@isTest
public class Clib_TestSObjectFieldSetInclusionsSelec {

    @isTest static void selectByDeveloperNameTest() {
        List <clib_SObjectFieldSetInclusion__mdt> fieldSetIncList = Clib_SObjectFieldSetInclusionsSelector.newInstance().selectByDeveloperName(new Set <String> {'Sample'});
        System.assert(!fieldSetIncList.isEmpty());
    }
    
    @isTest static void selectBySObjectNameTest() {
        List <clib_SObjectFieldSetInclusion__mdt> fieldSetIncList = Clib_SObjectFieldSetInclusionsSelector.newInstance().selectBySObjectName(new Set <String> {'Sample'});
        System.assert(!fieldSetIncList.isEmpty());
    }
}