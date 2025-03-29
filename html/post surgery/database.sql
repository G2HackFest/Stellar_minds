-- POST-SURGERY RECOVERY TRACKER DATABASE
-- Complete SQL implementation including schema, sample data, and queries

-- 1. DATABASE CREATION
DROP DATABASE IF EXISTS PostSurgeryRecovery;
CREATE DATABASE PostSurgeryRecovery;
USE PostSurgeryRecovery;

-- 2. TABLES CREATION

-- Users table (for authentication)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('patient', 'surgeon') NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Patients table (extends Users)
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    blood_type VARCHAR(5),
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Users(user_id)
);

-- Surgeons table (extends Users)
CREATE TABLE Surgeons (
    surgeon_id INT PRIMARY KEY,
    specialty VARCHAR(100),
    license_number VARCHAR(50),
    hospital_affiliation VARCHAR(100),
    FOREIGN KEY (surgeon_id) REFERENCES Users(user_id)
);

-- Surgery types
CREATE TABLE SurgeryTypes (
    surgery_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    typical_recovery_time VARCHAR(50)
);

-- Patient surgeries
CREATE TABLE PatientSurgeries (
    surgery_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    surgeon_id INT NOT NULL,
    surgery_type_id INT NOT NULL,
    surgery_date DATE NOT NULL,
    hospital_name VARCHAR(100),
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (surgeon_id) REFERENCES Surgeons(surgeon_id),
    FOREIGN KEY (surgery_type_id) REFERENCES SurgeryTypes(surgery_type_id)
);

-- Care tips
CREATE TABLE CareTips (
    tip_id INT PRIMARY KEY AUTO_INCREMENT,
    surgery_type_id INT NOT NULL,
    tip_text TEXT NOT NULL,
    days_post_op INT,
    importance_level INT DEFAULT 1,
    FOREIGN KEY (surgery_type_id) REFERENCES SurgeryTypes(surgery_type_id)
);

-- Milestones
CREATE TABLE Milestones (
    milestone_id INT PRIMARY KEY AUTO_INCREMENT,
    surgery_type_id INT NOT NULL,
    milestone_name VARCHAR(100) NOT NULL,
    description TEXT,
    typical_completion_day INT,
    FOREIGN KEY (surgery_type_id) REFERENCES SurgeryTypes(surgery_type_id)
);

-- Patient progress
CREATE TABLE PatientProgress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    surgery_id INT NOT NULL,
    milestone_id INT NOT NULL,
    completed BOOLEAN DEFAULT FALSE,
    completion_date DATE,
    notes TEXT,
    FOREIGN KEY (surgery_id) REFERENCES PatientSurgeries(surgery_id),
    FOREIGN KEY (milestone_id) REFERENCES Milestones(milestone_id),
    UNIQUE KEY (surgery_id, milestone_id)
);

-- Messages
CREATE TABLE Messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_id INT NOT NULL,
    recipient_id INT NOT NULL,
    surgery_id INT NOT NULL,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipient_id) REFERENCES Users(user_id),
    FOREIGN KEY (surgery_id) REFERENCES PatientSurgeries(surgery_id)
);

-- Patient-Surgeon relationships
CREATE TABLE PatientSurgeonRelationships (
    relationship_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    surgeon_id INT NOT NULL,
    is_primary BOOLEAN DEFAULT TRUE,
    relationship_start DATE,
    relationship_end DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (surgeon_id) REFERENCES Surgeons(surgeon_id),
    UNIQUE KEY (patient_id, surgeon_id)
);

-- 3. SAMPLE DATA INSERTION

-- Insert sample users (password hashes are placeholders - use proper hashing in production)
INSERT INTO Users (username, password_hash, user_type, full_name, email, phone) VALUES
('Ganesh', 'ganesh1', 'patient', 'M.Lakshmi Siva Ganesh', 'ganesh@example.com', '1234567890'),
('Rupesh', 'rupesh2', 'patient', 'T.Venkata Rupesh', 'rupesh@example.com', '1234567890'),
('Bhanu', 'bhanu3', 'patient','Chaithanya Bhanu', 'bhanu@example.com', '1234567890'),
('Tejagna', 'tejagna4', 'patient', 'Tejagna', 'teja@example.com', '1234567890'),
('dr_smith', 'smith5', 'surgeon', 'Dr. Robert Smith', 'dr.smith@example.com', '3456789012'),
('dr_jones', 'jones6', 'surgeon', 'Dr. Sarah Jones', 'dr.jones@example.com', '4567890123');

-- Insert patient details
INSERT INTO Patients (patient_id, date_of_birth, gender, blood_type, emergency_contact, emergency_phone) VALUES
(1, '1980-05-15', 'male', 'A+', 'Mary Doe', '1112223333'),
(2, '1975-08-22', 'female', 'B-', 'Mike Smith', '2223334444');

-- Insert surgeon details
INSERT INTO Surgeons (surgeon_id, specialty, license_number, hospital_affiliation) VALUES
(3, 'Orthopedic Surgery', 'MD123456', 'City General Hospital'),
(4, 'Cardiothoracic Surgery', 'MD654321', 'Metropolitan Medical Center');

-- Insert surgery types
INSERT INTO SurgeryTypes (name, description, typical_recovery_time) VALUES
('Knee Surgery', 'Various knee surgical procedures', '6-12 weeks'),
('Heart Surgery', 'Cardiac surgical procedures', '6-8 weeks'),
('Shoulder Surgery', 'Shoulder repair procedures', '4-6 months'),
('Spinal Surgery', 'Spinal cord procedures', '3-6 months');

-- Insert patient-surgeon relationships
INSERT INTO PatientSurgeonRelationships (patient_id, surgeon_id, is_primary, relationship_start) VALUES
(1, 3, TRUE, '2023-01-10'),
(2, 4, TRUE, '2023-02-15');

-- Insert patient surgeries
INSERT INTO PatientSurgeries (patient_id, surgeon_id, surgery_type_id, surgery_date, hospital_name, notes) VALUES
(1, 3, 1, '2023-03-01', 'City General Hospital', 'Successful ACL reconstruction'),
(2, 4, 2, '2023-03-15', 'Metropolitan Medical Center', 'Coronary artery bypass grafting');

-- Insert care tips
INSERT INTO CareTips (surgery_type_id, tip_text, days_post_op, importance_level) VALUES
-- Knee surgery tips
(1, 'Use ice pack for 20 minutes every 2 hours', 0, 1),
(1, 'Keep leg elevated when sitting', 0, 1),
(1, 'Start physical therapy exercises after 3 days', 3, 2),
(1, 'Avoid strenuous activities for first 2 weeks', 14, 2),
-- Heart surgery tips
(2, 'Take blood thinners as prescribed', 0, 1),
(2, 'Watch for redness, swelling, pus, fever at incision site', 0, 1),
(2, 'Use prescribed pain relievers as needed', 0, 1),
(2, 'Follow antibiotic prescriptions exactly', 0, 1),
-- Shoulder surgery tips
(3, 'Wear sling for first week', 0, 1),
(3, 'Perform pendulum exercises daily', 2, 2),
(3, 'Avoid lifting heavy objects', 0, 1),
-- Spinal surgery tips
(4, 'Follow post-operative care guidelines strictly', 0, 1),
(4, 'Gradually increase activity under medical supervision', 7, 2),
(4, 'Maintain a healthy weight to reduce spine stress', 0, 1),
(4, 'Engage in prescribed physical therapy to improve mobility', 14, 2);

-- Insert milestones
INSERT INTO Milestones (surgery_type_id, milestone_name, description, typical_completion_day) VALUES
-- Knee surgery milestones
(1, 'Pain Management', 'Able to manage pain with prescribed medication', 3),
(1, 'First Physical Therapy Session', 'Completed initial PT evaluation', 7),
(1, 'Full Weight Bearing', 'Able to bear full weight on operated leg', 21),
(1, 'Range of Motion Achieved', 'Regained full range of motion', 56),
-- Heart surgery milestones
(2, 'Incision Healing', 'Surgical incision shows no signs of infection', 7),
(2, 'Normal Heart Rhythm', 'No arrhythmias detected', 14),
(2, 'Increased Activity Tolerance', 'Able to walk short distances without fatigue', 21),
(2, 'Full Recovery', 'Cleared for normal activities', 56),
-- Shoulder surgery milestones
(3, 'Sling Removal', 'Doctor approved removal of shoulder sling', 7),
(3, 'Passive Motion Exercises', 'Began passive range of motion exercises', 14),
(3, 'Active Motion Exercises', 'Began active range of motion exercises', 28),
(3, 'Full Strength Regained', 'Regained full shoulder strength', 120),
-- Spinal surgery milestones
(4, 'Pain Control', 'Able to manage pain with prescribed medication', 3),
(4, 'Mobility Improvement', 'Able to walk with assistance', 7),
(4, 'Independent Movement', 'Able to move without assistance', 14),
(4, 'Full Functionality', 'Regained full range of motion and strength', 90);

-- Insert some progress data
INSERT INTO PatientProgress (surgery_id, milestone_id, completed, completion_date) VALUES
(1, 1, TRUE, '2023-03-04'),
(1, 2, TRUE, '2023-03-08'),
(2, 5, TRUE, '2023-03-22'),
(2, 6, TRUE, '2023-03-29');

-- Insert some sample messages
INSERT INTO Messages (sender_id, recipient_id, surgery_id, message_text, sent_at) VALUES
(1, 3, 1, 'Dr. Smith, I have some swelling in my knee. Is this normal?', '2023-03-05 09:15:00'),
(3, 1, 1, 'Some swelling is normal. Keep it elevated and ice it as we discussed.', '2023-03-05 11:30:00'),
(2, 4, 2, 'When can I resume my exercise routine?', '2023-03-20 14:45:00'),
(4, 2, 2, 'Let\'s discuss at your follow-up next week. For now, just light walking.', '2023-03-20 16:20:00');

-- 4. KEY QUERIES FOR APPLICATION INTEGRATION

-- User authentication query
DELIMITER //
CREATE PROCEDURE AuthenticateUser(IN p_username VARCHAR(50), IN p_password VARCHAR(255))
BEGIN
    SELECT user_id, username, user_type, full_name 
    FROM Users 
    WHERE username = p_username AND password_hash = p_password;
END //
DELIMITER ;

-- Get patient's surgeries
DELIMITER //
CREATE PROCEDURE GetPatientSurgeries(IN p_patient_id INT)
BEGIN
    SELECT ps.surgery_id, st.name AS surgery_type, ps.surgery_date,
           CONCAT(u.full_name) AS surgeon_name, ps.hospital_name
    FROM PatientSurgeries ps
    JOIN SurgeryTypes st ON ps.surgery_type_id = st.surgery_type_id
    JOIN Users u ON ps.surgeon_id = u.user_id
    WHERE ps.patient_id = p_patient_id
    ORDER BY ps.surgery_date DESC;
END //
DELIMITER ;

-- Get care tips for surgery type
DELIMITER //
CREATE PROCEDURE GetCareTips(IN p_surgery_type_id INT)
BEGIN
    SELECT tip_text, days_post_op, importance_level
    FROM CareTips 
    WHERE surgery_type_id = p_surgery_type_id 
    ORDER BY days_post_op ASC, importance_level DESC;
END //
DELIMITER ;

-- Get milestones for a patient's surgery
DELIMITER //
CREATE PROCEDURE GetSurgeryMilestones(IN p_surgery_id INT)
BEGIN
    SELECT m.milestone_id, m.milestone_name, m.description, 
           m.typical_completion_day, pp.completed, pp.completion_date
    FROM Milestones m
    JOIN SurgeryTypes st ON m.surgery_type_id = st.surgery_type_id
    JOIN PatientSurgeries ps ON st.surgery_type_id = ps.surgery_type_id
    LEFT JOIN PatientProgress pp ON m.milestone_id = pp.milestone_id 
                               AND pp.surgery_id = p_surgery_id
    WHERE ps.surgery_id = p_surgery_id
    ORDER BY m.typical_completion_day ASC;
END //
DELIMITER ;

-- Update milestone completion status
DELIMITER //
CREATE PROCEDURE UpdateMilestoneStatus(
    IN p_surgery_id INT,
    IN p_milestone_id INT,
    IN p_completed BOOLEAN
)
BEGIN
    INSERT INTO PatientProgress (surgery_id, milestone_id, completed, completion_date)
    VALUES (p_surgery_id, p_milestone_id, p_completed, IF(p_completed, CURRENT_DATE, NULL))
    ON DUPLICATE KEY UPDATE 
        completed = VALUES(completed), 
        completion_date = VALUES(completion_date);
END //
DELIMITER ;

-- Get messages between users for a specific surgery
DELIMITER //
CREATE PROCEDURE GetSurgeryMessages(
    IN p_surgery_id INT,
    IN p_user1_id INT,
    IN p_user2_id INT
)
BEGIN
    SELECT m.message_id, 
           u.user_id AS sender_id,
           u.username AS sender_name,
           u.user_type AS sender_type,
           m.message_text, 
           m.sent_at,
           m.read_at
    FROM Messages m
    JOIN Users u ON m.sender_id = u.user_id
    WHERE m.surgery_id = p_surgery_id
    AND ((m.sender_id = p_user1_id AND m.recipient_id = p_user2_id) OR 
         (m.sender_id = p_user2_id AND m.recipient_id = p_user1_id))
    ORDER BY m.sent_at ASC;
END //
DELIMITER ;

-- Send a new message
DELIMITER //
CREATE PROCEDURE SendMessage(
    IN p_sender_id INT,
    IN p_recipient_id INT,
    IN p_surgery_id INT,
    IN p_message_text TEXT
)
BEGIN
    INSERT INTO Messages (sender_id, recipient_id, surgery_id, message_text)
    VALUES (p_sender_id, p_recipient_id, p_surgery_id, p_message_text);
END //
DELIMITER ;

-- Mark message as read
DELIMITER //
CREATE PROCEDURE MarkMessageAsRead(IN p_message_id INT)
BEGIN
    UPDATE Messages 
    SET read_at = CURRENT_TIMESTAMP
    WHERE message_id = p_message_id;
END //
DELIMITER ;

-- Calculate recovery progress percentage
DELIMITER //
CREATE PROCEDURE CalculateRecoveryProgress(IN p_surgery_id INT)
BEGIN
    DECLARE total_milestones INT;
    DECLARE completed_milestones INT;
    
    SELECT COUNT(*) INTO total_milestones
    FROM Milestones m
    JOIN PatientSurgeries ps ON m.surgery_type_id = ps.surgery_type_id
    WHERE ps.surgery_id = p_surgery_id;
    
    SELECT COUNT(*) INTO completed_milestones
    FROM PatientProgress
    WHERE surgery_id = p_surgery_id AND completed = TRUE;
    
    IF total_milestones > 0 THEN
        SELECT ROUND((completed_milestones / total_milestones) * 100) AS progress_percentage;
    ELSE
        SELECT 0 AS progress_percentage;
    END IF;
END //
DELIMITER ;