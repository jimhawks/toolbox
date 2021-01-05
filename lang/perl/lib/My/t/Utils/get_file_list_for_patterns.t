#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;

use FindBin;

use lib "$FindBin::Bin/../../../../lib";
use My::Utils qw(
   get_file_list_for_patterns
);

is ( 1, 2, "tbd" );

# dir is empty
   # 1 pattern
   # 2 patterns

# dir is non-empty
   # 1 file
      # 1 pattern
         # file matches
         # file doesn't match
      # 2 patterns
         # no pattern matches
         # 1 pattern matches
         # both patterns match
   # multiple files
      # 1 pattern
         # pattern matches
         # pattern doesn't match
      # 2 patterns
         # 1 pattern matches
         # 2 patterns match
            # subset overlap
               # distinct
               # intersect
               # same

# files in subdirs
   # matches
   # no matches
       

   

done_testing();

exit 0;
