USE weight;

############
# TRIGGERS #
############

#Trigger for Participants Table
DELIMITER //

CREATE TRIGGER trigger_participants
	BEFORE INSERT ON participants
    FOR EACH ROW
BEGIN

	/*Limit tx_group to values of 1 or 2*/
	IF NEW.tx_group NOT IN (1,2) THEN
    SIGNAL SQLSTATE 'HY000'
    SET MESSAGE_TEXT = 'Please enter 1 or 2';
    END IF;
    
	/*Limit age range: 18 to 55*/
    IF NEW.age  NOT BETWEEN 18 AND 55 THEN
    SIGNAL SQLSTATE 'HY000'
    SET MESSAGE_TEXT = 'Age must be between 18 and 55';
    END IF;

	/*Limit prediabetes value to 0 or 1*/
	IF NEW.prediabetes NOT IN (0, 1) THEN
    SIGNAL SQLSTATE 'HY000'
    SET MESSAGE_TEXT = 'Please enter 0 and 1';
    END IF;
    
END//


#Trigger for adverse event log table
DELIMITER //

CREATE TRIGGER trigger_ae_log
	BEFORE INSERT ON adverse_event_log
    FOR EACH ROW
BEGIN

	/*Limit event_date to dates between 6/15/2017 and today*/
    IF NEW.adverse_event_date > CURDATE() OR NEW.adverse_event_date <  '2017-06-15' THEN
    SIGNAL SQLSTATE 'HY000'
    SET MESSAGE_TEXT =  'Invalid date: Please enter a date  between 6/15/2017 and today';
    END IF;

END//

##############
# DATA ENTRY #
##############

/****Data input ordered in a manner to avoid errors related to orphaned records****/

#Enter data into participants table

INSERT INTO participants (tx_group, age, height, prediabetes)
	VALUES
	(1, 46, 1.67, 0),
	(2, 54, 1.83, 0),
	(2, 49, 1.74, 1),
	(1, 47, 1.88, 0),
	(1, 39, 1.57, 1);

#Enter data into visits table
INSERT INTO visits (participant_id, visit_type, weight)
	VALUES
	(1, 0, 68.04),
	(2, 0, 91.63),
	(3, 0, 81.19),
	(1, 4, 65.77),
	(4, 0, 102.05),
	(2, 4, 92.08),
	(5, 0, 73.49),
	(1, 8, 64.86);

#Enter data into adverse_events table
INSERT INTO adverse_events (adverse_event_id, adverse_event_type)
	VALUES
	(1, 'Excessive fatigue'),
	(2, 'Reaction to medication'),
	(3, 'Abnormal lab results'),
	(4, 'Hospitalization'),
	(5, 'Skin rash'),
	(6, 'Other');
    
#Enter data into adverse_event_log table

INSERT INTO adverse_event_log(visit_id, adverse_event_id, adverse_event_date)
	VALUES
	(4, 3, '2017-08-29'),
	(5, 1, '2017-09-30'),
	(8, 3, '2017-11-12'); 
    
#Copy the data from medications_2 into the medications table

INSERT INTO medications (medication_id, medication_name)
	SELECT medication_id, medication_name
	FROM medications_2;

#Enter data into the current_meds table

INSERT INTO current_meds(visit_id, medication_id)
	VALUES
	(1, 6),
	(1, 7086),
	(2, 371),
	(3, 4241),
	(4, 6),
	(5, 3500),
	(6, 371),
	(7, 4241),
	(8, 6),
	(8, 7086); 

#Enter data into the diagnoses table

INSERT INTO diagnoses (diagnosis_code, diagnosis_name)
	VALUES
	(460, 'Acute nasopharyngitis (common cold)'),
	(461, 'Acute sinusitis'),
	(462, 'Acute pharyngitis'),
	(463, 'Acute tonsillitis'),
	(464,  'Acute laryngitis and tracheitis'),
	(465, 'Acute upper respiratory infections of multiple or unspecified sites'),
	(466, 'Acute bronchitis and bronchiolitis'),
	(470, 'Deviated nasal septum'),
	(471, 'Nasal polyps'),
	(472, 'Chronic pharyngitis and nasopharyngitis'),
	(473, 'Chronic sinusitis'),
	(474, 'Chronic disease of tonsils and adenoids'),
	(475, 'Peritonsillar abscess'),
	(476, 'Chronic laryngitis and laryngotracheitis'),
	(477, 'Allergic rhinitis'),
	(478, 'Other diseases of upper respiratory tract'),
	(510, 'Empyema'),
	(511, 'Pleurisy'),
	(512, 'Pneumothorax'),
	(513, 'Abscess of lung and mediastinum'),
	(514, 'Pulmonary congestion and hypostasis'),
	(515, 'Postinflammatory pulmonary fibrosis'); 

#Enter data into the current_dxs table
INSERT INTO current_dxs (visit_id, diagnosis_code)
	VALUES
	(1, 470),
	(1, 460),
	(1, 462),
	(3, 515),
	(3, 471),
	(4, 470),
	(4, 460),
	(7, 477),
	(8, 470),
	(8, 460);
     

#Drop the medications_2 table

DROP TABLE medications_2;

#########
# VIEWS #
#########

#weight_per_visit

CREATE VIEW weight_per_visit AS
	SELECT p.participant_id, visit_type, weight,
		CASE
			WHEN visit_type = 0 THEN 'Baseline'
            WHEN visit_type = 4 THEN 'Week 4'
            WHEN visit_type = 8 THEN 'Week 8'
            WHEN visit_type = 12 THEN 'Week 12'
            WHEN visit_type = 16 THEN 'Week 16'
            WHEN visit_type = 20 THEN 'Week 20'
			ELSE 'Check for mistakes'
		END AS visit_labels
    FROM participants AS p
    INNER JOIN visits AS v
		ON v.participant_id = p.participant_id
	ORDER BY participant_id, visit_type;
    
#meds_per_visit
CREATE VIEW meds_per_visit AS
	SELECT p.participant_id, visit_type, COUNT(cm.visit_id) AS number_of_unique_meds,
    	CASE
			WHEN visit_type = 0 THEN 'Baseline'
            WHEN visit_type = 4 THEN 'Week 4'
            WHEN visit_type = 8 THEN 'Week 8'
            WHEN visit_type = 12 THEN 'Week 12'
            WHEN visit_type = 16 THEN 'Week 16'
            WHEN visit_type = 20 THEN 'Week 20'
			ELSE 'Check for mistakes'
		END AS visit_labels
	FROM participants AS p
    LEFT JOIN visits AS v
		ON p.participant_id = v.participant_id
     LEFT JOIN current_meds AS cm
		ON cm.visit_id = v.visit_id
	GROUP BY p.participant_id, visit_type
	ORDER BY p.participant_id, number_of_unique_meds DESC;
    
#diagnosis_summary

CREATE VIEW diagnosis_summary AS
	SELECT diagnosis_name, cd.diagnosis_code, COUNT(cd.diagnosis_code) AS number_of_diagnosis
    FROM diagnoses AS d
    LEFT JOIN current_dxs AS cd
		ON d.diagnosis_code = cd.diagnosis_code
	GROUP BY diagnosis_name, cd.diagnosis_code
    ORDER BY number_of_diagnosis DESC;
		



















