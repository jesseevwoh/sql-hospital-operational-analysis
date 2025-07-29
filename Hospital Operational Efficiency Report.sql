/********************************************************************************
* PROJECT:      Optimizing Record Request Workflows Through Performance Analysis
* AUTHOR:       Jesse Evwoh
* DATE:         July 29, 2025
* DESCRIPTION:  An analysis of the medical records request process, focusing on 
* the relationship between staff experience, turnaround times, and
* SLA compliance to identify performance trends and bottlenecks.
********************************************************************************/

/********************************************************************************
* EXECUTIVE SUMMARY & RECOMMENDATIONS
********************************************************************************/

/*
EXECUTIVE SUMMARY: An analysis of the medical records request process reveals 
that staff experience is the primary driver of operational efficiency. 
Senior staff (Level 3) consistently outperform junior staff (Level 1) in both 
processing speed and SLA compliance. Key process inefficiencies were identified, 
with "Lab Report" requests showing the longest turnaround times and the 
"Review Failed" and "Other Error" stages being the primary source of rejections. 
Furthermore, the data indicates a potential issue with internal stakeholder 
satisfaction, as "Admins" reported the lowest satisfaction scores among all 
requester types. These findings suggest that improvements can be made through 
targeted staff training and specific process reviews.

KEY FINDINGS:
1.  Staff Performance Analysis: Level 3 staff were the most efficient across all 
    key metrics, while level 1 staff performed the worst. 
    Within each staff level,the highest years of experience performed best.

2.  Process Bottlenecks: Billings were the most common request type but they had 
    the second shortest processing rate. Lab reports had the longest processing 
    rates but were one of the less common request type. 
    Rejections occurred most frequently during the 'Review Failed' and 
    'Other Error' stages, identifying them as key process bottlenecks.
    Admins had a less satisfactory experience compared to other requester types.

3.  Performance Ranking: The best performers within each level had more years 
    of experience in comparison to their peers.
    
BUSINESS RECOMMENDATIONS:
1.  Targeted Training Program: Implement a targeted training and mentorship
    program for Level 1 staff, pairing them with high-performing Level 3
    staff to improve their speed and SLA compliance.
    
2.  Process Review: Initiate a detailed process review for 'Lab Report' requests
    to identify and address the causes for their long turnaround times.
    Similarly, analyze the 'Review Failed' stage to reduce the high number of 
    rejections.
    
3.  Improve Internal Stakeholder Experience: Conduct follow-up surveys or 
    meetings with 'Admin' and 'Doctor' requesters to understand the reasons 
    for their low satisfaction scores and identify areas for improvement.
    */

/********************************************************************************
* DATA SETUP & CLEANUP
********************************************************************************/
/*The first steps for this analysis involved cleaning the data in excel; 
the boolean table for sla_met was tranformed from text to boolean values.
The next steps involved creating the table in sql 
before loading data from the csv tables using import data wizard*/

CREATE TABLE Staff
(staff_id varchar2(8) constraint staff_id_pk PRIMARY KEY,
    staff_level number(1) constraint lvl_nn NOT NULL,
    staff_role varchar2(50),
    experience number(2) constraint exp_nn NOT NULL);
    
CREATE TABLE Record_Requests
(request_id varchar2(10) constraint request_id_pk PRIMARY KEY,
    staff_id varchar2(8) constraint staff_id_fk REFERENCES Staff(staff_id),
    request_date date constraint rr_date_nn NOT NULL,
    request_type varchar2(25),
    requester_type varchar2(12),
    turnaround_days number(2) constraint tr_days_nn NOT NULL,
    sla_met number(1) constraint sla_met_check CHECK (sla_met IN (0,1)),
    status varchar2(10),
    fulfillment_stage varchar2(10),
    satisfaction_score number(1));    

--During the import stage i encountered an error;
--the fulfillment_stage column exceeded the defined column size
ALTER TABLE Record_Requests
 MODIFY fulfillment_stage varchar(15);

--Queried both tables to ensure the import was succcessful
SELECT * 
FROM staff;

SELECT *
FROM record_requests;

--Data cleaning exercise
SELECT  INITCAP(request_type),
        INITCAP(requester_type),
        INITCAP(status),
        INITCAP(fulfillment_stage)
FROM record_requests;

UPDATE record_requests
SET 
    request_type = INITCAP(request_type),
    requester_type = INITCAP(requester_type),
    status = INITCAP(status),
    fulfillment_stage = INITCAP(fulfillment_stage);
    
SELECT INITCAP(staff_role)
FROM staff;

UPDATE staff
set staff_role = INITCAP(staff_role);


/********************************************************************************
* DATA ANALYSIS- BUSINESS QUESTIONS
********************************************************************************/

-- Question 1: What is the average turnaround time for each staff level?
SELECT  s.staff_level, 
        trunc(avg(rr.turnaround_days), 0) AS Average_Turnaround
FROM    record_requests rr
        JOIN 
        staff s
        ON rr.staff_id = s.staff_id
GROUP BY  s.staff_level
ORDER BY s.staff_level, Average_Turnaround DESC;
/* This analysis showed a direct relationship between staff level and their 
efficiency. Level 3 staff members and Level 2 staff members tied at an average 
of 3 turnaround days. While level 1 staff members had the longest average 
turnaround*/

--Question 2: Which staff level has the best SLA compliance rate (sla_met)?
SELECT  s.staff_level, 
        round((avg(rr.sla_met)*100), 2) as sla_compliance_rate
FROM    record_requests rr
        JOIN 
        staff s
        ON rr.staff_id = s.staff_id
GROUP BY  s.staff_level
ORDER BY sla_compliance_rate DESC;
/*Again, we see a direct relationship between staff level and thei Service-Level 
Agreement compliance rates. Level 3 staff members had the highest compliance 
rate, folowed closely behind by level 2 staff members.
Finally level 1 staff members had the lowest rate at 53%.*/

--Question 3: Does more years of experience directly lead to faster turnaround 
--times, even within the same staff level?
SELECT  s.staff_id, 
        s.staff_level, s.experience, 
        trunc(avg (turnaround_days), 0) AS Average_Turnaround 
FROM    record_requests rr
        JOIN    
        staff s
        ON rr.staff_id = s.staff_id
GROUP BY s.staff_level,vs.experience, s.staff_id
ORDER BY s.staff_level, s.experience DESC, Average_Turnaround;
/*The best performing staff within each level had more years of experience. 
*This analysis showed that there a direct relationship exists between years of 
experience and turnaround times.
*As average turnaround increased as years of experience decreased*/

--Question 4: What are the most common request_types, and do any of them take 
--significantly longer to process?
SELECT rr.request_type, 
    count(rr.request_type) AS Number_of_Requests,
    trunc(avg(rr.turnaround_days),2) AS Average_Turnaround
FROM record_requests rr
GROUP BY rr.request_type 
ORDER BY Number_of_Requests DESC;
/*The most frequent service request type was Billing but it had the second 
shortest processing rate.However, Lab Report which was the 4th service request 
type from a list of 6 had the longest processing rate*/

--Question 5: At which fulfillment_stage are requests most likely to be in a 
--'Rejected' status?
SELECT  rr.fulfillment_stage, 
        rr.status, 
        count(rr.fulfillment_stage)AS Number_of_Rejections
FROM    record_requests rr
WHERE   rr.status = 'Rejected'
GROUP BY rr.status, rr.fulfillment_stage
ORDER BY Number_of_Rejections DESC;
--Rejections occurred most frequently during the 'Review Failed' and 
--'Other Error' stages, identifying them as key process bottlenecks.

--Question 6: Which requester_type (e.g., Doctor, Insurance, Lawyer) has the 
--lowest average satisfaction score?
SELECT  rr.requester_type, 
        trunc(avg(rr.satisfaction_score),2) AS Average_Score
FROM    record_requests rr
GROUP BY rr.requester_type
ORDER BY Average_Score;
/*Admins had the lowest satisfaction score while Insurance had the highest score. 
*The results suggest Admins had a less satisfactory experience compared to other
requester types.*/

--Question 7: Who are the top 3 performers within each staff level based on the 
--fastest average turnaround time?
WITH Top_Staff AS 
    (SELECT     s.experience, 
                s.staff_id, 
                s.staff_level, 
                trunc(avg(rr.turnaround_days), 0) AS Average_Turnaround,
                DENSE_RANK () OVER (PARTITION BY s.staff_level 
                ORDER BY avg(rr.turnaround_days)) AS Staff_Rank 
    FROM        staff s
                JOIN 
                record_requests rr 
                ON rr.staff_id = s.staff_id
    GROUP BY  s.staff_level, s.staff_id, s.experience
    ORDER BY s.staff_level)

SELECT  staff_id,staff_level,
        experience, 
        Average_Turnaround, Staff_Rank
FROM    Top_Staff
WHERE   Staff_Rank <= 3;
/*This analysis confirms our result from question 3.
*The best performers within each level had more years of experience*/


/*Question 8: Can we rank our staff based on their SLA compliance percentage?
NOTE: Chose to skip this question as the project already provides a comprehensive
*performance analysis through turnaround times and top-performer rankings.
*This ranking would offer similar insights without adding significant new value.
WITH SLA_Rank AS
    (SELECT s.staff_id, s.staff_level, round((avg(rr.sla_met)*100), 2) as sla_compliance_rate,
        RANK () OVER (PARTITION BY s.staff_level ORDER BY round((avg(rr.sla_met)*100), 2)DESC) AS sla_rate_rank
FROM record_requests rr
JOIN staff s
ON rr.staff_id = s.staff_id
GROUP BY  s.staff_level, s.staff_id
ORDER BY sla_compliance_rate)

SELECT staff_id, staff_level, sla_rate_rank
FROM sla_rank
ORDER BY staff_level, sla_rate_rank;*/
