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
use File::Basename;
use FindBin;

#--------------------------------------------------
#
# modules - custom
#
#--------------------------------------------------
use lib "$FindBin::RealBin/../lib";
use My::Utils qw(
   grep_strs_in_array
   is_non_empty
   nvl
   trim
);

my %tree = (
   a1 => [
      "b1",
      "b2",
   ],
   b1 => [
      "c1",
      "c2",
   ],
   b2 => [ ],
   c1 => [ ],
   c2 => [ ],
);


#--------------------------------------------------
#
# main
#
#--------------------------------------------------

my @strs = @ARGV;
if ( $#strs < 0 )
{
   print "strs: ";
   chomp( my $input = <STDIN> );
   @strs = split( / +/, trim( $input ) );
}


my @tree_nodes = keys %tree;

my @matching_nodes = grep_strs_in_array(
   strs  => \@strs,
   array => \@tree_nodes,
);

foreach my $node ( sort @matching_nodes )
{
   print_tree( $node, "" );
}




exit 0;


sub print_tree
{
   my $node = nvl( shift, "" );
   my $tab  = nvl( shift, "" );

   is_non_empty( $node ) or die "ERROR. node is empty";
   is_non_empty( $tree{ $node } ) or die "ERROR.  node doesn't exist. node=[$node]";

   print "$tab$node\n";
   foreach my $subnode ( @{ $tree{ $node } } )
   {
      print_tree( $subnode, "$tab\t" );
   }
}

