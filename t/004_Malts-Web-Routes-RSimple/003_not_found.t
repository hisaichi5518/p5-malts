#!perl -w
package TestApp::Web;
use strict;
use warnings;

use parent qw(Malts Malts::Web);

sub startup {
    my $self = shift;
    my $r = $self->routes('RSimple');
    $r->connect('/' => {});
}

package main;
use strict;
use warnings;

use Test::More;

subtest 'testing dispatch' => sub {
    my $t = TestApp::Web->to_app;
    my $psgi_app =  $t->({PATH_INFO => '/404'});
    is $psgi_app->[0], 404;
    is_deeply $psgi_app->[2], ['404 Not Found!'];
};

done_testing;
