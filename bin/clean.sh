#! /bin/bash

set -o errexit
# set -o pipefail
set -o nounset

usage() {
	echo ""
		echo "    Usage: $0 [-n <number of spaces>] (<filename> | -r <directory>)"
		echo ""
		echo "Converts tabs to the specified number of spaces and strips trailing whitespace from the given file,"
		echo "in addition to ensuring that there is one and only one newline at the end of the file."
		echo ""
}

strip() {

	echo "Stripping trailing whitespace."
		sed -i '' 's/[ \t]*$//' "($2)"

		echo "Converting tabs to spaces."
		expand --tabs="$1" "$2"

		echo "Ensuring only one newline at end of file"
		awk '/^$/ {nlstack=nlstack "\n";next;} {printf "%s",nlstack; nlstack=""; print;}' "$2"
}

main() {
	NUM=4
		while getopts ":n:r:h" opt; 
	do
		case $opt in
# Set NumSpaces
			n)
			if [ "$OPTARG" -eq "$OPTARG" ]; then
				NUM=$OPTARG
			else
				usage
					fi
					;;
# Recursive
	r)
		if [ -d $file ]; then
			for file in $( find $OPTARG -type f ); do
				echo $file
					strip NUM $file
					done
		else
			usage
				fi
				return
				;;
# Error states
	\?)
		echo Invalid Option
		;&
		:)
		usage
		;&
		\h)
		usage
		;;
	esac
		done
		shift $((OPTIND -1))

		if [ $# -lt 2 ]; then
			usage
				exit 1
		else
			for file in $@; do 
				strip NUM $file
					done
					fi

}

    main "$@"

