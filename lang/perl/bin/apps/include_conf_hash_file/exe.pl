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
   read_conf_file
   read_hash_file
);

my $href = read_hash_file( "./conf.pl" );
print Dumper( $href );

my $href2 = read_conf_file( "./conf.pl" );
print Dumper( $href2 );

exit 0;

