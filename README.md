**Hospital Operational Efficiency Analysis**

**Executive Summary**

An analysis of the medical records request process reveals that staff experience is the primary driver of operational efficiency. Senior staff (Level 3) consistently outperform junior staff (Level 1) in both processing speed and SLA compliance. Key process inefficiencies were identified, with "Lab Report" requests showing the longest turnaround times and the "Review Failed" and "Other Error" stages being the primary source of rejections. Additionally, the data indicates a potential issue with internal stakeholder satisfaction, as "Admins" reported the lowest satisfaction scores among all requester types. These findings suggest that improvements can be made through targeted staff training and specific process reviews.


**Business Questions Answered**

This analysis sought to answer the following key questions, taken directly from the project's SQL file:

1. What is the average turnaround time for each staff level?
2. Which staff level has the best SLA compliance rate?
3. Does more years of experience directly lead to faster turnaround times, even within the same staff level?
4. What are the most common request types, and do any of them take significantly longer to process?
5. At which fulfillment stage are requests most likely to be in a 'Rejected' status?
6. Which requester type (e.g., Doctor, Insurance, Lawyer) has the lowest average satisfaction score?
7. Who are the top 3 performers within each staff level based on the fastest average turnaround time?
8. How do staff members' years of experience correlate with their request success and failure rates?

**Key Findings**

**1. Staff Performance is Tied to Experience:** 

There is a direct relationship between a staff member's level/experience and their efficiency. Level 3 staff had the fastest average turnaround times (3 days) and the highest SLA compliance rate (93%).

Within each staff level, employees with more years of experience consistently had higher success rates and were ranked as top performers.


**2. Identified Process Bottlenecks:**

While "Billing" was the most common request type, "Lab Report" requests took significantly longer to process than any other type, representing a key inefficiency.

The "Review Failed" and "Other Error" stages were the most frequent points of failure, accounting for the highest number of rejected requests.


**3. Internal Stakeholder Satisfaction Gaps:**

Internal requesters, specifically "Admins," reported the lowest average satisfaction scores, suggesting a potential area for improvement in the internal service experience.

**Recommendations**

**Implement a Targeted Training & Mentorship Program:**
Pair Level 1 staff with high-performing, experienced Level 3 staff to improve their processing speed, success rates, and SLA compliance.

**Initiate a Process Review for Bottlenecks:**
Conduct a detailed process review for "Lab Report" requests to identify and address the root causes of their long turnaround times. Similarly, analyze the "Review Failed" stage to understand and reduce the high number of rejections.

**Improve Internal Stakeholder Experience:**
Conduct follow-up surveys or meetings with 'Admin' and 'Doctor' requesters to understand the reasons for their low satisfaction scores and identify areas for service improvement.

**Establish a Knowledge-Sharing Program:**
Formalize a program where specialists with the highest success rates lead workshops or mentorship sessions to scale their effective practices across the department.
