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
   is_item_in_array
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################


my $item = "";
my @arr  = ();
my @a1   = ();
my @a2   = ();
my @a3   = ();
my @a4   = ();

# no args
is( is_item_in_array(), 0, "no args" );

# 1 arg
$item = "s";
is( is_item_in_array( $item ), 0, "1 arg" );

# 2+ args
   # arr is same type
      # find num
         # found
$item = 2;
@arr  = ( 1, 2, 3, 4, 5 );
is( is_item_in_array( $item, @arr ), 1, "homog, find num, found" );

         # not found
$item = 99;
@arr  = ( 1, 2, 3, 4, 5 );
is( is_item_in_array( $item, @arr ), 0, "homog, find num, not found" );

      # find str
         # found
$item = "def";
@arr  = ( "abc", "def", "ghi" );
is( is_item_in_array( $item, @arr ), 1, "homog, find str, found" );

         # not found
$item = "str";
@arr  = ( "abc", "def", "ghi" );
is( is_item_in_array( $item, @arr ), 0, "homog, find str, not found" );

      # find ref
         # found
@a1 = ( 1 );
@a2 = ( 1 );
@a3 = ( 1 );
$item = \@a2;
@arr  = ( \@a1, \@a2, \@a3 );
is( is_item_in_array( $item, @arr ), 1, "homog, find ref, found" );

         # not found
@a1 = ( 1 );
@a2 = ( 1 );
@a3 = ( 1 );
@a4 = ( 1 );
$item = \@a4;
@arr  = ( \@a1, \@a2, \@a3 );
is( is_item_in_array( $item, @arr ), 0, "homog, find ref, not found" );

   # arr is mix types
      # find num
         # found
@a2 = ( "asdfaf", "jkhhj" );
$item = 22;
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 1, "hetero, find num, found" );

         # not found
@a2 = ( "asdfaf", "jkhhj" );
$item = 99;
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 0, "hetero, find num, not found" );

      # find str
         # found
@a2 = ( "asdfaf", "jkhhj" );
$item = "car";
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 1, "hetero, find str, found" );

         # not found
@a2 = ( "asdfaf", "jkhhj" );
$item = "carsadf";
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 0, "hetero, find str, not found" );

      # find ref
         # found
@a2 = ( "asdfaf", "jkhhj" );
$item = \@a2;
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 1, "hetero, find ref, found" );

         # not found
@a2 = ( "asdfaf", "jkhhj" );
@a4 = ( "asdfasdf", "sadfasfdsfd" );
$item = \@a4;
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 0, "hetero, find ref, not found" );

# special cases
   # find undef
      # found
@a2 = ( "asdfaf", "jkhhj" );
$item = undef;
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 1, "hetero, find undef, found" );

      # not found
@a2 = ( "asdfaf", "jkhhj" );
$item = undef;
@arr  = ( 22, 456, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 0, "hetero, find undef, not found" );

   # find empty string
      # found
@a2 = ( "asdfaf", "jkhhj" );
$item = "";
@arr  = ( 22, undef, "car", "", \@a2 );
is( is_item_in_array( $item, @arr ), 1, "hetero, find empty str, found" );

      # not found
@a2 = ( "asdfaf", "jkhhj" );
$item = "";
@arr  = ( 22, undef, "car", \@a2 );
is( is_item_in_array( $item, @arr ), 0, "hetero, find empty str, not found" );


done_testing();

exit 0;
