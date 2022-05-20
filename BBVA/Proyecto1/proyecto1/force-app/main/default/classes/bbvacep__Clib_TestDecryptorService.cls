@isTest
public class Clib_TestDecryptorService {

    @isTest static void decriptKeyTest() {
        String key = Clib_DecryptorService.decryptKey('Sample_key');
        System.assertEquals(key, 'Sample');
    }
}