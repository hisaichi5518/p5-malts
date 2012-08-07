package Malts::Web::Request;
use strict;
use warnings;
use parent 'Plack::Request';
use Plack::Session;
use Log::Minimal qw(croakff);

sub args {
    my $self = shift;
    $self->env->{'malts.routing_args'};
}

sub session {
    my $self = shift;
    return $self->{session} if $self->{session};

    for my $key (qw/psgix.session psgix.session.options/) {
        croakff('Cant find $req->env->{%s}. you must use Plack::Middleware::Session.', $key)
            if not exists $self->env->{$key};
    }

    $self->{session} = Plack::Session->new($self->env);
}


# baseはAmon2::Web::Request
sub body_parameters {
    my ($self) = @_;
    $self->{'malts.body_parameters'} ||=
        $self->_decode_parameters($self->SUPER::body_parameters());
}

sub query_parameters {
    my ($self) = @_;
    $self->{'malts.query_parameters'} ||=
        $self->_decode_parameters($self->SUPER::query_parameters());
}

sub parameters {
    my $self = shift;

    $self->env->{'malts.request.merged'} ||= do {
        my $query = $self->query_parameters;
        my $body  = $self->body_parameters;

        Hash::MultiValue->new($query->flatten, $body->flatten);
    };
}

sub body_parameters_raw {
    shift->SUPER::body_parameters();
}

sub query_parameters_raw {
    shift->SUPER::query_parameters();
}

sub parameters_raw {
    my $self = shift;

    $self->env->{'plack.request.merged'} ||= do {
        my $query = $self->SUPER::query_parameters();
        my $body  = $self->SUPER::body_parameters();

        Hash::MultiValue->new($query->flatten, $body->flatten);
    };
}

sub param_raw {
    my $self = shift;

    return keys %{ $self->parameters_raw } if @_ == 0;

    my $key = shift;
    return $self->parameters_raw->{$key} unless wantarray;
    return $self->parameters_raw->get_all($key);
}

sub _decode_parameters {
    my ($self, $stuff) = @_;
    my $encoding = Malts->context->encoding;
    my @flatten = $stuff->flatten;
    my @decoded;

    while (my ($k, $v) = splice @flatten, 0, 2) {
        push @decoded, $encoding->decode($k), $encoding->decode($v);
    }

    return Hash::MultiValue->new(@decoded);
}

# TODO: flashはどこに書こう, argsはどうしよう
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

L<Plack::Request>を継承している。

=head1 METHODS

=head2 C<< $req->args -> HashRef >>

    $req->args;

C<$env->{'malts.routing_args'}>を返す。

=head2 C<< $req->parameters() -> Object >>

    $req->parameters->{$key};

C<Plack::Request#parameters>とほぼ同じですが、L<Malts::Web::Request>特有のC<args>メソッドも含みます。

L<Hash::MultiValue>のオブジェクトを返します。

=head2 C<< $req->session() -> Object >>

    $req->session();

L<Plack::Session>のオブジェクトを返す。

またC<$env->{'psgix.session'}>, C<$env->{'psgix.session.options'}>がないとエラーを吐く。

これはL<Plack::Middleware::Session>を使用すれば避けられる。

=head1 SEE ALSO

L<Plack::Request>

=cut
