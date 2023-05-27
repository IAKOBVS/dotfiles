#!/usr/bin/awk -f
BEGIN {
	N = 0
	FS = "."
	}
{
	old = $0
	gsub(/\[[^\]]*\]/, "")  # inside brackets
	sub(/^(\.\/){1,}[ \t]{1,}/, "") # leading spaces 
	# inside parens
	gsub(/\([0-9]*\)/, "")
	gsub(/\([^\)]*1080[^\)]*\)/, "")
	gsub(/\([^\)sS]*\)/, "")
	# trailing before extension
	if ($NF) {
		BF_NF = NF - 1
		gsub(/[ \t]{1,}$/, tmp, $BF_NF)
		gsub(/\-{1,}$/, tmp, $BF_NF)
		gsub(/_{1,}$/, tmp, $BF_NF)
		}
	# trailing
	gsub(/ *$/, "")
	gsub(/_*$/, "")
	gsub(/\-*$/, "")
	# weird symbols
	gsub(/_{2,}/, "_")
	gsub(/  {2,}/ , "")
	gsub(/-{2,}/, "-")
	gsub(/_\-_/, "_")
	gsub(/\.\-/, "_")
	# seasonN
	if (match($0, /eason [0-9]/)) {
		tmp = substr($0, RSTART, length("eason 1"))
		gsub(/eason([[0-9]])/, tmp)
		}
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
	printf "\nDo you want to rename?\n"
	getline ok <"/dev/tty"
	if (ok != "y")
		exit
	for (i = 0; i < N; ++i)
		if (system("mv \"" olds[i] "\" \"" news[i] "\" &"))
			printf "Can't rename %s into %s\n", olds[i], news[i]
	}
