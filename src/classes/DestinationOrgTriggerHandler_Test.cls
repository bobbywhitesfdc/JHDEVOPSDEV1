/**
  Class:   DestinationOrgTriggerHandler_Test

  Author:  Bobby White
  Company:  Salesforce.com
**/
@isTest
private class DestinationOrgTriggerHandler_Test {

    @testSetup static void setup() {
        // Create the Deployment Flow, etc
        TestDataFactory.setup();

        // Create Deployment
        copado__Org__c devOrg = getOrgByName(TestDataFactory.ORGNAME_DEV);
        copado__Org__c sitOrg = getOrgByName(TestDataFactory.ORGNAME_SIT);
        copado__Org__c prodOrg = getOrgByName(TestDataFactory.ORGNAME_PROD);

        copado__Deployment__c deployment = new copado__Deployment__c(name='Test Deployment', copado__From_Org__c = devOrg.id);
        insert deployment;

        List<copado__Destination_Org__c> destinations = new List<copado__Destination_Org__c>();

        destinations.add(new copado__Destination_Org__c(copado__Deployment__c=deployment.id, copado__To_Org__c=sitOrg.id));
        destinations.add(new copado__Destination_Org__c(copado__Deployment__c=deployment.id, copado__To_Org__c=prodOrg.id));

        insert destinations;

    }
    
    @isTest static void test_noPerms() {
        Test.startTest();

        Database.SaveResult[] results = updateDestinationOrgs();

        Test.stopTest();

        System.Assert(checkResults(results,Label.MSG_NO_BMGT_PERMISSIONS),'Expected FAILURE');

    }
    
    @isTest static void test_withPerms() {

        addBranchManagementPerms();

        Test.startTest();

        Database.SaveResult[] results = updateDestinationOrgs();

        Test.stopTest();

        System.Assert(checkResults(results,null),'Expected Success');


    }

    private static copado__Org__c getOrgByName(String name) {
        List<copado__Org__c> orgs = [SELECT id, name From copado__Org__c Where name = :name LIMIT 1];
        return orgs.isEmpty() ? null : orgs[0];
    }

    private static copado__Deployment__c getDeployment() {
         return [SELECT id,name From copado__Deployment__c LIMIT 1];
    }

    private static Database.SaveResult[] updateDestinationOrgs() {
        // Update all of the Destinations for our deployment do it in bulk
        copado__Deployment__c myDeployment = getDeployment();
        List<copado__Destination_Org__c> destinations = [SELECT id
                                                              , copado__Status__c
                                                              , copado__To_Org__c 
                                                           From copado__Destination_Org__c
                                                           Where copado__Deployment__c = :myDeployment.id];
        for (copado__Destination_Org__c current : destinations) {
            current.copado__Status__c = 'In Progress';
        }

        // Execute using Database method to allow partial success in Bulk mode
        return Database.update(destinations, false);
    }

    private static Boolean checkResults(Database.SaveResult[] results, String expectedMsg) {
        for (Database.SaveResult result : results) {
            if (expectedMsg != null && result.getErrors().isEmpty()) {
                return false;
            } else if (expectedMsg != null && !result.getErrors().isEmpty()) {
                System.Assert(result.getErrors()[0].getMessage().contains(expectedMsg),'Expected message not found');
            } else if (expectedMsg == null && !result.getErrors().isEmpty()) {
                System.AssertEquals(null,result.getErrors()[0].getMessage(),'No message expected');
            }
        }

        return true;
    }

    private static void addBranchManagementPerms() {

        List<copado__Branch_Management_Permission__c> bPerms = new List<copado__Branch_Management_Permission__c>();

        for (copado__Environment__c current : [SELECT Id, Name 
                                                    From copado__Environment__c 
                                                   LIMIT 100] ) {
            bPerms.add(new copado__Branch_Management_Permission__c(copado__Environment__c=current.Id
                                                                , copado__Allow_Deployments__c=true
                                                                , copado__User__c = userInfo.getUserId()));
        }

        insert bPerms;

    }
    
}