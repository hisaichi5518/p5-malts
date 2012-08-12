package Malts::Plugin::Web::CSRFDefender;
use strict;
use warnings;
use Malts::Util ();

our @EXPORT = qw(csrf_token validate_csrf_token);
our $SESSION_NAME = 'csrf_token';
our $PARAM_NAME   = 'csrf_token';
our $RANDOM_STRING_SIZE = 16;

sub init {
    my ($class, $c) = @_;

    $c->add_hooks(
        before_dispatch => \&_before_dispatch,
        html_filter     => \&_html_filter,
    );
    $c->add_method(
        csrf_token => \&_csrf_token,
    );
    $c->add_method(
        validate_csrf_token => \&_validate_csrf_token,
    );
}

sub _before_dispatch {
    my ($c, $res) = @_;

    if (!$c->validate_csrf_token) {
        my @err = (403, 'CSRF Session validation failed.');

        $$res = $c->render_string(@err);
    }
}

sub _html_filter {
    my ($c, $html) = @_;

    my $token = $c->csrf_token;
    $$html =~ s!(<form\s*.*?>)!$1\n<input type="hidden" name="$PARAM_NAME" value="$token" />!isg;
}

sub _csrf_token {
    my $c = shift;
    my $req = $c->request;

    if (my $token = $req->session->get($SESSION_NAME)) {
        return $token;
    }
    else {
        my $token = _random_string($RANDOM_STRING_SIZE);

        $req->session->set($SESSION_NAME => $token);
        return $token;
    }
}

sub _validate_csrf_token {
    my $c = shift;
    my $req = $c->request;

    if (_is_need_validated($req->method)) {
        my $param_token   = $req->param($PARAM_NAME);
        my $session_token = $req->session->get($SESSION_NAME);

        if (!$param_token || !$session_token || ($param_token ne $session_token)) {
            return 0; # bad
        }
    }
    return 1; # good
}

sub _is_need_validated {
    my ($method) = @_;
    return 0 if !$method;

    return
        $method eq 'POST'   ? 1 :
        $method eq 'PUT'    ? 1 :
        $method eq 'DELETE' ? 1 : 0;
}

sub _random_string {
    my $length = shift;
    my @chars = ('A'..'Z', 'a'..'z', '0'..'9', '$', '!');
    my $ret;
    for (1..$length) {
        $ret .= $chars[int rand @chars];
    }
    return $ret;
}

1;
__END__
