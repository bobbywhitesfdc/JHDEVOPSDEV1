trigger DeploymentJob on copado__Deployment_Job__c (before update) {
	DeploymentJobTriggerHandler.handleBeforeUpdate();
}