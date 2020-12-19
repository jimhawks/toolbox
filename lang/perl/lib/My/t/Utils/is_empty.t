#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   is_empty
);

# values
is( is_empty(undef), 1, "undef");
is( is_empty(""),    1, "empty string");
is( is_empty("a"),   0, "single char");
is( is_empty("abc"), 0, "nonempty string");
is( is_empty(0),     0, "zero");
is( is_empty(4),     0, "single digit int");
is( is_empty(123),   0, "multi digit int");
is( is_empty(12.3),  0, "float");

# hash refs
my %empty_hash    = ();
my %nonempty_hash = ( k1 => "v1", k2 => "v2" );
is( is_empty(\%empty_hash),     0, "empty hash");
is( is_empty(\%nonempty_hash),  0, "nonempty hash");

# array refs
my %empty_array    = ();
my %nonempty_array = ( "v1", "v2" );
is( is_empty(\%empty_array),     0, "empty array");
is( is_empty(\%nonempty_array),  0, "nonempty array");

done_testing();

exit 0;
