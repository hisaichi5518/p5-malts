#!perl -w
use strict;
use warnings;

use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp;

subtest 'testing router' => sub {
    new_ok('TestApp::Web');
};

subtest 'testing dispatch. return Status: 200' => sub {
    my $psgi_app = psgi_app({PATH_INFO => '/', REQUEST_METHOD => 'GET'});
    is $psgi_app->[0], 200;
    is_deeply $psgi_app->[2], ['index!'];
};

subtest 'testing dispatch. return Status: 404' => sub {
    is_404({PATH_INFO => '/404', REQUEST_METHOD => 'GET'});
    is_404({PATH_INFO => '/', REQUEST_METHOD => 'POST'});
    is_404({PATH_INFO => '/'});
    is_404({PATH_INFO => '/500', REQUEST_METHOD => 'GET'});
};

sub psgi_app {
    my $env = shift;
    my $t = TestApp::Web->to_app;
    $t->($env);
}

sub is_404 {
    my $env = shift;
    my $psgi_app = psgi_app($env);
    my $message  = error_message($env);
    is $psgi_app->[0], 404, $message;
    is_deeply $psgi_app->[2], ['404 Not Found!'], $message;
}

sub is_200 {}

sub is_error {
    my $env = shift;
    eval{ psgi_app($env) };
    ok $@, error_message($env);
}

sub error_message {
    my $env = shift;
    "PATH_INFO: @{[$env->{PATH_INFO} || '']}, REQUEST_METHOD: @{[$env->{REQUEST_METHOD} || '']}";
}

done_testing;
