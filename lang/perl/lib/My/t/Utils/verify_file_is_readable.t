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
   verify_file_is_readable
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $file = "";


# file is not readable
$file = "$DATA_DIR/file_not_readable";
chmod 0220, $file;
throws_ok { verify_file_is_readable( $file ) } qr/File is not readable/, "file not readable";
chmod 0664, $file;


done_testing();

exit 0;
