-- CREATE or replace VIEW YCC_view_RPT_Intervention_Summary AS
--  Intervention Report
-- , (select coalesce(count(*),0) from YCC_view_encounter_form f where f.patient_id = p.internal_patient_id and (f.visit_date_stopped BETWEEN '#startDate#' and '#endDate#') and f.form_name='Surgery Intervention') as 'Surg I'

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
--    where (f.visit_date_stopped BETWEEN '2020/1/1' and '2025/1/1') 
     group by f.patient_id, f.encounter_id, f.form_name, f.YCC_Service, f.YCC_Service_Seq
   ) as s
group by s.YCC_Service,s.YCC_Service_Seq
order by s.YCC_Service_Seq,s.YCC_Service
;
-- select * from YCC_view_encounter_form where YCC_Service ="Other" order by form_name,patient_id;