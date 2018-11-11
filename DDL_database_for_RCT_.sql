#Add a new schema called `weight`



CREATE SCHEMA weight;

#Write a statement that applies all subsequent code to the weighin schema

USE weight;

/*CREATE THE FOLLOWING TABLES IN AN APPROPRIATE ORDER TO ALLOW CREATION OF FOREIGN KEYS IN THE CREATE TABLE STATEMENT.
  ADD THE RELEVANT SQL CODE TO CREATE EACH TABLE (AND INDEXES) UNDER EACH COMMENT*/

#Participants table and index

CREATE TABLE participants (
	PRIMARY KEY (participant_id),
    participant_id SMALLINT(5) UNSIGNED AUTO_INCREMENT NOT NULL,
    tx_group TINYINT(1) UNSIGNED,
    age TINYINT(2) UNSIGNED,
    height FLOAT (3, 2) UNSIGNED,
    prediabetes TINYINT(1) UNSIGNED
);

CREATE INDEX participant_index 
	ON participants(tx_group);

#Visits table and indexes

CREATE TABLE visits (
	PRIMARY KEY (visit_id),
    visit_id SMALLINT(5) UNSIGNED AUTO_INCREMENT NOT NULL,
    participant_id SMALLINT(5) UNSIGNED,
    visit_type CHAR,
    weight FLOAT(5, 2) UNSIGNED,
    FOREIGN KEY (participant_id) REFERENCES participants (participant_id)
);

CREATE INDEX visits_weight_index
	ON visits (weight);
    
CREATE INDEX visits_v_type_index
	ON visits(visit_type);
    
CREATE UNIQUE INDEX unique_index_pv
	ON visits(participant_id, visit_type);

#Adverse Events lookup table

CREATE TABLE adverse_events (
	PRIMARY KEY (adverse_event_id),
    adverse_event_id TINYINT(1) UNSIGNED AUTO_INCREMENT NOT NULL,
    adverse_event_type CHAR
);

#Adverse Event Log table and indexes

CREATE TABLE adverse_event_log (
	PRIMARY KEY (event_log_id),
    event_log_id TINYINT UNSIGNED AUTO_INCREMENT,
    visit_id SMALLINT(5) UNSIGNED,
    adverse_event_id TINYINT(1) UNSIGNED,
    event_date DATE,
    FOREIGN KEY (visit_id) REFERENCES visits (visit_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (adverse_event_id) REFERENCES adverse_events (adverse_event_id)
		ON UPDATE CASCADE
);

CREATE INDEX adel_index
	ON adverse_event_log(event_date, event_log_id);
    
CREATE UNIQUE INDEX adel_unique
	ON adverse_event_log(visit_id, event_log_id, event_date);

#Medications lookup table

CREATE TABLE medications (
	PRIMARY KEY (medication_id),
    medication_id SMALLINT(5) UNSIGNED AUTO_INCREMENT NOT NULL,
    medication_name CHAR(255)
);

#Current Meds table and indexes

CREATE TABLE current_meds (
	PRIMARY KEY (current_med_id),
    current_med_id SMALLINT(5) UNSIGNED AUTO_INCREMENT NOT NULL,
    visit_id SMALLINT(5) UNSIGNED,
    medication_id SMALLINT(5) UNSIGNED,
    FOREIGN KEY (visit_id) REFERENCES visits (visit_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (medication_id) REFERENCES medications (medication_id)
		ON UPDATE CASCADE
);

CREATE INDEX current_meds_med_index
	ON current_meds(medication_id);
    
CREATE INDEX current_meds_visit_index
	ON current_meds(visit_id);
    
CREATE UNIQUE INDEX current_meds_unique
	ON current_meds(medication_id, visit_id);
    
#Diagnoses lookup table

CREATE  TABLE diagnoses (
	PRIMARY KEY (diagnosis_code),
    diagnosis_code SMALLINT(5),
    diagnosis_name CHAR(255)
);

#Current Diagnoses table and indexes

CREATE TABLE current_dxs (
	PRIMARY KEY(current_dx_id),
    current_dx_id SMALLINT(4) UNSIGNED AUTO_INCREMENT NOT NULL,
    visit_id SMALLINT(5) UNSIGNED NOT NULL, 
    diagnosis_code SMALLINT(5),
    FOREIGN KEY (visit_id) REFERENCES visits (visit_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (diagnosis_code) REFERENCES diagnoses (diagnosis_code)
		ON UPDATE CASCADE
);

CREATE INDEX diagnosis_code_index
	ON current_dxs (diagnosis_code);
    
CREATE INDEX diagnosis_visit_index
	ON current_dxs (visit_id);   
    
CREATE UNIQUE INDEX current_dx_unique
	ON current_dxs (visit_id, diagnosis_code);

/*REMEMBER TO CREATE AND SUBMIT THE RESULTING EER DIAGRAM ONCE TABLES HAVE BEEN CREATED*/


    




    