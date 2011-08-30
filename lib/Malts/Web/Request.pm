package Malts::Web::Request;
use strict;
use warnings;
use parent 'Plack::Request';

1;
__END__

=encoding utf8

=head1 NAME

Malts::Web::Request - Malts用のRequestクラス

=head1 SYNOPSIS

    use Malts::Web::Request;
    my $env = {PATH_INFO => '/'};
    my $req = Malts::Web::Request->new($env);
    $req->path_info;

=head1 DESCRIPTION

このモジュールは、L<Plack::Request>を継承している。

=head1 SEE ALSO

L<Plack::Request>

=cut
