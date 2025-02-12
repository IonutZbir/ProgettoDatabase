import random
from faker import Faker
from datetime import datetime, timedelta, date

fake = Faker('it_IT')

DATABASE = 'USE Torverbarber;\n'

# Genera mail random
def generateEmail(name, surname):
    
    domain = fake.domain_name()

    return f'{name}.{surname}@{domain}'

# Genera password random
def generatePsw():
    ALL = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    psw = ''.join(random.choice(ALL) for i in range(9))
    return psw

# Genera numeri di carta
def generateCardNumber():
    NUMBERS = '0123456789'
    number = ''.join(random.choice(NUMBERS) for i in range(16))
    return number

def insert_users(n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_utenti = []

        for _ in range(n):
            surname = fake.last_name()
            name = fake.first_name()
            email = str(generateEmail(name, surname))
            psw = generatePsw()
            cell = fake.phone_number()
            query = f'("{name}", "{surname}", "{email}", "{psw}", "{cell}")'
            values_utenti.append(query)
        
        f.write(
            'INSERT INTO Cliente (nome, cognome, email, password, cellulare) VALUES ' + ',\n'.join(values_utenti) + ';'
        )

def insert_carte_credito(n_users: int, n: int, file: str): 
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_carte = []
        
        for _ in range(n):
            numero_carta = generateCardNumber()
            data_scadenza = fake.date_between(start_date=date(2010, 1, 1), end_date=date(2030, 12, 31))
            data_scadenza_str = data_scadenza.strftime("%Y-%m-%d")  # Converti in stringa formattata
            cvv = ''.join(str(random.randint(0, 9)) for _ in range(3))
            cliente_id = random.randint(1, n_users)
            query = f'("{numero_carta}", "{data_scadenza_str}", "{cvv}", {cliente_id})'
            values_carte.append(query)

        f.write(
            'INSERT INTO CartaCredito (numeroCarta, dataScadenza, cvv, ClienteId) VALUES ' + ',\n'.join(values_carte) + ';'
        )

def insert_indirizzi_consegna(n_users: int, n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_indirizzi = []
        
        for _ in range(n):
            via = fake.street_name()
            civico = str(random.randint(1, 200))
            citta = fake.city()
            cap = fake.postcode()
            paese = 'Italia'
            provincia = fake.state()
            predefinito = random.choice([0, 1])
            cliente_id = random.randint(1, n_users)
            query = f'("{via}", "{civico}", "{citta}", "{cap}", "{paese}", "{provincia}", {predefinito}, {cliente_id})'
            values_indirizzi.append(query)

        f.write(
            'INSERT INTO IndirizzoConsegna (via, civico, citta, cap, paese, provincia, predefinito, ClienteId) VALUES ' + ',\n'.join(values_indirizzi) + ';'
        )

def insert_spedizioni(n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_spedizioni = []
        
        stati = ["In preparazione", "In transito", "Consegnato", "Reso", "Annullata"]
    
        for _ in range(n):
            data_spedizione = fake.date_between(start_date="-1y", end_date="today")
            data_consegna = data_spedizione + timedelta(days=random.randint(1, 10)) if random.choice([True, False]) else None
            corriere = fake.company()
            stato = random.choice(stati)
            data_consegna_str = f'"{data_consegna}"' if data_consegna else 'NULL'
            query = f'("{data_spedizione}", {data_consegna_str}, "{corriere}", "{stato}")'
            values_spedizioni.append(query)            

        f.write(
            'INSERT INTO Spedizione (dataSpedizione, dataConsegna, corriere, stato) VALUES ' + ',\n'.join(values_spedizioni) + ';'
        )

def insert_ordini(n_spedizioni: int, n_users: int, n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_ordini = []
        
        stati_ordine = ["In attesa", "Elaborato", "Spedito", "Consegnato", "Annullato", "Rifiutato"]
    
        for _ in range(n):
            data_ordine = fake.date_between(start_date="-1y", end_date="today")
            stato = random.choice(stati_ordine)
            cliente_id = random.randint(1, n_users)
            spedizione_id = random.randint(1, n_spedizioni)
            query = f'("{data_ordine}", "{stato}", {cliente_id}, {spedizione_id})'
            values_ordini.append(query)            

        f.write(
            'INSERT INTO Ordine (dataOrdine, stato, ClienteId, SpedizioneId) VALUES ' + ',\n'.join(values_ordini) + ';'
        )

def insert_prodotti(n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_prodotti = []    
        categorie = ["Shampoo", "Balsamo", "Cera", "Gel", "Rasoi Manuali", "Rasoi Elettrici", "Strumenti", "Altro"]
    
        for _ in range(n):
            codice_barre = fake.ean13()
            nome = fake.word().capitalize()
            categoria = random.choice(categorie)
            prezzo = round(random.uniform(5.0, 100.0), 2)
            descrizione = fake.sentence(nb_words=10)
            vendibile = random.choice([0, 1])
            query = f'("{codice_barre}", "{nome}", "{categoria}", "{prezzo}", "{descrizione}", {vendibile})'
            values_prodotti.append(query)            

        f.write(
            'INSERT INTO Prodotto (codiceBarre, nome, categoria, prezzo, descrizione, vendibile) VALUES ' + ',\n'.join(values_prodotti) + ';'
        )

def insert_dettagli_ordini(n: int, n_prodotti: int, n_ordini: int, file: str):
    from itertools import product
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_dettagli = []    

        combinazioni_possibili = list(product(range(1, n_ordini + 1), range(1, n_prodotti + 1)))

        n = min(n, len(combinazioni_possibili))

        dettagli_unici = random.sample(combinazioni_possibili, n)

        for ordine_id, prodotto_id in dettagli_unici:
            quantita = random.randint(1, 10)
            query = f'({quantita}, {ordine_id}, {prodotto_id})'
            values_dettagli.append(query)

        f.write(
            'INSERT INTO DettaglioOrdine (quantita, OrdineId, ProdottoId) VALUES ' + ',\n'.join(values_dettagli) + ';'
        )


def insert_turni(n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_turni = set()    
    
        for _ in range(n):
            data = fake.date_between(start_date="-1y", end_date="today")

            ora_inizio_dt = datetime.strptime(random.choice(["08:00:00", "14:00:00"]), "%H:%M:%S")
            ora_fine_dt = ora_inizio_dt + timedelta(hours=8)
            
            ora_inizio = ora_inizio_dt.strftime("%H:%M:%S")
            ora_fine = ora_fine_dt.strftime("%H:%M:%S")

            query = f'("{data}", "{ora_inizio}", "{ora_fine}")'
            values_turni.add(query)

        f.write(
            'INSERT INTO Turno (data, oraInizio, oraFine) VALUES ' + ',\n'.join(values_turni) + ';'
        )

def insert_zona(n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_zona = []    
    
        for _ in range(n):
            nome = fake.city()
            descrizione = fake.sentence(nb_words=10)
            responsabile_id = 'NULL'
            query = f'("{nome}", "{descrizione}", {responsabile_id})'
            values_zona.append(query)

        f.write(
            'INSERT INTO Zona (nome, descrizione, ResponsabileID) VALUES ' + ',\n'.join(values_zona) + ';'
        )

def insert_negozi(n: int, file: str, n_zone: int):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_negozio = []    
    
        for _ in range(n):
            nome = fake.company()
            via = fake.street_name()
            civico = str(random.randint(1, 200))
            citta = fake.city()
            cap = fake.postcode()
            telefono = fake.phone_number()
            ora_apertura_dt = datetime.strptime(random.choice(["08:00:00", "09:00:00", "10:00:00"]), "%H:%M:%S")
            ora_chiusura_dt = ora_apertura_dt + timedelta(hours=random.choice([8, 9, 10]))  # Turni tra 8 e 10 ore
            orario_apertura = ora_apertura_dt.strftime("%H:%M:%S")
            orario_chiusura = ora_chiusura_dt.strftime("%H:%M:%S")
            email = email = f"{nome.replace(' ', '').lower()}@{fake.domain_name()}"
            zona_id = random.randint(1, n_zone)

            query = f'("{nome}", "{via}", "{civico}", "{citta}", "{cap}", "{telefono}", "{orario_apertura}", "{orario_chiusura}", "{email}", {zona_id})'
            values_negozio.append(query)

        f.write(
            'INSERT INTO Negozio (nome, via, civico, citta, cap, telefono, orarioApertura, orarioChiusura, email, ZonaId) VALUES ' + ',\n'.join(values_negozio) + ';'
        )

def insert_inventario(n: int, n_negozi: int, n_prodotti: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_inventario = []    
        h = set()
    
        for _ in range(n):
            prodotto_id = random.randint(1, n_prodotti)
            negozio_id = random.randint(1, n_negozi)
            quantita = random.randint(0, 500)
            if (prodotto_id, negozio_id) not in h:
                query = f'({quantita}, {prodotto_id}, {negozio_id})'
                values_inventario.append(query)
            h.add((prodotto_id, negozio_id))

        f.write(
            'INSERT INTO Inventario (quantita, ProdottoId, NegozioId) VALUES ' + ',\n'.join(values_inventario) + ';'
        )

def insert_dipendente(n: int, n_ruoli: int, n_negozi: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_dipendente = []    
    
        for _ in range(n):
            nome = fake.first_name()
            cognome = fake.last_name()
            email = generateEmail(nome, cognome)
            password = fake.password()
            cellulare = fake.phone_number()
            data_nascita = fake.date_of_birth(minimum_age=18, maximum_age=65)
            data_assunzione = fake.date_between(start_date=data_nascita, end_date='today')
            stipendio = round(random.uniform(1200.0, 5000.0), 2)
            ruolo_id = random.randint(1, n_ruoli)
            negozio_id = random.randint(1, n_negozi)
            
            query = f'("{nome}", "{cognome}", "{email}", "{password}", "{cellulare}", "{data_nascita}", "{data_assunzione}", {stipendio}, {ruolo_id}, {negozio_id})'
            values_dipendente.append(query)

        f.write(
            'INSERT INTO Dipendente (nome, cognome, email, password, cellulare, dataNascita, dataAssunzione, stipendio, RuoloId, NegozioId) VALUES ' + ',\n'.join(values_dipendente) + ';'
        )

def insert_assegnazione_turno(n: int, n_dipendenti: int, n_turni: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_assegnazione = []    
        h = set()
        s = set()
        for _ in range(n):
            data_assegnazione = fake.date_between(start_date="-1y", end_date="today")
            note = fake.sentence(nb_words=8) if random.choice([True, False]) else None
            note = f'"{note}"' if note else 'NULL'
            dipendente_id = random.randint(1, n_dipendenti)
            turno_id = random.randint(1, n_turni)
            
            if (dipendente_id, turno_id) not in h and (dipendente_id, data_assegnazione) not in s:
                query = f'("{data_assegnazione}", {note}, {dipendente_id}, {turno_id})'
                values_assegnazione.append(query)
            h.add((dipendente_id, turno_id))
            s.add((dipendente_id, data_assegnazione))

        f.write(
            'INSERT INTO AssegnazioneTurno (dataAssegnazione, note, DipendenteId, TurnoId) VALUES ' + ',\n'.join(values_assegnazione) + ';'
        )

def insert_prenotazione(n: int, n_dipendenti: int, n_clienti: int, n_servizi: int, file: str):
     with open(file, 'w') as f:
        f.write(DATABASE)
        values_prenotazioni = []    
        stati_prenotazione = ["In attesa", "Confermato", "Annullato", "Completato", "No-Show"]
        
        for _ in range(n):
            data_prenotazione = fake.date_between(start_date="-1y", end_date="today")
            ora_prenotazione = fake.time(pattern='%H:%M:%S')
            stato = random.choice(stati_prenotazione)
            note = fake.sentence(nb_words=8) if random.choice([True, False]) else None
            note = f'"{note}"' if note else 'NULL'
            cliente_id = random.randint(1, n_clienti)
            servizio_id = random.randint(1, n_servizi)
            dipendente_id = random.randint(1, n_dipendenti)
            
            query = f'("{data_prenotazione}", "{ora_prenotazione}", "{stato}", {note}, {cliente_id}, {servizio_id}, {dipendente_id})'
            values_prenotazioni.append(query)

        f.write(
            'INSERT INTO Prenotazione (dataPrenotazione, oraPrenotazione, stato, note, ClienteId, ServizioId, DipendenteId) VALUES ' + ',\n'.join(values_prenotazioni) + ';'
        )

def insert_feedback(n: int, n_clienti: int, n_dipendenti: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_feedback = []    
        h = set()
        for _ in range(n):
            valutazione = random.randint(1, 5)
            commento = fake.sentence(nb_words=12) if random.choice([True, False]) else None
            commento = f'"{commento}"' if commento else 'NULL'
            data_feedback = fake.date_between(start_date="-1y", end_date="today")
            cliente_id = random.randint(1, n_clienti)
            prenotazione_id = random.randint(1, n_dipendenti)
            if prenotazione_id not in h:
                query = f'({valutazione}, {commento}, "{data_feedback}", {cliente_id}, {prenotazione_id})'
                values_feedback.append(query)
            h.add(prenotazione_id)

        f.write(
            'INSERT INTO Feedback (valutazione, commento, dataFeedback, ClienteId, PrenotazioneId) VALUES ' + ',\n'.join(values_feedback) + ';'
        )

def insert_entrate(n: int, n_negozi: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_entrate = []    
        metodi_pagamento = ["Contanti", "Carta", "PayPal"]
    
        for _ in range(n):
            data_entrata = fake.date_between(start_date="-1y", end_date="today")
            importo = round(random.uniform(10.0, 1000.0), 2)
            metodo_pagamento = random.choice(metodi_pagamento)
            descrizione = fake.sentence(nb_words=10) if random.choice([True, False]) else None
            descrizione = f'"{descrizione}"' if descrizione else 'NULL'
            negozio_id = random.randint(1, n_negozi)
            
            query = f'("{data_entrata}", {importo}, "{metodo_pagamento}", {descrizione}, {negozio_id})'
            values_entrate.append(query)

        f.write(
            'INSERT INTO Entrata (dataEntrata, importo, metodoPagamento, descrizione, NegozioId) VALUES ' + ',\n'.join(values_entrate) + ';'
        )

def insert_offerte(n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_offerte = []    
        tipi_offerta = ["Percentuale", "Sconto Fisso", "Promo Speciale"]
    
        for _ in range(n):
            tipo_offerta = random.choice(tipi_offerta)
            descrizione = fake.sentence(nb_words=12)
            
            query = f'("{tipo_offerta}", "{descrizione}")'
            values_offerte.append(query)

        f.write(
            'INSERT INTO Offerta (tipoOfferta, descrizione) VALUES ' + ',\n'.join(values_offerte) + ';'
        )

def insert_applica_offerta(n: int, file: str):
    with open(file, 'w') as f:
        f.write(DATABASE)
        values_applica_offerta = []    
        h = set()
        
        for _ in range(n):
            offerta_id = random.randint(1, 100)
            prodotto_id = random.randint(1, 100)
            data_inizio = fake.date_between(start_date="-1y", end_date="today")
            data_fine = fake.date_between(start_date=data_inizio, end_date="+1y")
            
            tipo_sconto = random.choice(["percentuale", "fisso", "prezzo"])
            
            
            if tipo_sconto == "percentuale":
                percentuale_sconto = round(random.uniform(1.0, 50.0), 2)
                sconto_fisso = 'NULL'
                prezzo_promozionale = 'NULL'
            elif tipo_sconto == "fisso":
                percentuale_sconto = 'NULL'
                sconto_fisso = round(random.uniform(5.0, 50.0), 2)
                prezzo_promozionale = 'NULL'
            else:
                percentuale_sconto = 'NULL'
                sconto_fisso = 'NULL'
                prezzo_promozionale = round(random.uniform(5.0, 100.0), 2)
            
            if (offerta_id, prodotto_id) not in h:
                query = f'({offerta_id}, {prodotto_id}, {percentuale_sconto}, {sconto_fisso}, {prezzo_promozionale}, "{data_inizio}", "{data_fine}")'
                values_applica_offerta.append(query)
            h.add((offerta_id, prodotto_id))

        f.write(
            'INSERT INTO ApplicaOfferta (OffertaId, ProdottoId, PercentualeSconto, ScontoFisso, PrezzoPromozionale, dataInizio, dataFine) VALUES ' + ',\n'.join(values_applica_offerta) + ';'
        )

if __name__ == '__main__':
    CLIENTI = (500, 'clienti.sql')
    CARTE = (1000, 'carte.sql')
    INDIRIZZI = (1000, 'indirizzi.sql')
    SPEDIZIONI = (2500, 'spedizioni.sql')
    ORDINI = (2500, 'ordini.sql')
    PRODOTTI = (2500, 'prodotti.sql')
    DETTAGLIORDINI = (2500, 'dettaglio_ordini.sql')
    TURNI = (1000, 'turni.sql')
    RUOLI = 5
    SERVIZI = 22
    ZONE = (20, 'zone.sql')
    NEGOZI = (20, 'negozi.sql')
    INVENTARI = (500, 'inventari.sql')
    DIPENDENTI = (250, 'dipendenti.sql')
    ASSEGNAZIONETURNO = (2000, 'assegnazione_turno.sql')
    PRENOTAZIONI = (1000, 'prenotazioni.sql')
    FEEDBACK = (500, 'feedback.sql')
    ENTRATE = (1000, 'entrate.sql')
    OFFERTE = (200, 'offerte.sql')
    APPLICAOFFERTA = (1000, 'applica_offerta.sql')
    
    print('[LOG]: Inserimento clienti...')
    FILE = 'sql/inserts/' + CLIENTI[1]
    insert_users(CLIENTI[0], FILE)
    
    print('[LOG]: Inserimento carte di credito...')
    FILE = 'sql/inserts/' + CARTE[1]
    insert_carte_credito(CLIENTI[0], CARTE[0], FILE)

    print('[LOG]: Inserimento indirizzi di consegna...')
    FILE = 'sql/inserts/' + INDIRIZZI[1]
    insert_indirizzi_consegna(CLIENTI[0], INDIRIZZI[0], FILE)

    print('[LOG]: Inserimento spedizioni...')
    FILE = 'sql/inserts/' + SPEDIZIONI[1]
    insert_spedizioni(SPEDIZIONI[0], FILE)

    print('[LOG]: Inserimento ordini...')
    FILE = 'sql/inserts/' + ORDINI[1]
    insert_ordini(SPEDIZIONI[0], CLIENTI[0], ORDINI[0], FILE)

    print('[LOG]: Inserimento prodotti...')
    FILE = 'sql/inserts/' + PRODOTTI[1]
    insert_prodotti(PRODOTTI[0], FILE)

    print('[LOG]: Inserimento dettagli ordini...')
    FILE = 'sql/inserts/' + DETTAGLIORDINI[1]
    insert_dettagli_ordini(DETTAGLIORDINI[0], PRODOTTI[0], ORDINI[0], FILE)

    print('[LOG]: Inserimento turni...')
    FILE = 'sql/inserts/' + TURNI[1]
    insert_turni(TURNI[0], FILE)

    print('[LOG]: Inserimento zone...')
    FILE = 'sql/inserts/' + ZONE[1]
    insert_zona(ZONE[0], FILE)

    print('[LOG]: Inserimento negozi...')
    FILE = 'sql/inserts/' + NEGOZI[1]
    insert_negozi(NEGOZI[0], FILE, ZONE[0])

    print('[LOG]: Inserimento inventari...')
    FILE = 'sql/inserts/' + INVENTARI[1]
    insert_inventario(INVENTARI[0], NEGOZI[0], PRODOTTI[0], FILE)

    print('[LOG]: Inserimento dipendenti...')
    FILE = 'sql/inserts/' + DIPENDENTI[1]
    insert_dipendente(DIPENDENTI[0], RUOLI, NEGOZI[0], FILE)

    print('[LOG]: Inserimento assegnazione turni...')
    FILE = 'sql/inserts/' + ASSEGNAZIONETURNO[1]
    insert_assegnazione_turno(ASSEGNAZIONETURNO[0], DIPENDENTI[0], 541, FILE)

    print('[LOG]: Inserimento prenotazioni...')
    FILE = 'sql/inserts/' + PRENOTAZIONI[1]
    insert_prenotazione(PRENOTAZIONI[0], DIPENDENTI[0], CLIENTI[0], SERVIZI, FILE)

    print('[LOG]: Inserimento feedback...')
    FILE = 'sql/inserts/' + FEEDBACK[1]
    insert_feedback(FEEDBACK[0], CLIENTI[0], DIPENDENTI[0], FILE)

    print('[LOG]: Inserimento entrate...')
    FILE = 'sql/inserts/' + ENTRATE[1]
    insert_entrate(ENTRATE[0], NEGOZI[0], FILE)

    print('[LOG]: Inserimento offerte...')
    FILE = 'sql/inserts/' + OFFERTE[1]
    insert_offerte(OFFERTE[0], FILE)

    print('[LOG]: Inserimento applica offerta...')
    FILE = 'sql/inserts/' + APPLICAOFFERTA[1]
    insert_applica_offerta(APPLICAOFFERTA[0], FILE)
    
    print('[LOG]: Creazione file di inserimento finito!')
    
    
    