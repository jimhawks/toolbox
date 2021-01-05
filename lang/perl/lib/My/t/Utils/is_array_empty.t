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
   is_array_empty
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my @arr = ();

# empty array
@arr = ();
is( is_array_empty( @arr ),  1, "empty array" );

# 1 item array
@arr = ( "a" );
is( is_array_empty( @arr ),  0, "1 item array" );

# 2+ item array
@arr = ( "a", "b", "c" );
is( is_array_empty( @arr ),  0, "2+ item array" );


done_testing();

exit 0;
