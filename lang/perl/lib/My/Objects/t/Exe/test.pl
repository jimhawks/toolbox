#!/usr/bin/perl -d

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;

my $obj = "";
my %exp = ();
my %got = ();

my @exp_argv = ();

my @opt_spec = ();
my @arg_list = ();

# skip unprocessed options
@arg_list = qw(
   arg1
   arg2
);
@opt_spec = qw(
   opt1=s
);
@ARGV = qw(
   -opt1=value1
   -opt2=value2
   str1
   str2
   str3
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => "str2",
);
@exp_argv = ( "str3" );

exit 0;

