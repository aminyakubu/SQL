#Add a new schema called `weight`
CREATE SCHEMA weight;

#Write a statement that applies all subsequent code to the weighin schema
USE weight;

#Participants table and index
CREATE TABLE participants (
	PRIMARY KEY (participant_id),
    participant_id SMALLINT(5) UNSIGNED AUTO_INCREMENT,
    tx_group TINYINT(1) UNSIGNED,
    age TINYINT(2) UNSIGNED,
    height FLOAT(4,2) UNSIGNED,
    prediabetes TINYINT(1) UNSIGNED
);

CREATE INDEX tx_group
	ON participants(tx_group);
   
#Visits table and indexes
CREATE TABLE visits (
	PRIMARY KEY (visit_id),
    visit_id MEDIUMINT(7) UNSIGNED AUTO_INCREMENT,
    participant_id SMALLINT(5) UNSIGNED,
    visit_type TINYINT(1) UNSIGNED,
    weight FLOAT(5,2) UNSIGNED,
    FOREIGN KEY (participant_id) REFERENCES participants(participant_id) ON UPDATE CASCADE
);

CREATE INDEX visit_type
	ON visits(visit_type);
    
CREATE INDEX weight
	ON visits(weight);
    
#Adverse Events lookup table
CREATE TABLE adverse_events (
	PRIMARY KEY (adverse_event_id),
    adverse_event_id TINYINT(1) UNSIGNED AUTO_INCREMENT,
    adverse_event_type VARCHAR(255)
);

#Adverse Event Log table and indexes
CREATE TABLE adverse_event_log (
	PRIMARY KEY (event_log_id),
    event_log_id MEDIUMINT(7) UNSIGNED AUTO_INCREMENT,
    visit_id MEDIUMINT(7) UNSIGNED,
    adverse_event_id TINYINT(1) UNSIGNED,
    adverse_event_date DATE,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON UPDATE CASCADE,
    FOREIGN KEY (adverse_event_id) REFERENCES adverse_events(adverse_event_id) ON UPDATE CASCADE 
);

CREATE UNIQUE INDEX ae_unique
	ON adverse_event_log(visit_id, adverse_event_id, adverse_event_date);
    
CREATE INDEX adverse_event_id
	ON adverse_event_log(adverse_event_id);
    
CREATE INDEX adverse_event_date
	ON adverse_event_log(adverse_event_date);
    
#Medications lookup table
CREATE TABLE medications (
	PRIMARY KEY (medication_id),
    medication_id SMALLINT(5) UNSIGNED AUTO_INCREMENT,
    medication_name VARCHAR(255)
);

#Current Meds table and indexes
CREATE TABLE current_meds (
	PRIMARY KEY (current_med_id),
    current_med_id MEDIUMINT(7) UNSIGNED AUTO_INCREMENT,
    visit_id MEDIUMINT(7) UNSIGNED,
    medication_id SMALLINT(5) UNSIGNED,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON UPDATE CASCADE 
);

CREATE UNIQUE INDEX current_med_unique
	ON current_meds(visit_id, medication_id);
    
CREATE INDEX medication_id
	ON current_meds(medication_id);
    
#Diagnoses lookup table
CREATE TABLE diagnoses (
	PRIMARY KEY (diagnosis_code),
    diagnosis_code SMALLINT(5) UNSIGNED AUTO_INCREMENT,
    diagnosis_name VARCHAR(255)
);

#Current Diagnoses table and indexes
CREATE TABLE current_dxs (
	PRIMARY KEY (current_dx_id),
    current_dx_id MEDIUMINT(7) UNSIGNED AUTO_INCREMENT,
    visit_id MEDIUMINT(7) UNSIGNED,
    diagnosis_code SMALLINT(5) UNSIGNED,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON UPDATE CASCADE,
    FOREIGN KEY (diagnosis_code) REFERENCES diagnoses(diagnosis_code) ON UPDATE CASCADE 
);

CREATE UNIQUE INDEX current_dx_unique
	ON current_dxs(visit_id, diagnosis_code);
    
CREATE INDEX diagnosis_code
	ON current_dxs(diagnosis_code);
    