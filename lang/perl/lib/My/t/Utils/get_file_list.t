#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use Cwd;
use FindBin;
use File::Basename;
use File::Path qw( make_path remove_tree );

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   get_file_list
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
@expect = ( );
@got = get_file_list( "$DATA_DIR/empty_dir" );
is_deeply( \@got, \@expect, "empty dir" );
rmdir $dir or die "ERROR. rmdir failed. dir=[$dir]";

# only dirs
$dir = "$DATA_DIR/dir1";
make_path( "$dir/dir1", "$dir/dir2" ) or die "ERROR.  Make_path failed";
@expect = ( );
@got = get_file_list( $dir );
is_deeply( \@got, \@expect, "only dirs" );
remove_tree( $dir ) or die "ERROR.  Remove_tree failed";

# files and dirs
$dir = "$DATA_DIR/dir2";
@expect = ( 
   "$dir/dir1/file1",
   "$dir/dir1/file2",
   "$dir/dir2/file1",
   "$dir/file3",
);
@got = get_file_list( $dir );
is_deeply( \@got, \@expect, "files and dirs" );


done_testing();

exit 0;
