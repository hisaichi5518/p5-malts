package Malts;
use 5.008_001;
use strict;
use warnings;

use Encode ();

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless {%args}, $class;
}

sub encoding {
    my ($self, $encoding) = @_;

    return $self->{encoding}
        if !$encoding && exists $self->{encoding};

    $self->{encoding} = Encode::find_encoding($encoding || 'utf8')
        or die "encoding '$encoding' not found";

    return $self->{encoding};
}

1;
__END__

=encoding utf8

=head1 NAME

Malts - 次世代 Web Application Framework

=head1 SYNOPSIS

    # TODO

=head1 DESCRIPTION

Malts is ...!

=head1 METHODS

=head2 C<new>

    MyApp->new;
    MyApp->new(mode => 'test');

アプリケーションのインスタンスを作成します。

=head2 C<encoding>

    $c->encoding;
    $c->encoding('utf8');
    $c->encoding('shift-jis');


渡した文字コードをEncode::find_encoding()したものが返される。

文字コードが存在しない場合はエラーを返す。

デフォルトは、utf8

B<変更は推奨されない>が、携帯サイトの場合はその限りではない。

=head1 SEE ALSO

L<Plack>, L<Amon2>, L<Mojolicious>

=head1 Repository

  http://github.com/hisaichi5518/p5-malts

=head1 AUTHOR

hisaichi5518 E<lt>info[at]moe-project.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, hisaichi5518. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
