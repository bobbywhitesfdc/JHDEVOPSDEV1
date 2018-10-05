@isTest
private class UserStoryTriggerHandler_Test {

	
	@isTest static void test_Insert() {

		TestDataFactory.setup();

		// Create a user Story setting Promote & Deploy
		copado__User_Story__c myUserStory = new copado__User_Story__c();
		myUserStory.copado__User_Story_Title__c = 'Test';
		myUserStory.copado__project__c = TestDataFactory.getProject().id;
		myUserStory.copado__promote_and_deploy__c = true;

		insert myUserStory;

		copado__User_Story__c afterInsert = [SELECT id,copado__promote_and_deploy__c From copado__User_Story__c where Id = :myUserStory.id];

		System.AssertEquals(false,afterInsert.copado__promote_and_deploy__c,'Expected promote and deploy to be off');


	}

	@isTest static void test_UpdateMissingReqFields() {

		TestDataFactory.setup();

		copado__User_Story__c myUserStory = TestDataFactory.getUserStory();
		myUserStory.copado__promote_and_deploy__c = true;
		myUserStory.copado__project__c = null; // null this out

		try {

			update myUserStory;
			System.Assert(false,'Should not reach this line');

		} catch (System.DmlException ex) {
			System.Assert(ex.getMessage().contains(Label.MSG_PROMOTE_REQUIRED_FIELDS),'Expected required fields validation error');
		}
	}
	
	@isTest static void test_UpdateNoBMP() {

		TestDataFactory.setup();

		copado__User_Story__c myUserStory = TestDataFactory.getUserStory();
		myUserStory.copado__promote_and_deploy__c = true;

		update myUserStory;

		copado__User_Story__c afterUpdate = [SELECT id,copado__promote_and_deploy__c From copado__User_Story__c where Id = :myUserStory.id];

		System.AssertEquals(false,afterUpdate.copado__promote_and_deploy__c,'Expected promote and deploy to be off');		
	}

    /**
      SPECIAL Handling here... can't create the Deployment Flow steps because of this exception:
       MESSAGE 
System.DmlException: Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The maximum number of active connections has already been reached. 
Please deactivate some Deployment Flows or contact Sales@copa.do to increase your limit.: []

Until we get a workaround for this, we have to enable SeeAllData=true :-(
    **/
	@isTest(seeAllData=true) 
	static void test_UpdateYesBMP() {

		// Pick an existing Deployment Flow Step
		copado__deployment_flow_step__c step = [SELECT id
													 , copado__Deployment_Flow__c
													 , copado__Source_Environment__c
													 , copado__Destination_Environment__c
												  FROM copado__deployment_flow_step__c
												  LIMIT 1];

		// Pick an existing Project that references this Flow
		copado__Project__c project = [SELECT Id 
										From copado__Project__c 
									   Where copado__deployment_flow__c = :step.copado__deployment_flow__c LIMIT 1];

		copado__Org__c orgCred = [SELECT id From copado__Org__c 
								   Where copado__environment__c = :step.copado__Source_Environment__c
								   	LIMIT 1];

		copado__User_Story__c myUserStory = new copado__User_Story__c(copado__project__c = project.id
																	 ,copado__environment__c = step.copado__Source_Environment__c
																	 ,copado__Org_Credential__c = orgCred.id);

		insert myUserStory;


		Test.startTest();

		User testUser = TestDataFactory.getDevUser();

		System.RunAs(testUser) {
				myUserStory.copado__promote_and_deploy__c = true;
				final Boolean result = UserStoryTriggerHandler.hasBMPForDestination(myUserStory);
				System.AssertEquals(false,result,'Expected BMP to be false before adding');		

		}


		// Add BMP for the destination Environment
		copado__Branch_Management_Permission__c bmp = new copado__Branch_Management_Permission__c(copado__environment__c=step.copado__Destination_Environment__c
																								 ,copado__Allow_Deployments__c = true
																								 ,copado__User__c = testUser.id);
		insert bmp;


		System.RunAs(testUser) {
				myUserStory.copado__promote_and_deploy__c = true;
				final Boolean result = UserStoryTriggerHandler.hasBMPForDestination(myUserStory);
				System.AssertEquals(true,result,'Expected BMP to be yes');		

		}

		Test.stopTest();

	}
	
}