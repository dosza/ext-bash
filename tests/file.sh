#!/bin/bash

source ./get-shunit2



testWriteFile(){
	local file2str=()
	local file_str=(
		"127.0.0.1\tlocalhost\n"
		"127.0.1.1\tuser\n"
		"# The following lines are desirable for IPv6 capable hosts\n"
		"::1\tip6-localhost ip6-loopbackz\n"
		"fe00::0 ip6-localnet\n"
		"ff00::0 ip6-mcastprefix\n"
		"ff02::1 ip6-allnodes\n"
		"ff02::2 ip6-allrouters\n"
	)

	WriterFile /tmp/file.txt file_str
	mapfile  file2str < "/tmp/file.txt" 
	assertEquals "$(printf "${file2str[*]}")" "$(printf "${file_str[*]}")"

}

testWriteFileln(){
	local file2str=()
	local file_str=(
		"127.0.0.1\tlocalhost"
		"127.0.1.1\tuser"
		"# The following lines are desirable for IPv6 capable hosts"
		"::1\tip6-localhost ip6-loopbackz"
		"fe00::0 ip6-localnet"
		"ff00::0 ip6-mcastprefix"
		"ff02::1 ip6-allnodes"
		"ff02::2 ip6-allrouters"
	)

	WriterFileln /tmp/file.txt file_str
	mapfile  -t file2str <  "/tmp/file.txt" 
	assertEquals "$(printf "${file2str[*]}")" "$(printf "${file_str[*]}")"
}


testReplaceLine(){
	local file2str=()
	local file_str=(
		"127.0.0.1\tlocalhost"
		"127.0.1.1\tuser"
		"# The following lines are desirable for IPv6 capable hosts"
		"::1\tip6-localhost ip6-loopbackz"
		"fe00::0 ip6-localnet"
		"ff00::0 ip6-mcastprefix"
		"ff02::1 ip6-allnodes"
		"ff02::2 ip6-allrouters"
	)

	WriterFileln /tmp/file.txt file_str
	replaceLine /tmp/file.txt "user" "pcman"
	mapfile  -t file2str <  "/tmp/file.txt" 
	assertEquals "$(printf "%b" "${file2str[1]}")" "$(printf "%b" "$(strReplace "${file_str[1]}" "user" "pcman" )")"


}




. $(which shunit2)
