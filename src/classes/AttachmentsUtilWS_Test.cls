@isTest
private class AttachmentsUtilWS_Test {
	
	@isTest static void test_copyAll() {

		TestDataFactory.setup();
		final List<SObject> parents = [SELECT Id FROM copado__Environment__c LIMIT 1];
		System.Assert(!parents.isEmpty(),'Expected at least 1 row of test data');

        Id parentId = parents[0].id;

		Test.startTest();

		AttachmentsUtilWS.copyAll(parentId);

		Test.stopTest();

		System.Assert(true,'Test Succeeded');


	}
	
}