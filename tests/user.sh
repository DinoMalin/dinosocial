#!/bin/sh

API_URL="api:3000"

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

	if [ -n "$6" ]; then
		FLAGS+=(-X "$6")
	fi

	if [ ${#4} = 3 ]; then
		FLAGS+=(-o /dev/null -w "%{http_code}")
	fi
	
	RES=$(curl "$API_URL/$2" "${FLAGS[@]}")
	if [ "$RES" != "$4" ]; then
		echo "$1: expected $4, got $RES"
		exit 1
	fi
}

## REGISTER - POST /user

# 1: basic
TEST='{"name": "dinomalin", "password": "thisisapw!6"}'
EXPECT="201"
test 1 user "$TEST" "$EXPECT"

# 2-4: bad request
TEST='{}'
EXPECT='{"error":"bad request"}'
test 2 user "$TEST" "$EXPECT"

TEST='{"name":"dinomalin"}'
test 3 user "$TEST" "$EXPECT"

TEST='{"password":"dinomalin"}'
test 4 user "$TEST" "$EXPECT"

# 5-9: password policy
TEST='{"name": "dinomalin", "password": "thisisapw"}'
EXPECT='{"error":"invalid password"}'
test 6 user "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "thisisapw6"}'
test 7 user "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "pass"}'
test 8 user "$TEST" "$EXPECT"

TEST='{"name": "dinomalin", "password": "loremipsumdolorsitamet"}'
test 9 user "$TEST" "$EXPECT"

# 10: already existing user
TEST='{"name": "dinomalin", "password": "thisisapw!6"}'
EXPECT='{"error":"username already exist"}'
test 10 user "$TEST" "$EXPECT"

## LOGIN - POST /login

# 11: basic (%21 == '!')
TEST='{"name": "dinomalin", "password": "thisisapw!6"}'
EXPECT="200"
test 11 login "$TEST" "$EXPECT"

# 12-14: bad request
EXPECT='{"error":"bad request"}'

TEST='{}'
test 12 login "$TEST" "$EXPECT"

TEST='{"password": "thisisapw!6"}'
test 13 login "$TEST" "$EXPECT"

TEST='{"name": "dinomalin"}'
test 14 login "$TEST" "$EXPECT"

# 15: invalid username
TEST='{"name": "dino", "password": "thisisapw!6"}'
EXPECT='{"error":"invalid username"}'
test 15 login "$TEST" "$EXPECT"

# 16: invalid password
TEST='{"name": "dinomalin", "password": "notthegoodpassword"}'
EXPECT='{"error":"invalid password"}'
test 16 login "$TEST" "$EXPECT"

## MODIFY - PATCH /user

TOKEN=$(curl 'api:3000/login' -s -H "Content-Type:application/json" -d '{"name": "dinomalin", "password": "thisisapw!6"}' | jq -r .token)

# 17: basic
TEST='{"name": "dinomalin", "bio": "dinomalining...", "avatar": "placeholder_link", "banner": "placeholder_link"}'
EXPECT="200"
test 17 "user" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN" PATCH

# 18: unauthorized
EXPECT="401"
test 18 "user" "$TEST" "$EXPECT" "Authorization: Bearer invalidtok" PATCH

# 19: bad request
TEST='{"bio": "dinomalining...", "avatar": "placeholder_link", "banner": "placeholder_link"}'
EXPECT='{"error":"bad request"}'
test 19 "user" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN" PATCH

TEST='{"name": "dinomalin", "avatar": "placeholder_link", "banner": "placeholder_link"}'
test 20 "user" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN" PATCH

TEST='{"name": "dinomalin", "bio": "dinomalining...", "banner": "placeholder_link"}'
test 21 "user" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN" PATCH

TEST='{"name": "dinomalin", "bio": "dinomalining...", "avatar": "placeholder_link"}'
test 22 "user" "$TEST" "$EXPECT" "Authorization: Bearer $TOKEN" PATCH


## FOLLOW

# 23: create a second user
TEST='{"name": "dinomalinfriend", "password": "thisisapw!6"}' 
EXPECT="201"
test 23 user "$TEST" "$EXPECT"

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
