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
   get_random_nasdaq_ticker
);

print get_random_nasdaq_ticker(). "\n";

exit 0;


