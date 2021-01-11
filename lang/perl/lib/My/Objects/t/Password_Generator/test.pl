#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Password_Generator;

my $obj = new My::Objects::Password_Generator(
   symbols => 0, # default: TRUE
   numbers => 0, # default: TRUE
   letters => 1, # default: TRUE
#   seed       => 12345,  # default: 0
);

print "passwd=[" . $obj->get_password( 34 ) . "]\n";

print Dumper( $obj->get_passwords( 3, 20, 30 ) );

exit 0;

