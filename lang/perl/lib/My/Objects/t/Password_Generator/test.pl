#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Password_Generator;
use My::Constants qw(
   $YES
   $NO
);

my $obj = new My::Objects::Password_Generator(
   symbols   => $NO,  # default: TRUE
   numbers   => $YES, # default: TRUE
   letters   => $YES, # default: TRUE
   lowercase => $NO,  # default: TRUE
   uppercase => $YES, # default: TRUE
);

print Dumper( $obj->get_passwords( len => 34, num_passwords => 3 ) );
print "\n\n";
print Dumper( $obj->get_dash_passwords( group_len => 3, num_groups => 4 ) );

#print "passwd=[" . $obj->get_password( 34 ) . "]\n";
#print "dash=[" . $obj->get_dash_password() . "]\n";
exit 0;

