/**
  Test the UserStoryGitSelections_EC (extension controller)

  Page: UserStoryReview
**/

@isTest
private class UserStoryGitSelections_EC_Test {
	public static final String TYPE_APEXCLASS = 'ApexClass';
	public static final String TYPE_PROFILE = 'Profile';
	public static final String TYPE_CUSTOMOBJECT = 'CustomObject';
	public static final String TYPE_CUSTOMFIELD = 'CustomField';
	public static final String TYPE_RECORDTYPE = 'RecordType';
	public static final String TYPE_VALIDATIONRULE = 'ValidationRule';


	@testSetup
	private static void setup() {
		TestDataFactory.setup();
	}

	@isTest static void testGetRecordName() {
        // 
        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        UserStoryGitSelections_EC myExtController = initController(theUserStory);

        Test.startTest();

        String name = myExtController.getRecordName();
        System.Assert(name!=null,'Cannot be null');

        Test.stopTest();

	}
	
	@isTest static void testNoCommits() {
        // 
        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        UserStoryGitSelections_EC myExtController = initController(theUserStory);

        Test.startTest();

        List<CopadoMetadata> selections = myExtController.getGitMetadataSelections();

        System.Assert(selections!=null,'Even if no commits, this list must not be null');
        System.AssertEquals(selections.size(),0,'Expected none');

        Test.stopTest();

	}	

	@isTest static void testWithCommit() {
        // 
        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        List<CopadoMetadata> testSelections = new List<CopadoMetadata>();
        testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass'));
        testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass_Test'));
        testSelections.add(TestDataFactory.createSelection(TYPE_PROFILE,'Admin'));
        testSelections.add(TestDataFactory.createSelection(TYPE_CUSTOMOBJECT,'Opportunity'));


        TestDataFactory.addTestCommit(theUserStory,testSelections,'Test Commit');

        UserStoryGitSelections_EC myExtController = initController(theUserStory);

        Test.startTest();

        List<CopadoMetadata> selections = myExtController.getGitMetadataSelections();

        System.Assert(selections!=null,'Even if no commits, this list must not be null');
        System.AssertEquals(testSelections.size(),selections.size(),'Expected same number of items');

        Test.stopTest();

	}

	@isTest static void testWithOverlappingCommits() {
        // 
        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        List<CopadoMetadata> testSelections = new List<CopadoMetadata>();
        testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass'));
        testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass_Test'));
        testSelections.add(TestDataFactory.createSelection(TYPE_PROFILE,'Admin'));
        testSelections.add(TestDataFactory.createSelection(TYPE_CUSTOMOBJECT,'Opportunity'));
        TestDataFactory.addTestCommit(theUserStory,testSelections,'Test Commit1');

        List<CopadoMetadata> testSelections2 = new List<CopadoMetadata>();
        testSelections2.add(TestDataFactory.createSelection(TYPE_VALIDATIONRULE,'Valid1'));
        testSelections2.add(TestDataFactory.createSelection(TYPE_VALIDATIONRULE,'Valid2'));
        testSelections2.add(TestDataFactory.createSelection(TYPE_CUSTOMFIELD,'Status__c'));
        testSelections2.add(TestDataFactory.createSelection(TYPE_CUSTOMFIELD,'PickList__c'));
        testSelections2.add(TestDataFactory.createSelection(TYPE_PROFILE,'Admin'));
        TestDataFactory.addTestCommit(theUserStory,testSelections2,'Test Commit2');

        UserStoryGitSelections_EC myExtController = initController(theUserStory);

        Test.startTest();

        List<CopadoMetadata> selections = myExtController.getGitMetadataSelections();

        System.Assert(selections!=null,'Even if no commits, this list must not be null');
        System.AssertEquals(testSelections.size() + testSelections2.size()-1,selections.size(),'Expected same number of items');

        Test.stopTest();

	}

    /**
       Test helper method to simplify the common setup routines
    **/
	private static UserStoryGitSelections_EC initController(copado__User_Story__c theUserStory) {
		// Create the Page and load the standard controller
        Test.setCurrentPage(Page.UserStoryReview);
        ApexPages.currentPage().getParameters().put('id',theUserStory.id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(theUserStory);
        UserStoryGitSelections_EC myExtController = new UserStoryGitSelections_EC(stdController);

        return myExtController;
	}
}