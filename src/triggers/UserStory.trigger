/**
	User Story Trigger for Copado Managed Package

	Author: Bobby White
	Company: Salesforce.com
	Date: June 24, 2017
**/
trigger UserStory on copado__User_Story__c (before insert, before update) {
	if (Trigger.isBefore && Trigger.isInsert) {
		UserStoryTriggerHandler.handleBeforeInsert();
	} else if (Trigger.isBefore && Trigger.isUpdate) {
		UserStoryTriggerHandler.handleBeforeUpdate();
	}

}