public without sharing class UserStoryCommitTriggerHandler {
    public static void handleBefore(List<copado__User_Story_Commit__c> usCommits) {
        Set<Id> commitIds = new Set<Id>();
        for (copado__User_Story_Commit__c current : usCommits) {
            commitIds.add(current.copado__Snapshot_Commit__c);
        }
        System.debug('commitIds.count: ' + commitIds.size());
        
        Map<Id,copado__Git_Org_Commit__c> snapShotCommits = new Map<Id,copado__Git_Org_Commit__c>(
                                                              [SELECT Id, copado__Status__c  
                                                              From copado__Git_Org_Commit__c 
                                                              Where Id IN :commitIds]);
        
        // Lookup against the map to find the status
        for (copado__User_Story_Commit__c current : usCommits ) {
            copado__Git_Org_Commit__c snapShotCommit = snapShotCommits.get(current.copado__Snapshot_Commit__c);
            current.Status__c = snapShotCommit.copado__Status__c;
            //current.Status__c = 'Pending';
            System.debug('Setting UserStory Commit.status=' + current.Status__c);
        }
    }

}