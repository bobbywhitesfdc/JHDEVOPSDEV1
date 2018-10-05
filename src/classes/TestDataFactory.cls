@istest
public class TestDataFactory {
    public static final String PENDING = 'Pending';
    public static final String COMPLETE = 'Complete';
    public static final String CONFLICT = 'Conflict';
    public static final String NOCHANGES = 'No changes';
    public static final String SANDBOXNAME_DEV = 'DEV1';
    public static final String SANDBOXNAME_SIT = 'SIT';
    public static final String SANDBOXNAME_PROD = 'PROD';
    public static final String ORGPREFIX = 'X-';
    public static final String ORGNAME_DEV = 'X-DEV1';
    public static final String ORGNAME_SIT = 'X-SIT';
    public static final String ORGNAME_PROD = 'X-PROD';
    public static final String CMT_ID = 'e59cccc19c4375f38af94b0157c11b185ab41251';
    public static final String GOOD_OUTCOME = 'Just getting here without an exception is good enough :-)';
    public static final String FILENAME_METADATA = 'MetaData';

    public static final String TYPE_SANDBOX = 'Sandbox';
    public static final String TYPE_PROD = 'Production/Developer';
        
    public static void setup() {
        System.runAs(getREMUser()) {

        // Environments
        copado__Environment__c devSandbox = new copado__Environment__c(name=ORGNAME_DEV,copado__type__c=TYPE_SANDBOX);
        copado__Environment__c sitSandbox = new copado__Environment__c(name=ORGNAME_SIT,copado__type__c=TYPE_SANDBOX);
        copado__Environment__c prodOrg = new copado__Environment__c(name=ORGNAME_PROD,copado__type__c=TYPE_PROD);
        List<copado__Environment__c> testEnvs = new List<copado__Environment__c>();
        testEnvs.add(devSandbox);
        testEnvs.add(sitSandbox);
        testEnvs.add(prodOrg);
        insert testEnvs;

        Id myFlowId = null;


        // Create a Deployment Flow
        copado__Deployment_Flow__c myFlow = new copado__Deployment_Flow__c(name='My Flow'
                                                      , copado__Main_Branch__c='PRODUCTION'
                                                      , copado__Active__c = true
                                                      , copado__Disable_Validations__c = true);

        insert myFlow;
        myFlowId = myFlow.id;

        List<copado__Deployment_Flow_Step__c> dfSteps = new List<copado__Deployment_Flow_Step__c>();
        dfSteps.add(new copado__Deployment_Flow_Step__c(copado__Deployment_Flow__c = myFlow.id
                                                      ,copado__Source_Environment__c = devSandbox.id
                                                      ,copado__Destination_Environment__c = sitSandbox.id
                                                      ,copado__Branch__c = SANDBOXNAME_DEV));

        dfSteps.add(new copado__Deployment_Flow_Step__c(copado__Deployment_Flow__c = myFlow.id
                                                      ,copado__Source_Environment__c = sitSandbox.id
                                                      ,copado__Destination_Environment__c = prodOrg.id
                                                      ,copado__Branch__c = SANDBOXNAME_SIT));
        //FIXME MAKE THIS WORK!
        //insert dfSteps;

        
        // Org Credentials
        List<copado__Org__c> orgCreds = new List<copado__Org__c>();
        copado__Org__c orgCred =  new copado__Org__c(name=ORGNAME_DEV
                                                    ,copado__Environment__c=devSandbox.id
                                                    ,copado__Default_Credential__c = true
                                                    ,copado__Username__c = 'bobby.white@salesforce.com.x.dev1');
        orgCreds.add(orgCred);

        copado__Org__c sitCred =  new copado__Org__c(name=ORGNAME_SIT
                                                    ,copado__Environment__c=sitSandbox.id
                                                    ,copado__Default_Credential__c = true
                                                    ,copado__Username__c = 'bobby.white@salesforce.com.x.sit');

        orgCreds.add(sitCred);

        copado__Org__c prodCred =  new copado__Org__c(name=ORGNAME_PROD
                                                    ,copado__Environment__c=prodOrg.id
                                                    ,copado__Default_Credential__c = true
                                                    ,copado__Username__c = 'bobby.white@salesforce.com.x');

        orgCreds.add(prodCred);

        insert orgCreds;
        
        // Create Git Repo
        copado__Git_Repository__c gitRepo = new copado__Git_Repository__c(name='TestGitRepo'
                                                                         , copado__URI__c  = 'git@github.com:bobbywhitesfdc/Test1.git'
                                                                         , WebURI__c  = 'https://github.com/bobbywhitesfdc/Test1.git'
                                                                         , IsBackupsOnly__c = false);
        insert gitRepo;
        
        // Create Git Snapshot
        copado__Git_Backup__c snapShot = new copado__Git_Backup__c(copado__Branch__c=SANDBOXNAME_DEV
                                                                  ,copado__Git_Repository__c = gitRepo.id
                                                                  ,copado__Org__c = orgCred.id
                                                                  ,name = ORGPREFIX + SANDBOXNAME_DEV);
        insert snapShot;
        
        // Create Snapshot commit

        copado__Git_Org_Commit__c  snapShotCommit = new copado__Git_Org_Commit__c (copado__Git_Backup__c = snapShot.id
                                                                          ,copado__Org__c  = orgCred.id
                                                                          ,copado__Commit_Id__c = CMT_ID
                                                                          ,copado__Commit_Message__c = 'Sample Commit'
                                                                          ,copado__Status__c = PENDING);
        insert snapShotCommit;
        
        System.AssertNotEquals(snapShotCommit,null,'SnapShotCommit must not be null');
        System.AssertNotEquals(snapShotCommit.id,null,'SnapShotCommit.id');

        // Create Project with an Active Deployment Flow
        copado__Project__c project = new copado__Project__c (name='Test Project'
                                                            ,copado__Deployment_Flow__c = myFlowId);
        insert project;

        // Create Release under this project
        copado__Release__c release = new copado__Release__c (name='Big Release'
                                                           , copado__Project__c=project.id);
        insert release;

      
        // Create User Story in the Project
        copado__User_Story__c userStory = new copado__User_Story__c (copado__User_Story_Title__c ='Sample'
                                                                    ,copado__Project__c = project.id
                                                                    ,copado__Release__c = release.id
                                                                    ,copado__Org_Credential__c = orgCred.id
                                                                    ,copado__Environment__c = devSandbox.id);
        insert userStory;
        
        System.AssertNotEquals(userStory,null,'UserStory must not be null');
        System.AssertNotEquals(userStory.id,null,'UserStory.id');
        }

    }

    public static copado__Git_Org_Commit__c getSnapShotCommit() {
        
        return [SELECT id,name FROM copado__Git_Org_Commit__c LIMIT 1];
    }

    public static copado__User_Story__c getUserStory() {
        return [SELECT Id,Name,copado__Org_Credential__c, copado__Environment__c, copado__Project__c
                  FROM copado__User_Story__c
                 LIMIT 1];
    }

    public static copado__Project__c getProject() {
      return [SELECT Id, Name, copado__Deployment_Flow__c 
                from copado__Project__c
               LIMIT 1];
    }

    public static copado__Release__c getRelease(Id projectId) {
      return [SELECT Id, Name 
                FROM copado__Release__c 
               WHERE copado__Project__c = :projectId
               LIMIT 1];
    }

    public static copado__Environment__c getEnvironment(Id projectId) {
      // FIXME get a Dev Environment that is in the Deployment Flow for this project
      String myDevSandboxName = ORGPREFIX + SANDBOXNAME_DEV;
      return [SELECT Id, Name 
                FROM copado__Environment__c 
               WHERE name = :myDevSandboxName LIMIT 1];
    }

   public static copado__Org__c getDefaultOrgCred(Id envId) {
      return [SELECT Id, Name 
                FROM copado__Org__c
               WHERE copado__Default_Credential__c = true
                 and copado__Environment__c = :envId];
    }

    public static copado__Git_Backup__c getSnapShot(Id orgCredId) {
      return [SELECT id, Name 
                FROM copado__Git_Backup__c
               WHERE copado__Org__c = :orgCredId ];
    }

    public static User getREMUser() {
      User remUser = [SELECT id, Name, Username 
                        from User 
                       Where Profile.name = 'System Administrator'
                         and isActive = true LIMIT 1];
      return remUser;
    }

    public static User getDevUser() {
       User devUser = [SELECT id, Name, Username 
                        from User 
                       Where Profile.name = 'Standard User'
                         and isActive = true LIMIT 1];
       return devUser;
    }

    public static User createDevUser() {
        User devUser = new User(alias = 'testUser', email='standarduser' + Math.random()  + '@testorg.com',
                                emailencodingkey='UTF-8', lastname='Test', languagelocalekey='en_US',
                                localesidkey='en_US', timezonesidkey='America/New_York',
                                username='teststandarduser' + Math.random() + '@testorg.com', IsActive=true,
                                Extension='1234', CompanyName = 'test Company');
       devUser.profileId = [SELECT id from Profile Where name = 'Standard User'].id;
       devUser.UserRoleId =  [SELECT id from UserRole Where name='Project Team Member'].id;

       insert devUser;

       //assignPermissionSet(devUser.id,'Copado_UserJohnHancock');

       return devUser;
    }

    /**
      Initialize a CopadoMetadata instance
    **/
    public static CopadoMetadata createSelection(String typeValue, String itemName) {
      CopadoMetadata theMetaData = new CopadoMetadata();
      theMetaData.t = typeValue;
      theMetaData.n = itemName;
      //FIXME initialize the other stuff
      return theMetadata;
    }

    public static List<CopadoMetadata> generateTestSelections(Integer n) {
        List<CopadoMetadata> testSelections = new List<CopadoMetadata>();
        for (Integer i=0; i < n; i++) {
            testSelections.add(TestDataFactory.createSelection('ApexClass','TestClass'+i));
        }
        return testSelections;
    }

    /**
       Add a Snapshot Commit and User Story Commit from this selection
    **/
    public static void addTestCommit(copado__User_Story__c theUserStory, List<CopadoMetaData> theSelections, String msg) {
        // Get the Snapshot from the UserStory
        copado__Git_Backup__c snapShot = getSnapShot(theUserStory.copado__Org_Credential__c);

        // Create the Snapshot Commit Record
        String commitStatus = (theSelections == null || theSelections.isEmpty()) ? NOCHANGES : COMPLETE;
        copado__Git_Org_Commit__c  snapShotCommit = new copado__Git_Org_Commit__c (copado__Git_Backup__c = snapShot.id
                                                                          ,copado__Org__c  = theUserStory.copado__Org_Credential__c
                                                                          ,copado__Commit_Id__c = generateCommitId()
                                                                          ,copado__Commit_Message__c = msg
                                                                          ,copado__Status__c = commitStatus);
        insert snapShotCommit;

        if (commitStatus == COMPLETE) {
            // Create the Attachment on the Snapshot Commit Record
            Attachment meta = new Attachment();
            meta.name = FILENAME_METADATA;
            meta.body = Blob.valueOf(JSON.serialize(theSelections));
            meta.parentId = snapShotCommit.id;
            insert meta;
        }


        // Create the User Story Commit
        copado__User_Story_Commit__c  usCommit = new copado__User_Story_Commit__c (copado__Snapshot_Commit__c = snapShotCommit.id
                                                                                  ,copado__User_Story__c = theUserStory.id);
        insert usCommit;        
    }

    /**
       Generates a unique string that serves as a fake Git commitid
    **/
    private static String generateCommitId() {
        String seed = Crypto.getRandomLong() + '' + Crypto.getRandomLong();

        return seed;
    }

    @future
    private static void assignPermSetWorker(Id theUserID, String psName) {
       Id pid = [SELECT id From PermissionSet Where Name = :psName ].id;

       PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = pid
                                        , AssigneeId = theUserId);
       insert psa; 
    }

    public static void assignPermissionSet(Id theUserId, String psName) {
        System.runAs(getREMUser()) {
          TestDataFactory.assignPermSetWorker(theUserId,psName);
        }

    }



}