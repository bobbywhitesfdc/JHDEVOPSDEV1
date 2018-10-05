public with sharing class Promotion_CC extends BasePagingController {

    private final copado__Promotion__c myPromotion;

    public Promotion_CC() {
        Id promotionId = ApexPages.currentPage().getParameters().get('id');

        // Retrieve the attributes we need
        this.myPromotion = [SELECT Id, Name
                              FROM copado__Promotion__c 
                             WHERE id= :promotionId];

        initHandler();
    }

    public String getRecordName() {
        return myPromotion.name;
    }

    /**
      Supplies a list of User Stories to initialize the Handler selections
    **/
    protected override List<Id> initHandlerArgs() {
        List<Id> usList = new List<Id>();
        for (copado__Promoted_User_Story__c current : [SELECT id, Name, copado__User_Story__c 
                                                         FROM copado__Promoted_User_Story__c
                                                        WHERE copado__Promotion__c = :myPromotion.id]) {
            usList.add(current.copado__User_Story__c);
        }
        return usList;
    }

}