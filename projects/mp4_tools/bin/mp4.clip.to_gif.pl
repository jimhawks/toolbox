#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use Carp qw(confess);
use File::Basename qw(basename);
use File::Copy qw(move);
use FindBin;
use Getopt::Long;

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
my $debug   = 0;
my $dry_run = 0;


#------------------------------------------------------------
# 
# main
#
#------------------------------------------------------------

# get options
GetOptions(
    'debug'   => \$debug,
    'dry-run' => \$dry_run,
) or die "Usage: $SCRIPT_NM [--debug] [--dry-run] ...\n";

if ( $debug ) {
    print "$SCRIPT_NM - options\n";
    print "  --debug   = [$debug]\n";
    print "  --dry-run = [$dry_run]\n";
}

# get args
my ($mp4_file, $clip_start, $clip_end, $gif_file ) = get_cmd_line_args();

# debug: output inputs
if ( $debug ) {
    print "$SCRIPT_NM - inputs: \n";
    print "    mp4_file   = [$mp4_file]\n";
    print "    clip_start = [$clip_start]\n";
    print "    clip_end   = [$clip_end]\n";
    print "    gif_file   = [$gif_file]\n";
    #exit 0;
}

if ( ! $dry_run ) {
    my $clipped_mp4_file = clip_mp4_file(
        mp4_file     => $mp4_file, 
        clip_start   => $clip_start, 
        clip_end     => $clip_end,
        #debug        => 1,
        #dry_run      => 0,
    );
    my $created_gif_file = convert_mp4_to_gif(
        mp4_file => $clipped_mp4_file,
        gif_file => $gif_file,
        #debug    => 1,
        #dry_run  => 0,
    );
}

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
   $mp4_file   = shift @ARGV // ""; 
   $clip_start = shift @ARGV // "";
   $clip_end   = shift @ARGV // ""; 
   $gif_file   = shift @ARGV // "";
   
   # check for help arg
   if ( is_str_empty($mp4_file)
         or is_str_empty($clip_start)
         or is_str_empty($clip_end)
         or $mp4_file eq "-h"
         or $mp4_file eq "-H"
         or $mp4_file eq "--help"
         or $mp4_file eq "--Help"
         or $mp4_file eq "-?" )
   {
      print "Usage:   $SCRIPT_NM <mp4 file> <clip start> <clip end> [<gif file>]\n";
      print "Example: $SCRIPT_NM my_video.mp4 00:01:00.4 00:03:49.3\n";
      print "Example: $SCRIPT_NM my_video.mp4 00:01:00.4 00:03:49.3 my_clip.gif\n";
      exit 0;
   }

   return( $mp4_file, $clip_start, $clip_end, $gif_file );
}

