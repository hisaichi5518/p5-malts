#!perl -w
use strict;
use Test::More;
use Malts::Hook;

subtest 'register hook' => sub {
    ok hook->set('run_test' => sub {
        my ($array) = @_;
        push @$array, 1;
    });

    ok hook->set('run_test' => sub {
        my ($array) = @_;
        push @$array, 2;
    });
};

subtest 'get hooks' => sub {
    my $hook_codes = hook->get('run_test');
    is ref $hook_codes, 'ARRAY';
    is scalar(@$hook_codes), 2;
};

subtest 'run hooks' => sub {
    my $array = [];
    hook->run('run_test', $array);
    is_deeply $array, [1, 2];
};

subtest 'reset hooks' => sub {
    ok hook->reset('run_test');
    is_deeply hook->get('run_test'), undef;
};

subtest 'reset all hooks' => sub {
    ok hook->set('run_test' => sub {});
    ok hook->set('run_test' => sub {});

    ok hook->reset_all;
    is_deeply hook->hooks, {};
};

done_testing;
