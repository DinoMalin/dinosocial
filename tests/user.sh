#!/bin/sh

# test $id $route $test $expected
function test() {
	FLAGS=(-s -H "Content-Type: application/json")
	if [ ${#4} = 3 ]; then
		FLAGS+=(-o /dev/null -w "%{http_code}")
	fi
	
	RES=$(curl "api:3000/$2" -d "$3" "${FLAGS[@]}")
	if [ "$RES" != "$4" ]; then
		echo "$1: expected $4, got $RES"
		exit 1
	fi
}

T1='{"name": "dinomalin", "password": "thisisapw!6"}'
E1="201"
test 1 register "$T1" "$E1"
