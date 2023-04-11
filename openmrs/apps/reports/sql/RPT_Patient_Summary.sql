--  Patient Summary Report

select 'Count of  Unique Patients' as 'Item', format(count(distinct v.patient_id),0) as 'Value' 
   from visit v where v.voided <> 1 AND v.date_stopped BETWEEN  '#startDate#' AND '#endDate#' 
union all select  '','' 
union all select  '    GENDER','' 
union all select  'Count of Males'  ,(select format(count(*),0) from person p  
																where p.gender="M" 
                                                                AND p.person_id in 
                                                                (select distinct v.patient_id 
																   from visit v where v.voided <> 1 
                                                                                  AND v.date_stopped BETWEEN  '#startDate#' AND '#endDate#') 
                                     )
union all select  'Count of Females',(select format(count(*),0) from person p  
																where p.gender="F" 
                                                                AND p.person_id in 
                                                                (select distinct v.patient_id 
																   from visit v where v.voided <> 1 
                                                                                  AND v.date_stopped BETWEEN '#startDate#' AND '#endDate#') 
                                     )
union all select  'Count of Other'  ,(select format(count(*),0) from person p  
																where ((p.gender<>"M" AND p.gender<>"F") or p.gender is null)
                                                                AND p.person_id in 
                                                                (select distinct v.patient_id 
																   from visit v where v.voided <> 1 
                                                                                  AND v.date_stopped BETWEEN  '#startDate#' AND '#endDate#') 
                                     ) 
union all select  ' ','' 
union all select  "Average Age",(select format(avg(timestampdiff(month,P.birthdate,curdate())/12),1)
                               from person P 
                              WHERE P.person_id in (select distinct v.patient_id 
                                                                from visit v 
															   where v.voided <> 1 AND v.date_stopped BETWEEN  '#startDate#' AND '#endDate#')
							)
union all select  ' ',' ' 
union all select  '    New versus Established','' 
union all select  'Count of New Patients'        ,(select format(count(*),0) from person p 
                                             where p.date_created >=  '#startDate#' 
                                               AND p.person_id in (select distinct v.patient_id from visit v where v.voided <> 1 AND v.date_stopped BETWEEN  '#startDate#' AND '#endDate#')) 
union all select  'Count of Established Patients',(select format(count(*),0) from person p 
                                             where p.date_created <  '#startDate#' 
					                           AND p.person_id in (select distinct v.patient_id from visit v where v.voided <> 1 AND v.date_stopped BETWEEN   '#startDate#' AND '#endDate#')) 
union all select  '  ','  ' 
union all select  '    Treatment Plans',''  
union all select  'Patients with TP'   , format((select count(distinct o.person_id) from obs o where o.form_namespace_and_path like 'Bahmni^Patient Treatment Plan%'  
                AND o.person_id in (select distinct v.patient_id from visit v where v.voided <> 1 AND v.date_stopped BETWEEN   '#startDate#' AND '#endDate#')),0) 


union all select  'Patients without TP'   , (select count(distinct v.patient_id) from visit v where v.voided <> 1 AND v.date_stopped BETWEEN  '#startDate#' AND '#endDate#') 
                                               - (select count(distinct o.person_id) from obs o where o.form_namespace_and_path like 'Bahmni^Patient Treatment Plan%'  
                AND o.person_id in (select distinct v.patient_id from visit v where v.voided <> 1 AND v.date_stopped BETWEEN  '#startDate#' AND '#endDate#')) 



union all select  '    ','  ' 
union all select  '    Patient Status','' 
union all select  'Count of Patients with status = Active'   ,
(select count(distinct v.patient_id) from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')
- (select format(count(distinct person_id),0) 
from YCC_view_obs_last_date_value t where t.concept_name='Is Closed - Discharge'     
AND t.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
- (select format(count(distinct person_id),0) 
from YCC_view_obs_last_date_value t where t.concept_name='Is Closed - Lost Contact'     
AND t.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 

union all select  'Count of Patients with status = Dropout'  ,
 (select format(count(distinct person_id),0) 
from YCC_view_obs_last_date_value t where t.concept_name='Is Closed - Lost Contact'     
AND t.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 

union all select  'Count of Patients with status = Completed',
 (select format(count(distinct person_id),0) 
from YCC_view_obs_last_date_value t where t.concept_name='Is Closed - Discharge'     
AND t.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 

union all select  'Count of Active Patients as a % of total',
   concat(format(100*(
   (select count(distinct v.patient_id) from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')
- (select format(count(distinct person_id),0) 
from YCC_view_obs_last_date_value t where t.concept_name='Is Closed - Discharge'     
AND t.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
- (select format(count(distinct person_id),0) 
from YCC_view_obs_last_date_value t where t.concept_name='Is Closed - Lost Contact'     
AND t.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
   )/(select count(distinct v.patient_id) from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')
			,0),"%") 

union all select  '','      ' 
union all select  '    School Status','' 

union all select  'Count of Patients with school = Enrolled'      ,
(select format(count(distinct person_id),0) from YCC_view_obs_last_coded_value lc where lc.concept_name='Current Education Level' 
    and lc.value_coded_name in ('Attending primary school','Attending secondary school','Attending college or university')  
    AND lc.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 

union all select  'Count of Patients with school = Graduated'     ,
(select format(count(distinct person_id),0) from YCC_view_obs_last_coded_value lc where lc.concept_name='Current Education Level' 
    and lc.value_coded_name in ('Completed primary school','Completed secondary school','Completed college or univerity')  
    AND lc.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 

union all select  'Count of Patients with school = Not School Age',
(select format(count(distinct person_id),0) from YCC_view_obs_last_coded_value lc where lc.concept_name='Current Education Level' 
    and lc.value_coded_name in ('Not old enough for school')  
    AND lc.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 

union all select  'Count of Patients with school = Out of School' ,
(select format(count(distinct person_id),0) from YCC_view_obs_last_coded_value lc where lc.concept_name='Current Education Level' 
    and lc.value_coded_name in ('Primary school-aged - not in school','Secondary school-aged - not in school')  
    AND lc.person_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
/*
*/
;

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
