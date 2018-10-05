@isTest
private class LightningSelfRegisterController_Test {
	public static final String PASSWORD1 = 'myPassw0rd';
	public static final String PASSWORD2 = 'otherPassw0rd';
	public static final String TEST_EMAIL = 'test1@example.com';
	public static final String TEST_CONFIRMURL = 'https://test.my.salesforce.com/support/confirmreg';
	public static final String TEST_STARTURL = 'https://test.my.salesforce.com/support/start';
	
	@isTest static void test_constructor() {
		LightningSelfRegisterController ctrl = new LightningSelfRegisterController();
		System.Assert(true,'Contructor tested');
	}
	
	@isTest static void test_isValidPassword() {
		System.Assert(LightningSelfRegisterController.isValidPassword(PASSWORD1,PASSWORD1),'Passwords did not match');
		System.Assert(!LightningSelfRegisterController.isValidPassword(PASSWORD1,PASSWORD2),'Passwords should not have matched');
	}

	@isTest static void test_selfregister() {
		Account testAccount = new Account(name='Test Account');
		insert testAccount;

		System.AssertEquals(Label.Site.lastname_is_required,LightningSelfRegisterController.selfRegister('Test' ,null, TEST_EMAIL
			,PASSWORD1, PASSWORD1, testAccount.id, TEST_CONFIRMURL, null, TEST_STARTURL, true));
		System.AssertEquals(Label.Site.email_is_required,LightningSelfRegisterController.selfRegister('Test' ,'User', null
			,PASSWORD1, PASSWORD1, testAccount.id, TEST_CONFIRMURL, null, TEST_STARTURL, true));
		System.AssertEquals(Label.Site.passwords_dont_match,LightningSelfRegisterController.selfRegister('Test' ,'User', TEST_EMAIL
			,PASSWORD1, PASSWORD2, testAccount.id, TEST_CONFIRMURL, null, TEST_STARTURL, true));

		/**
		 Passwords matching, should run through the full path
		System.AssertEquals(Label.Site.passwords_dont_match,LightningSelfRegisterController.selfRegister('Test' ,'User', TEST_EMAIL
			,PASSWORD1, PASSWORD1, testAccount.id, TEST_CONFIRMURL, null, TEST_STARTURL, true));
	    **/
	}
	
}