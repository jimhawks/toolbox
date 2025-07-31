package My::Utils;


use strict;
use warnings;
use Data::Dumper;

use feature "state";  # required for state vars

use Carp qw( cluck confess );
use File::Find;
use FindBin;
use Getopt::Long;
use JSON::XS qw( decode_json );

Getopt::Long::Configure( "pass_through" );

use lib "$FindBin::Bin/../../../lib";
use My::Constants qw(
    $TRUE
    $FALSE
);

no warnings "File::Find";

require Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw(
    add_dbg_var
    add_new_lines
    clip_mp4_file
    convert_mp4_to_gif
    delete_file
    does_dir_exist
    does_file_exist
    dump_dbg_vars
    get_cmd_line_args
    get_cmd_line_options
    get_dir_list
    get_file_list
    get_file_list_for_patterns
    get_file_stem_and_ext
    get_home_dir
    get_list_of_colors
    get_list_of_files_and_dirs
    get_list_of_misc_adj
    get_list_of_nasdaq_tickers
    get_list_of_sizes
    get_os_type
    get_random_5char_code
    get_random_birthdate
    get_random_color
    get_random_female_first_name
    get_random_female_full_name
    get_random_last_name
    get_random_male_first_name
    get_random_male_full_name
    get_random_nasdaq_ticker
    get_random_noun
    get_random_number
    get_random_pick_from_list
    get_random_pick_from_list_file
    get_random_size
    get_random_username
    get_recursive_list_of_dirs
    get_recursive_list_of_files
    get_recursive_list_of_files_and_dirs
    get_recursive_list_of_text_files
    grep_str_in_array
    grep_strs_in_array
    grepv_str_in_array
    grepv_strs_in_array
    grepi_array
    is_array_cnt_even
    is_array_empty
    is_dir_readable
    is_file_readable
    is_hash_empty
    is_item_in_array
    is_linux
    is_str_empty
    is_str_non_empty
    is_windows
    ltrim
    nem
    nvl
    read_conf_file
    read_dir
    read_file
    read_hash_file
    read_json_file
    read_list_file
    remove_array_duplicates
    remove_blank_lines
    remove_comment_lines
    rtrim
    substitute_shell_vars_in_array
    substitute_shell_vars_in_str
    touch_files
    trim
    verify_env_var
);

our @female_first_name_list = ();
our @last_name_list         = ();
our @male_first_name_list   = ();

our @color_list             = ();
our @misc_adj_list          = ();
our @noun_list              = ();
our @size_list              = ();
our @ticker_list            = ();

my %dbg_vars = ();

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

sub add_dbg_var
{
    my $grp  = nvl( shift @_, "" );
    my $name = nvl( shift @_, "" );
    my $ref  = shift @_;

    nem( $grp )  or confess "ERROR. grp is empty";
    nem( $name ) or confess "ERROR. name is empty";
    nem( $ref )  or confess "ERROR. ref is empty";

    $dbg_vars{ $grp }{ $name } = $ref;
}

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

sub clip_mp4_file
{
   my ($mp4_file, $clip_start, $clip_end) = @_;

   # decompose mp4 filename into stem and ext
   my @parts = split(/\./, $mp4_file);
   my $file_ext = pop @parts // "";
   my $file_stem = join(".", @parts);

   #verify its an mp4 file
   (is_str_non_empty($file_ext) and $file_ext eq "mp4") or confess "ERROR. extension is not mp4. ext=[$file_ext]";

   # build output filename
   my $clipped_mp4_file = "$file_stem.clipped.mp4";

   # remove files
   ! -e $clipped_mp4_file or delete_file($clipped_mp4_file);

   #run clipping command
   my $cmd = "ffmpeg"
            . " -i $mp4_file"
            . " -ss $clip_start -to $clip_end"
            . ' -vf "fps=30,scale=1280:-2" -c:v libx264 -preset veryfast -crf 18'
            . " -c:a aac -b:a 128k"
            . " $clipped_mp4_file"
            ;
   system($cmd);

   return($clipped_mp4_file);
}

sub convert_mp4_to_gif
{
   my ($mp4_file, $clip_start, $clip_end) = @_;

   my $palette_file = "palette.png";

   # decompose mp4 filename into stem and ext
   my @parts = split(/\./, $mp4_file);
   my $file_ext = pop @parts // "";
   my $file_stem = join(".", @parts);

   # verify its an mp4 file
   (is_str_non_empty($file_ext) and $file_ext eq "mp4") or confess "ERROR. extension is not mp4. ext=[$file_ext]";

   # build output filename
   my $gif_file = "$file_stem.gif";

   # remove files
   ! -e $gif_file     or delete_file($gif_file);
   ! -e $palette_file or delete_file($palette_file);

   # run cmd to get the palette
   my $palette_cmd = "ffmpeg"
            . " -i $mp4_file"
            . ' -vf "fps=15,scale=640:-1:flags=lanczos,palettegen"'
            . " $palette_file"
            ;
   system($palette_cmd);

   # run cmd to do conversion to gif
   my $conversion_cmd = "ffmpeg"
            . " -i $mp4_file"
            . " -i $palette_file"
            . ' -filter_complex "fps=15,scale=640:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5"'
            . " $gif_file"
            ;
   system($conversion_cmd);

   delete_file($palette_file);

   return($gif_file);
}

sub delete_file
{
   my $file  = shift // ""; 
   is_str_non_empty($file) or confess "ERROR. Filename is empty";
   unlink $file or confess "ERROR.  Delete file failed. file=[$file]"
}

sub does_dir_exist
{
    my $dir = nvl( shift, "");

    is_str_non_empty( $dir ) or return 0;
    -e $dir or return 0;
    -d $dir or return 0;

    return 1;
}

sub does_file_exist
{
    my $file = nvl( shift, "" );

    is_str_non_empty( $file ) or return 0;
    -e $file or return 0;
    -f $file or return 0;

    return 1;
}

sub dump_dbg_vars
{
    print Dumper( \%dbg_vars );
}

sub get_cmd_line_args
{
    my @arg_spec = @_;
    my %arg_vals = ();

    foreach my $spec ( @arg_spec )
    {
       # if spec has "@" on the end
       if ( $spec =~ /\@$/ )
       {
          # remove the "@" and copy remaining argv to value
          $spec =~ s/\@$//;
          @{ $arg_vals{ $spec } } = @ARGV;
          last;
       }
       $arg_vals{ $spec } = nvl( shift @ARGV, "" );
    }

    return( %arg_vals );
}

sub get_cmd_line_options
{
    # desc:   Get options from cmd line
    # input:  [array] options spec array
    # output: [hash] hash of options

    my @options_spec = @_;
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
          #    <modifier>
          #       @   array e.g. file=s@
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
    GetOptions( \%options, @options_spec ) or confess "ERROR... get options failed.";

    return( %options );
}

sub get_dir_list
{
    my @filesys_list = get_list_of_files_and_dirs( @_ );

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
    my @filesys_list = get_list_of_files_and_dirs( @_ );

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

    is_dir_readable( $dir );

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

sub get_file_stem_and_ext
{
    my $file = shift // "";

    my @parts = split(/\./, $file);
    my $ext = pop @parts // "";
    my $stem = join(".", @parts);

    return ($stem, $ext);
}

sub get_home_dir
{
    my $dir = "";
    if ( is_windows() )
    {
       $dir = $ENV{ USERPROFILE };
    }
    elsif ( is_linux() )
    {
       $dir = $ENV{ HOME };
    }

    return( $dir );
}

sub get_list_of_colors
{
    if ( is_array_empty( @color_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/colors.txt";
       @color_list = read_list_file( $file );
    }
    
    return( @color_list );
}

sub get_list_of_files_and_dirs
{
    my $dir = nvl( shift, "");

    is_dir_readable( $dir );

    @_gfl_file_list = ();
    find( { wanted => \&_gfl_wanted }, $dir );

    return( sort @_gfl_file_list );
}

sub get_list_of_misc_adj
{
    if ( is_array_empty( @misc_adj_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/adj.misc.txt";
       @color_list = read_list_file( $file );
    }
    
    return( @misc_adj_list );
}

sub get_list_of_nasdaq_tickers
{
    if ( is_array_empty( @ticker_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/nasdaq_ticker_symbols.txt";
       my @tmp = read_list_file( $file );
       shift @tmp;  # shift off the header
       my @tmp2 = ();
       foreach my $line ( sort @tmp )
       {
          my ( $ticker, undef ) = split( /,/, $line );
          push( @ticker_list, $ticker );
       }
    }
    
    return( @ticker_list );
}

sub get_list_of_sizes
{
    if ( is_array_empty( @size_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/sizes.txt";
       @size_list = read_list_file( $file );
    }
    
    return( @size_list );
}

sub get_os_type
{
    my $os = lc( $^O );

    my $type = "";
    if ( $os eq "mswin32" )
    {
       $type = "windows";
    }
    elsif ( $os eq "linux" )
    {
       $type = "linux";
    }
    else
    {
       $type = "unknown";
    }

    return( $type );
}

sub get_random_5char_code
{
    my @chars = ('A'..'Z', '0'..'9');
    my $code = join '', map { $chars[rand @chars] } 1..5;
    return $code;
}

sub get_random_birthdate
{
    my $date = get_random_number( 1965, 2002 )
               . "-" . sprintf( "%02d", get_random_number( 1, 12 ) )
               . "-" . sprintf( "%02d", get_random_number( 1, 28 ) )
               ;
    return( $date );
}

sub get_random_color
{
    my @list = get_list_of_colors();
    return( get_random_pick_from_list( @list ) );
}

sub get_random_female_first_name
{
    if ( is_array_empty( @female_first_name_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/names.first.female.txt";
       @female_first_name_list = read_list_file( $file );
    }
    
    return( get_random_pick_from_list( @female_first_name_list ) );
}

sub get_random_female_full_name
{
    my $name = get_random_female_first_name()
               . " " .  get_random_last_name();
    
    return( $name );
}

sub get_random_last_name
{
    if ( is_array_empty( @last_name_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/names.last.txt";
       @last_name_list = read_list_file( $file );
    }
    
    return( get_random_pick_from_list( @last_name_list ) );
}

sub get_random_male_first_name
{
    if ( is_array_empty( @male_first_name_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/names.first.male.txt";
       @male_first_name_list = read_list_file( $file );
    }
    
    return( get_random_pick_from_list( @male_first_name_list ) );
}

sub get_random_male_full_name
{
    my $name = get_random_male_first_name()
               . " " .  get_random_last_name();
    
    return( $name );
}

sub get_random_nasdaq_ticker
{
    my @list = get_list_of_nasdaq_tickers();
    return( get_random_pick_from_list( @list ) );
}

sub get_random_noun
{
    if ( is_array_empty( @noun_list ) )
    {
       my $file = "$ENV{ TLBX_DATA }/nouns.things.txt";
       @noun_list = read_list_file( $file );
    }
    
    return( get_random_pick_from_list( @noun_list ) );
}

sub get_random_number
{
    my @args = @_;

    my $min = 0;
    my $max = 0;

    $#args >= 0 or confess "ERROR. missing args";

    # get args
    if ( $#args == 0 )
    {
       $min = 0;
       $max = int( $args[ 0 ] );
    }
    elsif ( $#args == 1 )
    {
       $min = int( $args[ 0 ] );
       $max = int( $args[ 1 ] );
    }

    # error checking
    $min >= 0    or confess "ERROR. Min is negative";
    $max >= 0    or confess "ERROR. Max is negative";
    $min <= $max or confess "ERROR. Max is less than min";

    # special conditions
    if ( $max == 0 )
    {
       return( 0 );
    }
    elsif ( $min == $max )
    {
       return( $min );
    }

    # get the number
    my $num = int( rand( $max - $min + 1 ) + $min );

    return( $num );
}

sub get_random_pick_from_list
{
    my @list = @_;

    my $item = $list[ get_random_number( 0, $#list ) ];

    return( $item );
}

sub get_random_pick_from_list_file
{
    my $file = nvl( shift, "" );
    
    chomp( my @list = read_file( $file ) );
    my $item = $list[ get_random_number( 0, $#list ) ];

    return( $item );
}

sub get_random_size
{
    my @list = get_list_of_sizes();
    return( get_random_pick_from_list( @list ) );
}

sub get_random_username
{
    my @adj = ( 
                 get_list_of_colors(), 
                 get_list_of_sizes(),
                 get_list_of_misc_adj(),
              );
    my $name = get_random_pick_from_list( @adj )
               . "_" . get_random_noun()
               . "_" . get_random_number(11, 50)
               ;

    return( $name );
}

sub get_recursive_list_of_dirs
{
    my @tmp = get_recursive_list_of_files_and_dirs( @_ );

    my @list = ();
    foreach my $item ( @tmp )
    {
       if ( -d $item )
       {
          push( @list, $item );
       }
    }

    return( sort @list );
}

sub get_recursive_list_of_files
{
    my @tmp = get_recursive_list_of_files_and_dirs( @_ );

    my @list = ();
    foreach my $item ( @tmp )
    {
       if ( -f $item )
       {
          push( @list, $item );
       }
    }

    return( sort @list );
}

sub get_recursive_list_of_files_and_dirs
{
    my %args = @_;

    my $dir = nvl( $args{ dir }, "");
    my @patterns = @{ nvl( $args{ patterns }, [ "*" ] ) };

    is_dir_readable( $dir );

    my @list = ();
    push( @list, $dir );

    # process dirs 
    foreach my $item ( read_dir( $dir ) )
    {
       my $fpath = "$dir/$item";
       if ( -d $fpath )
       {
          my @tmp = get_recursive_list_of_files_and_dirs( 
             dir      => $fpath,
             patterns => \@patterns,
          );
          push( @list, @tmp );
       }
    }

    # process files
    foreach my $pattern ( @patterns )
    {
       foreach my $item ( glob "$dir/$pattern" )
       {
          if ( -f $item )
          {
             push( @list, $item );
          }
       }
    }

    return( sort @list );
}

sub get_recursive_list_of_text_files
{
    my @tmp = get_recursive_list_of_files_and_dirs( @_ );

    my @list = ();
    foreach my $item ( @tmp )
    {
       if ( -f $item and -T $item)
       {
          push( @list, $item );
       }
    }

    return( sort @list );
}

sub grep_str_in_array
{
    my %args = @_;

    my $str         = nvl( $args{ str }, "" );
    my @arr         = @{ nvl( $args{ array }, [ ] ) };
    my $ignore_case = nvl( $args{ ignore_case }, 0 );

    is_str_non_empty( $str ) or confess "str is empty";

    my @output = ();
    if ( $ignore_case )
    {
       push( @output, grep( /$str/i, @arr ) );
    }
    else
    {
       push( @output, grep( /$str/, @arr ) );
    }

    return( @output );
}

sub grep_strs_in_array
{
    my %args = @_;

    my @strs        = @{ nvl( $args{ strs },  [ ] ) };
    my @arr         = @{ nvl( $args{ array }, [ ] ) };
    my $ignore_case = nvl( $args{ ignore_case }, 0 );

    foreach my $str ( @strs )
    {
       my @tmp = grep_str_in_array(
          str         => $str,
          array       => \@arr,
          ignore_case => $ignore_case,
       );
       @arr = @tmp;
       if ( $#arr < 0 ) 
       {
          last;
       }
    }

    return( @arr );
}

sub grepv_str_in_array
{
    my %args = @_;

    my $str         = nvl( $args{ str }, "" );
    my @arr         = @{ nvl( $args{ array }, [ ] ) };
    my $ignore_case = nvl( $args{ ignore_case }, 0 );

    is_str_non_empty( $str ) or confess "str is empty";

    my @output = ();
    if ( $ignore_case )
    {
       push( @output, grep( !/$str/i, @arr ) );
    }
    else
    {
       push( @output, grep( !/$str/, @arr ) );
    }

    return( @output );
}

sub grepv_strs_in_array
{
    my %args = @_;

    my @strs        = @{ nvl( $args{ strs },  [ ] ) };
    my @arr         = @{ nvl( $args{ array }, [ ] ) };
    my $ignore_case = nvl( $args{ ignore_case }, 0 );

    foreach my $str ( @strs )
    {
       my @tmp = grepv_str_in_array(
          str         => $str,
          array       => \@arr,
          ignore_case => $ignore_case,
       );
       @arr = @tmp;
       if ( $#arr < 0 ) 
       {
          last;
       }
    }

    return( @arr );
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
          elsif ( is_str_empty( $str ) and is_str_non_empty( $line ) ) 
          {
             # do nothing
          }
          elsif ( is_str_empty( $str ) and is_str_empty( $line ) ) 
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

sub is_dir_readable
{
    my $dir = shift;

    does_dir_exist( $dir ) or return 0;
    -r $dir or return 0;

    return 1;
}

sub is_file_readable
{
    my $file = shift;

    does_file_exist( $file ) or return 0;
    -r $file or return 0;

    return 1;
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

sub is_linux
{
    return( get_os_type() eq "linux" ? 1 : 0 );
}

sub is_str_empty
{
    my $str = shift;
    my $rc = ( !defined( $str ) or length( $str ) == 0 ) ? 1 : 0;
    return( $rc );
}

sub is_str_non_empty
{
    my $str = shift;
    my $rc = ( defined( $str ) and length( $str ) > 0 ) ? 1 : 0;
    return( $rc );
}

sub is_windows
{
    return( get_os_type() eq "windows" ? 1 : 0 );
}

sub ltrim
{
    my $str = nvl( shift, "" );
    is_str_non_empty( $str ) or return "";
    $str =~ s/^\s+//;
    return( $str );
}

sub nem
{
    my $val     = shift;
    my $default = shift;
    return( is_str_non_empty( $val ) ? $val : $default );
}

sub nvl
{
    my $val     = shift;
    my $default = shift;
    return( defined( $val ) ? $val : $default );
}

sub read_conf_file
{
    return( read_hash_file( @_ ) );
}

sub read_dir
{
    my $dir = nvl( shift, "" );
    opendir( my $DH, $dir ) or confess "ERROR. Open dir failed. dir=[$dir]";
    my @list = ();
    while( my $f = readdir( $DH ) )
    {
       if ( $f eq "." or $f eq ".." )
       {
          next;
       }
       push( @list, $f );
    }
    close( $DH );
    return( @list );
}

sub read_file
{
    my $file = nvl( shift, "" );

    is_file_readable( $file );

    open( my $FH, "<", $file ) or confess "ERROR. Cannot open file";
    my @lines = <$FH>;
    close( $FH );

    return( @lines );
}

sub read_hash_file
{
    # Expected format of file.
    #
    # The file will contain a hash ref.
    #
    # example file:
    # {
    #    log_dir  => "/dir1/dir2",
    #    max_logs => 5,
    # }
    #
    my $file = shift;

    is_file_readable( $file );
    my $href = do $file;
    $href = nvl( $href, { } );

    return( $href );
}

sub read_json_file {
    my $file = nvl( shift, "" );

    is_file_readable( $file );

    open( my $FH, "<", $file ) or confess "ERROR. Cannot open file";
    my @lines= <$FH>;
    close( $FH );

    my $str = join('', @lines);
    my $json_ref = decode_json( $str );
    my %json_hash = %{ $json_ref };

    return( %json_hash );
}

sub read_list_file
{
    my $file = nvl( shift, "" );

    chomp( my @list = read_file( $file ) );
    @list = remove_blank_lines( remove_comment_lines( @list ) );

    return( @list );
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

sub remove_blank_lines
{
    my @lines = @_;

    my @tmp = ();
    foreach my $line ( @lines )
    {
       if ( $line =~ /^ *$/ )
       {
          next;
       }
       push( @tmp, $line );
    }

    return( @tmp );
}

sub remove_comment_lines
{
    my @lines = @_;

    my @tmp = ();
    foreach my $line ( @lines )
    {
       if ( $line =~ /^ *#/ )
       {
          next;
       }
       push( @tmp, $line );
    }

    return( @tmp );
}

sub rtrim
{
    my $str = nvl( shift, "" );
    is_str_non_empty( $str ) or return "";
    $str =~ s/\s+$//;
    return( $str );
}

sub substitute_shell_vars_in_array
{
    my @arr = @_;

    my @arr2 = ();
    foreach my $str ( @arr )
    {
        my $str2 = substitute_shell_vars_in_str( $str );
        push( @arr2, $str2 );
    }

    return( @arr2 );
}

sub substitute_shell_vars_in_str
{
    my $str = nvl( shift, "" );
    $str =~ s/\$(\w+)/$ENV{$1}/g;
    return( $str );
}

sub touch_files
{
    my @list = @_;
    foreach my $file ( @list )
    {
        open( my $FH, ">>", $file ) or confess "Open failed. file=[$file]";
        close( $FH );
    }
}

sub trim
{
    return( rtrim( ltrim( @_ ) ) );
}

sub verify_env_var
{
    my $var = shift // "";
    is_str_non_empty( $var ) or confess "ERROR. Env var name is empty";
    is_str_non_empty( $ENV{ $var } ) or confess "ERROR. Env var is not defined. var=[$var]";
}


1;
