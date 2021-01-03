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
   get_filesys_list
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
my $curr_dir = "";


# dir is empty
$dir = "$DATA_DIR/empty_dir";
mkdir $dir or die "ERROR. mkdir failed. dir=[$dir]";
@expect = ( $dir );
@got = get_filesys_list( "$DATA_DIR/empty_dir" );
is_deeply( \@got, \@expect, "empty dir" );
rmdir $dir or die "ERROR. rmdir failed. dir=[$dir]";

# dir is nonempty, no subdirs
$dir = "$DATA_DIR/dir1";
@expect = ( 
   $dir,
   "$dir/file1",
   "$dir/file2",
   "$dir/file3",
);
@got = get_filesys_list( $dir );
is_deeply( \@got, \@expect, "nonempty dir, no subdirs" );

# dir is nonempty, yes subdirs
$dir = "$DATA_DIR/dir2";
@expect = ( 
   $dir,
   "$dir/dir1",
   "$dir/dir1/file1",
   "$dir/dir1/file2",
   "$dir/dir2",
   "$dir/dir2/file1",
   "$dir/file3",
);
@got = get_filesys_list( $dir );
is_deeply( \@got, \@expect, "nonempty dir, yes subdirs" );

# subdir is not readable
$dir = "$DATA_DIR/dir3";
chmod 0331, "$dir/dir2";
@expect = ( 
   $dir,
   "$dir/dir1",
   "$dir/dir1/file1",
   "$dir/dir1/file2",
   "$dir/dir2",
   "$dir/file3",
);
@got = get_filesys_list( $dir );
is_deeply( \@got, \@expect, "subdir not readable" );
chmod 0775, "$dir/dir2";

# subdir file is not readable
$dir = "$DATA_DIR/dir4";
chmod 0220, "$dir/file2";
@expect = ( 
   $dir,
   "$dir/file1",
   "$dir/file2",
   "$dir/file3",
);
@got = get_filesys_list( $dir );
is_deeply( \@got, \@expect, "subdir file not readable" );
chmod 0664, "$dir/file2";

# relative dir, current dir
$dir = "$DATA_DIR/dir5";
$curr_dir = cwd;
chdir $dir or die "ERROR.  Chdir failed.  dir=[$dir]";
@expect = ( 
   ".",
   "./file1",
   "./file2",
   "./file3",
);
@got = get_filesys_list( "." );
is_deeply( \@got, \@expect, "relative dir, current dir" );
chdir $curr_dir or die "ERROR.  Chdir failed.  dir=[$curr_dir]";

# relative dir, tree traversal
$dir = "$DATA_DIR/dir6/dir2";
$curr_dir = cwd;
chdir $dir or die "ERROR.  Chdir failed.  dir=[$dir]";
@expect = ( 
   "../dir1",
   "../dir1/file1",
   "../dir1/file2",
);
@got = get_filesys_list( "../dir1" );
is_deeply( \@got, \@expect, "relative dir, tree traversal" );
chdir $curr_dir or die "ERROR.  Chdir failed.  dir=[$curr_dir]";


done_testing();

exit 0;
