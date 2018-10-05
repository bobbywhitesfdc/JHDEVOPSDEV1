public with sharing class UserStoryGitSelections_EC extends BasePagingController {

	private final copado__User_Story__c myUserStory;

    // The extension constructor initializes the private member
    // variable myUserStory by using the getRecord method from the standard
    // controller.
    public UserStoryGitSelections_EC(ApexPages.StandardController stdController) {
        Id myUserStoryId = stdController.getRecord().id;

        // Retrieve the attributes we need
        this.myUserStory = [SELECT Id, Name, copado__User_Story_Title__c 
                              FROM copado__User_Story__c 
                             WHERE id= :myUserStoryId];

        initHandler();

    }

    public String getRecordName() {
        return myUserStory.name + ' ' + myUserStory.copado__User_Story_Title__c;
    }

    /**
      Supplies a list of User Stories to initialize the Handler selections
    **/
    protected override List<Id> initHandlerArgs() {
        List<Id> usList = new List<Id>();
        usList.add(myUserStory.id);
        return usList;
    }

}