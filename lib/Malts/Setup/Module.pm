package Malts::Setup::Module;
use strict;
use warnings;
use Text::Xslate;

sub new {
    my ($class, %args) = @_;
    die "!! Can't find module name." if !$args{name};

    bless {
        name => $args{name},
    }, $class;
}

sub name { shift->{name} }

sub path {
    my ($self) = @_;
    return $self->{path} if $self->{path};

    my $path = $self->name;
    $path =~ s/::/\//g;

    $self->{path} = $path;
}

sub dist {
    my ($self) = @_;
    return $self->{dist} if $self->{dist};

    my $dist = $self->name;
    $dist =~ s/::/-/g;

    $self->{dist} = $dist;
}

sub build_template_files {
    my ($self, $template_files) = @_;

    my $view = Text::Xslate->new(
        path => {
            %{$template_files},
            map {
                $self->dist."/".$_ => $_
            } keys %$template_files,
        },
        line_start => '::',
        tag_start  => '<::',
        tag_end    => '::>',
        type       => 'text',
        suffix     => '',
    );

    my $files = {};
    for my $file_name (keys %$template_files) {
        my $file_body = $template_files->{$file_name};
        my $file_path = $self->dist.'/'.$file_name;

        $files->{$view->render($file_path, {module => $self})}
            = $view->render($file_name, {module => $self});
    }

    return $files;
}

1;
__END__

=head1 METHODS

=head2 C<< $class->new(%args) >>

=head2 C<< $self->name >>

=head2 C<< $self->template >>

=head2 C<< $self->path >>

=head2 C<< $self->dist >>

=head2 C<< $self->build_template_files >>

=cut
