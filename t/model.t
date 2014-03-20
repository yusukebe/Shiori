use strict;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use DBI;
use SQL::SplitStatement;
use Path::Tiny;
use Test::mysqld;
use Shiori::Model::Bookmark;

subtest 'bookmark' => sub {
    my $mysqld = Test::mysqld->new(
        my_cnf => {
            'skip-networking' => '',
        }
    ) or die $Test::mysqld::errstr;
    my $dbh = DBI->connect( $mysqld->dsn, 'root', undef );
    my $schema_file = path( 'etc', 'shiori_schema.sql' );
    my $schema_sql  = $schema_file->slurp();
    my $initial_sql = <<"SQL";
USE test;
$schema_sql
SQL
    my $splitter = SQL::SplitStatement->new(
        keep_terminator      => 1,
        keep_comments        => 0,
        keep_empty_statement => 0,
    );
    for ( $splitter->split($initial_sql) ) {
        $dbh->do($_) or die( $dbh->errstr );
    }
    my $dsn = $mysqld->dsn();
    ok $dsn;

    my $model =
      Shiori::Model::Bookmark->new( connect_info => [ $dsn, 'root', undef ] );
    ok $model;
    my $res = $model->create( { url => 'htt://example.jp/' } );
    ok $res->{error};
    $res = $model->create( { url => 'http://example.jp/' } );
    ok $res->{success};
    isa_ok $res->{success}{bookmark}, 'Shiori::DB::Row::Bookmark';
    
    my ($entries, $pager) = $model->entries({ page => 1 , limit => 1 });
    ok $entries;
    isa_ok $pager, 'Data::Page::NoTotalEntries';
};

done_testing();
