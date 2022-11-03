# Orienteering forking/variants checking  - VariantChecker

(c) Jukka Inkeri  2022-

Variant checking of orienteering.
Check variant using legs (control to control pairs) used by competitor/team. Not only variantcode.

Even if the variant codes seems to be in order, course data can include mistakes. 
This checking system checks that all teams/competitors have completed exactly the same course. 

All teams to have run the same leg variations at the end of the relay. When counting control to control in pairs, 
the count has to be same at the end.

1st team is the default value which is used to comparing variations for other teams in the same class.
If the 1st team contains a mistake, all the rest of the teams go to the mistake list.

Check can be done already before taking courses in the result system, as long as there is a course file in XML IOF 2.0.3 or 3.0 format with forking.csv including course codes for each team/competitor. 

There is also online service:[Awot variantcheck](https://awot.fi/variantcheck/en/).

## Feedback ##
box: variantcheck
domain: awot.fi

OR [Discussion](https://github.com/kshji/viestihajonta/discussions) 

Jukka Inkeri

## Pre install
### Linux ja OS-X
Default: all these are already installed
 * bash
 * gawk
 * sort
 * grep
 * sed
 * tr

### Windows
If you are using WSL or WSL2 (Linux subsystem for Windows), then commands works just like as in the native Linux.

If you have Windows, but are not using WSL, then the easiest method is to install 
[Git for Windows](https://gitforwindows.org/). This will give you access for the required commands in Windows also.
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
* execute GitBash above
* navigate to the working directory where you have unziped packet
* ex. C:\variantcheck
```sh
cd /c/variantcheck
```

## Examples
In the directory **sourcedata/examples** there are some example files. You can try CLI using those examples.
"Kenraali" has three legs, using Farsta. "virhe" file include mistakes. 

The example directory has test commands testi1.sh - testi7.sh. You can look those how to run some test competition.

CLI will always create directory ./tmp, where result files will be after executing.
```sh
./testi1.sh
```
## Executing access rights for .sh files
If .sh files do not include execute access rights, then add it:
```sh
chmod a+rx *.sh sourcedata/examples/*.sh
```
## How it works
 * convert source data into the normalized format (csv using delimiter |), used by this system
 * checking has done always using same normalized format 
 * if you need import new format, then you need to create own sourcedata command (source.XXXX.sh), 
which process the new source format into the  normalized format
 * tmp/XXXX/**results** directory includes normalized file examples to reviewed. They are in CSV-format with | as a separator. 
 * source data can be located anywhere, but the package above includes **sourcedata** directory that use. In there you may create subdirectory for every competition.
   * directory and filenames is more safety to use if names include only US-ASCII7 chars: a-z or 0-9. No No special characters such as öäå, nor spaces. dot . and underline _ are okay.

## Ocad instructions

Online server include instructions.

# Checking - execute
## Data Source version 1 - method ocad -  Cources (XML 3.0) and teamsvariations (txt) from Ocad
**radat.xml** ja **joukkuehajonnat.txt** OR 
**courses.xml** ja **teamvariants.txt**

Create courses using Ocad, relay variant or ex. individual butterfly variant
* Export from Ocad course.xml (IOF 3.0)
* Export from Ocad team variations teamvariants.txt 

This checking return always OK. If not, then you have big mistakes in the courses or Ocad include mistake.

You can also use those result files and make manual editing for variants used by teams.
Example compare same club teams 1,2,3,... or comparing the best teams variant and make sure that they are running same forking at same time.

This checking is being done using special csv file  **hajonta.lst**. You can edit those variants for teams and then use checking method **csv**.

### check method ocad
* check.variants.sh -c coursefile(xml) -t teamvariant(txt) -m 1 
* check.variants.sh -c coursefile(xml) -t teamvariant(txt) -m ocad
```sh
./check.variants.sh -c sourcedata/examples/relay1.course.Courses.v3.xml -t sourcedata/examples/relay1.course.Variations.txt -m ocad
# or
./check.variants.sh -c sourcedata/examples/radat.ocad.v3.xml -t sourcedata/examples/joukkuehajonnat.txt -m 2 
```

## Data source version 2 - csv - coursefile (XML) ja team variant using csv-file (Pirilä lst)
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

## Data source version  4 - raw - sourcedata has been  already done into the normalized format (csv, delimiter |)
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

## Data source version 5 - os.en - SportSoftware OS12 (english) 
Directory sourcedata/examples file *os.teamvariants.csv*, created using SportSoftware OS12 (english)

See separate instructions: [https://github.com/kshji/viestihajonta/raw/main/VariantChecker.SourceData.OS12.pdf](VariantChecker.SourceData.OS12.pdf)
describes in more detail how to generate the files from the Sport Software OS12 message program.

  * The file is generated from the OS12 program:
    * Courses :: Reports :: Course distribution :: Export :: Standard 
        * Select **Columns separated by character (CSV)**, the Delimiter is a semicolon (;) and the String Delimiter can also be off or a quotation mark "
        * give the file name something starting with **os.team** and ending with **csv**. In between, there may be a competition identifier or be missing
  * the final result is os.team.csv, the name must be **os.team**, that's how the format is identified by the checker
    * this file contains everything needed, no separate track file is needed

### tarkistus raw
* check.variants.sh -t hajontatiedosto(csv)  -m os.en
```sh
./check.variants.sh -t sourcedata/examples/os.teamvariants.csv  -m os.en
```


## Result
* Separate report directory with result files is being created after every time checking is executed

If there is an error in some class, those class names will be printed and mistakes highlighted.
Example: If M21 includes an errors, then file **M21.check.txt** includes the error report.

```tmp/SomeDirectory/results```
* normalized data **check.*.csv**
* method raw need this kind of source data

```tmp/SomeDirectory/results/tmp```
File for every teams. Teamfile include used control pairs with counter

## Variant checking

After checking has done, results direcory include:
* check.teams.csv,  check.controls.csv,  check.class.csv
* error report CLASS.check.txt for every classes
* if there are no errors, only 1 line = every team has done same variants after legs
* if there are mistakes, report includes the team number and which control pairs are not the same as on the comparison team (the first team as described earlier)

### Example error
VER-line is the variant for the 1st team

* 313 team does not have 0-33, should be once
* 313 team does not have 33-129, should be once
* 313 team hae 32-129 twice, should be once
* 313 team has 0-32 twice, should be once

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
**tmp** you can empty the tmp folder, unless competition you wish to store competition results in there
```sh
cd tdm -rf [0-9]*
```
# Example coursefile Ocad
Directory maps include Ocad examplefiles
* relay1 has used in testi6.sh 

# History

* 2022-10-14 added support for SportSoftware OS12 (finnish version)
* 2022-09-24 version 1 VariantChecker has published
* 2022 Finnish Championship relay - discarded seven classes

