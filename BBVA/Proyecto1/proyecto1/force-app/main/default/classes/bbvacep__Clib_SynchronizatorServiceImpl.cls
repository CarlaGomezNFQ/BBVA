public inherited sharing class Clib_SynchronizatorServiceImpl implements Clib_ISynchronizatorService {
	public static Map<Id,String> synchronize(List<SObject> records) {
    Clib_SynchronizatorServiceHelper helper = new Clib_SynchronizatorServiceHelper();
		return helper.synchronize(records);
	}
}