#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use Cwd;
use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   get_dir_list
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my @expect   = ();
my @got      = ();
my $dir      = "";


# dir is empty
$dir = "$DATA_DIR/empty_dir";
mkdir $dir or die "ERROR. mkdir failed. dir=[$dir]";
@expect = ( $dir );
@got = get_dir_list( "$DATA_DIR/empty_dir" );
is_deeply( \@got, \@expect, "empty dir" );
rmdir $dir or die "ERROR. rmdir failed. dir=[$dir]";

# only files
$dir = "$DATA_DIR/dir1";
@expect = ( 
   $dir,
);
@got = get_dir_list( $dir );
is_deeply( \@got, \@expect, "only files" );

# files and dirs
$dir = "$DATA_DIR/dir2";
@expect = ( 
   $dir,
   "$dir/dir1",
   "$dir/dir2",
);
@got = get_dir_list( $dir );
is_deeply( \@got, \@expect, "files and dirs" );


done_testing();

exit 0;
