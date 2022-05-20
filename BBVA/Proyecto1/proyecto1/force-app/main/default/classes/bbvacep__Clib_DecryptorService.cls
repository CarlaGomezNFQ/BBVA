global inherited sharing class Clib_DecryptorService implements Clib_IDecryptorService{
    global static String decryptKey(String key) {
		return service().decryptKey(key);
	}

	private static Clib_IDecryptorService service() {
		return (Clib_IDecryptorService) Clib_Application.SERVICE.newInstance(Clib_IDecryptorService.class);
	}
}