package Malts::Web::CSRFDefender;
use strict;
use warnings;
use Malts::Util ();
use Log::Minimal qw(debugff croakff);
use Exporter 'import';

our @EXPORT_OK = qw(csrf_token validate_csrf_token);
our $SESSION_NAME = 'csrf_token';
our $PARAM_NAME   = 'csrf_token';
our $RANDOM_STRING_SIZE = 16;

sub csrf_token {
    my $c = shift;
    my $req = $c->request or croakff 'Cannot find request object.';

    if (my $token = $req->session->get($SESSION_NAME)) {
        Malts::Util::DEBUG && debugff 'get session: %s', $token;
        return $token;
    }
    else {
        my $token = _random_string($RANDOM_STRING_SIZE);

        Malts::Util::DEBUG && debugff 'set session: %s', $token;
        $req->session->set($SESSION_NAME => $token);
        return $token;
    }
}

sub validate_csrf_token {
    my $c = shift;
    my $req = $c->request or croakff 'Cannot find request object.';

    if ($req->method && $req->method eq 'POST') {
        my $param_token   = $req->param($PARAM_NAME);
        my $session_token = $req->session->get($SESSION_NAME);

        if (!$param_token || !$session_token || ($param_token ne $session_token)) {
            return 0; # bad
        }
    }
    return 1; # good
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

=encoding utf8

=head1 NAME

Malts::Web::CSRFDefender - Malts用のCSRF Defender

=head1 SYNOPSIS

    package MyApp::CSRF::Web;
    use Malts::Web::CSRFDefender qw(csrf_token validate_csrf_token);

    sub startup {
        my $c = shift;
        unless ($c->validate_csrf_token) {
            ...;
        }
        $c->csrf_token;
    }

=head1 DESCRIPTION

=head1 METHODS

=head2 C<< $c->csrf_token -> Str >>

    $c->csrf_token;

=head2 C<< $c->validate_csrf_token() -> Bool >>

=head1 BASE CODE

L<Amon2::Plugin::Web::CSRFDefender> by tokuhirom

=head1 SEE ALSO

L<Amon2::Plugin::Web::CSRFDefender>

=cut
