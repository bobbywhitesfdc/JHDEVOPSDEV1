@RestResource(urlMapping='/AccountService/v1')
global with sharing class MyCustomAccountService  {



    @HttpPut
    global static ServiceResponseMsg updateAccounts(List<Account> accountsToLoad) {


        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm

        ServiceResponseMsg response = new ServiceResponseMsg();

        for (Database.UpsertResult current : Database.upsert(accountsToLoad,Account.fields.MyExternalId__c,false)) {
            if (!current.isSuccess()) {
                response.hasErrors = true;
            }

            response.details.add(new ResultDetail(current));

        }


        return response;
    }

    //ResponseMessage class needs to be serializable
    global with sharing class ServiceResponseMsg {
        Boolean hasErrors {get;set;}
        List<ResultDetail> details;

        public ServiceResponseMsg() {
            hasErrors=false;
            details = new List<ResultDetail>();
        }

    }

    global with sharing class ResultDetail {
        final Id salesforceId;
        final Boolean isSuccess;
        final List<String> errorMessages;
        public ResultDetail(Database.UpsertResult current) {
            this.salesforceId = current.getId();
            this.isSuccess = current.isSuccess();
            this.errorMessages = new List<String>();

            for (Database.Error currentError : current.getErrors()) {
                errorMessages.add(currentError.getMessage());
            }

        }
    }

}