trigger EnvironmentTrigger on copado__Environment__c (before insert, after insert, after update) {
    if (Trigger.isBefore && Trigger.isInsert) {
        EnvironmentTriggerHandler.handleBeforeInsert((List<copado__Environment__c>)Trigger.new);
    } else if (Trigger.isAfter && Trigger.isInsert) {
    	EnvironmentTriggerHandler.handleAfterInsert((Map<Id,copado__Environment__c>)Trigger.newMap);
    } else if (Trigger.isAfter && Trigger.isUpdate) {
    	EnvironmentTriggerHandler.handleAfterUpdate((Map<Id,copado__Environment__c>)Trigger.newMap);
    }

}