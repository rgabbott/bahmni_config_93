--  Intervention DETAIL Report

Select 
  p.patient_identifier                as 'Patient ID'
, p.patient_name                      as 'Patient Name'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Surgery Assessment'                            ) as 'Surg A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Surgery Intervention'                          ) as 'Surg I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Surgery Event'                                 ) as 'Surg Event'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Nutrition Assessment'                          ) as 'Nutr A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Nutrition Intervention'                        ) as 'Nutr I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Speech Assessment for Patient 0 to 3yrs'       ) as 'Speech A 0-3'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Speech Assessment for Patient 3yrs and older'  ) as 'Speech A 3+'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Speech Intervention for Patient 0 to 3yrs'     ) as 'Speech I 0-3'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Speech Intervention for Patient 3yrs and older') as 'Speech I 3+'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='ENT Assessment'                                ) as 'ENT A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='ENT Nasopharyngeal Endoscopic Assessment'      ) as 'ENT A - NE'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='ENT Intervention'                              ) as 'ENT I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Dental and Orthodontic Assessment'             ) as 'Dental A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Dental and Orthodontic Intervention'           ) as 'Dental I'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Social Work Assessment'                        ) as 'SWork A'
, (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#' ) and f.form_name='Social Work Intervention'                      ) as 'SWork I'

from YCC_view_RPT_Patient_Detail p
WHERE p.internal_patient_id in 
(select distinct v.patient_id 
   from visit v 
where v.date_stopped BETWEEN '#startDate#' and '#endDate#'
)
order by 2
;
