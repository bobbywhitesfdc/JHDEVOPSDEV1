/**
  UserStoryValidation_Test

  Acts as a FUNCTIONAL test to ensure end-to-end capability works as intended for User
  Story promotion.

  Author: Bobby White
  Date: March 23, 2017
  
**/
@isTest
public class UserStoryValidation_Test {

	@testSetup
	private static void setup() {
		TestDataFactory.setup();
	}

	/**
	  Scenario - no conflict commits, ensure that the validation rules don't prevent
	  the user story from being flagged for promotion
	**/
	private static testmethod void testPositive() {
        // Update Commit status from Pending --> Complete
        // Add Commit As Pending
        // Add UserStory Commit
        // Update the original Commit to 'Complete'
        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();
        
        copado__Git_Org_Commit__c theTestCommit = TestDataFactory.getSnapShotCommit();
        copado__User_Story_Commit__c  usCommit = new copado__User_Story_Commit__c (copado__Snapshot_Commit__c = theTestCommit.id
                                                                                  ,copado__User_Story__c = theUserStory.id);
        insert usCommit;
        
        System.debug('Commit.id: ' + usCommit.Id);
        
        theTestCommit.copado__Status__c = TestDataFactory.COMPLETE;
        update theTestCommit;
        
        Test.startTest();

        theUserStory = [SELECT Id, ConflictCommits__c 
                          FROM copado__User_Story__c
                         WHERE id = :theUserStory.id];

        // Now attempt to set the user story to promote and save it
        System.Assert(theUserStory.ConflictCommits__c == 0,'Did not expect conflict commits');
        theUserStory.copado__Promote_Change__c = true;
        update theUserStory;

        System.Assert(true,'Success');

        Test.stopTest();
               
        
      
	}

	/**
	  Scenario - Story has conflict commits, ensure that the validation rules prevent
	  the user story from being flagged for promotion
	**/
	private static testmethod void testConflict() {
		 // Update Commit status from Pending --> Complete
        // Add Commit As Pending
        // Add UserStory Commit
        // Update the original Commit to 'Conflict'

        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();
        
        copado__Git_Org_Commit__c theTestCommit = TestDataFactory.getSnapShotCommit();
        copado__User_Story_Commit__c  usCommit = new copado__User_Story_Commit__c (copado__Snapshot_Commit__c = theTestCommit.id
                                                                                  ,copado__User_Story__c = theUserStory.id);
        insert usCommit;
        
        System.debug('Commit.id: ' + usCommit.Id);
        
        theTestCommit.copado__Status__c = TestDataFactory.CONFLICT;
        update theTestCommit;
        
        Test.startTest();

        theUserStory = [SELECT Id, ConflictCommits__c 
                          FROM copado__User_Story__c
                         WHERE id = :theUserStory.id];

        System.Assert(theUserStory.ConflictCommits__c == 1,'Expected conflict commits');


        // Now attempt to set the user story to promote and save it
        try {
        	theUserStory.copado__Promote_Change__c = true;
            update theUserStory;
            System.Assert(false,'Failed to raise expected validation error');

        } catch (System.DmlException ex) {
            System.Assert(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'),'Expected a validation error mentioning conflicts');
        }



        Test.stopTest();
               
        
      


	}
}