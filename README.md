# Common Shell Library

What is?
---
A  Shell Script Library that simplifies  that provides several functions that simplify the execution of complex commands like sed, shell expansions, among others ...

Motivation 
---
[UFMT-LAB-Tools](https://github.com/DanielOliveiraSouza/ufmt-cua-lab-tools),[PostInstall](https://github.com/DanielOliveiraSouza/Linux-PostInstall) and [LAMW Manager](https://github.com/DanielOliveiraSouza/LAMW4Linux-installer) are command line tools that automate the installation of many software. 
From the development of these tools, it is observed that there is a set of routines that can be standardized.
This level of automation usually requires the execution of commands with poorly readable syntax. 
For example replacing a line in a file as a sed command.

Functions
---
Note: Em uma declaração de função em shell script dentro dos parentes não há argumentos. O uso apenas para facilitar o entedimento do leitor.
Cada argumento é referenciado por $1, $2, ... $n


```bash
 # a real function declaration
 name(){
 	echo "your name is $*"
}
  ```
  
+ searchLineFile(file, line)  //verify if a *line* exists in  a *file*
+ replaceLine(file,string_to_find,string_to_replace)
+ deleteLine(file,line_to_delete)
+ scappeString(str) //
+ AptInstall(packages) //install apt packages
