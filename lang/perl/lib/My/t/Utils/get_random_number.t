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
   get_random_number
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

srand( 34 );

my $dir = "";

# empty args
throws_ok { get_random_number( ) } qr/missing args/, "empty args";

# 1 arg, max is negative
throws_ok { get_random_number( -6 ) } qr/Max is negative/, "1 arg, max is negative";

# 1 arg, max is 0
is( get_random_number( 0 ), 0, "1 arg, max is 0" );

# 1 arg, max > 0
is( get_random_number( 15 ), 12, "1 arg, max > 0" );

# 2 args, min is negative
throws_ok { get_random_number( -2, 7 ) } qr/Min is negative/, "2 args, min is negative";

# 2 args, max is negative
throws_ok { get_random_number( 3, -8 ) } qr/Max is negative/, "2 args, max is negative";

# 2 args, max < min
throws_ok { get_random_number( 14, 5 ) } qr/Max is less than min/, "2 args, max < min";

# 2 args, min = max
is( get_random_number(23, 23), 23, "2 args, min = max" );

# 2 args, min is 0
is( get_random_number(0, 27), 19, "2 args, min is 0" );

# 2 args, both min max are not 0
is( get_random_number(9, 40), 15, "2 args, both min max are not 0" );


done_testing();

exit 0;
