
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--PROGRAMME (IA/IB/CS): CS
--GROUP NUMBER e.g. G01: G08
--GROUP LEADER NAME & EMAIL: TAN JING JIE   tanjingjie@1utar.my
--MEMBER 2 NAME: JACYNTH THAM MING QUAN
--MEMBER 3 NAME: TAN WEI MUN
--MEMBER 4 NAME: YAP JHENG KHIN
--Submission date and time (DD-MON-YY): 27-MAR-21

--GROUP ASSIGNMENT SUBMISSION
--Submit one individual report with partial/full output screenshot (*.docx)
--and one sql script (*.sql for oracle 11g)

--Template save as "G??_group_script.sql"  e.g. G01_group_script.sql
--Part 1 script only.
--Refer to the format of Northwoods.sql as an example for group sql script submission

--Your GROUP member information should appear in both files one individual report docx & one individual sql script, then save as UCCD2203_Assignment_CS_G01.zip

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------
--                           Welcome to Hospital Database                       --
----------------------------------------------------------------------------------
--Jacynth Tham Ming Quan 1801600
--Tan Jing Jie 1804560
--Tan Wei Mun 1803705
--Yap Jheng Khin 1800224

--------------------------------------------------------------------------
--The sequence of creating tables
--------------------------------------------------------------------------
--Person, Room, MedicalEquipment, ServiceList, Department
--Employee, Patient, Bed
--Nurse, Doctor, Admission
--Bill, ServiceRecord
--Prescription

--------------------------------------------------------------------------
--Set Display
--------------------------------------------------------------------------
SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 20000
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100
SET ECHO OFF 

--------------------------------------------------------------------------
--Drop Tables
--------------------------------------------------------------------------
DROP TABLE disease CASCADE CONSTRAINTS;
DROP TABLE prescription CASCADE CONSTRAINTS;
DROP TABLE bill CASCADE CONSTRAINTS;
DROP TABLE servicerecord CASCADE CONSTRAINTS;
DROP TABLE admission CASCADE CONSTRAINTS;
DROP TABLE bed CASCADE CONSTRAINTS;
DROP TABLE person CASCADE CONSTRAINTS;
DROP TABLE patient CASCADE CONSTRAINTS;
DROP TABLE employee CASCADE CONSTRAINTS;
DROP TABLE nurse CASCADE CONSTRAINTS;
DROP TABLE doctor CASCADE CONSTRAINTS;
DROP TABLE department CASCADE CONSTRAINTS;
DROP TABLE medicalequipment CASCADE CONSTRAINTS;
DROP TABLE room CASCADE CONSTRAINTS;
DROP TABLE servicelist CASCADE CONSTRAINTS;

DROP USER yapjhengkhin CASCADE;
DROP USER jacynththam CASCADE;
DROP USER tanjingjie CASCADE;
DROP USER tanweimun CASCADE;

DROP USER dodefarre CASCADE;
DROP USER janesilverstone CASCADE;
DROP USER loriannebrak CASCADE;
DROP USER nolliepynn CASCADE;
DROP USER kayfedoronko CASCADE;
DROP USER erwin CASCADE;

DROP ROLE admin;
DROP ROLE nurse;
DROP ROLE doctor;
----------------------------------------------------------------------
--CREATE TABLE (Refer to top for adding sequence)
----------------------------------------------------------------------

--Person
CREATE TABLE person 
(
	person_id VARCHAR2(6),
	first_name VARCHAR2(15) CONSTRAINT person_first_name_nn NOT NULL,
	last_name VARCHAR2(15) CONSTRAINT person_last_name_nn NOT NULL,
	gender VARCHAR2(1) CONSTRAINT person_gender_nn NOT NULL,
	birth_date DATE CONSTRAINT person_birth_date_nn NOT NULL,
	email VARCHAR2(30),
	phone_number VARCHAR2(15) CONSTRAINT person_phone_number_nn NOT NULL,
	address_line VARCHAR2(50),
	address_zip_code VARCHAR2(5),
	address_state VARCHAR2(25),
	blood_type VARCHAR2(2),
	rh_type CHAR(1),
	vaccination_eligibility CHAR(1) CONSTRAINT person_vaccination_eligible_nn NOT NULL,
	vaccination_status CHAR(1) CONSTRAINT person_vaccination_status_nn NOT NULL,
	CONSTRAINT person_person_id_pk PRIMARY KEY (person_id),
	CONSTRAINT person_email_uq UNIQUE (email),
	CONSTRAINT person_person_id_check CHECK(REGEXP_LIKE(person_id,'^P\d{5}$')),
	CONSTRAINT person_gender_check CHECK(gender IN ('M', 'F', 'O')),
	CONSTRAINT person_address_zip_code_check CHECK(LENGTH(address_zip_code) = 5),
	CONSTRAINT person_blood_type_check CHECK(blood_type IN ('A', 'B', 'O','AB')),
	CONSTRAINT person_RH_type_check CHECK(rh_type IN ('+', '-')),
	CONSTRAINT person_vaccination_eligible_ck CHECK(vaccination_eligibility IN ('y', 'n')),
	CONSTRAINT person_vaccination_status_ck CHECK(vaccination_status IN ('y', 'n'))
);

--Room
CREATE TABLE room
(
	room_id VARCHAR2(4),
	room_name VARCHAR2(30) CONSTRAINT room_room_name_nn NOT NULL,
	type VARCHAR2(30) CONSTRAINT room_type_nn NOT NULL,
	location VARCHAR2(30) CONSTRAINT room_location_nn NOT NULL,
	price NUMERIC(10, 2) CONSTRAINT room_price_nn NOT NULL,
	CONSTRAINT room_room_id_pk PRIMARY KEY (room_id),
	CONSTRAINT room_room_name_uq UNIQUE (room_name),
	CONSTRAINT room_room_id_check CHECK(REGEXP_LIKE(room_id,'^R\d{3}$'))
);

--Disease
CREATE TABLE disease
(
        disease_id VARCHAR2(6),
        name VARCHAR(20) CONSTRAINT disease_name_nn NOT NULL,
        symptom VARCHAR(75) CONSTRAINT disease_symptom_nn NOT NULL,
        cause VARCHAR(50) CONSTRAINT disease_cause_nn NOT NULL,
        cure VARCHAR(50) CONSTRAINT disease_cure_nn NOT NULL,
        CONSTRAINT disease_disease_id_pk PRIMARY KEY (disease_id),
        CONSTRAINT disease_disease_id_check CHECK(REGEXP_LIKE(disease_id,'^G\d{5}$'))
);

--MedicalEquipment
CREATE TABLE medicalequipment
(
	medicalequipment_id VARCHAR2(6),
	name VARCHAR2(30) CONSTRAINT medicalequipment_name_nn NOT NULL,
	type VARCHAR2(25) CONSTRAINT medicalequipment_type_nn NOT NULL,
	description VARCHAR2(50) CONSTRAINT medicalequipment_desc_nn NOT NULL,
	expiration_date DATE,
	unit_price Number(10,2) CONSTRAINT medicalequipment_unit_price_nn NOT NULL,
	stock_quantity Integer CONSTRAINT medicalequipment_quantity_nn NOT NULL,
	CONSTRAINT medicalequipment_type_check CHECK(type IN ('medicine', 'organ_a', 'organ_b', 'organ_o', 'organ_ab', 'blood_bag_a', 'blood_bag_b', 'blood_bag_o', 'blood_bag_ab', 'vaccine_astra_zeneca','vaccine_pfizer_biontech','vaccine_sinovac','vaccine_cansino_biologics','vaccine_sputnik_v')),
	CONSTRAINT medicalequipment_id_pk PRIMARY KEY (medicalequipment_id),
	CONSTRAINT med_med_id_check CHECK(REGEXP_LIKE(medicalequipment_id,'^M\d{5}$'))
);

--ServiceList
CREATE TABLE servicelist
(
	service_id Varchar2(6),
	name Varchar2(30) CONSTRAINT service_list_name_nn NOT NULL,
	description VARCHAR2(50) CONSTRAINT service_list_description_nn NOT NULL,
	price Number(10,2) CONSTRAINT service_list_price_nn NOT NULL,
	CONSTRAINT service_list_service_id_pk PRIMARY KEY (service_id),
	CONSTRAINT service_list_id_check CHECK(REGEXP_LIKE(service_id,'^L\d{5}$'))
);

--Department
CREATE TABLE department
(
	department_id VARCHAR2(6),
	name VARCHAR2(25) CONSTRAINT department_name_nn NOT NULL,
	description VARCHAR2(150) CONSTRAINT department_description_nn NOT NULL,
	head VARCHAR2(6),
	CONSTRAINT department_department_id_pk PRIMARY KEY (department_id),
	CONSTRAINT department_name_uq UNIQUE (name),
	CONSTRAINT department_head_uq UNIQUE (head),
	CONSTRAINT department_id_check CHECK(REGEXP_LIKE(department_id,'^D\d{5}$'))
);

--Employee
CREATE TABLE employee
(
	employee_id VARCHAR2(6),
	salary NUMBER(9, 2),
	hire_date DATE CONSTRAINT employee_hire_date NOT NULL,
	leave_date DATE,
	manager_id VARCHAR2(6),
	department_id VARCHAR2(6),
	CONSTRAINT employee_employee_id_fk FOREIGN KEY (employee_id) REFERENCES person(person_id),
	CONSTRAINT employee_employee_id_pk PRIMARY KEY (employee_id),
	CONSTRAINT employee_manager_id_fk FOREIGN KEY (manager_id) REFERENCES employee(employee_id),
	CONSTRAINT employee_department_id_fk FOREIGN KEY (department_id) REFERENCES department(department_id),
	CONSTRAINT employee_salary_check CHECK(salary > 0)
);
ALTER TABLE employee
MODIFY hire_date DEFAULT sysdate;

ALTER TABLE department
ADD CONSTRAINT department_head_fk 
FOREIGN KEY (head) REFERENCES employee(employee_id);

--hire date default constraint not set yet
--CONSTRAINT employee_hire_date_df DEFAULT sysdate

--Patient
CREATE TABLE patient
(
	patient_id VARCHAR2(6),
	death_date TIMESTAMP,
	CONSTRAINT patient_patient_id_fk FOREIGN KEY (patient_id) REFERENCES person(person_id),
	CONSTRAINT patient_patient_id_pk PRIMARY KEY (patient_id)
);

--Bed
CREATE TABLE bed
(
	bed_id VARCHAR2(4) CONSTRAINT bed_bed_id_nn NOT NULL,
	room_id VARCHAR2(4) CONSTRAINT bed_room_id_nn NOT NULL,
	CONSTRAINT bed_bed_id_pk PRIMARY KEY (bed_id),
	CONSTRAINT bed_room_id_fk FOREIGN KEY (room_id) REFERENCES room(room_id),
	CONSTRAINT bed_bed_id_check CHECK(REGEXP_LIKE(bed_id,'^B\d{3}$'))
);

--Nurse
CREATE TABLE nurse 
(
	nurse_id VARCHAR2(6),
	speciality VARCHAR2(30) CONSTRAINT nurse_speciality_nn NOT NULL,
	CONSTRAINT nurse_nurse_id_fk FOREIGN KEY (nurse_id) REFERENCES employee(employee_id),
	CONSTRAINT nurse_nurse_id_pk PRIMARY KEY (nurse_id)
);

--Doctor
CREATE TABLE doctor 
(
	doctor_id VARCHAR2(6),
	qualification VARCHAR2(20) CONSTRAINT doctor_qualification_nn NOT NULL,
	expertise VARCHAR2(30),
	CONSTRAINT doctor_doctor_id_fk FOREIGN KEY (doctor_id) REFERENCES employee(employee_id),
	CONSTRAINT doctor_doctor_id_pk PRIMARY KEY (doctor_id)
);


--Admission
CREATE TABLE admission
(
	admission_id VARCHAR2(6),
	patient_id VARCHAR2(6) CONSTRAINT admission_patient_id_nn NOT NULL,
	employee_id VARCHAR2(6) CONSTRAINT admission_employee_id_nn NOT NULL,
	admission_date TIMESTAMP CONSTRAINT admission_admission_date_nn NOT NULL,
	discharge_date TIMESTAMP,
	bed_id VARCHAR2(4),
	status VARCHAR2(1)CONSTRAINT admission_admission_status_nn NOT NULL,
	summary VARCHAR(100),
	CONSTRAINT admission_admission_id_pk PRIMARY KEY (admission_id),
	CONSTRAINT admission_bed_id_fk FOREIGN KEY (bed_id) REFERENCES bed(bed_id),
	CONSTRAINT admission_employee_id_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
	CONSTRAINT admission_patient_id_fk FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
	CONSTRAINT admission_id_check CHECK(REGEXP_LIKE(admission_id,'^A\d{5}$')),
	CONSTRAINT admission_status_check CHECK(status IN('R','I','D','O'))
);


ALTER TABLE admission
MODIFY admission_date DEFAULT sysdate;
--default value for admission date sysdate

--Bill
CREATE TABLE bill
(
	bill_id VARCHAR2(6),
	admission_id VARCHAR2(6) CONSTRAINT bill_admission_id_nn NOT NULL,
	description VARCHAR2(50) CONSTRAINT bill_description_nn NOT NULL,
	method VARCHAR2(20),
	due_date DATE CONSTRAINT bill_due_date_nn NOT NULL,
	amount NUMBER(10, 2) CONSTRAINT bill_amount_nn NOT NULL,
	payment_date TIMESTAMP,
	CONSTRAINT bill_bill_id_pk PRIMARY KEY (bill_id),
	CONSTRAINT bill_admission_id_fk FOREIGN KEY (admission_id) REFERENCES admission(admission_id),
	CONSTRAINT bill_id_check CHECK(REGEXP_LIKE(bill_id,'^I\d{5}$'))
);


--ServiceRecord
CREATE TABLE servicerecord
(
	service_record_id VARCHAR2(6), 
	admission_id VARCHAR2(6),
	doctor_id VARCHAR2(6),
	nurse_id VARCHAR2(6),
	room_id VARCHAR2(4),
	service_id VARCHAR2(6),
        disease_id VARCHAR2(6),
	summary VARCHAR2(60),
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	CONSTRAINT service_record_id_pk PRIMARY KEY (service_record_id),
	CONSTRAINT admission_id_fk FOREIGN KEY (admission_id) REFERENCES admission(admission_id),
	CONSTRAINT doctor_id_fk FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id),
	CONSTRAINT nurse_id_fk FOREIGN KEY (nurse_id) REFERENCES nurse(nurse_id),
	CONSTRAINT room_id_fk FOREIGN KEY (room_id) REFERENCES room(room_id),
	CONSTRAINT service_id_fk FOREIGN KEY (service_id) REFERENCES servicelist(service_id),
        CONSTRAINT disease_id_fk FOREIGN KEY (disease_id) REFERENCES disease(disease_id),
	CONSTRAINT service_rec_id_check CHECK(REGEXP_LIKE(service_record_id,'^S\d{5}$'))
);

ALTER TABLE servicerecord
MODIFY start_time DEFAULT sysdate;
--start date default sysdate

--Prescription
CREATE TABLE prescription
(
	service_record_id VARCHAR2(6),
	medicalequipment_id VARCHAR2(6),
	quantity INTEGER CONSTRAINT prescription_quantity_nn NOT NULL,
	unit_price NUMBER(10,2) CONSTRAINT prescription_unit_price_nn NOT NULL,
	CONSTRAINT Prescription_pk PRIMARY KEY (service_record_id,medicalequipment_id),
	CONSTRAINT service_record_id_fk FOREIGN KEY (service_record_id) REFERENCES servicerecord(service_record_id),
	CONSTRAINT medicalequipment_id_fk FOREIGN KEY (medicalequipment_id) REFERENCES medicalequipment(medicalequipment_id)
);

----------------------------------------------------------------------
--Insert Record
----------------------------------------------------------------------
-- Disease

INSERT INTO disease(disease_id, name, symptom, cause, cure)
VALUES ('G00001', 'COVID-19', 'Fever, Dry cough, Loss of taste or smell, Nasal congestion', 'SARS-CoV-2', 'Dexamethasone');

INSERT INTO disease(disease_id, name, symptom, cause, cure)
VALUES ('G00002', 'Cancer', 'Cough, hoarseness, Anemia, Bleeding, Bruising, Weight change', 'Gene mutation', 'Chemotherapy, Immunotherapy, Gene therapy');

INSERT INTO disease(disease_id, name, symptom, cause, cure)
VALUES ('G00003', 'Dengue fever', 'Headache, Muscle, bone, joint pain, nausea, Vomiting, Rash', 'Dengue virus', 'Acetaminophen');

INSERT INTO disease(disease_id, name, symptom, cause, cure)
VALUES ('G00004', 'Heart disease', 'Chest pain, Chest tightness, Shortness of breath', 'Smoking, Diabetes, Stress', 'Mechanical assist device, Heart transplant');

INSERT INTO disease(disease_id, name, symptom, cause, cure)
VALUES ('G00005', 'AIDS', 'Swollen lymph nodes, Tuberculosis, Bacterial infections', 'HIV, STI, unsafe tissue transplantation', 'Antiretroviral treatment');

--Department
		
INSERT INTO department(department_id, name, description) VALUES ('D00001', 'Diagnostic Imaging', 'A place to conduct X-Ray and radiology.');

INSERT INTO department(department_id, name, description) VALUES ('D00002', 'Intensive Care Unit (ICU)', 'A special department of a hospital or health care facility that provides intensive treatment medicalequipment.');

INSERT INTO department(department_id, name, description) VALUES ('D00003', 'General Surgery', 'A place to conduct  a wide range of types of surgery and procedures on patients.');

INSERT INTO department(department_id, name, description) VALUES ('D00004', 'Admission', 'A place to collect patient''s information and sign consent forms before being taken to the hospital unit or ward');

INSERT INTO department(department_id, name, description) VALUES ('D00005', 'Finance', 'A place in hospitals and other health care facilities that performs sterilization and other actions on medical equipment, devices, and consumables.');

INSERT INTO department(department_id, name, description) VALUES ('D00006', 'Nursing', 'A place to provide comprehensive, safe, effective and well-organized nursing care through the personnel of the department.');

INSERT INTO department(department_id, name, description) VALUES ('D00007', 'Research', 'Doing bio research');

--Person related and its inheritance (Patient, Employee -->Nurse, Doctor)
------------------------------------------------------------------------------------------------------
-- Insert patient a.k.a person
-- P00001 P00002 P00003 P00004 P00005
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- Insert employee a.k.a person
-- P00006 P00007 P00008 P00009 P00010 P00011 P00012
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- Insert nurse a.k.a employee a.k.a person
-- P00013 P00014 P00015 P00016 P00017 P00018 P00019
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
-- Insert doctor a.k.a employee a.k.a person
-- P00020 P00021 P00022 P00023 P00024 P00025 P00026
------------------------------------------------------------------------------------------------------

--Patient -- P00001 P00002 P00003 P00004 P00005
INSERT INTO person
VALUES ('P00001', 
        'Jheng Khin', 
        'Yap', 
        'M', 
        TO_DATE('1966/11/20', 'yyyy/mm/dd'), 
        'polarbearyap2@gmail.com', 
        '+60164220081', 
        '31 Jln Sibu 16 Taman Wahyu Shah Alam', 
        '66663', 
        'Selangor',
        null,
        null,
        'y',
        'n');
        
INSERT INTO person
VALUES ('P00002', 
        'Haryati', 
        'Izzati', 
        'F', 
        TO_DATE('1987/12/02', 'yyyy/mm/dd'), 
        'jasonlim2@gmail.com', 
        '+60161811344', 
        '16 Jln Zabedah 83000 Batu Pahat Johor Bahru', 
        '83000', 
        'Johor',
        'B',
        '-',
        'y',
        'n');
        
INSERT INTO person
VALUES ('P00003', 
        'Kevin', 
        'Owens', 
        'M', 
        TO_DATE('2000/10/31', 'yyyy/mm/dd'), 
        'kevin_owens@gmail.com', 
        '+6016151517', 
        '2 1 Jln Haji Yaakub Kampung Air Kota Kinabalu', 
        '88000', 
        'Sabah',
        'A',
        '+',
        'n',
        'n');

INSERT INTO person
VALUES ('P00004', 
        'Merry', 
        'Yeung', 
        'F', 
        TO_DATE('1995/07/07', 'yyyy/mm/dd'), 
        'merry_yeung@gmail.com', 
        '+60164227373', 
        'No. 74 Stadium Sultan Jln Mahmood Kota Bahru', 
        '15200', 
        'Kelantan',
        'O',
        '+',
        'y',
        'y');
        
INSERT INTO person
VALUES ('P00005', 
        'Puspa', 
        'Sangkara', 
        'F', 
        TO_DATE('1979/05/31', 'yyyy/mm/dd'), 
        'Puspa_sangkara@gmail.com', 
        '+60164220081', 
        '1064 1 Jln Bintang Jaya 1 Bintang Jaya Kuching', 
        '98000', 
        'Sarawak',
        'AB',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00027', 
        'LEE', 
        'Bruce', 
        'M', 
        TO_DATE('1955/06/06', 'yyyy/mm/dd'), 
        'LEEBRUSE@gmail.com', 
        '+66666666', 
        '28216 Sunbrook Court Kuantan', 
        '39001', 
        'Kuala Lumpur',
        'A',
        '-',
        'n',
        'n');

INSERT INTO person
VALUES ('P00028', 
        'Zaria', 
        'Altham', 
        'M', 
        TO_DATE('1978/12/16', 'yyyy/mm/dd'), 
        'zaltham0@gmail.com', 
        '+5504876057', 
        '245 Maryland Drive Kota Bahru', 
        '15744', 
        'Kelantan',
        'AB',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00029', 
        'Umberto', 
        'Pinnington', 
        'F', 
        TO_DATE('1967/09/07', 'yyyy/mm/dd'), 
        'upinnington4@gmail.com', 
        '+1843838225', 
        '64 Sommers Circle Ipoh', 
        '98000', 
        'Perak',
        'O',
        '+',
        'n',
        'n');

INSERT INTO person
VALUES ('P00030', 
        'Ardella', 
        'Rickett', 
        'F', 
        TO_DATE('1955/06/06', 'yyyy/mm/dd'), 
        'arickett8@gmail.com', 
        '+4811556120', 
        '71 Lakewood Parkway Johor Bahru', 
        '83000', 
        'Johor',
        'O',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00031', 
        'Upton', 
        'Tipler', 
        'M', 
        TO_DATE('1988/04/13', 'yyyy/mm/dd'), 
        'utipler9@gmail.com', 
        '+9335446705', 
        '6 Dryden Court Kuala Lumpur', 
        '39001', 
        'Wilayah Persekutuan',
        'B',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00032', 
        'Rickey', 
        'Liles', 
        'M', 
        TO_DATE('2000/01/12', 'yyyy/mm/dd'), 
        'rliles7@gmail.com', 
        '+2666996833', 
        '28216 Sunbrook Court Johor Bahru', 
        '83000', 
        'Johor',
        'AB',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00033', 
        'Izak', 
        'Siviour', 
        'M', 
        TO_DATE('1985/05/08', 'yyyy/mm/dd'), 
        'isiviour1@gmail.com', 
        '+1129652205', 
        '39 Nevada Way Kuantan', 
        '02224', 
        'Pahang',
        'AB',
        '-',
        'y',
        'n');

INSERT INTO patient VALUES ('P00001', null);

INSERT INTO patient VALUES ('P00002', null);

INSERT INTO patient VALUES ('P00003', null);

INSERT INTO patient VALUES ('P00004', null);

INSERT INTO patient VALUES ('P00005', null);

INSERT INTO patient VALUES ('P00027', TO_TIMESTAMP ('22-Mar-02 03:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO patient VALUES ('P00028', null);

INSERT INTO patient VALUES ('P00029', TO_TIMESTAMP ('27-Feb-21 03:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO patient VALUES ('P00030', null);

INSERT INTO patient VALUES ('P00031', null);

INSERT INTO patient VALUES ('P00032', null);

INSERT INTO patient VALUES ('P00033', null);

--Employee  -- P00006 P00007 P00008 P00009 P00010 P00011 P00012
INSERT INTO person
VALUES ('P00006', 
        'Dode', 
        'Farre', 
        'M', 
        TO_DATE('1978/01/16', 'yyyy/mm/dd'), 
        'dfarre0@gmail.com', 
        '+3887808052', 
        '84636 Cody Plaza Kuala Lumpur', 
        '58000', 
        'Wilayah Persekutuan',
        'O',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00007', 
        'Jane', 
        'Silverstone', 
        'F', 
        TO_DATE('1974/03/04', 'yyyy/mm/dd'), 
        'jsilverstone4@gmail.com', 
        '+4572423572', 
        '38611 Clyde Gallagher Court Klang', 
        '42100', 
        'Selangor',
        'A',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00008', 
        'Lorianne', 
        'Braksper', 
        'F', 
        TO_DATE('1963/11/11', 'yyyy/mm/dd'), 
        'lbrakspere@gmail.com', 
        '+4069022734', 
        '3 Claremont Avenue Kuantan', 
        '02224', 
        'Pahang',
        'B',
        '+',
        'y',
        'y');

INSERT INTO person
VALUES ('P00009', 
        'Annie', 
        'Leonhart', 
        'M', 
        TO_DATE('1963/11/11', 'yyyy/mm/dd'), 
        'annie_op@gmail.com', 
        '+3701441224', 
        '02662 Prentice Road Kota Bahru', 
        '15744', 
        'Kelantan',
        'A',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00010', 
        'Edith', 
        'Wearn', 
        'M', 
        TO_DATE('1983/04/07', 'yyyy/mm/dd'), 
        'ewearnc@gmail.com', 
        '+5935448404', 
        '871 Buena Vista Drive Johor Bahru', 
        '86555', 
        'Johor',
        'AB',
        '+',
        'y',
        'y');

INSERT INTO person
VALUES ('P00011', 
        'Teena', 
        'Swindles', 
        'F', 
        TO_DATE('1994/10/28', 'yyyy/mm/dd'), 
        'tswindles2@gmail.com', 
        '+1794873794', 
        '8889 Ryan Pass Melaka', 
        '77999', 
        'Melaka',
        'A',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00012', 
        'Hange', 
        'Zoe', 
        'M', 
        TO_DATE('1994/04/01', 'yyyy/mm/dd'), 
        'love_titans@gmail.com', 
        '+60164220081', 
        '8095 Lake View Trail Ipoh', 
        '98000', 
        'Perak',
        'AB',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00034', 
        'Han', 
        'Park', 
        'M', 
        TO_DATE('1994/04/01', 'yyyy/mm/dd'), 
        'han_parks@gmail.com', 
        '+60164220089', 
        '8095 Lake View Trail Ipoh', 
        '98000', 
        'Perak',
        'AB',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00035', 
        'Rosie', 
        'Park', 
        'M', 
        TO_DATE('1997/04/01', 'yyyy/mm/dd'), 
        'bp_love@gmail.com', 
        '+60168820081', 
        '8095 Lake View Trail Ipoh', 
        '98000', 
        'Korea',
        'AB',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00036', 
        'Lisa', 
        'Monaban', 
        'M', 
        TO_DATE('1997/07/01', 'yyyy/mm/dd'), 
        'dancingQueen@gmail.com', 
        '+60168820555', 
        '8095 Lake View Trail Ipoh', 
        '98000', 
        'Bangkok',
        'AB',
        '+',
        'y',
        'n');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00006', 5800.90, TO_DATE('2011/07/14', 'yyyy/mm/dd'), TO_DATE('2016/12/31', 'yyyy/mm/dd'), null, 'D00004');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00007', 4800.78, TO_DATE('2012/09/30', 'yyyy/mm/dd'), TO_DATE('2014/09/20', 'yyyy/mm/dd'), null, 'D00005');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00008', 6000.90, TO_DATE('2016/10/10', 'yyyy/mm/dd'), null, null, 'D00004');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00009', 5000.78, TO_DATE('2014/01/27', 'yyyy/mm/dd'), null, null, 'D00005');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00010', 4000.67, TO_DATE('2018/04/29', 'yyyy/mm/dd'), null, 'P00008', 'D00004');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00011', 3450.17, TO_DATE('2019/06/01', 'yyyy/mm/dd'), null, 'P00009', 'D00005');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00012', 3400.56, TO_DATE('2020/09/17', 'yyyy/mm/dd'), null, 'P00009', 'D00005');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00034', 3405.56, TO_DATE('2015/09/17', 'yyyy/mm/dd'), null, null, null);

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00035', 3777.56, TO_DATE('2017/09/17', 'yyyy/mm/dd'), null, null, null);

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00036', 3956.56, TO_DATE('2016/09/17', 'yyyy/mm/dd'), null, null, null);

INSERT INTO patient VALUES ('P00008', null);

INSERT INTO patient VALUES ('P00009', null);

INSERT INTO patient VALUES ('P00010', null);

--Nurse -- P00013 P00014 P00015 P00016 P00017 P00018 P00019
INSERT INTO person
VALUES ('P00013', 
        'Nollie', 
        'Pynn', 
        'F', 
        TO_DATE('2007/11/08', 'yyyy/mm/dd'), 
        'npynn8@gmail.com', 
        '+4032782762', 
        '93671 Kensington Park Teluk Intan', 
        '36000', 
        'Perak',
        'AB',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00014', 
        'Steve', 
        'Mityashev', 
        'F', 
        TO_DATE('2004/07/08', 'yyyy/mm/dd'), 
        'smityashev5@gmail.com', 
        '+5124796213', 
        '2621 Bellgrove Crossing Sungai Buloh', 
        '47000', 
        'Selangor',
        'O',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00015', 
        'Constancia', 
        'Ready', 
        'F', 
        TO_DATE('2002/05/14', 'yyyy/mm/dd'), 
        'creadya@gmail.com', 
        '+4069022734', 
        '4 Mifflin Hill Kuantan', 
        '02344', 
        'Pahang',
        'A',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00016', 
        'Kay', 
        'Fedoronko', 
        'M', 
        TO_DATE('2004/02/22', 'yyyy/mm/dd'), 
        'kfedoronkod@gmail.com', 
        '+3701441224', 
        '41180 Shoshone Way Kota Bahru', 
        '15774', 
        'Kelantan',
        'O',
        '+',
        'y',
        'y');

INSERT INTO person
VALUES ('P00017', 
        'Maggi', 
        'Nairn', 
        'F', 
        TO_DATE('1990/06/18', 'yyyy/mm/dd'), 
        'maggi@gmail.com', 
        '+9464871353', 
        '31 Delaware Drive George Town', 
        '14250', 
        'Pulau Penang',
        'AB',
        '+',
        'y',
        'y');

INSERT INTO person
VALUES ('P00018', 
        'Genni', 
        'Rhys', 
        'F', 
        TO_DATE('1994/10/28', 'yyyy/mm/dd'), 
        'glettington0@gmail.com', 
        '+1794873794', 
        '8889 Ryan Pass Melaka', 
        '77999', 
        'Melaka',
        'O',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00019', 
        'Berkie', 
        'Damrell', 
        'M', 
        TO_DATE('2010/12/13', 'yyyy/mm/dd'), 
        'bdamrelld@gmail.com', 
        '+5935448404', 
        '02846 Kinsman Park Johor Bahru', 
        '86741', 
        'Johor',
        'AB',
        '+',
        'n',
        'n');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00013', 7000.90, TO_DATE('2000/12/11', 'yyyy/mm/dd'), TO_DATE('2001/01/30', 'yyyy/mm/dd'), null, 'D00006');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00014', 6800.78, TO_DATE('2000/12/11', 'yyyy/mm/dd'), TO_DATE('2005/11/18', 'yyyy/mm/dd'), 'P00013', 'D00006');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00015', 7000.90, TO_DATE('2000/12/11', 'yyyy/mm/dd'), null, null, 'D00006');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00016', 6800.78, TO_DATE('2005/02/17', 'yyyy/mm/dd'), null, 'P00015', 'D00006');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00017', 5500.67, TO_DATE('2009/12/04', 'yyyy/mm/dd'), null, 'P00015', 'D00006');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00018', 5400.17, TO_DATE('2012/08/01', 'yyyy/mm/dd'), null, 'P00015', 'D00006');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00019', 5400.56, TO_DATE('2019/07/31', 'yyyy/mm/dd'), null, 'P00015', 'D00006');

INSERT INTO nurse(nurse_id, speciality)
VALUES ('P00013', 'Dermatology');

INSERT INTO nurse(nurse_id, speciality)
VALUES ('P00014', 'Developmental Disability');

INSERT INTO nurse(nurse_id, speciality)
VALUES ('P00015', 'Pediatrics');

INSERT INTO nurse(nurse_id, speciality)
VALUES ('P00016', 'ICU');

INSERT INTO nurse(nurse_id, speciality)
VALUES ('P00017', 'Surgery');

INSERT INTO nurse(nurse_id, speciality)
VALUES ('P00018', 'Psychology');

INSERT INTO nurse(nurse_id, speciality)
VALUES ('P00019', 'Cardiology');

INSERT INTO patient VALUES ('P00016', null);

INSERT INTO patient VALUES ('P00017', null);

--Doctor -- P00020 P00021 P00022 P00023 P00024 P00025
INSERT INTO person
VALUES ('P00020', 
        'Tan', 
        'Jing Jie', 
        'M', 
        TO_DATE('2000/08/17', 'yyyy/mm/dd'),
        '2000tanjingjie@gmail.com', 
        '+8973723278', 
        '96089 Cody Junction Kuala Lumpur', 
        '50300', 
        'Wilayah Persekutuan',
        'AB',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00021', 
        'Sasha', 
        'Braus', 
        'F', 
        TO_DATE('2000/10/30', 'yyyy/mm/dd'),
        'sasha_rip@gmail.com', 
        '+4069022734', 
        '666 Mid Valley Alor Setar', 
        '02224', 
        'Kedah',
        'AB',
        '-',
        'y',
        'n');

INSERT INTO person
VALUES ('P00022', 
        'Eren', 
        'Yeager', 
        'M', 
        TO_DATE('1987/10/12', 'yyyy/mm/dd'), 
        'eren_yeager@gmail.com', 
        '+3701441224', 
        '94 Mandrake Alley Kuching Kota Bahru', 
        '15744', 
        'Kelantan',
        'AB',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00023', 
        'Mikasa', 
        'Ackerman', 
        'F', 
        TO_DATE('1987/10/18', 'yyyy/mm/dd'), 
        'mikasa_ackerman@gmail.com', 
        '+5935448404', 
        '871 Buena Vista Drive Johor Bahru', 
        '86555', 
        'Johor',
        'B',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00024', 
        'Erwin', 
        'Smith', 
        'M', 
        TO_DATE('1994/07/11', 'yyyy/mm/dd'), 
        'erwin@gmail.com', 
        '+4483545904', 
        '871 Buena Vista Drive Johor Bahru', 
        '86555', 
        'Johor',
        'A',
        '+',
        'y',
        'n');

INSERT INTO person
VALUES ('P00025', 
        'Zeke', 
        'Yeager', 
        'M', 
        TO_DATE('1977/12/10', 'yyyy/mm/dd'), 
        'monke@gmail.com',
        '+1794873794', 
        '4444 Monkey Island Kuching', 
        '77999', 
        'Sarawak',
        'O',
        '+',
        'y',
        'y');

INSERT INTO person
VALUES ('P00026', 
        'Reiner', 
        'Braun', 
        'M', 
        TO_DATE('1966/06/06', 'yyyy/mm/dd'), 
        'reiner_cant_die@gmail.com', 
        '+3667452666', 
        '28216 Sunbrook Court Kuantan', 
        '39001', 
        'Pahang',
        'AB',
        '-',
        'n',
        'n');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00020', 11000.00, TO_DATE('2010/03/11', 'yyyy/mm/dd'), TO_DATE('2013/12/10', 'yyyy/mm/dd'), null, 'D00001');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00021', 12345.89, TO_DATE('2013/09/10', 'yyyy/mm/dd'), null, null, 'D00001');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00022', 9539.78, TO_DATE('2014/04/25', 'yyyy/mm/dd'), null, null, 'D00002');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00023', 9807.67, TO_DATE('2018/01/11', 'yyyy/mm/dd'), null, null, 'D00003');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00024', 8400.56, TO_DATE('2019/08/13', 'yyyy/mm/dd'), null, 'P00021', 'D00001');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00025', 8831.71, TO_DATE('2020/07/28', 'yyyy/mm/dd'), null, 'P00022', 'D00002');

INSERT INTO employee(employee_id, salary, hire_date, leave_date, manager_id, department_id)
VALUES('P00026', 7871.12, TO_DATE('2021/02/20', 'yyyy/mm/dd'), null, 'P00023', 'D00003');

INSERT INTO doctor(doctor_id, qualification, expertise)
VALUES('P00020', 'MCh', 'Internal medicalequipment');

INSERT INTO doctor(doctor_id, qualification, expertise)
VALUES('P00021', 'MMSc', 'Allergy and immunology');

INSERT INTO doctor(doctor_id, qualification, expertise)
VALUES('P00022', 'DSurg', 'Anesthesiology');

INSERT INTO doctor(doctor_id, qualification, expertise)
VALUES('P00023', 'MCh', 'Dermatology');

INSERT INTO doctor(doctor_id, qualification, expertise)
VALUES('P00024', 'MBBS', 'Diagnostic radiology');

INSERT INTO doctor(doctor_id, qualification, expertise)
VALUES('P00025', 'MMed', 'Pathology');

INSERT INTO doctor(doctor_id, qualification, expertise)
VALUES('P00026', 'MPhil', 'Preventive medicalequipment');

INSERT INTO patient VALUES ('P00025', null);

--Department manager
UPDATE department SET head='P00025'
WHERE department_id='D00003';

UPDATE department SET head='P00019'
WHERE department_id='D00006';

UPDATE department SET head='P00016'
WHERE department_id='D00002';

UPDATE department SET head='P00015'
WHERE department_id='D00004';

UPDATE department SET head='P00024'
WHERE department_id='D00001';

--Room
INSERT INTO room VALUES
('R001', 'Kid''s Ward', 'Patient Ward', 'West Wing L2', 300);

INSERT INTO room VALUES
('R002', 'General Ward 1', 'Patient Ward', 'West Wing L2', 500);

INSERT INTO room VALUES
('R003', 'Operation Theatre 1', 'Operation', 'East Wing L1', 1000);

INSERT INTO room VALUES
('R004', 'Operation Theatre 2', 'Operation', 'East Wing L1', 1500);

INSERT INTO room VALUES
('R005', 'Consultation Room 1', 'Consultation', 'West Wing LG', 150);

INSERT INTO room VALUES
('R006', 'Lab', 'Consultation', 'West Wing LG', 30);

INSERT INTO room VALUES
('R007', 'CT room', 'CT Scan, X-ray', 'West Wing LG', 50);

INSERT INTO room VALUES
('R008', 'General Ward 2', 'Patient Ward', 'West Wing L2', 500);

INSERT INTO room VALUES
('R009', 'General Ward 3', 'Patient Ward', 'West Wing L3', 500);

INSERT INTO room VALUES
('R010', 'General Ward 4', 'Patient Ward', 'West Wing L3', 500);

INSERT INTO room VALUES
('R011', 'General Ward 5', 'Patient Ward', 'West Wing L3', 500);

INSERT INTO room VALUES
('R012', 'General Ward 6', 'Patient Ward', 'West Wing L4', 500);

INSERT INTO room VALUES
('R013', 'General Ward 7', 'Patient Ward', 'West Wing L4', 500);

INSERT INTO room VALUES
('R014', 'General Ward 8', 'Patient Ward', 'West Wing L4', 500);

INSERT INTO room VALUES
('R015', 'General Ward 9', 'Patient Ward', 'West Wing L4', 500);

INSERT INTO room VALUES
('R016', 'General Ward 10', 'Patient Ward', 'West Wing L4', 500);

INSERT INTO room VALUES
('R017', 'General Ward 11', 'Patient Ward', 'West Wing L4', 500);

INSERT INTO room VALUES
('R018', 'Vaccination Room 1', 'Vaccination Room', 'East Wing L2', 0);

INSERT INTO room VALUES
('R019', 'Vaccination Room 2', 'Vaccination Room', 'East Wing L2', 0);

INSERT INTO room VALUES
('R020', 'General Ward 12', 'Patient Ward', 'West Wing L4', 0);

--MedicalEquipment
INSERT INTO medicalequipment VALUES
('M00001','Paracetamol 500mg','medicine','Cure fever',TO_DATE('2022/01/01', 'yyyy/mm/dd'),1.50,50);

INSERT INTO medicalequipment VALUES
('M00002','Paracetamol 1000mg','medicine','Cure fever',TO_DATE('2023/12/31', 'yyyy/mm/dd'),2.50,50);

INSERT INTO medicalequipment VALUES
('M00003','Aspirin 500mg','medicine','Acetylsalicylic acid, reduce pain',TO_DATE('2021/07/08', 'yyyy/mm/dd'),3.10,51);

INSERT INTO medicalequipment VALUES
('M00004','Aspirin 1000mg','medicine','Acetylsalicylic reduce pane',TO_DATE('2028/03/01', 'yyyy/mm/dd'),4.20,170);

INSERT INTO medicalequipment VALUES
('M00005','Ibuprofen 400mg','medicine','Treating pain, fever, and inflammation',TO_DATE('2026/02/22', 'yyyy/mm/dd'),3.50,200);

INSERT INTO medicalequipment VALUES
('M00006','Ibuprofen 1000mg','medicine','Treating pain, fever, and inflammation',TO_DATE('2022/08/28', 'yyyy/mm/dd'),4.00,40);

INSERT INTO medicalequipment VALUES
('M00007','Antibiotics 1000mg','medicine','Stop infections',TO_DATE('2027/04/19', 'yyyy/mm/dd'),5.00,9);

INSERT INTO medicalequipment VALUES
('M00008','Anti diarrhea pills 300mg','medicine','Treating severe diarrhea',TO_DATE('2025/09/30', 'yyyy/mm/dd'),2.00,66);

INSERT INTO medicalequipment VALUES
('M00009','Antibiotics 1500mg','medicine','Stop infections',TO_DATE('2028/04/19', 'yyyy/mm/dd'),7.00,4);

INSERT INTO medicalequipment VALUES
('M00010','Heart','organ_a','Donated by deceased patient, Encik Hassan', TO_DATE('2021/09/30', 'yyyy/mm/dd'), 119000.00, 1);

INSERT INTO medicalequipment VALUES
('M00011','Intestine','organ_a','Donated by Katijah binti Johan',TO_DATE('2021/05/01', 'yyyy/mm/dd'), 2519.00, 1);

INSERT INTO medicalequipment VALUES
('M00012','Liver','organ_ab','Donated by Rabinder Govindasamy a/l Marimuthu',TO_DATE('2021/07/19', 'yyyy/mm/dd'), 157000.00, 1);

INSERT INTO medicalequipment VALUES
('M00013','Lung','organ_ab','Donated by Lok Hew May',TO_DATE('2021/09/30', 'yyyy/mm/dd'), 100000.00, 1);

INSERT INTO medicalequipment VALUES
('M00014','Heart','organ_b','Bought from organ transplant centre',TO_DATE('2021/04/30', 'yyyy/mm/dd'), 119000.00, 1);

INSERT INTO medicalequipment VALUES
('M00015','Pancreas','organ_o','Donated by Rabinder Govindasamy a/l Marimuthu',TO_DATE('2021/10/13', 'yyyy/mm/dd'), 500.00, 1);

INSERT INTO medicalequipment VALUES
('M00016','Pancreas','organ_b','Donated by Lee Sia Lok',TO_DATE('2021/03/31', 'yyyy/mm/dd'), 500.00, 1);

INSERT INTO medicalequipment VALUES
('M00017','Lung','organ_o','Donated by deceased patient, Puteri bin Mara',TO_DATE('2021/06/30', 'yyyy/mm/dd'), 100000.00, 1);

INSERT INTO medicalequipment VALUES
('M00018','Kidney','organ_o','Donated by deceased patient, Swarna Prakash',TO_DATE('2021/11/13', 'yyyy/mm/dd'), 200000.00, 1);

INSERT INTO medicalequipment VALUES
('M00019','Pancreas','organ_o','Bought from organ transplant centre',TO_DATE('2021/12/03', 'yyyy/mm/dd'), 500.00, 1);

INSERT INTO medicalequipment VALUES
('M00020','Blood','blood_bag_a','Obtained from blood donation centre', TO_DATE('2021/05/03', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00021','Blood','blood_bag_ab','Bought from the market',TO_DATE('2021/06/30', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00022','Blood','blood_bag_ab','Obtained from blood donation centre',TO_DATE('2021/07/05', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00023','Blood','blood_bag_a','Bought from the market',TO_DATE('2021/09/24', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00024','Blood','blood_bag_b','Bought from the market',TO_DATE('2021/11/27', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00025','Blood','blood_bag_b','Bought from the market',TO_DATE('2021/10/13', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00026','Blood','blood_bag_o','Obtained from blood donation centre',TO_DATE('2021/06/01', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00027','Blood','blood_bag_o','Bought from the market',TO_DATE('2021/08/20', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00028','Blood','blood_bag_o','Bought from the market',TO_DATE('2022/01/15', 'yyyy/mm/dd'), 250.00, 1);

INSERT INTO medicalequipment VALUES
('M00029','COVID-19 Vaccine','vaccine_astra_zeneca','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00030','COVID-19 Vaccine','vaccine_sinovac','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00031','COVID-19 Vaccine','vaccine_astra_zeneca','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00032','COVID-19 Vaccine','vaccine_cansino_biologics','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00033','COVID-19 Vaccine','vaccine_pfizer_biontech','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00034','COVID-19 Vaccine','vaccine_astra_zeneca','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00035','COVID-19 Vaccine','vaccine_pfizer_biontech','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00036','COVID-19 Vaccine','vaccine_sinovac','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00037','COVID-19 Vaccine','vaccine_pfizer_biontech','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00038','COVID-19 Vaccine','vaccine_sputnik_v','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00039','COVID-19 Vaccine','vaccine_cansino_biologics','Get from the government',null, 0.00, 0);

INSERT INTO medicalequipment VALUES
('M00040','COVID-19 Vaccine','vaccine_sputnik_v','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00041','COVID-19 Vaccine','vaccine_astra_zeneca','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00042','COVID-19 Vaccine','vaccine_pfizer_biontech','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00043','COVID-19 Vaccine','vaccine_pfizer_biontech','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00044','COVID-19 Vaccine','vaccine_astra_zeneca','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00045','COVID-19 Vaccine','vaccine_pfizer_biontech','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00046','COVID-19 Vaccine','vaccine_cansino_biologics','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00047','COVID-19 Vaccine','vaccine_sputnik_v','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00048','COVID-19 Vaccine','vaccine_cansino_biologics','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00049','COVID-19 Vaccine','vaccine_pfizer_biontech','Get from the government',null, 0.00, 1);

INSERT INTO medicalequipment VALUES
('M00050','Dexamethasone','medicine','Bought from the market',null, 2.00, 50);

--ServiceList

INSERT INTO ServiceList VALUES
('L00001','X-ray Chest','For lungs',70);

INSERT INTO ServiceList VALUES
('L00002','X-ray body','For organ',100);

INSERT INTO ServiceList VALUES
('L00003','CT scan','body 360 xray',251);

INSERT INTO ServiceList VALUES
('L00004','Blood-Type Test','Check blood test',20);

INSERT INTO ServiceList VALUES
('L00005','Health Check','Check health annualy',200);

INSERT INTO ServiceList VALUES
('L00006','Urine check','Check urine content',50);

INSERT INTO ServiceList VALUES
('L00007','General Check-Up','A faster health checkup',80);

INSERT INTO ServiceList VALUES
('L00008','Heart transplant','For patients with failing or weak hearts',3000);

INSERT INTO ServiceList VALUES
('L00009','Neuroendoscopy','A type of brain surgery',7000);

INSERT INTO ServiceList VALUES
('L00010','Normal consultation','Fewer, etc.',70);

INSERT INTO ServiceList VALUES
('L00011','COVID-19 Vaccination','Receives vaccine.',0);

--Bed
INSERT INTO bed VALUES
('B001', 'R001');

INSERT INTO bed VALUES
('B002', 'R001');

INSERT INTO bed VALUES
('B003', 'R002');

INSERT INTO bed VALUES
('B004', 'R002');

INSERT INTO bed VALUES
('B005', 'R002');

INSERT INTO bed VALUES
('B006', 'R002');

INSERT INTO bed VALUES
('B007', 'R008');

INSERT INTO bed VALUES
('B008', 'R008');

INSERT INTO bed VALUES
('B009', 'R008');

INSERT INTO bed VALUES
('B010', 'R009');

INSERT INTO bed VALUES
('B012', 'R010');

INSERT INTO bed VALUES
('B013', 'R010');

INSERT INTO bed VALUES
('B014', 'R011');

INSERT INTO bed VALUES
('B015', 'R011');

INSERT INTO bed VALUES
('B016', 'R011');

INSERT INTO bed VALUES
('B017', 'R012');

INSERT INTO bed VALUES
('B018', 'R013');

INSERT INTO bed VALUES
('B019', 'R014');

INSERT INTO bed VALUES
('B020', 'R015');

INSERT INTO bed VALUES
('B021', 'R016');

INSERT INTO bed VALUES
('B022', 'R020');

--Admission
INSERT INTO admission VALUES
('A00001', 'P00001', 'P00008', TO_TIMESTAMP ('10-Jan-20 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('26-MAR-21 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B001','R','Discharged');

INSERT INTO admission VALUES
('A00002', 'P00002', 'P00009', TO_TIMESTAMP ('12-Feb-20 11:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('17-Feb-20 11:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B002','R','Discharged');

INSERT INTO admission VALUES
('A00003', 'P00003', 'P00009', TO_TIMESTAMP ('22-Feb-20 16:11:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('28-Feb-20 16:11:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B003','R','Discharged');

INSERT INTO admission VALUES
('A00004', 'P00003', 'P00010', TO_TIMESTAMP ('21-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), NULL, 'B004','R','In coma');

INSERT INTO admission VALUES
('A00005', 'P00004', 'P00011', TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), NULL,'B005','R', 'In coma');

INSERT INTO admission VALUES
('A00006', 'P00005', 'P00011', TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), NULL,'B001','R', NULL);

INSERT INTO admission VALUES
('A00007', 'P00002', 'P00010', TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('22-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),'B002','R', 'Discharged');

INSERT INTO admission VALUES
('A00008', 'P00001', 'P00008', TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('22-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null,'R', 'Discharged');

INSERT INTO admission VALUES
('A00009', 'P00001', 'P00008', SYSDATE,null,'B007','I',null);

INSERT INTO admission VALUES
('A00010', 'P00002', 'P00008', SYSDATE,null,'B002','I',null);

INSERT INTO admission VALUES
('A00011', 'P00027', 'P00008', TO_TIMESTAMP ('10-Jan-02 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('10-Jan-02 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B001','R','Discharged');

INSERT INTO admission VALUES
('A00012', 'P00027', 'P00009', TO_TIMESTAMP ('12-Jan-02 11:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('25-Jan-02 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B002','R',null);

INSERT INTO admission VALUES
('A00013', 'P00027', 'P00009', TO_TIMESTAMP ('13-Mar-02 16:11:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('22-Mar-02 03:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B003','D','Dead in sleeping');

INSERT INTO admission VALUES
('A00014', 'P00028', 'P00010', TO_TIMESTAMP ('18-Jan-21 19:08:11.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('22-Jan-21 19:08:36.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B017','R','Contracted COVID-19');

INSERT INTO admission VALUES
('A00015', 'P00029', 'P00008', TO_TIMESTAMP ('24-Feb-21 08:10:13.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('27-Feb-21 03:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B018','D','Dead after contracteed COVID-19');

INSERT INTO admission VALUES
('A00016', 'P00030', 'P00009', TO_TIMESTAMP ('05-Mar-21 12:30:59.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('08-Mar-21 18:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B019','R','Contracted COVID-19');

INSERT INTO admission VALUES
('A00017', 'P00031', 'P00011', TO_TIMESTAMP ('07-Mar-21 09:58:40.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('13-Mar-21 03:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'), 'B020','R','Contracted COVID-19');

INSERT INTO admission VALUES
('A00018', 'P00032', 'P00009', TO_TIMESTAMP ('15-Mar-21 14:01:41.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null, 'B021','I','Contracted COVID-19');

INSERT INTO admission VALUES
('A00019', 'P00017', 'P00010', TO_TIMESTAMP ('27-Feb-21 08:55:55.123000', 'DD-Mon-RR HH24:MI:SS.FF'), TO_TIMESTAMP ('16-Mar-21 09:05:35.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00020', 'P00032', 'P00009', TO_TIMESTAMP ('05-Mar-21 10:36:05.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('16-Mar-21 10:40:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00021', 'P00008', 'P00010', TO_TIMESTAMP ('18-Jan-21 15:57:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('18-Jan-21 16:05:43.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00022', 'P00010', 'P00009', TO_TIMESTAMP ('15-Mar-21 10:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('15-Mar-21 10:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00023', 'P00016', 'P00008', TO_TIMESTAMP ('15-Mar-21 11:30:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('15-Mar-21 11:40:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00024', 'P00025', 'P00009', TO_TIMESTAMP ('18-Mar-21 13:11:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('18-Mar-21 13:26:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00025', 'P00005', 'P00009', TO_TIMESTAMP ('15-Apr-21 10:00:00.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null, null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00026', 'P00028', 'P00009', TO_TIMESTAMP ('16-Apr-21 09:00:00.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null, null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00027', 'P00031', 'P00009', TO_TIMESTAMP ('16-Apr-21 09:15:00.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null, null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00028', 'P00009', 'P00010', TO_TIMESTAMP ('18-Apr-21 13:00:00.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null, null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00029', 'P00032', 'P00009', TO_TIMESTAMP ('30-Mar-21 09:50:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('30-Mar-21 10:05:43.123000', 'DD-Mon-RR HH24:MI:SS.FF'), null,'O','Receives COVID-19 vaccine');

INSERT INTO admission VALUES
('A00030', 'P00033', 'P00010', TO_TIMESTAMP ('04-Apr-21 11:15:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null, 'B022','O','Perform organ transplant surgeries');

--Bill
INSERT INTO bill VALUES
('I00001', 'A00001', 'General check-up, antibiotics', 'Credit Card', TO_DATE('2020/01/10', 'yyyy/mm/dd'), 300,TO_DATE('2020/03/14', 'yyyy/mm/dd'));

INSERT INTO bill VALUES
('I00002', 'A00001', 'Heart transplant', NULL, TO_DATE('2020/01/10', 'yyyy/mm/dd'), 3000,NULL);

INSERT INTO bill VALUES
('I00003', 'A00002', 'General ward 1 night with meals', 'Credit Card', TO_DATE('2020/03/19', 'yyyy/mm/dd'), 500,TO_TIMESTAMP ('19-Mar-20 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO bill VALUES
('I00004', 'A00003', 'Anti-diarrhea pills X2 boxes', NULL, TO_DATE('2020/03/13', 'yyyy/mm/dd'), 100, NULL);

INSERT INTO bill VALUES
('I00005', 'A00004', 'Neuroendoscopy', 'Debit Card', TO_DATE('2020/12/14', 'yyyy/mm/dd'), 5000,TO_TIMESTAMP ('16-Dec-20 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO bill VALUES
('I00006', 'A00004', 'General ward 3 nights with meals', 'Debit Card', TO_DATE('2021/12/14', 'yyyy/mm/dd'), 5000,TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO bill VALUES
('I00007', 'A00005', 'X-rays', 'Debit Card', TO_DATE('2021/12/01', 'yyyy/mm/dd'), 6000,TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO bill VALUES
('I00008', 'A00006', 'Heart transplant', 'Credit Card', TO_DATE('2021/06/14', 'yyyy/mm/dd'), 800,TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO bill VALUES
('I00009', 'A00007', 'Deliver Twins', NULL, TO_DATE('2021/03/23', 'yyyy/mm/dd'), 900, NULL);

INSERT INTO bill VALUES
('I00010', 'A00007', 'Life-support machine X 1 night', NULL, TO_DATE('2021/03/23', 'yyyy/mm/dd'), 3500, NULL);

INSERT INTO bill VALUES
('I00011', 'A00008', 'General check-up', NULL, TO_DATE('2021/12/23', 'yyyy/mm/dd'), 2600, NULL);

INSERT INTO bill VALUES
('I00012', 'A00008', 'Heart Transplant', NULL, TO_DATE('2021/03/24', 'yyyy/mm/dd'), 1700, NULL);

INSERT INTO bill VALUES
('I00013', 'A00014', 'Life-support machine X 3 night', NULL, TO_DATE('2021/03/01', 'yyyy/mm/dd'), 10500, NULL);

INSERT INTO bill VALUES
('I00014', 'A00014', 'General ward 2 night with meals', 'Credit Card', TO_DATE('2021/03/01', 'yyyy/mm/dd'), 1000, TO_TIMESTAMP ('26-Jan-21 19:05:00.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO bill VALUES
('I00015', 'A00015', 'Life-support machine X 2 night', 'Credit Card', TO_DATE('2021/04/01', 'yyyy/mm/dd'), 7000, TO_TIMESTAMP ('03-Mar-21 15:33:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'));

INSERT INTO bill VALUES
('I00016', 'A00015', 'Life-support machine X 2 night', NULL, TO_DATE('2021/04/01', 'yyyy/mm/dd'), 7000, NULL);

INSERT INTO bill VALUES
('I00017', 'A00016', 'Life-support machine X 1 night', NULL, TO_DATE('2021/05/01', 'yyyy/mm/dd'), 3500, NULL);

INSERT INTO bill VALUES
('I00018', 'A00016', 'General ward 3 night with meals', NULL, TO_DATE('2021/05/01', 'yyyy/mm/dd'), 1500, NULL);

INSERT INTO bill VALUES
('I00019', 'A00017', 'General ward 7 night with meals', NULL, TO_DATE('2021/05/01', 'yyyy/mm/dd'), 3500, NULL);

--ServiceRecord

INSERT INTO servicerecord VALUES
('S00001','A00001','P00025','P00015','R005','L00005','G00002','Normal consult',TO_TIMESTAMP ('21-Mar-21 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 15:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);
INSERT INTO servicerecord VALUES
('S00002','A00002','P00026','P00016','R005','L00006','G00003','Normal consult',TO_TIMESTAMP ('21-Mar-21 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null
);
INSERT INTO servicerecord VALUES
('S00003','A00003','P00024','P00013','R007','L00003','G00004','Normal result',TO_TIMESTAMP ('22-Mar-21 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null
);
INSERT INTO servicerecord VALUES	
('S00004','A00003','P00021','P00017','R006','L00004','G00005','O-',TO_TIMESTAMP ('21-Mar-21 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 22:58:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);
INSERT INTO servicerecord VALUES
('S00005','A00002','P00026','P00016','R005','L00006','G00003','Normal consult',TO_TIMESTAMP ('21-Mar-21 15:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null
);
INSERT INTO servicerecord VALUES
('S00006','A00004','P00023','P00018',null,'L00008','G00004','Consultation',TO_TIMESTAMP ('21-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 18:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00007','A00004','P00026','P00018','R003','L00010','G00004','Success',TO_TIMESTAMP ('21-Mar-21 18:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00008','A00004','P00025','P00013','R004','L00001','G00001','Success',TO_TIMESTAMP ('21-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 20:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00009','A00004','P00024','P00014','R005','L00002','G00002','Success',TO_TIMESTAMP ('21-Mar-21 20:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 21:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00010','A00004','P00023','P00015','R006','L00004','G00003','Success',TO_TIMESTAMP ('21-Mar-21 21:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00011','A00004','P00022','P00016','R007','L00006','G00004','Success',TO_TIMESTAMP ('21-Mar-21 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 23:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00012','A00005','P00021','P00017','R003','L00007','G00001','Success',TO_TIMESTAMP ('22-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 18:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00013','A00005','P00022','P00018','R004','L00009','G00002','Success',TO_TIMESTAMP ('22-Mar-21 18:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00014','A00005','P00023','P00019','R005','L00010','G00003','Success',TO_TIMESTAMP ('22-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 23:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00015','A00006','P00024','P00018','R006','L00007','G00004','Success',TO_TIMESTAMP ('22-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null
);

INSERT INTO servicerecord VALUES
('S00016','A00007','P00025','P00018','R007','L00006','G00001','Success',TO_TIMESTAMP ('22-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null
);

INSERT INTO servicerecord VALUES
('S00017','A00008','P00026','P00017','R003','L00002','G00002','Success',TO_TIMESTAMP ('22-Mar-21 20:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')
);

INSERT INTO servicerecord VALUES
('S00018','A00008','P00022','P00016','R004','L00001','G00003','Success',TO_TIMESTAMP ('22-Mar-21 22:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),null
);

INSERT INTO servicerecord VALUES	
('S00019','A00004','P00023','P00017','R006','L00004','G00005','O-, ',TO_TIMESTAMP ('21-Mar-21 23:11:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 22:58:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES
('S00020','A00009','P00023','P00016','R005','L00001','G00003','Success',SYSDATE,null
);

INSERT INTO servicerecord VALUES
('S00021','A00010','P00023','P00016','R005','L00001','G00003','Success',SYSDATE-3,SYSDATE-2
);

INSERT INTO servicerecord VALUES
('S00022','A00010','P00023','P00017','R005','L00001','G00003','Success',SYSDATE-2,SYSDATE-1
);

INSERT INTO servicerecord VALUES	
('S00023','A00004','P00022','P00018','R006','L00004','G00005','O-, ',SYSDATE,null	
);

INSERT INTO servicerecord VALUES	
('S00024','A00001','P00022','P00015','R005','L00005','G00002','Normal consult',TO_TIMESTAMP ('20-Mar-21 14:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 15:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00025','A00001','P00022','P00015','R005','L00005','G00002','Normal consult',TO_TIMESTAMP ('21-Mar-21 15:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 16:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00026','A00001','P00022','P00015','R005','L00005','G00002','Normal consult',TO_TIMESTAMP ('22-Mar-21 16:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00027','A00001','P00022','P00015','R005','L00005','G00002','Normal consult',TO_TIMESTAMP ('23-Mar-21 17:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 18:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00028','A00001','P00022','P00015','R005','L00005','G00002','Normal consult',TO_TIMESTAMP ('24-Mar-21 18:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00029','A00001','P00022','P00015','R005','L00005','G00002','Normal consult',TO_TIMESTAMP ('25-Mar-21 19:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 20:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00030','A00014','P00023',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('18-Mar-21 13:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('18-Mar-21 13:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00031','A00014','P00023',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('19-Mar-21 13:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('19-Mar-21 13:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00032','A00014','P00023',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('20-Mar-21 13:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('20-Mar-21 13:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00033','A00014',null,'P00018',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('21-Mar-21 13:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('21-Mar-21 13:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00034','A00014',null,'P00018',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('22-Mar-21 13:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 13:10:10.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00035','A00015','P00024',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('24-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('24-Mar-21 12:20:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00036','A00015','P00024',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('25-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('25-Mar-21 12:20:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00037','A00015','P00024',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('27-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('27-Mar-21 12:20:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00038','A00015','P00024',null,null,'L00007','G00001','Patient is dead',TO_TIMESTAMP ('22-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('22-Mar-21 15:33:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00039','A00016','P00022',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('05-Mar-21 11:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('05-Mar-21 11:30:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00040','A00016',null,'P00017',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('06-Mar-21 11:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('06-Mar-21 11:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00041','A00016',null,'P00017',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('07-Mar-21 11:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('07-Mar-21 11:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00042','A00016',null,'P00017',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('08-Mar-21 11:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('08-Mar-21 11:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00043','A00017',null,'P00015',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('07-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('07-Mar-21 12:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00044','A00017',null,'P00015',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('08-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('08-Mar-21 12:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00045','A00017',null,'P00015',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('09-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('09-Mar-21 12:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00046','A00017',null,'P00015',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('10-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('10-Mar-21 12:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00047','A00017',null,'P00015',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('11-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('11-Mar-21 12:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00048','A00017',null,'P00015',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('12-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('12-Mar-21 12:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00049','A00017',null,'P00015',null,'L00007','G00001','Patient has normal symptoms',TO_TIMESTAMP ('13-Mar-21 12:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('13-Mar-21 12:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

INSERT INTO servicerecord VALUES	
('S00050','A00018','P00024',null,null,'L00007','G00001','Patient has severe symptoms',TO_TIMESTAMP ('15-Mar-21 10:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('15-Mar-21 10:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

-- P00017
INSERT INTO servicerecord VALUES	
('S00051','A00019',null,'P00015','R019','L00011',null,'Receives COVID-19 vaccine',TO_TIMESTAMP ('27-Feb-21 08:55:55.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('16-Mar-21 09:05:35.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);
-- P00004
INSERT INTO servicerecord VALUES	
('S00052','A00020',null,'P00017','R018','L00011',null,'Receives COVID-19 vaccine',TO_TIMESTAMP ('05-Mar-21 10:36:05.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('16-Mar-21 10:40:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);
-- P00008
INSERT INTO servicerecord VALUES	
('S00053','A00021',null,'P00015','R019','L00011',null,'Receives COVID-19 vaccine',TO_TIMESTAMP ('18-Jan-21 15:57:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('18-Jan-21 16:05:43.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);
--P00010
INSERT INTO servicerecord VALUES	
('S00054','A00022',null,'P00017','R019','L00011',null,'Receives COVID-19 vaccine',TO_TIMESTAMP ('15-Mar-21 10:00:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('15-Mar-21 10:10:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);
--P00016
INSERT INTO servicerecord VALUES	
('S00055','A00023',null,'P00017','R018','L00011',null,'Receives COVID-19 vaccine',TO_TIMESTAMP ('15-Mar-21 11:30:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('15-Mar-21 11:40:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);
--P00025
INSERT INTO servicerecord VALUES	
('S00056','A00024',null,'P00015','R018','L00011',null,'Receives COVID-19 vaccine',TO_TIMESTAMP ('18-Mar-21 13:11:10.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('15-Mar-21 13:26:30.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);
-- P00001
INSERT INTO servicerecord VALUES	
('S00057','A00025',null,'P00017','R019','L00011',null,'Receives COVID-19 vaccine',null,null	
);
-- P00028
INSERT INTO servicerecord VALUES	
('S00058','A00026',null,'P00015','R018','L00011',null,'Receives COVID-19 vaccine',null,null
);
-- P00031
INSERT INTO servicerecord VALUES	
('S00059','A00027',null,'P00015','R018','L00011',null,'Receives COVID-19 vaccine',null,null
);
-- P00009
INSERT INTO servicerecord VALUES	
('S00060','A00028',null,'P00017','R019','L00011',null,'Receives COVID-19 vaccine',null,null
);
-- P00004
INSERT INTO servicerecord VALUES	
('S00061','A00029',null,'P00017','R019','L00011',null,'Receives COVID-19 vaccine',TO_TIMESTAMP ('30-Mar-21 09:50:30.123000', 'DD-Mon-RR HH24:MI:SS.FF'),TO_TIMESTAMP ('30-Mar-21 10:05:43.123000', 'DD-Mon-RR HH24:MI:SS.FF')	
);

--Prescription
INSERT INTO PRESCRIPTION VALUES(
'S00003','M00001','20','1.50'
);

INSERT INTO PRESCRIPTION VALUES(
'S00006','M00001','20','1.50'
);

INSERT INTO PRESCRIPTION VALUES(
'S00006','M00006','5','3.50'
);

INSERT INTO PRESCRIPTION VALUES(
'S00006','M00007','8','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00005','M00008','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00005','M00002','10','1.50'
);

INSERT INTO PRESCRIPTION VALUES(
'S00005','M00007','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00006','M00008','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00006','M00009','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00006','M00003','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00007','M00009','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00008','M00005','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00008','M00003','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00009','M00002','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00005','M00001','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00009','M00006','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00009','M00003','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00010','M00005','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00011','M00007','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00011','M00009','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00014','M00003','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00018','M00004','10','5'
);

INSERT INTO PRESCRIPTION VALUES(
'S00030','M00050','3','2'
);

INSERT INTO PRESCRIPTION VALUES(
'S00031','M00050','3','2'
);

INSERT INTO PRESCRIPTION VALUES(
'S00032','M00050','3','2'
);

INSERT INTO PRESCRIPTION VALUES(
'S00035','M00050','3','2'
);

INSERT INTO PRESCRIPTION VALUES(
'S00036','M00050','3','2'
);

INSERT INTO PRESCRIPTION VALUES(
'S00037','M00050','3','2'
);

INSERT INTO PRESCRIPTION VALUES(
'S00039','M00050','3','2'
);

INSERT INTO PRESCRIPTION VALUES(
'S00050','M00050','3','2'
);

-- One dose finish vaccination
INSERT INTO PRESCRIPTION VALUES(
'S00051','M00032','1','0'
);

-- Two dose finsih vaccination(1)
INSERT INTO PRESCRIPTION VALUES(
'S00052','M00033','1','0'
);

-- One dose finish vaccination
INSERT INTO PRESCRIPTION VALUES(
'S00053','M00039','1','0'
);

-- First dose finsih vaccination
INSERT INTO PRESCRIPTION VALUES(
'S00054','M00029','1','0'
);

-- First dose finsih vaccination
INSERT INTO PRESCRIPTION VALUES(
'S00055','M00030','1','0'
);

-- First dose finsih vaccination
INSERT INTO PRESCRIPTION VALUES(
'S00056','M00031','1','0'
);

-- Schedule to be vaccinated
INSERT INTO PRESCRIPTION VALUES(
'S00057','M00034','1','0'
);

-- Schedule to be vaccinated
INSERT INTO PRESCRIPTION VALUES(
'S00058','M00036','1','0'
);

-- Schedule to be vaccinated
INSERT INTO PRESCRIPTION VALUES(
'S00059','M00037','1','0'
);

-- Schedule to be vaccinated
INSERT INTO PRESCRIPTION VALUES(
'S00060','M00038','1','0'
);

-- Two dose finsih vaccination(2)
INSERT INTO PRESCRIPTION VALUES(
'S00061','M00035','1','0'
);

-------------------
-- Creating Roles
-------------------

CREATE ROLE admin;
CREATE ROLE doctor;
CREATE ROLE nurse;

-----------------------------
-- System Priviledges
-----------------------------
GRANT create table, create view, create session TO admin WITH ADMIN OPTION;
GRANT create view TO doctor, nurse;

------------------------------
--Object Priviledges
------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON person TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON doctor TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON nurse TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON employee TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON patient TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON admission TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON servicerecord TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON servicelist TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON medicalequipment TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON prescription TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON bed TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON room TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON disease TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON department TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON bill TO admin;

GRANT SELECT ON person TO doctor, nurse;
GRANT SELECT ON employee TO doctor, nurse;
GRANT SELECT ON nurse TO doctor, nurse;
GRANT SELECT ON doctor TO doctor, nurse;
GRANT SELECT ON servicerecord TO doctor, nurse;
GRANT SELECT ON servicelist TO doctor, nurse;
GRANT SELECT ON medicalequipment TO doctor, nurse;
GRANT SELECT ON prescription TO doctor, nurse;
GRANT SELECT ON patient TO doctor, nurse;
GRANT SELECT ON disease TO doctor, nurse;

GRANT UNLIMITED TABLESPACE TO admin, nurse, doctor;

---------------------------
--Create Users
---------------------------
CREATE USER yapjhengkhin IDENTIFIED BY abc123;
CREATE USER jacynththam IDENTIFIED BY abc1234;
CREATE USER tanjingjie IDENTIFIED BY abc12345;
CREATE USER tanweimun IDENTIFIED BY abc123456;

CREATE USER dodefarre IDENTIFIED BY abcd;
CREATE USER janesilverstone IDENTIFIED BY hfyr;
CREATE USER loriannebrak IDENTIFIED BY iwhf;
CREATE USER nolliepynn IDENTIFIED BY abcee;
CREATE USER kayfedoronko IDENTIFIED BY abc1233d;
CREATE USER erwin IDENTIFIED BY abdjeo;

GRANT admin to yapjhengkhin;
GRANT admin to jacynththam;
GRANT admin to tanjingjie;
GRANT admin to tanweimun;

GRANT admin to dodefarre;
GRANT admin to janesilverstone;
GRANT admin to loriannebrak;

GRANT nurse to nolliepynn;
GRANT nurse to kayfedoronko;

GRANT doctor to erwin;

-------------------------------------------------
-- COMMIT
-------------------------------------------------
COMMIT;


-------------------------------------------------
-- Thank you. Created 27/3/2021
-------------------------------------------------












































