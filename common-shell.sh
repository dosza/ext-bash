#!/bin/bash
#-------------------------------------------------------------------------------------------------#
#Universidade federal de Mato Grosso (mater-alma)
#Course: Science Computer
#version: 0.2.0	
#Date: 12/11/2020
#Description: Thi script provides common shell functions
#-------------------------------------------------------------------------------------------------#


#-------------------versions-------------------------------
#v0.1.0 add support to write a array to file, get a file (with validation)
#v0.2.0 add advanced support manipulation of string 

#GLOBAL VARIABLES
#----ColorTerm
export VERDE=$'\e[1;32m'
export AMARELO=$'\e[01;33m'
export SUBLINHADO=$'4'
export NEGRITO=$'\e[1m'
export VERMELHO=$'\e[1;31m'
export VERMELHO_SUBLINHADO=$'\e[1;4;31m'
export AZUL=$'\e[1;34m'
export NORMAL=$'\e[0m'
export BASH_TRUE=0
export BASH_FALSE=1
APT_LOCKS=(
	"/var/lib/dpkg/lock"
	"/var/lib/apt/lists/lock"
	"/var/cache/apt/archives/lock"
	"/var/lib/dpkg/lock-frontend"
)
shopt  -s expand_aliases
alias newPtr='declare -n'
alias isFalse='if [ $? != 0 ]; then return 1; fi'
alias WARM_ERROR_NETWORK_AND_EXIT='if [ $? != 0 ]; then echo "possible network instability!!";exit 1;fi'

initArrayAsCommand(){
	eval "$1=(`$2`)"
}



isVariableArray(){
	declare -p $1 | grep '^declare -[aA]' > /dev/null
}

isVariableAssociativeArray(){
	declare -p $1 | grep '^declare -A' > /dev/null
}

len(){
	isVariabelDeclared $1
	if [ $? != 0 ]; then strLen "$1" ;return ;fi

	isVariableArray $1
	if [ $? = 0 ]; then 
		eval "echo \${#$1[*]}"
	else
		eval "echo \${#$1}"
	fi
}

#check f variable exists

isVariabelDeclared(){
	if [ "$1" = "" ]; then return 1; fi

	declare -p "$1" &> /dev/null
	return $?
}

arraySlice(){
	if [ "$1" = "" ] || [ $# -lt 3 ]; then return 1 ; fi

	isVariabelDeclared $1
	isFalse

	newPtr ref_array_sliced=$1


	case $# in 
		3 )
			isVariabelDeclared $3
			isFalse	
			newPtr ref_ret_array_sliced=$3
			ref_ret_array_sliced=("${ref_array_sliced[@]:$2}")
		;;
		4 )
			isVariabelDeclared $4
			isFalse

			newPtr ref_ret_array_sliced=$4
			ref_ret_array_sliced=("${ref_array_sliced[@]:$2:$3}")
		;;
	esac

}

arrayToString(){
	if [ "$1" = "" ] ; then return 1 ; fi

	isVariabelDeclared $1
	isFalse

	newPtr array_str=$1
	echo "${array_str[*]}"
}
#This this function executes 'one or more commands' on each item in an array. Similar to the map () method of javascript and python.

#This function works in two ways: it accepts 3 or 4 arguments.
# names=(Elis Ethel Izzy)

#Form 1:
#$1 is the input array (example: names)
#$2 is an iterative variable (example: name)
#$3 is the commands to be executed: (example: 'echo $name')

#Form 2:
#$3 is a index variable (ex: index )
#$4 is the commands to execute 'echo $name'
#using form1:
# arrayMap names name 'echo $name'
#using form2:
#arrayMap names name index 'echo ${names[index]}'

arrayMap(){

	if [ $# -lt 3 ] || [ 4 -lt $# ] ; then return ; fi 
	
	isVariabelDeclared $1
	isFalse
	newPtr refMap=$1

	case $# in
		3)
			eval "for _mapIdx in ${!refMap[*]};do $2=\${refMap[\$_mapIdx]}; $3; done"
		;;
		4)
			eval "for $3 in ${!refMap[*]}; do $2=\${refMap[\$$3]}; $4; done" #  $2=$(eval echo ${refMap[$(echo \$$3)]});$4;done"
		;;
	esac
}

arrayFilter(){

	if [ $# -lt 3 ]; then return 1; fi 

	case $# in 
		4)
			isVariableArray $1 && isVariableArray $3
			isFalse
			newPtr refArray=$1			
			newPtr refFilter=$3


			refFilter=()
				
			eval "isVariableAssociativeArray $3
			if [ \$? != 0  ]; then 
				_appendArrayFiltered(){ refFilter+=(\$$2) ; }
			else
				_appendArrayFiltered(){ refFilter[\$$3]=\$$2 ; }
			fi

			for _filterIdx in ${!refArray[*]};do  
				$2=\${refArray[\$_filterIdx]}
				$4
				if [ \$? = 0 ]; then 
					_appendArrayFiltered
				fi
			done" 
			
		;;
		5)
			isVariableArray $1 && isVariableArray $4
			isFalse
			newPtr refArray=$1
			newPtr refFilter=$4

			refFilter=()
			

			#arrayFilter array iterator index filterD '{commands}'
			#arrayFilter packages pack index filter '{...}'

			eval "isVariableAssociativeArray $4
			if [ \$? != 0  ]; then 
				_appendArrayFiltered(){ refFilter+=(\$$2) ; }
			else
				_appendArrayFiltered(){ refFilter[\$$3]=\$$2 ; }
			fi

			for  $3 in ${!refArray[*]}
			do 
				$2=\${refArray[\$$3]}
				$5
				if [ \$?  = 0 ]; then 
					_appendArrayFiltered
				fi
			done"
		
		;;
	esac
	unset _appendArrayFiltered
}


# returns to stdout a string  to lowcase
# $1 is a string 
# $2 flag  all to ZERO
strToLowerCase(){
	if [ "$1" = "" ]; then return 1 ; fi

	echo "${1,,}"

}

# returns to stdout a string  to UpperCase
# $1 is a string 
strToUpperCase(){
	if [ "$1" = "" ]; then return 1 ; fi
	echo "${1^^}"
}

isStrEqual(){
	if [ "$1" = "$2" ]; then
		echo $BASH_TRUE
	else
		echo $BASH_FALSE
	fi
}

isStrEmpty(){
	isStrEqual "$1" ""
}
#get a substring  with of str with offset and length, is a funtion to expansion ${str:$offset:$length}
# $1 is a string, note:
# $2 is a offset
# $3 is a length of string
# returns to stdout of substring
strGetSubstring(){
    if [ ${#} -lt 2 ] || ( [ "$1" = "" ] || [ ${2} -lt 0 ] ||  [ ! -z "$3" ] && [ $3 -lt  1 ]  ); then echo "" ;return ;fi


  	case $# in 
  		2) echo "${1:$2}" ;;
		3) echo "${1:$2:$3}" ;;
	esac
}

# get a substring  with of str with offset and length, is a funtion to expansion ${str:$offset:$length}
# $1 is a string, note:
# $2 is a offset
# $3 is a length of string
# returns to stdout of substring
#note is small implementation 
str_substring1(){
    echo "${1:$2:$3}"
}


#get a lenght of string, is function to expansion ${#str}
# $1 string of input
#return to ouput a length of string
strLen(){
    echo "${#1}"
}
strGetCurrentChar(){
    echo "${1:$2:1}"
}

#remove the shortest match from start string, is a function to expansion ${str#$substr}
# $1 is a string input
# $2 is substring to delete
# returns to output a string with $2 removed.

strRemoveShortStart(){
    local str="$1"
    local del_substr="$2"
    echo "${str#$del_substr}"
}

#remove longest match from start string, is  a function to expansion ${str##$substr}
# $1 is a string input
# $2 is substring to delete
# returns to output a string with $2 removed.

strRemoveLongStart(){
    local str="$1"
    local del_substr="$2"
    echo "${str##$del_substr}"
}

#remove the shortest match from end string, is a function to expansion ${str%$substr}
# $1 is a string input
# $2 is substring to delete
# returns to output a string with $2 removed.

strRemoveShortEnd(){
    local str="$1"
    local del_substr="$2"
    echo "${str%$del_substr}"
}


#remove the longest match from end string, is a function to expansion ${str%%$substr}
# $1 is a string input
# $2 is substring to delete
# returns to output a string with $2 removed.


strRemoveLongEnd(){
    local str="$1"
    local del_substr="$2"
    echo "${str%%$del_substr}"
}

#Replace the first ocorrence of substring, is a function to expansion ${str/$find/$replace}
# $1 is a string input
# $2 is substring to find
# $3 is substring to replace
# returns to ouput a string with $2 replaced by $3

strReplace(){
	local str="$1"
	local find="$2"
	local replace="$3"
	echo "${str/$find/$replace}"
}

#Replace all ocorrences of substring, is a function to expansion ${str//$find/$replace}
# $1 is a string input
# $2 is substring to find
# $3 is substring to replace
# returns to ouput a string with $2 replaced by $3

strReplaceAll(){
	local str="$1"
	local find="$2"
	local replace="$3"
	echo "${str//$find/$replace}"
}
strRemoveAll(){
    local str="$1"
    local del_substr="$2"
    echo "${str//$del_substr/}"
}


# this function split a string using a builtin command
# $1 is string
# $2 is a delimiter
# $3 is a array variable name 
# returns: replace content of array passed by reference (name) with string splited

Split (){ 
	if [ $#  -lt 3 ] || [ "$1" = "" ] || [ "$2" = "" ] ||  [ "$3" = "" ] ; then 
		return 1
	fi

	isVariabelDeclared $3
	isFalse


	local str="$1"
	local delimiter="$2"
	newPtr array_splitted_ref=$3
	readarray -d "$delimiter" -t array_splitted_ref <<< "$str"
}



# Split a string input in array using a delimeter
# $1 is a string input
# $2 is a string delimiter
# $3 is  array variable name, note: array must be declared!
# result: override array content with string splitted

splitStr(){
    if [ $# -lt 3 ] || ( [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ]  ); then
        echo "missing args"
        return 1
    fi

    isVariabelDeclared $3
	isFalse
		

    local str="$1"
    local delimiter="$2"
    local index_start_substr=0
    declare -n array_Splitted_ref="$3"
    array_Splitted_ref=()

    echo "$1" | grep "$2" > /dev/null

    if [ $? = 0 ] ; then

        for ((i=0 ;i  <= $(strLen "$str") ;i++)); do

            local current_token="$(strGetCurrentChar "$str" $i)"

            if [ "$current_token" = "$delimiter" ] || [ $i = $(strLen "$str") ]; then
                local length_substring=$((i-index_start_substr))
                local substring="$(str_substring1 "$str" $index_start_substr $length_substring)"
                array_Splitted_ref[${#array_Splitted_ref[*]}]="$substring"
                index_start_substr=$((i+1))
            fi      
        done

    else
        array_Splitted_ref[0]="$1"
    fi
}





#cd not a native command, is a systemcall used to exec, read more in exec man 
changeDirectory(){
	if [ "$1" != "" ] ; then
		if [ -e "$1"  ]; then
			cd "$1"
		else
			echo "\"$1\" does not exists!" &<2
			exit 1
		fi
	fi 
}


# Verify se user is sudo member (return  1 false, 0 to true 	yttttt)
isUsersSudo(){
	local ret=0
	if [ "$1" = "" ]; then 
		echo "$1 can't be empty"
		ret=1
	fi

	cat /etc/group | grep sudo | grep $1 /dev/null 2>&1
	if [ $? != 0 ]; then
		ret=$?
	fi
	return $ret

}
# searchLineinFile(FILE *fp, char * str )
#$1 is File Path
#$2 is a String to search 
#this function return 0 if not found or 1  if found
searchLineinFile(){
	local flag=0
	local line=''
	if [ "$1" != "" ]; then
		if [ "$2" != "" ]; then
			while  read line 
			do
				if [ "$line" = "$2" ]; then
					flag=1
					break
				fi
			done < "$1"
		fi
	fi
	return $flag # return value 
}


# Gera uma string com escape
# entrada: $1 uma string 
GenerateScapesStr(){
	if [ "$1" = "" ] ; then
		echo "There is no string to scape!"; return 1
	fi

	echo "$1" | grep '\\' > /dev/null
	if [  $? = 0 ]; then  # se a string já está com com escape, retorne a string 
		echo "$1"; return 
	fi

	echo "$1" | sed 's|\/|\\\/|g'  | sed "s|\.|\\\.|g" | sed "s|\-|\\\-|g" | sed "s|\"|\\\"|g" | sed "s/'/\\\'/g"
}


# Find and replace line an file 
# $1 filepath
# $2 string_to_find (scapped)
# $3 string_to_replace(scapped)
replaceLine(){
	if [  $# -lt 3 ]; then 
		echo "missing args! $1 filename,$2 string to find, $3 string to replace"
		return 1
	fi

	if [ ! -e "$1" ]; then 
		echo "There is no \"$1\" file"
		return 1;
	fi
	local str_to_find="$2"
	local str_to_replace="$3"
	sed -i "s|${str_to_find}|${str_to_replace}|g" "$1"	
}



#write override writefile
#$1 filename
#$2 stream 
#note a stream must to be a formatted string
WriterFile(){
	if [ $# = 2 ]; then
		local filename="$1"

		isVariableArray $2
		if [ $? != 0 ]; then
			return 1
		fi

		newPtr stream=$2
		for(( _index_stream=0;_index_stream<${#stream[@]};_index_stream++));do
			local line="${stream[_index_stream]}"
			if [ $_index_stream = 0 ]; then 
				printf "%b" "$line" > "$filename"
			else
				printf "%b" "$line" >> "$filename"
			fi
		done
	fi
}

WriterFileln(){
	if [ $# = 2 ]; then
		local filename="$1"

		isVariableArray $2
		isFalse
		

		newPtr stream=$2
		for(( _index_stream=0; _index_stream<${#stream[@]}; _index_stream++ )); do 
			local line="${stream[_index_stream]}"
			if [ $_index_stream = 0 ]; then 
				printf "%b\n" "$line" > "$filename"
			else
				printf "%b\n" "$line" >> "$filename"
			fi
		done
	fi
}

#Append a file if exists
#$1 filename
#$2 stream reference
#sintaxy WriterFile(char filename, char * stream )
#note a stream must to be a formatted string
AppendFile(){
	if [ $# = 2 ]; then
		local filename="$1"

		isVariableArray $2
		isFalse
		

		newPtr stream=$2
		if [  -e  $filename ]; then 
			for ((_index_stream=0;_index_stream<${#stream[*]};_index_stream++));do
				local line="${stream[_index_stream]}"
				printf "%b" "$line" >> "$filename"
			done
		else
			echo "\"$filename\" does not exists!"
		fi
	fi
}

AppendFileln(){
	if [ $# = 2 ]; then
		local filename="$1"

		isVariableArray $2
		isFalse
		

		newPtr stream=$2
		if [  -e  "$filename" ]; then 
			for ((_index_stream=0;_index_stream<${#stream[*]};_index_stream++));do
				local line="${stream[$_index_stream]}"
				printf "%b" "$line" >> "$filename"
			done
		else
			echo "\"$filename\" does not exists!"
		fi
	fi
}

InsertUniqueBlankLine(){
	if [ "$1" != "" ] ; then
		if [ -e "$1" ] ; then 
			local aux=$(tail -1 "$1" )       #tail -1 mostra a última linha do arquivo 
			if [ "$aux" != "" ] ; then   # verifica se a última linha é vazia
				sed  -i '$a\' "$1" #adiciona uma linha ao fim do arquivo
			fi
		fi
	fi
}

IsUserRoot(){
	if  [  "$(whoami)" = "root" ];then #impede que o script seja executado pelo root 
		printf "Error: \"$1\" was designed  to run without root privileges\nExiting...\n" >&2 # >&2 is a file descriptor to /dev/stderror
		exit 1
	fi
}

Wget(){
	if [ $1 = "" ]; then echo "Wget needs a argument"; exit 1;fi
	
	local wget_opts="-c --timeout=300"
	wget $wget_opts $*
	if [ $? != 0 ]; then
		wget $wget_opts $*
		WARM_ERROR_NETWORK_AND_EXIT
	fi
}

#Verifica se um ou mais arquivos estão sendo usados por processos, 
#$1 é  mensagem que será exibida na espera ...
IsFileBusy(){
	if [ $# = 0 ]; then
		echo "IsFileBusy needs a argument"
		exit 1;
	fi

	local args=($*)
	unset args[0]
	local msg=0
	while fuser ${args[*]} > /dev/null 2<&1 #enquato os arquivos estiverem ocupados ....
	do
		if  [ $msg = 0 ]; then 
			echo "Wait for $1..."
			msg=1;
		fi
	done
}

#Essa instala um ou mais pacotes from apt 
AptInstall(){
	
	local apt_opts=(-y --allow-unauthenticated)
	local apt_opts_err=(--fix-missing)

	if [ $# = 0 ]; then
		echo "AptInstall requires arguments"
		exit 1
	fi
	IsFileBusy apt ${APT_LOCKS[*]}
	apt-get update
	apt-get install $* ${apt_opts[*]}
	if [ "$?" != "0" ]; then
		apt-get install $* ${apt_opts[*]} ${apt_opts_err[*]}
		WARM_ERROR_NETWORK_AND_EXIT
	fi
	apt-get clean
	apt-get autoclean
}

writeAptMirrors(){
	isVariableArray $1 && isVariableArray $2
	isFalse

	newPtr ref_str_mirrors=$1
	newPtr ref_file_mirros=$2

	echo "Writing mirrors ..."
	arrayMap ref_str_mirrors mirror index '{
		local file_mirror=${ref_file_mirros[$index]}
		local mirror_str=(
			"### THIS FILE IS AUTOMATICALLY CONFIGURED"
			"###ou may comment out this entry, but any other modifications may be lost." 
			"$mirror" 
		)
		WriterFileln $file_mirror mirror_str
	}'
}

ConfigureSourcesListByScript(){
	if [ $# -lt 1 ]; then return 1; fi

	isVariableArray $1
	isFalse

	newPtr ref_scripts_link=$1
	arrayMap ref_scripts_link script 'Wget -qO- "$script" | bash - '
	
}

getAptKeys(){
	if [ $# -lt 1 ] || [ "$1" = "" ] ; then return 1; fi

	isVariableArray $1
	newPtr ref_apt_keys=$1
	echo "Getting apt Keys ..."
	arrayMap ref_apt_keys key 'Wget -qO- "$key" | apt-key add - '
	
}

ConfigureSourcesList(){
	if [ $# -lt 3 ]; then return 1; fi
	getAptKeys $1
	writeAptMirrors $2 $3
}


#Retorna verdadeiro se o pacote $1 está instalado
isDebPackInstalled(){
	if [ "$1" = "" ]; then
		echo "missing package name";
		return 0;
	fi
	exec 2> /dev/null dpkg -s "$1" | grep 'Status: install' > /dev/null #exec 2 redireciona a saída do stderror para /dev/null
	
	if [ $?  = 0 ]; then
		return 1
	else
		return 0;
	fi
}


CheckPackageDebIsInstalled(){
	if [ "$1" = "" ]; then 
		echo "Package cannot be empty"
		return 2
	fi
	exec 2> /dev/null dpkg -s  "$1" | grep 'Status: install'  > /dev/null
}
getCurrentDebianFrontend(){
	tty | grep pts/[0-9] > /dev/null 
	if [ $? = 0 ]; then
		CheckPackageDebIsInstalled libgtk3-perl 
		local is_gnome_apt_frontend_installed=$?
		
		CheckPackageDebIsInstalled "debconf-kde-helper"
		local is_kde_apt_frontend_installed=$?


		if [ $is_gnome_apt_frontend_installed = 0 ]; then 
			export DEBIAN_FRONTEND=gnome
		else 
			if [ $is_kde_apt_frontend_installed = 0 ];then
				export DEBIAN_FRONTEND=kde
			fi
		fi
	fi
}
