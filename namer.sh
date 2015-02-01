#!/bin/bash

# (c) 05-17-2012 jurcapavel@sssvt.cz


### http://stackoverflow.com/questions/18743284/batch-rename-files

# file ab.xy|grep (audio|video),
# pripadne jen -mp3 SWITCH

# musite si byt jisti, ze ty soubory na nicem nezavisi!

# pro snazsi pouzivani-> alias nebo export PATH


############################################################
# ONLY for files you're not gonna feel sorry if the things go wrong
############################################################

#
# pridat "pattern" pro hromadne prejmenovani fotek
# napr.: namer "morava 2012" fotky
# => ./fotky/morava-2012-035.jpg
#

#!!! LOOK BEFORE YOU LEAP !!!
#this script doesn't rename files/dirs preceding with dots \
						#(hidden one's in POSIX)
rm -f /tmp/.summary #remove last log file
cd "/run/media/pavel/exter/foto/" 2>/dev/null #here set working folder
[ "$?" == 1 ] && echo "Specified directory does not exist!" && exit 2
#'-maxdepth NUM' determines how many folders in depth in folder's hierarchy \
	#set variable depth="" for recursion still deeper down
depth="-maxdepth 1" #stay in current directory
purple=`tput setaf 5`
lblue=`tput setaf 6`
def=`tput sgr0`
rep="[-[:space:],]"
ext="*"
typ="f" #default is renaming files
order=cat #rename in ascending order by FILE name
let x=0
let citac=0
for a
do
	case $a in
		#file/dir name: remove all chars except a-zA-Z0-9._ one's \
			#rep="[^[:alnum:]]" IS REALLY OFFENSIVE!
		--tight) rep="[^[:alnum:]\.]";; #use this very carefuly
		#look for directories instead of files \
			#rename in descending order by DIR name
		-d|--dir) typ="d";order=tac;;
		--czech) czech=true;; #replace czech chars for english one's
		#u can make your own file restriction
		--wma) ext="[wW][mM][aA]";; #applicable to WMA files only
		--wav) ext="[wW][aA][vV]";;
		--mp3) ext="[mM][pP]3";;
		--mp4) ext="[mM][pP]4";;
		*) echo "Unknown option. Sorry.";exit 2;;
	esac
done
#
#	treating files preceding with dashes
#	--> must use absolute path (or ./) OR -- to negate all switches
#	or quotation marks (apostrophes)
#	example: mv -- --file -file OR mv ./--file ./-file OR
#		 mv "--file.htm" "--file.html"
#
cz=( '(a|á|ä)' '(c|č)' '(d|ď)' '(e|é|ě|ë)' '(i|í)' '(n|ň)' '(o|ó|ö)' \
	'(r|ř)' '(s|š)' '(t|ť)' '(u|ú|ů|ü)' '(y|ý)' '(z|ž)' )
CZ=( '(A|Á)' '(C|Č)' '(D|Ď)' '(E|É|Ě|Ë)' '(I|Í)' '(N|Ň)' '(O|Ó|Ö)' \
	'(R|Ř)' '(S|Š)' '(T|Ť)' '(U|Ú|Ů|Ü)' '(Y|Ý)' '(Z|Ž)' )
function czech_chars()
{
	file=$b
	for (( char=0;${char}-${#cz[*]};char++ ))
	do
		file=`echo $file| \
			sed -r "s/${cz[${char}]}/"${cz[${char}]:1:1}"/g"| \
			sed -r "s/${CZ[${char}]}/"${CZ[${char}]:1:1}"/g"`
	done
	b=$file
}
#
# PRIDANO "|sort|"
# protoze prikaz 'find' je nekonzistentni!
#
# tahle smycka je ale prasarna; cely to predelat!
find `echo ${depth}` -type ${typ}|grep -Ev "/\.+"|grep "\.$ext$"|${order}|sort|while read line
do
	pref=`echo "${line}"|sed "s/[^/]*$/""/"` #until the last trailing char
	[ "$typ" = "f" ] && \
		var=`echo "${line:${#pref}}"|sed -r "s/\.[^\.]+$/""/"` || \
		var=`echo "${line:${#pref}}"`
	suf=`echo "${line:$[ ${#pref}+${#var} ]}"| \
		sed "s/[[:space:]]/""/g"|tr [:upper:] [:lower:]` #file extension
	#it's possible instead of '$rep' place own pattern/string/char \
		#but modificate this at your peril!
	b=`echo "$var"|sed -r "s/(^$rep+|$rep+$)/""/g"| \
		sed -r "s/$rep+/"-"/g"|tr [:upper:] [:lower:]`
	[ $czech ] && czech_chars
	#mv "$line" "${pref}${b}${suf}" &>/dev/null
	#mv "$line" "${pref}${b}${suf}"
	let citac+=1
	neco="00000000${citac}"
	ahoj="${neco:$[ ${#neco} - 3 ]}"
	mv "$line" "${pref}opl-vlaky-2014-${ahoj}${suf}"
	[ "$?" == 0 ] && \
	let x+=1 && \
	( echo -en "\t${def}'${purple}${line:2}${def}' >> "; \
        echo "${lblue}${pref:2}${b}${suf}${def}"; \
	#/tmp/.summary is a log file from the last running-the-script
	echo -e "'${line:2}' >> ${pref:2}${b}${suf}\n$x" >> \
		/tmp/.summary 2>/dev/null )
done
echo -n ${def}
[ -e "/tmp/.summary" ] && \
	echo -e "\tthis log can be found in /tmp/.summary" && \
	( if [[ "$typ" = "f" ]]; then echo -n "FILE MODE: ";else \
	echo -n "DIR MODE: "; fi; \
	if [[ "`tail -n1 /tmp/.summary`" > "1" ]]; then \
	echo -n "`tail -n1 /tmp/.summary` were "; else \
	echo -n "1 was "; fi; \
	echo -e "renamed.\n*have a great day!"; )
exit 0
