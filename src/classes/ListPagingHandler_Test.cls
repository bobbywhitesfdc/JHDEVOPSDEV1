@isTest
public class ListPagingHandler_Test {
	// public final Integer MY_PAGE_SIZE = 5;
	
	@isTest static void test_constructor1() {
		List<CopadoMetadata> testList = createTestList(10);
		ListPagingHandler handler = new ListPagingHandler(testList);

		System.AssertEquals(ListPagingHandler.MAX_PAGE_SIZE,handler.pageSize,'MaxPageSize should default properly');
		System.AssertEquals(0,handler.currentPage,'Default to page 0');
		System.AssertEquals(0,handler.maxPage,'Max page 0');		

	}

	@isTest static void test_constructor2() {
		final Integer MY_PAGE_SIZE = 5;
		List<CopadoMetadata> testList = createTestList(MY_PAGE_SIZE * 2);
		ListPagingHandler handler = new ListPagingHandler(testList,MY_PAGE_SIZE);

		System.AssertEquals(MY_PAGE_SIZE,handler.pageSize,'MaxPageSize should default properly');
		System.AssertEquals(0,handler.currentPage,'Default to page 0');
		System.AssertEquals(1,handler.maxPage,'Max page 1');	
	}

	
	@isTest static void test_emptyList() {
		final Integer MY_PAGE_SIZE = 5;
		List<CopadoMetadata> testList = createTestList(0);
		ListPagingHandler handler = new ListPagingHandler(testList,MY_PAGE_SIZE);

		System.AssertEquals(MY_PAGE_SIZE,handler.pageSize,'MaxPageSize should default properly');
		System.AssertEquals(0,handler.currentPage,'Default to page 0');
		System.AssertEquals(0,handler.maxPage,'Max page 0');
		System.AssertEquals(testList,handler.getSelections(),'Should get the original list');


		handler.currentPage +=1;

		System.AssertEquals(0,handler.currentPage,'Should not advance past first page');

		System.Assert(!handler.hasNext(),'Should not have a next page');
		System.Assert(!handler.hasPrevious(),'Should not have a previous page');
		System.AssertEquals(0,handler.next(),'Next should not move page past zero');
		System.AssertEquals(0,handler.previous(),'Previous should not move page past zero');		

	}

	@isTest static void test_partialPage() {
		final Integer MY_PAGE_SIZE = 5;
		List<CopadoMetadata> testList = createTestList(MY_PAGE_SIZE-1);
		ListPagingHandler handler = new ListPagingHandler(testList,MY_PAGE_SIZE);

		System.AssertEquals(MY_PAGE_SIZE,handler.pageSize,'MaxPageSize should default properly');
		System.AssertEquals(0,handler.currentPage,'Default to page 0');
		System.AssertEquals(0,handler.maxPage,'Max page 0');
		System.AssertEquals(testList,handler.getSelections(),'Should get the original list');


		handler.currentPage +=1;

		System.AssertEquals(0,handler.currentPage,'Should not advance past first page');
	}

	@isTest static void test_fullPage() {
		final Integer MY_PAGE_SIZE = 5;
		List<CopadoMetadata> testList = createTestList(MY_PAGE_SIZE-1);
		ListPagingHandler handler = new ListPagingHandler(testList,MY_PAGE_SIZE);

		System.AssertEquals(MY_PAGE_SIZE,handler.pageSize,'MaxPageSize should default properly');
		System.AssertEquals(0,handler.currentPage,'Default to page 0');
		System.AssertEquals(0,handler.maxPage,'Max page 0');
		System.AssertEquals(testList,handler.getSelections(),'Should get the original list');


		handler.currentPage +=1;

		System.AssertEquals(0,handler.currentPage,'Should not advance past first page');

		System.Assert(!handler.hasNext(),'Should not have a next page');
		System.Assert(!handler.hasPrevious(),'Should not have a previous page');
		System.AssertEquals(0,handler.next(),'Next should not move page past zero');
		System.AssertEquals(0,handler.previous(),'Previous should not move page past zero');	
	}

	@isTest static void test_fullpagePlusOne() {
		final Integer MY_PAGE_SIZE = 5;
		List<CopadoMetadata> testList = createTestList(MY_PAGE_SIZE+1);
		ListPagingHandler handler = new ListPagingHandler(testList,MY_PAGE_SIZE);

		System.AssertEquals(MY_PAGE_SIZE,handler.pageSize,'MaxPageSize should default properly');
		System.AssertEquals(0,handler.currentPage,'Default to page 0');
		System.AssertEquals(1,handler.maxPage,'Max page 1');
		System.AssertEquals(handler.pageSize,handler.getSelections().size(),'Should get first page only');


		handler.currentPage +=1;

		System.AssertEquals(1,handler.currentPage,'Should not advance past first page');
		System.AssertEquals(1,handler.getSelections().size(),'Should get only 1 item');

        handler.currentPage=0;
		System.Assert(handler.hasNext(),'Should have a next page');
		System.Assert(!handler.hasPrevious(),'Should not have a previous page');
		System.AssertEquals(1,handler.next(),'Next should  move page past zero');
		System.AssertEquals(0,handler.previous(),'Previous should move page to zero');	
	}

	@isTest static void test_multiPage() {
		final Integer MY_PAGE_SIZE = 5;
		List<CopadoMetadata> testList = createTestList(MY_PAGE_SIZE*3+1);
		ListPagingHandler handler = new ListPagingHandler(testList,MY_PAGE_SIZE);

		System.AssertEquals(MY_PAGE_SIZE,handler.pageSize,'MaxPageSize should default properly');
		System.AssertEquals(0,handler.currentPage,'Default to page 0');
		System.AssertEquals(3,handler.maxPage,'Max page 3');


		handler.currentPage +=1;
		System.AssertEquals(handler.pageSize,handler.getSelections().size(),'Should get second page only');

		handler.currentPage +=1;
		System.AssertEquals(handler.pageSize,handler.getSelections().size(),'Should get third page only');

		handler.currentPage +=1;

		System.AssertEquals(1,handler.getSelections().size(),'Should get only 1 item on final page');

		Integer placeHolder = handler.currentPage;
		handler.currentPage += 1;

		System.AssertEquals(placeHolder,handler.currentPage,'Should not advance page past end');

		handler.currentPage=0;
		System.Assert(handler.hasNext(),'Should have a next page');
		System.Assert(!handler.hasPrevious(),'Should not have a previous page');
		System.AssertEquals(1,handler.next(),'Next should  move page past zero');
		System.AssertEquals(0,handler.previous(),'Previous should move page to zero');

		handler.currentPage = handler.maxPage;
		System.Assert(!handler.hasNext(),'Should not have a next page');
		System.Assert(handler.hasPrevious(),'Should have a previous page');
		System.AssertEquals(handler.maxPage,handler.next(),'Next should not move page past max');

	}

	private static List<CopadoMetadata> createTestList(Integer count) {
		List<CopadoMetadata> testList = new List<CopadoMetadata>();
		for (Integer i=0; i < count; i++) {
			CopadoMetadata testItem = new CopadoMetadata();
			testItem.n = 'TestItem'+i;
			testItem.t = 'ApexClass';
			
			testList.add(testItem);
		}
		return testList;
	}
}