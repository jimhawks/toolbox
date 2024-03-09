#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use File::Copy qw(move);

use Data::Dumper;

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
