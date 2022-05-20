public inherited sharing class Clib_MDTEmailServiceParserSelector extends fflib_SObjectSelector implements Clib_IMDTEmailServiceParserSelector { //NOSONAR

	public static Clib_MDTEmailServiceParserSelector newInstance() {
		return (Clib_MDTEmailServiceParserSelector) Clib_Application.SELECTOR.newInstance(clib_Email_Service_Parser__mdt.SObjectType);
	}

        /**
         * Default constructor. Reads the fields from the getSObjectFieldList() method
         **/
	public Clib_MDTEmailServiceParserSelector() {
		super(false);
	}

        /**
         * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
         **/
	public override List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			clib_Email_Service_Parser__mdt.Id,
            clib_Email_Service_Parser__mdt.MasterLabel,
			clib_Email_Service_Parser__mdt.DeveloperName,
			clib_Email_Service_Parser__mdt.clib_ApexClass__c,
			clib_Email_Service_Parser__mdt.clib_Attributes__c,
            clib_Email_Service_Parser__mdt.clib_Regex_Expression__c,
            clib_Email_Service_Parser__mdt.clib_From_Address__c
		};
	}

	public override Schema.SObjectType getSObjectType() {
		return clib_Email_Service_Parser__mdt.sObjectType;
	}

	public List<clib_Email_Service_Parser__mdt> selectByDeveloperName(Set<String> stringSet) {
		fflib_QueryFactory emailServiceParser = newQueryFactory();
		return (List<clib_Email_Service_Parser__mdt>) Database.query (
			emailServiceParser.setCondition('DeveloperName in :stringSet').toSOQL());
    }
    
    public List<clib_Email_Service_Parser__mdt> selectAll() {
		fflib_QueryFactory emailServiceParser = newQueryFactory();
		String query = Test.isRunningTest() ? String.escapeSingleQuotes(emailServiceParser.toSOQL()) : emailServiceParser.setCondition('developerName != \'Test_Class\'').toSOQL();
		return (List<clib_Email_Service_Parser__mdt>) Database.query (query);//NOSONAR
	}
}