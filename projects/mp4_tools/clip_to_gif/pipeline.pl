#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use Carp qw(confess);
use File::Basename qw(basename);
use File::Copy qw(move);
use FindBin;
use Getopt::Long;

use Data::Dumper;

#use lib "$FindBin::RealBin/../lib";
use lib $ENV{ TOOLBOX_PERL_LIB_DIR };
use My::Utils qw(
    flatten_filename
    get_file_stem
    get_file_stem_and_ext
    get_random_5char_code
    is_str_empty
    is_str_non_empty
    read_json_file
);


# constants
my $SCRIPT_NM = basename( $0 );

# globals
my $debug   = 0;
my $dry_run = 0;


#------------------------------------------------------------
# 
# main
#
#------------------------------------------------------------

# get cmd line options
GetOptions(
    'debug'   => \$debug,
    'dry-run' => \$dry_run,
) or die "Usage: $SCRIPT_NM [--debug] [--dry-run] [<config_file>]\n";

# debug: output options
if ( $debug ) {
    print "$SCRIPT_NM - options\n";
    print "  --debug   = [$debug]\n";
    print "  --dry-run = [$dry_run]\n";
}

# get args
my $config_file = shift @ARGV // "config.json";

# debug: output inputs
if ( $debug ) {
    print "$SCRIPT_NM - inputs: \n";
    print "    config_file = [$config_file]\n";
    # exit 0;
}

# read the config
my %config = read_json_file( $config_file );

# debug: output config
if ( $debug ) {
    print "$SCRIPT_NM - config\n";
    print Dumper( \%config );
    # exit 0;
}

# validate config values
is_str_non_empty( $config{mp4_file} ) 
    or confess "ERROR. config field is empty.  field=[mp4_file]";

# copy config values to local vars for easier reading
my $mp4_file   = $config{ mp4_file };
my $clip_start = $config{ clip_start } // "";
my $clip_end   = $config{ clip_end }   // "";
my $gif_file   = $config{ gif_file }   // "";

# assign defaults
if ( is_str_empty( $gif_file ) ) {
    $gif_file = get_file_stem( $mp4_file ) . ".clipped.gif";
}

# append 5char code for uniqueness if seting is turned on
if ( $config{run_settings}{add_5char_code} ) {
    my ($stem, $ext) = get_file_stem_and_ext( $gif_file );
    $gif_file = $stem . "." . get_random_5char_code() . "." . $ext;
}

# run script to clip mp4 and convert to gif
my @cmd = (
    "project.pl",
    "mp4_tools/bin",
    "mp4.clip.to_gif.pl", 
    #"--debug",
    #"--dry-run",
    $mp4_file, 
    $clip_start, 
    $clip_end,
    $gif_file
);

# debug: print system cmd
if ( $debug ) {
    print "$SCRIPT_NM - system cmd\n";
    print Dumper( \@cmd );
    # exit 0;
}

# run cmd
if ( ! $dry_run ) {
    system( @cmd );
}

exit 0;

