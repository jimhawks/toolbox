#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

# public methods exist
can_ok( 
   "My::Objects::Exe", 
   qw(
      new 

      get_args
      get_data
      get_options

      get_arg_array
      get_arg_value
      get_option_array
      get_option_value

      get_data_array
      set_data_array
      get_data_hash
      set_data_hash
      get_data_value
      set_data_value
   )
);

# object is class
isa_ok( new My::Objects::Exe(), "My::Objects::Exe" );

done_testing();

exit 0;
