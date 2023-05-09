#!/usr/bin/awk -f
BEGIN {
	i = 0
	}
	{ o = $0
	# brackets
	gsub(/\[[^\]]*\]/, "")
	gsub(/\([^)Ss]\)/, "")
	# (.*)
	gsub(/\([[0-9]]{1,}\)/, "")
	gsub(/\([^\)]*1080[^\)]*\)/, "")
	gsub(/\([^\)]*720[^\)]*\)/, "")
	# trailing
	gsub(/[^0-9A-Za-z]{1,}$/, "")
	# before extension
	gsub(/[^0-9A-Za-z]{1,}\./, ".")
	# duplicate
	gsub(/([^0-9A-Za-z]){2,}/, "\1")
	# leading
	gsub(/^\.\/[^0-9A-Za-z]{1,}/, "./")
	gsub(/eason([0-9])/, "eason \1")
	if ($0 == o)
		next
	print $0
	old[i] = o
	new[i] = $0
	++i
	}
END { print "Do you want to rename?"
	getline input < "/dev/tty";
	if (input == "y" || input == "Y")
		for (i in new)
			if (system("mv " "\"" old[i] "\" \"" new[i] "\""))
				printf "Failed to rename %s to %s", old[i], new[i]
	}
