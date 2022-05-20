public inherited sharing class Clib_DecryptorServiceImpl implements Clib_IDecryptorService {

  Clib_DecryptorServiceHelper helper = new Clib_DecryptorServiceHelper();

  public String decryptKey(String key) {
		return helper.decryptKey(key);
	}
}