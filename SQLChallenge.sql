select 
A,B,C,
case 
    when (A=B and A=C and B=C) then 'Equilateral'
    when ((A=B and (A+B)>C) or (A=C and (A+C)>B) or (B=C and (B+C)>A)) then 'Isosceles'
    when ((A<>B and (A+B)>C) or (A<>C and (A+C)>B) or (B<>C and (C+B)>A)) then 'Scalene'
    when ((A+B)<=C or (B+C)<=A or (C+A)<=B)  then 'Not a triangle'
    end
from triangles  

SELECT 
CASE 
    WHEN A + B > C THEN 
        CASE 
             WHEN A = B AND B = C THEN 'Equilateral' 
             WHEN A = B OR B = C OR A = C THEN 'Isosceles' 
             WHEN A != B OR B != C OR A != C THEN 'Scalene' 
             END 
    ELSE 'Not A Triangle' 
    END 
    
FROM TRIANGLES

SELECT 
    CASE 
        WHEN A + B > C AND A+C>B AND B+C>A THEN 
            CASE WHEN A = B AND B = C THEN 'Equilateral' 
            WHEN A = B OR B = C OR A = C THEN 'Isosceles' 
            WHEN A != B OR B != C OR A != C THEN 'Scalene'     
        END 
    ELSE 'Not A Triangle' 
    END 
        
    FROM TRIANGLES;


SELECT
     [Doctor] AS Doctor
    ,[Professor] AS Professor
    ,[Singer] AS Singer
    ,[Actor] AS Actor
    
FROM (Select Name, Occupation from occupations) piv
pivot(MIN(Name) for Occupation in (Doctor,Professor,Singer,Actor)) col




select min(Doctor), min(Professor),min(Singer),  min(Actor)
from(
select ROW_NUMBER() OVER(PARTITION By Doctor,Actor,Singer,Professor order by name asc) AS Rownum, 
case when Doctor=1 then name else Null end as Doctor,
case when Actor=1 then name else Null end as Actor,
case when Singer=1 then name else Null end as Singer,
case when Professor=1 then name else Null end as Professor
from occupations
pivot
( count(occupation)
for occupation in(Doctor, Actor, Singer, Professor)) as p

) temp

group by Rownum  ;
     