#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

#--------------------------------------------------
#
# modules - system
#
#--------------------------------------------------
use FindBin;

#--------------------------------------------------
#
# modules - custom
#
#--------------------------------------------------
use lib "$FindBin::Bin/../../lib";
use My::Objects::Password_Generator;

my $obj = new My::Objects::Password_Generator();

exit 0;