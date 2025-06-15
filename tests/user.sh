#!/bin/sh

# test $id $route $test $expected $header
function test() {
	# post request
	FLAGS=(-s -H "Content-Type: application/json")
	if [ -n "$3" ]; then
		FLAGS+=(-d "$3")
	fi

	if [ -n "$5" ]; then
		FLAGS+=(-H "$5")
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

## MODIFY

TOKEN=$(curl 'api:3000/login?name=dinomalin&password=thisisapw%216' -s -H "Content-Type:application/json" | jq -r .token)

# 17: basic
TEST='{"name": "dinomalin", "bio": "dinomalining...", "avatar": "placeholder_link", "banner": "placeholder_link"}'
EXPECT="200"
test 17 "modify" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 18: unauthorized
EXPECT="401"
test 18 "modify" "$TEST" "$EXPECT" "Authorization: Bearer invalidtok"

# 19: bad request
TEST='{"bio": "dinomalining...", "avatar": "placeholder_link", "banner": "placeholder_link"}'
EXPECT='{"error":"bad request"}'
test 19 "modify" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

TEST='{"name": "dinomalin", "avatar": "placeholder_link", "banner": "placeholder_link"}'
test 20 "modify" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

TEST='{"name": "dinomalin", "bio": "dinomalining...", "banner": "placeholder_link"}'
test 21 "modify" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

TEST='{"name": "dinomalin", "bio": "dinomalining...", "avatar": "placeholder_link"}'
test 22 "modify" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

## FOLLOW

# 23: create a second user
TEST='{"name": "dinomalinfriend", "password": "thisisapw!6"}' 
EXPECT="201"
test 23 register "$TEST" "$EXPECT"

# 24: basic
TEST='{"name": "dinomalinfriend"}' 
EXPECT="200"
test 24 "follow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 25: unauthorized
TEST='{"name": "dinomalinfriend"}' 
EXPECT="401"
test 25 "follow" "$TEST" "$EXPECT" "Authorization: Bearer invalidtok"

# 26: bad request
TEST='{}' 
EXPECT='{"error":"bad request"}'
test 26 "follow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 27: invalid username
TEST='{"name": "someone"}' 
EXPECT='{"error":"invalid username"}'
test 27 "follow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 28: self follow
TEST='{"name": "dinomalin"}' 
EXPECT='{"error":"self follow"}'
test 28 "follow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 29: already followed
TEST='{"name": "dinomalinfriend"}' 
EXPECT='{"error":"already followed"}'
test 29 "follow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

## UNFOLLOW

# 30: basic
TEST='{"name": "dinomalinfriend"}' 
EXPECT="200"
test 30 "unfollow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 31: unauthorized
TEST='{"name": "dinomalinfriend"}' 
EXPECT="401"
test 31 "unfollow" "$TEST" "$EXPECT" "Authorization: Bearer invalid"

# 32: bad request
TEST='{}' 
EXPECT='{"error":"bad request"}'
test 32 "unfollow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 33: invalid username
TEST='{"name": "someone"}' 
EXPECT='{"error":"invalid username"}'
test 33 "unfollow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 34: self unfollow
TEST='{"name": "dinomalin"}' 
EXPECT='{"error":"self unfollow"}'
test 34 "unfollow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"

# 35: not followed
TEST='{"name": "dinomalinfriend"}' 
EXPECT='{"error":"not followed"}'
test 35 "unfollow" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN"
