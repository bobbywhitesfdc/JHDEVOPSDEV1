/**
   Copado Environment Trigger Handler class

   Does the heavy lifting for the trigger

   Must run without sharing to ensure that operations will succeed regardless of visibility provided through sharing rules
**/
public without sharing class EnvironmentTriggerHandler {
	public static final String TYPE_SANDBOX = 'Sandbox';
     /**
       Set default values - Production Orgs are always managed
     **/
	 public static void handleBeforeInsert(List<Copado__Environment__c> environments) {

	 	System.debug('handleBeforeInsert');

	 	for (Copado__Environment__c current : environments) {
	 		current.isManaged__c = (current.copado__Type__c != TYPE_SANDBOX);
	 		System.debug('Name: ' + current.name + ' Type: ' + current.copado__type__c + ' isManaged: ' + current.isManaged__c);
	 	}


	 }

	 /**
	    Handle After Insert operation
	 **/
	 public static void handleAfterInsert(Map<Id,Copado__Environment__c> envMap) {
	 	setOrgCredentialFields(envMap);
	 }

	 /**
	 **/
	 public static void handleAfterUpdate(Map<Id,Copado__Environment__c> envMap) {
	 	setOrgCredentialFields(envMap);
	 }

	 /**
	    Set isManaged and isDevelopmentSandbox fields on Org Credentials tied to Environment
	 **/
	 private static void setOrgCredentialFields(Map<Id,Copado__Environment__c> envMap)  {
	 	// Query for the Org Credentials Connected to these Environments
	 	// Propagate the values of isManaged and isDevelopmentSandbox


        final List<copado__Org__c> orgCreds = new List<copado__Org__c>();
	 	for (copado__Org__c current : [SELECT id, copado__Environment__c 
	 		                             FROM copado__Org__c
	 		                            WHERE copado__environment__c IN :envMap.keySet()]) {
	 		Copado__Environment__c env = envMap.get(current.Copado__Environment__c);
	 		current.isManaged__c = env.isManaged__c;
	 		current.isDevelopmentSandbox__c = env.isDevelopmentSandbox__c;
	 		orgCreds.add(current);
	 	}

	 	if (!orgCreds.isEmpty()) {
	 		update orgCreds;
	 	}
	 }
}