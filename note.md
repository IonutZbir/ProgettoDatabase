# Alcune note

## Triggers

1. Quando si aggiunge un feedback, controllare che si fa riferimento ad un barbiere. `Check Staff.Tipo == Barbiere`
1. Quando si aggiunge una zona, controllare che gli venga associato un responsabile di zona `Check Staff.Tipo == Responsabile Zona`

- implemetare una routine per il calocolo del stipendio

## Alcuni appunti su

- Diagramma Entity-Relationship
    a. Schema scheletro
    b. 1° livello di raffinamento
    c. Schema concettuale non ristrutturato
    d. Schema finale ristrutturato

Le fasi descritte per il Diagramma Entity-Relationship (E-R) si riferiscono ai passaggi progressivi della progettazione concettuale del database, partendo da una struttura di base (schema scheletro) fino ad arrivare a una versione ristrutturata ottimizzata. Ecco cosa significa ciascun punto:
a. Schema scheletro

    È una prima versione del diagramma E-R, molto semplice e minimale.
    Contiene solo le entità principali e le loro relazioni fondamentali, senza approfondire dettagli sugli attributi, vincoli o ulteriori relazioni.
    Serve per identificare:
        Quali sono le entità chiave del sistema.
        Le relazioni principali tra queste entità.

Esempio per TORVERBARBER: Entità principali:

    Negozio, Staff, Cliente, Prenotazione, Servizio.

Relazioni fondamentali:

    "Un Cliente effettua una Prenotazione."
    "Uno Staff lavora per un Negozio."

b. 1° livello di raffinamento

    Aggiunge maggiore dettaglio rispetto allo schema scheletro:
        Inserimento degli attributi principali per le entità.
        Specifica delle cardinalità (es. 1:1, 1:N, N:M) per le relazioni.
        Introduzione di ulteriori relazioni derivanti dall'analisi dei vincoli.

Esempio per TORVERBARBER:

    Per l'entità Staff, potresti aggiungere gli attributi: Nome, Ruolo, LivelloEsperienza.
    Per la relazione Effettua (Cliente - Prenotazione), potresti indicare che un Cliente può effettuare più Prenotazioni (1:N).

c. Schema concettuale non ristrutturato

    È una versione completa e dettagliata del diagramma E-R:
        Contiene tutte le entità, attributi e relazioni.
        Rappresenta anche vincoli complessi, come vincoli di integrità, specializzazioni o generalizzazioni.
        Non include ancora ottimizzazioni, quindi possono esserci ridondanze o strutture meno efficienti.

Esempio per TORVERBARBER:

    Potresti avere entità come Feedback o Turno, ognuna con i propri attributi.
    La relazione Assegna tra Negozio e Staff potrebbe includere informazioni sui turni di lavoro.

d. Schema finale ristrutturato

    È una versione ottimizzata dello schema concettuale, pronta per essere trasformata in uno schema logico.
    Vengono applicate tecniche di ristrutturazione:
        Eliminazione di ridondanze.
        Semplificazione di relazioni complesse.
        Uso di entità deboli se necessario.
        Partizionamento o accorpamento di entità e relazioni per garantire chiarezza e coerenza.

Esempio per TORVERBARBER:

    La relazione "Effettua" (Cliente - Prenotazione) potrebbe includere anche il riferimento al Servizio prenotato.
    Se ci sono vincoli complessi (es. un barbiere può lavorare in un solo negozio), questi vengono formalizzati nello schema.

Riassunto

    Schema scheletro: Identifica solo entità e relazioni principali.
    1° livello di raffinamento: Aggiunge attributi e cardinalità.
    Schema concettuale non ristrutturato: Modello dettagliato con tutti gli elementi, ma senza ottimizzazioni.
    Schema finale ristrutturato: Versione ottimizzata per eliminare ridondanze e facilitare la progettazione logica.

## Scelta delle chiavi primarie

Motivazione per l'uso di chiavi univoche (ID)

Nel progetto TORVERBARBER, abbiamo deciso di adottare una chiave primaria univoca per ogni entità del sistema (come Negozio_Id, Staff_Id, Cliente_Id, ecc.). Questa scelta è stata guidata da diverse considerazioni progettuali:

    Univocità e chiarezza: L'utilizzo di un ID numerico o alfanumerico univoco per ciascuna entità garantisce che ogni record sia identificato in modo unico e preciso. Questo elimina il rischio di confusione e conflitti, particolarmente in entità che potrebbero avere attributi simili o identici (ad esempio, due negozi con lo stesso nome ma in città diverse).

    Semplicità nelle relazioni: Le chiavi esterne basate su ID, come Negozio_Id, Staff_Id e Cliente_Id, semplificano le relazioni tra le entità. In un sistema con molte entità e interazioni, l'uso di ID rende più facile collegare, aggiornare e mantenere le informazioni tra le tabelle, senza dover gestire combinazioni di più attributi per ogni relazione.

    Flessibilità e manutenzione: L'adozione di chiavi univoche consente una maggiore flessibilità nelle modifiche future del sistema. Ad esempio, se un negozio cambia nome o indirizzo, non è necessario aggiornare tutte le tabelle e le relazioni collegate, poiché l'ID rimane invariato. Questo riduce la complessità e il rischio di errori.

    Efficienza nelle operazioni: Le chiavi numeriche o alfanumeriche sono più rapide da indicizzare e confrontare rispetto a chiavi composte (formate da più attributi), il che migliora le prestazioni durante l'esecuzione delle query e delle operazioni di join nel database.

    Scalabilità: L'uso di chiavi univoche permette di gestire facilmente l'espansione del sistema. Con l'aumentare del numero di entità e record, la gestione delle chiavi diventa sempre più semplice rispetto all'uso di chiavi composte, che potrebbero diventare difficili da mantenere man mano che il sistema cresce.