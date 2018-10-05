@isTest
private class Environment_EC_Test {

    @testSetup
	private static void setup() {
		TestDataFactory.setup();
	}
	
	@isTest static void test_getSourceVars() {

		Environment_EC myExtController = initController(TestDataFactory.getEnvironment(null));

		// Pick one of the other environments and use it as the source
		List<SelectOption> sources = myExtController.getEnvironmentSelections();

		myExtController.sourceEnvironment = sources[0].getValue();

		List<copado__Environmental_Variable__c> vars = myExtController.getSourceVars();
		System.Assert(vars!=null,'Must not be null');
	}
	
	@isTest static void test_getTargetVars() {
		Environment_EC myExtController = initController(TestDataFactory.getEnvironment(null));

		List<copado__Environmental_Variable__c> vars = myExtController.getTargetVars();
		System.Assert(vars!=null,'Must not be null');
	}

	@isTest static void test_getRecordName() {
		copado__Environment__c env = TestDataFactory.getEnvironment(null);
		Environment_EC myExtController = initController(env);
		System.AssertEquals(myExtController.getRecordName(),env.name,'Should be the name');
	}

	@isTest static void test_getEnvironmentSelections() {
		List<copado__Environment__c> allEnvs = [SELECT Id,Name 
		                                          From copado__Environment__c 
		                                         LIMIT 100];

		copado__Environment__c env = TestDataFactory.getEnvironment(null);
		Environment_EC myExtController = initController(env);
		System.AssertEquals(myExtController.getEnvironmentSelections().size(),allEnvs.size()-1,'Expected n-1 environements');

	}

	@isTest static void test_copy() {
		// We're really just testing navigation here... the unit test for the utility

		Environment_EC myExtController = initController(TestDataFactory.getEnvironment(null));


		// Pick one of the other environments and use it as the source
		List<SelectOption> sources = myExtController.getEnvironmentSelections();
		myExtController.sourceEnvironment = sources[0].getValue();
		myExtController.overwrite=true;
		
		PageReference pageRef = myExtController.copy();
		System.AssertEquals(pageRef,null,'Expected null (same page)');
	}



	

	/**
       Test helper method to simplify the common setup routines
    **/
	private static Environment_EC initController(copado__Environment__c theEnv) {
		// Create the Page and load the standard controller
        Test.setCurrentPage(Page.CopyEnvironmentVariables);
        ApexPages.currentPage().getParameters().put('id',theEnv.id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(theEnv);
        Environment_EC myExtController = new Environment_EC(stdController);

        return myExtController;
	}
	
}