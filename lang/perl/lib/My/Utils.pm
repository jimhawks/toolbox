package My::Utils;

use strict;
use warnings;

use Carp qw( cluck confess );

use Getopt::Long;
Getopt::Long::Configure( "pass_through" );

require Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw(
   add_new_lines
   get_cmd_line_options
   is_empty
   is_non_empty
   ltrim
   nvl
   rtrim
   trim
);

#### tbd
# is_substr_in_strings
# is_substr_not_in_strings
# is_substrs_in_strings
# is_substrs_not_in_strings
# read_file
# write_file_new
# write_file_append
# get_list_of_files
# get_list_of_files_using_unxutils

sub add_new_lines
{
   my @arr = @_;
   if ( $#arr >= 0 )
   {
      foreach my $line ( @arr )
      {
         if ( defined( $line ) )
	 {
            $line .= "\n";
         }
      }
   }
   return( @arr );
}

sub get_cmd_line_options
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

sub is_empty
{
    my $rc = is_non_empty( @_ ) ? 0 : 1;
    return( $rc );
}

sub is_non_empty
{
    my $str = shift;
    my $rc = ( defined( $str ) and length( $str ) > 0 ) ? 1 : 0;
    return( $rc );
}

sub ltrim
{
   my $str = nvl( shift, "" );
   is_non_empty( $str ) or return "";
   $str =~ s/^\s+//;
   return( $str );
}

sub nvl
{
   my $val     = shift;
   my $default = shift;
   return( is_non_empty( $val ) ? $val : $default );
}

sub rtrim
{
   my $str = nvl( shift, "" );
   is_non_empty( $str ) or return "";
   $str =~ s/\s+$//;
   return( $str );
}

sub trim
{
   return( rtrim( ltrim( @_ ) ) );
}

1;
