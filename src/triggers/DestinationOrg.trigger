/**
  Trigger:   DestinationOrgTrigger

  Trigger handler that enforces policy that user executing a Deployment must 
  have the Branch Management Permission on the destination org with "Allow Deployments"

  The handler works by preventing updates to the Destination_Org record that is associated 
  with the deployment

  Author:  Bobby White
  Company:  Salesforce.com
**/

trigger DestinationOrg on copado__Destination_Org__c (before update) {

    DestinationOrgTriggerHandler.handleBeforeUpdate();
}