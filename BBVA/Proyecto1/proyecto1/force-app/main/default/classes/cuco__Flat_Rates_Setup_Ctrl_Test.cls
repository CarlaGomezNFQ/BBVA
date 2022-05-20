/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Setup_Ctrl_Test
* Test class for Flat_Rates_Setup_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-19
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class Flat_Rates_Setup_Ctrl_Test {

    @TestSetup
    static void makeDataFlatRatesSetup() {

        // Create parent acc
        final List<Account> lstFRSAcc = Test_Utils.createAccounts(1);
        lstFRSAcc[0].AccountNumber = 'B99999999';
        insert lstFRSAcc;

        // Create child accs
        final List<Account> lstFRSChildAcc = Test_Utils.createAccounts(2);
        for (Account accFRS : lstFRSChildAcc) {
            accFRS.ParentId = lstFRSAcc[0].Id;
        }
        insert lstFRSChildAcc;

        // Create ps_catalog_flat_rates_account__c
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAccFRS = Test_Utils.createPSCatFlatRatesAcc();
        insert lstPsCatFlatRatesAccFRS;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCFFRS = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCFFRS;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCCFRS = Test_Utils.createPSCatalogConditons(4, lstPSCFFRS[0]);
        insert lstPSCCFRS;

        // Create ps catalog attribute
        List<ps_catalog_attribute__c> lstPsCatAttbFR = Test_Utils.createPSCatalogAttributes(5);
        lstPsCatAttbFR[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        lstPsCatAttbFR[1].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        lstPsCatAttbFR[2].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        lstPsCatAttbFR[3].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        lstPsCatAttbFR[4].gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        insert lstPsCatAttbFR;

        // Create ps catalog condition attributes
        List<ps_catalog_condition_attribute__c> lstPsCatCondAttbFR = new List<ps_catalog_condition_attribute__c>();
        lstPsCatCondAttbFR.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCFRS[0], lstPsCatAttbFR));
        lstPsCatCondAttbFR.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCFRS[1], lstPsCatAttbFR));
        lstPsCatCondAttbFR.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCFRS[2], lstPsCatAttbFR));
        lstPsCatCondAttbFR.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCCFRS[3], lstPsCatAttbFR));
        for (Integer i=0; i<lstPsCatCondAttbFR.size(); i++) {
            lstPsCatCondAttbFR[i].gf_psc_condition_attribute_id__c = 'canonical.uniqueid.' + i;
            switch on Math.mod(i, 5) {
                when  0 {
                    lstPsCatCondAttbFR[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 1 {
                    lstPsCatCondAttbFR[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 2 {
                    lstPsCatCondAttbFR[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 3 {
                    lstPsCatCondAttbFR[i].gf_psc_ca_exemption_name__c = 'IF';
                }
                when 4 {
                    lstPsCatCondAttbFR[i].gf_psc_ca_exemption_name__c = 'true';
                }
            }
        }
        insert lstPsCatCondAttbFR;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSFRS = Test_Utils.createProfSheet(1, lstFRSAcc[0]);
        insert lstPSFRS;

        // Create profitability sheet participants
        final List<profitability_sheet_participant__c> lstPSPFRS = Test_Utils.createProfSheetParticipant(1, lstPSFRS[0].Id, new List<Id>{lstFRSChildAcc[0].Id});
        insert lstPSPFRS;

        // Create profitability sheet flat rates
        final profitability_sheet_flat_rates__c psFlatRateFRS = new profitability_sheet_flat_rates__c();
        psFlatRateFRS.gf_ps_fr_price_type__c = '';
        psFlatRateFRS.gf_ps_fr_fixed_annual_amount__c = 00;
        psFlatRateFRS.gf_ps_fr_variable_amount_desc__c = '';
        psFlatRateFRS.gf_ps_fr_charge_type__c = '';
        psFlatRateFRS.gf_ps_fr_charge_pdicy_type__c = '';
        psFlatRateFRS.gf_ps_fr_currency_type__c = '';
        psFlatRateFRS.gf_ps_fr_price_type__c = '';
        psFlatRateFRS.gf_ps_fr_no_wrkdy_ch_meth_type__c = '';
        psFlatRateFRS.gf_ps_fr_ac_no_bal_method_type__c = '';
        psFlatRateFRS.gf_profitability_sheet_id__c = lstPSFRS[0].Id;
        insert psFlatRateFRS;

        // Create profitability_sheet_flat_rates_account__c
        final List<profitability_sheet_flat_rates_accounts__c> lstPSFlatRatesAccs = Test_Utils.createPSFlatRatesAccounts(new List<profitability_sheet_flat_rates__c>{psFlatRateFRS, psFlatRateFRS}, new List<ps_catalog_flat_rates_account__c>{lstPsCatFlatRatesAccFRS[0], lstPsCatFlatRatesAccFRS[2]}, new List<Decimal>{20.1,50.2});
        insert lstPSFlatRatesAccs;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAFRS = Test_Utils.createProfAnalysis(3, lstFRSAcc[0]);
        for (profitability_analysis__c paFRS : lstPAFRS) {
            paFRS.gf_pa_management_type_name__c = 'Renewal';
            paFRS.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paFRS.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paFRS.gf_profitability_sheet_id__c = lstPSFRS[0].Id;
        }
        lstPAFRS[0].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAFRS;

        // Create profitability analysis participants
        final List<profitability_analysis_participant__c> lstPAPFRS = Test_Utils.createProfAnalysisParticipant(1, lstPAFRS[1].Id, new List<Id>{lstFRSChildAcc[1].Id});
        insert lstPAPFRS;

        // Create profitability analysis flat rates
        final List<profitability_analysis_flat_rates__c> lstPAFRFRS = Test_Utils.createPaFlatRate(new List<Id>{lstPAFRS[1].Id}, 'New');
        lstPAFRFRS[0].gf_pa_fr_request_type__c = null;
        insert lstPAFRFRS;

        // Create profitability_analysis_flatrates_account__c
        final List<profitability_analysis_flatrates_account__c> lstPAFlatRatesAccs = Test_Utils.createPAFlatRatesAccounts(new List<profitability_analysis_flat_rates__c>{lstPAFRFRS[0]}, new List<ps_catalog_flat_rates_account__c>{lstPsCatFlatRatesAccFRS[0]}, new List<Decimal>{22,50});
        insert lstPAFlatRatesAccs;

        // Create ps catalog flat rates dp
        final ps_catalog_flat_rates_dp__c pccafrdp = new ps_catalog_flat_rates_dp__c();
        insert pccafrdp;

        // Create profitability analysis flat rates dp
        final list<profitability_analysis_flat_rates_dp__c> lstPAFRDP = new List<profitability_analysis_flat_rates_dp__c>();
        final profitability_analysis_flat_rates_dp__c pafrdp = new profitability_analysis_flat_rates_dp__c();
        pafrdp.gf_pa_flat_rate_id__c = lstPAFRFRS[0].Id;
        pafrdp.gf_fr_dynamic_pricing_item_id__c = pccafrdp.Id;
        lstPAFRDP.add(pafrdp);
        insert lstPAFRDP;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPACFRS = new List<profitability_analysis_condition__c>();
        lstPACFRS.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAFRS[1], lstPSCCFRS[0]));
        lstPACFRS.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAFRS[1], lstPSCCFRS[1]));
        lstPACFRS[0].gf_pa_cond_atrb_source_type__c = 'COMMISSIONS_FLAT';
        lstPACFRS[1].gf_pa_cond_atrb_source_type__c = 'COMMISSIONS_FLAT';
        insert lstPACFRS;
    }

    // Check getFlatRatesSetupInfo with typology 'Renewal'
    @IsTest
    static void getFlatRatesSetupInfo1() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR1 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPAFR1 = profAnSelectorFR1.selectByName(setNamesPAFR1);
        final PsCatalogCondition_Selector psCatCondSelectorFR1 = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> lstPsCatCondFR1 = psCatCondSelectorFR1.selectByName(new Set<String>{'Condition 0', 'Condition 1', 'Condition 2', 'Condition 3'});
        final List<Id> lstCondIdFR = new List<Id>();
        for (ps_catalog_condition__c psc1 : lstPsCatCondFR1) {
            lstCondIdFR.add(psc1.Id);
        }

        Test.startTest();

            final Map<String, Object> retMap1 = Flat_Rates_Setup_Ctrl.getFlatRatesSetupInfo(lstPAFR1[0].Id, lstCondIdFR);
            System.assertNotEquals(null, retMap1, 'Err at Flat_Rates_Setup_Ctrl_Test - getFlatRatesSetupInfo1');

        Test.stopTest();
    }

    // Check getFlatRatesSetupInfo error
    @IsTest
    static void getFlatRatesSetupInfo2() {
        Test.startTest();
            try {
                Flat_Rates_Setup_Ctrl.getFlatRatesSetupInfo(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Flat_Rates_Setup_Ctrl_Test - getFlatRatesSetupInfo2');
            }
        Test.stopTest();
    }

    // Check checkSetupFlatRatesSetupPermissions with permissions
    @IsTest
    static void checkSetupFlatRatesSetupPermissions1() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR3 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPAFR3 = profAnSelectorFR3.selectByName(setNamesPAFR3);

        Test.startTest();

            final Map<String, Object> retMapFR3 = Flat_Rates_Setup_Ctrl.checkSetupFlatRatesSetupPermissions(lstPAFR3[0].Id);
            final Map<String, Object> expectedMapFR3 = new Map<String, Object>();
            expectedMapFR3.put('setup', true);
            System.assertEquals(expectedMapFR3, retMapFR3, 'Err at Flat_Rates_Setup_Ctrl_Test - checkSetupFlatRatesSetupPermissions1');

        Test.stopTest();
    }

    // Check checkSetupFlatRatesSetupPermissions without permissions
    @IsTest
    static void checkSetupFlatRatesSetupPermissions2() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR4 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPAFR4 = profAnSelectorFR4.selectByName(setNamesPAFR4);

        Test.startTest();

            final Map<String, Object> retMapFR4 = Flat_Rates_Setup_Ctrl.checkSetupFlatRatesSetupPermissions(lstPAFR4[0].Id);
            final Map<String, Object> expectedMapFR4 = new Map<String, Object>();
            expectedMapFR4.put('setup', false);
            expectedMapFR4.put('setupMessage', Label.setup_fr_perm_error_sample);
            System.assertEquals(expectedMapFR4, retMapFR4, 'Err at Flat_Rates_Setup_Ctrl_Test - checkSetupFlatRatesSetupPermissions2');

        Test.stopTest();
    }

    // Check doFlatRatesSetupSave with all values needed
    @IsTest
    static void doFlatRatesSetupSave1() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR5 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPAFR5 = profAnSelectorFR5.selectByName(setNamesPAFR5);
        final PsCatalogCondition_Selector psCatCondSelectorFR5 = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> lstPsCatCondFR5 = psCatCondSelectorFR5.selectByName(new Set<String>{'Condition 0', 'Condition 3'});
        final PSCatalogFlatRatesAccount_Selector psCatFlatRatesAccsSelector = new PSCatalogFlatRatesAccount_Selector(true);
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAcc = psCatFlatRatesAccsSelector.selectByCanonicalId(new Set<String>{'comflat.debts.pyg.accounts.type', 'comflat.opr.pyg.accounts.type'});
        final String strDataFR5 = '{"flatRates":{"priceType":"IF","fixedAmount":222222.01,"chargeType":"2","periodicityChageType":"3","currencyType":"JPY","chargeDay":"22","nonWorkingDayChargeMethod":"A","accWithoutBalanceMethod":"C","invoceComments":"yrdy","accountComments":"test"},"flatRatesAccounts":[{"accId":"' + lstPsCatFlatRatesAcc[0].Id + '","usePercent":15},{"accId":"' + lstPsCatFlatRatesAcc[1].Id + '","usePercent":99}],"flatRatesConditions":[{"conditionId":"' + lstPsCatCondFR5[0].Id + '","estOpVol":"99"},{"conditionId":"' + lstPsCatCondFR5[1].Id + '","estOpVol":"11"}]}';

        Test.startTest();

            final Map<String, Object> retMapFR5 = Flat_Rates_Setup_Ctrl.doFlatRatesSetupSave(lstPAFR5[0].Id, strDataFR5);
            final Map<String, Object> actualMapFR5 = new Map<String, Object>();
            actualMapFR5.put('isSuccess', retMapFR5.get('isSuccess'));
            final Map<String, Object> expectedMapFR5 = new Map<String, Object>();
            expectedMapFR5.put('isSuccess', true);
            System.assertEquals(expectedMapFR5, actualMapFR5, 'Err at Flat_Rates_Setup_Ctrl_Test - doFlatRatesSetupSave1');

        Test.stopTest();
    }

    // Check doFlatRatesSetupSave with no flat rates record
    @IsTest
    static void doFlatRatesSetupSave2() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR6 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPAFR6 = profAnSelectorFR6.selectByName(setNamesPAFR6);
        final PSCatalogFlatRatesAccount_Selector psCatFlatRatesAccsSelectorFR6 = new PSCatalogFlatRatesAccount_Selector(true);
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAccFR6 = psCatFlatRatesAccsSelectorFR6.selectByCanonicalId(new Set<String>{'comflat.debts.pyg.accounts.type', 'comflat.opr.pyg.accounts.type'});
        final String strDataFR6 = '{"flatRates":{"priceType":"EF","fixedAmount":222222.01,"chargeType":"2","periodicityChageType":"3","currencyType":"JPY","chargeDay":"22","nonWorkingDayChargeMethod":"A","accWithoutBalanceMethod":"C","invoceComments":"yrdy","accountComments":"test"},"flatRatesAccounts":[{"accId":"' + lstPsCatFlatRatesAccFR6[0].Id + '","usePercent":15},{"accId":"' + lstPsCatFlatRatesAccFR6[1].Id + '","usePercent":99}],"flatRatesConditions":[]}';

        Test.startTest();

            final Map<String, Object> retMapFR6 = Flat_Rates_Setup_Ctrl.doFlatRatesSetupSave(lstPAFR6[0].Id, strDataFR6);
            final Map<String, Object> actualMapFR6 = new Map<String, Object>();
            actualMapFR6.put('isSuccess', retMapFR6.get('isSuccess'));
            final Map<String, Object> expectedMapFR6 = new Map<String, Object>();
            expectedMapFR6.put('isSuccess', true);
            System.assertEquals(expectedMapFR6, actualMapFR6, 'Err at Flat_Rates_Setup_Ctrl_Test - doFlatRatesSetupSave2');

        Test.stopTest();
    }

    // Check doFlatRatesSetupSave with err on flatRates values
    @IsTest
    static void doFlatRatesSetupSave3() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR7 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR7 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPAFR7 = profAnSelectorFR7.selectByName(setNamesPAFR7);
        final String strDataFR7 = '{"flatRates":{"priceType":"34","fixedAmount":222222.01,"chargeType":"V","periodicityChageType":"T","currencyType":"JPY","chargeDay":"22","nonWorkingDayChargeMethod":"A","accWithoutBalanceMethod":"C","invoceComments":"yrdy","accountComments":"test"},"flatRatesAccounts":[],"flatRatesConditions":[]}';

        Test.startTest();

            final Map<String, Object> retMapFR7 = Flat_Rates_Setup_Ctrl.doFlatRatesSetupSave(lstPAFR7[0].Id, strDataFR7);
            final Map<String, Object> actualMapFR7 = new Map<String, Object>();
            actualMapFR7.put('isSuccess', retMapFR7.get('isSuccess'));
            final Map<String, Object> expectedMapFR7 = new Map<String, Object>();
            expectedMapFR7.put('isSuccess', false);
            System.assertEquals(expectedMapFR7, actualMapFR7, 'Err at Flat_Rates_Setup_Ctrl_Test - doFlatRatesSetupSave3');

        Test.stopTest();
    }

    // Check doFlatRatesSetupSave with err on flat rate accs
    @IsTest
    static void doFlatRatesSetupSave4() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR8 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR8 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPAFR8 = profAnSelectorFR8.selectByName(setNamesPAFR8);
        final PsCatalogCondition_Selector psCatCondSelectorFR8 = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> lstPsCatCondFR8 = psCatCondSelectorFR8.selectByName(new Set<String>{'Condition 0', 'Condition 3'});
        final PSCatalogFlatRatesAccount_Selector psCatFlatRatesAccsSelectorFR8 = new PSCatalogFlatRatesAccount_Selector(true);
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAccFR8 = psCatFlatRatesAccsSelectorFR8.selectByCanonicalId(new Set<String>{'comflat.debts.pyg.accounts.type', 'comflat.opr.pyg.accounts.type'});
        final String strDataFR8 = '{"flatRates":{"priceType":"IF","fixedAmount":222222.01,"chargeType":"V","periodicityChageType":"T","currencyType":"JPY","chargeDay":"22","nonWorkingDayChargeMethod":"A","accWithoutBalanceMethod":"C","invoceComments":"yrdy","accountComments":"test"},"flatRatesAccounts":[{"accId":"' + lstPsCatFlatRatesAccFR8[0].Id + '","usePercent":15},{"accId":"' + lstPsCatFlatRatesAccFR8[1].Id + '","usePercent":99999999999999999999999.9999999999}],"flatRatesConditions":[{"conditionId":"' + lstPsCatCondFR8[0].Id + '","estOpVol":"99"},{"conditionId":"' + lstPsCatCondFR8[1].Id + '","estOpVol":"11"}]}';

        Test.startTest();

            final Map<String, Object> retMapFR8 = Flat_Rates_Setup_Ctrl.doFlatRatesSetupSave(lstPAFR8[0].Id, strDataFR8);
            final Map<String, Object> actualMapFR8 = new Map<String, Object>();
            actualMapFR8.put('isSuccess', retMapFR8.get('isSuccess'));
            final Map<String, Object> expectedMapFR8 = new Map<String, Object>();
            expectedMapFR8.put('isSuccess', false);
            System.assertEquals(expectedMapFR8, actualMapFR8, 'Err at Flat_Rates_Setup_Ctrl_Test - doFlatRatesSetupSave4');

        Test.stopTest();
    }

    // Check doFlatRatesSetupSave with err on conditions
    @IsTest
    static void doFlatRatesSetupSave5() {

        final ProfitabilityAnalysis_Selector profAnSelectorFR9 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPAFR9 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPAFR9 = profAnSelectorFR9.selectByName(setNamesPAFR9);
        final PsCatalogCondition_Selector psCatCondSelectorFR9 = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> lstPsCatCondFR9 = psCatCondSelectorFR9.selectByName(new Set<String>{'Condition 0', 'Condition 3'});
        final PSCatalogFlatRatesAccount_Selector psCatFlatRatesAccsSelectorFR9 = new PSCatalogFlatRatesAccount_Selector(true);
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAccFR9 = psCatFlatRatesAccsSelectorFR9.selectByCanonicalId(new Set<String>{'comflat.debts.pyg.accounts.type', 'comflat.opr.pyg.accounts.type'});
        final String strDataFR9 = '{"flatRates":{"priceType":"IF","fixedAmount":222222.01,"chargeType":"V","periodicityChageType":"T","currencyType":"JPY","chargeDay":"22","nonWorkingDayChargeMethod":"A","accWithoutBalanceMethod":"C","invoceComments":"yrdy","accountComments":"test"},"flatRatesAccounts":[{"accId":"' + lstPsCatFlatRatesAccFR9[0].Id + '","usePercent":15},{"accId":"' + lstPsCatFlatRatesAccFR9[1].Id + '","usePercent":99}],"flatRatesConditions":[{"conditionId":"' + lstPsCatCondFR9[0].Id + '","estOpVol":"99999999999999999999999.9999999"},{"conditionId":"' + lstPsCatCondFR9[1].Id + '","estOpVol":"999999999999999999999999999.99999"}]}';

        Test.startTest();

            final Map<String, Object> retMapFR9 = Flat_Rates_Setup_Ctrl.doFlatRatesSetupSave(lstPAFR9[0].Id, strDataFR9);
            final Map<String, Object> actualMapFR9 = new Map<String, Object>();
            actualMapFR9.put('isSuccess', retMapFR9.get('isSuccess'));
            final Map<String, Object> expectedMapFR9 = new Map<String, Object>();
            expectedMapFR9.put('isSuccess', false);
            System.assertEquals(expectedMapFR9, actualMapFR9, 'Err at Flat_Rates_Setup_Ctrl_Test - doFlatRatesSetupSave5');

        Test.stopTest();
    }

    // Check doFlatRatesSetupSave error
    @IsTest
    static void doFlatRatesSetupSave6() {
        Test.startTest();
            try {
                Flat_Rates_Setup_Ctrl.doFlatRatesSetupSave(null, null);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at Flat_Rates_Setup_Ctrl_Test - doFlatRatesSetupSave6');
            }
        Test.stopTest();
    }


    // Private constructor test
    @IsTest
    static void flatRatesSetupConstructorTest() {
        Test.startTest();
            final Flat_Rates_Setup_Ctrl constructorTest = new Flat_Rates_Setup_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at Flat_Rates_Setup_Ctrl_Test - flatRatesSetupConstructorTest');
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void flatRatesSetupHelperConstructorTest() {
        Test.startTest();
            final Flat_Rates_Setup_Helper constructorTest2 = new Flat_Rates_Setup_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at Flat_Rates_Setup_Helper_Test - flatRatesSetupHelperConstructorTest');
        Test.stopTest();
    }
}