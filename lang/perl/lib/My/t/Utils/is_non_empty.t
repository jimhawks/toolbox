#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   is_non_empty
);

# values
is( is_non_empty(undef), 0, "undef");
is( is_non_empty(""),    0, "empty string");
is( is_non_empty("a"),   1, "single char");
is( is_non_empty("abc"), 1, "nonempty string");
is( is_non_empty(0),     1, "zero");
is( is_non_empty(4),     1, "single digit int");
is( is_non_empty(123),   1, "multi digit int");
is( is_non_empty(12.3),  1, "float");

# hash refs
my %empty_hash    = ();
my %nonempty_hash = ( k1 => "v1", k2 => "v2" );
is( is_non_empty(\%empty_hash),     1, "empty hash");
is( is_non_empty(\%nonempty_hash),  1, "nonempty hash");

# array refs
my %empty_array    = ();
my %nonempty_array = ( "v1", "v2" );
is( is_non_empty(\%empty_array),     1, "empty array");
is( is_non_empty(\%nonempty_array),  1, "nonempty array");

done_testing();

exit 0;
