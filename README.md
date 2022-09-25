# Viestihajonta tarkistusjärjestelmä

(c) Jukka Inkeri  2022-

Suunnistuksen viestihajontojen tarkistus. Soveltuu myös henkilökohtaisten kilpailujen hajontojen tarkastukseen.

Tarkistetaan rastivälitasolla hajonnat eikä vain ratojen hajontatunnuksilla.
Virhe voi tapahtua esim. siinä, että hajontakoodit olettaa sisältävän tietyn hajonnan, 
mutta ratatiedostossa onkin eri hajonta.

Tämä systeemi tarkastaa joukkueiden juoksemat rastivälit, että jokainen joukkue on suorittanut samat rastivälit 
ja vain samat rastivälit ja vieläpä yhtä monta kertaa.

Kunkin sarjan 1. joukkueen rastivälipaketti toimii vertailuna. Jos siinä on virhe, 
niin kaikki muut joukkueet päätyvät virhelistalle.

Tarkistuksen voi tehdä jo ennen tulospalveluun viemistä, kunhan on ratatiedosto (XML IOF 2.0.3 tai 3.0) 
ja hajonta.csv, jossa on kunkin joukkueen käyttämät ratakoodit.

**Online** versio tulee tulevaisuudessa, mutta tässä ohjelmana hätäisimille.

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

Tai lataa ko. paketti ZIP tiedostona ja pura se johonkin kansioon
[ZIP-tiedosto](https://github.com/kshji/viestihajonta/archive/refs/heads/main.zip)

## Suoritus Windows
* suorita em. GitBash
* siirry em. kansioon, jonne purettu ko. paketti, esim: C:\viestihajonta
```sh
cd /c/viestihajonta
```

## Esimerkki
Kansiossa **esimerkki** on mallitiedostoja. Sieltä voi kopioida kansioon **lahdedata** tarvittavat tiedostot ja suorittaa ko. tarkistus. 
Malliaineisto on Jukolan kenraalista, jossa kolme osuutta.

Ko. kansiossa voit ajaa testiaineistot suoraan komennoilla testi1.sh ... testi6.sh
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
 * jos on uusi lähdeaineisto, niin tarvitsee rakentaa sille oma pohjatiedot-käsittely normalisoituun formaattiin
 * tulos kansiossa voi katsoa millaisia normalisoituja tiedostoja tarvitaan, ovat csv-tiedostoja, mutta erottimena |

## Ennakkotarkistus, lähde ratatiedosto (XML) ja hajonnat joukkueittain csv-tiedostosta
**radat.xml** ja **hajonta.csv**

Tehdään tarkistus, kun on radat tehty ja tiedossa on mitä hajontoja millekin joukkueelle.

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
Ko. kaksi tiedostoa oltava kansiossa **lahdedata**
* radat.xml
* hajonta.csv

### pohjatiedot tarkistukselle haetaan em. tiedostoista
```sh
./pohjatiedot.csv.sh
```
* kansiossa **tulos** on ns. normalisoidussa muodossa kilpailun tiedot tarkistus.*.txt
* ko. tiedot voi täten tuottaa muutenkin, jotta komento **tarkistus.sh** voidaan suorittaaa.


## Tarkistus tulospalveluohjelman tiedoilla, lähde ratatiedosto (XML) 
**radat.xml** ja **pirilasta.xml**

Lopullinen tarkistus tulee tehdä sillä tiedolla, joka on tulospalveluohjelmassa. Ohessa esimerkki Pirilä-ohjelmasta.
* ratatiedot viety  tiedostoon **radat.xml**
* kilpailijatiedot kaikki viety XML-tiedostoon **pirilasta.xml**

### pohjatiedot tarkistukselle haetaan em. tiedostoista
```sh
./pohjatiedot.pirila.sh
```

## Ennakkotarkistus, lähde ratatiedosto (XML) ja joukkuehajonnat Ocad-ohjelmasta 
**radat.xml** ja **joukkuehajonnat.txt**

Radat tehty Ocad:ssä viestihajontoina.
* tuotetaan Ocad:stä radat.xml (IOF 3.0)
* tuotetaan Ocad:stä joukkuehajonnat.txt 

Oheisessa ohjedokumentissä (Hajontatarkistus.Lahtotiedot.Pirilasta.pdf) on tarkemmin kuvaus 
kuinka Ocad:stä tehdään ko. lähdeaineisto.
Ocad:n ongelma on ettei hajontoja voi vähentää Farstasta esim. tupla-Vännekseen. Tästä syystä 
tehdään Ocadiin hajonnat omina ratoina, joka tietysti nostaa riskikerrointa saada aikaiseksi virheitä.

Tehdään tarkistus, kun on radat tehty ja tiedossa on mitä hajontoja millekin joukkueelle.

Tämän pohja-aineiston käsittely tuottaa sivutuotteena **tulos/hajonta.csv** Pirilän muotoisen 
hajonnat joukkueittain tiedoston. Ratakoodeja syntyy perus hajontamallissa ihan turhaan, mutta jos
käytetään farstaa ja kelpaa oletusarvonta joukkeiden hajonnoiksi, niin tätäkin voi käyttää.

Usein tämä versio toimii esitarkastuksena ennen kuin aloitetaan tehdä jokaista hajontaa omaksi radaksi Ocadiin.

Ko. kaksi tiedostoa oltava kansiossa **lahdedata**
* radat.xml
* joukkuehajonnat.txt

### pohjatiedot tarkistukselle haetaan em. tiedostoista
```sh
./pohjatiedot.ocad.sh
```
* kansiossa **tulos** on ns. normalisoidussa muodossa kilpailun tiedot tarkistus.*.txt
* ko. tiedot voi täten tuottaa muutenkin, jotta komento **tarkistus.sh** voidaan suorittaaa.
* kansioon tulos on tuotettu sivutuotteena Pirilä-ohjelman hyväksymä **hajonta.csv**, vertaa csv-versio edellä


## Tarkistus tulospalveluohjelman tiedoilla, lähde ratatiedosto (XML) 


## Hajonnat tarkistus
### pohja-aineisto tehty em. jommasta kummasta lähteestä
* tulos kansiossa on oltava tiedostot: tarkistus.joukkueet.csv,  tarkistus.rastit.csv,  tarkistus.sarjat.csv
* varsinainen tarkistus
```sh
./tarkista.sh
```

* lopputulos kansiossa tulos sarjoittain SARJA.tarkistus.txt
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
ERO: 0-33 = Joukkue:310 lkm:1 Joukkue:313 lkm:0
ERO: 33-129 = Joukkue:310 lkm:1 Joukkue:313 lkm:0
ERO: 32-129 = Joukkue:310 lkm:1 Joukkue:313 lkm:2
ERO: 0-32 = Joukkue:310 lkm:1 Joukkue:313 lkm:2
 316:0-31|1|0-32|2|129-52|1|129-61|1|129-888|1|31-129|1|32-129|2|52-741|1|61-741|1|741-M|2|888-M|1
ERO: 0-33 = Joukkue:310 lkm:1 Joukkue:316 lkm:0
ERO: 33-129 = Joukkue:310 lkm:1 Joukkue:316 lkm:0
ERO: 32-129 = Joukkue:310 lkm:1 Joukkue:316 lkm:2
ERO: 0-32 = Joukkue:310 lkm:1 Joukkue:316 lkm:2
```

## Esimerkkitiedostoja Ocad
Kansiossa maps on esimerkkejä Ocad:ssä.
* relay1 on tässä käytetyn testi6.sh esimerkin testidata
* Ocad:ssä monimutkaisemmat hajonnat vaatii hieman miettimistä, mutta syntyy kuitenkin ihan asiallisesti
* suurin ongelma on ettei
  * hajontakoodeja voi itse määritellä, aina A-C tyylisesti jokaisessa hajontanipussa - haastava tarkastaa
  * ettei arvottua hajontakasaa joukkueille voi säätää esim. saman seuran useamman joukkueen kesken jne.
  

## Historia
* 2022 SM-Viestin hajontavirheet toimi kimmokkeena, versio 1 on luotu 24.9.2022
