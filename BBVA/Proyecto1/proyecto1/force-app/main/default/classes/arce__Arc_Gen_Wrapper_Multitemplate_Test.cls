/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_JsonBuilder_Corp_Test
* @Author   BBVA Developers
* @Date     Created: 2020-07-14
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description test class for Arc_Gen_Wrapper_Multitemplate
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-14 BBVA Developers.
*              Test Class creation.
* 2020-10-21  amunguia@bbva.com the picklist values ​​are updated with the new values
* 2021-07-29  saimassimilianno.jordana.contractor@bbva.com wrapperMultitemplateBuildWithParticipant
*             and wrapperMultitemplateBuildWithoutAction methods modified while wrapperWithoutAction2012 and
*             wrapperWithAction2012 methods created to test new funcionalities of 2012 model.
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_Wrapper_Multitemplate_Test {
    @TestSetup
    static void testSetup(){
        Test.loadData(dyfr__Template__c.sObjectType, 'Arc_Gen_templates');
        Test.loadData(dyfr__Tab__c.sObjectType, 'Arc_Gen_tabs');
        Test.loadData(dyfr__Field_Config__c.sObjectType, 'Arc_Gen_fieldConfigs');

        final arce__Analysis__c analisis = Arc_Gen_Testing_Util.createAnalisis();
        insert analisis;
        final arce__Account_has_Analysis__c aha = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis.id);
        insert Aha;
        final arce__Activity_Split__c activity = Arc_Gen_Testing_Util.createActivitySplit('I', 'IC','ICA', '1341', '1', 25, '1');
        activity.arce__Account_has_Analysis__c = aha.Id;
        insert activity;
        final arce__Geographic_Split__c geoSplit = Arc_Gen_Testing_Util.createGeographicSplit('ES', 10, activity.Id, '1');
        insert geoSplit;

        final arce__Analysis__c analisis2012 = Arc_Gen_Testing_Util.createAnalisis2012();
        insert analisis2012;
        final arce__Account_has_Analysis__c aha2012 = Arc_Gen_Testing_Util.createAccountHasAnalisis(analisis2012.id);
        insert aha2012;
        final arce__Activity_Split_2012__c activity2012 = Arc_Gen_Testing_Util.crteActvtySplt2012();
        activity2012.arce__Account_has_Analysis__c = aha2012.Id;
        insert activity2012;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Test for wrapper Constructor by Account Has Analysis
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-27
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void wrapperMultitemplateBuildWithAction() {
        final arce__Account_has_Analysis__c aha =  [Select id from arce__Account_has_Analysis__c limit 1];
        final Arc_Gen_Wrapper_Multitemplate wrapper = new Arc_Gen_Wrapper_Multitemplate(aha.Id,'NEW','2019');
        System.assertEquals('IC',  wrapper.root[0].subsector.id, 'Error wrapperBuild Account Has Analysis');
    }

        /**
    *-------------------------------------------------------------------------------
    * @Description Test for wrapper Constructor by Account Has Analysis
    *--------------------------------------------------------------------------------
    * @ Author ivan.cons@bbva.com
    * @ Date   Created: 2021-01-27
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void wrapperMultitemplateBuildWithParticipant() {
        final arce__Account_has_Analysis__c aha =  [Select id from arce__Account_has_Analysis__c limit 1];
        final Arc_Gen_Wrapper_Multitemplate wrapper = new Arc_Gen_Wrapper_Multitemplate(aha.Id,'NEW', 'riskAssessmentId', 'participantId','2019');
        System.assertEquals(true,  wrapper.root[0].id.contains('riskAssessmentId'), 'Error wrapperBuild Account Has Analysis');
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Test for wrapper Constructor by Activity
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-08-03
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void wrapperMultitemplateBuildWithoutAction() {
        final arce__Account_has_Analysis__c aha =  [Select id from arce__Account_has_Analysis__c limit 1];
        final Arc_Gen_Wrapper_Multitemplate wrapper = new Arc_Gen_Wrapper_Multitemplate(aha.Id, '2019');
        System.assertEquals('IC',  wrapper.root[0].subsector.id, 'Error wrapperBuild Account Has Analysis');
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Test for wrapper Constructor by Activity
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date   Created: 2020-08-03
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void wrapperWithoutAction2012() {
        final arce__Account_has_Analysis__c aha =  [Select id from arce__Account_has_Analysis__c where arce__Analysis__r.name = '2012' limit 1];
        final Arc_Gen_Wrapper_Multitemplate wrapper = new Arc_Gen_Wrapper_Multitemplate(aha.Id, '2012');
        System.assertEquals('AD',  wrapper.root[0].subsector.id, 'Error wrapper multitemplate without action 2012');
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Test for wrapper Constructor by Account Has Analysis
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date   Created: 2020-07-27
    *--------------------------------------------------------------------------------
    **/
    @isTest
    public static void wrapperWithAction2012() {
        final arce__Account_has_Analysis__c aha =  [Select id from arce__Account_has_Analysis__c where arce__Analysis__r.name = '2012' limit 1];
        final Arc_Gen_Wrapper_Multitemplate wrapper = new Arc_Gen_Wrapper_Multitemplate(aha.Id,'NEW','2012');
        System.assertEquals('AD',  wrapper.root[0].subsector.id, 'Error wrapper multitemplate with action 2012');
    }
}