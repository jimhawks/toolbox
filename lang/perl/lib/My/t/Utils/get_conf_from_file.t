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
   read_conf_file
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $file = "";
my $expect = "";
my $got    = "";

# no args
throws_ok { read_conf_file( ) } qr/Filename is empty/, "no args";

# undef filename
$file = undef;
throws_ok { read_conf_file( $file ) } qr/Filename is empty/, "undef file name";

# empty filename
$file = "";
throws_ok { read_conf_file( $file ) } qr/Filename is empty/, "empty file name";

# file doesn't exit
$file = "$DATA_DIR/file_doesnt_exist.txt";
throws_ok { read_conf_file( $file ) } qr/File not found/, "file doesn't exist";

# file is a dir
$file = "$DATA_DIR/file1.txt";
throws_ok { read_conf_file( $file ) } qr/File is not a file/, "file is dir";

# file is not readable
$file = "$DATA_DIR/file2.txt";
chmod 0220, $file;
throws_ok { read_conf_file( $file ) } qr/File is not readable/, "file not readable";
chmod 0664, $file;

# file is empty
$file = "$DATA_DIR/file3.txt";
$expect = { };
$got = read_conf_file( $file );
is_deeply( $got, $expect, "file is empty" );

# file is a parenthesis instead of curly braces
$file = "$DATA_DIR/file4.txt";
$expect = { };
$got = read_conf_file( $file );
is_deeply( $got, $expect, "file contains parentheses" );

# file contains multiple top-level curly braces
$file = "$DATA_DIR/file5.txt";
$expect = { };
$got = read_conf_file( $file );
is_deeply( $got, $expect, "file contains multiple top level curly braces" );

# file is a simple hash
$file = "$DATA_DIR/file6.txt";
$expect = { 
   k1 => "v1",
   k2 => 12,
   k3 => [ 1, 2, 3 ],
   k4 => { 
            m1 => "n1",
            m2 => "n2",
         },
};
$got = read_conf_file( $file );
is_deeply( $got, $expect, "file is a simple hash" );

# file is a complex hash
$file = "$DATA_DIR/file7.txt";
$expect = { 
   k1 => "v1",
   k2 => 12,
   k3 => [ 1, 2, 3 ],
   k4 => { 
            m1 => "n1",
            m2 => "n2",
         },
   k5 => {
             k1 => "v1",
             k2 => 12,
             k3 => [ 1, 2, 3 ],
             k4 => { 
                      m1 => "n1",
                      m2 => "n2",
                   },
         }
};
$got = read_conf_file( $file );
is_deeply( $got, $expect, "file is a complex hash" );

done_testing();

exit 0;
