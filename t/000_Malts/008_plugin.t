#!perl -w
package Malts::Plugin::Test;
use strict;
use warnings;

# HACK for Plack::Util::load_class
$INC{'Malts/Plugin/Test.pm'} = __FILE__;

sub init {
    my ($self, $c, $opts) = @_;
    $c->{done_plugin} = 'ok';
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

done_testing;
