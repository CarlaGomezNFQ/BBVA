global inherited sharing class Clib_SynchronizatorChangeTriggerHandler implements Clib_IChangeTriggerHandler{
  global void afterInsert(List<SObject> newItems) {
    CLib_SynchronizatorService.synchronize(newItems);
  }
}