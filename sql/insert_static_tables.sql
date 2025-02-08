-- 1. Insert delle tipologie dei ruoli
use Torverbarber;

INSERT INTO
    Ruolo (tipoRuolo, livelloStipendiale)
VALUES
    ('Receptionist', 1),
    ('Barbiere', 2),
    ('Manager', 3),
    ('Responasbile Di Zona', 3),
    ('CEO', 4);

INSERT INTO
    Servizio (nome, prezzo, durataMinuti, descrizione)
VALUES
    (
        'Taglio Classico',
        18.00,
        30,
        'Taglio tradizionale con forbici e macchinetta'
    ),
    (
        'Taglio Fade',
        20.00,
        35,
        'Sfumatura progressiva con macchinetta'
    ),
    (
        'Taglio Razor Fade',
        22.00,
        40,
        'Sfumatura a pelle con rasoio'
    ),
    (
        'Rifinitura Capelli',
        10.00,
        15,
        'Piccole correzioni e styling'
    ),
    (
        'Lavaggio & Styling',
        12.00,
        20,
        'Shampoo, asciugatura e modellatura con prodotti'
    ),
    (
        'Taglio Bambino',
        12.00,
        25,
        'Taglio per bambini sotto i 12 anni'
    ),
    (
        'Rasatura Completa',
        15.00,
        30,
        'Rasatura tradizionale con panno caldo e rasoio'
    ),
    (
        'Modellatura Barba',
        12.00,
        20,
        'Definizione della barba con rasoio e forbici'
    ),
    (
        'Trattamento Idratante Barba',
        10.00,
        15,
        'Massaggio con oli nutrienti per ammorbidire la barba'
    ),
    (
        'Tinta Barba',
        15.00,
        30,
        'Colorazione della barba per coprire capelli bianchi o uniformare il colore'
    ),
    (
        'Trattamento Viso Rilassante',
        18.00,
        25,
        'Pulizia del viso con massaggio e crema idratante'
    ),
    (
        'Scrub Viso Esfoliante',
        15.00,
        20,
        'Eliminazione delle impurità con scrub delicato'
    ),
    (
        'Maschera Nutriente',
        12.00,
        15,
        'Maschera rivitalizzante per la pelle'
    ),
    (
        'Trattamento Anticaduta',
        25.00,
        40,
        'Massaggio al cuoio capelluto con lozioni rinforzanti'
    ),
    (
        'Trattamento Idratante Capelli',
        20.00,
        30,
        'Applicazione di maschere e oli nutrienti'
    ),
    (
        'Permanente Uomo',
        35.00,
        90,
        'Effetto riccio o mosso per capelli'
    ),
    (
        'Decolorazione Capelli',
        40.00,
        90,
        'Schiaritura progressiva dei capelli'
    ),
    (
        'Luxury Shave Experience',
        30.00,
        45,
        'Rasatura premium con oli pre-barba e panno caldo'
    ),
    (
        'Full Barber Experience',
        50.00,
        90,
        'Taglio, barba, trattamento viso e styling personalizzato'
    ),
    (
        'Pacchetto Uomo Moderno',
        60.00,
        120,
        'Taglio + Barba + Trattamento Viso + Styling'
    ),
    (
        'Servizio Express',
        25.00,
        40,
        'Taglio e barba veloce per chi ha poco tempo'
    ),
    (
        'Taglio & Barba a Domicilio',
        70.00,
        90,
        'Servizio esclusivo a casa o in ufficio'
    );