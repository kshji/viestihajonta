# Viestihajonta tarkistusjärjestelmä - Orienteering forking/variants checking 

(c) Jukka Inkeri  2022-

Suunnistuksen viestihajontojen tarkistus. Soveltuu myös henkilökohtaisten kilpailujen hajontojen tarkastukseen.

[English README](https://github.com/kshji/viestihajonta/blob/main/README.EN.md)

Tarkistetaan rastivälitasolla hajonnat eikä vain ratojen hajontatunnuksilla.
Virhe voi tapahtua esim. siinä, että hajontakoodit olettaa sisältävän tietyn hajonnan, 
mutta ratatiedostossa onkin eri hajonta.

Tämä systeemi tarkastaa joukkueiden juoksemat rastivälit, että jokainen joukkue on suorittanut samat rastivälit 
ja vain samat rastivälit ja vieläpä yhtä monta kertaa.

Kunkin sarjan 1. joukkueen rastivälipaketti toimii vertailuna. Jos siinä on virhe, 
niin kaikki muut joukkueet päätyvät virhelistalle.

Tarkistuksen voi tehdä jo ennen tulospalveluun viemistä, kunhan on ratatiedosto (XML IOF 2.0.3 tai 3.0) 
ja hajonta.csv, jossa on kunkin joukkueen käyttämät ratakoodit.

[Online tarkistus](https://awot.fi/variantcheck) versio on nyt myös tarjolla. Lähdekoodeissa on myös palvelimen lähdekoodi, voit pystyttää oman online-palvelimen.

Palautetta saa antaa, sposti ihan ok.
laatikkoon: viestihajonta
domain: awot.fi

Liperissä 25.9.2022, Jukka Inkeri

## Vaaditut ohjelmistot
### Linux ja OS-X
Oletettavasti kaikki on jo valmiina
 * bash
 * gawk
 * sort
 * grep
 * sed
 * tr

### Windows
Jos on käytössä WSL (Linux subsystem for Windows) ja jokin Linux asennettuna esim. Ubuntu, niin löytyy ko. komennot kuten Linuxeissa yleensäkin.

Jos ei ole WSL, niin helpointen tarvittavat komennot saa asentamalla [Git for Windows](https://gitforwindows.org/). Tällöin käytettävissä em. tarvittavat komennot myös Windowsissa.
Työpöydällä kuvake **GitBash**

##  Asennus

```sh
git clone https://github.com/kshji/viestihajonta.git
cd viestihajonta
# tassa hakemistossa suoritukset oheisen ohjeen mukaisesti
```

Tai lataa ko. paketti ZIP tiedostona ja pura se johonkin kansioon, 
[Lataa ZIP-tiedosto](https://github.com/kshji/viestihajonta/archive/refs/heads/main.zip)

## Suoritus Windows
* suorita em. GitBash
* siirry em. kansioon, jonne purettu ko. paketti, esim: C:\viestihajonta
```sh
cd /c/viestihajonta
```

## Esimerkki
Kansiossa **sourcedata/examples** on mallitiedostoja. Niille voi suorittaa tarkistukset.
Malliaineisto on mm. Jukolan kenraalista, jossa kolme osuutta.

Ko. kansiossa voit ajaa testiaineistot suoraan komennoilla testi1.sh ... testi7.sh

Samalla esimerkki, että komennon voi suorittaa myös siinä kansiossa, missä on lähdeaineisto. Tekee tällöin ko. kansion alle tmp-kansion.
```sh
./testi1.sh
```
## Suoritusoikeudet .sh tiedostoilla
Jollei ole, lisää suoritusoikeus:
```sh
chmod a+rx *.sh esimerkki/*.sh
```
## Toimintaperiaate
 * muodostetaan lähdeaineistosta normalisoitu formaatti
 * tarkastus tehdään aina normalisoidusta formaatista - yksi tarkastusohjelma vain ja vain, oli lähdedata mikä vaan
 * jos on uusi lähdeaineistotyyppi, niin tarvitsee rakentaa sille oma pohjatiedot-käsittely (source.XXXX.sh) normalisoituun formaattiin
 * tmp/XXXX/**results** kansiossa voi katsoa millaisia normalisoituja tiedostoja tarvitaan, ovat csv-tiedostoja, mutta erottimena |
 * lähdedata voi olla missä tahansa, mutta ko. paketissa on valmiina kansio **sourcedata** sitä varten, että sinne voi tehdä oman kansion kullekin kisalle
   * suositus: hakemistonimissä ja tiedostonimissä vain merkkejä a-z ja 0-9. Ei erikoismerkkejä, ei öäå, ei tyhjeitä

## Ocad ohjeet

Oheisessa dokumentissä
[https://github.com/kshji/viestihajonta/raw/main/Hajontatarkistus.Lahtotiedot.Pirilasta.pdf](Hajontatarkistus.Lahtotiedot.Pirilasta.pdf) on tarkemmin kuvaus
kuinka Ocad:stä tehdään ko. lähdeaineistot eri versioissa.

# Tarkistus - suoritusohje
## Lähdemateriaali versio 1 - ocad - Ocad:stä ratatiedosto (XML 3.0) ja hajonnat joukkueittain txt-tiedostosta 
**radat.xml** ja **joukkuehajonnat.txt**

Radat tehty Ocad:ssä viestihajontoina.
* tuotetaan Ocad:stä radat.xml (IOF 3.0)
* tuotetaan Ocad:stä joukkuehajonnat.txt 

**Huom:** **radat.xml** pitää olla IOF 3.0 formaatissa tuotettuna Ocad:stä.

Tämä tarkistushan pitäisi olla aina ok. 
Tai jos antaa virheen, niin joko viestiradoissa jotain pahasti pielessä tai Ocad:ssä on virhe.

MUTTA voit tehdä niinkin, että teet em. tiedostot Ocad:stä ja sen jälkeen muokkaaat ko. tiedostoja esim. oletettujen parhaiden
joukkueiden hajontoja vertailen/muokaten, että ovat järkeviä ja että seuran 1, 2, 3 jne. joukkueet ainakin aluksi ovat eri hajonnat.

Tällä ajolla syntyy aputuloksena Pirilä-ohjelman tuntema **hajonta.lst** muotoinen tiedosto - voi lukea lähdedatana Pirilään.
Ratakoodeja syntyy perus hajontamallissa ihan turhaan, mutta jos
käytetään farstaa ja kelpaa oletusarvonta joukkeiden hajonnoiksi, niin tätäkin voi käyttää.
Tässä mallissa kaikki ylläpito pitää tehdä Ocad:ssä, ainakin hajontoihin, koska sama hajonta voi olla useana 
samana hajontana esim. 1AAA, 2AAA, 3AAA voivat olla sama hajonta tai ei. 

### tarkistus ocad
* check.variants.sh -c ratatiedosto(xml) -t hajontatiedosto(txt) -m 1 
* check.variants.sh -c ratatiedosto(xml) -t hajontatiedosto(txt) -m ocad
```sh
./check.variants.sh -c sourcedata/examples/relay1.course.Courses.v3.xml -t sourcedata/examples/relay1.course.Variations.txt -m ocad
# tai
./check.variants.sh -c sourcedata/examples/radat.ocad.v3.xml -t sourcedata/examples/joukkuehajonnat.txt -m 2 
```

## Lähdemateriaali versio 2 - csv - ratatiedosto (XML) ja hajonnat joukkueittain csv-tiedostosta (Pirilän lst)
**radat.xml** ja **hajonta.csv** tai **hajonta.lst**

Tehdään tarkistus, kun on radat tehty ja tiedossa on mitä hajontoja millekin joukkueelle tarjoillaan.

 * Esim. Ocadistä ratatiedot IOF XML 2.0.3 formaatissa
   *  Ratatiedot :: Vie :: radat (XML, IOF Versio 2.0.3) ... nimellä **radat.xml** - toki voit nimetä muullakin nimellä, tämä tarkistusohjelma etsii ratatiedot ko. nimisestä tiedostosta.
 * joukkueittain hajonnat tiedostossa **hajonta.csv**
   *  muoto on mitä Pirilä-ohjelma tukee suoraan
   *  sarakkeita voi olla muitakin, tämä järjestelmä käyttää csv:stä vain ko. sarakkeita
   *  kaikki sarjat samassa tiedostossa

Esimerkki: hajonta.csv
```csv
Sarja;No;Rata-1;Rata-2;Rata-3
H21;1;AA;BB;CC
H21;2;AB;BA;CC
H21;3;BA;CB;AC
```
Ko. kaksi tiedostoa oltava käytettävissä, nimentä vapaasti, esim:
 * radat.xml
 * hajonta.csv

### tarkistus csv
* check.variants.sh -c ratatiedosto(xml) -t hajontatiedosto(csv) -m 2 
* check.variants.sh -c ratatiedosto(xml) -t hajontatiedosto(csv) -m csv
```sh
./check.variants.sh -c sourcedata/examples/radat.v2.kenraali.xml -t sourcedata/examples/hajonta.kenraali.csv -m csv
```
## Lähdemateriaali versio 3 - pirila - Pirilä-ohjelmisto - ratatiedosto (XML) ja  kilpalijatiedot (XML)
**radat.xml** ja **pirilasta.xml**

Lopullinen tarkistus tulee tehdä sillä tiedolla, joka on tulospalveluohjelmassa, tässä tapauksessa Pirilä-ohjelmasta
 * ratatiedot viety  tiedostoon **radat.xml**
 * kilpailijatiedot kaikki viety XML-tiedostoon **pirilasta.xml**
 * katso erillinen ohje: [https://github.com/kshji/viestihajonta/raw/main/Hajontatarkistus.Lahtotiedot.Pirilasta.pdf](Hajontatarkistus.Lahtotiedot.Pirilasta.pdf) on tarkemmin kuvattu, 
kuinka ko. tiedostot tuotetaan


### tarkistus pirila
* check.variants.sh -c ratatiedosto(xml) -t kisatiedosto(xml) -m 3 
* check.variants.sh -c ratatiedosto(xml) -t kisatiedosto(xml) -m pirila
```sh
./check.variants.sh -c sourcedata/examples/radat.v2.kenraali.xml -t sourcedata/examples/pirilasta.kenraali.xml -m pirila
```

## Lähdemateriaali versio 4 - raw - aineisto on tuotettu muulla tavalla jo valmiiksi tämän järjestelmän csv-muotoon
Kansiossa sourcedata/genericformat on esimerkkitiedostoja, jollaisia voi tuottaa valmiiksi.
  * sarjat : check.class.csv
  * hajontakoodit rasteineen :  check.controls.csv
  * joukkueet hajontakoodeineen: check.teams.csv

### tarkistus raw
* check.variants.sh -c ratatiedosto(xml) -t hajontatiedosto(csv) --classfile sarjartiedosto(csv) -m 4 
* check.variants.sh -c ratatiedosto(xml) -t hajontatiedosto(csv) --classfile sarjartiedosto(csv) -m raw
```sh
./check.variants.sh -c sourcedata/genericformat/check.controls.csv -t sourcedata/genericformat/check.teams.csv --classfile sourcedata/genericformat/check.class.csv  -m raw
```

## Lopputulos
Tarkistusajo kertoo lopuksi missä kansiossa on tarkistusajon kaikki tiedostot tallessa.

Jos oli virheitä, ilmoittaa virheelliset sarjat. Ko. kansiosta löytyy ko. sarjan raportti.
Esim. Jos sarjassa H21 on virhe, niin ilmoitetussa kansiossa on **H21.check.txt**, josta voi lukea mitä on pielessä.

```tmp/JOKUhakemisto/results```
* kansiossa on ns. normalisoidussa muodossa kilpailun tiedot **check.*.csv**
* ko. tiedot voi täten tuottaa muutenkin, jotta tarkistus voidaan suorittaa, katso versio 4 ohjeet

```tmp/JOKUhakemisto/results/tmp```
Kansiossa on kunkin joukkueen käyttämät rastivälit kukin omassa tiedostossa.

## Pirilä-ohjelmasta tarvittavat tiedostot
Tarkistus tulospalveluohjelman tiedoilla (XML) ja ratatiedosto (XML).

Oheisessa ohjedokumentissä 
[https://github.com/kshji/viestihajonta/raw/main/Hajontatarkistus.Lahtotiedot.Pirilasta.pdf](Hajontatarkistus.Lahtotiedot.Pirilasta.pdf) on tarkemmin kuvaus 
kuinka Ocad:stä tehdään ko. lähdeaineisto.
Ocad:n ongelma on ettei hajontoja voi vähentää Farstasta esim. tupla-Vännekseen. Tästä syystä 
tehdään Ocadiin hajonnat omina ratoina, joka tietysti nostaa riskikerrointa saada aikaiseksi virheitä.

## Hajonnat tarkistus
Em. check.variants.sh  -m optiolla valitaan mikä lähdeaineistoversio käytössä.

Kun tarkistus on tehty, on ilmoitetussa tuloskansiossa (results) tiedostoja, joista voi katsoa kuinka tulkittu
lähdedata.
* check.teams.csv,  check.controls.csv,  check.class.csv
* tulos sarjoittain SARJA.check.txt
* jos ei ole virheita, niin vain yksi rivi, jossa kaytetyt rastivalit ja kuinka monesti
* jos virheita, niin virheelliset joukkueet raportoitu ja kerrottu myös mikä erottaa 1. joukkueen hajonnasta

### Esimerkki virheraportista
VER-rivi on tulos, joka piti saada.

* 313 joukkueella 0-33 ei kertaakaan vaikka pitäisi olla 1
* 313 joukkueella 33-129 ei kertaakaan vaikka pitäisi olla 1
* 313 joukkueella 32-129 kahdesti vaikka pitää olla vain kerran
* 313 joukkueella 0-32 kahdesti vaikka pitää olla vain kerran

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

# tmp kansion siivous
**tmp** kansiosta voi siivota kaikki pois, jollei halua säilyttää siellä suoritusten tuloksia.
```sh
cd tmp
rm -rf [0-9]*
```
# Esimerkkitiedostoja Ocad
Kansiossa maps on esimerkkejä Ocad:ssä.
* relay1 on tässä käytetyn testi6.sh esimerkin testidata
* Ocad:ssä monimutkaisemmat hajonnat vaatii hieman miettimistä, mutta syntyy kuitenkin ihan asiallisesti
* suurin ongelma on ettei
  * hajontakoodeja voi itse määritellä, aina A-C tyylisesti jokaisessa hajontanipussa - haastava tarkastaa
  * ettei arvottua hajontakasaa joukkueille voi säätää esim. saman seuran useamman joukkueen kesken jne.
  

# Historia
* 2022 SM-Viestin hajontavirheet toimi kimmokkeena, versio 1 on luotu 24.9.2022
