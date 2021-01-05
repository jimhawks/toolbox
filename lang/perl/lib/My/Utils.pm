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
   get_file_list_for_patterns
   get_filesys_list
   grepi_array
   is_array_cnt_even
   is_array_empty
   is_empty
   is_hash_empty
   is_item_in_array
   is_non_empty
   ltrim
   nvl
   read_file
   remove_array_duplicates
   rtrim
   trim
   verify_dir_exists
   verify_dir_is_readable
   verify_file_exists
   verify_file_is_readable
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

sub get_file_list_for_patterns
{
   my $dir      = nvl( shift, "");
   my @patterns = @_;

   verify_dir_is_readable( $dir );

   my @files = ();
   for (1..30)
   {
      foreach my $pattern( @patterns )
      {
         push( @files, glob "$dir/$pattern" );
      }

      $dir .= "/*";
   }
   @files = remove_array_duplicates( @files );

   return( sort @files );
}

sub get_filesys_list
{
   my $dir = nvl( shift, "");

   verify_dir_is_readable( $dir );

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

sub is_array_empty
{
   my @arr = @_;

   return( $#arr < 0 ? 1 : 0 );
}

sub is_empty
{
   my $str = shift;
   my $rc = ( !defined( $str ) or length( $str ) == 0 ) ? 1 : 0;
   return( $rc );
}

sub is_hash_empty
{
   my %hash = @_;

   return( is_array_empty( keys %hash ) ? 1 : 0 );
}

sub is_item_in_array
{
   my $item = shift;
   my @arr  = @_;

   my $is_found = 0;
   foreach my $element ( @arr )
   {
      if ( defined( $element ) and !defined ( $item ) )
      {
         next;
      }
      elsif ( !defined( $element ) and defined ( $item ) )
      {
         next;
      }

      if ( !defined( $element ) and !defined( $item ) )
      {
         $is_found = 1;
         last;
      }
      elsif ( $element eq $item )
      {
         $is_found = 1;
         last;
      }
   }
   return( $is_found );
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

   verify_file_is_readable( $file );

   open( my $FH, "<", $file ) or confess "ERROR. Cannot open file";
   my @lines = <$FH>;
   close( $FH );

   return( @lines );
}

sub remove_array_duplicates
{
   my @arr = @_;

   my @new_arr = ();
   foreach my $item ( @arr )
   {
      if ( !is_item_in_array( $item, @new_arr ) )
      {
         push( @new_arr, $item );
      }
   }

   return( @new_arr );
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

sub verify_dir_exists
{
   my $dir = nvl( shift, "");

   is_non_empty( $dir ) or confess "ERROR. Dir name is empty";
   -e $dir or confess "ERROR. Dir not found. dir=[$dir]";
   -d $dir or confess "ERROR. Dir is not a dir. dir=[$dir]";
}

sub verify_dir_is_readable
{
   my $dir = nvl( shift, "");

   verify_dir_exists( $dir );

   -r $dir or confess "ERROR. Dir is not readable. dir=[$dir]";
}

sub verify_file_exists
{
   my $file = nvl( shift, "" );

   is_non_empty( $file ) or confess "ERROR. Filename is empty";
   -e $file or confess "ERROR. File not found. file=[$file]";
   -f $file or confess "ERROR. File is not a file. file=[$file]";

}

sub verify_file_is_readable
{
   my $file = nvl( shift, "" );

   verify_file_exists( $file );

   -r $file or confess "ERROR. File is not readable. file=[$file]";
}

1;
