@isTest
private class EnvironmentTriggerHandler_Test {

	@TestSetup
	private static void testSetup() {
		TestDataFactory.setup();
	}
	
	@isTest static void test_BeforeSandbox() {
		 copado__Environment__c mySandbox = new copado__Environment__c(name='Test',copado__type__c=TestDataFactory.TYPE_SANDBOX);
		 insert mySandbox;

		 copado__Environment__c mySandboxAfter = [SELECT id, isManaged__c FROM copado__Environment__c WHERE ID = :mySandbox.id];

		 System.AssertEquals(false,mySandboxAfter.isManaged__c,'isManaged should default to false for Sandboxes');

	}
	
	@isTest static void test_BeforeProd() {
		 copado__Environment__c myProdEnv = new copado__Environment__c(name='Test-Prod',copado__type__c=TestDataFactory.TYPE_PROD);
		 insert myProdEnv;

		 copado__Environment__c myProdEnvAfter = [SELECT id, isManaged__c FROM copado__Environment__c WHERE ID = :myProdEnv.id];

		 System.AssertEquals(true,myProdEnvAfter.isManaged__c,'isManaged should default to true for Production');

	}

	@isTest static void test_update() {


        final List<copado__Environment__c> envs = new List<copado__Environment__c>();

		// Update existing environments with connected Org Credentials
		for (copado__Environment__c current : [SELECT id, name, copado__type__c, isManaged__c, isDevelopmentSandbox__c 
			                                     FROM copado__Environment__c LIMIT 10]) {
			if (current.name.contains('PROD') || current.name.contains('SIT')) {
				current.isManaged__c = true;
				current.isDevelopmentSandbox__c = false;
			} else {
				current.isManaged__c = false;
				current.isDevelopmentSandbox__c = true;				
			}
			envs.add(current);

		}

		update envs;

		final Map<Id,copado__Environment__c> envMap = new Map<id,copado__Environment__c>([SELECT id, name, copado__type__c, isManaged__c
			                                                                       , isDevelopmentSandbox__c 
			                                                                       FROM copado__Environment__c LIMIT 10]);

		// Select the related Org Credentials
		for (copado__Org__c current : [SELECT id, name, isManaged__c,isDevelopmentSandbox__c, copado__Environment__c 
	 		                             FROM copado__Org__c
	 		                            WHERE copado__environment__c IN :envMap.keySet()]) {
	 		Copado__Environment__c env = envMap.get(current.Copado__Environment__c);

	 		System.AssertEquals(env.isManaged__c,current.isManaged__c
	 			,'OrgCred.isManaged must be the same as Env: ' + current.name);
	 		System.AssertEquals(env.isDevelopmentSandbox__c,current.isDevelopmentSandbox__c
	 			,'OrgCred.isDevelopmentSandbox must be the same as Env: ' + current.name);
	 	}


	}
	
}