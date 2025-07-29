#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use Carp qw(confess);
use File::Basename qw(basename);
use File::Copy qw(move);

use Data::Dumper;

# constants
my $SCRIPT_NM = basename( $0 );

# globals
my $file   = "";
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

sub clip_mp4_file
{
   my ($mp4_file, $clip_start, $clip_end) = @_;

   # decompose mp4 filename into stem and ext
   my @parts = split(/\./, $mp4_file);
   my $file_ext = pop @parts // "";
   my $file_stem = join(".", @parts);

   #verify its an mp4 file
   (is_str_non_empty($file_ext) and $file_ext eq "mp4") or confess "ERROR. extension is not mp4. ext=[$file_ext]";

   # build output filename
   my $clipped_mp4_file = "$file_stem.clipped.mp4";

   # remove files
   ! -e $clipped_mp4_file or delete_file($clipped_mp4_file);

   #run clipping command
   my $cmd = "ffmpeg"
            . " -i $mp4_file"
            . " -ss $clip_start -to $clip_end"
            . ' -vf "fps=30,scale=1280:-1" -c:v libx264 -preset veryfast -crf 18 -an'
            . " $clipped_mp4_file"
            ;
   system($cmd);

   return($clipped_mp4_file);
}

sub convert_mp4_to_gif
{
   my ($mp4_file, $clip_start, $clip_end) = @_;

   my $palette_file = "palette.png";

   # decompose mp4 filename into stem and ext
   my @parts = split(/\./, $mp4_file);
   my $file_ext = pop @parts // "";
   my $file_stem = join(".", @parts);

   # verify its an mp4 file
   (is_str_non_empty($file_ext) and $file_ext eq "mp4") or confess "ERROR. extension is not mp4. ext=[$file_ext]";

   # build output filename
   my $gif_file = "$file_stem.gif";

   # remove files
   ! -e $gif_file     or delete_file($gif_file);
   ! -e $palette_file or delete_file($palette_file);

   # run cmd to get the palette
   my $palette_cmd = "ffmpeg"
            . " -i $mp4_file"
            . ' -vf "fps=15,scale=640:-1:flags=lanczos,palettegen"'
            . " $palette_file"
            ;
   system($palette_cmd);

   # run cmd to do conversion to gif
   my $conversion_cmd = "ffmpeg"
            . " -i $mp4_file"
            . " -i $palette_file"
            . ' -filter_complex "fps=15,scale=640:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5"'
            . " $gif_file"
            ;
   system($conversion_cmd);

   delete_file($palette_file);

   return($gif_file);
}


#-----------------------------------------------------------------------------------
# functions - lib
#-----------------------------------------------------------------------------------

sub delete_file
{
   $file  = shift // ""; 
   is_str_non_empty($file) or confess "ERROR. Filename is empty";
   unlink $file or confess "ERROR.  Delete file failed. file=[$file]"
}


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

sub is_str_empty
{
    my $str = shift;
    my $rc = ( !defined( $str ) or length( $str ) == 0 ) ? 1 : 0;
    return( $rc );
}

sub is_str_non_empty
{
    my $str = shift;
    my $rc = ( defined( $str ) and length( $str ) > 0 ) ? 1 : 0;
    return( $rc );
}
