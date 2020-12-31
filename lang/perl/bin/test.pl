#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use Cwd;
use FindBin;
use File::Find;

use lib "$FindBin::Bin/../lib";
use My::Utils qw(
   is_empty
   is_non_empty
);

my $var = undef;
print "var is udef.  is_non_empty=[" . is_non_empty($var) . "]\n";
print "var is udef.  is_empty    =[" . is_empty($var) . "]\n";

my @list = get_list_of_files();
print Dumper( \@list );

exit 0;

sub get_list_of_files
{
   my @files = ();

   sub wanted
   {
      push( @files, $File::Find::name );
   }

   find( { wanted => \&wanted }, "$FindBin::Bin/../lib" );

   return( @files );
}

