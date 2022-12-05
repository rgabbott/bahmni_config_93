--  Patient Summary Report

select  'Count of  Unique Patients', format(count(*),0) as 'Value' from YCC_view_RPT_Patient_Summary t 
  WHERE t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#') 
union all select  '','' 
union all select  '    GENDER','' 
union all select  'Count of Males'  ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.gender="M" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Females',(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.gender="F" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Other'  ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t 
		 				where ((t.gender<>"M" and t.gender<>"F") or t.gender is null)
                              AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#'))
union all select  ' ','' 
union all select  "Average Age",(select format(avg(t.patient_age_now),0) 
                               from YCC_view_RPT_Patient_Summary t 
                              WHERE t.internal_patient_id in (select distinct v.patient_id 
                                                                from visit v 
															   where v.date_stopped BETWEEN '#startDate#' AND '#endDate#'
															 )
							)
union all select  ' ',' ' 
union all select  '    New versus Established','' 
union all select  'Count of New Patients'        ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t 
                                             where t.patient_create_date>='#startDate#' 
                                               AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Established Patients',(select format(count(*),0) from YCC_view_RPT_Patient_Summary t 
                                             where t.patient_create_date <'#startDate#' 
					                           AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  '  ','  ' 
union all select  '    Treatment Plans',''  
union all select  ' of Patients with TP'   ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.Treatment_Plan_exists="Y" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  ' of Patients without TP',(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where (t.Treatment_Plan_exists="N" or t.Treatment_Plan_exists is null) 
                                                                                     AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  '    ','  ' 
union all select  '    Patient Status','' 
union all select  'Count of Patients with status = Active'   ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.Status="A" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Patients with status = Dropout'  ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.Status="D" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Patients with status = Completed',(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.Status="C" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  '     ','   ' 
union all select  'Count of Active Patients as a % of total',
   concat(format(100*(
                 select count(*) 
                   from YCC_view_RPT_Patient_Summary t 
				  where t.Status="A" 
                    AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')
                    )
                /(select count(*) 
                    from YCC_view_RPT_Patient_Summary t
				   WHERE t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')
				 )
			,0),"%") 
union all select  '','      ' 
union all select  '    School Status','' 
union all select  'Count of Patients with school = Enrolled'      ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.School_Status="E" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#')) 
union all select  'Count of Patients with school = Graduated'     ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.School_Status="G" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#'))  
union all select  'Count of Patients with school = Not School Age',(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.School_Status="N" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#'))  
union all select  'Count of Patients with school = Out of School' ,(select format(count(*),0) from YCC_view_RPT_Patient_Summary t where t.School_Status="O" AND t.internal_patient_id in (select distinct v.patient_id from visit v where v.date_stopped BETWEEN '#startDate#' AND '#endDate#'))  
;
