--  Service Detail Report

Select 
  p.patient_identifier                as 'Patient ID'
, p.patient_name                      as 'Patient Name'
, p.patient_gender                    as 'Gender'
, f.YCC_Service                       as 'Service'
, COALESCE(count(*),0)+0              as 'Service Deliveries'

from 
(select
 pid1.patient_id
,pid1.identifier AS 'patient_identifier'
,concat(coalesce(per.given_name,''),' ',coalesce(per.middle_name,''),' ',coalesce(per.family_name,'')) AS 'patient_name'
,p.gender AS 'patient_gender'
from patient pa 
inner join person p on pa.patient_id=p.person_id 
inner join person_name per on pa.patient_id=per.person_id
inner join patient_identifier pid1 on pa.patient_id=pid1.patient_id and pid1.identifier_type=3 -- 3 = patient_id 4 = Yekatit OPD
where p.voided = 0 and pa.voided = 0
) p

left outer join YCC_view_encounter_form f on p.patient_id = f.patient_id
WHERE p.patient_id in 
(select distinct v.patient_id from visit v 
where v.date_stopped BETWEEN '#startDate#' and '#endDate#'
)
and f.YCC_Service <>'Other'
group by   p.patient_identifier, p.patient_name, p.patient_gender, f.YCC_Service
order by 1,4
;
