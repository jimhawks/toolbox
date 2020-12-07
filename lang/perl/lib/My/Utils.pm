package My::Utils;

use strict;
use warnings;

use Carp qw( cluck confess );

use Getopt::Long;
Getopt::Long::Configure( "pass_through" );

require Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw(
    isEmpty
    isNonEmpty
	ltrim
    nvl
	rtrim
	trim
);

#todo
#   trim


sub isEmpty
{
    my $rc = isNonEmpty( @_ ) ? 0 : 1;
    return( $rc );
}

sub isNonEmpty
{
    my $str = shift;
    my $rc = ( defined( $str ) and length( $str ) > 0 ) ? 1 : 0;
    return( $rc );
}

sub getCmdLineOptions
{
   my @optionsSpec = @_;
         # url:  https://perldoc.perl.org/Getopt::Long
         #
         # summary
         #    format:  <option>[ <required><type> ]
         #
         #    <option>
         #    <required>
         #       :   value is optional
         #       =   value is required
         #    <type>
         #       s   string
         #       i   integer
         #       f   float
         #
         #    examples:
         #       "debug_on"    --debug_on
         #                         debug_on will be set to 1
         #       "log:s"       --log
         #                         "s" was optional.  "log" will be set to 1
         #                     --log=other.log
         #                         "log" is set to "other.log"
         #       "port=i"      --port=80
         #                         "i" is required.  "port" is set to 80.
         #

   my %options = ();

   GetOptions( \%options, @optionsSpec ) or confess "ERROR... get options failed.";

   return( %options );
}

sub ltrim
{
   my $str = nvl( shift, "" );
   isNonEmpty( $str ) or return "";
   $str =~ s/^\s+//;
   return( $str );
}

sub nvl
{
   my $val     = shift;
   my $default = shift;
   return( isNonEmpty( $val ) ? $val : $default );
}

sub rtrim
{
   my $str = nvl( shift, "" );
   isNonEmpty( $str ) or return "";
   $str =~ s/\s+$//;
   return( $str );
}

sub trim
{
   return( rtrim( ltrim( @_ ) ) );
}

1;
