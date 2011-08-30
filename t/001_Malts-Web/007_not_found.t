#!perl -w
use strict;
use utf8;
use Test::More;
use Encode qw(encode_utf8);

use Malts::Web;

my $malts = Malts::Web->new;
{
    note 'testing not_found';
    my $not_found = $malts->not_found;
    is ref $not_found, 'Malts::Web::Response';
    is_deeply $not_found->body, ['404 Not Found!'];
}
{
    note 'testing error_message';
    my $not_found = $malts->not_found('404!');
    is_deeply $not_found->body, ['404!'];

}
{
    note 'testing decodeed error_message';
    my $not_found = $malts->not_found('404だよ!');
    is_deeply $not_found->body, [encode_utf8 '404だよ!'];
}

done_testing;
