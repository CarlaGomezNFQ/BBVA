/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ActionsPersistence_Test
* @Author   José Luis García    joseluis.garcia4.contractor@bbva.com
* @Date     Created: 2021-02-18
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Test class for Arc_Gen_ActionsPersistence_Service.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2021-02-11 joseluis.garcia4.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@IsTest
global class Arc_Gen_ActionsPersistence_Test {
    /**
    * @Description: String with external id of test group
    */
    static final string GROUP_ID = 'G000001';
    /**
    * @Description: String with external id of test subsidiary
    */
    static final string SUBSIDIARY_ID = 'C000001';
    /**
    * @Description: String with external id of test subsidiary
    */
    static final string SUBSIDIARY_ID2 = 'C000004';

    /**
    *-------------------------------------------------------------------------------
    * @description Setup data for test.
    --------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 18/02/2021
    **/
    @TestSetup
    global static void setup() {
        Arc_UtilitiesToTest_tst.setupAcccounts();
        final Map<String,Arc_Gen_Account_Wrapper> groupAccWrapper = Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String>{GROUP_ID,SUBSIDIARY_ID,SUBSIDIARY_ID2});
        final Arc_Gen_Account_Wrapper groupAccount = groupAccWrapper.get(GROUP_ID);
        final Arc_Gen_Account_Wrapper childAccount = groupAccWrapper.get(SUBSIDIARY_ID);

        final arce__Analysis__c arceVar = Arc_UtilitiesToTest_tst.crearArceAnalysis('arceAnalysis', null, groupAccount.accId);
        arceVar.arce__analysis_customer_relation_type__c = '01';
        arceVar.arce__Temporal_status__c = false;
        arceVar.arce__anlys_wkfl_sub_process_type__c = Arc_Gen_Constants.SUBPROCESS_NEW;
        insert arceVar;
        final arce__Analysis__c arceVarIrp = Arc_UtilitiesToTest_tst.crearArceAnalysis('arceRaip', null, groupAccount.accId);
        arceVarIrp.arce__analysis_customer_relation_type__c = '01';
        arceVarIrp.arce__Temporal_status__c = false;
        arceVarIrp.arce__anlys_wkfl_sub_process_type__c = Arc_Gen_Constants.SUBPROCESS_RATING;
        insert arceVarIrp;

        final arce__Sector__c sector = new arce__Sector__c();
        sector.arce__developer_name__c = 's-01';
        sector.arce__analysis_template_id__c = '1';
        insert sector;

        final arce__rating__c rating = new arce__rating__c();
        rating.arce__rating_id__c = '8932748289234';
        insert rating;

        final arce__Financial_Statements__c financial = new arce__Financial_Statements__c();
        financial.arce__ffss_submitted_type__c = '1';
        financial.arce__rating_id__c = rating.Id;
        insert financial;


        final arce__Account_has_Analysis__c accHasAnGp = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(null, arceVar.Id, groupAccount.accId, '1');
        accHasAnGp.arce__group_asset_header_type__c = '1';
        accHasAnGp.arce__ffss_for_rating_id__c = financial.Id;
        accHasAnGp.arce__currency_id__c = 'EUR';
        accHasAnGp.arce__risk_policy_type__c = '1';
        insert accHasAnGp;
        final arce__Account_has_Analysis__c accHasAnCl = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(null, arceVar.Id, childAccount.accId, '1');
        accHasAnCl.arce__group_asset_header_type__c = '2';
        accHasAnCl.arce__ll_before_adj_clsfn_type__c = 'NI';
        accHasAnCl.arce__fin_covenants_breach_type__c = '1';
        accHasAnCl.arce__ll_test_scope_ind_type__c = '2';
        accHasAnCl.arce__ffss_for_rating_id__c = financial.Id;
        accHasAnCl.arce__InReview__c = true;
        accHasAnCl.arce__currency_id__c = '';
        accHasAnCl.arce__risk_policy_type__c = '1';
        insert accHasAnCl;
        final arce__Account_has_Analysis__c accHasAnRaip = Arc_UtilitiesToTest_tst.crearAccHasAnalysis(null, arceVarIrp.Id, childAccount.accId, '1');
        accHasAnRaip.arce__group_asset_header_type__c = '2';
        accHasAnRaip.arce__ll_before_adj_clsfn_type__c = 'NI';
        accHasAnRaip.arce__fin_covenants_breach_type__c = '1';
        accHasAnRaip.arce__ll_test_scope_ind_type__c = '2';
        accHasAnRaip.arce__ffss_for_rating_id__c = financial.Id;
        accHasAnRaip.arce__InReview__c = true;
        accHasAnRaip.arce__currency_id__c = '';
        accHasAnRaip.arce__risk_policy_type__c = '1';
        insert accHasAnRaip;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Test persistence for analysis.
    *-------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 18/02/2021
    **/
    @IsTest
    global static void testPersistenceAnalysis() {
        final arce__Analysis__c analysis = [SELECT Id FROM arce__Analysis__c WHERE Name = 'arceAnalysis' LIMIT 1];
        Test.startTest();
        Arc_Gen_ActionsPersistence_Service.persistArceAction(analysis.Id, Arc_Gen_ActionsPersistence_Service.ACTION_PROPOSE);
        Test.stopTest();
        System.assert(true, 'Persistence must not throw any exception.');
    }

    /**
    *-------------------------------------------------------------------------------
    * @description Test persistence for IRP.
    *-------------------------------------------------------------------------------
    * @author joseluis.garcia4.contractor@bbva.com
    * @date 18/02/2021
    **/
    @IsTest
    global static void testPersistenceRaip() {
        final arce__Analysis__c analysis = [SELECT Id FROM arce__Analysis__c WHERE Name = 'arceRaip' LIMIT 1];
        Test.startTest();
        Arc_Gen_ActionsPersistence_Service.persistArceAction(analysis.Id, Arc_Gen_ActionsPersistence_Service.ACTION_PROPOSE);
        Test.stopTest();
        System.assert(true, 'Persistence must not throw any exception.');
    }
}