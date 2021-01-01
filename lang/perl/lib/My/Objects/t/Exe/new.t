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

# object is class
isa_ok( new My::Objects::Exe(), "My::Objects::Exe" );

# public methods exist
can_ok( 
   "My::Objects::Exe", 
   qw(
   )
);


#my @expect = ();
#my @got    = ();
#my $file   = "";
#
#
## undef filename
#$file = undef;
#throws_ok { read_file( $file ) } qr/Filename is empty/, "undef filename";
#
## empty filename
#$file = "";
#throws_ok { read_file( $file ) } qr/Filename is empty/, "empty filename";
#
## file doesn't exist
#$file = "$DATA_DIR/file_not_found";
#throws_ok { read_file( $file ) } qr/File not found/, "filename doesnt exist";
#
## file is a dir
#$file = "$DATA_DIR/file_is_dir";
#throws_ok { read_file( $file ) } qr/File is not a file/, "file is dir";
#
## file is not readable
#$file = "$DATA_DIR/file_not_readable";
#chmod 0220, $file;
#throws_ok { read_file( $file ) } qr/File is not readable/, "file not readable";
#chmod 0664, $file;
#
## file is empty
#$file = "$DATA_DIR/empty_file";
#@expect = ();
#@got = read_file( $file );
#is_deeply( \@got, \@expect, "empty file" );
#
## file is nonempty, 1 line
#$file = "$DATA_DIR/one_line";
#@expect = ("Four score and seven years\n");
#@got = read_file( $file );
#is_deeply( \@got, \@expect, "1 line file" );
#
## file is nonempty, multiple lines
#$file = "$DATA_DIR/multiple_lines";
#@expect = (
#   "Four score and seven years\n",
#   "\n",
#   "Four score and seven years ago our fathers \n",
#   "\n",
#   "\n",
#   "Four score and seven years ago our fathers brought forth, upon this continent\n",
#);
#@got = read_file( $file );
#is_deeply( \@got, \@expect, "2+ lines file" );


done_testing();

exit 0;
