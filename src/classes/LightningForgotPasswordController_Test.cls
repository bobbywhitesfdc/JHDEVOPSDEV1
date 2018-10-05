@isTest
private class LightningForgotPasswordController_Test {
	public static final String TEST_USERNAME = 'test@jhadmin.my.test' + System.now();
	public static final String TEST_CHECKEMAILURL = 'https://localhost/checkemailurl';
	
	@isTest static void test_forgotPassword() {
		System.AssertEquals(Label.Site.invalid_email,LightningForgotPasswordController.forgotPassowrd(TEST_USERNAME,TEST_CHECKEMAILURL),'Forgot Password Message');
	}	
}