#!/usr/bin/perl -d

use strict;
use warnings;
use Data::Dumper;

use FindBin;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;
use My::Objects::Password_Generator;

my $exe = "";
my @arg_list = qw(
   arg1
   arg2
);
my @opt_spec = qw(
   =s
);

$obj  = new My::Objects::Exe( arg_list => \@arg_list, opt_spec => \@opt_spec );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => "str2",
);
@exp_argv = ( "str3" );

exit 0;

