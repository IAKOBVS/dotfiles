#!/usr/bin/awk -f
BEGIN {i = 0}
{
	o = $0
	# brackets
	gsub(/\[[^\]]*\]/, "")
	# leading space
	gsub(/^\.\/[[:space:]]{1,}/, "./")
	# (.*)
	gsub(/\([[:digit:]]*\)/, "")
	gsub(/\([^\)]*1080[^\)]*\)/, "")
	gsub(/\([^\)]*720[^\)]*\)/, "")
	gsub(/\([^\)sS]*\)/, "")
	# trailing symbols
	gsub(/ {1,}$/, "")
	gsub(/_{1,}$/, "")
	gsub(/-{1,}$/, "")
	# trailing symbols before ext
	gsub(/ *\./, ".")
	gsub(/_*\./, ".")
	gsub(/-\./, ".")
	# weird symbols
	gsub(/_{2,}/, "_")
	gsub(/ {2,}/, " ")
	gsub(/-{2,}/, "-")
	gsub(/_-_/, "_")
	gsub(/\.-/, " ")

	print $0
	old[i] = o
	new[i] = $0
	++i
}
END {
	print "Do you want to rename?"
	getline input < "/dev/tty";
	if (input == "y" \
    	|| input == "Y")
		for (i in new)
			if (system("mv " "\"" old[i] "\" \"" new[i] "\""))
				printf "Failed to rename %s to %s", old[i], new[i]
}
