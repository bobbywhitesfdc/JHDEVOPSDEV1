/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    public static final String TEST_PASSWORD = 'passW0rd';

    @istest static void testCommunitiesSelfRegController() {
        Account testAccount = new Account(name='Test Account');
        insert testAccount;

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.accountId = testAccount.id;
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);   

        // No match on password
        controller.password = TEST_PASSWORD;
        controller.confirmPassword = TEST_PASSWORD + 'badMatch';
        System.assert(controller.registerUser() == null);   
        
        // Matching Password
        controller.password = TEST_PASSWORD;
        controller.confirmPassword = TEST_PASSWORD;
        System.assert(controller.registerUser() == null);  

        // Bad Account
        controller.accountId = null;
        controller.password = TEST_PASSWORD;
        controller.confirmPassword = TEST_PASSWORD;
        System.assert(controller.registerUser() == null);  
    }    
}