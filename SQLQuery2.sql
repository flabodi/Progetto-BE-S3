ALTER TABLE ANAGRAFICA
ALTER COLUMN Cognome VARCHAR(50) NOT NULL;

ALTER TABLE ANAGRAFICA
ALTER COLUMN Nome VARCHAR(50) NOT NULL;

ALTER TABLE ANAGRAFICA
ALTER COLUMN Indirizzo VARCHAR(100) NOT NULL;

ALTER TABLE ANAGRAFICA
ALTER COLUMN Città VARCHAR(50) NOT NULL;

ALTER TABLE ANAGRAFICA
ALTER COLUMN CAP VARCHAR(10) NOT NULL;

ALTER TABLE ANAGRAFICA
ALTER COLUMN Cod_Fisc VARCHAR(16) NOT NULL;

ALTER TABLE TIPO_VIOLAZIONE
ALTER COLUMN descrizione VARCHAR(100) NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN idanagrafica INT NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN idviolazione INT NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN DataViolazione DATE NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN IndirizzoViolazione VARCHAR(100) NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN Nominativo_Agente VARCHAR(50) NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN DataTrascrizioneVerbale DATE NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN Importo DECIMAL(10,2) NOT NULL;

ALTER TABLE VERBALE
ALTER COLUMN DecurtamentoPunti INT NOT NULL;




CREATE TABLE ANAGRAFICA (
    idanagrafica INT PRIMARY KEY,
    Cognome      VARCHAR(50),
    Nome         VARCHAR(50),
    Indirizzo    VARCHAR(100),
    Città        VARCHAR(50),
    CAP          VARCHAR(10),
    Cod_Fisc     VARCHAR(16)
);

CREATE TABLE TIPO_VIOLAZIONE (
    idviolazione INT PRIMARY KEY,
    descrizione  VARCHAR(100)
);


CREATE TABLE VERBALE (
    idverbale               INT PRIMARY KEY,
    idanagrafica            INT,
    idviolazione            INT,
    DataViolazione          DATE,
    IndirizzoViolazione     VARCHAR(100),
    Nominativo_Agente       VARCHAR(50),
    DataTrascrizioneVerbale DATE,
    Importo                 DECIMAL(10,2),
    DecurtamentoPunti       INT,
    CONSTRAINT FK_VERBALE_ANAGRAFICA FOREIGN KEY (idanagrafica) REFERENCES ANAGRAFICA(idanagrafica),
    CONSTRAINT FK_VERBALE_TIPO_VIOLAZIONE FOREIGN KEY (idviolazione) REFERENCES TIPO_VIOLAZIONE(idviolazione)
);

INSERT INTO ANAGRAFICA (idanagrafica, Cognome, Nome, Indirizzo, Città, CAP, Cod_Fisc)
VALUES 
  (1, 'Rossi',  'Mario', 'Via Roma 1',      'Palermo', '90100', 'RSSMRA80A01H501A'),
  (2, 'Bianchi','Luigi', 'Corso Italia 10',   'Milano',  '20100', 'BNC LG80B02F205Z'),
  (3, 'Verdi',  'Anna',  'Via Roma 20',       'Palermo', '90100', 'VRDANN85C50H501B');


INSERT INTO TIPO_VIOLAZIONE (idviolazione, descrizione)
VALUES 
  (1, 'Eccesso di velocità'),
  (2, 'Parcheggio vietato'),
  (3, 'Mancato rispetto del semaforo');


INSERT INTO VERBALE (idverbale, idanagrafica, idviolazione, DataViolazione, IndirizzoViolazione, Nominativo_Agente, DataTrascrizioneVerbale, Importo, DecurtamentoPunti)
VALUES 
  (1, 1, 1, CONVERT(DATE, '15-03-2009', 105), 'Via dei Mille, Palermo', 'Agente Rossi',   CONVERT(DATE, '16-03-2009', 105), 500.00, 3),
  (2, 1, 2, CONVERT(DATE, '10-06-2009', 105), 'Via Libertà, Palermo',   'Agente Bianchi', CONVERT(DATE, '11-06-2009', 105), 450.00, 5),
  (3, 2, 1, CONVERT(DATE, '05-08-2009', 105), 'Piazza Verdi, Milano',     'Agente Verdi',   CONVERT(DATE, '06-08-2009', 105), 300.00, 2),
  (4, 3, 3, CONVERT(DATE, '20-04-2009', 105), 'Corso Vittorio, Palermo',  'Agente Neri',    CONVERT(DATE, '21-04-2009', 105), 600.00, 6);

SELECT COUNT(*) AS TotaleVerbali
FROM VERBALE;


SELECT A.Cognome, A.Nome, COUNT(V.idverbale) AS TotaleVerbali
FROM VERBALE V
JOIN ANAGRAFICA A ON V.idanagrafica = A.idanagrafica
GROUP BY A.Cognome, A.Nome;

SELECT TV.descrizione, COUNT(V.idverbale) AS TotaleVerbali
FROM VERBALE V
JOIN TIPO_VIOLAZIONE TV ON V.idviolazione = TV.idviolazione
GROUP BY TV.descrizione;

SELECT A.Cognome, A.Nome, SUM(V.DecurtamentoPunti) AS TotalePunti
FROM VERBALE V
JOIN ANAGRAFICA A ON V.idanagrafica = A.idanagrafica
GROUP BY A.Cognome, A.Nome;

SELECT A.Cognome, A.Nome, V.DataViolazione, V.IndirizzoViolazione, V.Importo, V.DecurtamentoPunti
FROM VERBALE V
JOIN ANAGRAFICA A ON V.idanagrafica = A.idanagrafica
WHERE A.Città = 'Palermo';

SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM VERBALE V
JOIN ANAGRAFICA A ON V.idanagrafica = A.idanagrafica
WHERE V.DataViolazione BETWEEN '2009-02-01' AND '2009-07-31';

SELECT A.Cognome, A.Nome, SUM(V.Importo) AS TotaleImporto
FROM VERBALE V
JOIN ANAGRAFICA A ON V.idanagrafica = A.idanagrafica
GROUP BY A.Cognome, A.Nome;

SELECT *
FROM ANAGRAFICA
WHERE Città = 'Palermo';

SELECT DataViolazione, Importo, DecurtamentoPunti
FROM VERBALE
WHERE DataViolazione = '2009-03-15';

SELECT Nominativo_Agente, COUNT(*) AS TotaleViolazioni
FROM VERBALE
GROUP BY Nominativo_Agente;

SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM VERBALE V
JOIN ANAGRAFICA A ON V.idanagrafica = A.idanagrafica
WHERE V.DecurtamentoPunti > 5;

SELECT A.Cognome, A.Nome, A.Indirizzo, V.DataViolazione, V.Importo, V.DecurtamentoPunti
FROM VERBALE V
JOIN ANAGRAFICA A ON V.idanagrafica = A.idanagrafica
WHERE V.Importo > 400;

SELECT Nominativo_Agente, 
       COUNT(idverbale) AS NumeroVerbali, 
       SUM(Importo) AS TotaleImporti
FROM VERBALE
GROUP BY Nominativo_Agente;

SELECT TV.descrizione, 
       AVG(V.Importo) AS MediaImporti
FROM VERBALE V
JOIN TIPO_VIOLAZIONE TV ON V.idviolazione = TV.idviolazione
GROUP BY TV.descrizione;
