#!/bin/bash

post() {
	curl -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d @${1} http://localhost:19001${2}
}

put() {
	curl -H "Accept: application/json" -H "Content-Type: application/json" -X PUT -d @${1} http://localhost:19001${2}
}

get() {
	curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X GET http://localhost:19001${2}
}

case $1 in
	post)
		post $2 $3
		;;
	POST)
		post $2 $3
		;;
	put)
		put $2 $3
		;;
	PUT)
		put $2 $3
		;;
	get)
		get $2
		;;
	GET)
		get $2
		;;
	*)
		echo "Usage: hreq {post|put|get} {file|URL}"
		;;
esac
