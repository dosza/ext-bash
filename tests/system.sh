source ./get-shunit2

testIsUserRoot(){
	if [ $UID != 0 ] ; then 
		$(IsUserRoot)
		assertEquals "$BASH_TRUE" $?
	else 
		$(IsUserRoot)
		assertEquals "$BASH_FALSE" $?
	fi
}

testIsUsersSudo(){
	grep sudo /etc/group  | grep $USER -q 2>/dev/null
	local expected_user_sudo=$?
	isUsersSudo $USER
	assertEquals "$expected_user_sudo" "$?"
}


testLen(){
	local array=({0..10..2})
	local str='name'
	assertEquals "[Get a length of array by reference]" "${#array[*]}" "$(len array)"
	assertEquals "[Get a length of string by reference]" "${#str}" "$(len str)"
	assertEquals "[Get a length of string]" "5" "$(len maria)"
}


testIsFileBusy(){
	local tmp_busy_file=$(mktemp)

	lockFile(){
		exec 3>$tmp_busy_file
		sleep 0.1
	}

	unlockFile(){
		exec 3>&-
	}

	assertEquals "[Running IsFileBusy without file busy(unklocked)]" "" "$(IsFileBusy bash $tmp_busy_file)"
	lockFile &
	assertEquals "[Running IsFileBusy with file busy (locked) ]" "Wait for bash..." "$(IsFileBusy bash $tmp_busy_file)"
	unlockFile
	rm $tmp_busy_file

}
. $(which shunit2)