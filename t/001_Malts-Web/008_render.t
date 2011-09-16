#!perl -w
use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/lib";
use TestApp::Web;
use Test::More;
use Encode qw(encode_utf8);
use Text::Xslate;

subtest 'testing render' => sub {
    my $res = render('ascii');
    is_deeply $res->body, ['ascii'];
};

subtest 'testing encoded str' => sub {
    my $res = render('日本語');
    is_deeply $res->body, [encode_utf8 '日本語'];
};

subtest 'testing content_type' => sub {
    my $res = render('ok', html_content_type => 'text/html; charset=UTF-8');
    is $res->headers->{'content-type'}, 'text/html; charset=UTF-8';
};

sub render {
    my $text = shift;
    my $t = TestApp::Web->new(@_);
    $t->view(Text::Xslate->new(path => {file => $text}));
    my $res = $t->render('file');
    isa_ok $res, 'Malts::Web::Response', encode_utf8 "\$res(body: $text)";
    is $res->content_length, length($text), encode_utf8 "content_length == length($text)";
    return $res;
}

done_testing;
