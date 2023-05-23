#DO NOT USE (BROKEN)

##!/usr/bin/perl
#use strict;
#use warnings;

#while (my $fnam = glob('*.c *.h *.cpp *.hpp')) {
#	open(my $fp, '+<', $fnam) or die "Can't open $fnam\n";
#	while (<$fp>) {
#		# match file in #include file.cpp
#		if (!/^[ \t]*#[ \t]*include[ \t\/]{1,}"([^"]{1,})"/) {
#			next;
#		}
#		if (-e $1) {
#			next;
#		}
#		my $incl = $1;
#		# remove leading ../../
#		$incl =~ s/^[\.\/]{1,}//;
#		for (my $i = 0;; ++$i) {
#			$incl = "../$incl";
#			if (-e $incl) {
#				s/"$1"/"$incl"/;
#				print $fp $_;
#				last;
#			}
#			if ($i == 10) {
#				print "Couldn't find correct path for $1 in file $fnam\n";
#				last;
#			}
#		}
#	}
#	close($fp);
#}
