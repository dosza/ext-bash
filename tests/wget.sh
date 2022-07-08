#!/bin/bash

source ./get-shunit2

TEST_WGET_CASE=0
wget(){
	case $TEST_WGET_CASE in 
		0)
			echo 'Hello World!'
			return $BASH_TRUE
		;;
		1)
			TEST_WGET_CASE=0
			return $BASH_FALSE
		;;
		2)
			return $BASH_FALSE
		;;
	esac
}


testWget(){
	assertEquals '[Running Wget without args]' "Wget needs a argument" "$(Wget "")"
	TEST_WGET_CASE=1
	assertEquals '[Running Wget Failed and Retrying Successfully]'\
	 	'Hello World!' "$(Wget "http://localhost")"
	TEST_WGET_CASE=2
	assertEquals '[Running Wget Failed and Retrying with falls]'\
		'possible network instability!!' "$(Wget "http://localhost")"
}


testWgetOut(){
	TEST_WGET_CASE=0
	local wx=''
	WgetToStdout wx "https://raw.githubusercontent.com/jmpessoa/lazandroidmodulewizard/master/package.json"
	assertEquals '[Running WgetToStdout with valid reference to string]' 0 $?

	$(WgetToStdout '[Running WgetToStdout with valid reference to string]' x "https://raw.githubusercontent.com/jmpessoa/lazandroidmodulewizard/master/package.json")
	assertFalse $?

	TEST_WGET_CASE=0
	$(WgetToStdout  )
	assertFalse '[Running WgetToStdout without args]' $?
}


. $(which shunit2)
