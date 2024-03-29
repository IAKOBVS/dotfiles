#!/usr/bin/awk -f
BEGIN {
	N = 0
	}
	{
	old = $0
	# inside brackets
	gsub(/\[[^\]]*\]/, "") 
	# leading spaces 
	sub(/^(\.\/){1,}[ \t]{1,}/, "")
	gsub(/ /, "_");
	# inside parens
	gsub(/\([0-9]*\)/, "")
	gsub(/\([^\)]*1080[^\)]*\)/, "")
	gsub(/\([^\)sS]*\)/, "")
	# trailing before extension
	if (match($0, /\.[0-9A-Za-z]{1,}$/)) {
		tmp = substr($0, RSTART)
		gsub(/[ \t]{1,}\.[0-9A-Za-z]{1,}$/, tmp)
		gsub(/\-{1,}\.[0-9A-Za-z]{1,}$/, tmp)
		gsub(/_{1,}\.[0-9A-Za-z]{1,}$/, tmp)
		}
	# trailing
	gsub(/ *$/, "")
	gsub(/_*$/, "")
	gsub(/\-*$/, "")
	# weird symbols
	gsub(/_{2,}/, "_")
	gsub(/ {2,}/, "")
	gsub(/-{2,}/, "-")
	gsub(/_\-_/, "_")
	gsub(/\.\-/, "_")
	if ($0 == old)
		next
	printf "%s\n", $0
	news[N] = $0
	olds[N] = old
	++N
	}
END {
	if (!N)
		exit
	printf "\nDo you want to rename? (Y/n)\n"
	getline ok <"/dev/tty"
	if (ok != "Y")
		exit
	for (i = 0; i < N; ++i)
		if (system("mv \"" olds[i] "\" \"" news[i] "\" &"))
			printf "Can't rename %s into %s\n", olds[i], news[i]
	}
