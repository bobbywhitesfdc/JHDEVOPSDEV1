public with sharing class UserStoryCommitUtil {

    public static List<CopadoMetadata> getGitMetadataSelections(List<Id> usList) {
	        // Get all of the Snapshot Commits for these User Stories
        List<CopadoMetadata> allCommitSelections = new List<CopadoMetadata>();
        List<Id> commitIds = new List<Id>();
        Map<Id,String> userStoryNames = new Map<Id,String>();

        // we must grab the Commit Ids first because the Attachments are nested there
        for (copado__user_story_commit__c current : [SELECT Id, name, copado__User_Story__c
        												                          , copado__User_Story__r.name
        												                          , copado__Snapshot_Commit__c
                                                       FROM copado__user_story_commit__c
                                                      WHERE copado__User_Story__c IN :usList
                                                        AND copado__Snapshot_Commit__r.copado__status__c = 'Complete'
                                                      ORDER BY copado__User_Story__r.name]) {

          // Save the name of the UserStory so we can lookup while getting the attachment bodies
          Id commitId = current.copado__Snapshot_Commit__c;
          commitIds.add(commitId);
          userStoryNames.put(commitId,current.copado__User_Story__r.name);
          System.Debug('UserStory:' + current.copado__User_Story__r.name);


        	
        }

        System.debug('Count of Commits: ' + commitIds.size());
        
        // Bulkified Query for the Attachment Bodies
        for (Attachment current : [SELECT Id, Name, ParentId, Body 
                                               FROM Attachment
                                              WHERE Name = 'MetaData'
                                                and ParentId IN :commitIds]) {


            List<CopadoMetadata> commitSelections = CopadoMetadata.parseArray(current.Body.toString());
            for (CopadoMetadata currentSel : commitSelections) {
                    // Save the name of the UserStory so we can cross reference
                  currentSel.userStoryReferences = userStoryNames.get(current.ParentId);
            }
            allCommitSelections.addAll(commitSelections); // this is unordered, not unique

        }

        System.Debug('Count of Selections: ' + allCommitSelections.size());

        // Eliminate duplicates
        Map<String,CopadoMetadata> selectionsMap = new Map<String,CopadoMetadata>();
        for (CopadoMetadata current : allCommitSelections) {
            if (!selectionsMap.containsKey(current.getKey())) {
                selectionsMap.put(current.getKey(),current);
            } else {
            	CopadoMetadata existing = selectionsMap.get(current.getKey());
            	existing.userStoryReferences += ',' + current.userStoryReferences;
            }
        }

        List<CopadoMetadata> dedupedSelections = selectionsMap.values();

        dedupedSelections.sort();

        // Dedupe the references
        for (CopadoMetadata current : dedupedSelections) {
        	current.dedupReferences();
        }
        return dedupedSelections;

    }

}