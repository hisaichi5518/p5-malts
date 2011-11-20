#!perl -w
use strict;
use Test::More;

use Malts::Web::Request;
use Malts::Web::Request::CSRFDefender;

subtest 'testing get csrf_token' => sub {
    my $req = Malts::Web::Request->new({
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $req->csrf_token, 'hisaichi';
};

subtest 'return random string if can not get csrf_token' => sub {
    my $req = Malts::Web::Request->new({
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    is $req->csrf_token, "";
};

subtest 'testing session error' => sub {
    my $req = Malts::Web::Request->new({});
    eval { $req->csrf_token };
    ok $@;
};

subtest 'testing validate_csrf' => sub {
    my $req = Malts::Web::Request->new({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hisaichi',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $req->validate_csrf, 1;
};

subtest 'testing validate_csrf error' => sub {
    my $req = Malts::Web::Request->new({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hogehoge',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $req->validate_csrf, 0;

    $req = Malts::Web::Request->new({
        REQUEST_METHOD => 'POST',
        'psgix.session' => {csrf_token => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $req->validate_csrf, 0;

    $req = Malts::Web::Request->new({
        REQUEST_METHOD => 'POST',
        QUERY_STRING => 'csrf_token=hogehoge',
        'psgix.session' => {},
        'psgix.session.options' => {},
    });
    is $req->validate_csrf, 0;
};

subtest 'testing local var' => sub {
    local $Malts::Web::Request::CSRFDefender::SESSION_NAME = 'name';
    local $Malts::Web::Request::CSRFDefender::PARAM_NAME = 'name';
    my $req = Malts::Web::Request->new({
        QUERY_STRING => 'name=hisaichi',
        'psgix.session' => {name => 'hisaichi'},
        'psgix.session.options' => {},
    });
    is $req->validate_csrf, 1;
};

done_testing;

__END__

=pod

C<psgix.session>とC<psgix.session.options>は、sessionで使うため必須。

=cut
