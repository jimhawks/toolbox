#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use Carp qw(confess);
use File::Basename qw(basename);
use File::Copy qw(move);
use FindBin;

use Data::Dumper;

#use lib "$FindBin::RealBin/../lib";
use lib $ENV{ TOOLBOX_PERL_LIB_DIR };
use My::Utils qw(
    clip_mp4_file
    convert_mp4_to_gif
    delete_file
    is_str_empty
    is_str_non_empty
);


# constants
my $SCRIPT_NM = basename( $0 );

# globals
my $file  = "";
my $start = "";
my $end   = "";


#------------------------------------------------------------
# 
# main
#
#------------------------------------------------------------

get_cmd_line_args();
my $clipped_file = clip_mp4_file($file, $start, $end);
my $gif_file     = convert_mp4_to_gif($clipped_file);

delete_file($clipped_file);

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
   $start = shift @ARGV // "";
   $end   = shift @ARGV // ""; 
   
   # check for help arg
   if ( is_str_empty($file)
         or is_str_empty($start)
         or is_str_empty($end)
         or $file eq "-h"
         or $file eq "-H"
         or $file eq "--help"
         or $file eq "--Help"
         or $file eq "-?" )
   {
      print "Usage:  $SCRIPT_NM <mp4 file> <clip start> <clip end>\n";
      print "Usage:  $SCRIPT_NM my_video.mp4 00:01:00.4 00:03:49.3\n";
      exit 0;
   }
}

