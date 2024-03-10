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
   is_dir_readable
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $dir = "";

# dir is not readable
$dir = "$DATA_DIR/dir_not_readable";
chmod 0331, $dir;
throws_ok { is_dir_readable( $dir ) } qr/Dir is not readable/, "dir not readable";
chmod 0775, $dir;


done_testing();

exit 0;
