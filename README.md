namr
====

rename improperly named mp3 files

---
replace

* spaces
* single quotes
* ...
* whatever chars beyond ASCII

with defined 


### use cases

* can't switch keyboard layout
* can't change terminal's *LC_ALL*, *LANG* etc.
* [cp](http://www.gnu.org/software/coreutils/manual/html_node/cp-invocation.html) telling you about invalid chars
* [$IFS](http://tldp.org/LDP/abs/html/special-chars.html#FIELDREF)
* u just hate spaces and all the mess in your mp3 files

problemy s locale pri kopirovani WIN na Linuxu

http://perlgeek.de/en/article/set-up-a-clean-utf8-environment
http://community.spiceworks.com/topic/271363-how-do-i-remove-invalid-utf-8-characters-in-filenames-using-bash


### usage

first you'll get a dump
about possible replacements

chmod +x namr.pl
echo "alias namr='$HOME/namr.pl -f '" >> $HOME/.bashrc
source ~/.bashrc

```$> namr [ DIRs|FILEs ]```

now you get `.namr` file
and can adjust the forthcoming
replacements

```$> namr -f ```
u sure? [yes/no] (no):
takes that `.namr` file and starts it's job

there's still **no** warranty though

### changelog

* namr.sh   
initial commit  
3 years old  

