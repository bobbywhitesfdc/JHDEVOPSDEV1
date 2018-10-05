@isTest
private class AttachmentUtil_Test {
	public static final String TEST_FILENAME = 'TestFile.json';
	public static final String TEST_FILECONTENTS = 'Hello my Friends!';

    @testSetup
	private static void setup() {
		TestDataFactory.setup();
	}
	
	@isTest static void testCopyFile() {

		// Fetch something to use as a parent
        List<SObject> parents = [SELECT Id FROM copado__Environment__c LIMIT 1];

        System.Assert(!parents.isEmpty(),'Expected at least 1 row of test data');

        Id parentId = parents[0].id;

        addFile(parentId,TEST_FILENAME,TEST_FILECONTENTS);

		Test.startTest();

		// Test our utility
		AttachmentUtil.copyFilesToAttachments(parentId);

		Test.stopTest();

		// Verify that we can find the attachment
		List<Attachment> results = [SELECT Id, Name, Body FROM Attachment Where ParentId = :parentId];
		System.AssertEquals(1,results.size(),'Expected 1 attachment, found differently');
		System.AssertEquals(TEST_FILENAME,results[0].name,'Filename should match');
		System.AssertEquals(TEST_FILECONTENTS,results[0].body.toString(),'Contents should match');

	}

	@isTest static void testNoteFile() {

		// Fetch something to use as a parent
        List<SObject> parents = [SELECT Id FROM copado__Environment__c LIMIT 1];

        System.Assert(!parents.isEmpty(),'Expected at least 1 row of test data');

        Id parentId = parents[0].id;

        addNote(parentId,TEST_FILENAME,TEST_FILECONTENTS);

		Test.startTest();

		// Test our utility
		AttachmentUtil.copyNotesToAttachments(parentId);

		Test.stopTest();

		// Verify that we can find the attachment
		List<Attachment> results = [SELECT Id, Name, Body FROM Attachment Where ParentId = :parentId];
		System.AssertEquals(1,results.size(),'Expected 1 attachment, found differently');
		System.AssertEquals(TEST_FILENAME,results[0].name,'Filename should match');
		System.AssertEquals(TEST_FILECONTENTS,results[0].body.toString(),'Contents should match');

	}
	
	private static void addFile(Id parentId, String filename, String fileData) {

		ContentVersion cv = new ContentVersion();
		cv.ContentDocumentId = null;  // we don't have one, this insert will implicitly create it
        cv.ContentLocation = 'S';
        cv.VersionData = Blob.valueOf(fileData);
        cv.Title = fileName;
        cv.PathOnClient = filename;
        
        insert cv;

        // reselect it to get the ContentDocumentId
        cv = [SELECT id, ContentDocumentId FROM ContentVersion WHERE id = :cv.id];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv.ContentDocumentId;
        cdl.LinkedEntityId = parentId;
        cdl.ShareType = 'I';
        
        insert cdl;

	}

	private static void addNote(Id parentId, String filename, String fileData) {

		Note theNote = new Note();
		theNote.parentId = parentId;
		theNote.Title = filename;
		theNote.body = fileData;

		insert theNote;
	}
	
}