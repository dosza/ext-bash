#!/bin/bash
source ~/Dev/common-shell-lib/common-shell.sh

if [ "$(which shunit2)" = "" ]; then
	echo "missing shunit2"
	if [  "$(which wget)" = "" ]; then
		echo "try download manual in https://github.com/kward/shunit2/archive/master.zip, unzip and add folder in PATH"
		
	else
		echo "trying  download shunit2 in /tmp/tmp_shunit2 folder!"
		mkdir /tmp/tmp_shunit2
		cd /tmp/tmp_shunit2
		wget  -c "https://github.com/kward/shunit2/archive/master.zip"
		unzip  -o "master.zip" 
		export PATH=$PATH:$PWD/shunit2-master
		cd "$OLDPWD"
	fi
fi

testStrLen (){
	local str="my"
	assertEquals $(strLen "$str") 2
	
	str="is Daniel"
	assertEquals $(strLen "$str" ) 9

	str="The Crown"
	assertEquals $(strLen "$str") ${#str}
	assertEquals $(strLen $str) 3

}




testStrGetSubstring(){
	local str="is Daniel"
	assertEquals "$(strGetSubstring "$str" 3 7)" "Daniel"
}

testStrGetCurrentChar(){
	local str="is Daniel"
	assertEquals "$(strGetCurrentChar "$str" 0)" "i"
	assertEquals "$(strGetCurrentChar "$str" 3)" "D"
	assertEquals "$(strGetCurrentChar "$str" 4)" "a"
}

testStrRemoveAll(){
	local str="time"
	assertEquals "$(strRemoveAll "$str" "time" )" ""
	str="babaca"
	assertEquals "$(strRemoveAll "$str" "baba" )" "ca"

}


testStrRemoveShortStart(){
	local str="abcABC123ABCabc" #exempla by: https://tldp.org/LDP/abs/html/string-manipulation.html

	local shortstr="$(strRemoveShortStart "$str" 'a*C' )"  #  Strip out shortlest match between 'a' and 'C'.
	assertEquals "$shortstr" "123ABCabc"

	str="/etc/fstab"
	shortstr="$(strRemoveShortStart "$str" "/etc/")"
	assertEquals "$shortstr" "fstab"

	str="/usr/bin/python"
	shortstr="$(strRemoveShortStart "$str" "/usr/")"
	assertEquals "$shortstr" "bin/python"
}



testRemoveLongStart(){
	local str="abcABC123ABCabc" #exempla by: https://tldp.org/LDP/abs/html/string-manipulation.html
	local shortstr="$(strRemoveLongStart "$str" 'a*C' )" #  Strip out longest match between 'a' and 'C'.
	assertEquals "$shortstr" "abc"

}

testRemoveShortEnd(){
	local str="/tmp/LAMW4Linux-master/lamw_manager/lamw_manager"
	local shortstr="$(strRemoveShortEnd "$str" "/lamw_manager")"
	assertEquals "$shortstr" "/tmp/LAMW4Linux-master/lamw_manager"

	str="bainabcdefgIJKabcdefIJK"
	local shortstr="$(strRemoveShortEnd "$str" 'a*K')"

	assertEquals  "$shortstr" "bainabcdefgIJK"
}

testRemoveLongEnd(){
	local str="xyzabcdefgIJKabcdefIJK"
	local shortstr="$(strRemoveLongEnd "$str" 'a*K')" # Strip out longest match between 'a' and 'K'.
	assertEquals  "$shortstr" "xyz"
}



testSplitStr(){
	local my_array=()
	local my_str="Meu;nome;é;Daniel;Oliveira;Souza"
	splitStr "$my_str" ";" my_array
	assertEquals  ${#my_array[*]} 6

	my_str="The Crown Series IV"
	splitStr "$my_str" " " my_array
	assertEquals ${#my_array[*]} 4

	my_str="       int var = null"
	splitStr "$my_str" " " my_array
	assertEquals ${#my_array[*]} 11

	my_array=('xz')
	my_str="the crown series IV"
	splitStr "$my_str" " " my_array
	assertEquals ${#my_array[*]} 4

	my_str="code"
	splitStr "$my_str" " " my_array
	assertEquals ${#my_array[*]} 1

}


# Load and run shUnit2.
. $(which shunit2)
