@isTest
private class Promotion_CC_Test {
	public static final String TYPE_APEXCLASS = 'ApexClass';
	public static final String TYPE_PROFILE = 'Profile';
	public static final String TYPE_CUSTOMOBJECT = 'CustomObject';
	public static final String TYPE_CUSTOMFIELD = 'CustomField';
	public static final String TYPE_RECORDTYPE = 'RecordType';
	public static final String TYPE_VALIDATIONRULE = 'ValidationRule';
	
	@testSetup
	private static void setup() {
		TestDataFactory.setup();
		// Create extra local data we need for all of the tests
		copado__Project__c project = TestDataFactory.getProject();
		copado__Release__c release = TestDataFactory.getRelease(project.id);
		copado__Environment__c devSandbox = TestDataFactory.getEnvironment(project.Id);
        copado__Org__c orgCred = TestDataFactory.getDefaultOrgCred(devSandbox.id);


		// Create a User Story
        copado__User_Story__c userStory1 = new copado__User_Story__c (copado__User_Story_Title__c ='Sample1'
                                                                    ,copado__Project__c = project.id
                                                                    ,copado__Release__c = release.id
                                                                    ,copado__Org_Credential__c = orgCred.id
                                                                    ,copado__Environment__c = devSandbox.id);
        insert userStory1;

		// Add Commits
        TestDataFactory.addTestCommit(userStory1,createCommitSelections(),'Test Commit');

		// Add them to a Promotion
		copado__Promotion__c myPromotion = new copado__Promotion__c(copado__release__c = release.id
																   ,copado__Source_Environment__c = devSandbox.id
																   ,copado__Source_Org_Credential__c = orgCred.id
																   ,copado__Destination_Environment__c = devSandbox.id  //FIXME
																   ,copado__Destination_Org_Credential__c = orgCred.id  //FIXME
																   );
		insert myPromotion;

		copado__Promoted_User_Story__c promoUserStory = new copado__Promoted_User_Story__c();
		promoUserStory.copado__Promotion__c = myPromotion.id;
		promoUserStory.copado__User_Story__c = userStory1.id;
		insert promoUserStory;
	}

	@isTest static void test_getRecordName() {
		copado__promotion__c myPromotion = getPromotion();
		Promotion_CC myCustomController =  initController(myPromotion);
		System.AssertEquals(myCustomController.getRecordName(),myPromotion.name,'must equal');
	}
	
	@isTest static void test_getSelections() {

		copado__promotion__c myPromotion = getPromotion();
		Promotion_CC myCustomController =  initController(myPromotion);
		System.AssertEquals(myCustomController.getRecordName(),myPromotion.name,'must equal');

		List<CopadoMetadata> testSelections = createCommitSelections();

		Test.startTest();

        List<CopadoMetadata> selections = myCustomController.getGitMetadataSelections();

        System.Assert(selections!=null,'Even if no commits, this list must not be null');
        System.AssertEquals(selections.size(),testSelections.size(),'Expected same number of items');

        Test.stopTest();
	}

	@isTest static void test_NoChangeCommit() {

		copado__promotion__c myPromotion = getPromotion();

		copado__User_Story__c userStory1 = [SELECT id, name, copado__Org_Credential__c
		                                      FROM copado__User_Story__c 
		                                     WHERE id IN (SELECT copado__User_Story__c 
		                                                    FROM copado__Promoted_User_Story__c 
		                                                   WHERE copado__Promotion__c = :myPromotion.id) LIMIT 1];

		// Add an Empty Commit
        TestDataFactory.addTestCommit(userStory1,new List<CopadoMetaData>(),'No Change Commit');


		Promotion_CC myCustomController =  initController(myPromotion);
		System.AssertEquals(myCustomController.getRecordName(),myPromotion.name,'must equal');

		List<CopadoMetadata> testSelections = createCommitSelections();

		Test.startTest();

        List<CopadoMetadata> selections = myCustomController.getGitMetadataSelections();

        System.Assert(selections!=null,'Even if no commits, this list must not be null');
        System.AssertEquals(selections.size(),testSelections.size(),'Expected same number of items');

        Test.stopTest();
	}


	// Retreive our test promotion
	private static copado__Promotion__c getPromotion() {
         return [SELECT id, name from copado__Promotion__c LIMIT 1];
	}

    private static List<CopadoMetadata> createCommitSelections() {

		List<CopadoMetadata> testSelections =  new List<CopadoMetadata>();

        testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass'));
        testSelections.add(TestDataFactory.createSelection(TYPE_APEXCLASS,'MyTestClass_Test'));
        testSelections.add(TestDataFactory.createSelection(TYPE_PROFILE,'Admin'));
        testSelections.add(TestDataFactory.createSelection(TYPE_CUSTOMOBJECT,'Opportunity'));

        return testSelections;
    }

	   /**
       Test helper method to simplify the common setup routines
    **/
	private static Promotion_CC initController(copado__Promotion__c thePromotion) {
		// Create the Page and load the standard controller
        Test.setCurrentPage(Page.PromotionReview);
        ApexPages.currentPage().getParameters().put('id',thePromotion.id);

        return new Promotion_CC();
	}
	
}