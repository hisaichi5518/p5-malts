package Malts::Web::View::Util;
use strict;
use warnings;
use Exporter 'import';
use Malts ();

our @EXPORT = qw/config flash session param uri_for args app_dir csrf_token/;

sub config {
    my $c = Malts->context;
    return $c->config(@_);
}

sub session {
    my $c = Malts->context;
    return $c->req->session(@_);
}

sub param {
    my $c = Malts->context;
    return $c->req->param(@_);
}

sub uri_for {
    my $c = Malts->context;
    return $c->uri_for(@_);
}

sub args {
    my $c = Malts->context;
    return $c->req->args(@_);
}

sub flash {
    my $c = Malts->context;
    return $c->flash(@_);
}

sub csrf_token {
    my $c = Malts->context;
    return $c->csrf_token(@_);
}

1;
__END__

=head1 NAME

Malts::Web::View::Util - view utilities

=head1 SYNOPSIS

    # Xslateでの例
    use Text::Xslate;
    use Malts::Web::View::Util;

    my $tx = Text::Xslate->new(
        module => [
            'Malts::Web::View::Util',
            'MyApp::Web::View::Util',
        ],
    );

=head1 FUNCTIONS

=head2 C<< config() >>

=head2 C<< flash() >>

=head2 C<< session() >>

=head2 C<< param() >>

=head2 C<< uri_for() >>

=head2 C<< args() >>

=head2 C<< csrf_token() >>

=head1 SEE ALSO

L<Text::Xslate>

=cut
