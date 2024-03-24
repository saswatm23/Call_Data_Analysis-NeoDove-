select * from "Call_Log"
select * from "Organisation"
select * from "Properties"

--Dropped the column properties as we have successfully extracted data into diff relation
alter table "Organisation"
drop column properties


--1. Find the first connected call for all the renewed organizations from the Gujarat location
ALTER TABLE "Organisation" ALTER COLUMN "org_date" TYPE DATE using to_date(org_date, 'DD-MM-YYYY');
rollback;

select org_id,org_name,org_code,org_status,email,location,DateTime,call_connected from
(select o.*,p.*,TO_TIMESTAMP(c.call_date, 'YYYY-MM-DD HH24:MI:SS') as DateTime,c.call_connected from "Organisation" O
join "properties" P
on o.org_name=p.company
right join "Call_Log" c
on o.org_id=c.org_id
where o.org_status='renewed' and p.location='Gujarat' and c.call_connected=1)A
order by datetime




--2. Find the count of organizations that had three consecutive calls (excluding Saturday and Sunday) within 0-4 days, 5-8 days, 8-15 days, 16-30 days,30+ days of organization creation
--a. Perform this analysis for both renewed and not renewed organizations

WITH ConsecutiveCalls AS (
    SELECT 
        c.org_id,
        c.call_date,
        LAG(c.call_date, 1) OVER (PARTITION BY c.org_id ORDER BY c.call_date) AS prev_call_date,
        LAG(c.call_date, 2) OVER (PARTITION BY c.org_id ORDER BY c.call_date) AS prev_prev_call_date,
        ROW_NUMBER() OVER (PARTITION BY c.org_id ORDER BY c.call_date) AS row_num
    FROM 
        "Call_Log" c
),
TimeRanges AS (
    SELECT
        o.org_id,
        CASE
            WHEN EXTRACT(DOW FROM org_date::DATE) NOT IN (0, 6) AND EXTRACT(DOW FROM call_date::DATE) NOT IN (0, 6)
                AND DATE_PART('day', call_date::TIMESTAMP - org_date::TIMESTAMP) BETWEEN 0 AND 4 THEN '0-4 days'
            WHEN EXTRACT(DOW FROM org_date::DATE) NOT IN (0, 6) AND EXTRACT(DOW FROM call_date::DATE) NOT IN (0, 6)
                AND DATE_PART('day', call_date::TIMESTAMP - org_date::TIMESTAMP) BETWEEN 5 AND 8 THEN '5-8 days'
            WHEN EXTRACT(DOW FROM org_date::DATE) NOT IN (0, 6) AND EXTRACT(DOW FROM call_date::DATE) NOT IN (0, 6)
                AND DATE_PART('day', call_date::TIMESTAMP - org_date::TIMESTAMP) BETWEEN 9 AND 15 THEN '9-15 days'
            WHEN EXTRACT(DOW FROM org_date::DATE) NOT IN (0, 6) AND EXTRACT(DOW FROM call_date::DATE) NOT IN (0, 6)
                AND DATE_PART('day', call_date::TIMESTAMP - org_date::TIMESTAMP) BETWEEN 16 AND 30 THEN '16-30 days'
            ELSE '30+ days'
        END AS time_range
    FROM
        ConsecutiveCalls cc
        INNER JOIN "Organisation" o ON cc.org_id = o.org_id
)
SELECT
    time_range,
    org_status,
    COUNT(DISTINCT o.org_id) AS num_organizations
FROM
    TimeRanges tr
    INNER JOIN "Organisation" o ON tr.org_id = o.org_id
GROUP BY
    time_range,
    org_status;


--3. Identify the location with the maximum number of connected calls for unique leads

select lead_id,locations,call_count from 	
	(select DISTINCT(c.lead_id),count(c.call_connected) call_count,p.locations,dense_rank() over(order by count(c.call_connected) desc) as RNK from "Organisation" o
	join "Call_Log" c
	on o.org_id=c.org_id
	join "Properties" p
	on o.org_name=p.companies
	where c.call_connected=1
	group by p.locations,c.lead_id
	order by call_count desc)A
where rnk=1

--4. For calls not connected, identify the most common reason(s) for why the call was not connected.

select call_not_connected_reason,count(call_not_connected_reason) as cnt from "Call_Log"
where call_not_connected_reason is not null
group by call_not_connected_reason
order by cnt desc
limit 1