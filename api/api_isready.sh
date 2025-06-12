#!/bin/bash

RES=$(curl -s localhost:3000/)
if [ "$RES" = '{"message":"api is on"}' ]; then
	exit 0
fi

exit 1;
