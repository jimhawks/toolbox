#!C:\Strawberry\perl\bin\perl.exe

###################################################################################
# In the current dir, 
#
###################################################################################

use strict;
use warnings;

use File::Basename qw(basename);
use File::Copy qw(move);

use Data::Dumper;

# constants
my $SCRIPT_NM = basename( $0 );

# globals
my $file_pattern = "";
my $search_text  = "";
my $replace_text = "";
my @file_list    = ();

# main
get_cmd_line_args();
get_list_of_files();



print "test\n"; <STDIN>; exit 0;

# get list of files in current dir
opendir( my $DH, "." ) or die "ERROR.. unable to open dir";
chomp( my @dirList = readdir($DH) );
closedir( $DH );






foreach my $dir ( @dirList )
{
   if ( $dir =~ /^20/ and $dir =~ /\./ )
   {
      my ( $date, $send_recv, $who, $how, $title ) = split( /\./, $dir, 5);
      my $new_dir = join("=", $date, $send_recv, $who, $how, $title);
      print "\n";
      print "old=[$dir]\n";
      print "new=[$new_dir]\n";
      move( $dir, $new_dir ) or die "ERROR. move failed";
   }
}

print "wtf\n";

exit 0;

#-----------------------------------------------------------------------------------
# functions
#-----------------------------------------------------------------------------------

sub get_cmd_line_args
{
   # get cmd line args
   $file_pattern = shift @ARGV || "";  # default is specified to silence "undef" warnings
   $search_text  = shift @ARGV;
   $replace_text = shift @ARGV; 
   
   # check file pattern arg
   length( $file_pattern ) > 0 or die "ERROR.  file_pattern is empty";
   
   # check for help arg
   if ( $file_pattern eq "-h"
        or $file_pattern eq "-H"
        or $file_pattern eq "--help"
        or $file_pattern eq "--Help"
        or $file_pattern eq "-?" )
   {
      print "Usage:  $SCRIPT_NM <file_pattern> <search text> <replace text>\n";
      exit 0;
   }
   
   # check search and replace args
   ( defined( $search_text ) and length( $search_text ) > 0 ) or die "ERROR.  search_text is empty";
   defined( $replace_text ) or die "ERROR.  replace_text is empty";
}

sub get_list_of_files
{
   @file_list = glob($file_pattern);
}



