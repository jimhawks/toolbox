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
   grepi_file
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $dir = "";


## undef dirname
#$dir = undef;
#throws_ok { verify_dir_exists( $dir ) } qr/Dir name is empty/, "undef dir name";
#
## file is nonempty, 1 line
#$file = "$DATA_DIR/one_line";
#@expect = ("Four score and seven years\n");
#@got = read_file( $file );
#is_deeply( \@got, \@expect, "1 line file" );
#
## "is" check
#is( is_empty(\%empty_array),     0, "empty array");

is( 1, 2, "not finished" );

done_testing();

exit 0;
