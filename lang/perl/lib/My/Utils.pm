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
   grepi_array
   is_empty
   is_non_empty
   ltrim
   nvl
   read_file
   rtrim
   trim
);

#### tbd
## is_substr_in_strings
## is_substr_not_in_strings
## is_substrs_in_strings
## is_substrs_not_in_strings
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

sub grepi_array
{
   my $strs_ref  = shift;
   my $lines_ref = shift;

   my @empty_array = ();

   $#{ $strs_ref } >= 0 or return( @empty_array );

   my @matching_lines = @{ $lines_ref };
   foreach my $str ( @{ $strs_ref } )
   {
      defined( $str ) or return ( @empty_array );

      my @tmp = ();
      foreach my $line ( @matching_lines )
      {
         if ( !defined( $line ) ) 
         {
            # do nothing
         }
         elsif ( is_empty( $str ) and is_non_empty( $line ) ) 
         {
            # do nothing
         }
         elsif ( is_empty( $str ) and is_empty( $line ) ) 
         {
            push( @tmp, $line );
         }
         elsif ( $line =~ /$str/i )
         {
            push( @tmp, $line );
	 }
      }
      @matching_lines = @tmp;
   }
   return( @matching_lines );
}

sub is_empty
{
    my $str = shift;
    my $rc = ( !defined( $str ) or length( $str ) == 0 ) ? 1 : 0;
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

sub read_file
{
   my $fname = nvl( shift || "" );

   is_non_empty( $fname ) or die "ERROR. Filename is empty";
   -e $fname or die "ERROR. File not found";
   -f $fname or die "ERROR. File is not a file";
   -r $fname or die "ERROR. File is not readable";

   open( my $FH, "<", $fname ) or die "ERROR. Cannot open file";
   my @lines = <$FH>;
   close( $FH );

   return( @lines );
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
