use Torverbarber;

CREATE TABLE
    IF NOT EXISTS Cliente (
        ClienteId INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(50) NOT NULL,
        cognome VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL, -- Password criptata con hashing
        cellulare VARCHAR(20),
        dataRegistrazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS CartaCredito (
        CartaCreditoId INT AUTO_INCREMENT PRIMARY KEY,
        numeroCarta VARCHAR(16) UNIQUE NOT NULL,
        dataScadenza DATE NOT NULL,
        cvv VARCHAR(4) NOT NULL,
        ClienteId INT NOT NULL,
        FOREIGN KEY (ClienteId) REFERENCES Cliente (ClienteId) ON DELETE CASCADE
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS IndirizzoConsegna (
        IndirizzoId INT AUTO_INCREMENT PRIMARY KEY,
        via VARCHAR(100) NOT NULL,
        civico VARCHAR(10) NOT NULL,
        citta VARCHAR(50) NOT NULL,
        cap VARCHAR(10) NOT NULL,
        paese VARCHAR(50) NOT NULL,
        provincia VARCHAR(50) NOT NULL,
        predefinito TINYINT (1) DEFAULT 0 CHECK (predefinito IN (0, 1)),
        ClienteId INT NOT NULL,
        FOREIGN KEY (ClienteId) REFERENCES Cliente (ClienteId) ON DELETE CASCADE
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Spedizione (
        SpedizioneId INT AUTO_INCREMENT PRIMARY KEY,
        dataSpedizione DATE NOT NULL,
        dataConsegna DATE,
        corriere VARCHAR(50),
        stato ENUM (
            'In preparazione',
            'In transito',
            'Consegnato',
            'Reso',
            'Annullata'
        ) NOT NULL,
        CHECK (
            dataConsegna IS NULL
            OR dataConsegna >= dataSpedizione
        ) -- Impedisce che la consegna sia prima della spedizione
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Ordine (
        OrdineId INT AUTO_INCREMENT PRIMARY KEY,
        dataOrdine DATE NOT NULL,
        stato ENUM (
            'In attesa',
            'Elaborato',
            'Spedito',
            'Consegnato',
            'Annullato',
            'Rifiutato'
        ) NOT NULL,
        ClienteId INT,
        SpedizioneId INT,
        FOREIGN KEY (ClienteId) REFERENCES Cliente (ClienteId) ON DELETE SET NULL, -- Manteniamo gli ordini ma con ClienteId a NULL per avere lo storico degli ordini
        FOREIGN KEY (SpedizioneId) REFERENCES Spedizione (SpedizioneId) ON DELETE SET NULL
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Prodotto (
        ProdottoId INT AUTO_INCREMENT PRIMARY KEY,
        codiceBarre CHAR(13) UNIQUE NOT NULL,
        nome VARCHAR(100) NOT NULL,
        categoria ENUM (
            'Shampoo',
            'Balsamo',
            'Cera',
            'Gel',
            'Rasoi Manuali',
            'Rasoi Elettrici',
            'Strumenti',
            'Altro'
        ) NOT NULL,
        prezzo DECIMAL(10, 2) NOT NULL CHECK (prezzo > 0),
        descrizione TEXT,
        vendibile TINYINT (1) DEFAULT 0 CHECK (vendibile IN (0, 1)),
        INDEX (categoria) -- Indice per ricerche più veloci
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS DettaglioOrdine (
        quantita INT NOT NULL CHECK (quantita > 0),
        OrdineId INT,
        ProdottoId INT,
        PRIMARY KEY (OrdineId, ProdottoId),
        FOREIGN KEY (OrdineId) REFERENCES Ordine (OrdineId) ON DELETE CASCADE,
        FOREIGN KEY (ProdottoId) REFERENCES Prodotto (ProdottoId) ON DELETE CASCADE
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Turno (
        TurnoId INT AUTO_INCREMENT PRIMARY KEY,
        data DATE NOT NULL,
        oraInizio TIME NOT NULL,
        oraFine TIME NOT NULL,
        CHECK (oraFine > oraInizio), -- Assicura che l'orario di fine sia successivo a quello di inizio
        UNIQUE (data, oraInizio, oraFine) -- Evita turni duplicati
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Ruolo (
        RuoloId INT AUTO_INCREMENT PRIMARY KEY,
        tipoRuolo VARCHAR(50) UNIQUE NOT NULL,
        livelloStipendiale INT NOT NULL CHECK (livelloStipendiale BETWEEN 1 AND 5)
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Servizio (
        ServizioId INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(100) UNIQUE NOT NULL,
        descrizione TEXT,
        prezzo DECIMAL(10, 2) NOT NULL CHECK (prezzo > 0),
        durataMinuti INT NOT NULL CHECK (durataMinuti > 0), -- Durata del servizio in minuti
        INDEX (nome)
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Zona (
        ZonaId INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(100) UNIQUE NOT NULL,
        descrizione TEXT
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Negozio (
        NegozioId INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        via VARCHAR(100) NOT NULL,
        civico VARCHAR(10) NOT NULL,
        citta VARCHAR(50) NOT NULL,
        cap VARCHAR(10) NOT NULL,
        telefono VARCHAR(20),
        orarioApertura TIME NOT NULL,
        orarioChiusura TIME NOT NULL CHECK (OrarioChiusura > OrarioApertura), -- Impredisce orari errati 
        email VARCHAR(100) UNIQUE NOT NULL,
        ZonaId INT,
        FOREIGN KEY (ZonaId) REFERENCES Zona (ZonaId) ON DELETE SET NULL
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Inventario (
        quantita INT NOT NULL CHECK (quantita >= 0),
        ultimaModifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Tiene traccia dell'ultima modifica
        ProdottoId INT,
        NegozioId INT,
        PRIMARY KEY (ProdottoId, NegozioId),
        FOREIGN KEY (ProdottoId) REFERENCES Prodotto (ProdottoId) ON DELETE CASCADE,
        FOREIGN KEY (NegozioId) REFERENCES Negozio (NegozioId) ON DELETE CASCADE
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Dipendente (
        DipendenteId INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(50) NOT NULL,
        cognome VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL, -- Password cifrata
        cellulare VARCHAR(20),
        dataNascita DATE NOT NULL,
        dataAssunzione DATE NOT NULL,
        CHECK (dataAssunzione > dataNascita),
        stipendio DECIMAL(10, 2) NOT NULL CHECK (stipendio > 0),
        RuoloId INT,
        NegozioId INT,
        FOREIGN KEY (RuoloId) REFERENCES Ruolo (RuoloId) ON DELETE SET NULL,
        FOREIGN KEY (NegozioId) REFERENCES Negozio (NegozioId) ON DELETE SET NULL
    ) ENGINE = INNODB;

ALTER TABLE Zona ADD ResponsabileID INT;

ALTER TABLE Zona ADD CONSTRAINT fk_responsabile FOREIGN KEY (ResponsabileID) REFERENCES Dipendente (DipendenteId) ON DELETE SET NULL;

CREATE TABLE
    IF NOT EXISTS AssegnazioneTurno (
        dataAssegnazione DATE NOT NULL,
        note TEXT,
        DipendenteId INT,
        TurnoId INT,
        PRIMARY KEY (DipendenteId, TurnoId),
        UNIQUE (DipendenteId, dataAssegnazione), -- Evita doppie assegnazioni nello stesso giorno
        FOREIGN KEY (DipendenteId) REFERENCES Dipendente (DipendenteId) ON DELETE CASCADE,
        FOREIGN KEY (TurnoId) REFERENCES Turno (TurnoId) ON DELETE CASCADE
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Prenotazione (
        PrenotazioneId INT AUTO_INCREMENT PRIMARY KEY,
        dataPrenotazione DATE NOT NULL,
        oraPrenotazione TIME NOT NULL,
        stato ENUM (
            'In attesa',
            'Confermato',
            'Annullato',
            'Completato',
            'No-Show'
        ) NOT NULL,
        note TEXT,
        ClienteId INT,
        ServizioId INT,
        DipendenteId INT,
        FOREIGN KEY (ClienteId) REFERENCES Cliente (ClienteId) ON DELETE SET NULL,
        FOREIGN KEY (ServizioId) REFERENCES Servizio (ServizioId) ON DELETE CASCADE,
        FOREIGN KEY (DipendenteId) REFERENCES Dipendente (DipendenteId) ON DELETE SET NULL,
        UNIQUE (DipendenteId, dataPrenotazione, oraPrenotazione) -- Evita doppie prenotazioni per lo stesso barbiere
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Feedback (
        FeedbackId INT AUTO_INCREMENT PRIMARY KEY,
        valutazione INT NOT NULL CHECK (valutazione BETWEEN 1 AND 5),
        commento TEXT,
        dataFeedback DATE NOT NULL DEFAULT CURDATE (),
        ClienteId INT,
        PrenotazioneId INT UNIQUE, -- Impedisce più feedback sulla stessa prenotazione
        FOREIGN KEY (ClienteId) REFERENCES Cliente (ClienteId) ON DELETE SET NULL,
        FOREIGN KEY (PrenotazioneId) REFERENCES Prenotazione (PrenotazioneId) ON DELETE CASCADE
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Entrata (
        EntrataId INT AUTO_INCREMENT PRIMARY KEY,
        dataEntrata DATE NOT NULL DEFAULT CURDATE (), -- Se non specificata, usa la data attuale
        importo DECIMAL(10, 2) NOT NULL CHECK (importo > 0),
        metodoPagamento ENUM ('Contanti', 'Carta', 'PayPal') NOT NULL,
        descrizione TEXT,
        NegozioId INT,
        FOREIGN KEY (NegozioId) REFERENCES Negozio (NegozioId) ON DELETE CASCADE
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS Offerta (
        OffertaId INT AUTO_INCREMENT PRIMARY KEY,
        tipoOfferta ENUM ('Percentuale', 'Sconto Fisso', 'Promo Speciale') NOT NULL,
        descrizione TEXT NOT NULL
    ) ENGINE = INNODB;

CREATE TABLE
    IF NOT EXISTS ApplicaOfferta (
        OffertaId INT,
        ProdottoId INT,
        PercentualeSconto DECIMAL(5, 2) CHECK (PercentualeSconto BETWEEN 0 AND 100),
        ScontoFisso DECIMAL(10, 2) CHECK (ScontoFisso >= 0),
        PrezzoPromozionale DECIMAL(10, 2) CHECK (PrezzoPromozionale >= 0),
        dataInizio DATE NOT NULL,
        dataFine DATE NOT NULL,
        CHECK (dataFine >= dataInizio), -- Impedisce date errate
        CHECK (
            (
                PercentualeSconto IS NOT NULL
                AND ScontoFisso IS NULL
                AND PrezzoPromozionale IS NULL
            )
            OR (
                PercentualeSconto IS NULL
                AND ScontoFisso IS NOT NULL
                AND PrezzoPromozionale IS NULL
            )
            OR (
                PercentualeSconto IS NULL
                AND ScontoFisso IS NULL
                AND PrezzoPromozionale IS NOT NULL
            )
        ), -- Assicura che solo uno sconto sia impostato
        PRIMARY KEY (OffertaId, ProdottoId),
        FOREIGN KEY (OffertaId) REFERENCES Offerta (OffertaId) ON DELETE CASCADE,
        FOREIGN KEY (ProdottoId) REFERENCES Prodotto (ProdottoId) ON DELETE CASCADE
    ) ENGINE = INNODB;