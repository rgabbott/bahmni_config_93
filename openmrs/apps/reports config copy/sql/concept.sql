select
 c.concept_id 
,ln.name as Concept_Name
,sn.name as Short_Name
,dt.name as Datatype
,cl.name as ClasS
,c.retired 
,c.is_set
,abs((sign(asp.parent_cnt)-c.is_set)) as is_set_err
,asp.parent_cnt as is_set_parent_cnt
,asx.child_cnt as is_set_child_cnt
,c.creator
,c.changed_by
,c.date_created
,c.date_changed
,c.uuid
,c.class_id 
,c.datatype_id 
,c.description
,c.form_text
from concept c 
 LEFT OUTER JOIN concept_name ln ON c.concept_id = ln.concept_id and ln.concept_name_type="FULLY_SPECIFIED"
 LEFT OUTER JOIN concept_name sn ON c.concept_id = sn.concept_id and sn.concept_name_type="SHORT"
 LEFT OUTER JOIN concept_datatype dt on c.datatype_id = dt.concept_datatype_id 
 LEFT OUTER JOIN concept_class cl on c.class_id = cl.concept_class_id
 LEFT OUTER JOIN (select csp.concept_set, count(*) as parent_cnt from concept_set csp group by csp.concept_set) asp on c.concept_id = asp.concept_set
 LEFT OUTER JOIN (select csc.concept_id , count(*) as child_cnt  from concept_set csc group by csc.concept_id ) asx on c.concept_id = asx.concept_id
order by c.concept_id ;
