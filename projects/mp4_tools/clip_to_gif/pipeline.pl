#!C:\Strawberry\perl\bin\perl.exe

use strict;
use warnings;

use Carp qw(confess);
use File::Basename qw(basename);
use File::Copy qw(move);
use FindBin;

use Data::Dumper;

#use lib "$FindBin::RealBin/../lib";
use lib $ENV{ TOOLBOX_PERL_LIB_DIR };
use My::Utils qw(
    get_file_stem_and_ext
    get_random_5char_code
    clip_mp4_file
    convert_mp4_to_gif
    delete_file
    is_str_empty
    is_str_non_empty

    read_json_file
);


# constants
my $SCRIPT_NM = basename( $0 );

# globals



#------------------------------------------------------------
# 
# main
#
#------------------------------------------------------------

# read the config
my %config = read_json_file( "config.json" );

# validate config values
is_str_non_empty( $config{input_file} ) or confess "ERROR. config field is empty.  field=[input_file]";
is_str_non_empty( $config{clip_start} ) or confess "ERROR. config field is empty.  field=[clip_start]";
is_str_non_empty( $config{clip_end} )   or confess "ERROR. config field is empty.  field=[clip_end]";
-e $config{input_file} or confess "ERROR. config input_file doesnt exist. file=[$config{input_file}]";
$config{clip_start} =~ /^\d{2}:\d{2}:\d{2}\.\d$/ or confess "config clip start is invalid. value=[$config{clip_start}]";
$config{clip_end}   =~ /^\d{2}:\d{2}:\d{2}\.\d$/ or confess "config clip start is invalid. value=[$config{clip_end}]";

# set options for called scripts
my $clip_script_options = "";
if ( $config{run_settings}{keep_work_files} ) {
    $clip_script_options = "--keep-work-files";
}

# build output gif filename from clipping script
my ($mp4_stem, undef) = get_file_stem_and_ext( $config{input_file} );
my $output_gif_file = "$mp4_stem.clipped.gif";

# build renamed gif filename
my $renamed_gif_file = $output_gif_file;
if ( $config{gif_file} ) {
    $renamed_gif_file = $config{gif_file};
}

# append 5char code for uniqueness if seting is turned on
if ( $config{run_settings}{add_5char_code}) {
    my ($stem, $ext) = get_file_stem_and_ext( $renamed_gif_file );
    $renamed_gif_file .= $stem . "." . get_random_5char_code() . "." . $ext;
}

# run script to clip mp4 and convert to gif
system("project.pl",
        "mp4_tools/bin",
        "mp4.clip.to_gif.pl", 
        $config{input_file}, 
        $config{clip_start}, 
        $config{clip_end}
        );

# rename the output gif file 
if ( $renamed_gif_file ne $output_gif_file ) {
    move($output_gif_file, $renamed_gif_file) or confess "ERROR. rename failed. src=[$output_gif_file] copy=[$renamed_gif_file]";
}


exit 0;

