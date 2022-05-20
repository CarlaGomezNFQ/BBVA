public interface Clib_ISynchronizatorSelector {
    List<sObject> selectById(sObject sObjectName, Set<schema.SObjectField> sObjectSelectFields, Set<Id> sObjectIds);
	List<sObject> selectByExternalName(sObject sObjectName, Set<schema.SObjectField> sObjectSelectFields, Set<String> sObjectExternalIds, schema.SObjectField externalFieldName);
}