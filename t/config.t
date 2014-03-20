use strict;
use Test::More;

BEGIN {
    use_ok('Shiori');
}

subtest 'load_config' => sub {
    $ENV{PLACK_ENV} = 'development';
    my $config = Shiori->config();
    ok $config;
    isa_ok $config, 'HASH';
};

done_testing();
