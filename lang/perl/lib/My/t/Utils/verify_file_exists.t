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
   does_file_exist
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $file = "";

# undef filename
$file = undef;
throws_ok { does_file_exist( $file ) } qr/Filename is empty/, "undef filename";

# empty filename
$file = "";
throws_ok { does_file_exist( $file ) } qr/Filename is empty/, "empty filename";

# file doesn't exist
$file = "$DATA_DIR/file_not_found";
throws_ok { does_file_exist( $file ) } qr/File not found/, "file doesnt exist";

# file is a dir
$file = "$DATA_DIR/file_is_dir";
throws_ok { does_file_exist( $file ) } qr/File is not a file/, "file is dir";


done_testing();

exit 0;
