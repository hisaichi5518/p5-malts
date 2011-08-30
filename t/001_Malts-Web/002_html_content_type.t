#!perl -w
use strict;
use Test::More;

use Malts::Web;

note 'testing html_content_type';
my $malts = Malts::Web->new;
is $malts->html_content_type, 'text/html; charset=UTF-8';

done_testing;
