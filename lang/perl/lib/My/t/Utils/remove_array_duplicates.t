#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   remove_array_duplicates
);

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################


my @arr = ();
my @exp = ();
my @got = ();

# dupe types
   # numbers
@arr = ( 1, 1 );
@got = remove_array_duplicates( @arr );
@exp = ( 1 );
is_deeply( \@got, \@exp, "dupe types.  numbers" );

   # strings
@arr = ( "str", "str" );
@got = remove_array_duplicates( @arr );
@exp = ( "str" );
is_deeply( \@got, \@exp, "dupe types.  strings" );

   # refs
my @list = ( 1, 2, 3 );
@arr = ( \@list, \@list );
@got = remove_array_duplicates( @arr );
@exp = ( \@list );
is_deeply( \@got, \@exp, "dupe types.  refs" );

   # undef
@arr = ( undef, undef );
@got = remove_array_duplicates( @arr );
@exp = ( undef );
is_deeply( \@got, \@exp, "dupe types.  undef" );

# empty array
@arr = ( );
@got = remove_array_duplicates( @arr );
@exp = ( );
is_deeply( \@got, \@exp, "empty array" );


# non-empty array
   # 1 element
@arr = ( "a" );
@got = remove_array_duplicates( @arr );
@exp = ( "a" );
is_deeply( \@got, \@exp, "1 element" );

   # multiple array elements
      # all unique
@arr = ( "a", "b", "c" );
@got = remove_array_duplicates( @arr );
@exp = ( "a", "b", "c" );
is_deeply( \@got, \@exp, "unique array" );

      # not unique
         # all elements are dupes
@arr = ( "a", "a", "a" );
@got = remove_array_duplicates( @arr );
@exp = ( "a" );
is_deeply( \@got, \@exp, "all are dupes" );

         # not all elements are dupes
            # 1 set of dupes
@arr = ( "a", "b", "a", "c" );
@got = remove_array_duplicates( @arr );
@exp = ( "a", "b", "c" );
is_deeply( \@got, \@exp, "1 set of dupes" );

            # 2 sets of dupes
@arr = ( "a", "b", "a", "c", "b" );
@got = remove_array_duplicates( @arr );
@exp = ( "a", "b", "c" );
is_deeply( \@got, \@exp, "2 sets of dupes" );


done_testing();

exit 0;
