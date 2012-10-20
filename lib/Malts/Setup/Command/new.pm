package Malts::Setup::Command::new;
use strict;
use warnings;
use parent 'Malts::Setup::Command';
use Malts::Setup::Module;
use Malts::Setup::Flavor;

sub run {
    my $class = shift;
    my ($opts, @args) = $class->parse_options(@_);
    my $config = $class->config;

    my $tag        = $opts->{tag}        or die "!! Can't find --tag.";
    my $app_name   = $config->{app_name} or die "!! Can't find app_name in .maltsconfig.";
    my $tag_config = $config->{tags}->{$opts->{tag}}
        or die "!! Can't find tags.@{[$opts->{tag}]} in .maltsconfig.";

    my $flavor = Malts::Setup::Flavor->new(
        name => $args[1] || $config->{template_name},
    );
    my $module = Malts::Setup::Module->new(
        name => $config->{app_name},
    );

    my $files = $module->build_files($flavor->files);

    my $tagged_files = {};
    for my $template_name (keys %{$files}) {
        next if !($template_name ~~ $tag_config->{files});

        my $body = $files->{$template_name};

        if (my $module_path = $tag_config->{module_path}) {
            $template_name =~ s/$module_path/<:: \$module.path ::>/g;
        }
        if (my $module_camelized_path = $tag_config->{module_camelized_path}) {
            $template_name =~ s/$module_camelized_path/<:: \$module.camelized_path ::>/g;
        }

        if (my $module_name = $tag_config->{module_name}) {
            $body =~ s/$module_name/<:: \$module.name ::>/g;
        }
        if (my $module_camelized_name = $tag_config->{module_camelized_name}) {
            $body =~ s/$module_camelized_name/<:: \$module.camelized_name ::>/g;
        }

        $tagged_files->{$template_name} = $body;
    }

    $module = Malts::Setup::Module->new(
        name => $args[0],
    );

    $files = $module->build_files($tagged_files);

    $class->create_files($files, {
        dry_run => $opts->{'dry-run'},
    });



}

sub option_spec {
    qw/tag=s dry-run/;
}

1;
__END__

=head1 METHODS

=head2 C<< $class->run >>

=head2 C<< $class->option_spec >>

=cut
