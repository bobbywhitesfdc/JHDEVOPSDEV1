/**
	NotifyUtil - A collection of helper methods to simplify notifying people when something needs attention

	Author:  Bobby White
	Company:  Salesforce.com
	Date: June 24, 2017
**/
public with sharing class NotifyUtil {

	public static void sendEmail(String subject, String msg) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		mail.toAddresses = new String[] { userInfo.getUserId() };
        //mail.setTreatTargetObjectAsRecipient(true);
        //mail.saveAsActivity = false;
        //mail.setTargetObjectId(userInfo.getUserId());


        mail.setSubject(subject);

        mail.setPlainTextBody(msg);
        mail.setHtmlBody(msg);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

	public static void chatterPost(Id locationId, String msg, List<id> mentions) {
		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

		if (mentions != null) {
			for (Id current : mentions) {
				ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
				mentionSegmentInput.id = current;
				messageBodyInput.messageSegments.add(mentionSegmentInput);
			}

		}


		textSegmentInput.text = msg;
		messageBodyInput.messageSegments.add(textSegmentInput);

		feedItemInput.body = messageBodyInput;
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = locationId;

		//ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
		System.enqueueJob(new QueueableChatterPoster(Network.getNetworkId(),feedItemInput));

	}

	/**
	  Queueable method to allow execution in the Trigger after error
	**/
	public with sharing class QueueableChatterPoster implements Queueable {
		final Id networkId;
		final ConnectApi.FeedItemInput feedInput;

		public QueueableChatterPoster(Id networkId, ConnectApi.FeedItemInput feedInput) {
			this.networkId = networkId;
			this.feedInput = feedInput;
			System.Debug('Constructor called');
		}
		public void execute(QueueableContext context) {
			System.Debug('execute method called');
			ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(this.networkId, this.feedInput);
		}
	}
}