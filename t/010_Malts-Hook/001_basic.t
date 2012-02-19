#!perl -w
use strict;
use Test::More;
use Malts::Hook;

subtest 'register hook' => sub {
    ok +Malts::Hook->set('run_test' => sub {
        my ($array) = @_;
        push @$array, 1;
    });

    ok +Malts::Hook->set('run_test' => sub {
        my ($array) = @_;
        push @$array, 2;
    });
};

subtest 'get hooks' => sub {
    my $hook_codes = Malts::Hook->get('run_test');
    is ref $hook_codes, 'ARRAY';
    is scalar(@$hook_codes), 2;
};

subtest 'run hooks' => sub {
    my $array = [];
    Malts::Hook->run('run_test', $array);
    is_deeply $array, [1, 2];
};

done_testing;
