/**
  Class:   DeploymentJobTriggerHandler

  Trigger handler that enforces policy that user executing a Deployment must 
  have the Branch Management Permission on the destination org with "Allow Deployments"

  The handler works by preventing updates to the copado__Deployment_Job__c record that is associated 
  with the deployment Destination

  Author:  Bobby White
  Company:  Salesforce.com
**/
public with sharing class DeploymentJobTriggerHandler 
{
	public static void handleBeforeInsert() {
		checkForBMP();

	}
	public static void handleBeforeUpdate() {
		checkForBMP();
	}

    public static void checkForBMP() {
        // Get the list of Destination Orgs (must dereference this from the job)
        final Set<Id> destOrgs = new Set<Id>();
        for (copado__Deployment_Job__c current : (List<copado__Deployment_Job__c>) Trigger.new) {
            destOrgs.add(current.copado__Destination_Org__c);
        }

        // Get the list of Orgs
        final Set<Id> orgs = new Set<Id>();
        final Map<Id,Id>  destOrgMap = new Map<Id,Id>();
        for (copado__Destination_Org__c current : [SELECT id, copado__To_Org__c From copado__Destination_Org__c where id IN :destOrgs ]) {
            orgs.add(current.copado__To_Org__c);
            destOrgMap.put(current.id,current.copado__To_Org__c);
        }


        // Get Branch Management Permission for this user for the Orgs in scope
        final Map<Id,Boolean> bmpMap = new Map<Id,Boolean>();
        for (copado__Branch_Management_Permission__c current : [SELECT copado__Allow_Deployments__c,copado__Environment__c
                                                                  FROM copado__Branch_Management_Permission__c
                                                                 WHERE copado__User__c = :userInfo.getUserId()
                                                                   AND copado__Allow_Deployments__c = true 
                                                                   AND copado__Environment__c IN
                                                                    (SELECT copado__environment__c From Copado__Org__c  
                                                                      where id IN :orgs) ]) {

            bmpMap.put(current.copado__Environment__c,current.copado__Allow_Deployments__c);
        }

        // Need a lookup to join beteen OrgCred and Environment to lookup in BMP map
        final Map<Id,copado__Org__c> orgInfoMap = new Map<Id,copado__Org__c>([SELECT Id, Name, copado__Environment__c
                                         FROM copado__Org__c 
                                        Where id in :orgs]);

        NotifyUtil.chatterPost(UserInfo.getUserId(),'Checking BMP for deployment Jobs',null);

        /**
          Check for changes to the Status field.
        **/
        for (copado__Deployment_Job__c current : (List<copado__Deployment_Job__c>) Trigger.new) {

            // Prevent status changes for promotions to Managed Sandboxes
            // Current User must have branch management permission
 
            copado__Deployment_Job__c old = (copado__Deployment_Job__c) Trigger.oldMap.get(current.Id);

            System.Debug('Evaluating Deployment Job ' + current.id + ' ' + current.name 
            	+ ' old=' + old.copado__status__c + ' current=' + current.copado__status__c);

            final Id orgId = destOrgMap.get(current.copado__Destination_Org__c);
            final Id envId = orgInfoMap.get(orgId).copado__Environment__c;
            final Boolean bmp = bmpMap.get(envId);

            System.Debug('Bmp=' + bmp);

            if (bmp == null || !bmp) {
               String msg = userInfo.getUserName() + ' ' + Label.MSG_NO_BMGT_PERMISSIONS + ' Environment: ' + envId;
               NotifyUtil.sendEmail('Unable to execute Deployment',msg);
               current.addError(msg);

            } 
        }

    }
}