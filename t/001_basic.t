#!perl -w
use strict;
use Test::More;

use Malts;

my $malts = Malts->new;

note 'testing $malts isa Malts';
isa_ok $malts, 'Malts';
is $malts->html_content_type, 'text/html; charset=UTF-8';

done_testing;
