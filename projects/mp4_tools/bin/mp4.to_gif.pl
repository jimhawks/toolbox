#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use File::Basename qw(basename);
use File::Copy qw(move);
use FindBin;

use Data::Dumper;

use lib "$FindBin::RealBin/../lib";
use My::Utils qw(
    convert_mp4_to_gif
    is_str_empty
    is_str_non_empty
);


# constants
my $SCRIPT_NM = basename( $0 );

# globals
my $file   = "";


#------------------------------------------------------------
# 
# main
#
#------------------------------------------------------------

get_cmd_line_args();
convert_mp4_to_gif($file);

exit 0;


#-----------------------------------------------------------------------------------
# functions - app
#-----------------------------------------------------------------------------------



#-----------------------------------------------------------------------------------
# functions - lib
#-----------------------------------------------------------------------------------

sub get_cmd_line_args
{
   # get cmd line args
   $file  = shift @ARGV // ""; 
   
   # check for help arg
   if ( is_str_empty($file)
         or $file eq "-h"
         or $file eq "-H"
         or $file eq "--help"
         or $file eq "--Help"
         or $file eq "-?" )
   {
      print "Usage:  $SCRIPT_NM <mp4 file>\n";
      print "Usage:  $SCRIPT_NM my_video.mp4\n";
      exit 0;
   }
}

