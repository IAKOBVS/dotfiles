#!/usr/bin/awk -f

function ifpsx(cmd, flag)
{
	if (system("man " ((cmd == "awk") ? "gawk" : cmd) " 2>/dev/null | grep -q \"^[[:space:]]*" flag "[^A-Za-z]\""))
		return -1
	if (system("man 1p " cmd " 2>/dev/null | grep -q \"^[[:space:]]*" flag "[^A-Za-z]\""))
		return 1
	return 0
}

function shopt(cmd, flag)
{
	ret = ifpsx(flag)
	if (ret == -1)
		print FILENAME ":" FNR ":" cmd ":" flag ":invalid flag"
	else if (ret == 1)
		print FILENAME ":" FNR ":" cmd ":" flag ":non-POSIX flag"
}

function loopt(cmd, flag)
{
	c = substr(flag, j, 1)
	ret = ifpsx(cmd, "-" c)
	if (ret == -1)
		print FILENAME ":" FNR ":" cmd ":" c ":invalid flag"
	else if (ret == 1)
		print FILENAME ":" FNR ":" cmd ":" c ":non-POSIX flag"
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
			return "&&";
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
				if (ret = eol($i)) {
					gsub(ret, "", $i)
					shopt(prog, $i)
					break
				}
				shopt(prog, $i)
			} else if ($i ~ /^-[A-Za-z]/) {
				if (ret = eol($i))
					gsub(ret, "", $i)
				len = length($i)
				for (j = 2; j <= len; ++j)
					loopt(prog, $i)
			}
		}
	}
}
