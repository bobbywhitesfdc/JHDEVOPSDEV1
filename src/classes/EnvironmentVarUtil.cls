/**
  Utility class to copy Copado Environment Variables
**/
public with sharing class EnvironmentVarUtil {
	private  final copado__environment__c targetEnv;
	public EnvironmentVarUtil(Id envId) {
		this.targetEnv = [SELECT id, name FROM copado__environment__c where id = :envId];
	}

	public void copyVariables(Id sourceEnvId, Boolean overwriteExistingValues) {

		final List<copado__Environmental_Variable__c> sourceEnvVars = [SELECT id, name, copado__Value__c, copado__Environment__c 
		            													 from copado__Environmental_Variable__c 
                    													where copado__Environment__c = :sourceEnvId];

		final List<copado__Environmental_Variable__c> targetEnvVars = [SELECT id, name, copado__Value__c, copado__Environment__c 
																		 from copado__Environmental_Variable__c 
																		where copado__Environment__c = :targetEnv.id];


		// Initialize the Map so we can find by Name
		final Map<String,copado__Environmental_Variable__c> targetEnvVarsMap = new Map<String,copado__Environmental_Variable__c>();
		for (copado__Environmental_Variable__c current : targetEnvVars) {
			targetEnvVarsMap.put(current.name,current);
		}

		// Walk through the source and copy the missing (or existing to update)
		List<copado__Environmental_Variable__c> myUpdates = new List<copado__Environmental_Variable__c>();
		for (copado__Environmental_Variable__c current : sourceEnvVars) {
    		String theValue = current.copado__Value__c;
    		theValue = theValue.trim();

    		if (targetEnvVarsMap.containsKey(current.name)) {
    			if (overwriteExistingValues) {
       				final copado__Environmental_Variable__c oneToUpdate = targetEnvVarsMap.get(current.name);
       				oneToUpdate.copado__Value__c = theValue;
       				myUpdates.add(oneToUpdate);
      				System.Debug('Updating: ' + current.name + ' value [' + theValue +']');
      			} else {
      				System.debug('Skipping: ' + current.name + ' because NO Overwrite was specified');
      			}
    		} else {
      			System.Debug('Creating: ' + current.name + ' value [' + theValue +']');
      			final copado__Environmental_Variable__c oneToAdd = new copado__Environmental_Variable__c();
      			oneToAdd.copado__Environment__c = targetEnv.id;
      			oneToAdd.name = current.name;
      			oneToAdd.copado__Value__c = theValue;
       			myUpdates.add(oneToAdd); 
    		}
	}

	System.debug('Rows to update: ' + myUpdates.size());

	upsert myUpdates;

	}
}