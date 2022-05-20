@isTest
public class Clib_TestMDTMappingFieldsSelector {

    @isTest static void selectByDeveloperNameTest() {
        List <clib_Mapping_Fields__mdt> mappingList = Clib_MDTMappingFieldsSelector.newInstance().selectByDeveloperName(new Set <String> {'Name'});
        System.assert(!mappingList.isEmpty());
    }
}