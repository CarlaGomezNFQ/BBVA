@namespaceAccessible
public inherited sharing class Clib_SObjectFieldSetInclusionsSelector extends fflib_SObjectSelector implements Clib_ISObjectFieldSetInclusionsSelector { //NOSONAR
	@namespaceAccessible
	public static Clib_ISObjectFieldSetInclusionsSelector newInstance() {
		return (Clib_ISObjectFieldSetInclusionsSelector) Clib_Application.SELECTOR.newInstance(clib_SObjectFieldSetInclusion__mdt.SObjectType);
	}

        /**
         * Default constructor. Reads the fields from the getSObjectFieldList() method
         **/
	@namespaceAccessible
	public Clib_SObjectFieldSetInclusionsSelector() {
		super(false);
	}

        /**
         * Returns a default list of fields if FieldSets functionality is not used (No Dependency Injection Pattern here!)
         **/
	public override List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			       clib_SObjectFieldSetInclusion__mdt.Id,
			       clib_SObjectFieldSetInclusion__mdt.DeveloperName,
			       clib_SObjectFieldSetInclusion__mdt.clib_FieldSetFQDNName__c,
			       clib_SObjectFieldSetInclusion__mdt.clib_SObjectName__c
		};
	}

	public override Schema.SObjectType getSObjectType() {
		return clib_SObjectFieldSetInclusion__mdt.sObjectType;
	}

	@namespaceAccessible
	public List<clib_SObjectFieldSetInclusion__mdt> selectByDeveloperName(Set<String> stringSet) {
		fflib_QueryFactory fieldSetIncQF = newQueryFactory();
		return (List<clib_SObjectFieldSetInclusion__mdt>) Database.query (
			fieldSetIncQF.setCondition('DeveloperName in :stringSet').toSOQL());

	}

	@namespaceAccessible
	public List<clib_SObjectFieldSetInclusion__mdt> selectBySObjectName(Set<String> stringSet) {
		fflib_QueryFactory fieldSetIncQF = newQueryFactory();
		return (List<clib_SObjectFieldSetInclusion__mdt>) Database.query (
			fieldSetIncQF.setCondition('clib_SObjectName__c in :stringSet').toSOQL());
	}
}