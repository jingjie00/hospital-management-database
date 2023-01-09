/*
INDIVIDUAL ASSIGNMENT SUBMISSION
Submit one individual report with partial/full output screenshot (*.docx)
and one sql script (*.sql for oracle 11g)

Template save as "G??_YourFullStudentID.sql"
e.g. G01_99ACB999999.sql

GROUP NUMBER : G08
PROGRAMME : CS
STUDENT ID : 1804560
STUDENT NAME : Tan Jing Jie
Submission date and time: 27-03-2021

Your information should appear in both files one individual report docx & one individual sql script, then save as G01_99ACB999999.zip

Should be obvious different transaction among the members

*/
-----------------------------------------------------------------------------------
--                              Tan Jing Jie 1804560                             --
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--                        Please run Hospital Script first                       --
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--             Some example for prompting is given under the script              --
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
--Set Server output on, DBMS_OutPUT enables to display output from PL/SQL blocks --
-----------------------------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 20000
SET PAGESIZE 100
-----------------------------------------------------------------------------------
--                                   10 QUERIES                                  --
-----------------------------------------------------------------------------------
/* Query 1 */
--1 Show the list of doctor(s) by using their name or/and department (prompting)
SELECT (d.doctor_id||' Dr. ' ||p.first_name ||' '|| p.last_name) AS Doctor, 
TRUNC((SYSDATE-p.birth_date)/365.25) AS Age,
 dp.name AS Department,
 d.qualification As Qualification,
 d.expertise As Expertise
FROM employee e, doctor d, person p, department dp
WHERE p.person_id = e.employee_id
AND e.employee_id = d.doctor_id 
AND e.department_id=dp.department_id
AND (LOWER(dp.name) LIKE LOWER('%&query_department%')
AND LOWER(CONCAT(CONCAT(p.first_name,' '), p.last_name)) LIKE LOWER('%&query_name%'))
AND e.leave_date IS NULL
ORDER BY Age, TO_CHAR(SUBSTR(d.doctor_id,2,5),'99999');
--Try:
--imaging
--sasha

/* Query 2 */
--2 Show all service that perform to patient in an admission (by prompting patient name)
SELECT a.admission_id AS AdmID,
(pt.patient_id||', '||p2.first_name||' '||p2.last_name) AS Patient,
(e.department_id||', '||dp.name) AS Department,
(p.person_id ||', Dr. ' ||p.first_name ||' '|| p.last_name) AS Doctor, 
COUNT(s.service_id) AS Quantity,
(l.service_id||', '||l.name) AS Service
FROM employee e, doctor d, person p, department dp, servicerecord s, servicelist l, admission a, person p2, patient pt
WHERE s.doctor_id = d.doctor_id 
AND e.employee_id = d.doctor_id 
AND p.person_id = e.employee_id
AND s.admission_id=a.admission_id 
AND a.patient_id = pt.patient_id 
AND pt.patient_id=p2.person_id
AND e.department_id = dp.department_id
AND s.service_id = l.service_id
AND LOWER(CONCAT(CONCAT(p2.first_name,' '), p2.last_name)) LIKE LOWER('%&patient%')
AND a.discharge_date IS NULL
AND a.status != 'O'
GROUP BY p.person_id, e.department_id,p.person_id, dp.name,p.first_name, p.last_name, l.name, l.service_id, pt.patient_id, p2.first_name, p2.last_name, a.admission_id
ORDER BY pt.patient_id,e.department_id, p.person_id;
--Try:
--kevin

/* Query 3 */
--3 Show a list of a doctor’s patients (by prompting doctor ID)
SELECT (INITCAP(p1.first_name) ||''|| INITCAP(p1.last_name)) AS Patient, l.name AS Service, s.summary AS Summary,
TO_CHAR(s.start_time, 'DD-MON-YYYY HH24:MI:SSxFF') AS Start_Time,
CASE WHEN s.end_time IS NULL THEN 'Current undergoing service' 
	ELSE TO_CHAR(s.end_time, 'DD-MON-YYYY HH24:MI:SSxFF') end AS End_Time
FROM patient pt, person p1, doctor d, employee e, person p2, servicerecord s, servicelist l, admission a
WHERE a.admission_id=s.admission_id
AND a.patient_id = pt.patient_id 
AND pt.patient_id=p1.person_id
AND s.doctor_id=d.doctor_id 
AND d.doctor_id = e.employee_id 
AND e.employee_id=p2.person_id
AND s.service_id = l.service_id
AND s.doctor_id = '&doctor_id'
ORDER BY s.end_time DESC NULLS FIRST;
--Try
--P00023

/* Query 4 */
--4 Show list of unpaid after due date
SELECT (p.gender ||' | ' ||INITCAP(p.first_name) ||' '|| INITCAP(p.last_name) ||' | ' || p.phone_number)||' | ' || p.email||
(p.address_line||', '||p.address_zip_code||', '||p.address_state)  "Patient Details" ,
'RM'||SUM(b.amount) ||' (' ||LISTAGG('RM'||b.amount||'[Late: '||TO_CHAR(TRUNC((SYSDATE-b.due_date)))||'day(s)]', ', ') WITHIN GROUP (ORDER BY b.amount)||') ' AS Amount,  
LISTAGG(b.description, ', ') WITHIN GROUP (ORDER BY b.description) "Description"
FROM patient pt, person p, bill b, admission a
WHERE b.admission_id=a.admission_id
AND a.patient_id=pt.patient_id 
AND pt.patient_id=p.person_id
AND b.payment_date IS NULL
AND TRUNC(SYSDATE-b.due_date)>0
GROUP BY p.first_name, p.last_name, p.gender,p.phone_number,p.email, p.address_state, p.address_zip_code,p.address_line
ORDER BY SUM(b.amount)DESC;

/* Query 5 */
--5 Show list admission from current date. (prompting the nearest n day(s))
SELECT (pt.patient_id||', '|| INITCAP(p.first_name) ||''|| INITCAP(p.last_name)) AS Patient, s.admission_id, MIN(start_time)||' ' AS First_Service_Time,
'['||((LISTAGG((d.doctor_id||', Dr. '||INITCAP(p2.first_name) ||' '|| INITCAP(p2.last_name)), ' | ') WITHIN GROUP (ORDER BY d.doctor_id))||' ')||'] && ['||
((LISTAGG((s.nurse_id||', '||INITCAP(p3.first_name) ||' '|| INITCAP(p3.last_name)), ' | ') WITHIN GROUP (ORDER BY s.nurse_id)))||']' AS Medical_staff
FROM servicerecord s, admission a, patient pt, person p, doctor d, employee e, person p2, nurse n, employee e2, person p3
WHERE s.admission_id=a.admission_id
AND a.patient_id=pt.patient_id 
AND pt.patient_id=p.person_id
AND s.doctor_id=d.doctor_id 
AND d.doctor_id=e.employee_id 
AND e.employee_id=p2.person_id
AND s.nurse_id=n.nurse_id(+)
AND n.nurse_id=e2.employee_id(+) 
AND e2.employee_id=p3.person_id(+)
AND SYSDATE - CAST(a.admission_date AS DATE) <= &days 
AND SYSDATE - CAST(a.admission_date AS DATE) > 0 
AND a.bed_id IS NOT NULL
AND a.status != 'O'
AND discharge_date IS NULL
GROUP BY s.admission_id,pt.patient_id,p.first_name,p.last_name, s.admission_id;
--Try:
--1

/* Query 6 */
--6 Show all historical medicine equipment undertaking by a patient
SELECT (a.admission_id ||'-'||p.first_name||' '||p.last_name) AS Patient,m.medicalequipment_id||' '||m.name AS Medicine, 
('RM'||TO_NUMBER(SUM(q.unit_price*q.quantity),'9999.99')||
(LISTAGG(' ('||q.quantity||' x RM'||TO_NUMBER(q.unit_price,'9999.99')||')',' | ') WITHIN GROUP (ORDER BY d.doctor_id)))AS Price,
(LISTAGG(d.doctor_id,' | ') WITHIN GROUP (ORDER BY d.doctor_id)) AS Doctor
FROM prescription q, medicalequipment m, patient pt, person p, servicerecord s, admission a, doctor d, employee e, person p2
WHERE q.service_record_id=s.service_record_id 
AND s.admission_id=a.admission_id
AND a.patient_id=pt.patient_id 
AND pt.patient_id=p.person_id
AND q.medicalequipment_id=m.medicalequipment_id
AND s.doctor_id=d.doctor_id 
AND d.doctor_id=e.employee_id 
AND e.employee_id=p2.person_id
AND LOWER(CONCAT(CONCAT(p.first_name,' '), p.last_name)) LIKE LOWER('%&patient%')
GROUP BY a.admission_id,p.first_name,p.last_name,m.name, m.medicalequipment_id;
--Try:
--kevin

/* Query 7 */
--7 Show operation room schedule by entering room name
SELECT r.room_id||' '||r.room_name AS Room, d.doctor_id||' '||p2.first_name||' '||p2.last_name AS Doctor,
pt.patient_id||' '||p1.first_name||' '||p1.last_name AS Patient,
TO_CHAR(s.start_time, 'DD-MON-YYYY HH24:MI:SSxFF') AS Start_Time,
CASE WHEN s.end_time IS NULL THEN 'Current in use' 
ELSE TO_CHAR(s.end_time, 'DD-MON-YYYY HH24:MI:SSxFF') END AS End_Time
FROM room r, servicerecord s, admission a, patient pt, person p1, doctor d, employee e, person p2
WHERE r.room_id = s.room_id
AND s.admission_id=a.admission_id 
AND a.patient_id=pt.patient_id 
AND pt.patient_id=p1.person_id
AND s.doctor_id=d.doctor_id 
AND d.doctor_id=e.employee_id 
AND e.employee_id=p2.person_id
AND LOWER(r.room_name)LIKE LOWER('%&room%')
ORDER BY r.room_id,s.start_time;
--Try:
--operation

/* Query 8 */
--8 Show nurse with highest service duration
SELECT * FROM(
SELECT (d.name||'-'||n.nurse_id||' '||p.first_name ||' '|| p.last_name) AS Nurse,
TRUNC((SYSDATE - e.hire_date)/365.25) "Service year(s)",
TO_CHAR(SUM((EXTRACT (DAY FROM ((CASE WHEN s.end_time is null then SYSTIMESTAMP ELSE s.end_time END)-s.start_time))*24*60*60+
EXTRACT (HOUR FROM ((CASE WHEN s.end_time is null then SYSTIMESTAMP ELSE s.end_time END)-s.start_time))*60*60+
EXTRACT (MINUTE FROM ((CASE WHEN s.end_time is null then SYSTIMESTAMP ELSE s.end_time END)-s.start_time))*60+
EXTRACT (SECOND FROM ((CASE WHEN s.end_time is null then SYSTIMESTAMP ELSE s.end_time END)-s.start_time)))/60
),'999999999.9999')|| ' min' AS "Total Duration(Min)"
FROM nurse n, employee e, person p, servicerecord s, department d
WHERE s.nurse_id=n.nurse_id 
AND n.nurse_id=e.employee_id 
AND e.employee_id=p.person_id
AND d.department_id=e.department_id
GROUP BY n.nurse_id,p.first_name, p.last_name, d.name,e.hire_date
ORDER BY 3 DESC
)WHERE ROWNUM <= &top_query;
--Try:
--2

/* Query 9 */
--9 Show the list of staff number in each department
SELECT (d.department_id||' '||d.name) "Department", (p1.person_id||' '||p1.first_name ||' '|| p1.last_name) "Head",
CASE WHEN COUNT(e2.employee_id)=0 THEN TO_CHAR('No people') 
ELSE TO_CHAR(COUNT(e2.employee_id)) END "Number",
CASE WHEN COUNT(e2.employee_id)=0 THEN TO_CHAR('No people') 
ELSE (LISTAGG(e2.employee_id,' | ')WITHIN GROUP (ORDER BY e2.employee_id)) END"Staff inside"
FROM department d
LEFT OUTER JOIN employee e1 ON d.head=e1.employee_id
LEFT OUTER JOIN person p1 ON e1.employee_id = p1.person_id
LEFT OUTER JOIN employee e2 ON d.department_id=e2.department_id
LEFT OUTER JOIN person p2 ON e2.employee_id=p2.person_id
GROUP BY d.department_id,d.name,p1.person_id,p1.first_name,p1.last_name
ORDER BY d.department_id ASC;

/* Query 10 */
--10 Show the list of patients that a nurse served on the day
SELECT pt.patient_id||' '||p2.first_name||' '||p2.last_name AS Patient, 
(r.room_id ||' '||r.room_name||' '||r.location) AS Service_Location,
(l.service_id||' '||l.name) AS Service,
(TO_CHAR(s.start_time, 'DD-MON-YYYY HH24:MI')||' -> '||CASE WHEN s.end_time IS NULL THEN 'Current' ELSE TO_CHAR(s.end_time,'DD-MON-YYYY HH24:MI') END) AS Duration
FROM servicerecord s, nurse n, employee e, person p1, patient pt, person p2, admission a, room r, servicelist l
WHERE s.admission_id=a.admission_id 
AND s.nurse_id=n.nurse_id 
AND n.nurse_id=e.employee_id 
AND e.employee_id=p1.person_id
AND a.patient_id=pt.patient_id 
AND pt.patient_id=p2.person_id
AND s.room_id=r.room_id
AND s.service_id=l.service_id
AND (TO_CHAR(SYSDATE, 'RRRRMMDD') = TO_CHAR(s.start_time, 'RRRRMMDD')
OR TO_CHAR(SYSDATE, 'RRRRMMDD') = TO_CHAR(s.end_time, 'RRRRMMDD'))
AND LOWER(CONCAT(CONCAT(p1.first_name,' '), p1.last_name)) LIKE LOWER('%&query_name%');
--Try:
--Kay

---------------------------------------------------------------------------------------
--                                Stored procedure                                   --
---------------------------------------------------------------------------------------

/* Stored procedure 1 */
---------------------------------------------------------
--1 Check patient current situation. (Patient's location and what service undergo)
---------------------------------------------------------
--Stored procedure
CREATE OR REPLACE PROCEDURE patient_current_situation
(
   patient_name IN varchar2
)
IS
	Admission Varchar2(6);
	Bed varchar2(20);
	Room varchar2(100);
	Patient varchar2(100);
	Nurse varchar2(100);
	Doctor varchar2(100);
	Service varchar2(100);
	patient_n varchar2(200);
	checkexist number(1);
BEGIN
	SELECT COUNT(*) INTO checkexist 
	FROM admission a, patient pt, person p
	WHERE a.patient_id = pt.patient_id
	AND pt.patient_id = p.person_id
	AND LOWER(CONCAT(CONCAT(p.first_name,' '), p.last_name)) LIKE LOWER(patient_name)
	AND a.discharge_date IS NULL
	AND status != 'O';

	IF (checkexist=1) THEN
		SELECT a.admission_id, b.bed_id, (r.room_id ||' '||r.room_name||' '||r.location), (pt.patient_id||', '||p.first_name||' '||p.last_name) INTO Admission, Bed, Room, Patient
		FROM patient pt, admission a, person p, bed b, room r
		WHERE a.patient_id=pt.patient_id AND pt.patient_id=p.person_id
		AND b.room_id=r.room_id
		AND a.bed_id=b.bed_id
		AND LOWER(CONCAT(CONCAT(p.first_name,' '), p.last_name)) LIKE LOWER(patient_name)
		AND a.discharge_date IS NULL;
	
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('Admission: ' || Admission );
		DBMS_OUTPUT.PUT_LINE('Patient:   ' || Patient );
		DBMS_OUTPUT.PUT_LINE('Bed:       ' || Bed );
		DBMS_OUTPUT.PUT_LINE('Room:      ' || Room );
	
	SELECT COUNT(*) INTO checkexist FROM servicerecord sr WHERE sr.admission_id = Admission AND end_time is NULL;
	
	IF (checkexist=1) THEN
		SELECT (r.room_id ||' '||r.room_name||' '||r.location), (s.nurse_id||' '||pn.first_name||' '||pn.last_name), (s.doctor_id||' '||pd.first_name||' '||pd.last_name), (s.service_id ||' '||l.name)
		INTO Room, Nurse, Doctor, Service
		FROM servicerecord s, room r, nurse n, doctor d, employee en,employee ed, person pn,person pd, servicelist l
		WHERE s.room_id=r.room_id
		AND s.nurse_id=n.nurse_id AND n.nurse_id =en.employee_id AND en.employee_id = pn.person_id
		AND s.doctor_id=d.doctor_id AND d.doctor_id =ed.employee_id AND ed.employee_id = pd.person_id
		AND s.service_id=l.service_id
		AND s.room_id=r.room_id
		AND admission_id=Admission
		AND s.end_time is NULL;
	
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('Now:       '||SYSTIMESTAMP);
		DBMS_OUTPUT.PUT_LINE('Service:   '||Service);
		DBMS_OUTPUT.PUT_LINE('Room:      '||Room);
		DBMS_OUTPUT.PUT_LINE('Doctor:    '||Doctor);
		DBMS_OUTPUT.PUT_LINE('Nurse:     '||Nurse);
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	ELSE
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('No any current service undergo');
	END IF;
	
	ELSE
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('No admission_record');
	END IF;
COMMIT;
END;
/
--Execute Store Procedure
EXECUTE patient_current_situation('%&patient_name%');

--Try:
--kevin

/* Stored procedure 2 */
---------------------------------------------------------
--2 Insert data into medical equipment table by auto generate ID. (Add new medical equipment)
---------------------------------------------------------

--Stored Procedure - for viewing new result
CREATE OR REPLACE PROCEDURE view_medical_equipment
IS 
	Medicine_count NUMBER(10);
	mname VARCHAR2(30);
	mtype VARCHAR2(12);
	mdescription VARCHAR2(50);
	mexpiration_date Date;
	munit_price Number(10,2);
	mstock_quantity Integer;
	Medicine_ID VARCHAR(6);
BEGIN
	SELECT COUNT(*) INTO Medicine_count FROM medicalequipment;

	Medicine_ID:=CONCAT('M',TRIM(TO_CHAR(Medicine_count,'09999')));

	SELECT m.name, m.type, m.description, m.expiration_date, m.unit_price, m.stock_quantity INTO mname, mtype ,mdescription,mexpiration_date, munit_price, mstock_quantity
	FROM medicalequipment m
	WHERE medicalequipment_id = Medicine_ID;

	DBMS_OUTPUT.PUT_LINE(' ID:                         '||Medicine_ID);
	DBMS_OUTPUT.PUT_LINE(' Name:                       '||mname);
	DBMS_OUTPUT.PUT_LINE(' Type:                       '||mtype);
	DBMS_OUTPUT.PUT_LINE(' Description:                '||mdescription);
	DBMS_OUTPUT.PUT_LINE(' Expirate Date (DD/MM/YYYY): '||TO_CHAR(mexpiration_date,'DD/MM/YYYY'));
	DBMS_OUTPUT.PUT_LINE(' Unit_price:                 RM'||TRIM(TO_CHAR(munit_price,'9999.99')));
	DBMS_OUTPUT.PUT_LINE(' Stock quantity:             '||TO_CHAR(mstock_quantity));
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
END;
/

--Trigger when medicine successfully insert, call the view
CREATE OR REPLACE TRIGGER insert_medicine_trigger
AFTER INSERT
   ON medicalequipment
BEGIN
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	DBMS_OUTPUT.PUT_LINE('Successfully added');
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	view_medical_equipment;
END;
/

--Stored procedure for insert medical equipment purpose (Main)
CREATE OR REPLACE PROCEDURE insert_medical_equipment
( 
	name VARCHAR2,
    type VARCHAR2,
	description VARCHAR2,
    expiration_date Date,
	unit_price Number,
	stock_quantity Integer
)
IS 
	Medicine_count NUMBER(10);
	Medicine_ID VARCHAR(6);
BEGIN
	SELECT COUNT(*) INTO Medicine_count FROM medicalequipment;

	Medicine_ID:=CONCAT('M',TRIM(TO_CHAR(Medicine_count+1,'09999')));

	INSERT INTO medicalequipment
	VALUES (Medicine_ID, name, type, description, expiration_date, unit_price, stock_quantity);
COMMIT;
END;
/

---Execution with error handle
BEGIN
	insert_medical_equipment('&medical_name', '&medical_type', '&description',TO_DATE('&expiration_date','DD-MM-YYYY'), TO_NUMBER('&unit_price','999999.99'),TO_NUMBER('&stock_quantity','9999'));
EXCEPTION
	WHEN VALUE_ERROR THEN
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('Invalid value input. Please follow the instruction given');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE(' Name --> <30 character');
		DBMS_OUTPUT.PUT_LINE(' Type --> medicine, organ_a, organ_b, organ_o, organ_ab, blood_bag_a, blood_bag_b, blood_bag_o, blood_bag_ab, vaccine');
		DBMS_OUTPUT.PUT_LINE(' Description --> <50 character');
		DBMS_OUTPUT.PUT_LINE(' Expirate Date --> DD-MM-YYYY');
		DBMS_OUTPUT.PUT_LINE(' Unit_price --> Number');
		DBMS_OUTPUT.PUT_LINE(' Stock quantity --> Integer');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('Please follow instruction and enter a valid input');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
END;
/

--Try:
--Paracetamol 200mg
--medicine
--for kid
--12-12-2021
--21.20
--20

/* Stored procedure 3 */
---------------------------------------------------------
--3 Update salary of all staff in hospital with a parameter value and option procedure
---------------------------------------------------------
--Stored Procedure
CREATE OR REPLACE PROCEDURE update_salary
( 
	 uparameter Number,
	 ufunction VARCHAR
)
IS 
	pid employee.employee_id%type;
	pidc employee.employee_id%type;
	psalary employee.salary%type;
	pleave_date employee.leave_date%type;
	CURSOR pointer is 
		SELECT employee_id,salary,leave_date 
		FROM employee;
BEGIN

		IF ufunction='+' THEN
			DBMS_OUTPUT.PUT_LINE('Update logic: + RM'||uparameter);
		ELSIF ufunction='-' THEN
			DBMS_OUTPUT.PUT_LINE('Update logic: - RM'||uparameter);
		ELSIF ufunction='*' THEN
			DBMS_OUTPUT.PUT_LINE('Update logic: * '||TO_CHAR(uparameter)||'%');	
		ELSE
			DBMS_OUTPUT.PUT_LINE('Invalid input. Only accept + - and *');
			RETURN;
		END IF;
		
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		
		OPEN pointer;
		LOOP
		FETCH pointer INTO pid, psalary, pleave_date;
		IF pidc=pid THEN
			EXIT;
		ELSE
		pidc:=pid;
		END IF;
		IF pleave_date IS NULL THEN
			IF ufunction='+' THEN
				UPDATE employee set salary=psalary+uparameter WHERE employee_id=pid;
				DBMS_OUTPUT.PUT_LINE('Person ID: '||TO_CHAR(pid)||' updated salary from RM'||TO_CHAR(psalary,'999999999.99')||' to RM'||TO_CHAR(psalary+uparameter,'999999999.99'));
			ELSIF ufunction='-' THEN
				UPDATE employee set salary=psalary-uparameter WHERE employee_id=pid;
				DBMS_OUTPUT.PUT_LINE('Person ID: '||TO_CHAR(pid)||' updated salary from RM'||TO_CHAR(psalary,'999999999.99')||' to RM'||TO_CHAR(psalary-uparameter,'999999999.99'));
			ELSIF ufunction='*' THEN
				UPDATE employee set salary=psalary/100*uparameter WHERE employee_id=pid;
				DBMS_OUTPUT.PUT_LINE('Person ID: '||TO_CHAR(pid)||' updated salary from RM'||TO_CHAR(psalary,'999999999.99')||' to RM'||TO_CHAR(psalary/100*uparameter,'999999999.99'));
			END IF;
		END IF;
		EXIT WHEN pointer%NOTFOUND;

		END LOOP;
		CLOSE pointer;
COMMIT;
END;
/

--Execution
BEGIN
DBMS_OUTPUT.PUT_LINE('Update Salary');
DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
update_salary(&parameter,'&operation_function');
END;
/

--Try:
--200
--+

/* Stored procedure 4 */
---------------------------------------------------------
--4 Update blood type in both person table and servicerecord table
---------------------------------------------------------
--Store Procedure
CREATE OR REPLACE PROCEDURE update_blood_type(
	nservice_record_id VARCHAR,
	nsummary VARCHAR
)
IS
	bt VARCHAR(2);
	rh VARCHAR(1);
	pid VARCHAR(6);
BEGIN
	SELECT p.patient_id into pid
	FROM servicerecord s, admission a, patient p
	WHERE s.admission_id = a.admission_id
	AND a.patient_id=p.patient_id
	AND s.service_record_id=nservice_record_id;
	
	IF LENGTH(nsummary)=3 THEN
		bt:=SUBSTR(nsummary,1,2);
		rh:=SUBSTR(nsummary,3,1);
	ELSIF LENGTH(nsummary)=2 THEN
		bt:=SUBSTR(nsummary,1,1);
		rh:=SUBSTR(nsummary,2,1);
	END IF;
	
	UPDATE person p set p.blood_type = bt,p.rh_type=rh WHERE p.person_id= pid;
	UPDATE servicerecord s set s.summary=nsummary, s.end_time=SYSTIMESTAMP WHERE s.service_record_id=nservice_record_id;
EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Invalid input. Please follow the instruction given');
END;
/

--Trigger to view comparison
CREATE OR REPLACE TRIGGER trigger_patient_blood_type
AFTER UPDATE
   ON person
FOR EACH ROW
BEGIN
IF(:old.blood_type = :new.blood_type) AND (:old.rh_type = :new.rh_type) THEN
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	DBMS_OUTPUT.PUT_LINE('No blood type is changed. Blood type: '||:new.blood_type||:new.rh_type);
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
ELSE
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	DBMS_OUTPUT.PUT_LINE('Updated Person: '||:old.person_id||' : '||CASE WHEN :old.blood_type is NULL OR :old.rh_type is NULL THEN 'Empty' ELSE CONCAT(:old.blood_type,:old.rh_type) END||' to '||:new.blood_type||:new.rh_type);
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
END IF;
END;
/

--Execution
Execute update_blood_type('S00020','B-')

/* Stored procedure 5 */
---------------------------------------------------------
--5 Update all unpaid overdue bill’s due date and adding penalty.
---------------------------------------------------------
-- Stored procedure - show unpaid
CREATE OR REPLACE PROCEDURE show_unpaid
IS
	CURSOR pointers is 
		SELECT b.bill_id AS ID, b.amount AS Amount,b.description AS Description, pt.patient_id
		FROM patient pt, person p, bill b, admission a
		WHERE b.admission_id=a.admission_id
		AND a.patient_id=pt.patient_id 
		AND pt.patient_id=p.person_id
		AND b.payment_date is null
		AND TRUNC(SYSDATE-b.due_date)>0;
BEGIN
		DBMS_OUTPUT.PUT_LINE('Due bill');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		FOR ptr IN pointers
		LOOP 
			DBMS_OUTPUT.PUT_LINE(ptr.id||' '||ptr.amount||' | '||ptr.patient_id||' '|| ptr.description);
		END LOOP;
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
COMMIT;
END;
/
-- Stored procedure (main)- update
CREATE OR REPLACE PROCEDURE renew_bill_due_date
IS 
	times Number;
	counti Number;
	temp VARCHAR(70);
	CURSOR pointers is 
		SELECT bill_id,due_date,amount,description,payment_date FROM bill;
BEGIN
		show_unpaid;
		DBMS_OUTPUT.PUT_LINE('Update:');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		FOR ptr IN pointers
		LOOP 
			IF ptr.payment_date IS NULL AND SYSDATE>ptr.due_date THEN
				counti:=INSTR(ptr.description,'*');
				IF counti>0 THEN
					counti:=INSTR(ptr.description,'*');
					times:=TO_NUMBER(SUBSTR(ptr.description,0,counti));
					temp:=SUBSTR(ptr.description,counti,60);
				ELSE
					temp:=CONCAT('*',ptr.description);
					times:=0;
				END IF;
				times:=times+1;
				temp:=SUBSTR(CONCAT(times,temp),1,60);
				UPDATE bill SET due_date=SYSDATE+14, amount=ptr.amount*105/100, description=temp WHERE bill_id=ptr.bill_id;
				DBMS_OUTPUT.PUT_LINE(ptr.bill_id||' RM'||TO_CHAR(ptr.amount,'99999999.99')||'--> RM'||TO_CHAR(ptr.amount*105/100,'99999999.99')||' '||TO_CHAR(times-1)||'->'||TO_CHAR(times));
			END IF;
		END LOOP;
COMMIT;
END;
/

--Execution
EXECUTE renew_bill_due_date

---------------------------------------------------------------------------------------
--                                      FUNCTION                                     --
---------------------------------------------------------------------------------------
/* Function 1 */
---------------------------------------------------------
--1 Calculate and list out total available bed in all room or specify room
---------------------------------------------------------
--Function
CREATE OR REPLACE FUNCTION total_bed_available
(
	roomid VARCHAR
)
RETURN NUMBER
IS
bedcount number(8); 
temp VARCHAR(4);
CURSOR pointers is 
	SELECT b.bed_id AS Bed, r.room_id AS Room, r.room_name AS RName
	FROM bed b, room r
	WHERE b.room_id=r.room_id
	MINUS
	SELECT b.bed_id AS Bed, r.room_id AS Room, r.room_name AS RName
	FROM admission a, bed b, room r
	WHERE a.bed_id = b.bed_id
	AND b.room_id=r.room_id
	AND a.discharge_date IS NULL
	AND a.status IN ('I','R');
BEGIN
	bedcount:=0;
	temp:=' ';
	DBMS_OUTPUT.PUT_LINE('Room               |    Bed Available');
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	FOR ptr IN pointers
	LOOP
	IF UPPER(roomid) = 'ALL' THEN
		IF temp=' ' THEN
			DBMS_OUTPUT.PUT_LINE(' ');
		ELSIF temp!=ptr.Room THEN
			DBMS_OUTPUT.PUT_LINE('****');
		END IF;
		temp:=ptr.Room;
		bedcount:=bedcount+1;
		DBMS_OUTPUT.PUT_LINE(ptr.Room||' - '||ptr.RName||'             '||ptr.Bed);
	ELSIF roomid = ptr.Room THEN
		bedcount:=bedcount+1;
		DBMS_OUTPUT.PUT_LINE(ptr.Room||' - '||ptr.RName||'             '||ptr.Bed);
	END IF;
	END LOOP;
	RETURN bedcount;
END;
/
--Execution
DECLARE
	totalbed number(8);
	query VARCHAR(6);
BEGIN
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	DBMS_OUTPUT.PUT_LINE('Available bed query');
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	query:='&roomid_or_ALL';
	IF UPPER(query)='ALL' THEN
		totalbed:=total_bed_available(query);
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('All bed in hospital available are total of '||TO_NUMBER(totalbed,'9999'));
	ELSIF REGEXP_LIKE(query,'^R\d{3}$') THEN
		totalbed:=total_bed_available(query);
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('All bed in room with ID '||query||' have total of '||TO_NUMBER(totalbed,'9999'));
	ELSE
		DBMS_OUTPUT.PUT_LINE('Invalid input. Key in again');
END IF; 
END;
/

--TRY:
--R011
--ALL

/* Function 2 */
---------------------------------------------------------
--2 Calculate the total staff payment
---------------------------------------------------------
--Function
CREATE OR REPLACE FUNCTION total_staff_payment
(
	categories VARCHAR, --<e admin staff, n nurse, d doctor>
	duration Integer, --<1 -1month, 2 -2months, etc>
	epf Number  --Percentage
)
RETURN Number
IS
total Number;
totale Number;
totaln Number;
totald Number;
CURSOR nptr is 
		SELECT employee_id, salary FROM employee, nurse WHERE employee_id=nurse_id AND leave_date is null;
CURSOR dptr is 
		SELECT employee_id, salary FROM employee, doctor WHERE employee_id=doctor_id AND leave_date is null;
CURSOR eptr is 
		SELECT employee_id, salary FROM employee WHERE leave_date is null MINUS 
		SELECT employee_id, salary FROM employee, doctor WHERE employee_id=doctor_id AND leave_date is null MINUS
		SELECT employee_id, salary FROM employee, nurse WHERE employee_id=nurse_id AND leave_date is null;
BEGIN
	total:=0;
	totale:=0;
	totaln:=0;
	totald:=0;
	IF INSTR(categories,'e')!=0 THEN
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('Payment to: admin staff');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		FOR e IN eptr
		LOOP 
			DBMS_OUTPUT.PUT_LINE(e.employee_id||'--> RM'||TRIM(TO_CHAR(e.salary,'999999999.99')));
			totale:=totale+e.salary;
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('Total admin payment --> RM'||TRIM(TO_CHAR(totale,'999999999.99')));
		totale:=totale+totale*epf/100;
		DBMS_OUTPUT.PUT_LINE('Total admin payment including epf ('||epf||'%) --> RM'||TRIM(TO_CHAR(totale,'999999999.99')));
		totale:=totale*duration;
		DBMS_OUTPUT.PUT_LINE('Total admin payment including epf ('||duration||'months(s)) --> RM'||TRIM(TO_CHAR(totale,'999999999.99')));
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	END IF;
	
	IF INSTR(categories,'n')!=0 THEN
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('Payment to: nurse staff');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		FOR n IN nptr
		LOOP 
			DBMS_OUTPUT.PUT_LINE(n.employee_id||'--> RM'||TRIM(TO_CHAR(n.salary,'999999999.99')));
			totaln:=totaln+n.salary;
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('Total nurse payment --> RM'||TRIM(TO_CHAR(totaln,'999999999.99')));
		totaln:=totaln+totaln*epf/100;
		DBMS_OUTPUT.PUT_LINE('Total nurse payment including epf ('||epf||'%) --> RM'||TRIM(TO_CHAR(totaln,'999999999.99')));
		totaln:=totaln*duration;
		DBMS_OUTPUT.PUT_LINE('Total nurse payment ('||duration||'months(s)) --> RM'||TRIM(TO_CHAR(totaln,'999999999.99')));
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	END IF;
	
	IF INSTR(categories,'d')!=0 THEN
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		DBMS_OUTPUT.PUT_LINE('Payment to: doctor staff');
		DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
		FOR d IN dptr
		LOOP 
			DBMS_OUTPUT.PUT_LINE(d.employee_id||'--> RM'||TRIM(TO_CHAR(d.salary,'999999999.99')));
			totald:=totald+d.salary;
		END LOOP;
		DBMS_OUTPUT.PUT_LINE('Total doctor payment --> RM'||TRIM(TO_CHAR(totald,'999999999.99')));
		totald := totald+totald*epf/100;
		DBMS_OUTPUT.PUT_LINE('Total doctor payment including epf ('||epf||'%) --> RM'||TRIM(TO_CHAR(totald,'999999999.99')));
		totald := totald*duration;
		DBMS_OUTPUT.PUT_LINE('Total doctor payment ('||duration||'months(s)) --> RM'||TRIM(TO_CHAR(totald,'999999999.99')));
	END IF;
	total:=totale+totaln+totald;
   RETURN total;
END;
/
--Execution
DECLARE
	total number(10,2);
BEGIN
	total := total_staff_payment('edn',2,11);
	
	DBMS_OUTPUT.PUT_LINE(rpad('*',80,'*'));
	DBMS_OUTPUT.PUT_LINE('Total payment (2months(s),11 % epf) --> RM'||TRIM(TO_CHAR(total,'999999999.99')));
	DBMS_OUTPUT.PUT_LINE(rpad('*',80,'*'));
END;
/

/* Function 3 */
---------------------------------------------------------
--3 Calculate the most preferable doctor-department by public
---------------------------------------------------------
--Function - count each department have the high number of services provided
CREATE OR REPLACE FUNCTION department_count
(
	depart VARCHAR
)
RETURN NUMBER
IS
total Number;
CURSOR pointers is 
	SELECT s.doctor_id AS Did, p.first_name AS Dfn , p.last_name AS Dln, COUNT(s.doctor_id) AS scount
	FROM servicerecord s, doctor d, employee e, person p
	WHERE s.doctor_id=d.doctor_id
	AND d.doctor_id=e.employee_id
	AND e.employee_id=p.person_id
	AND e.department_id=depart
	GROUP BY s.doctor_id,p.first_name,p.last_name
	ORDER BY 1 ASC;
BEGIN
	total:=0;
	DBMS_OUTPUT.PUT_LINE('Doctor       | Count');
	DBMS_OUTPUT.PUT_LINE(rpad('-',80,'-'));
	FOR ptr IN pointers
	LOOP
	DBMS_OUTPUT.PUT_LINE(ptr.Did||'-'||ptr.Dfn||' '||ptr.Dln||'---->'||ptr.scount);
	total:=total+ptr.scount;
	END LOOP;
	RETURN total;
END;
/

--Function - Main 
--Sort out the most preferable department by public after get the return value from department_count function
CREATE OR REPLACE FUNCTION most_preferable_department
RETURN VARCHAR
IS
temp Number;
compare Number;
text VARCHAR(1000);
total Number;
CURSOR pointers is 
	SELECT DISTINCT dt.department_id AS deptid, dt.name AS dname
	FROM doctor d, employee e, department dt
	WHERE d.doctor_id=e.employee_id
	AND e.department_id=dt.department_id
	ORDER BY 1 ASC;
BEGIN
	text:='';
	compare:=0;
	total:=0;
	DBMS_OUTPUT.PUT_LINE(rpad('*',120,'*'));
	FOR ptr IN pointers
	LOOP
	temp:=department_count(ptr.deptid);
	total:=total+temp;
	DBMS_OUTPUT.PUT_LINE('--');
	DBMS_OUTPUT.PUT_LINE('Summary: '||ptr.deptid||'-'||ptr.dname||'       '||TO_CHAR(temp));
	IF compare<temp THEN
		compare:=temp;
		text:=CONCAT(CONCAT(ptr.deptid,'-'),ptr.dname);
	ELSIF compare=temp THEN
		text:= CONCAT(text,CONCAT(' | ',CONCAT(CONCAT(ptr.deptid,'-'),ptr.dname)));
	END IF;
	DBMS_OUTPUT.PUT_LINE(rpad('*',120,'*'));
	END LOOP;
	text:= CONCAT(CONCAT(text,TO_CHAR(compare)), CONCAT(CONCAT(' (',TRIM(TO_CHAR(compare/total*100,'99999.99'))),'%)'));
	return text;
END;
/

--Execution
BEGIN
	DBMS_OUTPUT.PUT_LINE(rpad('*',120,'*'));
	DBMS_OUTPUT.PUT_LINE('The most preferable department is ' ||TO_CHAR(most_preferable_department));
	DBMS_OUTPUT.PUT_LINE(rpad('*',120,'*'));
END;
/

/* Function 4 */
---------------------------------------------------------
--4 Calculate and analyze diseases among different age interval function
---------------------------------------------------------
--Function -Return disease number in record
CREATE OR REPLACE FUNCTION disease_count
(
	diseaseid VARCHAR,
	interval_start Number,
	interval_end Number
)
RETURN NUMBER
IS
	counts Number;
	CURSOR pointers is 
		SELECT g.disease_id ||'-'|| g.name AS Diseases, TRUNC((SYSDATE-p.birth_date)/365.25)  AS AGE, COUNT(*) AS times
		FROM disease g, servicerecord s, patient pt, person p, admission a
		WHERE g.disease_id = s.disease_id
		AND s.admission_id = a.admission_id
		AND a.patient_id = pt.patient_id
		AND pt.patient_id = p.person_id
		AND g.disease_id = diseaseid
		GROUP BY g.name,p.birth_date,g.disease_id, a.admission_id
		ORDER BY g.disease_id,age;
BEGIN
	counts:=0;
	FOR ptr IN pointers
	LOOP
		IF ptr.age >= interval_start AND ptr.age<interval_end THEN
			counts := counts+ptr.times;
		END IF;
	END LOOP;
	return counts;
END;
/

--Execution with for loop
DECLARE
	a Number;
	diseaseid VARCHAR(6);
	diseasename VARCHAR(20);
	target Number;
	total Number;
BEGIN
	a := 0;
	diseaseid:='&Disease_id';
	SELECT d.name into diseasename FROM disease d WHERE d.disease_id=diseaseid;
	
	
	SELECT COUNT(*) into total
	FROM servicerecord s
	WHERE s.disease_id is not null;
		
	SELECT COUNT(*) into target
	FROM servicerecord s
	WHERE s.disease_id = diseaseid;
	DBMS_OUTPUT.PUT_LINE(rpad('-',32,'-'));
	DBMS_OUTPUT.PUT_LINE('Disease: '|| diseasename);
	DBMS_OUTPUT.PUT_LINE('Percentage in service record provided to other disease: '|| TO_CHAR(target/total*100,'9999999.990')||'% ('||target||'/'||total||')');
	DBMS_OUTPUT.PUT_LINE(rpad('-',32,'-'));
	DBMS_OUTPUT.PUT_LINE('| Age interval  | Disease Count |');
	DBMS_OUTPUT.PUT_LINE(rpad('-',32,'-'));
	WHILE a < 100 LOOP
		DBMS_OUTPUT.PUT_LINE('| '||TO_CHAR(a,'999')||' --> '||TO_CHAR(a+5,'999')||'  |  '||
		CASE WHEN TRIM(TO_CHAR(disease_count(diseaseid,a,a+5),'99999'))='0'THEN '------' ELSE TO_CHAR(disease_count(diseaseid,a,a+5),'99999')END||'     |');
		a := a+5;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(rpad('-',32,'-'));
END;
/

--Try
--G00003

/* Function 5 */
---------------------------------------------------------
--5 Count the nurse which not perform any service in a time. (Available nurse)
---------------------------------------------------------
--Function
CREATE OR REPLACE FUNCTION nurse_count
(
	ctime TIMESTAMP
)
RETURN NUMBER
IS
	counts Number;
	CURSOR pointers is 
		SELECT p.person_id AS pid, p.first_name AS pfn,p.last_name AS pln
		FROM person p,nurse n, employee e
		WHERE n.nurse_id=e.employee_id
		AND e.employee_id=p.person_id
		AND e.leave_date IS NULL
		MINUS
		SELECT p.person_id, p.first_name,p.last_name
		FROM nurse n, employee e, person p, servicerecord s
		WHERE  s.nurse_id = n.nurse_id 
		AND n.nurse_id=e.employee_id
		AND e.employee_id=p.person_id
		AND e.leave_date IS NULL
		AND ctime > s.start_time
		AND ctime < CASE WHEN s.end_time is null then SYSTIMESTAMP+1 ELSE s.end_time END;
BEGIN		
	counts:=0;
	DBMS_OUTPUT.PUT_LINE('Nurse');
	DBMS_OUTPUT.PUT_LINE(rpad('-',40,'-'));
	FOR ptr IN pointers
	LOOP
		counts:=counts+1;
		DBMS_OUTPUT.PUT_LINE(ptr.pid||' '||ptr.pfn||' '||ptr.pln);
	END LOOP;
	return counts;
END;
/

--Execution - For loop with array
DECLARE
   type array_t is varray(6) of Number;
   array array_t := array_t(-30,-10,0,20,40,48);
BEGIN
	FOR i in 1..array.count LOOP
		DBMS_OUTPUT.PUT_LINE(rpad('-',40,'-'));
		DBMS_OUTPUT.PUT_LINE('There are total of '||nurse_count(SYSTIMESTAMP + TO_NUMBER(array(i)/24))||' nurse(s) available in '||TO_CHAR(SYSTIMESTAMP + TO_NUMBER(array(i)/24),'YYYY-MM-DD HH:MI:SS pm'));
	END LOOP;
	DBMS_OUTPUT.PUT_LINE(rpad('-',40,'-'));
END;
/


--END

-------------------------------------------------------------------------------------
--                              Tan Jing Jie 1804560                               --
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--                Any issue feel free contact me at +6011-3810 0852                --
-------------------------------------------------------------------------------------

