--- Visualizzare i turni di tutti i dipendenti per una data giornata

USE Torverbarber;

CREATE VIEW Dsiposizione_Turni AS
SELECT d.DipendenteId AS Matricola, d.Nome, d.Cognome, n.Nome AS Negozio, r.tipoRuolo AS Ruolo, a.Note, t.Data, t.OraInizio, t.OraFine  
FROM Dipendente d
JOIN Ruolo r ON d.RuoloId = r.RuoloId
JOIN Negozio n ON d.NegozioId = n.NegozioId
JOIN AssegnazioneTurno a ON d.DipendenteId = a.DipendenteId
JOIN Turno t ON t.TurnoId = a.TurnoId 
WHERE Data = "2024-02-14";

--- Visualizzare tutte le prenotazioni di un cliente

USE Torverbarber;

CREATE VIEW Prenotazione_Per_Cliente AS
SELECT c.Nome AS Nome_Cliente, c.cognome AS Cognome_Cliente, p.dataPrenotazione, p.oraPrenotazione, p.stato, p.note, n.nome AS Negozio, d.nome, d.cognome, s.nome AS Servizio
FROM Prenotazione p
JOIN Servizio s ON s.ServizioId = p.ServizioId
JOIN Dipendente d ON p.DipendenteId = d.DipendenteId
JOIN Negozio n ON p.NegozioId = n.NegozioId
JOIN Cliente c ON p.ClienteId = c.ClienteId
WHERE c.Nome = "Filippo" AND c.Cognome = "Gussoni";

--- Visualizzare tutti gli ordini di un cliente

USE Torverbarber;

CREATE VIEW Ordini_Per_Cliente AS
SELECT o.stato AS StatoOrdine, o.dataOrdine, p.Nome AS NomeProdotto
FROM Ordine o
JOIN DettaglioOrdine d ON d.OrdineId = o.OrdineId
JOIN Prodotto p ON p.ProdottoID = d.ProdottoID
JOIN Cliente c ON o.ClienteId = c.ClienteId
WHERE c.nome = 'Tullio' AND c.cognome = 'Versace';

--- Mostra i dipendenti di un negozio ordinati per ruolo e data di assunzione 

USE Torverbarber;

CREATE VIEW Visualizza_Dipendenti AS
SELECT d.dataAssunzione, d.nome, d.cognome, r.tipoRuolo AS Ruolo
FROM Dipendente d
JOIN Ruolo r ON d.RuoloId = r.RuoloId
JOIN Negozio n ON n.NegozioId =  d.NegozioId
ORDER BY r.tipoRuolo, d.dataAssunzione;

--- Visualizzare le prenotazioni con dettagli cliente e negozio ordinate per data

USE Torverbarber;

CREATE VIEW Prenotazioni_Clienti AS
SELECT c.nome, c.cognome, p.dataPrenotazione, p.oraPrenotazione, n.nome AS NomeNegozio
FROM Prenotazione p
JOIN Cliente c ON c.ClienteId = p.ClienteId
JOIN Negozio n ON n.NegozioId = p.NegozioId
ORDER BY p.dataPrenotazione, p.oraPrenotazione;

--- Visualizzare i prodotti all'interno dell'inventario di un negozio

USE Torverbarber;

CREATE VIEW Inventario_Negozio AS
SELECT p.nome, p.categoria, i.quantita, n.nome AS NomeNegozio
FROM Inventario i
JOIN Prodotto p ON i.ProdottoId = p.ProdottoId
JOIN Negozio n ON i.NegozioId = n.NegozioId
WHERE n.nome = 'Roero Group';

--- Visualizzare tutti gli ordini relativi ad un prodotto

USE Torverbarber;

CREATE VIEW Ordini_Per_Prodotto AS
SELECT o.dataOrdine, o.stato
FROM Prodotto p
JOIN DettaglioOrdine d ON d.ProdottoId = p.ProdottoId
JOIN Ordine o ON o.OrdineId = d.OrdineId
WHERE p.nome = 'Forbici';