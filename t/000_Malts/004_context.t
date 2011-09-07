#!perl -w
use strict;
use Test::More;

use Malts;

{
    note 'testing default context';
    ok !Malts->context;
}
{
    note 'testing set context';
    my $malts = Malts->new;
    ok !Malts->context;
    ok !!Malts->set_context($malts);
    ok !!Malts->context;
}
{
    note 'testing has context';
    ok !!Malts->context;
}

done_testing;
