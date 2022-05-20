global inherited sharing class Clib_SynchronizatorService {
	global static Map<Id,String> synchronize(List<SObject> records) {
		return service().synchronize(records);
	}

	private static Clib_ISynchronizatorService service() {
		return (Clib_ISynchronizatorService) Clib_Application.SERVICE.newInstance(Clib_ISynchronizatorService.class);
	}
}