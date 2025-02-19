--- Visualizzare i turni di tutti i dipendenti per una data giornata
USE Torverbarber;

CREATE VIEW
    Dsiposizione_Turni AS
SELECT
    d.DipendenteId AS Matricola,
    d.Nome,
    d.Cognome,
    n.Nome AS Negozio,
    r.tipoRuolo AS Ruolo,
    a.Note,
    t.Data,
    t.OraInizio,
    t.OraFine
FROM
    Dipendente d
    JOIN Ruolo r ON d.RuoloId = r.RuoloId
    JOIN Negozio n ON d.NegozioId = n.NegozioId
    JOIN AssegnazioneTurno a ON d.DipendenteId = a.DipendenteId
    JOIN Turno t ON t.TurnoId = a.TurnoId
WHERE
    Data = "2024-02-14";

--- Visualizzare tutte le prenotazioni di un cliente
USE Torverbarber;

CREATE VIEW
    Prenotazione_Per_Cliente AS
SELECT
    c.Nome AS Nome_Cliente,
    c.cognome AS Cognome_Cliente,
    p.dataPrenotazione,
    p.oraPrenotazione,
    p.stato,
    p.note,
    n.nome AS Negozio,
    d.nome,
    d.cognome,
    s.nome AS Servizio
FROM
    Prenotazione p
    JOIN Servizio s ON s.ServizioId = p.ServizioId
    JOIN Dipendente d ON p.DipendenteId = d.DipendenteId
    JOIN Negozio n ON p.NegozioId = n.NegozioId
    JOIN Cliente c ON p.ClienteId = c.ClienteId
WHERE
    c.Nome = "Filippo"
    AND c.Cognome = "Gussoni";

--- Visualizzare tutti gli ordini di un cliente
USE Torverbarber;

CREATE VIEW
    Ordini_Per_Cliente AS
SELECT
    o.stato AS StatoOrdine,
    o.dataOrdine,
    p.Nome AS NomeProdotto
FROM
    Ordine o
    JOIN DettaglioOrdine d ON d.OrdineId = o.OrdineId
    JOIN Prodotto p ON p.ProdottoID = d.ProdottoID
    JOIN Cliente c ON o.ClienteId = c.ClienteId
WHERE
    c.nome = 'Tullio'
    AND c.cognome = 'Versace';

--- Mostra i dipendenti di un negozio ordinati per ruolo e data di assunzione 
USE Torverbarber;

CREATE VIEW
    Visualizza_Dipendenti AS
SELECT
    d.dataAssunzione,
    d.nome,
    d.cognome,
    r.tipoRuolo AS Ruolo
FROM
    Dipendente d
    JOIN Ruolo r ON d.RuoloId = r.RuoloId
    JOIN Negozio n ON n.NegozioId = d.NegozioId
ORDER BY
    r.tipoRuolo,
    d.dataAssunzione;

--- Visualizzare le prenotazioni con dettagli cliente e negozio ordinate per data
USE Torverbarber;

CREATE VIEW
    Prenotazioni_Clienti AS
SELECT
    c.nome,
    c.cognome,
    p.dataPrenotazione,
    p.oraPrenotazione,
    n.nome AS NomeNegozio
FROM
    Prenotazione p
    JOIN Cliente c ON c.ClienteId = p.ClienteId
    JOIN Negozio n ON n.NegozioId = p.NegozioId
ORDER BY
    p.dataPrenotazione,
    p.oraPrenotazione;

--- Visualizzare i prodotti all'interno dell'inventario di un negozio
USE Torverbarber;

CREATE VIEW
    Inventario_Negozio AS
SELECT
    p.nome,
    p.categoria,
    i.quantita,
    n.nome AS NomeNegozio
FROM
    Inventario i
    JOIN Prodotto p ON i.ProdottoId = p.ProdottoId
    JOIN Negozio n ON i.NegozioId = n.NegozioId
WHERE
    n.nome = 'Roero Group';

--- Visualizzare tutti gli ordini relativi ad un prodotto
USE Torverbarber;

CREATE VIEW
    Ordini_Per_Prodotto AS
SELECT
    o.dataOrdine,
    o.stato
FROM
    Prodotto p
    JOIN DettaglioOrdine d ON d.ProdottoId = p.ProdottoId
    JOIN Ordine o ON o.OrdineId = d.OrdineId
WHERE
    p.nome = 'Balsamo Pantene';

--- Visualizzare tutte le offerte relative ad un prodotto
-- Da rivedere
USE Torverbarber;

CREATE VIEW
    Offerte_Per_Prodotto AS
SELECT
    o.tipoOfferta,
    a.dataInizio,
    a.dataFine,
    a.PercentualeSconto,
    a.PrezzoPromozionale,
    o.tipoOfferta,
    o.descrizione
FROM
    ApplicaOfferta a
    JOIN Offerta o ON a.OffertaId = o.OffertaId
    JOIN Prodotto p ON a.ProdottoId = p.ProdottoId
WHERE
    p.nome = 'Rasoio Philips'
    AND p.Vendibille = 1;

--- Elenco delle recensioni scritte da un cliente con valutazione, commento e data.  
USE Torverbarber;

CREATE VIEW
    Feedback_Per_Utente AS
SELECT
    p.dataPrenotazione,
    p.oraPrenotazione,
    f.valutazione,
    f.commento,
    f.dataFeedback
FROM
    Feedback f
    JOIN Cliente c ON c.ClienteId = f.ClienteId
    JOIN Prenotazione p ON p.PrenotazioneId = f.PrenotazioneId
WHERE
    c.nome = 'Mario'
    and c.cognome = 'Rossi'
    --- Visualizzare tutti i feedback relativi ad un dipendente
    USE Torverbarber;

CREATE VIEW
    Feedback_Per_Dipendente AS
SELECT
    d.DipendenteId,
    p.dataPrenotazione,
    p.oraPrenotazione,
    c.nome AS NomeCliente,
    c.cognome CognomeCliente,
    f.valutazione,
    f.commento,
    f.dataFeedback
FROM
    Feedback f
    JOIN Cliente c ON f.ClienteId = c.ClienteId
    JOIN Prenotazione p ON f.PrenotazioneId = p.PrenotazioneId
    JOIN Dipendente d ON d.DipendenteId = p.DipendenteId
WHERE
    d.nome = 'Stefani'
    AND d.cognome = 'Gianinazzi';

--- Determina le entrate totali di un negozio in una specifica giornata.
USE Torverbarber;

SELECT
    n.nome AS Nome_Negozio,
    SUM(e.importo) AS Totale_Entrate
FROM
    Entrata e
    JOIN Negozio n on e.NegozioId = n.NegozioId
WHERE
    e.dataEntrata BETWEEN '2024-11-01' AND '2024-12-01'
GROUP BY
    n.NegozioId;

--- Calcolo delle vendite totali per prodotto
USE Torverbarber;

SELECT
    p.nome AS Prodotto,
    p.codiceBarre,
    SUM(d.quantita) AS PezziVenduti
FROM
    Prodotto p
    JOIN DettaglioOrdine d ON d.ProdottoId = p.ProdottoId
    JOIN Ordine o ON o.OrdineId = d.OrdineId
WHERE
    o.stato = 'Consegnato'
GROUP BY
    p.nome;

--- Numero medio di appuntamenti per dipendente al mese
USE Torverbarber;

SELECT
    DATE_FORMAT (p.dataPrenotazione, '%M %Y') AS mesePrenotazione,
    d.nome,
    d.cognome,
    ROUND(
        COUNT(p.PrenotazioneId) / COUNT(
            DISTINCT DATE_FORMAT (p.dataPrenotazione, '%Y-%m')
        ),
        1
    ) AS mediaPrenotazioni
FROM
    Dipendente d
    JOIN Prenotazione p ON p.DipendenteId = d.DipendenteId
GROUP BY
    d.DipendenteId,
    mesePrenotazione;

--- Percentuale di prenotazioni cancellate rispetto al totale
USE Torverbarber;

SELECT
    COUNT(*) AS TotalePrenotazioni,
    COUNT(
        CASE
            WHEN p.stato = 'Annullato' THEN 1
        END
    ) AS PrenotazioniCancellate,
    (
        COUNT(
            CASE
                WHEN p.stato = 'Annullato' THEN 1
            END
        ) * 100.0
    ) / NULLIF(COUNT(*), 0) AS PercentualeCancellazioni
FROM
    Prenotazione p;

--- Elenco dei clienti con il totale speso negli ultimi sei mesi
USE Torverbarber;

SELECT
    c.nome,
    c.cognome,
    (
        COALESCE(SUM(d.quantita * p.prezzo), 0) + COALESCE(SUM(s.prezzo), 0)
    ) AS TotaleSpeso
FROM
    Cliente c
    LEFT JOIN Ordine o ON c.ClienteId = o.ClienteId
    AND o.stato = 'Consegnato'
    LEFT JOIN DettaglioOrdine d ON o.OrdineId = d.OrdineId
    LEFT JOIN Prodotto p ON d.ProdottoId = p.CodiceBarre
    LEFT JOIN Prenotazione p1 ON p1.ClienteId = c.ClienteId
    AND p1.stato = 'Completato'
    LEFT JOIN Servizio s ON p1.ServizioId = s.ServizioId
WHERE
    (
        o.dataOrdine BETWEEN '2024-06-01' AND '2024-12-01'
        OR p1.dataPrenotazione BETWEEN '2024-06-01' AND '2024-12-01'
    )
GROUP BY
    c.ClienteId,
    c.nome,
    c.cognome
ORDER BY
    TotaleSpeso DESC;

--- Lista dei clienti che hanno acquistato almeno 3 volte nell’ultimo anno
USE Torverbarber;

SELECT
    c.nome,
    c.cognome,
    COUNT(o.OrdineId) AS OrdiniTotali
FROM
    Cliente c
    JOIN Ordine o ON c.ClienteId = o.ClienteId
WHERE
    (
        SELECT
            COUNT(o.OrdineId)
        FROM
            Ordine o
    ) > 3
GROUP BY
    c.ClienteId;

--- Elenco di tutti i feedback con valutazione maggiore di 4
USE Torverbarber;

SELECT
    d.nome,
    d.cognome,
    f.valutazione,
    f.dataFeedback,
    f.commento
FROM
    Dipendente d
    JOIN Prenotazione p ON p.DipendenteId = d.DipendenteId
    JOIN Ruolo r ON r.RuoloId = d.RuoloId
    JOIN Feedback f ON p.PrenotazioneId = f.FeedbackId
WHERE
    f.valutazione >= 4
    AND r.tipoRuolo = 'Barbiere';