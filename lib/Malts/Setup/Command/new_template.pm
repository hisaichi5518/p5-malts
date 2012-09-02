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

    my @data_sections;
    dir($base_dir)->recurse(
        callback => sub {
            my $file = shift;
            return unless -f $file;

            push @data_sections, $class->_data_section_single($file, $base_dir);
        }
    );
    my $data_section = join "\n", @data_sections;

    my $file_content = <<"...";
package $module;
use strict;
use warnings;

sub distribution {
    return <<'__DIST__';
$data_section
__DIST__
}

1;
__END__

=head1 METHODS

=head2 C<< \$class->distribution >>

=cut
...

    my $file_name = $module;
    $file_name =~ s/^.*:://;
    $file_name .= '.pm';
    $class->create_files({$file_name => $file_content});
}

sub _data_section_single {
    my ($class, $file, $base_dir) = @_;

    my $file_path = $file->relative($base_dir);
    $file_path =~ s/MyApp/<:: \$module.path ::>/g;

    my $data_section = '@@ '. $file_path ."\n";
    my $content = $file->slurp;
    if (Malts::Util::is_binary($file)) {
        $content = encode_base64($content);
    }

    $content =~ s/MyApp/<:: \$module.name ::>/g;
    $data_section .= $content;
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
