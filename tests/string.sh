#!/bin/bash

source ./get-shunit2

testIsStrEqual(){
	local str="my name"
	local st2="$str"

	assertTrue "[ $(isStrEqual "$str" "$st2") ]"
	assertTrue "[ $(isStrEqual "$str" "$st2")  -eq $BASH_TRUE ]"
	assertTrue "[ $(isStrEqual "$str" "$st2") ]"
	assertTrue "[ $(isStrEqual "$str" "$st2") -eq $BASH_TRUE ]"
	st2="blablabla"
	assertFalse "[ $(isStrEqual "$str" "$st2") -eq $BASH_TRUE ]"
	assertFalse "[ $(isStrEqual "Daniel" "Kate") -eq $BASH_TRUE ]"

}


testIsStrEmpty(){
	local str="my name"

	assertFalse "[ $(isStrEmpty "$str") -eq $BASH_TRUE ]"
	assertFalse "[ $(isStrEmpty "Daniel") -eq $BASH_TRUE ]"
	str=""
	assertTrue "[ $(isStrEmpty "$str") ]"
	assertTrue "[ $(isStrEmpty "") ]"
	assertTrue "[ $(isStrEmpty "") -eq $BASH_TRUE  ]"
	assertTrue "[ $(isStrEmpty "$str") -eq $BASH_TRUE  ]"

}
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
	local aux=""
	assertEquals "$(strGetSubstring "$str" 3 7)" "Daniel"

	str="The Crown Series IV"
	aux="$( strGetSubstring "$str" 10 )"
	assertEquals  "$aux" "Series IV"

	str="value to"
	assertTrue   "["$(strGetSubstring "$str")" -eq  "" ]" #obter substring sem passar o parametro $offset
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
	shortstr="$(strRemoveShortEnd "$str" 'a*K')"

	assertEquals  "$shortstr" "bainabcdefgIJK"
}

testRemoveLongEnd(){
	local str="xyzabcdefgIJKabcdefIJK"
	local longstr="$(strRemoveLongEnd "$str" 'a*K')" # Strip out longest match between 'a' and 'K'.
	assertEquals  "$longstr" "xyz"
}



testSplit(){
	local my_array=()
	local my_str="Meu;nome;é;Daniel;Oliveira;Souza"
	Split "$my_str" ";" my_array
	assertEquals  ${#my_array[*]} 6

	my_str="The Crown Series IV"
	Split "$my_str" " " my_array
	assertEquals ${#my_array[*]} 4

	my_str="       int var = null"
	Split "$my_str" " " my_array
	assertEquals ${#my_array[*]} 11

	my_array=('xz')
	my_str="the crown series IV"
	Split "$my_str" " " my_array
	assertEquals ${#my_array[*]} 4

	my_str="code"
	Split "$my_str" " " my_array
	assertEquals ${#my_array[*]} 1

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

testStrReplace(){
	local path="/home/user/LAMW4Linux-master/lamw_manager/lamw_manager"
	local base_path="$(strReplace "$path" "/lamw_manager" "" )"
	assertEquals "/home/user/LAMW4Linux-master/lamw_manager" "$base_path"

	path="name=admin"
	base_path="$(strReplace "$path" "admin" "user" )"
	assertEquals "name=user" "$base_path"
}

testStrReplaceAll(){
	local path="/home/user/LAMW4Linux-master/lamw_manager/lamw_manager"
	local base_path="$(strReplaceAll  "$path" "/lamw_manager" "" )"
	assertEquals "/home/user/LAMW4Linux-master" "$base_path"
}


testStrToUpperCase(){
	local str="my name is ammy pond"

	assertEquals "$(strToUpperCase "$str")" "MY NAME IS AMMY POND"

	str="my name is Ammy Pond"

	assertEquals "$(strToUpperCase "$str")" "MY NAME IS AMMY POND"

}


testStrToLowerCase(){
	local str="MY NAME IS AMMY POND"
	assertEquals "$(strToLowerCase "$str")" "my name is ammy pond"

	str="My Name is Ammy Pond"
	assertEquals "$(strToLowerCase "$str")" "my name is ammy pond"
}


# Load and run shUnit2.
. $(which shunit2)
