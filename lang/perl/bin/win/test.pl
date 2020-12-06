#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../lib";
use My::Utils qw(
   isEmpty
   isNonEmpty
);

my $var = undef;
print "var is udef.  isNonEmpty=[" . isNonEmpty($var) "]\n";
print "var is udef.  isEmpty   =[" . isEmpty($var) "]\n";

exit 0;
