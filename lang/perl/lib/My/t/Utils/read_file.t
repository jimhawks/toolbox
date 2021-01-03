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
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my @expect = ();
my @got    = ();
my $file   = "";


# file is empty
$file = "$DATA_DIR/empty_file";
@expect = ();
@got = read_file( $file );
is_deeply( \@got, \@expect, "empty file" );

# file is nonempty, 1 line
$file = "$DATA_DIR/one_line";
@expect = ("Four score and seven years\n");
@got = read_file( $file );
is_deeply( \@got, \@expect, "1 line file" );

# file is nonempty, multiple lines
$file = "$DATA_DIR/multiple_lines";
@expect = (
   "Four score and seven years\n",
   "\n",
   "Four score and seven years ago our fathers \n",
   "\n",
   "\n",
   "Four score and seven years ago our fathers brought forth, upon this continent\n",
);
@got = read_file( $file );
is_deeply( \@got, \@expect, "2+ lines file" );


done_testing();

exit 0;
