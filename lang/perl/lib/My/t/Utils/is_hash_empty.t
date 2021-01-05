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
   is_hash_empty
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my %hash = ();


# nothing passed
is( is_hash_empty( ), 1, "nothing passed" );

# empty hash
%hash = ();
is( is_hash_empty( %hash ), 1, "empty hash" );

# 1 kv pair
%hash = (
   k1 => "v1",
);
is( is_hash_empty( %hash ), 0, "1 kv pair" );


# 2 kv pair
%hash = (
   k1 => "v1",
   k2 => "v2",
);
is( is_hash_empty( %hash ), 0, "2 kv pair" );


done_testing();

exit 0;
