trigger Deployment on copado__Deployment__c (before insert, before update) {
	for(copado__Deployment__c current : Trigger.new) {
		// block running deployments connected to Promotions
		if (current.copado__Promotion__c != null && current.copado__Status__c == 'In progress') {
			current.AddError('Blocking deployment execution for Promotions');
		}
	}

}