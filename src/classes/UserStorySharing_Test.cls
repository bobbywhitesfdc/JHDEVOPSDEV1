/**
   Functional Test - UserSTorySharing_Test

   Ensure that a normal Copado developer without elevated access rights can 
   work with UserStories

**/
@isTest
private class UserStorySharing_Test {

	@testSetup static void setup() {
		TestDataFactory.setup();
	}
	
	/**
	  Developer Creates a User Story in a Project created by REM
	**/
	@isTest static void testCreateUserStory() {
		// get Project
		copado__Project__c project = TestDataFactory.getProject();
		copado__Release__c release = TestDataFactory.getRelease(project.id);
		copado__Environment__c env = TestDataFactory.getEnvironment(project.id);
		copado__Org__c orgCred = TestDataFactory.getDefaultOrgCred(env.id);
		copado__Git_Backup__c snapShot = TestDataFactory.getSnapShot(orgCred.id);

		// Create User Story
		copado__User_Story__c myUserStory = new copado__User_Story__c(copado__User_Story_Title__c='My User Story'
			                                                         ,copado__Project__c=project.id
			                                                         ,copado__Release__C=release.id
			                                                         ,copado__Org_Credential__c= orgCred.id);

		insert myUserStory;

		// Get SnapShot & Commit against it, add to this User Story
        copado__Git_Org_Commit__c myCommit = new copado__Git_Org_Commit__c(copado__Git_Backup__c = snapShot.id
        	                                                              ,copado__Org__c = orgCred.id
        	                                                              ,copado__Status__c=TestDataFactory.COMPLETE
        	                                                              ,copado__Commit_Id__c = '12345'
        	                                                              ,copado__Commit_Message__c = 'My changes');

        insert myCommit;

        copado__User_Story_Commit__c usCommit = new copado__User_Story_Commit__c(copado__User_Story__c = myUserStory.id
        	                                                                    ,copado__Snapshot_Commit__c = myCommit.id);

        insert usCommit;

        System.Assert(true,'Just getting here without an exception is good enough :-)');
	}
	
	@isTest static void testCommitAgainstExistingUS() {
		// Get their User Story
		copado__User_Story__c theirUserStory = TestDataFactory.getUserStory();

		// Back into the right Snapshot
		copado__Git_Backup__c snapShot = TestDataFactory.getSnapShot(theirUserStory.copado__Org_Credential__c);

		// Get SnapShot & Commit against it, add to this User Story
        copado__Git_Org_Commit__c myCommit = new copado__Git_Org_Commit__c(copado__Git_Backup__c = snapShot.id
        	                                                              ,copado__Org__c = theirUserStory.copado__Org_Credential__c
        	                                                              ,copado__Status__c=TestDataFactory.COMPLETE
        	                                                              ,copado__Commit_Id__c = '12345xx'
        	                                                              ,copado__Commit_Message__c = 'My changes');

        insert myCommit;

        copado__User_Story_Commit__c usCommit = new copado__User_Story_Commit__c(copado__User_Story__c = theirUserStory.id
        	                                                                    ,copado__Snapshot_Commit__c = myCommit.id);

        insert usCommit;


	}
	
}