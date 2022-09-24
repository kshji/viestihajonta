# Viestihajonta tarkistusjärjestelmä

(c) Jukka Inkeri  2022-

Suunnistuksen viestihajontojen tarkistus.

Tarkistetaan rastivälitasolla hajonnat eikä vain ratojen hajontatunnuksilla.
Virhe voi tapahtua esim. siinä, että hajontakoodit olettaa sisältävän tietyn hajonnan, mutta ratatiedostossa onkin eri hajonta.

Tämä systeemi tarkastaa joukkueiden juoksemat rastivälit, että jokainen joukkue on suorittanut samat rastivälit ja vain samat
rastivälit ja vieläpä yhtä monta kertaa.

Kunkin sarjan 1. joukkueen rastivälipaketti toimii vertailuna. Jos siinä on virhe, niin kaikki muut joukkueet päätyvät virhelistalle.

Tarkistuksen voi tehdä jo ennen tulospalveluun viemistä, kunhan on ratatiedosto (XML IOF 2.0.3 tai 3.0) ja hajonta.csv, 
jossa on kunkin joukkueen käyttämät ratakoodit.

Palautetta saa antaa, sposti ihan ok.
laatikkoon: viestihajonta
domain: awot.fi

Liperissä 24.9.2022, Jukka Inkeri

## Vaaditut ohjelmistot
### Linux
Oletettavasti kaikki on jo valmiina
 * bash
 * gawk
 * sort
 * grep

### Windows
Jos on käytössä WSL (Linux subsystem for Windows) ja jokin Linux asennettuna esim. Ubuntu, niin löytyy ko. komennot kuten Linuxeissa yleensäkin.

Jos ei ole WSL, niin helpointen tarvittavat komennot saa asentamalla [Git for Windows](https://gitforwindows.org/). Tällöin käytettävissä em. tarvittavat komennot myös Windowsissa.
Työpöydällä kuvake **GitBash**

## Esimerkki
Kansiossa esimerkki on mallitiedostoja. Sieltä voi kopioida kansioon **lahdedata** tarvittavat tiedostot ja suorittaa ko. tarkistus. 
Malliaineisto on Jukolan kenraalista, jossa kole osuutta.

## Ennakkotarkistus, lähde ratatiedosto (XML) **radat.xml** ja **hajonta.csv**
Tehdään tarkistus, kun on radat tehty ja tiedossa on mitä hajontoja millekin joukkueelle.

 * Esim. Ocadistä ratatiedot IOF XML 2.0.3 formaatissa
  * Ratatiedot :: Vie :: radat (XML, IOF Versio 2.0.3) ... nimellä **radat.xml** - toki voit nimetä muullakin nimellä, tämä tarkistusohjelma etsii ratatiedot ko. nimisstä tiedostosta.
 * joukkueittain hajonnat tiedostossa **hajonta.csv**
  * muoto on mitä Pirilä-ohjelma tukee suoraan
  * sarakkeita voi olla muitakin, tämä järjestelmä käyttää csv:stä vain ko. sarakkeita
  * kaikki sarjat samassa tiedostossa
```csv
Sarja;No;Rata-1;Rata-2;Rata-3
H21;1;AA;BB;CC
H21;2;AB;BA;CC
H21;3;BA;CB;AC
```
Ko. kaksi tiedostoa oltava kansiossa lahdedata
* radat.xml
* hajonta.csv

### pohjatiedot tarkistukselle haetaan em. tiedostoista
```sh
./pohjatiedot.csv.sh
```
* kansiossa **tulos** on ns. normalisoidussa muodossa kilpailun tiedot tarkistus.*.txrt
* ko. tiedot voi täten tuottaa muutenkin, jotta komento **tarkistus.sh** voidaan suorittaaa.

```sh
```

## Tarkistus tulospalveluohjelman tiedoilla, lähde ratatiedosto (XML) **radat.xml** ja **pirilasta.xml**
Lopullinen tarkistus tulee tehdä sillä tiedolla, joka on tulospalveluohjelmassa. Ohessa esimerkki Pirilä-ohjelmasta.
* ratatiedot viety  tiedostoon **radat.xml**
* kilpailijatiedot kaikki viety XML-tiedostoon **pirilasta.xml**

## Historia
* 2022 SM-Viestin hajontavirheet toimi kimmokkeena, versio 1 on luotu 24.9.2022
