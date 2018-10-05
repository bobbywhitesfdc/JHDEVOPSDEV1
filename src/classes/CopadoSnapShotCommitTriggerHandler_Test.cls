/**
 * Test the CopadoSnapShotCommitTriggerHandler class
 **/
@istest
public class CopadoSnapShotCommitTriggerHandler_Test {
        
    @testSetup public static void setup() {
        TestDataFactory.setup();
    }

        
    /**
     * User Story adds a Commit as Pending
     **/ 
    private static testmethod void testInsert() {
        // Add Commit As Pending
        // Add UserStory Commit
         
        copado__User_Story_Commit__c  usCommit = new copado__User_Story_Commit__c (copado__Snapshot_Commit__c = TestDataFactory.getSnapShotCommit().id
                                                                                  ,copado__User_Story__c = TestDataFactory.getUserStory().id);
        insert usCommit;
        
        
        
        System.debug('Commit.id: ' + usCommit.Id);
        
        Test.startTest();
        copado__User_Story_Commit__c usCommitAfter = [SELECT id,name,Status__c 
                                                      FROM copado__User_Story_Commit__c
                                                      WHERE id = :usCommit.id];
        Test.stopTest();
        
        System.Assert(usCommitAfter != null,'After must not be null');
        System.AssertEquals(usCommitAfter.status__c,TestDataFactory.PENDING,'Expected Pending Status');
        
    }
 
    private static testmethod void testUpdate() {
        // Update Commit status from Pending --> Complete
        // Add Commit As Pending
        // Add UserStory Commit
        // Update the original Commit to 'Complete'
        
        copado__Git_Org_Commit__c theTestCommit = TestDataFactory.getSnapShotCommit();
        copado__User_Story_Commit__c  usCommit = new copado__User_Story_Commit__c (copado__Snapshot_Commit__c = theTestCommit.id
                                                                                  ,copado__User_Story__c = TestDataFactory.getUserStory().id);
        insert usCommit;
        
        System.debug('Commit.id: ' + usCommit.Id);
        
        theTestCommit.copado__Status__c = TestDataFactory.COMPLETE;
        update theTestCommit;
        
        Test.startTest();
        copado__User_Story_Commit__c usCommitAfter = [SELECT id,name,Status__c 
                                                      FROM copado__User_Story_Commit__c
                                                      WHERE id = :usCommit.id];
        Test.stopTest();
        
        System.Assert(usCommitAfter != null,'After must not be null');
        System.AssertEquals(usCommitAfter.status__c,TestDataFactory.COMPLETE,'Expected Complete Status');
        
        
        
    }

}