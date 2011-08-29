#!perl -w
use strict;
use utf8;
use Test::More;
use Encode qw(encode_utf8);

use Malts;

my $malts = Malts->new;
{
    note 'testing ok';
    my $ok =  $malts->ok('ok');
    isa_ok $ok, 'Plack::Response';
    is_deeply $ok->body, ['ok'];
}
{
    note 'testing decoded string';
    my $ok = $malts->ok('こんにちは');
    is_deeply $ok->body, [encode_utf8 'こんにちは'];
}
{
    note 'testing return error if $decoed_html is required';
    eval { $malts->ok };
    ok $@;
}
done_testing;
