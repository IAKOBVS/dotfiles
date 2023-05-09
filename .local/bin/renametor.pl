#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

my @old;
my @new;

my $new;

foreach my $old (glob('./*')) {
	no warnings; # ignores use of \1 over $1 warning for backreference
	$new = $old;

	# brackets
	$new =~ s/\[[^\]]*\]//g;

	# leading space
	$new =~ s/^\.\/[[:space:]]*([^[:space:]])/\1/;

	# (str)
	$new =~ s/\([[:digit:]]*\)//g; # (2019)
	$new =~ s/\([^\)]*1080[^\)]*\)//g; # (.*1080.*)
	$new =~ s/\([^\)sS]*\)//g;

	# trailing symbols before extension
	$new =~ s/[[:space:]]*(\.[[:alnum:]]*)$/\1/; # space
	$new =~ s/-*(\.[[:alnum:]]*)$/\1/; # underscore
	$new =~ s/_*(\.[[:alnum:]]*)$/\1/; # dash

	# trailing
	$new =~ s/\ *$//; # space
	$new =~ s/_*$//; # underscore
	$new =~ s/-*$//; # dash

	# weird symbols
	$new =~ s/_*/_/g; # underscores
	$new =~ s/  */\ /g; # spaces
	$new =~ s/-*/-/g; # dashes
	$new =~ s/_-_/_/g; # _-_
	$new =~ s/\.-/_/g; # .-

	$new =~ s/eason([[:digit:]])/eason\ \1/g; # season2 -> season 2

	print "$new\n";
	push @old, $old;
	push @new, $new;
}

print "\nDo you want to rename the files? (y/n)\n";
my $in = readline(STDIN);
chomp($in);

if ($in eq 'y' || $in eq 'Y') {
	for my $i (0..$#old) {
		rename($old[$i], $new[$i]) or print "Unable to rename $old[$i] to $new[$i]\n";
	}
	print "Files successfully renamed!\n";
}