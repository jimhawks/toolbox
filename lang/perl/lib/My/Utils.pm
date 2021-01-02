package My::Utils;

use strict;
use warnings;

use Carp qw( cluck confess );
use File::Find;
use Getopt::Long;
Getopt::Long::Configure( "pass_through" );

no warnings "File::Find";

require Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw(
   add_new_lines
   get_cmd_line_options
   get_dir_list
   get_file_list
   get_filesys_list
   grepi_array
   is_array_cnt_even
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
# write_file_new
# write_file_append
# get_filesys_list_using_unxutils

#===============================================================
#
# private
#
#===============================================================

my @_gfl_file_list = ();

sub _gfl_wanted
{
   push( @_gfl_file_list, $File::Find::name );
}

#===============================================================
#
# public
#
#===============================================================

sub add_new_lines
{
   # desc:   Add newline to each string in an array
   # input:  [array] array of strings
   # output: [array] array of strings

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
   # desc:   Get options from cmd line
   # input:  [array] options spec array
   # output: [hash] hash of options

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

sub get_dir_list
{
   my @filesys_list = get_filesys_list( @_ );

   my @dir_list = ();
   foreach my $item ( @filesys_list )
   {
      if ( -d $item )
      {
         push( @dir_list, $item );
      }
   }

   return( @dir_list );
}

sub get_file_list
{
   my @filesys_list = get_filesys_list( @_ );

   my @file_list = ();
   foreach my $item ( @filesys_list )
   {
      if ( -f $item )
      {
         push( @file_list, $item );
      }
   }

   return( @file_list );
}

sub get_filesys_list
{
   my $dir = nvl( shift, "");

   is_non_empty( $dir ) or die "ERROR. Dir name is empty";
   -e $dir or die "ERROR. Dir not found. dir=[$dir]";
   -d $dir or die "ERROR. Dir is not a dir. dir=[$dir]";
   -r $dir or die "ERROR. Dir is not readable. dir=[$dir]";

   @_gfl_file_list = ();
   find( { wanted => \&_gfl_wanted }, $dir );

   return( sort @_gfl_file_list );
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

sub is_array_cnt_even
{
   my @arr = @_;

   my $cnt = ($#arr) + 1;
   return( $cnt % 2 == 0 ? 1 : 0 );
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
   return( defined( $val ) ? $val : $default );
}

sub read_file
{
   my $file = nvl( shift, "" );

   is_non_empty( $file ) or die "ERROR. Filename is empty";
   -e $file or die "ERROR. File not found. file=[$file]";
   -f $file or die "ERROR. File is not a file. file=[$file]";
   -r $file or die "ERROR. File is not readable. file=[$file]";

   open( my $FH, "<", $file ) or die "ERROR. Cannot open file";
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
