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

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $obj = "";


# default value
$obj = new My::Objects::Password_Generator(
);
is( $obj->get_seed_setting(), 0, "default setting" );

# set to 0
$obj = new My::Objects::Password_Generator(
   seed => 0,
);
is( $obj->get_seed_setting(), 0, "set to 0" );

# set to positive int
$obj = new My::Objects::Password_Generator(
   seed => 5,
);
is( $obj->get_seed_setting(), 5, "set to positive int" );

# set to positive float
$obj = new My::Objects::Password_Generator(
   seed => 4.3,
);
is( $obj->get_seed_setting(), 4, "set to positive float" );

# set to negative number
throws_ok { 
   $obj = new My::Objects::Password_Generator(
      seed => -1,
   )
} qr/Seed is a negative number/, "error.  negative number";



done_testing();

exit 0;
