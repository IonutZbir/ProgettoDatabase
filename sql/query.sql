USE Torverbarber;

CREATE VIEW Dsiposizione_Turni AS
SELECT d.DipendenteId AS Matricola, d.Nome, d.Cognome, n.Nome AS Negozio, r.tipoRuolo AS Ruolo, a.Note, t.Data, t.OraInizio, t.OraFine  
FROM Dipendente d
JOIN Ruolo r ON d.RuoloId = r.RuoloId
JOIN Negozio n ON d.NegozioId = n.NegozioId
JOIN AssegnazioneTurno a ON d.DipendenteId = a.DipendenteId
JOIN Turno t ON t.TurnoId = a.TurnoId 
WHERE Data = "2024-02-14";

---

USE Torverbarber;

CREATE VIEW Prenotazione_Per_Cliente AS
SELECT c.Nome AS Nome_Cliente, c.cognome AS Cognome_Cliente, p.dataPrenotazione, p.oraPrenotazione, p.stato, p.note, n.nome AS Negozio, d.nome, d.cognome, s.nome AS Servizio
FROM Prenotazione p
JOIN Servizio s ON s.ServizioId = p.ServizioId
JOIN Dipendente d ON p.DipendenteId = d.DipendenteId
JOIN Negozio n ON p.NegozioId = n.NegozioId
JOIN Cliente c ON p.ClienteId = c.ClienteId
WHERE c.Nome = "Filippo" AND c.Cognome = "Gussoni";