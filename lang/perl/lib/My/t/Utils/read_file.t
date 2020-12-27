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
   read_file
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = ${SCRIPT} . ".data";

# undef filename
throws_ok { read_file( undef ) } qr/Filename is empty/, "undef filename";

# empty filename
throws_ok { read_file( "" ) } qr/Filename is empty/, "empty filename";

# file doesn't exist
throws_ok { read_file( "$DATA_DIR/file_not_found" ) } qr/File not found/, "filename doesnt exist";

# file is a dir
throws_ok { read_file( "$DATA_DIR/file_is_dir" ) } qr/File is not a file/, "file is dir";

# file is not readable
chmod 0220, "$DATA_DIR/file_not_readable";
throws_ok { read_file( "$DATA_DIR/file_not_readable" ) } qr/File is not readable/, "file not readable";
chmod 0664, "$DATA_DIR/file_not_readable";

# file is empty
# file is nonempty, 1 line
# file is nonempty, multiple lines
# file is a binary file







#my @lines_empty = ();
#my @lines_1 = (
#   "Four score and seven years ago our fathers brought forth, upon this continent",
#);
#my @lines_many = (
#   "Four score and seven years",
#   "Four score and seven years ago our fathers",
#   "",
#   undef,
#   "Four score and seven years ago our fathers brought forth",
#   "",
#   "Four score and seven years ago our fathers brought forth, upon this continent",
#);
#
#my @strs   = ();
#my @got    = ();
#my @expect = ();
#
##################################
#@strs = (
#   "father",
#);
#@expect = (
#   "Four score and seven years ago our fathers brought forth, upon this continent",
#);
#@got = read_file( \@strs, \@lines_1 );
#is_deeply( \@got, \@expect, "1 str, 1 line, yes match, case match");



done_testing();

exit 0;
