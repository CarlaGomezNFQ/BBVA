public inherited sharing class Clib_EncryptedKeysSelector extends fflib_SObjectSelector implements Clib_IEncryptedKeysSelector { //NOSONAR

    public static Clib_IEncryptedKeysSelector newInstance() {
		return (Clib_IEncryptedKeysSelector) Clib_Application.SELECTOR.newInstance(clib_Encrypted_Key__mdt.SObjectType);
	}

        /**
         * Default constructor. Reads the fields from the getSObjectFieldList() method
         **/
	public Clib_EncryptedKeysSelector() {
		super(false);
	}

        /**
         * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
         **/
	public override List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			       clib_Encrypted_Key__mdt.Id,
			       clib_Encrypted_Key__mdt.DeveloperName,
                   clib_Encrypted_Key__mdt.clib_Crypto_key__c,
                   clib_Encrypted_Key__mdt.clib_Key__c
		};
	}

	public override Schema.SObjectType getSObjectType() {
		return clib_Encrypted_Key__mdt.sObjectType;
	}

    public List<clib_Encrypted_Key__mdt> selectByDeveloperName(Set<String> stringSet) {
		fflib_QueryFactory encryptedKeyQF = newQueryFactory();
		return (List<clib_Encrypted_Key__mdt>) Database.query (
			encryptedKeyQF.setCondition('DeveloperName in :stringSet').toSOQL());

	}
}