#!perl -w
use strict;

package MyApp;
use parent 'Malts';

sub startup {
    my ($c) = @_;
    $c->{test} = 1;
}

package main;
use Test::More;

subtest 'testing boostrap' => sub {
    my $c = MyApp->boostrap;
    isa_ok $c, 'MyApp';
    isa_ok $c, 'Malts';
    is $c->{test}, 1;
};

done_testing;
