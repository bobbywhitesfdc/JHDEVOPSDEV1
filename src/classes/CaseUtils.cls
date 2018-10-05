public with sharing class CaseUtils {
	public CaseUtils() {
	}

	public static Contact getContactForCurrentUser() {
		return getContactForUser(UserInfo.getUserId());
	}
	/**
	* Given a User, get their contact record.
	If they don't have one, create it and link it.
	
	**/
	public static Contact getContactForUser(id userId) {
		// Get the User Record, check to see if they have a built in Contact
		User current = [SELECT id,email,name, firstName,lastName, companyname, accountId, contactId 
						  From User Where Id = :userId];

		if (current.contactId != null) {
			return getContactById(current.contactId);
		}


		// If not found, check for an internal contact
		List<Contact> contacts = [SELECT id, name, accountId 
								    from Contact 
								   where id = :userId order by id];

	    if (contacts.isEmpty()) {
	    	String[] emailParts = current.email.split('@');


	    	Account theAccount = new Account(name=emailParts[1]);
	    	upsert theAccount;

	    	Contact theContact = new Contact(firstName = current.firstName
	    							, lastName = current.LastName
	    							, email = current.email
	    							, accountId = theAccount.id);

	    	upsert theContact email;

	    	//current.ContactId = theContact.Id;  Can't do this for internal users!
	    	//update current;

			return theContact;

	    } else {
	    	return contacts[0];

	    }
	}

	private static Contact getContactById(Id contactId) {
		List<Contact> contacts  = [SELECT id, name, accountId 
								     From Contact 
								    Where Internal_User__c = :contactId];
		return (contacts.isEmpty() ? null : contacts[0]);
	}
}