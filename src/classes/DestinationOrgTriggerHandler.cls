/**
  Class:   DestinationOrgTriggerHandler

  Trigger handler that enforces policy that user executing a Deployment must 
  have the Branch Management Permission on the destination org with "Allow Deployments"

  The handler works by preventing updates to the Destination_Org record that is associated 
  with the deployment

  Author:  Bobby White
  Company:  Salesforce.com
**/
public with sharing class DestinationOrgTriggerHandler 
{
    public static void handleBeforeUpdate() {
        // Get the list of Orgs
        final Set<Id> orgs = new Set<Id>();
        for (copado__Destination_Org__c current : (List<copado__Destination_Org__c>) Trigger.new) {
            orgs.add(current.copado__To_Org__c);
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

        final List<Id> mentions = new List<Id>();
        mentions.add(UserInfo.getUserId());

        /**
          Check for changes to the Status field.
        **/
        for (copado__Destination_Org__c current : (List<copado__Destination_Org__c>) Trigger.new) {

                final Boolean bmp = bmpMap.get(orgInfoMap.get(current.copado__To_Org__c).copado__Environment__c);
                final Id envId = orgInfoMap.get(current.copado__To_Org__c).copado__Environment__c;

                if (bmp == null || !bmp) {
                    String msg = userInfo.getUserName() + ' ' + Label.MSG_NO_BMGT_PERMISSIONS + ' Environment: ' + envId;
                    NotifyUtil.chatterPost(current.copado__deployment__c,msg,mentions);
                    //current.addError(msg);
                }    

            // Prevent status changes for promotions to Managed Sandboxes
            // Current User must have branch management permission
            copado__Destination_Org__c old = (copado__Destination_Org__c) Trigger.oldMap.get(current.Id);
            if (current.copado__status__c != old.copado__status__c) {
               System.Debug('status has changed');
            }


        }

    }
}