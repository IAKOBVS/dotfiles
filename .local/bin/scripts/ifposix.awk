#!/usr/bin/awk -f

function ifpsx(flag)
{
	if (prog == "awk") {
		if (system("man gawk 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
			return -1
		if (system("man 1p awk 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
			return 1
		return 0
	}
	if (system("man " prog " 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
		return -1
	if (system("man 1p " prog " 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
		return 1
	return 0
}

function shopt()
{
	ret = ifpsx($i)
	if (ret == -1)
		printf "%s:%s:%s:%s:invalid flag\n", FILENAME, FNR, prog, $i
	else if (ret == 1)
		printf "%s:%s:%s:%s:non-POSIX flag\n", FILENAME, FNR, prog, $i
}

function loopt()
{
	c = substr($i, j, 1)
	ret = ifpsx("-" c)
	if (ret == -1)
		printf "%s:%s:%s:-%s:invalid flag\n", FILENAME, FNR, prog, c
	else if (ret == 1)
		printf "%s:%s:%s:-%s:non-POSIX flag\n", FILENAME, FNR, prog, c
}

function eol()
{
	if ($i ~ /\|$/)
		return "$"
	if ($i ~ /&$/)
		return "&"
	if ($i ~ /;$/)
		return ";"
	return 0
}

BEGIN {
	FS = "[^-|&;_0-9A-Za-z]{1,}"
}
/awk|grep|sed/ {
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
		for (++i; i <= NF && \
				($i !~ /^\|/ \
				&& $i !~ /^&/ \
				&& $i !~ /^;/); \
				++i) {
			if ($i ~ /^--[A-Za-z]/) {
				if (ret = eol()) {
					gsub(ret, "", $i)
					shopt()
					break
				}
				shopt()
			} else if ($i ~ /^-[A-Za-z]/) {
				if (ret = eol())
					gsub(ret, "", $i)
				len = length($i)
				for (j = 2; j <= len; ++j)
					loopt()
			}
		}
	}
}
