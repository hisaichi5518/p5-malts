package Malts::Setup::Flavor::Default;
use strict;
use warnings;

sub distribution {
    return <<'__DIST__';
@@ .maltsconfig
{
    app_name => '<:: $module.name ::>',
    template_name => 'Default',
    tags => {
        controller => {
                files => [
                    'lib/<:: $module.name ::>/Web/Controller/Root.pm',
                ],

                module_path => qr/Root/,
                module_name => qr/Root/,
        },
    },
}

@@ .proverc
--exec "perl -Ilib -MTest::Name::FromLine -MTest::Flatten"
--color
--timer
-w

@@ app.psgi
use strict;
use warnings;

use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Plack::Builder;
use <:: $module.name ::>::Web;

builder {
    <:: $module.name ::>::Web->to_app;
};

@@ Makefile.PL
use strict;
use warnings;
BEGIN {
    unshift @INC, 'inc';

    # author requires, or bundled modules
    my @devmods = qw(
        inc::Module::Install             1.00
        Module::Install::AuthorTests     0.002
        Malts                            0.05
    );
    my @not_available;
    while(my($mod, $ver) = splice @devmods, 0, 2) {
        eval qq{use $mod $ver (); 1} or push @not_available, $mod;
    }
    if(@not_available) {
        print qq{# The following modules are not available.\n};
        print qq{# `perl $0 | cpanm` will install them:\n};
        print $_, "\n" for @not_available;
        exit 1;
     }
}
use inc::Module::Install;

all_from 'lib/<:: $module.name ::>.pm';

test_requires 'Test::More'     => 0.96;
test_requires 'Test::Requires' => 0.06;

tests_recursive;
author_tests 'xt';

clean_files qw(
    <:: $module.name ::>-*
    *.stackdump
    cover_db *.gcov *.gcda *.gcno
    nytprof
    *.out
);

# SEE http://blog.64p.org/entry/20110928/1317193393
sub MY::test_via_harness {
        "\tprove -r t"
}
sub MY::top_targets {
        <<"..."
all ::
\t
pure_all ::
\t
subdirs ::
\t
config ::
\t
...
}

WriteAll(check_nmake => 0);

@@ lib/<:: $module.path ::>.pm
package <:: $module.name ::>;
use strict;
use warnings;
our $VERSION = '0.01';

1;

@@ t/00_compile.t
use strict;
use warnings;
use utf8;

use Test::More;

BEGIN {
    use_ok qw/
        <:: $module.name ::>
        <:: $module.name ::>::Web
        <:: $module.name ::>::Web::Dispatcher
        <:: $module.name ::>::Web::Controller::Root
    /;
};

done_testing;

@@ t/Util.pm
package t::Util;
use strict;
use warnings;
use Exporter 'import';

use Carp ();
use Plack::Util ();
use Malts::Test ();
use Test::More;
use File::Spec;
use FIle::Basename qw/basedir/;

our @EXPORT = qw/test_app/;

sub test_app (&) {
    my ($client) = @_;
    Carp::croak("Can't find client.") if !$client;

    Malts::Test::test_app(
        app => Plack::Util::load_psgi(
            File::Spec->catfile(basedir(__FILE__), '..', 'app.psgi')
        ),
        app_name => '<:: $module.name ::>',
        impl     => 'MockHTTP',
        client   => $client,
    );
}

1;

@@ xt/perlcritic.t
use strict;
use warnings;
use Test::More;

eval q{
    use Perl::Critic 1.105;
    use Test::Perl::Critic -profile => \do { local $/; <DATA> };
};
plan skip_all => "Test::Perl::Critic is not available." if $@;

all_critic_ok('lib');
__DATA__

exclude=ProhibitStringyEval ProhibitExplicitReturnUndef RequireBarewordIncludes

[TestingAndDebugging::ProhibitNoStrict]
allow=refs

[TestingAndDebugging::RequireUseStrict]
equivalent_modules = Mouse Mouse::Role Mouse::Exporter Mouse::Util Mouse::Util::TypeConstraints Moose Moose::Role Moose::Exporter Moose::Util::TypeConstraints Any::Moose

[TestingAndDebugging::RequireUseWarnings]
equivalent_modules = Mouse Mouse::Role Mouse::Exporter Mouse::Util Mouse::Util::TypeConstraints Moose Moose::Role Moose::Exporter Moose::Util::TypeConstraints Any::Moose

@@ lib/<:: $module.path ::>/Web.pm
package <:: $module.name ::>::Web;
use 5.10.1;
use strict;
use warnings;
use parent 'Malts';

use Text::Xslate;

sub view {
    my $self = shift;
    state $view = Text::Xslate->new(
        path => [File::Spec->catdir($self->app->base_dir, 'templates')],
    );
}


1;

@@ templates/layout/base.tx
<!DOCTYPE html>
<html>
  <head><title><: $title :></title></head>
  <body><: block content -> {} :></body>
</html>

@@ templates/root/index.tx
: cascade layout::base {title => 'トップページ'}

: around content -> {
<p>Hello World!<p>
: }

@@ lib/<:: $module.path ::>/Web/Dispatcher.pm
package <:: $module.name ::>::Web::Dispatcher;
use strict;
use warnings;
use Malts::Web::Router::Simple;

get '/' => 'Root#index';

1;

@@ lib/<:: $module.path ::>/Web/Controller/Root.pm
package <:: $module.name ::>::Web::Controller::Root;
use strict;
use warnings;

sub index {
    my ($self, $c) = @_;

    $c->render(200, 'root/index.tx');
}

1;

__DIST__
}

1;
__END__

=head1 METHODS

=head2 C<< $class->distribution >>

=cut
