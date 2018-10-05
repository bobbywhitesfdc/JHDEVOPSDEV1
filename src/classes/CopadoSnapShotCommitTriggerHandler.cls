/**
 * Trigger Handler to update Commit Status field from Snapshot Commit
 * Denormalization to allow Rollup Summary on User Story
**/
public with sharing class CopadoSnapShotCommitTriggerHandler {
    public static void handleUpdate(Map<Id,copado__Git_Org_Commit__c> updatedItems) {
       Set<Id> commits = updatedItems.keySet();
        
       System.debug('Commits Count: '+ commits.size());
       
       List<copado__User_Story_Commit__c> usCommits = new List<copado__User_Story_Commit__c>();
    
       for (copado__User_Story_Commit__c current : [SELECT Id, name
                                                        , Status__c
                                                        , copado__Snapshot_Commit__c
                                                     FROM copado__User_Story_Commit__c
                                                    WHERE copado__Snapshot_Commit__c IN :commits]) {
               current.status__c = updatedItems.get(current.copado__Snapshot_Commit__c).copado__Status__c ; 
               System.debug('CommitID: ' + current.name + ' status: ' + current.status__c);                                         
               usCommits.add(current);                                        
           }
       System.debug('US Commits Count:' + usCommits.size());
       update usCommits;
    }

}