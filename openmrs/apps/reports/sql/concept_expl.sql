create table FOO 
(rowNum int not null, AUTO_INCREMENT
,parent_concept int not null
,child_concept int not null
)
SELECT Concept_se

;
with RPL (Parent_Concept, Child_Concept) AS
  ( Select ROOT.concept_set as Parent_Concept
          ,ROOT.concept_id  as Child_Concept
      from concept_set ROOT
     where not exists (select CHK.concept_set from concept_set CHK where CHK.concept_id = ROOT.concept_set)
   UNION ALL
    Select CHILD.concept_set  
         , CHILD.concept_id  
      from RPL         PARENT
          ,concept_set CHILD
     where PARENT.Child_Concept = CHILD.concept_set
  )
select distinct Parent_Concept, Child_Concept
  from RPL
  order by 1,2
;


