package Malts::Setup::Command;
use strict;
use warnings;
use Getopt::Long;
use File::Spec;
use Plack::MIME;
use Text::Xslate;
use File::Basename;
use File::Path ();
use Malts::Util ();
use MIME::Base64 ();

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub parse_options {
    my($class, @args) = @_;

    my @spec = $class->option_spec;
    my %opts;
    my $success = Getopt::Long::GetOptionsFromArray(\@args, \%opts, @spec);

    if(!$success) {
        $class->usage;
        return;
    }
    return(\%opts, @args);
}

sub option_spec {}
sub usage {}

sub create_files {
    my ($class, $files, $opts) = @_;

    my $dry_run = $opts->{dry_run};

    for my $file_name (keys %$files) {
        print "create the $file_name.\n";

        if (!$opts->{dry_run}) {
            my $dir = dirname($file_name);
            File::Path::mkpath($dir);

            open my $fh, '>:encoding(utf-8)', $file_name
                or die "Can't open $file_name: $!";

            my $content = $files->{$file_name};
            if (Malts::Util::is_binary($file_name)) {
                binmode($fh);
                $content = MIME::Base64::decode_base64($content);
            }

            print $fh $content;
            close $fh;
        }
    }
}

1;
__END__

=head1 METHODS

=head2 C<< $class->new(%args) >>

=head2 C<< $class->parse_options(@args) -> (\%opts, @args) >>

=head2 C<< $class->option_spec >>

=head2 C<< $class->usage >>

=head2 C<< $class->create_files(\%files, \%opts) >>

=cut
