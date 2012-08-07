use strict;
use warnings;
use FindBin;
use Test::More;

my $app = do {
    package MaltsApp::Plugin::Test;
    my $count;
    sub init  { $count++ }
    sub count { $count   }

    package MaltsApp::Plugin;
    use parent qw(Malts);

    sub dispatch {
        $_[0]->add_hooks(before => sub {});
        $_[0]->render_string(200, 'ok');
    }

    __PACKAGE__->to_app;
};

subtest 'hooks' => sub {
    my $codes = MaltsApp::Plugin->get_hook_codes('before');
    is scalar(@$codes), 0;

    my $count = 0;
    MaltsApp::Plugin->add_hooks(
        before => sub { $count++ },
        after  => sub { ${$_[1]}++ },
    );

    $codes = MaltsApp::Plugin->get_hook_codes('before');
    is scalar(@$codes), 1;

    $codes = MaltsApp::Plugin->get_hook_codes('after');
    is scalar(@$codes), 1;

    is $count, 0;
    MaltsApp::Plugin->run_hooks('before');
    is $count, 1;
    MaltsApp::Plugin->run_hooks('after', \$count);
    is $count, 2;

    my $c = MaltsApp::Plugin->new;
    $c->add_hooks(before => sub{});
    $codes = $c->get_hook_codes('before');
    is scalar(@$codes), 2;

    $codes = MaltsApp::Plugin->get_hook_codes('before');
    is scalar(@$codes), 1;

};

subtest 'add_method' => sub {
    ok !MaltsApp::Plugin->can('test');
    MaltsApp::Plugin->add_method(test => sub {});
    can_ok 'MaltsApp::Plugin', 'test';
};

subtest 'load_plugins' => sub {
    local $INC{(join '/', split '::', 'MaltsApp::Plugin::Test').'.pm'} = 1;

    MaltsApp::Plugin->load_plugins(
        '+MaltsApp::Plugin::Test',
        '+MaltsApp::Plugin::Test' => {},
        '+MaltsApp::Plugin::Test',
        '+MaltsApp::Plugin::Test' => {},
        '+MaltsApp::Plugin::Test',
    );
    is +MaltsApp::Plugin::Test->count, 5;
};

done_testing;
