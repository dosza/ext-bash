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

. $(which shunit2)