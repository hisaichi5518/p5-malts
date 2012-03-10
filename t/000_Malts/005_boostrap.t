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
use Malts;

subtest 'testing boostrap' => sub {
    my $c = MyApp->boostrap;
    isa_ok $c, 'MyApp';
    isa_ok $c, 'Malts';
    is $c->{test}, 1;
    $c->{test} = 2;
    is $c->{test}, 2;
};

subtest 'has context' => sub {
    my $c = Malts->context;
    is $c->{test}, 2;
};

subtest 'clear cached context' => sub {
    my $c = MyApp->boostrap;
    $c = Malts->context;
    is $c->{test}, 1;
};

done_testing;
