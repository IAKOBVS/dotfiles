#!/usr/bin/awk -f

function bad_flag(cmd, flag, posixity)
{
	print FILENAME ":" FNR ":" cmd ":" flag ":" posixity " flag"
}

function ifpsx(cmd, flag, longopt)
{
	if (longopt)
		grep = " 2>/dev/null | grep -q -E \",[[:space:]]{1,}" flag "([^A-Za-z]|$)\""
	else
		grep = " 2>/dev/null | grep -q \"^[[:space:]]*" flag "[^A-Za-z]\""
	if (system("man " ((cmd == "awk") ? "gawk" : cmd) grep))
		bad_flag(cmd, flag, "invalid")
	else if (system("man 1p " cmd grep))
		bad_flag(cmd, flag, "non-POSIX")
}

function eol(w)
{
	if (w ~ /\|$/) {
		if (w ~ /\|\|$/)
			return "||"
		return "$"
	}
	if (w ~ /&$/) {
		if (w ~ /&&$/)
			return "&&"
		return "&"
	}
	if (w ~ /;$/)
		return ";"
	return 0
}

function eol_match(w)
{
	if (w == "|" \
	|| w == "||" \
	|| w == "&" \
	|| w == "&&" \
	|| w == ";")
		return 1;
	return 0;
}

BEGIN {
	FS = "[[:space:]]{1,}"
}
/awk|grep|sed|echo|cd|pwd|ls|cp|mkdir|rmdir|touch|cat|sort/ {
	for (i = 1; i <= NF; ++i) {
		if ($i != "awk" \
		&& $i != "grep" \
		&& $i != "sed" \
		&& $i != "echo" \
		&& $i != "cd" \
		&& $i != "pwd" \
		&& $i != "ls" \
		&& $i != "cp" \
		&& $i != "mkdir" \
		&& $i != "rmdir" \
		&& $i != "touch" \
		&& $i != "cat" \
		&& $i != "sort")
			continue
		prog = $i
		for (++i; i <= NF && !eol_match($i); ++i) {
			if ($i ~ /^--[A-Za-z]/) {
				ret = eol($i)
				if (ret) {
					gsub(ret, "", $i)
					ifpsx(prog, $i, 1)
					break
				}
				long(prog, $i)
			} else if ($i ~ /^-[A-Za-z]/) {
				ret = eol($i)
				if (ret)
					gsub(ret, "", $i)
				len = length($i)
				for (j = 2; j <= len; ++j)
					ifpsx(prog, "-" substr($i, j, 1), 0)
			}
		}
	}
}
