#!/bin/bash

source ./get-shunit2



testWriterFile(){
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
	WriterFile "$testTempWriteFilePath" stream
	assertFalse "[Try WriterFile with invalid array stream ]" $?
	rm "$testTempWriteFilePath"
	WriterFile 
	assertFalse "[Try WriterFile with few args]" $?
}

testWriterFileln(){
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
	WriterFileln "$testTempWriteFilelnPath" stream &>/dev/null
	assertFalse "[Try WriterFileln with invalid array stream ]" $?
	rm "$testTempWriteFilelnPath"
	WriterFileln 
	assertFalse "[Try WriterFileln with few args]" $?

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
	
	replaceLine "$testTempReplaceLinePath" "user" &>/dev/null
	assertFalse '[Try replaceLine with few args]' $?
	
	rm $testTempReplaceLinePath
	replaceLine "$testTempReplaceLinePath" "user" "pcman" &>/dev/null
	assertFalse '[Try replaceLine with non-existing file]' $?

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
	AppendFile "$testAppendFile" stream &>/dev/null
	assertFalse "[Try appendfile with invalid arrayStream]" $?

	rm $testAppendFile

	AppendFileln "$testAppendFile" appendStream &>/dev/null
	assertFalse "[Try append on non-existing file]" $?
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
	AppendFileln "$testAppendFile" stream &>/dev/null
	assertFalse "[Try appendfile with invalid arrayStream]" $?

	rm $testAppendFile

	AppendFileln "$testAppendFile" appendStream &>/dev/null
	assertFalse "[Try append on non-existing file]" $?
	
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
	assertFalse '[Try insert blank line in non-existing file]' $?

}

testSearchLineinFile(){
	local search_line_path=$(mktemp -t file.txt.XXXXXXXXXXXXX)
	local search_line_str='debian\nubuntu\nmint\nfedora\nopensuse\nsalix\nslackware\n'
	local search_line_query='mint'
	local search_line_query_not_found='windows'
	printf "%b" "$search_line_str" > "$search_line_path"
	searchLineinFile "$search_line_path" "$search_line_query"
	assertEquals '[searchLineFile as success]'  "$BASH_FALSE" "$?"

	searchLineinFile "$search_line_path" "$search_line_query_not_found"
	assertEquals '[not found line in file]' "$BASH_TRUE" "$?"

	rm "$search_line_path"
	searchLineinFile "$search_line_path" "$search_line_query" &>/dev/null
	assertEquals '[not found file]' "$BASH_TRUE" "$?"	
}


testWriterFileFromStr(){
	local test_writer_file_path=$(mktemp -t file.txt.XXXXXXXXXXXXX)
	local test_writer_file_stream="MariaDB\nMySQL\nSqlite3\n"
	local test_writer_file_stream_resul=()
	local expected_file_stream=('MariaDB' 'MySQL' Sqlite3)
	WriterFileFromStr "$test_writer_file_path" "$test_writer_file_stream"
	mapfile -t test_writer_file_stream_resul < "$test_writer_file_path"
	assertEquals "${expected_file_stream[*]}" "${test_writer_file_stream_resul[*]}"
	rm $test_writer_file_path
}

testChangeDirectory(){
	local test_chdir_path=$(mktemp -d -t chdir.XXXXXXXXXXXXX)
	changeDirectory ''
	assertFalse '[It does nothing if it has few arguments]' $?

	changeDirectory "$test_chdir_path"
	assertEquals "$PWD" "$test_chdir_path"
	changeDirectory "$OLDPWD"
	rm -r "$test_chdir_path"
	$(changeDirectory "$test_chdir_path" &>/dev/null)
	assertFalse '[Try to access a non-existing directory]' $?

}


. $(which shunit2)
