
#QUESTION 1 - LARGEST WEIGHT CHANGE BETWEEN TWO CONSECUTIVE VISITS
USE weight;

### SELF JOIN

SELECT a.participant_id, a.visit_type, a.weight, b.visit_type, b.weight, (b.weight - a.weight) AS diff
FROM visits AS a
	INNER JOIN visits AS b
    USING (participant_id)
WHERE b.visit_type > a.visit_type AND (b.visit_type - a.visit_type) = 4
ORDER BY diff;




#############################################
# DATA BELOW FOR THE NEXT QUERY ###
#############################################

CREATE SCHEMA clinics;

USE clinics;

CREATE TABLE clinics (
	clinic_id VARCHAR(6), 
    location_cat VARCHAR(8)
);

INSERT INTO clinics 
	VALUES
	('ABC','rural'),
	('DEFG','suburban'),
	('HIJKL','urban'),
	('MNOPQR','suburban'),
	('STUV','rural'),
	('WXYZA','rural'),
	('BCDEF','urban'),
	('GHIJK','suburban'),
	('LMN',	'suburban'),
	('OPQ',	'rural'),
    ('RSTNLE', 'urban');

CREATE TABLE participants (
	partic_id TINYINT(3), 
	clinic_id VARCHAR(6)
);

INSERT INTO participants
VALUES
('70','ABC'),
('46','HIJKL'),
('15','MNOPQR'),
('6','STUV'),
('6','STUV'),
('82','STUV'),
('9','DEFG'),
('52','WXYZA'),
('29','STUV'),
('3','GHIJK'),
('60','LMN'),
('88','DEFG'),
('1','HIJKL'),
('69','HIJKL'),
('59','STUV'),
('36','WXYZA'),
('24','ABC'),
('67','MNOPQR'),
('71','HIJKL'),
('19','STUV'),
('34','LMN'),
('25','LMN'),
('45','OPQ'),
('49','HIJKL'),
('31','LMN'),
('13','DEFG'),
('83','WXYZA'),
('18','WXYZA'),
('73','WXYZA'),
('22','STUV'),
('61','OPQ'),
('90','GHIJK'),
('78','MNOPQR'),
('80','LMN'),
('91','ABC'),
('33','HIJKL'),
('16','OPQ'),
('14','WXYZA'),
('77','WXYZA'),
('50','WXYZA'),
('32','WXYZA'),
('54','RSTUVW'),
('97','ABC'),
('99','DEFG'),
('55','STUV'),
('7','OPQ'),
('66','GHIJK'),
('96','HIJKL'),
('44','RSTUVW'),
('10','MNOPQR'),
('98','STUV'),
('11','GHIJK'),
('40','STUV'),
('2','HIJKL'),
('47','MNOPQR'),
('26','LMN'),
('95','OPQ'),
('68','OPQ'),
('76','OPQ'),
('94','MNOPQR'),
('35','RSTUVW'),
('62','RSTUVW'),
('17','HIJKL'),
('4','GHIJK'),
('30','GHIJK'),
('39','OPQ'),
('89','LMN'),
('87','HIJKL'),
('57','HIJKL'),
('74','MNOPQR'),
('85','HIJKL'),
('100','STUV'),
('53','STUV'),
('43','HIJKL'),
('92','ABC'),
('56','GHIJK'),
('58','LMN'),
('23','OPQ'),
('64','LMN'),
('75','LMN'),
('79','MNOPQR'),
('8','DEFG'),
('84','DEFG'),
('37','DEFG'),
('5','RSTUVW'),
('86','HIJKL'),
('28','GHIJK'),
('48','LMN'),
('27','WXYZA'),
('12','STUV'),
('63','DEFG'),
('20','STUV'),
('81','STUV'),
('38','ABC'),
('72','OPQ'),
('21','WXYZA'),
('42', NULL),
('51','HIJKL'),
('41','LMN'),
('95','OPQ'),
('93','DEFG');

###############################################

# FULL JOIN IN MySQL
SELECT c.clinic_id, c.location_cat, p.clinic_id, p.partic_id
FROM clinics AS c
	LEFT JOIN participants AS p
	USING (clinic_id)
WHERE (c.clinic_id IS NULL AND p.clinic_id IS NOT NULL) OR (c.clinic_id IS NOT NULL AND p.clinic_id IS NULL)

UNION

SELECT c.clinic_id, c.location_cat, p.clinic_id, p.partic_id
FROM clinics AS c
	RIGHT JOIN participants AS p
	USING (clinic_id)
WHERE (c.clinic_id IS NULL AND p.clinic_id IS NOT NULL) OR (c.clinic_id IS NOT NULL AND p.clinic_id IS NULL);


#####################################
# DATA BELOW FOR NEXT QUERY#
#####################################

CREATE SCHEMA class;

USE class;

CREATE TABLE ta (
	ta_name VARCHAR(8)
);

INSERT INTO ta
	VALUES
    ('Anu'),
    ('Lynette'),
    ('Sarah');

CREATE TABLE student (
	student_name VARCHAR(15)
);

INSERT INTO student
	VALUES
    ('Amin'),
    ('Chianti'),
    ('Dandi'),
    ('Di'),
    ('Ditian'),
    ('Gaeun'),
    ('Jacky'),
    ('Jason'),
    ('Josie'),
    ('Kathryn'),
    ('Katie'),
    ('Manali'),
    ('Mengqi'),
    ('Morgan'),
    ('Nadiya'),
    ('Peter'),
    ('Rebecca'),
    ('Sha'),
    ('Shichen'),
    ('Stephanie'),
    ('Sunny'),
    ('Volha'),
    ('Xin'),
    ('Yeyi'),
    ('Yutian');

#CROSS JOINS
SELECT ta_name, student_name
FROM ta 
	CROSS JOIN student
WHERE 
	(ta_name = 'Anu' AND student_name REGEXP '^[A-G]') OR
    (ta_name = 'Lynette' AND student_name REGEXP '^[H-N]') OR
    (ta_name = 'Sarah' AND student_name REGEXP '^[O-Z]')
ORDER BY ta_name, student_name;