<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approve_Solution_Design</fullName>
        <description>Mark this Story as approved the Solution Design stage</description>
        <field>Solution_Review_Completed__c</field>
        <literalValue>1</literalValue>
        <name>Approve Solution Design</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Active</fullName>
        <description>Change the Record Type back to Active</description>
        <field>RecordTypeId</field>
        <lookupValue>Active</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_Review</fullName>
        <description>Change the Record Type to Review to force a different Page Layout to be shown</description>
        <field>RecordTypeId</field>
        <lookupValue>Review</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Status_to_Pending_Design_Review</fullName>
        <description>Change the Status to Pending Solution Review</description>
        <field>copado__Status__c</field>
        <literalValue>Pending Design/Review of What&apos;s Built Meeting</literalValue>
        <name>Change Status to  Pending Design Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Component_Review_Failed</fullName>
        <description>Uncheck the box for Component Review completed</description>
        <field>Code_Review_Completed__c</field>
        <literalValue>0</literalValue>
        <name>Component Review Failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Component_Review_Passed</fullName>
        <description>Component Review has passed, check the box.</description>
        <field>Code_Review_Completed__c</field>
        <literalValue>1</literalValue>
        <name>Component Review Passed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Post_Component_Review_Status</fullName>
        <description>Update the  Status After the Component Review to indicate it&apos;s done and ready for the next step.</description>
        <field>copado__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Post Component Review Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>REM_Review_Failed</fullName>
        <description>REM Review of Manual Tasks Failed</description>
        <field>REM_Review_Completed__c</field>
        <literalValue>0</literalValue>
        <name>REM Review Failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>REM_Review_Passed</fullName>
        <description>REM Review of Manual Tasks Passed</description>
        <field>REM_Review_Completed__c</field>
        <literalValue>1</literalValue>
        <name>REM Review Passed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>REM_Status_Rejected</fullName>
        <description>Update status to Rejected after REM Review</description>
        <field>copado__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>REM Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Status_on_Recall</fullName>
        <description>Reset the Record Status on Recall</description>
        <field>copado__Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>Reset Status on Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Solution_Review_Failed</fullName>
        <description>Solution Review failed and the User Story will be rejected until the objections are removed.</description>
        <field>Solution_Review_Completed__c</field>
        <literalValue>0</literalValue>
        <name>Solution Review Failed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Solution_Review_Passed</fullName>
        <description>Indicate that the Solution Review has Passed</description>
        <field>Solution_Review_Completed__c</field>
        <literalValue>1</literalValue>
        <name>Solution Review Passed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_After_All_Reviews</fullName>
        <description>All Reviews Completed</description>
        <field>copado__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status After All Reviews</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_After_Solution_Review</fullName>
        <description>Status after Solution Review completed</description>
        <field>copado__Status__c</field>
        <literalValue>Solution Review Completed</literalValue>
        <name>Status After Solution Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected_Code_Review</fullName>
        <description>Set the status back to Rejected after a failed code review</description>
        <field>copado__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Rejected Code Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_after_REM_Review</fullName>
        <description>Update the Status after REM Review</description>
        <field>copado__Status__c</field>
        <literalValue>REM Review Completed</literalValue>
        <name>Status after REM Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_after_Rejection</fullName>
        <description>Update the Status after Approval Rejection</description>
        <field>copado__Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status after Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
