--  Patient Detail Report
-- SET @start_date = '#startDate#';
-- SET @end_date = '#endDate#';
SET @start_date = str_to_date('2022-07-01', '%Y-%m-%d'); 
SET @end_date   = str_to_date('2024-01-01', '%Y-%m-%d');

drop temporary table if exists TMP_patient_summary;
create temporary table TMP_patient_summary 
( rowid int,
  mylabel varchar(50),
  mylabel_value varchar(10)
);

drop temporary table if exists TMP_patient_details;
create temporary table TMP_patient_details as
Select 
  p.patient_identifier                as 'Patient_identifier'
, p.patient_name                      as 'Patient_Name'
, p.patient_birthdate                 as 'DOB'
, p.patient_gender                    as 'gender'
, p.type_of_cleft                     as 'Type_of_Cleft'
, p.treatment_plan_exists             as 'Treatment_Plan_exists'
,if(p.patient_create_date>=@start_date,'N','E')  as 'isNewPatient'                -- If Patient Registration date = or > beginning of reporting period, set to "N". Else "E"
, if(p.is_closed_Discharge,'C',if(p.is_closed_Lost_Contact,"D","A")) as 'Status'
											-- Patient Status A = Active D = Drop Out C = Completed all treatment
                                            -- Based on Patient Case Status on the Patient Treatment Plan OBS form. 
                                            -- If Patient Case Status "Is Closed - Discharge",  set to "C";  If "Is Closed - Lost Contact", set to "D" else set to "A"
, Case 
    WHEN p.Current_Education_Level = 'Not old enough for school'             THEN 'N'
    WHEN p.Current_Education_Level = 'Primary school-aged - not in school'   THEN 'O'
    WHEN p.Current_Education_Level = 'Attending primary school'              THEN 'E'
    WHEN p.Current_Education_Level = 'Completed primary school'              THEN 'G'
    WHEN p.Current_Education_Level = 'Secondary school-aged - not in school' THEN 'O'
    WHEN p.Current_Education_Level = 'Attending secondary school'            THEN 'E'
    WHEN p.Current_Education_Level = 'Completed secondary school'            THEN 'G'
    WHEN p.Current_Education_Level = 'Attending college or university'       THEN 'E'
    WHEN p.Current_Education_Level = 'Completed college or university'       THEN 'G'
    ELSE ''
  END
  AS 'School_Status' 
  ,"|" as 'Extras'
, p.Current_Education_Level
, p.registration_date
, p.patient_create_date
, p.patient_age_at_registration
, p.patient_age_now
, p.is_closed_Discharge
, p.is_closed_Lost_Contact
from RPT_View_Patient_Detail p
WHERE p.internal_patient_id in 
(select distinct v.patient_id 
   from visit v 
  where v.date_stopped BETWEEN @start_date AND @end_date
)
;
SET @total_patient_cnt = (select count(*) from TMP_patient_details);

insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  1, '# of  Unique Patients', count(*) from TMP_patient_details t1 ; 
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  2, '','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  3, '    GENDER','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  4, '# of Males',(select count(*) from TMP_patient_details t2 where t2.gender="M") ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  5, '# of Females',(select count(*) from TMP_patient_details t where t.gender="F") ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  6, '# of Other' ,(select count(*) from TMP_patient_details t where (t.gender<>"M" and t.gender<>"F") or t.gender is null) ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  7, '','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  8, "Average Age",(select format(avg(t.patient_age_now),1) from TMP_patient_details t);
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select  9, '','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 10, '    New versus Established','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 11, '# of New Patients',(select count(*) from TMP_patient_details t where t.isNewPatient="N") ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 12, '# of Established Patients',(select count(*) from TMP_patient_details t where t.isNewPatient="E") ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 13, '','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 14, '    Treatment Plans','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 15, ' of Patients with TP',(select count(*) from TMP_patient_details t where t.Treatment_Plan_exists="Y") ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 16, ' of Patients without TP',(select count(*) from TMP_patient_details t where t.Treatment_Plan_exists="N" or t.Treatment_Plan_exists is null) ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 17, '','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 18, '    Patient Status','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 19, '# of Patients with status = Active',(select count(*) from TMP_patient_details t where t.Status="A" ) ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 20, '# of Patients with status = Dropout',(select count(*) from TMP_patient_details t where t.Status="D" ) ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 21, '# of Patients with status = Completed',(select count(*) from TMP_patient_details t where t.Status="C" ) ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 22, '','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 23, '# of Active Patients as a % of total',concat(format(100*(select count(*) from TMP_patient_details t where t.Status="A" )/@total_patient_cnt,0),"%") ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 24, '','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 25, '    School Status','' ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 26, '# of Patients with school = Enrolled',(select count(*) from TMP_patient_details t where t.School_Status="E" ) ;
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 27, '# of Patients with school = Graduated',(select count(*) from TMP_patient_details t where t.School_Status="G" ) ; 
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 28, '# of Patients with school = Not School Age',(select count(*) from TMP_patient_details t where t.School_Status="N" ) ; 
insert into TMP_patient_summary (rowid, mylabel, mylabel_value) select 29, '# of Patients with school = Out of School',(select count(*) from TMP_patient_details t where t.School_Status="O" ) ; 

select mylabel, mylabel_value from TMP_patient_summary order by rowid;
;
drop temporary table if exists TMP_patient_details;	
drop temporary table if exists TMP_patient_summary;