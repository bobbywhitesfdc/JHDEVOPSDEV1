public with sharing class UserStoryListController extends BasePagingController {

    @TestVisible private final ApexPages.StandardSetController standardController;

    public UserStoryListController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
    }

    /**
      Supplies a list of User Stories to initialize the Handler selections
    **/
    protected override List<Id> initHandlerArgs() {
        List<Id> usList = new List<Id>();
        for (copado__User_Story__c current : (List<copado__User_Story__c>) standardController.getSelected()) {
            usList.add(current.id);
        }
        return usList;
    }

    /**
      Page Level Init method
    **/
    public PageReference init() {
        initHandler();
        return null;
    }

}