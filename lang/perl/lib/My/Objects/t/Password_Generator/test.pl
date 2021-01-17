#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Password_Generator;

my $obj = new My::Objects::Password_Generator(
   symbols   => "n", # default: TRUE
   numbers   => "y", # default: TRUE
   letters   => "y", # default: TRUE
   lowercase => "n", # default: TRUE
   uppercase => "y", # default: TRUE
#   seed       => 12345,  # default: 0
);

print "passwd=[" . $obj->get_password( 34 ) . "]\n";

print Dumper( $obj->get_passwords( 20, 30, 3 ) );

print "dash=[" . $obj->get_dash_password() . "]\n";
exit 0;

