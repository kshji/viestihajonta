# Orienteering forking/variants checking  - VariantChecker

(c) Jukka Inkeri  2022-

Variant checking of orienteering.
Check variant using legs (control to control pairs) used by competitor/team. Not only variantcode.

Even variant codes look okay, course data can include mistakes. This checking system checks also 
control codes = used legs.

All teams have run the same leg variations at the end of the relay. 
Counting control to control pairs, count have to be same.

1st team is the default value which is used to comparing variations for other teams in the same class.
If the 1st team contains a mistake, all the rest of the teams go to the mistake list.

There is also online service:[Awot variantcheck](https://awot.fi/variantcheck/en/).

## Feedback ##
box: variantcheck
domain: awot.fi

OR [Discussion](https://github.com/kshji/viestihajonta/discussions) 

Jukka Inkeri

## Pre install
### Linux ja OS-X
Default: all this is already installed
 * bash
 * gawk
 * sort
 * grep
 * sed
 * tr

### Windows
If you are using WSL or WSL2 (Linux subsystem for Windows), then works just like as in the native Linux.

If you have Windows and not use WSL, then easiest method is to install 
[Git for Windows](https://gitforwindows.org/). Gitbash include all those needed commands.
On the desktop you have shortcut **GitBash**

##  Install

```sh
git clone https://github.com/kshji/viestihajonta.git
cd viestihajonta
# execute in this directory using CLI
```

Or download ZIP from Github and unzip it to the some directory.
[Download ZIP-file](https://github.com/kshji/viestihajonta/archive/refs/heads/main.zip)

## Execute in Windows
* execute ex. GitBash
* change working directory to the directory where you have unziped packet
* ex. C:\variantcheck
```sh
cd /c/variantcheck
```

## Examples
In the directory **sourcedata/examples** has some example files. You can try CLI using those examples.
"Kenraali" has three legs, using farsta. "virhe" file include mistakes. 

In the example directory has testing commands testi1.sh - testi7.sh. You can look those how to run some test competition.

CLI will make always directory ./tmp, there will be result files after executing.
```sh
./testi1.sh
```
## Executing priviledges for .sh files
If .sh files not include execute priviledge, then add it:
```sh
chmod a+rx *.sh sourcedata/examples/*.sh
```
## How it works
 * convert sourcedata to the normalized format (csv using delimiter |), used by this system
 * checking has done always using same normalized format 
 * if you need import to the new format, then you need to make own sourcedatacommand (source.XXXX.sh), which process some source format to the  normalized format
 * tmp/XXXX/**results** directory include after executing those normalized format files. Easy to look the normalized format.
 * source data could be in any directory, but directory **sourcedata** has done for that, you create subdirectory for every competitions.
   * directory and filenames is more safety to use if names include only US-ASCII7 chars: a-z or 0-9. No specialchars like öäå, or spaces. dot . and underline _ are okay.

## Ocad instructions

Online server include instructions.

# Checking - execute
## Sourcematerial version 1 - method ocad -  Cources (XML 3.0) and teamsvariations (txt) from Ocad
**radat.xml** ja **joukkuehajonnat.txt** OR 
**courses.xml** ja **teamvariants.txt**

Make courses using Ocad, relay variant or ex. individual butterfly variant
* Export from Ocad course.xml (IOF 3.0)
* Export from Ocad team variations teamvariants.txt 

This checking return always OK. If not then you have big mistakes or Ocad include mistake.

You can also use those result files and make manual editing for variants used by teams.
Example compare same club teams 1,2,3,... or comparing the best teams variant - not running same forking in same time.

This checking has done susing special csv file  **hajonta.lst**. You can edit those variants for teams and then use checking method **csv**.

### check method ocad
* check.variants.sh -c coursefile(xml) -t teamvariant(txt) -m 1 
* check.variants.sh -c coursefile(xml) -t teamvariant(txt) -m ocad
```sh
./check.variants.sh -c sourcedata/examples/relay1.course.Courses.v3.xml -t sourcedata/examples/relay1.course.Variations.txt -m ocad
# or
./check.variants.sh -c sourcedata/examples/radat.ocad.v3.xml -t sourcedata/examples/joukkuehajonnat.txt -m 2 
```

## Sourcematerial version 2 - csv - coursefile (XML) ja team variant using csv-file (Pirilä lst)
**radat.xml** and **hajonta.csv** / **hajonta.lst** OR
**course.xml** and **variant.csv** / **variant.lst** 

 * Ex. Export Cource from Ocad using IOF XML 2.0.3 or 3.0 format 
   *  Course information: Course Setting - Export - Courses IOF XML 3.0, name file courses...xml. Filename have to include **radat** or **course**
 * Teams variant in file **hajonta.csv** (or **variant.csv**)
   *  Pirilä-format (csv), look sourcedata/examples/hajonta.kenraali.csv
     * Sarja=Class,Rata-1 = Leg-1, ...
   *  there could be other columns, but this system use only cols Sarja, No, Rata-1, Rata-2, ..., Rata-25
   *  all classes in the same file

Example: hajonta.csv - variant.csv
```csv
Sarja;No;Rata-1;Rata-2;Rata-3
H21;1;AA;BB;CC
H21;2;AB;BA;CC
H21;3;BA;CB;AC
```
Name those files example:
 * radat.xml  or course.xml  - file have to include those strings, you can add any other strings to the filenames
 * hajonta.csv or variant.csl (or .lst), file have to include those strings, you can add any other strings to the filenames

### check method csv
check.variants.sh -c coursefile(xml) -t variant(csv) -m 2 
check.variants.sh -c coursefile(xml) -t variant(csv) -m csv
```sh
./check.variants.sh -c sourcedata/examples/radat.v2.kenraali.xml -t sourcedata/examples/hajonta.kenraali.csv -m csv
```
## Sourcematerial version 3 - pirila - Pirilä-software - coursefile (XML) and  competitiondata (XML)
**radat.xml** ja **pirilasta.xml**

This is example how to process checking when you have set data to the resultsoftware. The last check.
Export data from resultsystem and then make checking.

### check method pirila
* check.variants.sh -c coursefile(xml) -t competitiondata_including_teamvariants(csv) -m 3 
* check.variants.sh -c coursefile(xml) -t competitiondata_including_teamvariants(csv) -m pirila
```sh
./check.variants.sh -c sourcedata/examples/radat.v2.kenraali.xml -t sourcedata/examples/pirilasta.kenraali.xml -m pirila
```

## Sourcematerial version  4 - raw - sourcedata has done already to the normalized (csv, delimiter |)
Directory sourcedata/genericformat include example files, 
external software has done this VariantChecker generic csv format.
  * Class : check.class.csv
  * Variants with controls :  check.controls.csv
  * Teams variants: check.teams.csv

### check method raw
* check.variants.sh -c coursefile(csv) -t variant(csv) --classfile classes(csv) -m 4 
* check.variants.sh -c coursefile(csv) -t variant(csv) --classfile classes(csv) -m raw
```sh
./check.variants.sh -c sourcedata/genericformat/check.controls.csv -t sourcedata/genericformat/check.teams.csv --classfile sourcedata/genericformat/check.class.csv  -m raw
```

## Sourcematerial version 5 - os.en - SportSoftware OS2020 (english) 
Directory sourcedata/examples file *os.teamvariants.csv*, produced using SportSoftware OS2020 (english)
  * Csv file has done from OS2020 software ...
  * result is os.teamvariants.csv, file name have to include string *os.team*
    ** csv include all needed information, no need for a separate course file

### tarkistus raw
* check.variants.sh -t hajontatiedosto(csv)  -m 5
* check.variants.sh -t hajontatiedosto(csv)  -m os.fi
```sh
./check.variants.sh -t sourcedata/examples/os.joukkuehajonnat.csv  -m os.fi
```


## Result
* report directory which include result files, unique directory after every executing

If there is error in some class, print the class name and show the mistakes.
Example: If M21 include errors, then file **M21.check.txt** include error report.

```tmp/SomeDirectory/results```
* normalized data **check.*.csv**
* method raw need this kind of sourcedata

```tmp/SomeDirectory/results/tmp```
File for every teams. Teamfile include used control pairs with counter

## Variant checking

After checking has done, results direcory include:
* check.teams.csv,  check.controls.csv,  check.class.csv
* error report CLASS.check.txt for every classes
* if not errors, only 1 line = every team has done same variants after legs
* if mistakes, report include the teamnumber and which control pairs are not same as on the 1st team

### Example error
VER-line is the variant for the 1st team

* 313 team 0-33 has not , should be once
* 313 team 33-129 has not, should be once
* 313 team 32-129 twice, should be once
* 313 team 0-32 twice, should be once

```text
VER :0-31|1|0-32|1|0-33|1|129-52|1|129-61|1|129-888|1|31-129|1|32-129|1|33-129|1|52-741|1|61-741|1|741-M|2|888-M|1
 313:0-31|1|0-32|2|129-52|1|129-61|1|129-888|1|31-129|1|32-129|2|52-741|1|61-741|1|741-M|2|888-M|1
DIFF-ERO: 0-33 = teamid:310 counter:1 teamid:313 counter:0
DIFF-ERO: 33-129 = teamid:310 counter:1 teamid:313 counter:0
DIFF-ERO: 32-129 = teamid:310 counter:1 teamid:313 counter:2
DIFF-ERO: 0-32 = teamid:310 counter:1 teamid:313 counter:2
 316:0-31|1|0-32|2|129-52|1|129-61|1|129-888|1|31-129|1|32-129|2|52-741|1|61-741|1|741-M|2|888-M|1
DIFF-ERO: 0-33 = teamid:310 counter:1 teamid:316 counter:0
DIFF-ERO: 33-129 = teamid:310 counter:1 teamid:316 counter:0
DIFF-ERO: 32-129 = teamid:310 counter:1 teamid:316 counter:2
DIFF-ERO: 0-32 = teamid:310 counter:1 teamid:316 counter:2
```

# tmp - remove files from tmp directory
**tmp** you can empty the tmp folder
```sh
cd tmp
rm -rf [0-9]*
```
# Example coursefile Ocad
Directory maps include Ocad examplefiles
* relay1 has used in testi6.sh 

# History

* 2022-10-14 added support for SportSoftware OS2020 (finnish version)
* 2022-09-24 version 1 VariantChecker has published
* 2022 Finnish Championship relay - discarded seven classes

