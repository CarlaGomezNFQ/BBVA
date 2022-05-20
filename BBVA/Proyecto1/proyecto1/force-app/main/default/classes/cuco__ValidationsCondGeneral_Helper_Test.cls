/**
* ────────────────────────────────────────────────────────────────────
* ValidationsCondGeneral_Helper_Test
* Test class for ValidationsCondGeneral_Helper apex class
* ────────────────────────────────────────────────────────────────────
* @author      Fco Javier Berenguer <franciscojavier.berenguer.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-24
* @modified
* @systemLayer Test
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ValidationsCondGeneral_Helper_Test {

    @TestSetup
    static void setupValidationsCondGen() {

        // Create ps catalog family
        final List<ps_catalog_family__c> familiesCG = Test_Utils.createPSCatalogFamilies(4);
        familiesCG[0].gf_psc_family_id__c = 'np.nat.transfer';
        familiesCG[1].gf_psc_family_id__c = 'np.check';
        familiesCG[2].gf_psc_family_id__c = 'debit.sepa';
        familiesCG[3].gf_psc_family_id__c = 'cheque.rate';
        insert familiesCG;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> conditionsCG = Test_Utils.createPSCatalogConditons(8, familiesCG[0]);
        conditionsCG[0].gf_psc_family_id__c = familiesCG[0].Id;
        conditionsCG[0].gf_psc_condition_id__c = 'np.transfer.mail.expenses';
        conditionsCG[1].gf_psc_family_id__c = familiesCG[0].Id;
        conditionsCG[1].gf_psc_condition_id__c = 'EEEp.issued.mail';
        conditionsCG[2].gf_psc_family_id__c = familiesCG[1].Id;
        conditionsCG[2].gf_psc_condition_id__c = 'np.bonus';
        conditionsCG[3].gf_psc_family_id__c = familiesCG[1].Id;
        conditionsCG[3].gf_psc_condition_id__c = 'np.exempt.mail';
        conditionsCG[4].gf_psc_family_id__c = familiesCG[2].Id;
        conditionsCG[4].gf_psc_condition_id__c = 'debit.sepa.present';
        conditionsCG[5].gf_psc_family_id__c = familiesCG[2].Id;
        conditionsCG[5].gf_psc_condition_id__c = 'debit.sepa.present.other';
        conditionsCG[6].gf_psc_family_id__c = familiesCG[3].Id;
        conditionsCG[6].gf_psc_condition_id__c = 'cheque.rate99.bonus.type';
        conditionsCG[7].gf_psc_family_id__c = familiesCG[3].Id;
        conditionsCG[7].gf_psc_condition_id__c = 'cheque.rate55.alternate.branch';
        insert conditionsCG;

        // Create ps catalog attribute
        final List<ps_catalog_attribute__c> attributesCG = Test_Utils.createPSCatalogAttributes(10);
        attributesCG[0].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributesCG[0].gf_attribute_value_type_name__c = 'Currency';
        attributesCG[0].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        attributesCG[1].gf_psc_bknd_svc_format_type__c = 'RATE';
        attributesCG[1].gf_attribute_value_type_name__c = 'Permillage';
        attributesCG[1].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        attributesCG[2].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributesCG[2].gf_attribute_value_type_name__c = 'Currency';
        attributesCG[2].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        attributesCG[3].gf_psc_bknd_svc_format_type__c = 'TEXT';
        attributesCG[3].gf_attribute_value_type_name__c = 'Checkbox';
        attributesCG[3].cuco__gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        attributesCG[4].gf_psc_bknd_svc_format_type__c = 'AMOUNT';
        attributesCG[4].gf_attribute_value_type_name__c = 'Currency';
        attributesCG[4].cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_fix_amount__c';
        attributesCG[5].gf_psc_attribute_id__c = 'price';
        attributesCG[6].gf_psc_attribute_id__c = 'rate.type';
        insert attributesCG;

        // Create ps catalog condition attributes
        final List<ps_catalog_condition_attribute__c> conditionAttributesCG = Test_Utils.createPSCatalogConditonAttributes(10, conditionsCG[0], attributesCG);
        conditionAttributesCG[0].gf_psc_condition_attribute_id__c = 'np.transfer.mail.expenses.amount';
        conditionAttributesCG[0].gf_psc_condition_id__c = conditionsCG[0].Id;
        conditionAttributesCG[0].gf_psc_atribute_id__c = attributesCG[0].Id;
        conditionAttributesCG[1].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.type';
        conditionAttributesCG[1].gf_psc_condition_id__c = conditionsCG[2].Id;
        conditionAttributesCG[1].gf_psc_atribute_id__c = attributesCG[1].Id;
        conditionAttributesCG[2].gf_psc_condition_attribute_id__c = 'EEEp.issued.mail.amount';
        conditionAttributesCG[2].gf_psc_condition_id__c = conditionsCG[1].Id;
        conditionAttributesCG[2].gf_psc_atribute_id__c = attributesCG[2].Id;
        conditionAttributesCG[3].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.type';
        conditionAttributesCG[3].gf_psc_condition_id__c = conditionsCG[3].Id;
        conditionAttributesCG[3].gf_psc_atribute_id__c = attributesCG[3].Id;
        conditionAttributesCG[4].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.tf.min';
        conditionAttributesCG[4].gf_psc_condition_id__c = conditionsCG[2].Id;
        conditionAttributesCG[4].gf_psc_atribute_id__c = attributesCG[4].Id;
        conditionAttributesCG[5].gf_psc_condition_attribute_id__c = 'debit.sepa.present.price';
        conditionAttributesCG[5].gf_psc_condition_id__c = conditionsCG[4].Id;
        conditionAttributesCG[5].gf_psc_atribute_id__c = attributesCG[5].Id;
        conditionAttributesCG[6].gf_psc_condition_attribute_id__c = 'debit.sepa.present.other.price';
        conditionAttributesCG[6].gf_psc_condition_id__c = conditionsCG[5].Id;
        conditionAttributesCG[6].gf_psc_atribute_id__c = attributesCG[5].Id;
        conditionAttributesCG[7].gf_psc_condition_attribute_id__c = 'cheque.rate99.bonus.type';
        conditionAttributesCG[7].gf_psc_condition_id__c = conditionsCG[6].Id;
        conditionAttributesCG[7].gf_psc_atribute_id__c = attributesCG[6].Id;
        conditionAttributesCG[8].gf_psc_condition_attribute_id__c = 'cheque.rate55.alternate.branch.type';
        conditionAttributesCG[8].gf_psc_condition_id__c = conditionsCG[7].Id;
        conditionAttributesCG[8].gf_psc_atribute_id__c = attributesCG[6].Id;
        insert conditionAttributesCG;

        // Create ps account
        final List<Account> accountsCG = Test_Utils.createAccounts(2);
        accountsCG[0].Sic = '666';
        accountsCG[0].AccountNumber = '001183970';
        insert accountsCG;

        // Create profitability sheet
        final List<profitability_sheet__c> profSheetsCG = Test_Utils.createProfSheet(3, accountsCG[0]);
        insert profSheetsCG;

        // Create ps participant
        final List<profitability_sheet_participant__c> participantsCG = Test_Utils.createProfSheetParticipant(1, profSheetsCG[0].Id, new List<Id>{accountsCG[0].Id});
        insert participantsCG;

        final List<profitability_sheet_participant__c> participants2CG = Test_Utils.createProfSheetParticipant(1, profSheetsCG[1].Id, new List<Id>{accountsCG[1].Id});
        insert participants2CG;

        // Create ps condition
        final List<profitability_sheet_condition__c> psConditionsCG = Test_Utils.createProfSheetConditons(3, profSheetsCG[0], conditionsCG[0]);
        psConditionsCG[1].gf_ps_cond_atrb_srce_type_name__c = 'COMMERCIAL_PACKAGE';
        psConditionsCG[1].gf_ps_source_cust_package_id__c = '001183970F765';
        psConditionsCG[2].gf_ps_cond_atrb_srce_type_name__c = 'GIP_PACKAGE';
        psConditionsCG[2].gf_ps_source_cust_package_id__c = '001183970G654';
        insert psConditionsCG;

        // Create profitability analysis
        final List<profitability_analysis__c> profAnalysisCG = Test_Utils.createProfAnalysis(1, accountsCG[0]);
        profAnalysisCG[0].gf_pa_management_type_name__c = 'Novation';
        profAnalysisCG[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        profAnalysisCG[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        profAnalysisCG[0].segment_type__c = 'BEC';
        profAnalysisCG[0].gf_all_ct_apply_cond_ind_type__c = false;
        profAnalysisCG[0].gf_pa_forced_mf_mgmt_ind_type__c = false;
        profAnalysisCG[0].gf_profitability_sheet_id__c = profSheetsCG[0].Id;
        insert profAnalysisCG;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> paConditionsCG = Test_Utils.createProfAnalysisConditons(8, profAnalysisCG[0], conditionsCG[0]);
        paConditionsCG[2].gf_psc_condition_id__c = conditionsCG[1].Id;
        paConditionsCG[3].gf_psc_condition_id__c = conditionsCG[2].Id;
        paConditionsCG[4].gf_psc_condition_id__c = conditionsCG[4].Id;
        paConditionsCG[5].gf_psc_condition_id__c = conditionsCG[5].Id;
        paConditionsCG[6].gf_psc_condition_id__c = conditionsCG[6].Id;
        paConditionsCG[7].gf_psc_condition_id__c = conditionsCG[7].Id;
        insert paConditionsCG;

        // Create ps catalog condition standard
        final List<ps_catalog_condition_standard__c> stdConditionsCG = Test_Utils.createPSCatalogConditonsStandard(3);
        stdConditionsCG[0].gf_psc_cond_atrb_std_id__c = conditionAttributesCG[0].gf_psc_condition_attribute_id__c;
        stdConditionsCG[0].gf_psc_condition_attribute_id__c = conditionAttributesCG[0].Id;
        stdConditionsCG[1].gf_psc_cond_atrb_std_id__c = conditionAttributesCG[1].gf_psc_condition_attribute_id__c;
        stdConditionsCG[1].gf_cond_atrb_max_val_name__c = '';
        stdConditionsCG[1].gf_psc_condition_attribute_id__c = conditionAttributesCG[1].Id;
        stdConditionsCG[2].gf_psc_cond_atrb_std_id__c = conditionAttributesCG[2].gf_psc_condition_attribute_id__c;
        stdConditionsCG[2].gf_psc_condition_attribute_id__c = conditionAttributesCG[2].Id;
        stdConditionsCG[2].gf_cond_atrb_min_val_name__c = '';
        insert stdConditionsCG;
    }

    @IsTest
    static void getConditionsPerFamilyTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId1 = profAnSelector1.selectByName(setNamesPA1)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper1 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId1);
        Test.startTest();
            final Map<String,Map<String,Map<String,String>>> retMap1 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper1);
            System.assertEquals(4, retMap1.size(), 'Err at ValidationsCondGeneral_Helper_Test - getConditionsPerFamilyTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkValuesRangeTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId2 = profAnSelector2.selectByName(setNamesPA2)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper2 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId2);
        Test.startTest();
            final List<String> retList2 = ValidationsCondGeneral_Helper.checkValuesRange(paWrapper2);
            System.assertEquals(0, retList2.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkValuesRangeTest1');
        Test.stopTest();
    }
    @IsTest
    static void checkValuesRangeTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId3 = profAnSelector3.selectByName(setNamesPA3)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper3 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId3);
        paWrapper3.conditionsList[0].attributesList[0].value = '1001';
        paWrapper3.conditionsList[2].attributesList[0].value = '1001';
        paWrapper3.conditionsList[3].attributesList[0].value = '0.99';
        Test.startTest();
            final List<String> retList3 = ValidationsCondGeneral_Helper.checkValuesRange(paWrapper3);
            System.assertEquals(3, retList3.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkValuesRangeTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkMailExpensesTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId4 = profAnSelector4.selectByName(setNamesPA4)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper4 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId4);
        paWrapper4.conditionsList[0].attributesList[0].value = '0.99';
        Test.startTest();
            final List<String> retList4 = ValidationsCondGeneral_Helper.checkMailExpenses(paWrapper4);
            System.assertEquals(1, retList4.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkMailExpensesTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkMailExpensesTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId5 = profAnSelector5.selectByName(setNamesPA5)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper5 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId5);
        paWrapper5.conditionsList[0].attributesList[0].value = '0.99';
        paWrapper5.conditionsList[0].source = 'FORFAIT';
        Test.startTest();
            final List<String> retList5 = ValidationsCondGeneral_Helper.checkMailExpenses(paWrapper5);
            System.assertEquals(1, retList5.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkMailExpensesTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkMailExpensesTest3() {
        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId6 = profAnSelector6.selectByName(setNamesPA6)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper6 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId6);
        paWrapper6.conditionsList[2].attributesList[0].value = '0.99';
        paWrapper6.conditionsList[2].source = 'FORFAIT';
        Test.startTest();
            final List<String> retList6 = ValidationsCondGeneral_Helper.checkMailExpenses(paWrapper6);
            System.assertEquals(1, retList6.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkMailExpensesTest3');
        Test.stopTest();
    }

    @IsTest
    static void checkNPTransCondTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector7 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA7 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId7 = profAnSelector7.selectByName(setNamesPA7)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper7 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId7);
        final Map<String,Map<String,Map<String,String>>> condPerFamily7 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper7);
        condPerFamily7.get('np.nat.transfer').remove('EEEp.issued.mail');
        Test.startTest();
            final List<String> retList7 = ValidationsCondGeneral_Helper.checkNPTransCond(condPerFamily7);
            System.assertEquals(1, retList7.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkNPTransCondTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkNPCheckCondTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector8 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA8 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId8 = profAnSelector8.selectByName(setNamesPA8)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper8 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId8);
        final Map<String,Map<String,Map<String,String>>> condPerFamily8 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper8);
        Test.startTest();
            final List<String> retList8 = ValidationsCondGeneral_Helper.checkNPCheckCond(condPerFamily8);
            System.assertEquals(1, retList8.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkNPCheckCondTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkNPCheckCondTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector9 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA9 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId9 = profAnSelector9.selectByName(setNamesPA9)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper9 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId9);
        paWrapper9.conditionsList[3].canonicalId = 'np.exempt.mail';
        final Map<String,Map<String,Map<String,String>>> condPerFamily9 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper9);
        Test.startTest();
            final List<String> retList9 = ValidationsCondGeneral_Helper.checkNPCheckCond(condPerFamily9);
            System.assertEquals(1, retList9.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkNPCheckCondTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkSEPAPriceClassTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector10 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA10 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId10 = profAnSelector10.selectByName(setNamesPA10)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper10 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId10);
        final Map<String,Map<String,Map<String,String>>> condPerFamily10 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper10);
        condPerFamily10.get('debit.sepa').get('debit.sepa.present').put('price', '1.02');
        Test.startTest();
            final List<String> retList10 = ValidationsCondGeneral_Helper.checkSEPAPriceClass(condPerFamily10);
            System.assertEquals(1, retList10.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkSEPAPriceClassTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkRate55CondTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector11 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA11 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId11 = profAnSelector11.selectByName(setNamesPA11)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper11 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId11);
        final Map<String,Map<String,Map<String,String>>> condPerFamily11 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper11);
        condPerFamily11.get('cheque.rate').get('cheque.rate99.bonus.type').put('rate.type', '55');
        Test.startTest();
            final List<String> retList11 = ValidationsCondGeneral_Helper.checkRate55Cond(condPerFamily11);
            System.assertEquals(0, retList11.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkRate55CondTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkRate55CondTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector12 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA12 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId12 = profAnSelector12.selectByName(setNamesPA12)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper12 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId12);
        final Map<String,Map<String,Map<String,String>>> condPerFamily12 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper12);
        condPerFamily12.get('cheque.rate').get('cheque.rate99.bonus.type').put('rate.type', '55');
        condPerFamily12.get('cheque.rate').remove('cheque.rate55.alternate.branch');
        Test.startTest();
            final List<String> retList12 = ValidationsCondGeneral_Helper.checkRate55Cond(condPerFamily12);
            System.assertEquals(1, retList12.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkRate55CondTest2');
        Test.stopTest();
    }

    @IsTest
    static void checkRateTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector13 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA13 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId13 = profAnSelector13.selectByName(setNamesPA13)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper13 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId13);
        final Map<String,Map<String,Map<String,String>>> condPerFamily13 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper13);
        Test.startTest();
            final List<String> retList13 = ValidationsCondGeneral_Helper.checkRate(condPerFamily13);
            System.assertEquals(1, retList13.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkRateTest1');
        Test.stopTest();
    }

    @IsTest
    static void checkSepaPairsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector14 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA14 = new Set<String>{'Prof Analysis Test 0'};
        final Id profAnalysisId14 = profAnSelector14.selectByName(setNamesPA14)[0].Id;
        final ProfitabilityAnalysis_Wrapper paWrapper14 = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId14);
        final Map<String,Map<String,Map<String,String>>> condPerFamily14 = ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper14);
        Test.startTest();
            final List<String> retList14 = ValidationsCondGeneral_Helper.checkSEPAPairs(condPerFamily14);
            System.assertEquals(0, retList14.size(), 'Err at ValidationsCondGeneral_Helper_Test - checkSepaPairsTest1');
        Test.stopTest();
    }

    @IsTest
    static void validationsCondGeneralConstructorTest() {
        Test.startTest();
            final ValidationsCondGeneral_Helper constructorTest = new ValidationsCondGeneral_Helper();
            System.assertEquals(constructorTest, constructorTest, 'Error at ValidationsCondGeneral_Helper_Test - validationsPackagesConstructorTest');
        Test.stopTest();
    }
}