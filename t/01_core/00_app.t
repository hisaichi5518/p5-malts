use strict;
use warnings;
use Test::More;
use Malts::App;
use File::Spec;

subtest 'new' => sub {
    my $app = Malts::App->new(name => 'MyApp');
    isa_ok $app, 'Malts::App';
    is $app->name, 'MyApp';
};

subtest 'set app?' => sub {
    my $app = Malts::App->set_running_app('MyApp');
    is_deeply $app, Malts::App->current;
    is_deeply $app, Malts::App->get('MyApp');
};

subtest 'base_dir with lib/MyApp.pm' => sub {
    local $INC{'MyApp.pm'} = '/home/user_name/lib/MyApp.pm';

    my $app = Malts::App->new(name => 'MyApp');
    is $app->base_dir, File::Spec->rel2abs('/home/user_name');
};

subtest 'base_dir with blib/lib/MyApp.pm' => sub {
    local $INC{'MyApp.pm'} = '/home/user_name/blib/lib/MyApp.pm';

    my $app = Malts::App->new(name => 'MyApp');
    is $app->base_dir, File::Spec->rel2abs('/home/user_name');
};

subtest 'base_dir no $INC{"MyApp.pm"}' => sub {
    my $app = Malts::App->new(name => 'MyApp');
    is $app->base_dir, File::Spec->rel2abs('./');
};

done_testing;
