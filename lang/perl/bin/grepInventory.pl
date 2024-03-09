#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;
use Data::Dumper;

use FindBin;

my $filename = "inventory.txt";

# get contents of inventory file
my $filePath = $FindBin::Bin . "/inventory.txt";
open(my $FH, "<", $filePath) or die "ERROR. file open failed. file=[$filePath]";
my @fileContents = (<$FH>);
$fileContents[-1] =~ /\n$/ or $fileContents[-1] .= "\n";
close($FH);

# print out file
print "file=[" . $filePath . "]\n";

while (1)
{
   # terminate loop if empty input
   my $searchStringsText = getUserInput();
   $searchStringsText ne "" or last;

   # if "all", then show all lines and return to beginning of loop
   if ($searchStringsText eq "all")
   {
      print @fileContents;
      next;
   }

   # split into search strings
   my @searchStrings = split(/ /, "$searchStringsText");

   # grep file lines
   my @filteredList = @fileContents;
   foreach my $str (@searchStrings)
   {
       my @newList = grep(/$str/i, @filteredList);
       @filteredList = @newList;
       @newList = ();
   }

   # print out match lines and pause.
   if ($#filteredList < 0)
   {
      print "nothing found\n";
   }
   else 
   {
      print @filteredList;
   }
}

exit;



sub getUserInput
{
   # get from user text strings to search file
   print "\n";
   print "search strings: ";

   # remove extra spaces
   chomp(my $user_input = <stdin>);
   $user_input =~ s/  */ /g; # remove extra spaces
   $user_input =~ s/^ *//g;  # remove leading spaces
   $user_input =~ s/ *$//g;  # remove trailing spaces

   return "$user_input";
}
