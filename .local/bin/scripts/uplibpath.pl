#!/usr/bin/perl
use strict;
use warnings;

my $incl;
my $oincl;
foreach my $file (glob('*.c *.h *.cpp *.hpp')) {
	if (!-d || !-f) {
		next;
	}
	rename($file, "$file.bak") or die "Can't rename $file to $file.bak\n";
	open(my $old, '<', "$file.bak") or die "Can't open $file.bak\n";
	open(my $new, '>', $file) or die "Can't open $file";
	while (my $ln = <$old>) {
		# capture header.h in #include "header.h"
		if ($ln =~ !/^[ \t]*#[ \t]*include[ \t\/]{1,}"([^"]{1,})"/) {
			goto PRINT_LINE;
		}
		$oincl = $1;
		if (-e $oincl) {
			goto PRINT_LINE;
		}
		$incl = $oincl;
		# removes leading ../../
		$incl =~ s/^[\/\.]{1,}//;
		print "$incl\n";
		for (my $max = 8; $max; $max--) {
			$incl = "../$incl";
			if (-e $incl) {
				$ln =~ s?$oincl?$incl?;
				print "Corrected $oincl to $incl in $file\n\n";
				last;
			}
		}
PRINT_LINE:
		print $new $ln;
	}
	close($old);
	unlink("$file.bak");
	close($new);
}
