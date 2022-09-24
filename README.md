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

##Historia
* 2022 SM-Viestin hajontavirheet toimi kimmokkeena, versio 1 on luotu 24.9.2022
