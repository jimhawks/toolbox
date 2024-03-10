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
   does_dir_exist
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $dir = "";


# undef dirname
$dir = undef;
throws_ok { does_dir_exist( $dir ) } qr/Dir name is empty/, "undef dir name";

# empty dirname
$dir = "";
throws_ok { does_dir_exist( $dir ) } qr/Dir name is empty/, "empty dir name";

# dir doesn't exist
$dir = "$DATA_DIR/dir_not_found";
throws_ok { does_dir_exist( $dir ) } qr/Dir not found/, "dir doesnt exist";

# dir is a file
$dir = "$DATA_DIR/dir_is_file";
throws_ok { does_dir_exist( $dir ) } qr/Dir is not a dir/, "dir is file";


done_testing();

exit 0;
