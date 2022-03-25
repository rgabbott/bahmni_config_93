
select 
per.given_name as 'First Name',
per.middle_name as 'Middle Name',
per.family_name as 'Last Name',
pid1.identifier as 'Patient ID',
pid2.identifier as 'OPD',
p.birthdate as 'Date of Birth',
timestampdiff(year,p.birthdate,pa.date_created) As 'Age',
p.gender AS 'Gender',
DATE_FORMAT(p.date_created, "%d-%b-%Y")  AS 'Registration Date'
from patient pa 
inner join person_name per on pa.patient_id=per.person_id
inner join person p on pa.patient_id=p.person_id and p.date_created BETWEEN '#startDate#' and '#endDate#'
inner join patient_identifier pid1 on pa.patient_id=pid1.patient_id and pid1.identifier_type=3
inner join patient_identifier pid2 on pa.patient_id=pid2.patient_id and pid2.identifier_type=4
;

