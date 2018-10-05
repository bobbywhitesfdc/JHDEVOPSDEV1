/**
   UserStoryListController_Test is a unit test for 
   UserStoryListController 
   which is used on the Apex Page: UserStoryListReview

   Author:  Bobby White
   Company:  Salesforce.com
   Date: April 13, 2017
**/
@isTest
private class UserStoryListController_Test {
	public static final String TYPE_APEXCLASS = 'ApexClass';
	public static final String TYPE_PROFILE = 'Profile';
	public static final String TYPE_CUSTOMOBJECT = 'CustomObject';
	public static final String TYPE_CUSTOMFIELD = 'CustomField';
	public static final String TYPE_RECORDTYPE = 'RecordType';
	public static final String TYPE_VALIDATIONRULE = 'ValidationRule';

	//public static final String STATUS_APPROVED = 'Approved';
	public static final String STATUS_DRAFT = 'Draft';

	@testSetup
	private static void setup() {
		TestDataFactory.setup();
		// Create extra local data we need for all of the tests
		copado__Project__c project = TestDataFactory.getProject();
		copado__Release__c release = TestDataFactory.getRelease(project.id);
		copado__Environment__c devSandbox = TestDataFactory.getEnvironment(project.Id);
        copado__Org__c orgCred = TestDataFactory.getDefaultOrgCred(devSandbox.id);


		// Create some User Stories
		List<copado__User_Story__c> stories = new List<copado__User_Story__c>();

        copado__User_Story__c userStory1 = new copado__User_Story__c (copado__User_Story_Title__c ='Sample1'
                                                                    ,copado__Project__c = project.id
                                                                    ,copado__Release__c = release.id
                                                                    ,copado__Org_Credential__c = orgCred.id
                                                                    ,copado__Environment__c = devSandbox.id
                                                                    ,copado__Status__c = STATUS_DRAFT);

         copado__User_Story__c userStory2 = new copado__User_Story__c (copado__User_Story_Title__c ='Sample2'
                                                                    ,copado__Project__c = project.id
                                                                    ,copado__Release__c = release.id
                                                                    ,copado__Org_Credential__c = orgCred.id
                                                                    ,copado__Environment__c = devSandbox.id
                                                                    ,copado__Status__c = STATUS_DRAFT);
 
        stories.add(userStory1);
        stories.add(userStory2);
        insert stories;

		// Add Commits
        TestDataFactory.addTestCommit(userStory1,createCommitSelections(1),'Test Commit1');
       	TestDataFactory.addTestCommit(userStory2,createCommitSelections(2),'Test Commit2');



	}


	
	@isTest static void test_NoneSelected() {

		UserStoryListController myListController = initController();

		List<CopadoMetadata> results =  myListController.getGitMetadataSelections();
		System.Assert(results!=null,'Never allowed to be null');
		System.AssertEquals(0,results.size(),'Expected to be empty');

		System.AssertEquals(null,myListController.init(),'Init expected to return null');
	}
	
	@isTest static void test_SomeSelected() {
		UserStoryListController myListController = initController();

		myListController.standardController.setSelected([SELECT Id, Name 
										From copado__User_Story__c
										Where copado__Status__c = :STATUS_DRAFT 
										LIMIT 10 ]);

		List<CopadoMetadata> results =  myListController.getGitMetadataSelections();

		// Test data inputs
		List<CopadoMetadata> testSelections = createCommitSelections(1);
		testSelections.addAll(createCommitSelections(2));

		System.Assert(results!=null,'Never allowed to be null');
		System.AssertEquals(Math.min(myListController.pageSize,testSelections.size()-1),results.size(),'Expected to be 1 overlap');
	}


	private static List<CopadoMetadata> createCommitSelections(Integer n) {

		List<CopadoMetadata> testSelections =  new List<CopadoMetadata>();

		if (n == 1) {
			testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass'));
        	testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass_Test'));
        	testSelections.add(TestDataFactory.createSelection(TYPE_PROFILE,'Admin'));
        	testSelections.add(TestDataFactory.createSelection(TYPE_CUSTOMOBJECT,'Opportunity'));
		} else {
			testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'SecondClass'));
        	testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'SecondClass_Test'));
        	testSelections.add(TestDataFactory.createSelection(TYPE_PROFILE,'Admin'));
        	testSelections.add(TestDataFactory.createSelection(TYPE_CUSTOMOBJECT,'Account'));			
		}

        return testSelections;
    }

	   /**
       Test helper method to simplify the common setup routines
    **/
	private static UserStoryListController initController() {
		// Create the Page and load the standard list controller
        Test.setCurrentPage(Page.UserStoryListReview);


        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(
        															[SELECT Id, Name 
																	  From copado__User_Story__c
																	 LIMIT 50 ]);
        
        UserStoryListController myListController = new UserStoryListController(stdSetController);

        return myListController;
	}

	
}