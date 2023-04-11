-- YCC_function_Display_Age:

DROP FUNCTION IF EXISTS YCC_function_Display_Age;

DELIMITER $$
CREATE FUNCTION YCC_function_Display_Age(
    p_DOB date,
    p_as_of_Date date) 
    RETURNS VARCHAR(255)
    DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(255);
    Declare Age_in_Integer_Months int;
    Declare Age_in_Fractional_Years  float;
    Declare Age_in_Years_Month_Part  int;
    Declare Age_in_Years_Year_Part  int;

	select   TIMESTAMPDIFF(MONTH, p_DOB, p_as_of_date)                INTO Age_in_Integer_Months   ;
	select   0.0 + Age_in_Integer_Months/12.0                           INTO Age_in_Fractional_Years ;
	select  truncate(Age_in_Fractional_Years,0)                    INTO Age_in_Years_Year_Part  ;
	select round(Age_in_Integer_Months - Age_in_Years_Year_Part*12,0) INTO Age_in_Years_Month_Part ;
	select  CASE   
				WHEN Age_in_Integer_Months <=12 THEN concat(FORMAT(Age_in_Integer_Months,0), ' Month',if(Age_in_Integer_Months=1,'','s'))
				WHEN Age_in_Integer_Months >12 and Age_in_Integer_Months < 5*12 THEN CONCAT(FORMAT(Age_in_Years_Year_Part,0), ' Year',if(Age_in_Years_Year_Part=1,' ','s '), format(Age_in_Years_Month_Part,0), ' Month',if(Age_in_Years_Month_Part=1,'','s'))
				ELSE CONCAT(format(Age_in_Years_Year_Part,0), ' Years')
			END
		into result
    ;

/* 	 -- debug
select   concat(result, ', ', p_DOB, ', ', p_as_of_Date, ', ', Age_in_Integer_Months , ', ' , format(Age_in_Fractional_Years,2), ', ' , Age_in_Years_Year_Part , ', ' , Age_in_Years_Month_Part)
  into result;
*/
    RETURN result;
END$$
DELIMITER ;

/*
select           YCC_function_Display_Age('2000/1/1'  ,'2000/1/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2000/2/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2000/3/1')
union all select YCC_function_Display_Age('2000/1/1'  ,'2000/4/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2000/11/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2000/12/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2001/1/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2001/2/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2001/3/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2001/4/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2001/12/8')
union all select YCC_function_Display_Age('2000/1/1'  ,'2002/1/1')
union all select YCC_function_Display_Age('2000/1/1'  ,'2002/2/1')
union all select YCC_function_Display_Age('2000/1/1'  ,'2005/1/8')
;

          select '2000/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/1/8')
union all select '2000/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/2/8')
union all select '2000/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/3/8')
union all select '2000/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/4/8')
union all select '2000/5/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/5/8')
union all select '2000/6/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/6/8')
union all select '2000/7/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/7/8')
union all select '2000/8/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/8/8')
union all select '2000/9/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/9/8')
union all select '2000/10/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/10/8')
union all select '2000/11/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/11/8')
union all select '2000/12/8',  YCC_function_Display_Age('2000/1/1'  ,'2000/12/8')
union all select '2001/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/1/8')
union all select '2001/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/2/8')
union all select '2001/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/3/8')
union all select '2001/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/4/8')
union all select '2001/5/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/5/8')
union all select '2001/6/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/6/8')
union all select '2001/7/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/7/8')
union all select '2001/8/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/8/8')
union all select '2001/9/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/9/8')
union all select '2001/10/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/10/8')
union all select '2001/11/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/11/8')
union all select '2001/12/8',  YCC_function_Display_Age('2000/1/1'  ,'2001/12/8')
union all select '2002/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/1/8')
union all select '2002/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/2/8')
union all select '2002/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/3/8')
union all select '2002/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/4/8')
union all select '2002/5/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/5/8')
union all select '2002/6/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/6/8')
union all select '2002/7/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/7/8')
union all select '2002/8/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/8/8')
union all select '2002/9/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/9/8')
union all select '2002/10/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/10/8')
union all select '2002/11/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/11/8')
union all select '2002/12/8',  YCC_function_Display_Age('2000/1/1'  ,'2002/12/8')
union all select '2003/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/1/8')
union all select '2003/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/2/8')
union all select '2003/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/3/8')
union all select '2003/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/4/8')
union all select '2003/5/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/5/8')
union all select '2003/6/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/6/8')
union all select '2003/7/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/7/8')
union all select '2003/8/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/8/8')
union all select '2003/9/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/9/8')
union all select '2003/10/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/10/8')
union all select '2003/11/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/11/8')
union all select '2003/12/8',  YCC_function_Display_Age('2000/1/1'  ,'2003/12/8')
union all select '2004/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/1/8')
union all select '2004/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/2/8')
union all select '2004/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/3/8')
union all select '2004/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/4/8')
union all select '2004/5/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/5/8')
union all select '2004/6/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/6/8')
union all select '2004/7/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/7/8')
union all select '2004/8/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/8/8')
union all select '2004/9/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/9/8')
union all select '2004/10/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/10/8')
union all select '2004/11/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/11/8')
union all select '2004/12/8',  YCC_function_Display_Age('2000/1/1'  ,'2004/12/8')
union all select '2005/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/1/8')
union all select '2005/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/2/8')
union all select '2005/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/3/8')
union all select '2005/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/4/8')
union all select '2005/5/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/5/8')
union all select '2005/6/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/6/8')
union all select '2005/7/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/7/8')
union all select '2005/8/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/8/8')
union all select '2005/9/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/9/8')
union all select '2005/10/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/10/8')
union all select '2005/11/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/11/8')
union all select '2005/12/8',  YCC_function_Display_Age('2000/1/1'  ,'2005/12/8')
union all select '2006/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/1/8')
union all select '2006/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/2/8')
union all select '2006/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/3/8')
union all select '2006/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/4/8')
union all select '2006/5/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/5/8')
union all select '2006/6/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/6/8')
union all select '2006/7/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/7/8')
union all select '2006/8/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/8/8')
union all select '2006/9/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/9/8')
union all select '2006/10/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/10/8')
union all select '2006/11/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/11/8')
union all select '2006/12/8',  YCC_function_Display_Age('2000/1/1'  ,'2006/12/8')
union all select '2007/1/8',  YCC_function_Display_Age('2000/1/1'  ,'2007/1/8')
union all select '2007/2/8',  YCC_function_Display_Age('2000/1/1'  ,'2007/2/8')
union all select '2007/3/8',  YCC_function_Display_Age('2000/1/1'  ,'2007/3/8')
union all select '2007/4/8',  YCC_function_Display_Age('2000/1/1'  ,'2007/4/8')

*/
;
CREATE or replace VIEW YCC_view_RPT_Patient_Detail AS
select 
 pid1.identifier AS 'patient_identifier'
,concat(coalesce(per.given_name,''),' ',coalesce(per.middle_name,''),' ',coalesce(per.family_name,'')) AS 'patient_name'
,date_format(p.birthdate, "%d-%b-%Y") as 'patient_birthdate'
,p.date_created AS 'patient_create_date'
,YCC_function_Display_Age(p.birthdate,pa.date_created) AS 'patient_age_at_registration'
,YCC_function_Display_Age(p.birthdate,      curdate()) As 'patient_age_now'
,p.gender AS 'patient_gender'
, (select lc.value_coded_name from YCC_view_obs_last_coded_value lc where lc.person_id=pa.patient_id and lc.concept_name='Cleft Type') AS 'type_of_cleft'      -- diagnosis short name: CL CP or CLP
, coalesce((select max('Y') from YCC_view_obs ro where ro.person_id = pa.patient_id and ro.form_name='Patient Treatment Plan'),'N')  
   AS 'treatment_plan_exists'       -- If Patient Treatment Plan OBS form exists, set to "Y". Else "N"
-- ,if(p.date_created>=@start_date,'N','E')  as 'new_patient'                -- If Patient Registration date = or > beginning of reporting period, set to "N". Else "E"
-- the following two values determine "patient_status":
, (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Discharge') AS 'is_closed_Discharge'
, (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Lost Contact') AS 'is_closed_Lost_Contact'
-- ,'' AS 'patient_status'                     -- Patient Status A = Active D = Drop Out C = Completed all treatment
--                                             -- Based on Patient Case Status on the Patient Treatment Plan OBS form. 
--                                             -- If Patient Case Status "Is Closed - Discharge",  set to "C";  If "Is Closed - Lost Contact", set to "D" else set to "A"
, (select lc.value_coded_name from YCC_view_obs_last_coded_value lc where lc.person_id=pa.patient_id and lc.concept_name='Current Education Level') AS 'Current_Education_Level'      -- diagnosis short name: CL CP or CLP
-- ,'' AS 'school_status'       -- School status E=Enrolled G=Graduated N=Not school aged O=Out of school (if school-aged)
                             -- From "Current Education Level" on most recent patient Visit:
							 -- If Current Education Level is:
							 -- "Not old enough for school" set to "N"
							 -- "Primary school-aged - not in school" set to O
							 -- "Attending primary school" set to E
							 -- "Completed primary school" set to G
							 -- "Secondary school-aged - not in school" set to O
							 -- "Attending secondary school" set to E
							 -- "Completed secondary school" set to G
							 -- "Attending college or university" set to E
							 -- "Completed college or univerity" set to G

,DATE_FORMAT(p.date_created, "%d-%b-%Y")  AS 'registration_date'
,pa.voided AS 'patient_voided'
,p.voided AS 'person_voided'
,per.voided AS 'person_name_voided'
,pa.patient_id as 'internal_Patient_id'
from patient pa 
left outer join person_name per on pa.patient_id=per.person_id
left outer join person p on pa.patient_id=p.person_id 
left outer join patient_identifier pid1 on pa.patient_id=pid1.patient_id and pid1.identifier_type=3 -- 3 = patient_id 4 = Yekatit OPD
where p.voided = 0 and pa.voided = 0
;
 select * from YCC_view_RPT_Patient_Detail ; --  WHERE patient_create_date BETWEEN date('1/1/2000') AND DATE('1/1/2025');      -- '#startDate#' and '#endDate#';
create or replace view YCC_view_obs as select 
 obs.obs_id
,obs.person_id
,obs.concept_id
,obs.encounter_id
,obs.obs_datetime
,obs.location_id   as obs_location_id
,obs.obs_group_id
-- ,obs.value_group_id    -- not used?
,obs.value_coded
,(select cn.name from concept_name cn where cn.concept_id=obs.value_coded and cn.locale='en' and cn.concept_name_type='FULLY_SPECIFIED' and cn.voided=0) as value_coded_name
-- ,obs.value_coded_name_id   -- not used?
,obs.value_drug    -- not used?
,obs.value_datetime
,obs.value_numeric
,obs.value_modifier   -- not used?
,obs.value_text
,obs.value_complex
,obs.comments
,obs.date_created as obs_date_created
-- ,obs.voided  as obs_voided           -- YES this is used!!!
,obs.previous_version
,obs.form_namespace_and_path
,substring_index(substring(obs.form_namespace_and_path,8,200),".",1 ) as 'form_name'
,obs.status                       -- FINAL or AMENDED
-- ,obs.interpretation            -- not used?
-- ,c.retired as 'Concept_retired'
,(select cn.name from concept_name cn where cn.concept_id=obs.concept_id and cn.locale='en' and cn.voided=0 and cn.concept_name_type='FULLY_SPECIFIED' and cn.voided=0) 'concept_name'
-- ,c.short_name                 -- not used?
-- ,c.description                   -- not used?
-- ,c.form_text
,c.datatype_id as concept_datatype_id
,(select dt.name from concept_datatype dt where dt.concept_datatype_id = c.datatype_id) 'datatype_name'
,c.class_id as concept_class_id
,c.is_set   as concept_is_set
,e.encounter_datetime
,e.encounter_type
,e.location_id as encounter_location_id
,e.visit_id  as visit_id
,v.visit_type_id as visit_type_id
,v.date_started  as visit_date_started
,v.date_stopped  as visit_date_stopped
,v.location_id   as visit_location_id
from obs
Left join concept c on c.concept_id = obs.concept_id
Left join encounter e on e.encounter_id = obs.encounter_id
left join visit v on v.visit_id = e.visit_id
where obs.voided = 0
  and c.retired = 0
  and e.voided = 0
;
-- select * from YCC_view_obs o 
-- where o.concept_name in ('Current Education Level' , 'xPatient Case Status')
-- or o.concept_id = 4654 or obs_group_id=4654 ;
-- select o.concept_name,count(*) from YCC_view_obs o group by o.concept_name order by 1;

create or replace view YCC_view_obs_last_boolean_value as
select o.obs_id,o.person_id, o.concept_name, o.value_coded as value_boolean, o.value_coded_name, o.concept_datatype_id, o.datatype_name
from YCC_view_obs o 
where o.concept_datatype_id=10  -- name='Boolean'      -- type 10 is Boolean
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id = 10)
-- order by o.person_id, o.concept_name, o.value_coded_name
;

-- select * from YCC_obs_last_Boolean_value where person_id=70 ;
-- select * from concept_datatype;
create or replace view YCC_view_obs_last_coded_value as
select o.obs_id,o.person_id, o.concept_name, o.value_coded_name
from YCC_view_obs o 
where o.concept_datatype_id = 2  -- datatype_name='Coded'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id=2)
-- order by o.person_id, o.concept_name, o.value_coded_name
;
-- select * from YCC_view_obs_last_coded_value;
-- select * from YCC_view_obs_last_coded_value where person_id=70 ;
-- select * from concept_datatype;
create or replace view YCC_view_obs_last_complex_value as
select o.obs_id,o.person_id, o.concept_name, o.value_complex
from YCC_view_obs o 
where o.concept_datatype_id = 13  -- datatype_name='Complex'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id = 13)
order by o.person_id, o.concept_name, o.value_coded_name;

-- select * from YCC_obs_last_Complex_value ; -- where person_id=70 ;
-- select * from concept_datatype;
create or replace view YCC_view_obs_last_date_value as
select o.obs_id,o.person_id, o.concept_name, o.value_datetime
from YCC_view_obs o 
where o.concept_datatype_id = 6   -- datatype_name='Date'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id = 6)
-- order by o.person_id, o.concept_name, o.value_coded_name
;

-- select * from YCC_view_obs_last_Date_value where person_id=70 ;
-- select * from concept_datatype;
create or replace view YCC_view_obs_last_datetime_value as
select o.obs_id,o.person_id, o.concept_name, o.value_datetime
from YCC_view_obs o 
where o.concept_datatype_id = 8   -- datatype_name='Datetime'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id = 8)
-- order by o.person_id, o.concept_name, o.value_coded_name
;

-- select * from YCC_obs_last_Datetime_value  ;
-- select * from concept_datatype;
-- this not needed? returns a set or collection....
create or replace view YCC_view_obs_last_NA_value as -- this not needed? returns a set or collection....
select o.obs_id as ID, o.person_id as Person_id_id, o.concept_name as ConceptName, o.*
from YCC_view_obs o 
where o.concept_datatype_id = 4   -- datatype_name='N/A'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id = 4)
;
-- order by o.person_id, o.concept_name, o.value_coconcept_datatype_id = 4ded_name;
-- select * from YCC_view_obs_last_NA_value where person_id=70 ;
-- select * from concept_datatype;
create or replace view YCC_view_obs_last_numeric_value as
select o.obs_id,o.person_id, o.concept_name, o.value_numeric
from YCC_view_obs o 
where o.concept_datatype_id = 1   -- datatype_name='Numeric'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id=1)
;

-- select * from YCC_obs_last_Numeric_value where person_id=70 ;
-- select * from concept_datatype;
create or replace view YCC_view_obs_last_text_value as
select o.obs_id,o.person_id, o.concept_name, o.value_text
from YCC_view_obs o 
where o.concept_datatype_id = 3   -- datatype_name='Text'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id=3)
;
-- order by o.person_id, o.concept_name, o.value_coded_name;

-- select * from YCC_view_obs_last_Text_value where person_id=70 ;
create or replace view YCC_view_obs_last_time_value as
select o.obs_id,o.person_id, o.concept_name, o.value_datetime
from YCC_view_obs o 
where o.concept_datatype_id = 7   -- datatype_name='Time'
  and o.obs_id = (select max(oo.obs_id) 
                    from YCC_view_obs oo 
				   where oo.person_id=o.person_id 
                     and oo.concept_name=o.concept_name 
                     -- and oo.value_coded_name=o.value_coded_name 
                     and oo.concept_datatype_id = 7)
-- order by o.person_id, o.concept_name, o.value_coded_name
;

-- select * from YCC_obs_last_Time_value where person_id=70 ;
-- select * from concept_datatype;
-- select * from visit;
create or replace view YCC_view_visit_attribute as
select 
  va.visit_attribute_id
, va.visit_id
, va.attribute_type_id
,(select vat.name from visit_attribute_type vat where vat.visit_attribute_type_id = va.attribute_type_id) as visit_attribute_type_name
, va.value_reference
-- , va.uuid
-- , va.creator
-- , va.date_created as va_date_created
-- , va.changed_by
-- , va.date_changed
-- , va.voided as va_voided
-- , va.voided_by
-- , va.date_voided
-- , va.void_reason
-- , v.visit_id                                 -- visit table --------------------------------------
,'|' as vv
, v.patient_id
, v.visit_type_id
,(select vt.name from visit_type vt where vt.visit_type_id = v.visit_type_id) as visit_type_name
, v.date_started  as v_date_started
, v.date_stopped  as v_date_stopped
, if(v.date_stopped is null, 'Open', 'Closed') as visit_progress
, v.indication_concept_id
, v.location_id
,(select l.name from location l where l.location_id = v.location_id) as visit_location_name
-- , v.creator
, v.date_created as visit_date_created
-- , v.changed_by
-- , v.date_changed
-- , v.voided  as visit_voided
-- , v.voided_by
-- , v.date_voided
-- , v.void_reason
-- , v.uuid
from visit_attribute va
left join visit v on va.visit_id = v.visit_id
where v.voided = 0
  and va.voided = 0
;
-- select * from RGA_Visit_Attribute;
-- 
create or replace view YCC_view_visit as
select 
  v.visit_id                                 -- visit table --------------------------------------
, v.patient_id
, v.visit_type_id
,(select vt.name from visit_type vt where vt.visit_type_id = v.visit_type_id) as visit_type_name
,(select va.value_reference from YCC_view_visit_attribute va where va.visit_id =v.visit_id and va.attribute_type_id=1) as visit_status
,(select va.value_reference from YCC_view_visit_attribute va where va.visit_id =v.visit_id and va.attribute_type_id=2) as admission_status
, v.date_started  as v_date_started
, v.date_stopped  as v_date_stopped
, if(v.date_stopped is null, 'Open', 'Closed') as visit_progress
, v.indication_concept_id
, v.location_id
,(select l.name from location l where l.location_id = v.location_id) as visit_location_name
-- , v.creator
, v.date_created as visit_date_created
-- , v.changed_by
-- , v.date_changed
-- , v.voided  as visit_voided
-- , v.voided_by
-- , v.date_voided
-- , v.void_reason
-- , v.uuid
from visit v
where v.voided = 0
;
-- select * from YCC_view_visit;
create or replace view YCC_view_encounter as
select 
  e.encounter_id
, e.encounter_type
, (select et.name from encounter_type et where e.encounter_type = et.encounter_type_id) as encounter_type_name
, e.patient_id   as encounter_patient_id
,(select pi.identifier from patient_identifier pi where pi.patient_id = e.patient_id and pi.identifier_type=3) as encounter_patient_identifier 
, e.location_id  as encounter_location_id
, (select l.name from location l where l.location_id = e.location_id) as encounter_location_name
-- , e.form_id
, e.encounter_datetime
-- , e.voided   as encounter_voided
, e.visit_id
, v.patient_id     as visit_patient_id
, v.visit_type_id
,(select vt.name from visit_type vt where vt.visit_type_id = v.visit_type_id) as visit_type_name 
, v.date_started as visit_date_started
, v.date_stopped as visit_date_stopped
, round(timestampdiff(minute,v.date_started,v.date_stopped)/60,0) as visit_duration_hours
,if(v.date_stopped is null,'Open','Closed') as visit_status
-- , v.indication_concept_id
, v.location_id  as visit_location_id
,(select l.name from location l where l.location_id = v.location_id) as visit_location_name
-- , v.voided
from encounter e
left join visit v on e.visit_id = v.visit_id
where e.voided = 0 and v.voided = 0
;
-- select * from YCC_view_encounter ;
create or replace view YCC_view_encounter_form as
select 
 rov.person_id as 'patient_id'
,rov.encounter_id
,rov.visit_date_stopped
,rov.encounter_type
,(select et.name from encounter_type et where et.encounter_type_id = rov.encounter_type) as encounter_type_name
,rov.form_name
,CASE 
  When rov.form_name='Surgery Assessment' THEN 'Surgery'
  When rov.form_name='Surgery Intervention' THEN 'Surgery'
  When rov.form_name='Surgery Event' THEN 'Surgery'
  When rov.form_name='Nutrition Assessment' THEN 'Nutrition'
  When rov.form_name='Nutrition Intervention' THEN 'Nutrition'
  When rov.form_name='Speech Assessment for Patient 0 to 3yrs' THEN 'Speech'
  When rov.form_name='Speech Assessment for Patient 3yrs and older' THEN 'Speech'
  When rov.form_name='Speech Intervention for Patient 0 to 3yrs' THEN 'Speech'
  When rov.form_name='Speech Intervention for Patient 3yrs and older' THEN 'Speech'
  When rov.form_name='ENT Assessment' THEN 'ENT'
  When rov.form_name='ENT Nasopharyngeal Endoscopic Assessment' THEN 'ENT'
  When rov.form_name='ENT Intervention' THEN 'ENT'
  When rov.form_name='Dental and Orthodontic Assessment' THEN 'Dental'
  When rov.form_name='Dental and Orthodontic Intervention' THEN 'Dental'
  When rov.form_name='Social Work Assessment' THEN 'Social Work'
  When rov.form_name='Social Work Intervention' THEN 'Social Work'
  When rov.form_name is null THEN 'Other'
 ELSE 'Other'
 END AS YCC_Service
,CASE 
  When rov.form_name='Surgery Assessment' THEN 1
  When rov.form_name='Surgery Intervention' THEN 1
  When rov.form_name='Surgery Event' THEN 1
  When rov.form_name='Nutrition Assessment' THEN 5
  When rov.form_name='Nutrition Intervention' THEN 5
  When rov.form_name='Speech Assessment for Patient 0 to 3yrs' THEN 4
  When rov.form_name='Speech Assessment for Patient 3yrs and older' THEN 4
  When rov.form_name='Speech Intervention for Patient 0 to 3yrs' THEN 4
  When rov.form_name='Speech Intervention for Patient 3yrs and older' THEN 4
  When rov.form_name='ENT Assessment' THEN 3
  When rov.form_name='ENT Nasopharyngeal Endoscopic Assessment' THEN 3
  When rov.form_name='ENT Intervention' THEN 3
  When rov.form_name='Dental and Orthodontic Assessment' THEN 2
  When rov.form_name='Dental and Orthodontic Intervention' THEN 2
  When rov.form_name='Social Work Assessment' THEN 6
  When rov.form_name='Social Work Intervention' THEN 6
  When rov.form_name is null THEN 99
 ELSE 99
 END AS YCC_Service_Seq
,count(*) as 'obs_count'
from YCC_view_obs rov
-- where rov.encounter_id = (select max(rov2.encounter_id
group by rov.person_id, rov.encounter_id, rov.visit_date_stopped, rov.encounter_type, rov.form_name
;
-- select * from YCC_view_encounter_form ;-- where encounter_id=25 order by  encounter_type desc, form_name asc;
-- select encounter_type,count(*) from encounter group by encounter_type order by 2 desc, 1;
-- select * from encounter_type;
