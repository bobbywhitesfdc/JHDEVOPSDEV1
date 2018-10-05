/**
	BasePagingController_Test

	Tests the paging methods of this abstract base class
**/

@isTest
private class BasePagingController_Test {
	public static final Integer FULL_PAGES = 3;
	public static final Integer TOTAL_SELECTIONS = (BasePagingController.DEFAULT_PAGESIZE * FULL_PAGES) + 1;
	public static final Integer LAST_PAGE = FULL_PAGES + 1 - 1;  // 1 partial, but zero based so minus 1



	@testSetup
	private static void setup() {
		TestDataFactory.setup();

		copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        List<CopadoMetadata> testSelections = TestDataFactory.generateTestSelections(TOTAL_SELECTIONS);

        TestDataFactory.addTestCommit(theUserStory,testSelections,'Test Commit');
	}
	
	@isTest static void test_pageSize() {
        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory);

        System.AssertEquals(BasePagingController.DEFAULT_PAGESIZE,controller.pageSize,'Page size should default');
	}
	
	@isTest static void test_currentPage() {
        copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory);

        // Initial page
        System.AssertEquals(0,controller.currentPage,'Initial page should be zero');

        // set to crazy high value, will cap at Max Page Size
        controller.currentPage = 100000;
        System.AssertEquals(controller.maxPage,controller.currentPage,'Should stop at max page');
	}

	
	@isTest static void test_hasNext() {
		copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory);

        System.AssertEquals(controller.maxPage > controller.currentPage, controller.hasNext,'Expected hasNext to reflect current page position');
	}

	@isTest static void test_hasPrevious() {
		copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory);

        System.AssertEquals(controller.currentPage > 0, controller.hasPrevious,'Expected hasPrevious to reflect current page > 0');
	}

	@isTest static void test_DoNext() {
		copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory);

        System.AssertEquals(null,controller.next(),'Next should always returns null');
        System.AssertEquals(1,controller.currentPage ,'Expected Next to advance page');
	}

	@isTest static void test_DoPrevious() {
		copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory);

        controller.currentPage = 1;  // Force the page to move 1 forward through explicit set

        System.AssertEquals(null,controller.previous(),'Previous should always returns null');
        System.AssertEquals(0,controller.currentPage ,'Expected Previous to backup 1 page');
	}

	@isTest static void test_getSelections() {

		copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory);

        System.AssertEquals(BasePagingController.DEFAULT_PAGESIZE,controller.getGitMetadataSelections().size(),'Expected full first page');
        controller.currentPage=LAST_PAGE;
        System.AssertEquals(1,controller.getGitMetadataSelections().size() ,'Expected Last Page to contain 1 item');

	}

	@isTest static void test_getSelectionsLazyLoad() {

		copado__User_Story__c theUserStory = TestDataFactory.getUserStory();

        BasePagingController controller = initController(theUserStory,true); // Lazy Load

        System.AssertEquals(BasePagingController.DEFAULT_PAGESIZE,controller.getGitMetadataSelections().size(),'Expected full first page');
        controller.currentPage=LAST_PAGE;
        System.AssertEquals(1,controller.getGitMetadataSelections().size() ,'Expected Last Page to contain 1 item');
	}

	/**
       Test helper method to simplify the common setup routines
    **/
	private static BasePagingController initController(copado__User_Story__c theUserStory) {
		return initController(theUserStory,false);
	}

	/**
       Test helper method to simplify the common setup routines
       @param lazyLoad the handler
    **/
	private static BasePagingController initController(copado__User_Story__c theUserStory, Boolean lazyLoad) {
		// Create the Page and load the standard controller
        Test.setCurrentPage(Page.UserStoryReview);
        ApexPages.currentPage().getParameters().put('id',theUserStory.id);  

        return new TestControllerExample(theUserStory.id,lazyLoad);
	}

	/**
		Our test controller
	**/
	private with sharing class TestControllerExample extends BasePagingController {
		Id usId;
		public TestControllerExample(Id usId, Boolean lazyLoadHandler) {
			this.usId = usId;
			if (!lazyLoadHandler) {
			   initHandler();
			}

		}
		protected override List<Id> initHandlerArgs() {
			List<Id> results = new List<Id>();
			results.add(usId);
			return results;
		}
	}

	
}