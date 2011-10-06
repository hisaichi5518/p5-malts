use strict;
use warnings;
BEGIN {
    unshift @INC, 'inc';

    # author requires, or bundled modules
    my @devmods = qw(
        inc::Module::Install             1.00
        Module::Install::AuthorTests     0.002
        Module::Install::Repository      0.06
        Test::Requires                   0.06
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

requires 'Encode';
requires 'Plack';
requires 'Data::Util';
requires 'Class::Method::Modifiers::Fast';
requires 'parent';
requires 'Text::Xslate' => 1.4001;
requires 'File::Spec';
requires 'Log::Minimal';
requires 'Plack::Middleware::Log::Minimal';

test_requires 'Test::More' => '0.96';

auto_set_repository if -e '.git';

tests_recursive;
author_tests 'xt';


clean_files qw(
    Malts-*
    *.stackdump
    cover_db *.gcov *.gcda *.gcno
    nytprof
    *.out
);

WriteAll(check_nmake => 0);
