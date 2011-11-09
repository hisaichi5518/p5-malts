#!perl -w
use strict;
use warnings;

use FindBin;
use Test::More;
use Plack::Util;

my $dir_path = "$FindBin::Bin/../../eg/hello-scripts";

subtest "testing $dir_path/app.psgi" => sub {
    is_200('app.psgi', {PATH_INFO => '/', REQUEST_METHOD => 'GET'}, qr/DICE:/);
};

subtest "testing $dir_path/hello.psgi" => sub {
    is_200('hello.psgi', {PATH_INFO => '/', REQUEST_METHOD => 'GET'}, qr/Hello Malts/);
};

subtest "testing $dir_path/render.psgi" => sub {
   is_200('render.psgi', {PATH_INFO => '/', REQUEST_METHOD => 'GET'}, qr/Hello Xslate World!/);
};

subtest "testing $dir_path/routes.psgi" => sub {
    is_200('routes.psgi', {PATH_INFO => '/', REQUEST_METHOD => 'GET'}, qr/Hello Router::Simple World/);
};

sub psgi_app {
    my ($script, $env) = @_;
    my $app = Plack::Util::load_psgi("$dir_path/$script");
    $app->($env);
}

sub is_200 {
    my ($script, $env, $text) = @_;
    my $psgi = psgi_app($script, $env);
    is $psgi->[0], 200;
    like $psgi->[2]->[0], $text;
}

done_testing;
