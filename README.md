# Common Shell Library
<p align="center">
	  <a href="https://github.com/dosza/common-shell-lib/archive/master.zip"><img src="https://img.shields.io/badge/Release-v0.3.0-green"/> </a><img src="https://img.shields.io/badge/language-shell-blue"/> <a href="https://github.com/dosza/common-shell-lib/LICENSE.md"><img src="https://img.shields.io/github/license/dosza/common-shell-lib"/></a>
</p>

What is?
---
A  Shell Script Library that simplifies  that provides several functions that simplify the execution of complex commands like sed, shell expansions, among others ...

Motivation 
---
[UFMT-LAB-Tools](https://github.com/DanielOliveiraSouza/ufmt-cua-lab-tools),[PostInstall](https://github.com/DanielOliveiraSouza/Linux-PostInstall) and [LAMW Manager](https://github.com/DanielOliveiraSouza/LAMW4Linux-installer) are command line tools that automate the installation of many software.
From the development of these tools, it is observed that there is a set of routines that can be standardized.
This level of automation usually requires the execution of commands with poorly readable syntax. 
The idea is to provide a level of abstraction (generic) that the *user* can use in his context.

Advantages
---
Rapid development of installation and configuration scripts using WriterFileln function families
Support for referencing variables using the newPtr keyword (alias to declare -n )
Easy development of installers for debian systems, using custom APT functions
+ Facilitates repository configuration, using the function

Functions
---
Note: a shell function is declared by Name(){COMMANDS;} or function Name{ COMMANDS;}
Each argument is referenced by \$1..\$n.

The list below includes the parameters within the parentheses for teaching purposes.
+ replaceLine(file,string_to_find,string_to_replace)
+ deleteLine(file,line_to_delete)
+ scappeString(str) //
+ AptInstall(packages) //install apt packages

New: String manipulation functions
---
+ strLen(str) //returns to output of length of string, a equivalent C strlen()
+ strGetSubstring(str,offset,length) // returns to output a str delimeted of offset and lenght
+ strGetCurrentChar(str,index) //returns to output a char delimited by index, a equivalent C str[index];
+ Split(str,delimiter,ref_array) // split (using a builtin command) a string and store in ref_array ( ref_array is a reference to array )
+ splitStr(str,delimiter,ref_array) split a string and store in ref_array

New: Array Functions
---
+ arrayMap(array,item, '{commands...}') // executes 'one or more commands' on each item in an array.
+ arrayFilter(array, item, filtersItens, '[conditions]')
+ arrayToString(array)
+ arraySlice(array,offset,arraySliced) || arraySlice(array,offset,length,arraySliced)
+ forEach(array,item '{commands...}') //execute one or more commands, on each item in array, forEach is a function similar to arrayMap, but the iterator is a reference to the current element of the array
+	initArrayAsCommand(array, '{commands'}) //init an array as output of '{ commands }'
---


New: APT functions
---
This family call APT functions with -y and check erros param
+ AptInstall(args...) #install packages without need confirm action
+ getCurrentDebianFrontend() # set (if is possible) DEBIAN_FRONTEND=
+ getAptKeys(array_key_ref) # import apt keys to Apt from array of Urls: note
+ getDebPackVersion # returns a version of package  (.deb) installed
+ ConfigureSourcesListByScript(scripts_url) configure sources from array of url scripts (apt)
+ ConfigureSourcesList(repository, mirrors,apt_keys), configure sources


### sample:

```bash
#!/bin/bash 
# without common-shell-lib
sed  -i 's/stretch/buster/g' /etc/fstab

#with common shell library
#!/bin/bash
source ./common-shell.sh
replaceLine /etc/apt/sources.list  "stretch" "buster" 

  ```	
### sample: A length string
```bash
str="0000-000-000"
strLen "$str" #write 12 in output
```

### sample: Splitting a string 

```bash
source ./common-shell.sh
#split a string delimeted by ' ' (blank space)
my_array=()
str="Hello World!"
Split "$str" " " my_array # my_array=("Hello" "World!")
```

### sample: Getting a substring using a *offset* and *length*
```bash
source ./common-shell.sh
str="user@pc:~"
sub_str="$(strGetSubstring "$str" 5 2)" #sub_str="pc"
```

### sample: Installing packages using arrayMap
```bash
source ./common-shell.sh
packages=(gcc g++ wget)
arrayMap  packages package 'sudo apt-get install $package -y
```
**Notes**:
**packages** is array variable
**package** is name to iterator
'**sudo apt-get install $package**'  is a command to execute for each item in packages


### sample: Filter pars numbers and store in pars.
```bash
source ./common-shell.sh
numbers=({357..368})
pars=()
arrayFilter numbers number pars '((number %2 == 0))'
#show pars
arrayToString pars
```

### sample: Filter names with start of letter D
```bash
source ./common-shell.sh
names=(Davros Daniel Debra 'Yan Mordock' Woody)
matchD=()
regex_matched_to_d='^D'
arrayFilter names name matchD '[[ "$name" =~ $regex_matched_to_d ]]'
```

### sample: Calculing five times table with forEach
```bash
source ./common-shell.sh
five_times_table=({0..10})
  forEach five_times_table number 'number=$(echo "$number * 5"| bc )'
  arrayMap five_times_table multiple number 'echo "5 * $number = $multiple"' #printing five times table
```

### sample: setting up 3rd party repository quickly

```bash
source ./common-shell.sh

#example: configure google chrome, sublime text and microsoft teams repository!
repositorys=(
	"/etc/apt/sources.list.d/google-chrome.list"
	"/etc/apt/sources.list.d/sublime-text.list"
	"/etc/apt/sources.list.d/geogebra.list"
	"/etc/apt/sources.list.d/teams.list")

mirrors=(
	'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' 
	'deb https://download.sublimetext.com/ apt/stable/' 
	'deb http://www.geogebra.net/linux/ stable main'   
	"deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main")

apt_key_url_repository=(
	"https://dl-ssl.google.com/linux/linux_signing_key.pub"
	"https://static.geogebra.org/linux/office@geogebra.org.gpg.key"
	"https://packages.microsoft.com/keys/microsoft.asc")

# Note: requires admin
ConfigureSourcesList apt_key_url_repository mirrors repositorys
```

### sample: setting repository by url script download
```bash
source ./common-shell
# Configuring nodejs repository sample
scripts_url=(
  https://deb.nodesource.com/setup_lts.x 
)
ConfigureSourcesListByScript scripts_url #note requires admin 
