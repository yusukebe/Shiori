package Shiori::DB::Schema;
use Teng::Schema::Declare;
use DateTime::Format::MySQL;

table {
    name 'bookmark';
    pk 'id';
    columns qw/id url created_at updated_at/;
    inflate qr/.+_at/ => sub {
        my $value = shift;
        return DateTime::Format::MySQL->parse_datetime($value);
    };
    deflate qr/.+_at/ => sub {
        my $value = shift;
        return DateTime::Format::MySQL->format_datetime($value);
    };
};

1;
