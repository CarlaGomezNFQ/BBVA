/**
 * @name    	MM_GBL_TestFactory 
 * @description This class helps create customized test data, the methods are organized by Object and ordered alphabitacally
 */
@IsTest
public class MM_GBL_TestFactory {

//
// Account
//

    /**
     * @description This method creates a list of Accounts
     * @param   	nb : an integer representing the number of records to create           
     * @return  	list<Account> : the created Accounts' list
     */
    public static list<Account> getAccounts(String seed, Integer nb, Id ownerId) {
        List<Account> results = new list<Account>();
        String recordTypeId = [
            SELECT	Id
            FROM	RecordType
            WHERE	SObjectType = 'Account'
            AND		DeveloperName = 'MM_GBL_Cliente'
            LIMIT	1
        ].Id;

        // Parent Account
        Account parent = new Account(
                    Name = seed + ' Parent',                    
                    RecordTypeId = recordTypeId,
                    BillingCountry = 'US',
           			BillingCity = 'San Francisco',
           			BillingPostalCode = '30100',
           			BillingStreet = 'The Landmark @ One Market, Suite 200',
                    OwnerId = ownerId
                );
        insert parent;
        for (Integer i = 0; i < nb; i++) {
            Account tmp = new Account(
                    Name = seed + String.valueOf(i),                    
                    RecordTypeId = recordTypeId,
                    BillingCountry = 'US',
           			BillingCity = 'San Francisco',
           			BillingPostalCode = '30100',
           			BillingStreet = 'The Landmark @ One Market, Suite 20' + i,
                    ParentId = parent.Id,
                    OwnerId = ownerId
                );
            results.add(tmp);
        }
        return results;
    }


//
// Contact
//
  
	/**
     * @description This method creates a list of Contact
     * @param   	nb : an integer representing the number of records to create           
     * @param   	accounts : the list of the parent accounts
	 * @return  	list<Contact> : the created Contacts' list
     */
    public static list<Contact> getContacts(String seed, Integer nb, list<Account> accounts) {
        List<Contact> results = new list<Contact>();
        Integer accountsSize = accounts.size();
        
        for (Integer i = 0; i < nb; i++) {
            results.add(
                new Contact(
                    LastName = seed + i,
                    FirstName = seed + i,
                    Email = seed + '@' + seed + '.com',
                    AccountId = accounts[Math.mod(i, accountsSize-1)].Id
                )
            );
        }
        return results;
    }
    
    
//
// User
//

	 /**
      * @description This method creates a list of Users
      * @param   	nb : an integer representing the number of records to create
      * @param   	profileName : the name of the profile used for users assignment
      * @return  	list<User> : the created Users' list
      */
    public static list<User> getUsers(String seed, Integer nb, String profileName) {
        List<User> results = new list<User>();
        Id profileId = [SELECT Id from Profile where Name=:profileName].Id;
        User theUser;
        for (Integer i = 0; i < nb; i++) {
            theUser = new User(
                Email = seed + i + '@bbva.com', 
       			UserName = seed + i + '@bbva.com', 
       			Alias = seed + i,
       			CommunityNickName = seed + i,
       			TimeZoneSidKey = 'GMT',
                LocaleSidKey = 'en_US', 
				EmailEncodingKey = 'UTF-8',  
       			LanguageLocaleKey = 'en_US', 
       			FirstName = seed, 
       			LastName = seed + i,
                ProfileId = profileId
            );
            results.add(theUser);
        }
            
        return results;
    }

   	/**
      * @description This method creates a list of Users
      * @param   	nb : an integer representing the number of records to create
      * @param   	profileName : the name of the profile used for users assignment
      * @return  	list<User> : the created Users' list
      */
    public static list<Opportunity> getOpportunities(List<String> stageStatusList, List<Account> accounts, Id ownerId) {
        List<Opportunity> results = new list<Opportunity>();
        
        Opportunity theOppty;
        Integer i = 0;
        for (String value : stageStatusList) {
             theOppty = new Opportunity(
                                Name = 'Oppty ' + i,
                                AccountId = accounts[Math.mod(i, accounts.size()-1)].Id,                                
                                StageName = value.split('-')[0],                                
                                CloseDate = Date.today().addDays(5),
                                Amount = 100,
                                OwnerId = ownerId                                
                            );          
        	 results.add(theOppty);
             i++;

        }            
        return results;
    }


}