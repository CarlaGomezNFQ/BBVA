public inherited sharing class Clib_SynchronizatorSelector { //NOSONAR
	public List<sObject> selectById(schema.SObjectType sObjectName, Set<schema.SObjectField> sObjectSelectFields, Set<String> sObjectIds) {
		String selectClause = getSelectClause(sObjectSelectFields);
		List<sObject> results = new List<sObject>();
		String myQuery = selectClause + ' FROM ' + sObjectName.getDescribe().getName() + ' WHERE Id IN :sObjectIds';
		system.debug('SyncSelector.selectById() Query: ' + myQuery);

		results = Database.query(String.escapeSingleQuotes(myQuery));
		return results;
	}

	public List<sObject> selectByExternalName(schema.SObjectType sObjectName, Set<schema.SObjectField> sObjectSelectFields, Set<String> sObjectExternalIds, schema.SObjectField externalFieldName) {
		String selectClause = getSelectClause(sObjectSelectFields);
		List<sObject> results = new List<sObject>();
		String myQuery = selectClause + ' FROM ' + sObjectName.getDescribe().getName() + ' WHERE ' + externalFieldName + ' IN :sObjectExternalIds';
		system.debug('SyncSelector.selectByExternalName() Query: ' + myQuery);

		results = Database.query(String.escapeSingleQuotes(myQuery));
		return results;
	}

	private String getSelectClause(Set<schema.SObjectField> sObjectSelectFields) {
		String selectClause = 'SELECT Id, ';

		if (sObjectSelectFields != null && sObjectSelectFields.size() > 0) {
			for (schema.SObjectField selectfield : sObjectSelectFields) {
				selectClause += selectField.getDescribe().getName() + ', ';
			}
		}
		return selectClause.removeEnd(', ');
	}
}