#!perl -w
use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";

BEGIN { use_ok 'TestApp' };

subtest 'testing router' => sub {
    new_ok('TestApp::Web');
};

subtest 'testing dispatch. return Status: 200' => sub {
    is_200({PATH_INFO => '/get', REQUEST_METHOD => 'GET'});
    is_200({PATH_INFO => '/get', REQUEST_METHOD => 'HEAD'});
    is_200({PATH_INFO => '/post', REQUEST_METHOD => 'POST'});
    is_200({PATH_INFO => '/put', REQUEST_METHOD => 'PUT'});
    is_200({PATH_INFO => '/del', REQUEST_METHOD => 'DELETE'});

    is_200({PATH_INFO => '/code', REQUEST_METHOD => 'GET'});
    is_200({PATH_INFO => '/submapper/name', REQUEST_METHOD => 'GET'});
};

subtest 'testing dispatch. return Status: 404' => sub {
    is_404({PATH_INFO => '/404', REQUEST_METHOD => 'GET'});
    is_404({PATH_INFO => '/', REQUEST_METHOD => 'POST'});
    is_404({PATH_INFO => '/'});
    is_404({PATH_INFO => '/500', REQUEST_METHOD => 'GET'});
};

sub is_404 {
    my $env = shift;
    my $res = run_app($env);
    my $message = error_message($env);
    is $res->[0], 404, $message;
    is_deeply $res->[2], ['404 Not Found!'], $message;
}

sub is_200 {
    my $env = shift;
    my $res = run_app($env);
    my $message  = error_message($env);
    is $res->[0], 200, $message;
    is_deeply $res->[2], ['index!'], $message;
}

sub run_app {
    my $env = shift;
    my $t = TestApp::Web->to_app;
    $t->($env);
}

sub error_message {
    my $env = shift;
    "PATH_INFO: @{[$env->{PATH_INFO} || '']}, REQUEST_METHOD: @{[$env->{REQUEST_METHOD} || '']}";
}

done_testing;
