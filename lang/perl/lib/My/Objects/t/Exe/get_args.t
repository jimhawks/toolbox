#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use Test::More;
use Test::Exception;

use FindBin;
use File::Basename;

use lib "$FindBin::Bin/../../../../../lib";
use My::Objects::Exe;

my $SCRIPT = basename( $0 );
my $DATA_DIR = $FindBin::Bin . "/" . ${SCRIPT} . ".data";

###############################################################
#
# tests
#
###############################################################

my $obj = "";
my %exp = ();
my %got = ();

my @exp_argv = ();

my @opt_spec = ();
my @arg_list = ();


# empty new
@ARGV = qw(
   str1
   str2
);
$obj  = new My::Objects::Exe( );
%got  = $obj->get_args();
%exp  = ();
@exp_argv = qw(
   str1
   str2
);
is_deeply( \%got,  \%exp,      "empty new. obj" );
is_deeply( \@ARGV, \@exp_argv, "empty new. argv" );


# new, even numbered array.
@ARGV = qw(
   str1
   str2
);
$obj  = new My::Objects::Exe( 1, 2 );
%got  = $obj->get_args();
%exp  = ();
@exp_argv = qw(
   str1
   str2
);
is_deeply( \%got,  \%exp,      "new, even numbered array. obj" );
is_deeply( \@ARGV, \@exp_argv, "new, even numbered array. argv" );


# hash, no matching keys.
@ARGV = qw(
    str1
    str2
);
$obj  = new My::Objects::Exe( k1 => "v1" );
%got  = $obj->get_args();
%exp  = ();
@exp_argv = qw(
    str1
    str2
);
is_deeply( \%got,  \%exp,      "hash, no matching keys. obj." );
is_deeply( \@ARGV, \@exp_argv, "hash, no matching keys. argv" );


# empty arg_list, empty args
@arg_list = ();
@ARGV = ();
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = ();
@exp_argv = ();
is_deeply( \%got,  \%exp,      "empty arg_list, empty args. obj" );
is_deeply( \@ARGV, \@exp_argv, "empty arg_list, empty args. argv" );


# empty arg_list, nonempty args
@arg_list = ();
@ARGV = qw(
   str1
   str2
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = ();
@exp_argv = qw(
   str1
   str2
);
is_deeply( \%got,  \%exp,      "empty arg_list, nonempty args. obj" );
is_deeply( \@ARGV, \@exp_argv, "empty arg_list, nonempty args. argv" );


# nonempty arg_list, empty args
@arg_list = qw(
   arg1
   arg2
);
@ARGV = ();
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => "",
   arg2 => "",
);
@exp_argv = ();
is_deeply( \%got,  \%exp,      "nonempty arg_list, empty args. obj" );
is_deeply( \@ARGV, \@exp_argv, "nonempty arg_list, empty args. argv" );


# arg_list > args
@arg_list = qw(
   arg1
   arg2
);
@ARGV = qw(
   str1
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => "",
);
@exp_argv = ();
is_deeply( \%got,  \%exp,      "arg_list > args. obj" );
is_deeply( \@ARGV, \@exp_argv, "arg_list > args. argv" );


# arg_list == args
@arg_list = qw(
   arg1
   arg2
);
@ARGV = qw(
   str1
   str2
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => "str2",
);
@exp_argv = ();
is_deeply( \%got,  \%exp,      "arg_list == args. obj" );
is_deeply( \@ARGV, \@exp_argv, "arg_list == args. argv" );


# arg_list < args
@arg_list = qw(
   arg1
   arg2
);
@ARGV = qw(
   str1
   str2
   str3
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => "str2",
);
@exp_argv = qw(
   str3
);
is_deeply( \%got,  \%exp,      "arg_list < args. obj" );
is_deeply( \@ARGV, \@exp_argv, "arg_list < args. argv" );


# 1 arg, array arg
@arg_list = qw(
   @arg1
);
@ARGV = qw(
   str1
   str2
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => [ "str1", "str2" ],
);
@exp_argv = ();
is_deeply( \%got,  \%exp,      "1 arg, array arg. obj" );
is_deeply( \@ARGV, \@exp_argv, "1 arg, array arg. argv" );


# 2 args, 2nd is array arg 
@arg_list = qw(
   arg1
   @arg2
);
@ARGV = qw(
   str1
   str2
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => [ "str2" ],
);
@exp_argv = ();
is_deeply( \%got,  \%exp,      "2 args, 2nd is array arg. obj" );
is_deeply( \@ARGV, \@exp_argv, "2 args, 2nd is array arg. argv" );


# 3 args, array arg is 2nd
@arg_list = qw(
   arg1
   @arg2
   arg3
);
@ARGV = qw(
   str1
   str2
   str3
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => [ "str2", "str3" ],
);
@exp_argv = ();
is_deeply( \%got,  \%exp,      "3 args, 2nd is array arg. obj" );
is_deeply( \@ARGV, \@exp_argv, "3 args, 2nd is array arg. argv" );


# cmd line has opts and args
@arg_list = qw(
   arg1
   arg2
);
@ARGV = qw(
   -opt1=value1
   -opt2=value2
   str1
   str2
   str3
);
$obj  = new My::Objects::Exe( arg_list => \@arg_list );
%got  = $obj->get_args();
%exp  = (
   arg1 => "str1",
   arg2 => "str2",
);
@exp_argv = ( "str3" );
is_deeply( \%got,  \%exp,      "cmd line has opts and args. obj" );
is_deeply( \@ARGV, \@exp_argv, "cmd line has opts and args. argv" );


done_testing();

exit 0;
