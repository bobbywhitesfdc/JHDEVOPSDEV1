/**
	User Story Trigger for Copado Managed Package

	Author: Bobby White
	Company: Salesforce.com
	Date: June 24, 2017
**/
public with sharing class UserStoryTriggerHandler {
	/**
	  Validations that require Apex code + default overrides
	**/
	public static void handleBeforeInsert() {
		for (copado__User_Story__c current : (List<copado__User_Story__c>) Trigger.new) {
			current.copado__Promote_and_Deploy__c = false; // clear this if cloned record or bulk load
		}
	}

	/**
	  Validations that require Apex code
	**/	
	public static void handleBeforeUpdate() {

		System.Debug('handleBeforeUpdate');
		List<Id> mentions = new List<Id>();
		mentions.add(UserInfo.getUserId());


		//List<copado__User_Story__c> toValidateBMP = new List<copado__User_Story__c>();

		for (copado__User_Story__c current : (List<copado__User_Story__c>) Trigger.new) {

			if (current.copado__Promote_and_Deploy__c) {
				if (current.copado__Project__c == null || current.copado__Environment__c == null) {
					current.addError(Label.MSG_PROMOTE_REQUIRED_FIELDS);
				} else {
					// Need to validate that they have Branch Management Permissions to execute deployment in destination
					// destination is configured in the Deployment flow associated with this Project.
					// ProjectId + SourceEnvId
					//toValidateBMP.add(current);
					if (!hasBMPForDestination(current)) {

						// Instead of throwing an error, we're just going to turn it back off!
						current.copado__Promote_and_Deploy__c = false;
					}
				}
			}
		}

	}

	@TestVisible private static Boolean hasBMPForDestination(copado__User_Story__c current) {
		final copado__Project__c project = [SELECT id, copado__Deployment_Flow__c 
											  FROM copado__Project__c 
									   		 Where Id = :current.copado__Project__c];

		final List<copado__Deployment_Flow_Step__c> steps = [SELECT copado__Destination_Environment__c 
												  		 	   FROM copado__Deployment_Flow_Step__c 
												 			  WHERE copado__Deployment_Flow__c = :project.copado__Deployment_Flow__c
												   		  		AND copado__Source_Environment__c = :current.copado__Environment__c];

		if (steps.isEmpty()) {
			System.Debug('No deployment steps found');
			return false; 
		}

		final List<copado__Branch_Management_Permission__c> bmps = [SELECT copado__Allow_Deployments__c, copado__Environment__r.name
		   												 	    	  FROM copado__Branch_Management_Permission__c
		  													   		 WHERE copado__User__c = : userInfo.getUserId() 
		    											  	     	   AND copado__Environment__c = : steps[0].copado__Destination_Environment__c];

		System.Debug('No BMP - isEmpty?' + bmps.IsEmpty() + ' count=' + bmps.size());
		
		Boolean hasBMP = bmps.isEmpty() ? false : bmps[0].copado__Allow_Deployments__c;
		if (!hasBMP) {
			final List<Id> mentions = new List<Id>();
			mentions.add(UserInfo.getUserId());
			final String envName =  (bmps.isEmpty() ? (String) steps[0].copado__Destination_Environment__c : bmps[0].copado__Environment__r.name);
			final String msg = Label.MSG_NO_BMGT_PERMISSIONS + ' ' + envName;
			System.debug('BMP env=' + envName);
			NotifyUtil.sendEmail('User Story ' + current.name + ' cannot Promote & Deploy',msg);
			NotifyUtil.chatterPost(current.id,' ' + msg,mentions);
		}

		return hasBMP;
	}
}