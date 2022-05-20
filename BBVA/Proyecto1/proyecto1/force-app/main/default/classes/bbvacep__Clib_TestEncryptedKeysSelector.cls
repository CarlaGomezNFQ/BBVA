@isTest
public class Clib_TestEncryptedKeysSelector {

    @isTest static void selectByDeveloperNameTest() {
        List <cLib_Encrypted_Key__mdt> keyList = Clib_EncryptedKeysSelector.newInstance().selectByDeveloperName(new Set <String> {'Sample_key'});
        System.assert(!keyList.isEmpty());
    }
}