#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   isNonEmpty
);

# values
is( isNonEmpty(undef), 0, "undef");
is( isNonEmpty(""),    0, "empty string");
is( isNonEmpty("a"),   1, "single char");
is( isNonEmpty("abc"), 1, "nonempty string");
is( isNonEmpty(0),     1, "zero");
is( isNonEmpty(4),     1, "single digit int");
is( isNonEmpty(123),   1, "multi digit int");
is( isNonEmpty(12.3),  1, "float");

# hash refs
my %empty_hash    = ();
my %nonempty_hash = ( k1 => "v1", k2 => "v2" );
is( isNonEmpty(\%empty_hash),     1, "empty hash");
is( isNonEmpty(\%nonempty_hash),  1, "nonempty hash");

# array refs
my %empty_array    = ();
my %nonempty_array = ( "v1", "v2" );
is( isNonEmpty(\%empty_array),     1, "empty array");
is( isNonEmpty(\%nonempty_array),  1, "nonempty array");

done_testing();

exit 0;
