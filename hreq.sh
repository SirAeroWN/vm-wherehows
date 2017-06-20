#!/bin/bash

post() {
	if [ -z "$3" ]; then
		curl -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d @${1} http://localhost:19001${2}
	else
		curl -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d @${1} http://localhost:${3}${2}
	fi
}

put() {
	if [ -z "$3" ]; then
		curl -H "Accept: application/json" -H "Content-Type: application/json" -X PUT -d @${1} http://localhost:19001${2}
	else
		curl -H "Accept: application/json" -H "Content-Type: application/json" -X PUT -d @${1} http://localhost:${3}${2}
	fi
}

get() {
	if [ -z "$2" ]; then
		curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:19001${2}
	else
		curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:${3}${2}
	fi
}

case $1 in
	post)
		post $2 $3 $4
		;;
	POST)
		post $2 $3 $4
		;;
	put)
		put $2 $3 $4
		;;
	PUT)
		put $2 $3 $4
		;;
	get)
		get $2 $3
		;;
	GET)
		get $2 $3
		;;
	*)
		echo "Usage: hreq {post|put|get} {file|URL} {URL} {port}"
		;;
esac
