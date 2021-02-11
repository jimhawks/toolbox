#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Tmp_Files;
use My::Utils qw(
   touch_files
);
use My::Constants qw(
   $TRUE
   $FALSE
);

my $obj = new My::Objects::Tmp_Files(
   #dir        => "$ENV{ HOME }/.blah",
   #tag        => "mearg", 
   #keep_files => $FALSE, 
);

my @arr = ();
push( @arr, $obj->get_new_file() );
push( @arr, $obj->get_new_file() );
push( @arr, $obj->get_new_file() );
push( @arr, $obj->get_new_file() );
push( @arr, $obj->get_new_file() );
touch_files( @arr );
print Dumper( $obj );
<STDIN>;

#print Dumper( \@arr );


exit 0;

