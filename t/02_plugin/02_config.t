use strict;
use warnings;
use Test::More;


my $app = do {
    package MaltsPlugin::ConfigLoader;
    use parent 'Malts';
    use Malts::ConfigLoader;
    use FindBin;

    sub config {
        my ($self) = @_;
        local $INC{(join '/', split '::', __PACKAGE__).'.pm'} = $FindBin::Bin;

        my @args = ($self->app->base_dir, 'config.pl');
        Malts::ConfigLoader->load(@args);
    }
};

subtest 'testing config_loader' => sub {
    my $c = MaltsPlugin::ConfigLoader->boostrap;
    my $config = {config => 'loaded'};
    is_deeply $c->config, $config;
};

done_testing;
