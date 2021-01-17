#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;

my $obj = "";
my @arg_list = ();
my @opt_spec = ();

# skip unprocessed options
@arg_list = qw(
);
@opt_spec = qw(
   opt1|a=s
   opt2|b:s
   opt3|c
);
#@ARGV = qw( --opt1=v1 --opt2=v2 --opt3 );
@ARGV = qw( -a=v1 -b= -c );
$obj  = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );

print Dumper( \$obj );

exit 0;

