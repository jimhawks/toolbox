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

# default value
$obj = new My::Objects::Password_Generator(
);
is( $obj->get_numbers_setting(), $YES, "use default" );

# set to true
$obj = new My::Objects::Password_Generator(
   numbers => $YES,
);
is( $obj->get_numbers_setting(), $YES, "set to true" );

# set to false
$obj = new My::Objects::Password_Generator(
   numbers => $NO,
);
is( $obj->get_numbers_setting(), $NO, "set to false" );


done_testing();

exit 0;
