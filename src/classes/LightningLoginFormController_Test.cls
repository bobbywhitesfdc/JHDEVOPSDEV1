@isTest
private class LightningLoginFormController_Test {
	public static final String TEST_USERNAME = 'testlightning@jhadmin.lghtning';
	public static final String TEST_PASSWORD = 'Pass$W0rd';
	public static final String TEST_STARTURL = 'https://localhost/start';
	public static final String RESULT_LOGINMSG = 'Argument 1 cannot be null';
	
	@isTest static void test_constructor() {
		LightningLoginFormController ctrl = new LightningLoginFormController();
		System.Assert(ctrl!=null,'Cannot be null');
	}
	
	@isTest static void test_getForgotPasswordUrl() {
		System.AssertEquals(null,LightningLoginFormController.getForgotPasswordUrl(),'Forgot Password URL should be null');
	}

	@isTest static void test_getSelfRegUrl() {
		System.AssertEquals(null,LightningLoginFormController.getSelfRegistrationUrl(),'Self-Reg URL should be null');
	}

	@isTest static void test_getSelfRegEnabled() {
		System.AssertEquals(false,LightningLoginFormController.getIsSelfRegistrationEnabled(),'Self-Reg Enabled value wrong');
	}

    /**
    This test behavior differs between users depending on (their SSO settings???)
    **/
	@isTest static void test_getIsUsernamePasswordEnabled() {
        Id networkId = Network.getNetworkId();
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');

		System.AssertEquals(authConfig.getUsernamePasswordEnabled()
							,LightningLoginFormController.getIsUsernamePasswordEnabled()
							,'UserNamePassword Enabled value wrong');
	}

	@isTest static void test_login() {
		System.AssertEquals(RESULT_LOGINMSG,LightningLoginFormController.login(TEST_USERNAME,TEST_PASSWORD,TEST_STARTURL)
			,'login message failure');
	}

    public static Boolean runningInASandbox() {
    return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
}

	
}