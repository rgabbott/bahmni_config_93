-- Intervention Summary

Select s.YCC_Service
      ,Count(*) as Service_Total
  FROM 
   (select 
      f.patient_id
    , f.encounter_id
    , f.form_name
    , f.YCC_Service
    , f.YCC_Service_Seq
     from YCC_view_encounter_form f 
	where (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') 
    group by f.patient_id, f.encounter_id, f.form_name, f.YCC_Service, f.YCC_Service_Seq
   ) as s
where s.YCC_Service <>"Other"
group by s.YCC_Service,s.YCC_Service_Seq
order by s.YCC_Service_Seq,s.YCC_Service
;

