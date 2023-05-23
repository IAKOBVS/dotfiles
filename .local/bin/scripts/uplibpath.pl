#!/usr/bin/perl
use strict;
use warnings;

# while (my $fnam = glob('*.c *.h *.cpp *.hpp')) {
# 	open(my $fp, '+<', $fnam) or die "Can't open $fnam\n";
# 	while (my $ln = <$fp>) {
# 		# match file in #include file.cpp
# 		if ($ln =~ !/^[ \t]*#[ \t]*include[ \t\/]{1,}"([^"]{1,})"/) {
# 			next;
# 		}
# 		if (-e $1) {
# 			next;
# 		}
# 		my $incl = $1;
# 		# remove leading ../../
# 		$incl =~ s/^[\.\/]{1,}//;
# 		for (my $i = 0;; ++$i) {
# 			$incl = "../$incl";
# 			if (-e $incl) {
# 				printf "%s %s\n", $1, $incl;
# 				$ln =~ s/"$1"/"$incl"/;
# 				print $fp $ln;
# 				last;
# 			}
# 			if ($i == 10) {
# 				print "Couldn't find correct path for $1 in file $fnam\n";
# 				last;
# 			}
# 		}
# 	}
# 	close($fp);
# }
