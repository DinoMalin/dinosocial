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

# 1: basic
TEST='{"name": "dinomalin", "password": "thisisapw!6"}'
EXPECT="201"
test 1 register "$TEST" "$EXPECT"

# 2-4: bad request
TEST='{}'
EXPECT='{"error":"bad request"}'
test 2 register "$TEST" "$EXPECT"

TEST='{"name":"dinomalin"}'
EXPECT='{"error":"bad request"}'
test 3 register "$TEST" "$EXPECT"

TEST='{"password":"dinomalin"}'
EXPECT='{"error":"bad request"}'
test 4 register "$TEST" "$EXPECT"

# 5-9: password policy
TEST='{"name": "dinomalin", "password": "thisisapw"}'
EXPECT='{"error":"invalid password"}'
test 6 register "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "thisisapw6"}'
EXPECT='{"error":"invalid password"}'
test 7 register "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "pass"}'
EXPECT='{"error":"invalid password"}'
test 8 register "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "loremipsumdolorsitamet"}'
EXPECT='{"error":"invalid password"}'
test 9 register "$TEST" "$EXPECT"

# 10: already existing user
TEST='{"name": "dinomalin", "password": "thisisapw!6"}'
EXPECT='{"error":"username already exist"}'
test 10 register "$TEST" "$EXPECT"
