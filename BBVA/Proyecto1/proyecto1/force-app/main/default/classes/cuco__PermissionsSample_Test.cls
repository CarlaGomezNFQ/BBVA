/**
* ────────────────────────────────────────────────────────────────────
* PermissionsSample_Test
* Test class for PermissionsSample apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-16
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class PermissionsSample_Test {

    /** @description RENEWAL */
    static final String RENEWAL = Label.renewal;

    @TestSetup
    static void makeDataPermissionsSample() {

        final User newUser = Test_Utils.createUser();
        insert newUser;

        final List<Account> lstGroupAccount = Test_Utils.createAccounts(2);
        insert lstGroupAccount;

        final List<Account> lstChildAccs = Test_Utils.createAccounts(2);
        lstChildAccs[0].ParentId = lstGroupAccount[0].Id;
        lstChildAccs[0].Name = 'Account Test Child 0';
        lstChildAccs[1].ParentId = lstGroupAccount[1].Id;
        lstChildAccs[1].Name = 'Account Test Child 1';
        lstChildAccs[1].OwnerId = newUser.Id;
        insert lstChildAccs;

        final List<profitability_sheet__c> lstPS = Test_Utils.createProfSheet(2, lstGroupAccount);
        insert lstPS;

        final List<profitability_analysis__c> lstPA = Test_Utils.createProfAnalysis(2, lstGroupAccount);
        lstPA[0].gf_pa_management_type_name__c = 'New';
        lstPA[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPA[0].gf_profitability_sheet_id__c = lstPS[0].Id;
        lstPA[1].gf_pa_management_type_name__c = 'Cancellation';
        lstPA[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPA[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPA[1].gf_profitability_sheet_id__c = lstPS[1].Id;
        insert lstPA;

        final List<profitability_sheet_participant__c> lstPSP = Test_Utils.createProfSheetParticipant(1, lstPS[0].Id, new List<Id>{lstChildAccs[0].Id});
        insert lstPSP;
    }

    // Test method to check can manage methods with positive result of Permissions Sample
    @IsTest
    static void canManageMethodsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();
            final PermissionsSample pManageSample1 = new PermissionsSample();

            final Map<String, Object> retMapManageCond = pManageSample1.canManageConditions(lstPA1[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManagePart = pManageSample1.canManageParticipants(lstPA1[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManagePkg = pManageSample1.canManagePackages(lstPA1[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManageFR = pManageSample1.canManageFlatRates(lstPA1[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManageAnalysis = pManageSample1.canManageAnalysis(lstPA1[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap1 = new Map<String, Object>();
            actualMap1.put('manageCondAdd', retMapManageCond.get('add'));
            actualMap1.put('manageCondEdit', retMapManageCond.get('edit'));
            actualMap1.put('manageCondRemove', retMapManageCond.get('remove'));
            actualMap1.put('managePartAdd', retMapManagePart.get('add'));
            actualMap1.put('managePartRemove', retMapManagePart.get('remove'));
            actualMap1.put('managePkgAdd', retMapManagePkg.get('add'));
            actualMap1.put('managePkgEdit', retMapManagePkg.get('edit'));
            actualMap1.put('managePkgCancel', retMapManagePkg.get('cancel'));
            actualMap1.put('manageFlatRatesSetup', retMapManageFR.get('setup'));
            actualMap1.put('manageFlatRatesRemove', retMapManageFR.get('remove'));
            actualMap1.put('manageAnalysis', retMapManageAnalysis.get('manage'));

            final Map<String, Object> expectedMap1 = new Map<String, Object>();
            expectedMap1.put('manageCondAdd', true);
            expectedMap1.put('manageCondEdit', true);
            expectedMap1.put('manageCondRemove', true);
            expectedMap1.put('managePartAdd', true);
            expectedMap1.put('managePartRemove', true);
            expectedMap1.put('managePkgAdd', true);
            expectedMap1.put('managePkgEdit', true);
            expectedMap1.put('managePkgCancel', true);
            expectedMap1.put('manageFlatRatesSetup', true);
            expectedMap1.put('manageFlatRatesRemove', true);
            expectedMap1.put('manageAnalysis', true);

            System.assertEquals(expectedMap1, actualMap1, 'Err at PermissionsSample_Test - canManageMethodsTest1');
        Test.stopTest();
    }

    // Test method to check can manage methods with negative result of Permissions Sample
    @IsTest
    static void canManageMethodsTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        Test.startTest();
            final PermissionsSample pManageSample2 = new PermissionsSample();

            final Map<String, Object> retMapManageCond = pManageSample2.canManageConditions(lstPA2[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManagePart = pManageSample2.canManageParticipants(lstPA2[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManagePkg = pManageSample2.canManagePackages(lstPA2[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManageFR = pManageSample2.canManageFlatRates(lstPA2[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapManageAnalysis = pManageSample2.canManageAnalysis(lstPA2[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap2 = new Map<String, Object>();
            actualMap2.put('manageCondAdd', retMapManageCond.get('add'));
            actualMap2.put('manageCondEdit', retMapManageCond.get('edit'));
            actualMap2.put('manageCondRemove', retMapManageCond.get('remove'));
            actualMap2.put('managePartAdd', retMapManagePart.get('add'));
            actualMap2.put('managePartRemove', retMapManagePart.get('remove'));
            actualMap2.put('managePkgAdd', retMapManagePkg.get('add'));
            actualMap2.put('managePkgEdit', retMapManagePkg.get('edit'));
            actualMap2.put('managePkgCancel', retMapManagePkg.get('cancel'));
            actualMap2.put('manageFlatRatesSetup', retMapManageFR.get('setup'));
            actualMap2.put('manageFlatRatesRemove', retMapManageFR.get('remove'));
            actualMap2.put('manageAnalysis', retMapManageAnalysis.get('manage'));
            actualMap2.put('manageAnalysisMsg', retMapManageAnalysis.get('manageMessage'));

            final Map<String, Object> expectedMap2 = new Map<String, Object>();
            expectedMap2.put('manageCondAdd', false);
            expectedMap2.put('manageCondEdit', false);
            expectedMap2.put('manageCondRemove', false);
            expectedMap2.put('managePartAdd', false);
            expectedMap2.put('managePartRemove', false);
            expectedMap2.put('managePkgAdd', false);
            expectedMap2.put('managePkgEdit', false);
            expectedMap2.put('managePkgCancel', false);
            expectedMap2.put('manageFlatRatesSetup', false);
            expectedMap2.put('manageFlatRatesRemove', false);
            expectedMap2.put('manageAnalysis', false);
            expectedMap2.put('manageAnalysisMsg', Label.manage_analysis_perm_error_sample);

            System.assertEquals(expectedMap2, actualMap2, 'Err at PermissionsSample_Test - canManageMethodsTest2');
        Test.stopTest();
    }

    // Test method to check can add methods with positive result of Permissions Sample
    @IsTest
    static void canAddMethodsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector3 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA3 = profAnSelector3.selectByName(setNamesPA3);

        Test.startTest();
            final PermissionsSample pManageSample3 = new PermissionsSample();

            final Map<String, Object> retMapAddCond = pManageSample3.canAddConditions(lstPA3[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapAddPart = pManageSample3.canAddParticipants(lstPA3[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapAddPkg = pManageSample3.canAddPackage(lstPA3[0].Id, UserInfo.getUserId(), null);

            final Map<String, Object> actualMap3 = new Map<String, Object>();
            actualMap3.put('condAdd', retMapAddCond.get('add'));
            actualMap3.put('partAdd', retMapAddPart.get('add'));
            actualMap3.put('pkgAdd', retMapAddPkg.get('add'));

            final Map<String, Object> expectedMap3 = new Map<String, Object>();
            expectedMap3.put('condAdd', true);
            expectedMap3.put('partAdd', true);
            expectedMap3.put('pkgAdd', true);

            System.assertEquals(expectedMap3, actualMap3, 'Err at PermissionsSample_Test - canAddMethodsTest1');
        Test.stopTest();
    }

    // Test method to check can add methods with negative result of Permissions Sample
    @IsTest
    static void canAddMethodsTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector4 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA4 = profAnSelector4.selectByName(setNamesPA4);

        Test.startTest();
            final PermissionsSample pManageSample4 = new PermissionsSample();

            final Map<String, Object> retMapAddCond = pManageSample4.canAddConditions(lstPA4[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapAddPart = pManageSample4.canAddParticipants(lstPA4[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapAddPkg = pManageSample4.canAddPackage(lstPA4[0].Id, UserInfo.getUserId(), null);

            final Map<String, Object> actualMap4 = new Map<String, Object>();
            actualMap4.put('condAdd', retMapAddCond.get('add'));
            actualMap4.put('condAddMsg', retMapAddCond.get('addMessage'));
            actualMap4.put('partAdd', retMapAddPart.get('add'));
            actualMap4.put('partAddMsg', retMapAddPart.get('addMessage'));
            actualMap4.put('pkgAdd', retMapAddPkg.get('add'));
            actualMap4.put('pkgAddMsg', retMapAddPkg.get('addMessage'));

            final Map<String, Object> expectedMap4 = new Map<String, Object>();
            expectedMap4.put('condAdd', false);
            expectedMap4.put('condAddMsg', Label.add_cond_perm_error_sample);
            expectedMap4.put('partAdd', false);
            expectedMap4.put('partAddMsg', Label.add_subs_perm_error_sample);
            expectedMap4.put('pkgAdd', false);
            expectedMap4.put('pkgAddMsg', Label.pkg_add_perm_error_sample);

            System.assertEquals(expectedMap4, actualMap4, 'Err at PermissionsSample_Test - canAddMethodsTest2');
        Test.stopTest();
    }

    // Test method to check can edit methods with positive result of Permissions Sample
    @IsTest
    static void canEditMethodsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector5 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA5 = profAnSelector5.selectByName(setNamesPA5);

        Test.startTest();
            final PermissionsSample pManageSample5 = new PermissionsSample();

            final Map<String, Object> retMapEditCond = pManageSample5.canEditConditions(lstPA5[0].Id, UserInfo.getUserId(), null);
            final Map<String, Object> retMapEditPkg = pManageSample5.canEditPackage(lstPA5[0].Id, UserInfo.getUserId(), null);

            final Map<String, Object> actualMap5 = new Map<String, Object>();
            actualMap5.put('condEdit', retMapEditCond.get('edit'));
            actualMap5.put('pkgEdit', retMapEditPkg.get('edit'));

            final Map<String, Object> expectedMap5 = new Map<String, Object>();
            expectedMap5.put('condEdit', true);
            expectedMap5.put('pkgEdit', true);

            System.assertEquals(expectedMap5, actualMap5, 'Err at PermissionsSample_Test - canEditMethodsTest1');
        Test.stopTest();
    }

    // Test method to check can edit methods with negative result of Permissions Sample
    @IsTest
    static void canEditMethodsTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector6 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA6 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA6 = profAnSelector6.selectByName(setNamesPA6);

        Test.startTest();
            final PermissionsSample pManageSample6 = new PermissionsSample();

            final Map<String, Object> retMapEditCond = pManageSample6.canEditConditions(lstPA6[0].Id, UserInfo.getUserId(), null);
            final Map<String, Object> retMapEditPkg = pManageSample6.canEditPackage(lstPA6[0].Id, UserInfo.getUserId(), null);

            final Map<String, Object> actualMap6 = new Map<String, Object>();
            actualMap6.put('condEdit', retMapEditCond.get('edit'));
            actualMap6.put('condEditMsg', retMapEditCond.get('editMessage'));
            actualMap6.put('pkgEdit', retMapEditPkg.get('edit'));
            actualMap6.put('pkgEditMsg', retMapEditPkg.get('editMessage'));

            final Map<String, Object> expectedMap6 = new Map<String, Object>();
            expectedMap6.put('condEdit', false);
            expectedMap6.put('condEditMsg', Label.edit_cond_perm_error_sample);
            expectedMap6.put('pkgEdit', false);
            expectedMap6.put('pkgEditMsg', Label.pkg_edit_perm_error_sample);

            System.assertEquals(expectedMap6, actualMap6, 'Err at PermissionsSample_Test - canEditMethodsTest2');
        Test.stopTest();
    }

    // Test method to check can remove methods with positive result of Permissions Sample
    @IsTest
    static void canRemoveMethodsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector7 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA7 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA7 = profAnSelector7.selectByName(setNamesPA7);

        Test.startTest();
            final PermissionsSample pManageSample7 = new PermissionsSample();

            final Map<String, Object> retMapRemoveCond = pManageSample7.canRemoveCondition(lstPA7[0].Id, UserInfo.getUserId(), null);
            final Map<String, Object> retMapRemovePart = pManageSample7.canRemoveParticipant(lstPA7[0].Id, UserInfo.getUserId(), null);
            final Map<String, Object> retMapRemoveFR = pManageSample7.canRemoveFlatRates(lstPA7[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap7 = new Map<String, Object>();
            actualMap7.put('condRemove', retMapRemoveCond.get('remove'));
            actualMap7.put('partRemove', retMapRemovePart.get('remove'));
            actualMap7.put('removeFR', retMapRemoveFR.get('remove'));

            final Map<String, Object> expectedMap7 = new Map<String, Object>();
            expectedMap7.put('condRemove', true);
            expectedMap7.put('partRemove', true);
            expectedMap7.put('removeFR', true);

            System.assertEquals(expectedMap7, actualMap7, 'Err at PermissionsSample_Test - canRemoveMethodsTest1');
        Test.stopTest();
    }

    // Test method to check can remove methods with negative result of Permissions Sample
    @IsTest
    static void canRemoveMethodsTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector8 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA8 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA8 = profAnSelector8.selectByName(setNamesPA8);

        Test.startTest();
            final PermissionsSample pManageSample8 = new PermissionsSample();

            final Map<String, Object> retMapRemoveCond = pManageSample8.canRemoveCondition(lstPA8[0].Id, UserInfo.getUserId(), null);
            final Map<String, Object> retMapRemovePart = pManageSample8.canRemoveParticipant(lstPA8[0].Id, UserInfo.getUserId(), null);
            final Map<String, Object> retMapRemoveFR = pManageSample8.canRemoveFlatRates(lstPA8[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap8 = new Map<String, Object>();
            actualMap8.put('condRemove', retMapRemoveCond.get('remove'));
            actualMap8.put('condRemoveMsg', retMapRemoveCond.get('removeMessage'));
            actualMap8.put('partRemove', retMapRemovePart.get('remove'));
            actualMap8.put('partRemoveMsg', retMapRemovePart.get('removeMessage'));
            actualMap8.put('removeFR', retMapRemoveFR.get('remove'));
            actualMap8.put('removeFRMsg', retMapRemoveFR.get('removeMessage'));

            final Map<String, Object> expectedMap8 = new Map<String, Object>();
            expectedMap8.put('condRemove', false);
            expectedMap8.put('condRemoveMsg', Label.remove_cond_perm_error_sample);
            expectedMap8.put('partRemove', false);
            expectedMap8.put('partRemoveMsg', Label.remove_subs_perm_error_sample);
            expectedMap8.put('removeFR', false);
            expectedMap8.put('removeFRMsg', Label.remove_fr_perm_error_sample);

            System.assertEquals(expectedMap8, actualMap8, 'Err at PermissionsSample_Test - canRemoveMethodsTest2');
        Test.stopTest();
    }

    // Test method to check can cancel methods with positive result of Permissions Sample
    @IsTest
    static void canCancelMethodsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector9 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA9 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA9 = profAnSelector9.selectByName(setNamesPA9);

        Test.startTest();
            final PermissionsSample pManageSample9 = new PermissionsSample();
            final Map<String, Object> retMapCancelPkg = pManageSample9.canCancelPackage(lstPA9[0].Id, UserInfo.getUserId(), null);

            final Map<String, Object> actualMap9 = new Map<String, Object>();
            actualMap9.put('pkgCancel', retMapCancelPkg.get('cancel'));

            final Map<String, Object> expectedMap9 = new Map<String, Object>();
            expectedMap9.put('pkgCancel', true);

            System.assertEquals(expectedMap9, actualMap9, 'Err at PermissionsSample_Test - canCancelMethodsTest1');
        Test.stopTest();
    }

    // Test method to check can cancel methods with negative result of Permissions Sample
    @IsTest
    static void canCancelMethodsTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector10 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA10 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA10 = profAnSelector10.selectByName(setNamesPA10);

        Test.startTest();
            final PermissionsSample pManageSample10 = new PermissionsSample();
            final Map<String, Object> retMapCancelPkg = pManageSample10.canCancelPackage(lstPA10[0].Id, UserInfo.getUserId(), null);

            final Map<String, Object> actualMap10 = new Map<String, Object>();
            actualMap10.put('pkgCancel', retMapCancelPkg.get('cancel'));
            actualMap10.put('pkgCancelMsg', retMapCancelPkg.get('cancelMessage'));

            final Map<String, Object> expectedMap10 = new Map<String, Object>();
            expectedMap10.put('pkgCancel', false);
            expectedMap10.put('pkgCancelMsg', Label.pkg_cancel_perm_error_sample);

            System.assertEquals(expectedMap10, actualMap10, 'Err at PermissionsSample_Test - canCancelMethodsTest2');
        Test.stopTest();
    }

    // Test method to check can create new PA methods with positive result of Permissions Sample
    @IsTest
    static void canCreateNewPATest1() {
        final List<Account> lstAccParent11 = [SELECT Id FROM Account WHERE Name = 'Account Test 0' LIMIT 1];
        final List<Account> lstAccChild11 = [SELECT Id FROM Account WHERE Name = 'Account Test Child 0' LIMIT 1];

        Test.startTest();
            final PermissionsSample pManageSample11 = new PermissionsSample();
            final Map<String, Object> retMapCreateNewPAParent = pManageSample11.canCreateNewPA(lstAccParent11[0].Id, UserInfo.getUserId());
            final Map<String, Object> retMapCreateNewPAChild = pManageSample11.canCreateNewPA(lstAccChild11[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap11 = new Map<String, Object>();
            actualMap11.put('createNewPAParent', retMapCreateNewPAParent.get('create'));
            actualMap11.put('createNewPAChild', retMapCreateNewPAChild.get('create'));

            final Map<String, Object> expectedMap11 = new Map<String, Object>();
            expectedMap11.put('createNewPAParent', true);
            expectedMap11.put('createNewPAChild', true);

            System.assertEquals(expectedMap11, actualMap11, 'Err at PermissionsSample_Test - canCreateNewPATest1');
        Test.stopTest();
    }

    // Test method to check can create new PA methods with negative result of Permissions Sample
    @IsTest
    static void canCreateNewPATest2() {
        final List<Account> lstAccChild12 = [SELECT Id FROM Account WHERE Name = 'Account Test Child 1' LIMIT 1];

        Test.startTest();
            final PermissionsSample pManageSample12 = new PermissionsSample();
            final Map<String, Object> retMapCreateNewPAChild = pManageSample12.canCreateNewPA(lstAccChild12[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap12 = new Map<String, Object>();
            actualMap12.put('createNewPAChild', retMapCreateNewPAChild.get('create'));
            actualMap12.put('createNewPAChildMsg', retMapCreateNewPAChild.get('createMessage'));

            final Map<String, Object> expectedMap12 = new Map<String, Object>();
            expectedMap12.put('createNewPAChild', false);
            expectedMap12.put('createNewPAChildMsg', Label.creation_perm_error_sample);

            System.assertEquals(expectedMap12, actualMap12, 'Err at PermissionsSample_Test - canCreateNewPATest2');
        Test.stopTest();
    }

    // Test method to check canCreateRequestPA method with of Permissions Sample
    @IsTest
    static void canCreateRequestPATest() {
        final Set<String> setNamePf = new Set<String>{'Prof Sheet Test 0'};
        final ProfitabilitySheet_Selector psSelector = new ProfitabilitySheet_Selector(false);
        final List<profitability_sheet__c> lstProfSheet1 = psSelector.selectByName(setNamePf);
        final Map<String,Object> mapPfInfo = ProfitabilitySheet_Service.getProfSheetFullDetails(lstProfSheet1[0].Id);
        final ProfitabilitySheet_Wrapper wrapper = (ProfitabilitySheet_Wrapper) mapPfInfo.get('profSheetDetails');

        Test.startTest();
            final PermissionsSample pManageSample13 = new PermissionsSample();
            final Map<String, Object> retMapCrPA = pManageSample13.canCreateRequestPA(wrapper, UserInfo.getUserId(),RENEWAL);

            final Map<String, Object> actualMap13 = new Map<String, Object>();
            actualMap13.put('canCreate', retMapCrPA.get('canCreate'));
            actualMap13.put('message', retMapCrPA.get('message'));

            final Map<String, Object> expectedMap13 = new Map<String, Object>();
            expectedMap13.put('canCreate', true);
            expectedMap13.put('message', null);

            System.assertEquals(expectedMap13, actualMap13, 'Err at PermissionsSample_Test - canCreateRequestPATest');
        Test.stopTest();
    }

    // Test method to check can setup methods with positive result of Permissions Sample
    @IsTest
    static void canSetupMethodsTest1() {
        final ProfitabilityAnalysis_Selector profAnSelector14 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA14 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA14 = profAnSelector14.selectByName(setNamesPA14);

        Test.startTest();
            final PermissionsSample pManageSample14 = new PermissionsSample();
            final Map<String, Object> retMapSetupFR = pManageSample14.canSetupFlatRates(lstPA14[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap14 = new Map<String, Object>();
            actualMap14.put('setupFR', retMapSetupFR.get('setup'));

            final Map<String, Object> expectedMap14 = new Map<String, Object>();
            expectedMap14.put('setupFR', true);

            System.assertEquals(expectedMap14, actualMap14, 'Err at PermissionsSample_Test - canSetupMethodsTest1');
        Test.stopTest();
    }

    // Test method to check can setup methods with negative result of Permissions Sample
    @IsTest
    static void canSetupMethodsTest2() {
        final ProfitabilityAnalysis_Selector profAnSelector15 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA15 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA15 = profAnSelector15.selectByName(setNamesPA15);

        Test.startTest();
            final PermissionsSample pManageSample15 = new PermissionsSample();
            final Map<String, Object> retMapSetupFR = pManageSample15.canSetupFlatRates(lstPA15[0].Id, UserInfo.getUserId());

            final Map<String, Object> actualMap15 = new Map<String, Object>();
            actualMap15.put('setupFR', retMapSetupFR.get('setup'));
            actualMap15.put('setupFRMsg', retMapSetupFR.get('setupMessage'));

            final Map<String, Object> expectedMap15 = new Map<String, Object>();
            expectedMap15.put('setupFR', false);
            expectedMap15.put('setupFRMsg', Label.setup_fr_perm_error_sample);

            System.assertEquals(expectedMap15, actualMap15, 'Err at PermissionsSample_Test - canSetupMethodsTest2');
        Test.stopTest();
    }

    // Private Permissions_Service constructor test
    @IsTest
    static void permissionsServiceConstructorTest1() {
        Test.startTest();
            final Permissions_Service constructorTest = new Permissions_Service();
            System.assertEquals(constructorTest, constructorTest, 'Err at PermissionsSample_Test - permissionsServiceConstructorTest1');
        Test.stopTest();
    }

    // Private Permissions_Helper constructor test
    @IsTest
    static void permissionsServiceConstructorTest2() {
        Test.startTest();
            final Permissions_Helper constructorTest2 = new Permissions_Helper();
            System.assertEquals(constructorTest2, constructorTest2, 'Err at PermissionsSample_Test - permissionsServiceConstructorTest2');
        Test.stopTest();
    }
}