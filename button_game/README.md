# button_game

Prima esercitazione flutter, prova con l'uso di Stream

## Procedimento

Il cronometro lo adopero in funzione di uno Stream: _onGoing.

Il quale tramite la funzione waiting, fino ad un numero imprecisato di volte(se non specificato infinito), attende un secondo. 
Per il quale lo Stream si ascolta per far partire la funzione: incrementCounter() (che a differenza di waiting è sincrona), che mi permette di incrementetare ogni secondo i secondi del cronometro. La funzione aggiorna automaticamente anche i minuti e le ore.

Usati 2 pulsanti, per avviare il cronometro e per fermarlo, fermare il cronometro è ancora inefficiente visto che non si blocca lo stream ma si impedisce l'aggiornamento del contatore dei secondi, ma queste due funzioni di avvio e riposo sono dato un pulsante che ambia interazione a seconda dello stasto dello Stream (o meglio se ci sono in ascolto o meno); l'altro pulsante sempre presente fa ripartire il cronometro da 0. Questo bottone anche se sempre presente si palesa all'utente solo quando il cronometro è fermo così da fare un reset (Se in caso si cliccasse il pulsante mentre non è visibile ci sarà comunque un reset, ma si partirà dal secondo, già calcolato, 1).

Di sicuro non ci saranno errori, per la visualizzazione dei numero del cronometro(Ore:Minuti:Secondi): gestiti da 3 funzioni che in base alle decine mi permettono di visulizzare solo le unità anticipate con lo 0 oppure il numero reale presente nel codice.

## DIfficoltà

Le maggiori difficoltà le ho riscontate:

- Prima di aver rivisto bene la documentazione sugli [Stream](https://gitlab.com/divino.marchese/zuccante_src/wikis/dart/stream) data dal professore.
- La gestione dell'ascolto dello Stream, per la quale mi sto ancora interrogando
- La gestione dei bottoni (anche se è un punto secondario)

Comunque si son largamente quasi tutte risolte.

## Aggiornamento e scuse 17/11/2020

Durante le ore di laboratorio ero andato a controllare i miei progetti su GitHub, a quanto sembra mi son completamente dimenticato di salvare lì il file .md finito di scrivere la sera, qualche ora prima della consegna.
Un piccolo incidente dato dal fatto che ho avuto tante difficoltà a capire come scriverci.
Il programma non ha subito alteramenti, l'unico file che malaugaratemente devo caricare oggi è questo, ma per mia incompetenza.