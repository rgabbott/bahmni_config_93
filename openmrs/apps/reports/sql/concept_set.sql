select 
 ln.name as Concept_Set_Name
,cs.sort_weight
,cn.name as Concept_Name
,cs.concept_set
,cs.concept_id
,cs.creator
,cs.date_created
,cs.uuid
,cs.concept_set_id

 from concept_set cs
 LEFT OUTER JOIN concept_name ln ON cs.concept_set = ln.concept_id and ln.concept_name_type="FULLY_SPECIFIED"
 LEFT OUTER JOIN concept_name cn ON cs.concept_id  = cn.concept_id and cn.concept_name_type="FULLY_SPECIFIED"

order by cs.concept_set, cs.sort_weight, cs.concept_id, cs.concept_set_id ;




select
 c.concept_id 
,ln.name as Concept_Name
,sn.name as Short_Name
,dt.name as Datatype
,cl.name as Class
,c.retired 
,c.is_seT
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
order by c.concept_id ;

-- this is a commenT
-- ,(select sn.name from concept_name sn where c.concept_id = sn.concept_id and sn.concept_name_type="FULLY_SPECIFIED") as Concept_Name
-- ,(select sn.name from concept_name sn where c.concept_id = sn.concept_id and sn.concept_name_type="SHORT") as Short_Name
-- ,(select dt.name from concept_datatype dt where c.datatype_id = dt.concept_datatype_id) as Datatype_Name
-- ,(select cl.name from concept_class cl where c.class_id = cl.concept_class_id) as Class_Name


select * from concept order by concept_id ;
select * from concept_name order by concept_id,concept_name_id ;
select * from concept_datatype order by concept_datatype_id ;
select * from concept_class order by concept_class_id ;
select * from concept_answer order by concept_id,concept_answer_id ;
SELECt * from concept_set order by concept_set, concept_id, concept_set_id ;

select c.concept_id ,c.retired ,c.datatype_id ,c.class_id from concept c order by c.concept_id ;

select * from concept order by concept_id ;

select * from concept_name order by concept_id,concept_name_id ;
select * from concept_datatype order by concept_datatype_id ;
select * from concept_class order by concept_class_id ;
select * from concept_answer order by concept_id,concept_answer_id ;
select * from concept_set order by concept_set, concept_id, concept_set_id ;

