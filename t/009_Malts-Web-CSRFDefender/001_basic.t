#!perl -w
package MyApp::Web;
use strict;
use warnings;
use parent qw(Malts Malts::Web);
use Malts::Web::CSRFDefender qw(csrf_token validate_csrf_token);

package main;
use strict;
use Test::More;

sub request {
    my $env = shift;
    my $c = MyApp::Web->new;
    $c->create_request($env);
    return $c;
}

subtest 'testing get csrf_token' => sub {
    my $c = request({
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->csrf_token, 'hisaichi';
};

subtest 'return random string if can not get csrf_token' => sub {
    my $c = request({
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    is length($c->csrf_token), 16;
};

subtest 'testing session error' => sub {
    my $c = request({});
    eval { $c->csrf_token };
    ok $@;
};

subtest 'testing validate_csrf' => sub {
    my $c = request({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hisaichi',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 1;
};

subtest 'testing validate_csrf error' => sub {
    my $c = request({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hogehoge',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 0;

    $c = request({
        REQUEST_METHOD => 'POST',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 0;

    $c = request({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hogehoge',
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 0;
};

subtest 'testing local var' => sub {
    local $Malts::Web::CSRFDefender::SESSION_NAME = 'name';
    local $Malts::Web::CSRFDefender::PARAM_NAME = 'name';
    my $c = request({
        QUERY_STRING => 'name=hisaichi',
        'psgix.session' => {name => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $c->validate_csrf_token, 1;

    local $Malts::Web::CSRFDefender::RANDOM_STRING_SIZE = 32;
    $c = request({
        QUERY_STRING => 'name=hisaichi',
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    is length($c->csrf_token), 32;
};

done_testing;

__END__

=pod

C<psgix.session>とC<psgix.session.options>は、sessionで使うため必須。

=cut
