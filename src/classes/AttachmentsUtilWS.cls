/**
  Attachments Utility WebService - provides an entry point to call from a Javascript button
**/
global class AttachmentsUtilWS {

	webservice static void copyAll(Id parentId){
        AttachmentUtil.copyFilesToAttachments(parentId);
        AttachmentUtil.copyNotesToAttachments(parentId);
	}
}