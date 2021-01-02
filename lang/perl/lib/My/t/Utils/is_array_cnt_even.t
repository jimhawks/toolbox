#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   is_array_cnt_even
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

# array is odd
is( is_array_cnt_even( 1 ), 0, "array, odd number" );

# array is even
is( is_array_cnt_even( 1, 2 ), 1, "array, even number" );

# hash passed
my %hash = ( k1 => "v1", k2 => "v2" );
is( is_array_cnt_even( %hash ), 1, "hash" );


done_testing();

exit 0;
