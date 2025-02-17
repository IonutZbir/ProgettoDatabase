USE Torverbarber;

SELECT o.stato AS StatoOrdine, d.Prodotto, p.Nome AS NomeProdotto
FROM Ordine o
JOIN DettaglioOrdine d ON d.OrdineId = o.OrdineId
JOIN Prodotto p ON p.ProdottoId = d.ProdottoId
JOIN Cliente c ON o.ClienteId = c.ClienteId
WHERE c.nome = '' AND c.cognome = '';


USE Torverbarber;

SELECT d.dataAssunzione, d.nome, d.cognome, r.tipoRuolo
FROM Dipendente data
JOIN Ruolo r ON d.RuoloId = r.RuoloId
JOIN Negozio n ON n.NegozioId =  d.NegozioId
ORDER BY r.tipoRuolo, d.dataAssunzione 
WHERE n.nome = '';

USE Torverbarber;

SELECT p.data, p.ora, c.nome, c.cognome, n.nome AS NomeNegozio
FROM Prenotazione p
JOIN Cliente c ON c.ClienteId = p.ClienteId
JOIN Negozio n ON n.NegozioId = p.NegozioId
ORDER BY p.data, p.ora;

USE Torverbarber;

SELECT p.nome, p.categoria, i.quantita, n.nome AS NomeNegozio
FROM Inventario i
JOIN Prodotto p ON i.ProdottoId = p.ProdottoId
JOIN Negozio n ON i.NegozioId = n.NegozioId
WHERE n.nome = '';

USE Torverbarber;

SELECT o.dataOrdine, o.stato
FROM Prodotto paese
JOIN DettaglioOrdine d ON d.ProdottoId = p.ProdottoId
JOIN Ordine o ON o.OrdineId = d.OrdineId
WHERE p.nome = '';

USE Torverbarber;

SELECT o.tipoOfferta, a.dataInizio, a.dataFine, a.PercentualeSconto, a.PrezzoPromozionale, o.tipoOfferta, o.descrizione
FROM ApplicaOfferta a
JOIN Offerta o ON a.OffertaId = o.OffertaId
JOIN Prodotto p ON a.ProdottoId = p.ProdottoId
WHERE p.nome = '';

USE Torverbarber;

SELECT f.valutazione, f.commento, f.dataFeedback
FROM Feedback f
JOIN Cliente c ON c.ClienteId = f.ClienteId
WHERE c.nome = '' and c.cognome = '';

USE Torverbarber;

SELECT c.nome, c.cognome, f.valutazione, f.commento, f.dataFeedback
FROM Feedback f
JOIN Cliente c ON f.ClienteId = c.ClienteId
JOIN Prenotazione p ON f.PrenotazioneId = p.PrenotazioneId
JOIN Dipendente d ON d.DipendenteId = p.DipendenteId
WHERE c.nome = '' and c.cognome = '';