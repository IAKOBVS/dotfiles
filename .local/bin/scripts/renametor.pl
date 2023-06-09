#!/usr/bin/perl
use strict;
use warnings;

my @old;
my @new;
my $old;
foreach (glob('*')) {
	no warnings; # ignore use of \1 as backref warnings
	if (!-d && !-f) {
		next;
	}
	$old = $_;

	# inside brackets
	s/\[[^\]]*\]//g;

	# leading spaces
	s/^\.\/[[:space:]]*([^[:space:]])/\1/;

	# inside parens
	s/\([0-9]*\)//g; # contains num
	s/\([^\)]*1080[^\)]*\)//g; # contains resolution
	s/\([^\)sS]*\)//g; # does not contain season

	# trailing before extension
	s/[[:space:]]{1,}(\.[0-9A-Za-z]*)$/\1/; # space
	s/\-{1,}(\.[0-9A-Za-z]*)$/\1/; # underscore
	s/_{1,}(\.[0-9A-Za-z]*)$/\1/; # dash

	# trailing
	s/\ *$//; # space
	s/_*$//; # underscore
	s/\-*$//; # dash

	# weird symbols
	s/_{2,}/_/g; # underscores
	s/  {2,}/ /g; # spaces
	s/-{2,}/-/g; # dashes
	s/_\-_/_/g; # _-_
	s/\.\-/_/g; # .-

	# season2 -> season 2
	s/eason([[0-9]])/eason\ \1/g;

	print "$_\n";
	push @old, $old;
	push @new, $_;
}
printf "\nDo you want to rename the files? (Y/N)\n";
$_ = <>;
chomp;
if ($_ eq 'Y') {
	for my $i (0..$#old) {
		rename($old[$i], $new[$i]) or print "Unable to rename $old[$i] to $new[$i]\n";
	}
	printf "Files successfully renamed!\n";
}
