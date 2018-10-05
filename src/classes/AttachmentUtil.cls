/**
  Class:  AttachmentUtil
  Description:  Utility class to manipulate Attachments
  Author:  Bobby White
  Company:  Salesforce.com
  Date:  May 26, 2017
**/
public with sharing class AttachmentUtil {
	// Copy the Files to Attachments, but don't delete the Files
	public static void copyFilesToAttachments(Id parentId) {

		// Get all of the DocIds for the Files into a Collection
		final List<Id> docIds = new List<Id>();
		for (ContentDocumentLink current : [SELECT ContentDocumentId,ContentDocument.Title
												   FROM ContentDocumentLink
												  WHERE LinkedEntityId = :parentId]) {
   			docIds.add(current.ContentDocumentId);
		}

		List<Attachment> myAttachments = new List<Attachment>();

		// get the body from ContentVersion
		for (ContentVersion cv : new ParentHelper(parentId).getDocs()) {
            // Show the content
    		System.debug('Doc-Title: ' + cv.Title);
    		System.debug(cv.VersionData);
    
    		Attachment meta = new Attachment();
    		meta.name = cv.Title;
    		meta.body = cv.VersionData;
    		meta.parentId = parentId;
    		myAttachments.add(meta);
		}

		insert myAttachments;
	}

		// Copy the Notes to Attachments, but don't delete the Notes
	public static void copyNotesToAttachments(Id parentId) {

		List<Attachment> myAttachments = new List<Attachment>();

		// get the body from ContentVersion
		for (Note current : [SELECT id,Title,Body 
                          FROM Note
                          WHERE ParentId = :parentId]) {
            // Show the content
    		System.debug('Doc-Title: ' + current.Title);
    		System.debug(current.Body);
    
    		Attachment meta = new Attachment();
    		meta.name = current.Title;
    		meta.body = Blob.valueOf(current.body);
    		meta.parentId = parentId;
    		myAttachments.add(meta);
		}

		insert myAttachments;
	}

    /*
      ParentHelper is used to fetch the documents in case they are owned by someone else.

      Executes without Sharing intentionally to ensure that all documents are visible
    */
	public without sharing class ParentHelper {
		final Id parentId;
		public ParentHelper(Id parentId) {
			this.parentId = parentId;
		}
		public  List<ContentVersion> getDocs() {
			List<Id> docIds = new List<Id>();
			for (ContentDocumentLink current : [SELECT ContentDocumentId,ContentDocument.Title
												   FROM ContentDocumentLink
												  WHERE LinkedEntityId = :parentId]) {
   				docIds.add(current.ContentDocumentId);
			}

			return [SELECT id,Title,VersionData 
                          FROM ContentVersion
                          WHERE ContentDocumentId IN :docIds];
		}

	}
}