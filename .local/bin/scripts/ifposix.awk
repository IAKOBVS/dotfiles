#!/usr/bin/awk -f

function ifpsx(prog_, flag)
{
	if (prog == "awk") {
		if (system("man gawk 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
			return -1
		if (system("man 1p awk 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
			return 1
		return 0
	}
	if (system("man " prog_ " 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
		return -1
	if (system("man 1p " prog_ " 2>/dev/null | grep -q \"^[[:space:]]*"flag"[^A-Za-z]\""))
		return 1
	return 0
}

BEGIN {
	FS = "[^-|&;_0-9A-Za-z]{1,}"
	}
/awk|grep|sed/ {
	for (i = 1; i <= NF; ++i) {
		if ($i != "awk" \
		&& $i != "grep" \
		&& $i !=  "sed")
			continue
		prog = $i
		for (++i; i <= NF && \
				(($i !~ /\|/) \
				&& ($i !~ /&/) \
				&& $i !~ /;/); \
			     ++i) {
			if ($i ~ /^--[A-Za-z]/) {
				ret = ifpsx($prog, $i)
				if (ret == -1)
					printf "%s:%s:%s:%s:not a valid flag\n", FILENAME, NR, prog, $i
				else if (ret == 1)
					printf "%s:%s:%s:%s:not a POSIX flag\n", FILENAME, NR, prog, $i
			} else if ($i ~ /^-[A-Za-z]/) {
				len = length($i)
				for (j = 2; j <= len; ++j) {
					c = substr($i, j, 1)
					ret = ifpsx(prog, "-" c)
					if (ret == -1)
						printf "%s:%s:%s:-%s:not a valid flag\n", FILENAME, NR, prog, c
					else if (ret == 1)
						printf "%s:%s:%s:-%s:not a POSIX flag\n", FILENAME, NR, prog, c
				}
			}
		}
	}
}
