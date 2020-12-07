
use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   isEmpty
);

# values
is( isEmpty(undef), 1, "undef");
is( isEmpty(""),    1, "empty string");
is( isEmpty("a"),   0, "single char");
is( isEmpty("abc"), 0, "nonempty string");
is( isEmpty(0),     0, "zero");
is( isEmpty(4),     0, "single digit int");
is( isEmpty(123),   0, "multi digit int");
is( isEmpty(12.3),  0, "float");

# hash refs
my %empty_hash    = ();
my %nonempty_hash = ( k1 => "v1", k2 => "v2" );
is( isEmpty(\%empty_hash),     0, "empty hash");
is( isEmpty(\%nonempty_hash),  0, "nonempty hash");

# array refs
my %empty_array    = ();
my %nonempty_array = ( "v1", "v2" );
is( isEmpty(\%empty_array),     0, "empty array");
is( isEmpty(\%nonempty_array),  0, "nonempty array");

done_testing();

exit 0;
