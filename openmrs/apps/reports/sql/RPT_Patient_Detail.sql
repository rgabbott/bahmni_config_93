--  Patient Detail Report
-- SET @start_date = '#startDate#';  -- '08-01-2022'
-- SET @end_date = '#endDate#';
-- SET @start_date =  str_to_date('2022-08-01', '%Y-%m-%d'); 
-- SET @end_date   =  str_to_date('2024-01-01', '%Y-%m-%d');

Select 
  p.patient_identifier                as 'Patient ID'
, p.patient_name                      as 'Patient Name'
, p.patient_birthdate                 as 'DOB'
, p.patient_gender                    as 'Sex'
, p.type_of_cleft                     as 'Type of Cleft'
, p.treatment_plan_exists             as 'Treatment Plan?'
,if(p.patient_create_date>='#startDate#','N','E')  as 'New Patient?'                -- If Patient Registration date = or > beginning of reporting period, set to "N". Else "E"
, if(p.is_closed_Discharge,'C',if(p.is_closed_Lost_Contact,"D","A")) as 'Status:'
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
  AS 'School Status' 
--   ,"|" as 'Extras:'
-- , p.Current_Education_Level
-- , p.registration_date
-- , p.patient_create_date                                -- date part only no time
, p.patient_age_at_registration
, p.patient_age_now                       -- age in just 0 decimal
-- ,p.is_closed_Discharge
-- ,p.is_closed_Lost_Contact
-- ,'v: #startDate#' as startDate_Text
from YCC_view_RPT_Patient_Detail p
WHERE p.internal_patient_id in 
(select distinct v.patient_id 
   from visit v 
  where v.date_stopped 
    BETWEEN '#startDate#' and '#endDate#'
  -- BETWEEN @start_date AND @end_date
)
;
