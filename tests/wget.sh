#!/bin/bash

source ./get-shunit2
TEST_WGET_CASE=0
wget(){
	case $TEST_WGET_CASE in 
		0)
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
	local wget_out=''
	wget_out="$(Wget "")"
	assertFalse '[Running Wget without args]'  $?
	TEST_WGET_CASE=1

	wget_out="$(Wget "http://localhost")"
	assertTrue '[Running Wget Failed and Retrying Successfully]' $?
	TEST_WGET_CASE=2

	wget_out="$(Wget "http://localhost")"
	assertFalse '[Running Wget Failed and Retrying with falls]'  $?
}


testWgetOut(){
	TEST_WGET_CASE=0
	local wx=''
	WgetToStdout wx "https://raw.githubusercontent.com/jmpessoa/lazandroidmodulewizard/master/package.json"
	assertEquals '[Running WgetToStdout with valid reference to string]' 0 $?

	$(WgetToStdout '[Running WgetToStdout with valid reference to string]' x "https://raw.githubusercontent.com/jmpessoa/lazandroidmodulewizard/master/package.json")
	assertFalse $?

	TEST_WGET_CASE=0
	$(WgetToStdout  2>/dev/null)
	assertFalse '[Running WgetToStdout without args]' $?
}


. $(which shunit2)
