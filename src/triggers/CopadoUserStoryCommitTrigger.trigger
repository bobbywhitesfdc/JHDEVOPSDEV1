trigger CopadoUserStoryCommitTrigger on copado__User_Story_Commit__c (before insert) {
    if (Trigger.isInsert && Trigger.isBefore) {
       UserStoryCommitTriggerHandler.handleBefore(Trigger.new);
    }
}