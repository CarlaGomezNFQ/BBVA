/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SaveMultitemplate_Test
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 20/10/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class method for Arc_Gen_SaveMultitemplate
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |20-10-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_SaveMultitemplate_Test {
    /**
    * @description makeData
    * @author amunguia.contractor@bbva.com | 10-20-2021
    **/
    @TestSetup
    static void makeData() {
        // All basic data inserted.
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('ES', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        acc.Site = 'ES';
        insert acc;
        final arce__Analysis__c analisis = Arc_UtilitiesToTest_tst.crearArceAnalysis('TestAna', 'Arce', acc.id);
        analisis.arce__anlys_wkfl_sub_process_type__c = '4';
        insert analisis;
        final arce__Sector__c sector = Arc_UtilitiesToTest_tst.crearSector('g-01', '100', 'g-01', null);
        insert sector;
        final arce__Account_has_Analysis__c aha = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(sector.Id, analisis.Id, acc.id, 'g-01');
        aha.arce__group_asset_header_type__c = '1';
        aha.arce__analysis_template_id__c = 'Generic';
        aha.arce__InReview__c = true;
        aha.arce__IRP_Workflow__c = System.Label.Arc_Gen_NewRaipAdjustmentApi;
        insert aha;
        final arce__rating__c rating = Arc_UtilitiesToTest_tst.createRatingObj(null, 'AAA', 'AAA', '2');
        insert rating;
        final arce__Financial_Statements__c ffss = Arc_UtilitiesToTest_tst.crearFinStatement(acc.id, aha.id, rating.Id, null);
        insert ffss;
        aha.arce__ffss_for_rating_id__c = ffss.id;
        aha.arce__financial_statement_id__c = ffss.id;
        update aha;
        final arce__Activity_Split_2012__c actSplt2012 = new arce__Activity_Split_2012__c();
        actSplt2012.arce__Account_has_Analysis__c = aha.Id;
        actSplt2012.arce__sector_id__c = 'B';
        actSplt2012.arce__Subsector_id__c = 'BE';
        actSplt2012.arce__gf_company_economic_actvy_id__c = 'BEB';
        actSplt2012.arce__gf_subactivity_id__c = 'BEB1';
        actSplt2012.arce__Country__c = 'AU';
        actSplt2012.arce__Template_type__c = '107';
        insert actSplt2012;
        Test.loadData(dyfr__Template__c.sObjectType, 'Arc_Gen_templates');
        Test.loadData(dyfr__Tab__c.sObjectType, 'Arc_Gen_tabs');
        Test.loadData(dyfr__Field_Config__c.sObjectType, 'Arc_Gen_fieldConfigs');
        Test.loadData(dyfr__Dependent_value__c.sObjectType, 'Arc_Gen_dataValues');
    }

    /**
    * @description save test
    * @author amunguia.contractor@bbva.com | 10-20-2021
    **/
    @isTest
    public static void testSaveOK1() {
        final arce__Activity_Split_2012__c actSplt2012 = [SELECT Id, arce__Continuity__c FROM arce__Activity_Split_2012__c LIMIT 1];
        actSplt2012.arce__Continuity__c = '5';
        final List<sObject> param = new List<sObject>{actSplt2012};

        Test.startTest();
        final Arc_Gen_SaveMultitemplate saveImpl = new Arc_Gen_SaveMultitemplate();
        final String resp = saveImpl.save(param);
        System.assert(resp.containsIgnoreCase('"validated":true'), 'response must contains "validated":true as a sign of successful execution');
        Test.stopTest();
    }
}