//module ministryofJustice
open util/ordering [Time] as T
---------------- Signatures ----------------
sig Time {}
--------------------------------------------
-------------------------------------------
sig Directorate_General_of_Justice_of_the_province  {}
// sub directors
sig
Core_selection,
Appeals_and_criminal_courts_of_the_province,
Justice_and_public_prosecutors_office_and_the_revolution_of_the_cities,
Provincial_courts,
Presidency,
Vice_President_of_Planning,
Deputy_of_Statistics_and_Information_Technology,
Vice_President_of_the_Dispute_Resolution_Council,
Vice_President_of_Education,
Deputy,
Judicial_Deputy,
Social_assistant_for_crime_prevention,
Administrative_and_financial_assistant_and_support,
Public_relations_and_communication_management,
Public_Prosecutors_Office_and_Revolution_in_the_center_of_the_province,
General_and_revolutionary_courts_of_the_center_of_the_province,
Protection_and_information_management
{
Responsive_to : Directorate_General_of_Justice_of_the_province
}
// sub presidency
sig
Office_of_the_Secretariat,
Inspection_and_complaints_handling_department,
Secretariat_of_the_Board_of_Supervision_and_Citizen_Rights,
Secretariat_of_the_committee_for_judicial_protection_of_investment,
Office_of_Prisoners
{
Sub_department_of : Presidency
}
// sub Vice President of Planning
sig
Management_of_planning_and_follow_up_of_plans,
Management_of_organizations_procedures_and_documents
{
Sub_department_of : Vice_President_of_Planning
}
// sub Deputy of Statistics and Information Technology
sig
Software_management,
Statistics_and_information_management,
Infrastructure_management
{
Sub_department_of : Deputy_of_Statistics_and_Information_Technology
}
//sub Vice_President_of_the_Dispute_Resolution_Council
sig
Supervision_and_inspection_department,
Department_of_Public_Affairs
{
Sub_department_of : Vice_President_of_the_Dispute_Resolution_Council
}
// sub Vice_President_of_Education
sig
Management_of_administrative_and_judicial_training,
Educational_and_library_planning_management
{
Sub_department_of : Vice_President_of_Education
}
// sub Social_assistant_for_crime_prevention
sig
Crime_prevention_management,
Social_management_and_public_participation
{
Sub_department_of : Social_assistant_for_crime_prevention
}
// sub Administrative_and_financial_assistant_and_support
sig
Department_of_supervision_of_employee_performance_evaluation,
Management_of_administrative_affairs_and_human_resources,
Management_of_welfare_cooperation_and_social_security,
Finance_management,
Support_and_service_management,
Technical_and_engineering_management
{
Sub_department_of : Administrative_and_financial_assistant_and_support
}
// sub Public_Prosecutors_Office_and_Revolution_in_the_center_of_the_province
sig
Prosecutorial_and_investigation_branches
{
Sub_department_of : Public_Prosecutors_Office_and_Revolution_in_the_center_of_the_province
}
sig
Criminal_and_legal_branches
{
Sub_department_of : General_and_revolutionary_courts_of_the_center_of_the_province
}
/////////////////////////////////////////////////////////////////////
//abstract sig  Case 
//{
//analyzing_by : one Criminal_and_legal_branches -> Time,
//existance : set Time
//}
//sig openCase,closedCase extends Case
//{
//status : Case-> Time
//}
/////////////////////////////////////////////////////////////////////
----------------Predicts and Facts----------------
// Departments
fact {
#Directorate_General_of_Justice_of_the_province = 1
#Core_selection = 1
#Appeals_and_criminal_courts_of_the_province >= 1
#Justice_and_public_prosecutors_office_and_the_revolution_of_the_cities = 1
#Provincial_courts > 1
#Presidency = 1
#Vice_President_of_Planning = 1
#Deputy_of_Statistics_and_Information_Technology = 1
#Vice_President_of_the_Dispute_Resolution_Council = 1
#Vice_President_of_Education = 1
#Deputy = 1
#Judicial_Deputy = 1
#Social_assistant_for_crime_prevention = 1
#Administrative_and_financial_assistant_and_support = 1
#Public_relations_and_communication_management = 1
#Public_Prosecutors_Office_and_Revolution_in_the_center_of_the_province = 1
#General_and_revolutionary_courts_of_the_center_of_the_province >= 1
#Protection_and_information_management = 1
}
// Sub Departments
fact {
// sub Presidency
#Office_of_the_Secretariat = 1
#Inspection_and_complaints_handling_department = 1
#Secretariat_of_the_Board_of_Supervision_and_Citizen_Rights = 1
#Secretariat_of_the_committee_for_judicial_protection_of_investment = 1
#Office_of_Prisoners = 1
// sub Vice President of Planning
#Management_of_planning_and_follow_up_of_plans = 1
#Management_of_organizations_procedures_and_documents = 1
// sub Deputy of Statistics and Information Technology
#Software_management = 1
#Statistics_and_information_management = 1
#Infrastructure_management = 1
//sub : Vice President of the Dispute Resolution Council
#Supervision_and_inspection_department = 1
#Department_of_Public_Affairs = 1
// sub Vice President of Education
#Management_of_administrative_and_judicial_training = 1
#Educational_and_library_planning_management = 1
//sub  Social assistant for crime prevention
#Crime_prevention_management = 1
#Social_management_and_public_participation = 1
// sub Administrative_and_financial_assistant_and_support
#Department_of_supervision_of_employee_performance_evaluation = 1
#Management_of_administrative_affairs_and_human_resources = 1
#Management_of_welfare_cooperation_and_social_security = 1
#Finance_management = 1
#Support_and_service_management = 1
#Technical_and_engineering_management = 1
// sub Public_Prosecutors_Office_and_Revolution_in_the_center_of_the_province
#Prosecutorial_and_investigation_branches >= 1
// sub General_and_revolutionary_courts_of_the_center_of_the_province
#Criminal_and_legal_branches >= 1
/////////////////////////////////////////////////////////////////////
//pred initial_status [opt,t2: Time]{
//(one c1.openCase.t and no c1.closedCase.t)
//and
//(one c1.closedCase.t and no c1.openCase.t)
/////////////////////////////////////////////////////////////////////
//Time
//Constraint
//assert
}



 ----------------Assertions----------------
 ----------------Commands----------------
run {}
