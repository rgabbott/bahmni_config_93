--  Patient Summary Report

select  'Count of  Unique Patients', format(count(pa.patient_id),0) as 'Value' from patient pa 
  WHERE pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#') 
union all select  '','' 
union all select  '    GENDER','' 
union all select  'Count of Males'    ,(select format(count(*),0) from patient pa left outer join person p on p.person_id= pa.patient_id where p.gender="M" AND pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Females'  ,(select format(count(*),0) from patient pa left outer join person p on p.person_id= pa.patient_id where p.gender="F" AND pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Other'    ,(select format(count(*),0) from patient pa left outer join person p on p.person_id= pa.patient_id where ((p.gender<>"M" and p.gender<>"F") or p.gender is null) AND pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  ' ','' 
union all select  "Average Age",(select format(avg(timestampdiff(month,p.birthdate,curdate())/12 ),0) 
                               from patient pa left outer join person p on pa.patient_id=p.person_id 
                              WHERE pa.patient_id in (select distinct v.patient_id 
                                                                from visit v 
															   where v.date_stopped BETWEEN '#startDate#' AND '#endDate#'
															 )
							)
union all select  ' ',' ' 
union all select  '    New versus Established','' 
union all select  'Count of New Patients'         ,(select format(count(*),0) from patient pa left outer join person p on pa.patient_id=p.person_id 
                                                     where p.date_created >= '#startDate#' 
                                                       AND pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Established Patients' ,(select format(count(*),0) from patient pa left outer join person p on pa.patient_id=p.person_id 
                                                     where p.date_created < '#startDate#' 
                                                       AND pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 

union all select  '  ','  ' 
union all select  '    Treatment Plans',''  
union all select  ' of Patients with TP'   ,(select format(count(*),0) 
	                                           from patient pa left outer join person p on pa.patient_id = p.person_id 
										      where pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#') 
											    and exists (select * from YCC_view_obs ro where ro.person_id = pa.patient_id and ro.form_name='Patient Treatment Plan'))
union all select  ' of Patients without TP'   ,(select format(count(*),0) 
	                                           from patient pa left outer join person p on pa.patient_id = p.person_id 
										      where pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#') 
											    and not exists (select * from YCC_view_obs ro where ro.person_id = pa.patient_id and ro.form_name='Patient Treatment Plan'))
union all select  '    ','  ' 
union all select  '    Patient Status for patients updated during the period','' 
union all select  'Count of Patients with status = Active'   ,
(select format(count(*),0) 
   from patient pa 
  WHERE	pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')  
   and NOT (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Discharge')
   and NOT (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Lost Contact')
)
union all select  'Count of Patients with status = Dropout', 
(select format(count(*),0) 
   from patient pa 
  WHERE	pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')  
   and NOT (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Lost Contact')
)
union all select  'Count of Patients with status = Completed',
(select format(count(*),0) 
   from patient pa 
  WHERE	pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')  
   and NOT (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Discharge')
)
union all select  '     ','   ' 
union all select  'Count of Active Patients as a % of total',
   concat(format(100*(
                 select count(*) 
                   from patient pa 
				  where pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')
                    and NOT (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Discharge')
                    and NOT (select not(isnull(lc.value_datetime)) from YCC_view_obs_last_date_value lc where lc.person_id=pa.patient_id and lc.concept_name='Is Closed - Lost Contact')
                    )
                /(select count(*) 
                    from patient pa
				   WHERE pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#'))
			,0),"%") 

-- ,'' AS 'patient_status'                     -- Patient Status A = Active D = Drop Out C = Completed all treatment
--                                             -- Based on Patient Case Status on the Patient Treatment Plan OBS form. 
--                                             -- If Patient Case Status "Is Closed - Discharge",  set to "C";  If "Is Closed - Lost Contact", set to "D" else set to "A"

union all select  '','      ' 
union all select  '    School Status','' 
union all select  'Count of Patients with school = Enrolled'      ,
	      (select format(count(*),0) from patient pa       -- YCC_view_RPT_Patient_Summary t -- where t.School_Status="E" 
	       WHERE pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')
             AND exists (select lc.value_coded_name from YCC_view_obs_last_coded_value lc 
				          where lc.person_id=pa.patient_id and lc.concept_name='Current Education Level' 
						    and lc.value_coded_name in ('Attending primary school','Attending secondary school','Attending college or university')) 
	       ) 
union all select  'Count of Patients with school = Graduated'     ,
         (select format(count(*),0) from patient pa      -- YCC_view_RPT_Patient_Summary t -- where t.School_Status="G" 
	       WHERE pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')  
             AND exists (select lc.value_coded_name from YCC_view_obs_last_coded_value lc 
				          where lc.person_id=pa.patient_id and lc.concept_name='Current Education Level' 
						    and lc.value_coded_name in ('Completed primary school','Completed secondary school','Completed college or university' )) 
			)
union all select  'Count of Patients with school = Not School Age',
         (select format(count(*),0) from patient pa      -- YCC_view_RPT_Patient_Summary t -- where t.School_Status="N" 
	       WHERE pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#') 
             AND exists (select lc.value_coded_name from YCC_view_obs_last_coded_value lc 
				          where lc.person_id=pa.patient_id and lc.concept_name='Current Education Level' 
						    and lc.value_coded_name in ('Not old enough for school' ))
					)
union all select  'Count of Patients with school = Out of School' ,
         (select format(count(*),0) from patient pa      -- YCC_view_RPT_Patient_Summary t -- where t.School_Status="O" 
	       WHERE pa.patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')  
             AND exists (select lc.value_coded_name from YCC_view_obs_last_coded_value lc 
				          where lc.person_id=pa.patient_id and lc.concept_name='Current Education Level' 
						    and lc.value_coded_name in ( 'Primary school-aged - not in school','Secondary school-aged - not in school' )) 
					)
;
