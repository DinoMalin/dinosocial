#!/bin/sh

# test $id $route $test $expected
function test() {
	# post request
	FLAGS=(-s -H "Content-Type: application/json")
	if [ -n "$3" ]; then
		FLAGS+=(-d "$3")
	fi

	if [ ${#4} = 3 ]; then
		FLAGS+=(-o /dev/null -w "%{http_code}")
	fi
	
	RES=$(curl "api:3000/$2" "${FLAGS[@]}")
	if [ "$RES" != "$4" ]; then
		echo "$1: expected $4, got $RES"
		exit 1
	fi
}

## REGISTER

# 1: basic
TEST='{"name": "dinomalin", "password": "thisisapw!6"}'
EXPECT="201"
test 1 register "$TEST" "$EXPECT"

# 2-4: bad request
TEST='{}'
EXPECT='{"error":"bad request"}'
test 2 register "$TEST" "$EXPECT"

TEST='{"name":"dinomalin"}'
test 3 register "$TEST" "$EXPECT"

TEST='{"password":"dinomalin"}'
test 4 register "$TEST" "$EXPECT"

# 5-9: password policy
TEST='{"name": "dinomalin", "password": "thisisapw"}'
EXPECT='{"error":"invalid password"}'
test 6 register "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "thisisapw6"}'
test 7 register "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "pass"}'
test 8 register "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "loremipsumdolorsitamet"}'
test 9 register "$TEST" "$EXPECT"

# 10: already existing user
TEST='{"name": "dinomalin", "password": "thisisapw!6"}'
EXPECT='{"error":"username already exist"}'
test 10 register "$TEST" "$EXPECT"

## LOGIN

# 11: basic (%21 == '!')
EXPECT="200"
test 11 "login?name=dinomalin&password=thisisapw%216" "" "$EXPECT"

# 12-14: bad request
EXPECT='{"error":"bad request"}'
test 12 "login" "" "$EXPECT"
test 13 "login?password=thisisapw%216" "" "$EXPECT"
test 14 "login?name=dinomalin" "" "$EXPECT"

# 15: invalid username
EXPECT='{"error":"invalid username"}'
test 15 "login?name=dino&password=thisisapw%216" "" "$EXPECT"

# 16: invalid password
EXPECT='{"error":"invalid password"}'
test 16 "login?name=dinomalin&password=thisisapw" "" "$EXPECT"
