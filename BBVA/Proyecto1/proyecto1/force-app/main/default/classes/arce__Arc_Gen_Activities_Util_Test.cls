/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Activities_Util_Test
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 20/10/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Test class that covers: Arc_Gen_Activities_Util
* -----------------------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_Activities_Util_Test {
    /**
    * @description makeData
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @Date     Created: 20/10/2021
    **/
    @TestSetup
    static void makeData() {
        final arce__Analysis__c analisis1 = Arc_Gen_Testing_Util.createAnalisis();
        analisis1.Name = '2019';
        insert analisis1;
        final arce__Analysis__c analisis2 = Arc_Gen_Testing_Util.createAnalisis2012();
        insert analisis2;
        final arce__Account_has_Analysis__c aha1 = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis1.Id);
        insert aha1;
        final arce__Account_has_Analysis__c aha2 = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis2.Id);
        insert aha2;
        final arce__Activity_Split__c activity1 = Arc_Gen_Testing_Util.createActivitySplit();
        activity1.arce__Account_has_Analysis__c = aha1.Id;
        insert activity1;
        final arce__Activity_Split_2012__c activity2 = Arc_Gen_Testing_Util.crteActvtySplt2012();
        activity2.arce__Account_has_Analysis__c = aha2.Id;
        insert activity2;

    }

    /**
    * @description getAllActByParent2012ById method test
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @Date     Created: 20/10/2021
    **/
    @isTest
    public static void byParentPrctg2012ByIdTest() {
        final String currentId = [select Id from arce__Activity_Split_2012__c LIMIT 1].Id;
        final Set<String> parentId = new Set<String>{currentId};
        Test.startTest();
        final List<arce__Activity_Split_2012__c> result = Arc_Gen_Activities_Util.getAllActByParent2012ById(parentId);
        final Decimal resultPrc = Arc_Gen_Activities_Util.getOveralActivitiesPrcntg2012(result);
        Test.stopTest();
        System.assertEquals(97, resultPrc, 'differents Percentage');
    }

    /**
    * @description getAllActivitiesByParentAndTemplate method test
    * @author saimassimilianno.jordana.contractor@bbva.com
    * @Date     Created: 20/10/2021
    **/
    @isTest
    public static void actvByParentAndTemplTest() {
        final String currentId = [select Id, arce__Analysis__r.Name from arce__Account_has_Analysis__c where arce__Analysis__r.Name = '2019' LIMIT 1].Id;
        final Set<String> parentId = new Set<String>{currentId};
        final Set<String> templateId = new Set<String>{'10'};
        Test.startTest();
        final List<arce__Activity_Split__c> result = Arc_Gen_Activities_Util.getAllActivitiesByParentAndTemplate(parentId,templateId);
        Test.stopTest();
        System.assertEquals('D', result[0].arce__sector_id__c, 'differents Sectors');
    }

}