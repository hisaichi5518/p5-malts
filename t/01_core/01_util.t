use strict;
use warnings;
use Test::More;
use Malts::Util;

subtest 'find_encoding' => sub {
    isa_ok Malts::Util::find_encoding('utf-8'), 'Encode::utf8';
};

subtest 'find_encoding error' => sub {
    eval { Malts::Util::find_encoding('hisaichi5518') };
    ok $@;
};

subtest 'is_binary' => sub {
    ok +Malts::Util::is_binary('.jpg');
    ok !+Malts::Util::is_binary('.txt');
};

subtest 'remove_error_line' => sub {
    my $message;

    $message = Malts::Util::remove_error_line('Died at -e line 1.');
    is $message, 'Died';

    $message = Malts::Util::remove_error_line("Died at -e line 1.\n");
    is $message, 'Died';

    $message = Malts::Util::remove_error_line(<<'...');
Died at lib/Malts.pm line 1.
Malts::Test::apptest('Malts::Web::Response(0x7f9b32b74330)', '200', 'HASH(0x7f9b32b74330)') called at lib/Malts/App.pm line 334
...
    is $message, 'Died';
};

done_testing;
