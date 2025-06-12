#!/bin/bash

FILE=.env

function gen_secret() {
	if ! grep "$1" "$FILE" >/dev/null 2>&1 ; then
		echo >>$FILE $1=$(cat /dev/random \
			| head -n 1 \
			| sha1sum \
			| awk '{print $1}'\
		)
	fi
}

gen_secret "DB_PASSWORD"
gen_secret "JWT_PASSWORD"
