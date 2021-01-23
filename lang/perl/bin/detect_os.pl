#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../lib";
use My::Utils qw(
   get_home_dir
   get_os_type
   is_windows
);

print "os=[" . $^O . "]\n";
print "os=[" . get_os_type() . "]\n";
print "is_windows=[" . is_windows() . "]\n";
print "home dir=[" . get_home_dir() . "]\n";

<STDIN>;


exit 0;

