use strict;
use warnings;
BEGIN {
    unshift @INC, 'inc';

    # author requires, or bundled modules
    my @devmods = qw(
        inc::Module::Install             1.00
        Module::Install::AuthorTests     0.002
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

all_from 'lib/Malts.pm';

# parent, Plack
requires 'Encode'         => 2.44;
requires 'Text::Xslate'   => 1.5009;
requires 'Router::Simple' => 0.09;
requires 'Plack::Middleware::Session'      => 0.14;

test_requires 'Test::More'     => 0.96;
test_requires 'Test::Requires' => 0.06;

tests_recursive;
author_tests 'xt';
install_script 'script/malts';

clean_files qw(
    Malts-*
    *.stackdump
    cover_db *.gcov *.gcda *.gcno
    nytprof
    *.out
);

WriteAll(check_nmake => 0);
