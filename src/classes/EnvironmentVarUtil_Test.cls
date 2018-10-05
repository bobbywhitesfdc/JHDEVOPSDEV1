@isTest
private class EnvironmentVarUtil_Test {
    public static final String[] SOURCE_VARS =  new String[] {'key1','key2','site.url'};
    public static final String[] SOURCE_VALUES = new String[] {'123456789','BANANA','http://example.com'};

	@testSetup
	private static void setup() {
		TestDataFactory.setup();
		// Always Add Environment Variables to Source
        final copado__environment__c sourceEnv = getSourceEnv();
        createEnvironmentVars(sourceEnv.id,SOURCE_VARS, SOURCE_VALUES);


	}

	private  static copado__environment__c getTargetEnv() {
		final String sbNameWildcard =  '%' + TestDataFactory.SANDBOXNAME_DEV;
		return [SELECT id, name FROM copado__environment__c WHERE name LIKE :sbNameWildcard limit 1];
	}

	private static copado__environment__c getSourceEnv() {
		final String sbNameWildcard =  '%' + TestDataFactory.SANDBOXNAME_SIT;
		return [SELECT id, name FROM copado__environment__c WHERE name LIKE :sbNameWildcard limit 1];
	}

    private static void createEnvironmentVars(String envId, String[] varNames, String[] varValues) {
    	List<copado__Environmental_Variable__c> toAdd = new List<copado__Environmental_Variable__c>();
    	for (Integer i=0; i < varNames.size(); i++) {
    		toAdd.add(initEnvVar(envId,varNames[i],varValues[i]));
    	}
    	insert toAdd;

    }

	private static copado__Environmental_Variable__c initEnvVar(String envId, String varName, String varValue) {
      	final copado__Environmental_Variable__c oneToAdd = new copado__Environmental_Variable__c();
      	oneToAdd.copado__Environment__c = envId;
      	oneToAdd.name = varName;
      	oneToAdd.copado__Value__c = varValue;

      	return oneToAdd;
	}

	@isTest static void testEmptyTarget() {
		// Target has no variables to begin with should match Source at the end
		copado__environment__c targetEnv = getTargetEnv();
		copado__environment__c sourceEnv = getSourceEnv();

		Test.startTest();

		EnvironmentVarUtil util = new EnvironmentVarUtil(targetEnv.id);

		util.copyVariables(sourceEnv.id,true);

		Test.stopTest();

		List<copado__Environmental_Variable__c> testVars = [SELECT name, copado__Value__c 
														FROM copado__Environmental_Variable__c 
													   WHERE copado__Environment__c = :targetEnv.id
													   ORDER BY name];

        System.Assert(testVars != null & !testVars.isEmpty(),'Must have environment variables after copy');
        System.AssertEquals(testVars.size(),SOURCE_VARS.size(),'Should be equal in size to SOURCE_VARS');


	}

	
	@isTest static void testNoOverwrite() {
	    final String[] TARGET_VARS =  new String[] {'key1','key2'};
        final String[] TARGET_VALUES = new String[] {'8675309','ORANGE'};

      	// Target has 2 variables to begin with overlapping with Source, but having different values
		copado__environment__c targetEnv = getTargetEnv();
		createEnvironmentVars(targetEnv.id,TARGET_VARS, TARGET_VALUES);
   

		copado__environment__c sourceEnv = getSourceEnv();

		Test.startTest();

		EnvironmentVarUtil util = new EnvironmentVarUtil(targetEnv.id);

		util.copyVariables(sourceEnv.id,false);

		Test.stopTest();

		List<copado__Environmental_Variable__c> testVars = [SELECT name, copado__Value__c 
														FROM copado__Environmental_Variable__c 
													   WHERE copado__Environment__c = :targetEnv.id
													   ORDER BY name];

        System.Assert(testVars != null & !testVars.isEmpty(),'Must have environment variables after copy');
        System.AssertEquals(testVars.size(),SOURCE_VARS.size(),'Should be equal in size to SOURCE_VARS');

        System.AssertEquals(testVars[SOURCE_VARS.size()-1].name,SOURCE_VARS[SOURCE_VARS.size()-1],'Names must match for added value');
        System.AssertEquals(testVars[SOURCE_VARS.size()-1].copado__Value__c,SOURCE_VALUES[SOURCE_VARS.size()-1],'New value must be added and matching source');

        System.AssertEquals(testVars[0].name,TARGET_VARS[0],'Names must match');
        System.AssertEquals(testVars[0].copado__Value__c,TARGET_VALUES[0],'Value must not be overwritten');



	}
	
	@isTest static void testYesOverwrite() {
	    final String[] TARGET_VARS =  new String[] {'key1','key2'};
        final String[] TARGET_VALUES = new String[] {'8675309','ORANGE'};

      	// Target has 2 variables to begin with overlapping with Source, but having different values
		copado__environment__c targetEnv = getTargetEnv();
		createEnvironmentVars(targetEnv.id,TARGET_VARS, TARGET_VALUES);
   

		copado__environment__c sourceEnv = getSourceEnv();

		Test.startTest();

		EnvironmentVarUtil util = new EnvironmentVarUtil(targetEnv.id);

		util.copyVariables(sourceEnv.id,true);

		Test.stopTest();

		List<copado__Environmental_Variable__c> testVars = [SELECT name, copado__Value__c 
														FROM copado__Environmental_Variable__c 
													   WHERE copado__Environment__c = :targetEnv.id
													   ORDER BY name];

        System.Assert(testVars != null & !testVars.isEmpty(),'Must have environment variables after copy');
        System.AssertEquals(testVars.size(),SOURCE_VARS.size(),'Should be equal in size to SOURCE_VARS');

       System.AssertEquals(testVars[SOURCE_VARS.size()-1].name,SOURCE_VARS[SOURCE_VARS.size()-1],'Names must match for added value');
        System.AssertEquals(testVars[SOURCE_VARS.size()-1].copado__Value__c,SOURCE_VALUES[SOURCE_VARS.size()-1],'New value must be added and matching source');

        System.AssertEquals(testVars[0].name,SOURCE_VARS[0],'Names must match');
        System.AssertEquals(testVars[0].copado__Value__c,SOURCE_VALUES[0],'Value must be overwritten');



	}


	
}