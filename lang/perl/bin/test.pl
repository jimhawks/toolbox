#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use Cwd;
use FindBin;
use File::Find;

use lib "$FindBin::Bin/../lib";
use My::Utils qw(
   get_home_dir
   is_linux
   is_windows
   get_os_type
);

print "type=[" . get_os_type() . "]\n";
print "is_linux=[" . is_linux() . "]\n";
print "is_win=[" . is_windows() . "]\n";
print "home=[" . get_home_dir() . "]\n";

exit 0;


