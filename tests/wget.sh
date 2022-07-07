#!/bin/bash

source ./get-shunit2


testWgetOut(){
	local wx=''
	WgetToStdout wx "https://raw.githubusercontent.com/jmpessoa/lazandroidmodulewizard/master/package.json"
	assertEquals 0 $?

	$(WgetToStdout x "https://raw.githubusercontent.com/jmpessoa/lazandroidmodulewizard/master/package.json")
	assertFalse $?



}

. $(which shunit2)
