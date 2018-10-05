public with sharing class Environment_EC {

	private final copado__environment__c myEnvironment;

    public Id sourceEnvironment {get; set; }
    public Boolean overwrite {get; set; }

    // The extension constructor initializes the private member
    // variable myEnvironment by using the getRecord method from the standard
    // controller.
    public Environment_EC(ApexPages.StandardController stdController) {
        Id envId = ((copado__environment__c) stdController.getRecord()).id;

        // Retrieve the attributes we need
        this.myEnvironment = [SELECT Id, Name
                              FROM copado__environment__c 
                             WHERE id= :envId];

       // default to Overwrite false
       this.overwrite = false;
    }

    public List<copado__Environmental_Variable__c> getSourceVars() {
        return [SELECT Id, Name, copado__value__c 
                  FROM copado__Environmental_Variable__c 
                 WHERE copado__environment__c = :sourceEnvironment];
    }

    public List<copado__Environmental_Variable__c> getTargetVars() {
        return [SELECT Id, Name, copado__value__c 
                  FROM copado__Environmental_Variable__c 
                 WHERE copado__environment__c = :myEnvironment.id];
    }

    public String getRecordName() {
        return myEnvironment.name;
    }

    public PageReference copy() {
        EnvironmentVarUtil util = new EnvironmentVarUtil(myEnvironment.id);
        util.copyVariables(sourceEnvironment,overwrite);
        return null;
    }

    /**
      Return a list of Environments, excluding this one
    **/
    public List<SelectOption> getEnvironmentSelections() {
         List<SelectOption> allEnvs = new List<SelectOption>();
         for(copado__environment__c current : [SELECT Id, Name From copado__environment__c]) {
            if (current.id <> myEnvironment.id) {
                allEnvs.add(new SelectOption(current.id,current.name));
            }
         }
         return allEnvs;
    }

}