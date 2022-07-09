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
	local tmp_busy_file=$(mktemp   -t 'file.busy.txt.XXXXXXXXXXXXX')

	lockFile(){
		exec 3>$tmp_busy_file
		sleep 0.2
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

testIsVariableArray(){
	local array=()
	local fake_array='a=()'
	local -A hash_array=()

	isVariableArray array
	assertTrue '[Test array as success]' $?

	isVariableArray fake_array
	assertFalse '[Test if a variable type string is array]' $?

	isVariableArray ""
	assertFalse '[Test if variable is array with few args]' $?

	isVariableArray hash_array
	assertTrue '[Test  associative array as success]' $?	
}
testIsVariableAssociativeArray(){
	local array=()
	local fake_array='a=()'
	local -A hash_array=()

	isVariableAssociativeArray fake_array
	assertFalse '[Test if a variable type string is  associative array]' $?

	isVariableAssociativeArray ""
	assertFalse '[Test if variable is array with few args]' $?

	isVariableAssociativeArray hash_array
	assertTrue '[Test  associative array as success]' $?	
}

testIsVariabelDeclared(){
	G_VARIABLE=''
	local local_var=''

	isVariabelDeclared G_VARIABLE
	assertTrue '[Test as sucessful variable declared]' $?

	unset G_VARIABLE
	isVariabelDeclared G_VARIABLE
	assertFalse '[Test a non-existing variable]' $?

	isVariabelDeclared local_var
	assertTrue '[Test as sucessful local variable declared]' $?

}


. $(which shunit2)