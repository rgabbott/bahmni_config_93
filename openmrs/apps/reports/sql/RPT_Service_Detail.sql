--  Intervention Report

Select 
  p.patient_identifier                as 'Patient ID'
, p.patient_name                      as 'Patient Name'
, p.patient_gender                    as 'Gender'
, f.YCC_Service                       as 'Service'
,count(*)                             as 'Service Deliveries'
-- , (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Surgery Assessment'                            ) as 'Surg A'

-- , p.patient_birthdate                 as 'DOB'
-- , p.type_of_cleft                     as 'Type of Cleft'

from YCC_view_RPT_Patient_Detail p
left outer join YCC_view_encounter_form f on p.internal_patient_id = f.patient_id
WHERE p.internal_patient_id in 
(select distinct v.patient_id 
   from visit v 
-- where v.date_stopped BETWEEN '2022/8/1' and '2024/1/1'
where v.date_stopped BETWEEN '#startDate#' and '#endDate#'
)
and f.YCC_Service <>'Other'
group by   p.patient_identifier, p.patient_name, p.patient_gender, f.YCC_Service
order by 1,4
;
