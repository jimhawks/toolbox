#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $separator = "";
if ( get_os_type() eq "windows" )
{
   $separator = ";";
}
elsif ( get_os_type() eq "linux" )
{
   $separator = ":";
}
else
{
   die "ERROR.  OS type is unknown";
}


my @paths = split( /$separator/, $ENV{ PATH } );
foreach my $path ( @paths )
{
   print "[$path]\n";
}

<STDIN>;

exit 0;


sub get_os_type
{
   my $os = lc( $^O );

   my $type = "";
   if ( $os eq "mswin32" )
   {
      $type = "windows";
   }
   elsif ( $os eq "linux" )
   {
      $type = "linux";
   }
   else
   {
      $type = "unknown";
   }

   return( $type );
}
