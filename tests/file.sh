#!/bin/bash

source ./get-shunit2



testWriteFile(){
	local testTempWriteFilePath=$(mktemp -t "file.txt.XXXXXXXXXXXXX")
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

	WriterFile $testTempWriteFilePath file_str
	mapfile  file2str < "$testTempWriteFilePath" 
	assertEquals '[testWriteFile as success]' "$(printf "${file2str[*]}")" "$(printf "${file_str[*]}")"
	unset stream
	WriterFileln "$testTempWriteFilePath" stream
	assertFalse "[Try WriterFile with invalid array stream ]" $?
	rm "$testTempWriteFilePath"
}

testWriteFileln(){
	local testTempWriteFilelnPath=$(mktemp -t "file.txt.XXXXXXXXXXXXX")
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

	WriterFileln "$testTempWriteFilelnPath" file_str
	mapfile  -t file2str <  "$testTempWriteFilelnPath" 
	assertEquals "$(printf "${file2str[*]}")" "$(printf "${file_str[*]}")"
	unset stream
	WriterFileln "$testTempWriteFilelnPath" stream
	assertFalse "[Try WriterFileln with invalid array stream ]" $?
	rm "$testTempWriteFilelnPath"
}


testReplaceLine(){
	local testTempReplaceLinePath="$(mktemp -t "file.txt.XXXXXXXXXXXXX")"
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

	WriterFileln "$testTempReplaceLinePath" file_str
	replaceLine "$testTempReplaceLinePath" "user" "pcman"
	mapfile  -t file2str <  "$testTempReplaceLinePath"
	assertEquals "$(printf "%b" "${file2str[1]}")" "$(printf "%b" "$(strReplace "${file_str[1]}" "user" "pcman" )")"
	
	replaceLine "$testTempReplaceLinePath" "user"
	assertFalse '[Try replaceLine with few args]' $?
	
	rm $testTempReplaceLinePath
	replaceLine "$testTempReplaceLinePath" "user" "pcman"
	assertFalse '[Try replaceLine with non existent file]' $?

}


testAppendFile(){
	local testAppendFile=$(mktemp  -t testAppend.txt.XXXXXXXXXXXXX)
	local testAppendFileStr='MariaDB\nMySQL\n'
	local appendStream=('Sqlite3\n')
	local resultStream=()
	local expectedStream=(
		'MariaDB'
		'MySQL'
		'Sqlite3'
	)
	printf "%b" "$testAppendFileStr" >> "$testAppendFile"
	AppendFile "$testAppendFile" appendStream
	mapfile -t resultStream < "$testAppendFile"
	assertEquals "${expectedStream[*]}" "${resultStream[*]}"
	unset stream
	AppendFile "$testAppendFile" stream
	assertFalse "[Try appendfile with invalid arrayStream]" $?

	rm $testAppendFile

	AppendFileln "$testAppendFile" appendStream
	assertFalse "[Try append on non existent file]" $?
}

testAppendFileln(){
	local testAppendFile=$(mktemp  -t testAppend.txt.XXXXXXXXXXXXX)
	local testAppendFileStr='MariaDB\nMySQL\n'
	local appendStream=('Sqlite3')
	local resultStream=()
	local expectedStream=(
		'MariaDB'
		'MySQL'
		'Sqlite3'
	)
	printf "%b" "$testAppendFileStr" >> "$testAppendFile"
	AppendFileln "$testAppendFile" appendStream
	mapfile -t resultStream < "$testAppendFile"
	assertEquals "${expectedStream[*]}" "${resultStream[*]}"

	unset stream
	AppendFileln "$testAppendFile" stream
	assertFalse "[Try appendfile with invalid arrayStream]" $?

	rm $testAppendFile

	AppendFileln "$testAppendFile" appendStream
	assertFalse "[Try append on non existent file]" $?
	
}

testInsertUniqueBlankLine(){
	local testFileUniqueBlankLinePath=$(mktemp -t "testUniqueBlankLine.txt.XXXXXXXXXXXXX")
	local testUniqueLineBlankStr='MariaDB\nMySQL'
	printf "%b" "$testUniqueLineBlankStr" > $testFileUniqueBlankLinePath
	InsertUniqueBlankLine "$testFileUniqueBlankLinePath"
	assertTrue '[Add blank line on file ]' $?

	InsertUniqueBlankLine
	assertFalse '[Try insert blank line with few args]' $?
	rm "$testFileUniqueBlankLinePath"
	InsertUniqueBlankLine "$testFileUniqueBlankLinePath"
	assertFalse '[Try insert blank line in non existent file]' $?

}





. $(which shunit2)
