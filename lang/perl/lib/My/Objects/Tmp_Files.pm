package My::Objects::Tmp_Files;

use strict;
use warnings;
use Data::Dumper;

use Carp qw( cluck confess );
use File::Path qw( make_path );

use lib "$FindBin::Bin/../../../../../lib";
use My::Constants qw(
   $TRUE
   $FALSE
);
use My::Utils qw(
   get_home_dir
   is_array_cnt_even
   is_str_non_empty
   nem
   nvl
);


my $SCRIPT_PID   = $$;
my $DEFAULT_DIR  = get_home_dir() . "/.tmp_files";

our $SEQ_NUM = 0;

#===============================================================
#
# class - public
#
#===============================================================

# constructor
sub new
{
   my $class = shift;
   my $self  = { };
   bless $self, $class;

   $self->_init_obj( @_ );

   return $self
}

sub _init_obj 
{
   my $self = shift;

   is_array_cnt_even( @_ ) or die "ERROR. Args is not a hash";

   # get values
   my %args = @_;
   my $dir        = $args{ dir };
   my $tag        = $args{ tag };
   my $keep_files = $args{ keep_files };

   # set values
   $self->_set_dir( nem( $dir, $DEFAULT_DIR ) );
   $self->_set_tag( nvl( $tag, "" ) );
   $self->_set_keep_files_flag( nem( $keep_files, $FALSE ) );
   
   # create dir if needed
   if ( ! -e $self->get_dir() )
   {
      make_path $self->get_dir() 
         or confess "ERROR. Mkpath failed. dir=[" . $self->get_dir() . "]";
   }
}

# destructor
sub DESTROY
{
   my $self = shift;
   $self->_term_obj();
}

sub _term_obj
{
   my $self = shift;
   $self->delete_files( );
}


#===============================================================
#
# instance - public
#
#===============================================================

sub delete_files
{
   my $self = shift;

   foreach my $file ( $self->get_list() )
   {
      if ( -e $file )
      {
         unlink $file or confess "Delete file failed. file=[$file]";
      }
   }

   $self->_empty_list( );
}

sub _empty_list
{
   my $self = shift;
   $self->{ data }->{ files } = [ ];
}

sub get_new_file
{
   my $self = shift;

   $SEQ_NUM++;
   my $formatted_num = sprintf( "%03d", $SEQ_NUM );

   my $name = $self->get_dir()
              . "/" . $SCRIPT_PID
              . ( is_str_non_empty( $self->get_tag() )
                  ? "." . $self->get_tag() : "" )
              . "." . $formatted_num 
              . ".tmp"
              ;

   $self->_add_name_to_list( $name );

   return( $name );
}


#===============================================================
#
# instance - private
#
#===============================================================

sub _add_name_to_list
{
   my $self = shift;
   my $value = shift;

   is_str_non_empty( $value ) or confess "Value is empty";

   push( @{ $self->{ data }->{ files } }, $value );
}


#===============================================================
#
# getters/setters - public
#
#===============================================================

sub get_dir
{
   my $self = shift;
   return( $self->{ data }->{ dir } );
}

sub get_keep_files_flag
{
   my $self = shift;
   return( $self->{ data }->{ keep_files_flag } );
}

sub get_list
{
   my $self = shift;

   if ( !exists( $self->{ data }->{ files } ) )
   {
      $self->{ data }->{ files } = [ ];
   }

   return( @{ $self->{ data }->{ files } } );
}

sub get_tag
{
   my $self = shift;
   return( $self->{ data }->{ tag } );
}


#===============================================================
#
# getters/setters - private
#
#===============================================================

sub _set_dir
{
   my $self = shift;
   my $value = shift;

   is_str_non_empty( $value ) or confess "Value is empty";

   $self->{ data }->{ dir } = $value;
}

sub _set_keep_files_flag
{
   my $self = shift;
   my $value = shift;

   is_str_non_empty( $value ) or confess "Value is empty";
   $value == $TRUE or $value == $FALSE or confess "Invalid value";

   $self->{ data }->{ keep_files_flag } = $value;
}

sub _set_tag
{
   my $self = shift;
   my $value = shift;

   $self->{ data }->{ tag } = $value;
}


1;
