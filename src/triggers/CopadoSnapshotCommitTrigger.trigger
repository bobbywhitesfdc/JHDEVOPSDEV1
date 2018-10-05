trigger CopadoSnapshotCommitTrigger on copado__Git_Org_Commit__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        CopadoSnapshotCommitTriggerHandler.handleUpdate(Trigger.newmap);
    }
}