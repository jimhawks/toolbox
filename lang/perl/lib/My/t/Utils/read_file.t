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

###############################################################
#
# tests
#
###############################################################

my @expect = ();
my @got    = ();


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
@expect = ();
@got = read_file( "$DATA_DIR/empty_file" );
is_deeply( \@got, \@expect, "empty file" );

# file is nonempty, 1 line
@expect = ("Four score and seven years\n");
@got = read_file( "$DATA_DIR/one_line" );
is_deeply( \@got, \@expect, "1 line file" );

# file is nonempty, multiple lines
@expect = (
   "Four score and seven years\n",
   "\n",
   "Four score and seven years ago our fathers \n",
   "\n",
   "\n",
   "Four score and seven years ago our fathers brought forth, upon this continent\n",
);
@got = read_file( "$DATA_DIR/multiple_lines" );
is_deeply( \@got, \@expect, "2+ lines file" );


done_testing();

exit 0;
