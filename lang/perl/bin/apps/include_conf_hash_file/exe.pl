#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

#--------------------------------------------------
#
# modules - system
#
#--------------------------------------------------
use Carp qw( cluck confess );
use FindBin;

#--------------------------------------------------
#
# modules - custom
#
#--------------------------------------------------
use lib "$FindBin::RealBin/../../../lib";
use My::Utils qw(
   get_conf_from_file
   get_hash_from_file
);

my $href = get_hash_from_file( "./conf.pl" );
print Dumper( $href );

my $href2 = get_conf_from_file( "./conf.pl" );
print Dumper( $href2 );

exit 0;

