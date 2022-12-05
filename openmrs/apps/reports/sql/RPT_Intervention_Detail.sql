--  Intervention DETAIL Report

Select 
  p.patient_identifier                as 'Patient ID'
, p.patient_name                      as 'Patient Name'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Surgery Assessment'                            ) as 'Surg A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Surgery Intervention'                          ) as 'Surg I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Surgery Event'                                 ) as 'Surg Event'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Nutrition Assessment'                          ) as 'Nutr A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Nutrition Intervention'                        ) as 'Nutr I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Speech Assessment for Patient 0 to 3yrs'       ) as 'Speech A 0-3'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Speech Assessment for Patient 3yrs and older'  ) as 'Speech A 3+'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Speech Intervention for Patient 0 to 3yrs'     ) as 'Speech I 0-3'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Speech Intervention for Patient 3yrs and older') as 'Speech I 3+'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='ENT Assessment'                                ) as 'ENT A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='ENT Nasopharyngeal Endoscopic Assessment'      ) as 'ENT A - NE'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='ENT Intervention'                              ) as 'ENT I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Dental and Orthodontic Assessment'             ) as 'Dental A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Dental and Orthodontic Intervention'           ) as 'Dental I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Social Work Assessment'                        ) as 'SWork A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Social Work Intervention'                      ) as 'SWork I'

-- , p.patient_birthdate                 as 'DOB'
-- , p.patient_gender                    as 'Sex'
-- , p.type_of_cleft                     as 'Type of Cleft'
--   ,"|" as 'Extras:'
-- , p.Current_Education_Level
-- , p.registration_date
-- , p.patient_create_date                                -- date part only no time
-- , p.patient_age_at_registration
-- , p.patient_age_now                       -- age in just 0 decimal
-- ,p.is_closed_Discharge
-- ,p.is_closed_Lost_Contact
-- ,'v: #startDate#' as startDate_Text
from YCC_view_RPT_Patient_Detail p
WHERE p.internal_patient_id in 
(select distinct v.patient_id 
   from visit v 
--  where v.date_stopped BETWEEN '2020/1/1' and '2024/1/1'
  where v.date_stopped BETWEEN '#startDate#' and '#endDate#'
 -- BETWEEN @start_date AND @end_date
)
order by 2
;
