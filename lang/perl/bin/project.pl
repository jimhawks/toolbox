#!C:\Strawberry\perl\bin\perl.exe
use strict;
use warnings;
use File::Spec;

# Ensure TOOLBOX is defined
my $toolbox_dir = $ENV{'TOOLBOX_DIR'} or die "TOOLBOX_DIR environment variable is not set\n";

# Require at least 2 arguments: <path> <script> [args...]
@ARGV >= 2 or die "Usage: project.pl <path> <script> [args...]\n";

# Extract arguments
my $rel_path = shift @ARGV;  # e.g., someapp/folder1
my $script   = shift @ARGV;  # e.g., run.pl
my @args     = @ARGV;        # everything else

# Build full absolute path to the target script
my $full_path = File::Spec->catfile($toolbox_dir, 'projects', $rel_path, $script);

# Ensure the file exists
die "Script not found: $full_path\n" unless -e $full_path;

# Run it (will create a sub process)
system($full_path, @args);
