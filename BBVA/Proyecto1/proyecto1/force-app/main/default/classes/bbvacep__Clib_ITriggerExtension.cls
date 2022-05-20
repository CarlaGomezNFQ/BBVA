global interface Clib_ITriggerExtension {
    void onBeforeInsert(List <SObject> records);
    void onAfterInsert(List <SObject> records);
    void onBeforeUpdate(List <SObject> records, Map <Id, SObject> existingRecords);
    void onAfterUpdate(List <SObject> records, Map <Id, SObject> existingRecords);
    void onBeforeDelete(List <SObject> records);
    void onAfterDelete(List <SObject> records);
    void onAfterUndelete(List <SObject> records);
}