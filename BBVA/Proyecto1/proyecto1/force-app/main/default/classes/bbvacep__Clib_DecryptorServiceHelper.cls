public inherited sharing class Clib_DecryptorServiceHelper {

	public String decryptKey(String key) {
		String decryptedKey;
		clib_Encrypted_Key__mdt keyMdt = new Clib_EncryptedKeysSelector().selectByDeveloperName(new Set <String> {key})[0];
		Blob encryptedData = EncodingUtil.base64Decode(keyMdt.clib_Key__c);
		Blob cryptoKey = EncodingUtil.base64Decode(keyMdt.clib_Crypto_key__c);
		Blob decrypted = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedData);//NOSONAR
		decryptedKey = decrypted.toString();
		return decryptedKey;
	}
}