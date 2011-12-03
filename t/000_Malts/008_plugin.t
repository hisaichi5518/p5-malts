#!perl -w
package Malts::Plugin::Test;
use strict;
use warnings;

# HACK for Plack::Util::load_class
$INC{'Malts/Plugin/Test.pm'} = __FILE__;

sub init {
    my ($self, $c, $opts) = @_;
    $c->{done_plugin} = 'ok';
    if ($opts->{hoge}) {
        $c->{hoge} = 1;
    }
}

package main;
use strict;
use Test::More;
use Malts;

subtest 'testing plugin' => sub {
    my $c = Malts->new;
    $c->plugin('Test');
    is $c->{done_plugin}, 'ok';
};

subtest 'testing plugin opts' => sub {
    my $c = Malts->new;
    $c->plugin('Test' => {hoge => 1});
    is $c->{hoge}, 1;
};

subtest 'testing error' => sub {
    my $c = Malts->new;
    eval{ $c->plugin };
    ok $@;
};

done_testing;
