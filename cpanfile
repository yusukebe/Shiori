requires 'Mojolicious';
requires 'Mouse';
requires 'FormValidator::Lite', '0.37';
requires 'DateTime';
requires 'DateTime::Format::MySQL';
requires 'DBI';
requires 'DBD::mysql';
requires 'Teng';
requires 'Config::PL';

test_requires 'Test::More';
test_requires 'Test::mysqld';
test_requires 'SQL::SplitStatement';
test_requires 'Path::Tiny';
