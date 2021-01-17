#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Password_Generator;
use My::Constants qw(
   $YES
   $NO
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $obj = "";

# empty new
lives_ok { new My::Objects::Password_Generator() } "empty new ";

# all options
lives_ok { 
   new My::Objects::Password_Generator(
      symbols     => $NO,
      numbers     => $NO,
      letters     => $NO,
      dash_groups => $YES, 
      num_groups  => 6,
      seed        => 12345,
   ) 
} "all options";



## empty new
#lives_ok { new My::Objects::Exe() } "empty new ";
#
## single item array
#throws_ok { new My::Objects::Exe( 1 ) } qr/Args is not a hash/, "single item array";
#
## even number array
#lives_ok { new My::Objects::Exe( 1, 2 ) } "even number array";
#
## hash
#lives_ok { new My::Objects::Exe( k1 => "v1", k2 => "v2" ) } "hash";


done_testing();

exit 0;
