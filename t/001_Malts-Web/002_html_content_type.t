#!perl -w
package TestApp;
use strict;
use warnings;
use parent 'Malts';

package TestApp::Web;
use strict;
use warnings;

use parent -norequire, 'TestApp';
use parent 'Malts::Web';
use Class::Method::Modifiers::Fast qw(after);

after startup => sub {
    my $self = shift;
    $self->ok('ok');
};

package main;
use strict;
use warnings;

use Test::More;

subtest 'testing html_content_type' => sub {
    my $t = TestApp::Web->new;
    ok !$t->html_content_type;
};

subtest 'testing html_content_type have string' => sub {
    # 初期設定でtext/html; charset=UTF-8がセットされる
    my $t = TestApp::Web->to_app;
    my $psgi_app =  $t->({});
    is_deeply $psgi_app->[1], ['Content-Length' => 2, 'Content-Type' => 'text/html; charset=UTF-8'];
};

done_testing;
