---
title: "Pinto -- Un Archivio CPAN Personalizzato In Confezione Regalo"
timestamp: 2013-05-03T16:30:03
tags:
  - cpan
  - pinto
published: true
original: pinto-tutorial
author: thalhammer
translator: giatorta
---


<i>
Questo contributo è di [Jeffrey Ryan Thalhammer](http://twitter.com/thaljef), autore di Pinto
e di Perl::Critic. Jeff dirige una piccola impresa di consulenza a San Francisco ed
 è attivo nella comunità Perl da molti anni.
Jeff ha aperto una [raccolta fondi](https://www.crowdtilt.com/campaigns/specify-module-version-ranges-in-pint) che durerà fino al 7 Maggio per finanziare lo sviluppo di una funzione che permetta di <b>specificare dei range di versioni per i moduli in Pinto</b>.
</i>

Uno dei punti di forza di Perl sono i suoi moduli open source
disponibili su CPAN. Purtroppo stare al passo con tutti gli aggiornamenti che li riguardano è
difficile. Ogni settimana ci sono centinaia di nuovi rilasci e non
potete sapere se una nuova versione di un modulo introdurrà un bug che
blocca la vostra applicazione.


La versione originale di questo articolo è stata pubblicata su [Pragmatic Perl](http://pragmaticperl.com/).

Una strategia per risolvere questo problema è quella di creare un vostro archivio CPAN
personalizzato che contenga soltanto le versioni dei moduli che
volete. In questo modo potete usare i tool di CPAN per creare la vostra
applicazione con i moduli del vostro archivio personalizzato, evitando di
esporvi agli imprevisti che si possono verificare usando l'archivio CPAN pubblico.

Nel corso degli anni ho creato svariati archivi CPAN personalizzati usando
tool come [CPAN::Mini](https://metacpan.org/pod/CPAN::Mini)
e [CPAN::Site](https://metacpan.org/pod/CPAN::Site), ma
mi sono sempre sembrati macchinosi
e non mi hanno mai lasciato completamente soddisfatto.  Un paio di anni fa un
cliente mi ha assunto per creargli un ennessimo CPAN personalizzato. Questa volta, però, ho
avuto l'opportunità di ricominciare da zero. Pinto è il risultato di quel
lavoro.

[Pinto](https://metacpan.org/pod/Pinto) è un tool affidabile
per creare e gestire un archivio CPAN personalizzato.
Ha molte funzionalità che vi aiutano efficacemente a gestire
in modo sicuro tutti i moduli Perl da cui dipende la vostra applicazione. Questo
tutorial vi illustrerà come creare un CPAN personalizzato con Pinto e
come usare alcune delle sue funzionalità.

## Installare Pinto

Pinto è disponibile su CPAN e può essere installato come un qualunque altro modulo
usando le utility cpan o `cpanm`. Ma Pinto, più che una libreria,
è un'applicazione. È un tool che usate per gestire il codice della
vostra applicazione ma non è parte effettiva della vostra applicazione.
Perciò vi suggerisco di installare Pinto come una applicazione stand-alone con
questi due comandi:

```
curl -L http://getpinto.stratopan.com | bash
source ~/opt/local/pinto/etc/bashrc
```

In questo modo Pinto verrà installato in `~/opt/local/pinto` e le opportune directory
saranno aggiunte ai vostri `PATH` e `MANPATH`. L'applicazione è auto-contenuta,
quindi installare Pinto non ha effetti sul resto del vostro ambiente di
sviluppo e, viceversa, eventuali modifiche al vostro ambiente di sviluppo non hanno effetti su
Pinto.

## Esploriamo Pinto

Come per ogni nuovo tool, la prima cosa che dovete imparare è come chiedere aiuto:

```
pinto commands            # Visualizza una lista di comandi disponibili
pinto help <COMMAND>      # Visualizza un riepilogo delle opzioni e argomenti di <COMMAND>
pinto manual <COMMAND>    # Visualizza il manuale completo di <COMMAND>
```

Pinto include anche altra documentazione, tra cui un tutorial e
una guida di riferimento rapido. Potete accedere a tali documenti con i seguenti
comandi:

```
man Pinto::Manual::Introduction  # Spiega i concetti base di Pinto
man Pinto::Manual::Installing    # Suggerimenti sull'installazione di Pinto
man Pinto::Manual::Tutorial      # Una guida su Pinto in stile narrativo
man Pinto::Manual::QuickStart    # Un riepilogo sui comandi più comuni
```

## Creazione Di Un Archivio

Il primo passo nell'uso di Pinto è la creazione di un archivio con il comando
`init`:

```
pinto -r ~/repo init
```

Viene creato un nuovo archivio nella directory `~/repo`. Se la directory
non esiste viene creata automaticamente. Se invece esiste
deve essere vuota.

L'opzione -r (o --root) specifica l'ubicazione dell'archivio. È
richiesta da tutti i comandi di pinto. Se vi annoiate a riscriverla ogni volta,
potete settare la variabile d'ambiente `PINTO_REPOSITORY_ROOT` per farla puntare al
vostro archivio e poter omettere l'opzione -r.


## Ispezione Dell'Archivio

Ora che avete creato un archivio, diamo un'occhiata a che cosa contiene. Per visualizzare il
contenuto di un archivio usate il comando "list":

```
pinto -r ~/repo list
```

Al momento la lista è vuota perché l'archivio non ha ancora
contenuti. Ma torneremo a usare spesso il comando "list"
in questo tutorial.

## Aggiunta Di Moduli CPAN

Immaginate di lavorare ad una applicazione My-App che contiene
un modulo My::App e dipende dal modulo URI.  Potete
importare il modulo URI nel vostro archivio usando il comando `pull`:

```
pinto -r ~/repo pull URI
```

Vi viene chiesto di immettere un messaggio di log che descriva il perché di questo
cambiamento dell'archivio. La prima linea del template del messaggio include un
semplice messaggio generato automaticamente che potete editare. In fondo al template
del messaggio c'è invece l'elenco esatto dei moduli che sono stati aggiunti. Quando siete pronti
salvate il file e chiudete l'editor.

Ora il modulo URI dovrebbe essere nel vostro archivio. Proviamo a vedere
che cosa è successo. Usate di nuovo il comando `list`
per visualizzare il contenuto dell'archivio:

```
pinto -r ~/repo list
```

Questa volta l'elenco sarà qualcosa tipo:

```
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```

Come vedete, il modulo URI è stato aggiunto all'archivio insieme
a tutti i prerequisiti di URI, ai loro prerequisiti
e così via.

## Aggiunta Di Moduli Privati

Ora immaginate di aver finito di lavorare su My-App e di essere pronti a
rilasciarne la prima versione.  Sfruttando il vostro strumento preferito di build (e.g
ExtUtils::MakeMaker, Module::Build, Module::Install etc.) generate
un package con la release My-App-1.0.tar.gz. A questo punto potete aggiungere la distribuzione
nell'archivio Pinto con il comando `add`:

```
$> pinto -r ~/repo add path/to/My-App-1.0.tar.gz
```

Vi verrà nuovamente chiesto di immettere un messaggio che descriva il cambiamento dell'archivio.
Quando elencate i contenuti dell'archivio, essi includeranno ora il modulo My::App
e vi menzioneranno come autori della distribuzione:

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
rf  URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.60.tar.gz
...
```


## Installazione Di Moduli

Ora che i vostri moduli sono stati importati nell'archivio Pinto, il passo
successivo consiste nel farne il build e installarli da qualche parte. Dietro le quinte,
un archivio Pinto è organizzato esattamente come un archivio CPAN ed è quindi
completamente compatibile con cpanm e con gli altri tool per l'installazione di moduli Perl. Dovete
soltanto far puntare il tool di installazione al vostro archivio Pinto:

```
cpanm --mirror file://$HOME/repo --mirror-only My::App
```

Questo comando fa il build e l'installazione di My::App usando *solo* i moduli del vostro
archivio Pinto. Di conseguenza, ogni volta verranno usate esattamente le stesse versioni di tali
moduli, indipendentemente dal fatto che il modulo sia stato rimosso o aggiornato sull'archivio
CPAN pubblico.

L'opzione --mirror-only di cpanm è importante perché impedisce a
cpanm di ricorrere al CPAN pubblico quando non trova un modulo
nel vostro archivio. Quando ciò succede, normalmente è causato da qualche
distribuzione nell'archivio che non dichiara correttamente tutte le proprie
dipendenze nel proprio file META. Potete risolvere il problema semplicemente
usando il comando `pull` per recuperare i moduli mancanti.


## Aggiornamento Di Moduli

Immaginate che sia passata qualche settimana dal vostro primo rilascio di My-App
e che ora su CPAN sia disponibile la versione 1.62 di URI. Dato che essa
include la soluzione di alcuni bug critici vorreste iniziare a usarla. Potete importarla
nell'archivio usando nuovamente il comando `pull`. Però, dato che il vostro
archivio contiene già una versione di URI, dovete indicare che
ne volete una <b>più recente</b> specificandone la versione minima:

```
pinto -r ~/repo pull URI~1.62
```

Se visualizzare il contenuto dell'archivio, questa volta vedrete la nuova 
versione di URI (ed eventualmente anche di altri moduli):

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.62  GAAS/URI-1.62.tar.gz
rf  URI::Escape                    3.38  GAAS/URI-1.62.tar.gz
rf  URI::Heuristic                 4.20  GAAS/URI-1.62.tar.gz
...
```

Se la nuova versione di URI richiede delle dipendenze nuove o
aggiornate, saranno anch'esse nell'archivio. E quando
installate di nuovo My::App verrà usata la versione 1.62 di URI.

## Lavorare Con Gli Stack

Finora abbiamo trattato un archivio come una singola risorsa. Pertanto,
quando abbiamo aggiornato il modulo URI nella sezione precedente, l'aggiornamento ha coinvolto tutte le persone e
tutte le applicazioni che usavano in qualche modo l'archivio. Questo tipo
di effetto universale è poco desiderabile. Probabilmente preferireste poter cambiare delle cose
isolatamente e testarle prima di forzare tutti gli altri ad adottarle.
Questa è la funzione degli stack.

Tutti gli archivi derivati da CPAN hanno un indice che mappa l'ultima versione
di ogni modulo alla distribuzione che lo contiene. Normalmente c'è
un unico indice per archivio. Invece, Pinto prevede che ci possano essere
molti indici diversi. Ognuno di essi rappresenta uno <b>"stack"</b>.  In
questo modo potete creare diversi stack di dipendenze all'interno dello stesso
archivio. Per sempio potreste avere uno stack "sviluppo" e uno stack
"produzione" oppure uno stack "perl-5.8" e uno stack "perl-5.16".
Quando aggiungete o aggiornate un modulo, il cambiamento interessa un solo stack.

Prima di proseguire è utile introdurre il concetto di stack di default.
Per la maggior parte delle  operazioni il nome dello stack è un parametro opzionale.
Se non specificate esplicitamente uno stack il comando viene
applicato allo stack che è contrassegnato come default.

In ogni archivio può esserci al più uno stack di default. Quando
abbiamo creato il nostro archivio, Pinto ha anche creato uno stack di nome "master" e
lo ha contrassegnato come default. Potete cambiare lo stack di default o cambiare il
nome di uno stack, ma per ora non ci occupiamo di queste funzioni. Ricordate soltanto che
"master" è il nome dello stack creato quando l'archivio
è stato inizializzato.

<h3>Creare Uno Stack</h3>

Immaginate che il vostro archivio contenga la versione 1.60 del modulo URI e che la versione 1.62
sia stata rilasciata su CPAN, come descritto sopra. Volete provare a fare
l'aggiornamento, e questa volta lo farete su uno stack separato.

Finora tutto ciò che avete aggiunto o importato nell'archivio è
andato a finire nello stack "master". Cloneremo quindi
tale stack usando il comando `copy`:

```
pinto -r ~/repo copy master uri_upgrade
```

Questo comando crea un nuovo stack chiamato "uri_upgrade".  Se volete vedere che cosa
contiene, usate semplicemente il comando `list` con l'opzione
"--stack":

```
pinto -r ~/repo list --stack uri_upgrade
```

L'elenco dei contenuti dovrebbe essere identico a quello dello stack "master":

```
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf  URI                            1.60  GAAS/URI-1.60.tar.gz
...
```

<h3>Aggiornare Uno Stack</h3>

Ora che avete creato uno stack separato, potete provare ad aggiornare il modulo URI.  Dovete 
usare il comando `pull` come prima, ma questa volta indicherete a
Pinto di importare i moduli nello stack "uri_upgrade":

```
pinto -r ~/repo pull --stack uri_upgrade URI~1.62
```

Possiamo confrontare gli stack "master" e "uri_upgrade" usando il comando
"diff":

```
pinto -r ~/repo diff master uri_upgrade

+rf URI                                              1.62 GAAS/URI-1.62.tar.gz
+rf URI::Escape                                      3.31 GAAS/URI-1.62.tar.gz
+rf URI::Heuristic                                   4.20 GAAS/URI-1.62.tar.gz
...
-rf URI                                              1.60 GAAS/URI-1.60.tar.gz
-rf URI::Escape                                      3.31 GAAS/URI-1.60.tar.gz
-rf URI::Heuristic                                   4.20 GAAS/URI-1.60.tar.gz
```

L'output è simile a quello del comando diff(1). Le righe che iniziano con un simbolo
"+" sono state aggiunte e quelle che iniziano con un simbolo "-" sono state rimosse.  Come potete
vedere, i moduli della distribuzione URI-1.60 sono stati sostituiti
con i moduli della distribuzione URI-1.62.

<h3>Installare Da Uno Stack</h3>

Una volta che i nuovi moduli sono stati importati nello stack "uri_upgrade" stack, potete provare
a fare il build della vostra applicazione facendo puntare cpanm a tale stack.  Ogni stack
è semplicemente una sottodirectory all'interno dell'archivio, quindi tutto ciò che dovete fare
è aggiungerla all'URL:

```
cpanm --mirror file://$HOME/repo/stacks/uri_upgrade --mirror-only My::App
```

Se tutti i test hanno successo potete aggiornare tranquillamente il modulo URI alla versione
1.62 anche nello stack "master" usando il comando `pull`.  Dato che
"master" è lo stack di default, potete omettere il parametro "--stack":

```
pinto -r ~/repo pull URI~1.62
```

## Lavorare Con I Pin

Gli stack forniscono un ottimo mezzo per testare gli effetti delle modifiche alle dipendenze della
vostra applicazione. Ma che cosa succede se i test falliscono?  Se il problema è causato
da My-App e potete correggerlo facilmente, potreste semplicemente modificare
il vostro codice, rilasciare la versione 2.0 di My-App e quindi aggiornare il modulo
URI nello stack "master".

Ma se la causa è un bug nel modulo URI oppure correggere il bug in
My-App richiederebbe troppo tempo, allora siete di fronte a un problema. Non volete che URI venga
aggiornato da qualcun altro, né volete che venga aggiornato automaticamente per
soddisfare qualche altro prerequisito di My-App.  Finché non siete sicuri
che il problema sia stato corretto, volete impedire che URI venga aggiornato.
Questo è il compito dei pin (in Italiano "puntine").

<h3>Appuntare Un Modulo</h3>

Quando appuntate un modulo in uno stack, state forzando la sua versione corrente a restare in quello
stack.  Ogni tentativo di aggiornarlo (direttamente o attraverso un altro
prerequisito) fallirà.  Per appuntare un modulo, usate il comando `pin`:

```
pinto -r ~/repo pin URI
```

Se guardate di nuovo l'elenco dei contenuti dello stack "master", vedrete
qualcosa come:

```
...
rl  My::App                         1.0  JEFF/My-App-1.0.tar.gz
rf! URI                            1.60  GAAS/URI-1.60.tar.gz
rf! URI::Escape                    3.31  GAAS/URI-1.60.tar.gz
...
```

Il simbolo "!" vicino all'inizio di una riga indica che il modulo è stato
appuntato.  Se qualcuno tenta di aggiornare il modulo URI o di aggiungere una distribuzione che
richiede una versione più recente di URI, Pinto emetterà un warning e
rifiuterà di accettare la distribuzione.  Notate che ogni modulo nella
distribuzione URI-1.60 è stato appuntato, quindi è impossibile
aggiornare parzialmente una distribuzione (questa situazione potrebbe verificarsi quando un
modulo viene spostato in una distribuzione diversa).

<h3>Staccare I Moduli</h3>

Supponete che, dopo qualche tempo, il problema in My-App sia stato corretto o che una nuova versione
di URI, senza bug, sia stata rilasciata. In questo caso, potete
staccare URI dallo stack usando il comando `unpin`:

```
pinto -r ~/repo unpin URI
```

A questo punto siete liberi di aggiornare URI alla sua ultima versione
in qualunque momento.  Come quando appuntate un modulo, quando lo staccate
vengono staccati anche tutti gli altri moduli nella distribuzione.

## Usare Pin E Stack Insieme

Pin e stack sono usati spesso insieme per aiutarvi a gestire i cambiamenti durante
il ciclo di sviluppo.  Per esempio, potete creare uno stack
"prod" che contiene le vostre dipendenze in versioni affidabili.  Allo stesso tempo,
potete creare un altro stack "dev" che contiene dipendenze
sperimentali per la vostra porssima release.  Inizialmente lo stack "dev" è
semplicemente una copia dello stack "prod".

Man mano che lo sviluppo procede, potreste aggiornare o aggiungere molti moduli sullo
stack "dev".  Se l'aggiornamento di un modulo fa fallire la vostra applicazione, 
appuntate quel modulo con un pin nello stack "prod" per segnalare che
non deve essere aggiornato.

<h3>Pin e Patch</h3>

Talvolta può succedere che una nuova versione di una distribuzione CPAN abbia un
bug ma che l'autore non possa o non voglia correggerlo (almeno non
prima del rilascio successivo).  In queste situazioni, potreste decidere
di fare una patch locale della distribuzione CPAN.

Immaginate di avere scaricato il codice di URI e di aver creato una versione locale
della distribuzione chiamata URI-1.60_PATCHED.tar.gz.  Potete aggiungerla al
vostro archivio con il comando `add`:

```
pinto -r ~/repo add path/to/URI-1.60_PATCHED.tar.gz
```

In questo caso è opportuno che appuntiate anche il modulo, dato che
non volete che venga aggiornato finché non siete sicuri che la nuova versione
su CPAN includa la vostra patch oppure che l'autore abbia comunque corretto il bug in qualche altro
modo.

```
pinto -r ~/repo pin URI
```

Quando l'autore di URI rilascia la versione 1.62, vorrete testarla
prima di decidere di staccare la vostra versione corretta in locale.  Come in
precedenza, potete farlo clonando lo stack con il comando `copy`.
Supponiamo che questa volta il nuovo stack abbia nome "trial":

```
pinto -r ~/repo copy master trial
```

Prima di poter aggiornare URI sullo stack "trial", dovete
staccarlo:

```
pinto -r ~/repo unpin --stack trial URI
```

Ora potete aggiornare URI sullo stack e provare a fare il build di
My::App con questi comandi:

```
pinto -r ~/repo pull --stack trial URI~1.62
cpanm --mirror file://$HOME/repo/stacks/trial --mirror-only My::App
```

Se tutto è andato bene, rimuovete il pin anche dallo stack "master" e importarvi la
nuova versione di URI.

```
pinto -r ~/repo unpin URI
pinto -r ~/repo pull URI~1.62
```

## Esaminare I Cambiamenti

Come ormai avrete probabilmente notato, ogni comando che cambia lo stato
di uno stack richiede un messaggio di log che lo descrive.  Potete esaminare
tali messaggi usando il comando `log`:

```
pinto -r ~/repo log
```

Questo comando dovrebbe visualizzare qualcosa come:

```
revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pin GAAS/URI-1.59.tar.gz

     Appunto URI perche' fa fallire il mio script foo.t

revision 4a62d7ce-245c-45d4-89f8-987080a90112
Date: Mar 15, 2013 1:58:05 PM
User: jeff

     Pull GAAS/URI-1.59.tar.gz

     URI e' necessario per usare HTTP nella mia applicazione

...
```

L'intestazione di ogni messaggio indica chi ha fatto il cambiamento e quando.
Include anche un identificatore univoco simile ai digest SHA-1 di Git.  Potete
usare questi identificatori per visualizzare le differenze tra due revisioni o per
ripristinare una revisione precedente dello stack [NB: questa funzione non è
ancora implementata].

## Conclusioni

In questo tutorial avete visto i comandi base per creare un archivio Pinto
e popolarlo con dei moduli.  Avete anche visto come
usare gli stack e i pin per gestire le vostre dipendenze evitando alcuni
ostacoli tipici del ciclo di sviluppo.

Ogni comando ha molte opzioni che non abbiamo discusso in questo
tutorial e alcuni comandi che non sono stati neppure
menzionati.  Vi invito quindi a esplorare le pagine dei manuali di ogni comando
per imparare di più.

