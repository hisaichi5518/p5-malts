package Malts::Setup::Command::new_template;
use strict;
use warnings;
use parent 'Malts::Setup::Command';
use Path::Class;
use Malts::Util;
use MIME::Base64;
use Encode qw/decode_utf8/;

sub run {
    my $class = shift;
    my ($opts, @args) = $class->parse_options(@_);

    my $base_dir = $opts->{dir}    or die;
    my $module   = $opts->{module} or die;

    my @templates;
    dir($base_dir)->recurse(
        callback => sub {
            my $file = shift;
            return unless -f $file;

            push @templates, $class->_build_template($file, $base_dir);
        }
    );
    my $flavor = join "\n", @templates;

    my $file_content = <<"...";
package $module;
use strict;
use warnings;

sub build_files {
    my \$files = {};
$flavor
    return \$files;
}

1;
__END__

=head1 METHODS

=head2 C<< \$class->build_files >>

=cut
...

    my $file_name = $module;
    $file_name =~ s/^.*:://;
    $file_name .= '.pm';
    $class->create_files({$file_name => $file_content});
}

sub _build_template {
    my ($class, $file, $base_dir) = @_;

    my $file_path = $file->relative($base_dir);
    $file_path =~ s/MyApp/<:: \$module.path ::>/g;
    $file_path =~ s/my_app/<:: \$module.camelized_path ::>/g;

    my $data_section = '    $files->{\''. $file_path ."'} = <<'__TEMPLATE__';\n";
    my $content = $file->slurp;
    if (Malts::Util::is_binary($file)) {
        $content = encode_base64($content);
    }

    $content =~ s/MyApp/<:: \$module.name ::>/g;
    $content =~ s/my_app/<:: \$module.camelized_name ::>/g;

    $data_section .= $content."\n";
    $data_section .= '__TEMPLATE__';

    return decode_utf8 $data_section;
}

sub option_spec {
    return qw(
        module=s
        dir=s
    );
}

1;
__END__

=head1 METHODS

=head2 C<< $class->run >>

=head2 C<< $class->option_spec >>

=cut
