package Malts::Web::Request::CSRFDefender;
use strict;
use warnings;
use Malts::Util ();

our $SESSION_NAME = 'csrf_token';
our $PARAM_NAME   = 'csrf_token';
our $RANDOM_STRING_SIZE = 16;

sub Malts::Web::Request::csrf_token {
    my $req = shift;

    if (my $token = $req->session->get($SESSION_NAME)) {
        return $token;
    }
    else {
        my $token = _random_string($RANDOM_STRING_SIZE);
        $req->session->set($SESSION_NAME => $token);
        return $token;
    }
}

sub Malts::Web::Request::validate_csrf {
    my $req = shift;

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

Malts::Web::Request - Malts用のRequestクラス

=head1 SYNOPSIS

    use Malts::Web::Request;
    use Malts::Web::Request::CSRFDefender;
    my $env = {
        PATH_INFO => '/',
        'psgix.session' => {csrf_token => 'hogehoge'},
        'psgix.session.options' => {},
    };
    my $req = Malts::Web::Request->new($env);
    $req->csrf_token; # hogehoge

=head1 DESCRIPTION

L<Malts::Web::Request>拡張モジュールです。

=head1 METHODS

以下のメソッドをL<Malts::Web::Request>に生やします。

=head2 C<< $req->csrf_token -> Str >>

    $req->csrf_token;

=head2 C<< $req->validate_csrf() -> Bool >>

=head1 BASE CODE

L<Amon2::Plugin::Web::CSRFDefender> by tokuhirom

=head1 SEE ALSO

L<Plack::Request>, L<Amon2::Plugin::Web::CSRFDefender>

=cut
