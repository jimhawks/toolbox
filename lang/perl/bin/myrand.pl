#!c:\Strawbery\perl\bin\perl

my $uid_suffix = 1+int(rand(999));
my $bday_mm = 1+int(rand(12));
my $bday_dd = 1+int(rand(28));
my $bday_yyyy = 1960+int(rand(39));

print "uid_suffix: " . $uid_suffix . "\n";
print "bday: " . $bday_mm . "/" . $bday_dd . "/" . $bday_yyyy . "\n";

exit 0;
