#!/usr/bin/perl
use strict;
use warnings;

foreach my $file (glob('*.c *.h *.cpp *.hpp')) {
	rename($file, "$file.bak") or die "Can't rename $file to $file.bak\n";
	open(my $old, '<', "$file.bak") or die "Can't open $file.bak\n";
	open(my $new, '>', $file) or die "Can't open $file";
	while (my $ln = <$old>) {
		if ($ln =~ /^[ \t]*#[ \t]*include[ \t\/]{1,}"([^"]{1,})"/) {
			my $oincl = $1;
			if (!-e $oincl) {
				my $incl = $oincl;
				$incl =~ s/^[\/\.]{1,}//;
				print "$incl\n";
				for (my $max = 8; $max; $max--) {
					$incl = "../$incl";
					if (-e $incl) {
						$ln =~ s/$oincl/$incl/;
						print $ln;
						print "Corrected $oincl to $incl in $file\n\n";
						last;
					}
				}
			}
		}
		print $new $ln;
	}
	close($old);
	unlink("$file.bak");
	close($new);
}
