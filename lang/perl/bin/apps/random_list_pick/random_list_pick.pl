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
use My::Constants qw(
   $TRUE
   $FALSE
);
use My::Utils qw(
   get_random_number
   is_non_empty
   read_file
);

#--------------------------------------------------
#
# globals
#
#--------------------------------------------------


###################################################
#
# process
#
###################################################
init();
main();
term();

exit 0;


#--------------------------------------------------
#
# functions - top level
#
#--------------------------------------------------

sub init
{
}

sub main
{
    my $str = "";
    foreach my $filename( @ARGV )
    {
       my @list = read_file( $filename );
       chomp( @list );
       my $item = $list[ get_random_number( 0, $#list ) ];
       $str .= ( is_non_empty( $str ) ? " " : "" ) . $item;
    }
    print "$str\n";
}

sub term
{
   <STDIN>;
}
           
#--------------------------------------------------
#
# functions - others
#
#--------------------------------------------------




exit 0;

