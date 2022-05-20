/**
* ____________________________________________________________________________
* Price Negotiation Integration Helper Test
* Name class: PriceNegotiation_Helper_Test
* ____________________________________________________________________________
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-30
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@IsTest
public class PriceNegotiation_Helper_Test  {

    @TestSetup
    static void makeDataPriceDelegationLevels() {

        // Create a user to run
        final User usuario = Test_Utils.createUser();
        Insert usuario;

        // Create parent acc
        final List<Account> lstCommPkgEditAcc = Test_Utils.createAccounts(1);
        lstCommPkgEditAcc[0].AccountNumber = 'B99999999';
        insert lstCommPkgEditAcc;

        // Create child accs
        final List<Account> lstCommPkgEditChildAcc = Test_Utils.createAccounts(3);
        for (Account acc : lstCommPkgEditChildAcc) {
            acc.ParentId = lstCommPkgEditAcc[0].Id;
        }
        insert lstCommPkgEditChildAcc;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCF = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCF;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCC = Test_Utils.createPSCatalogConditons(4, lstPSCF[0]);
        insert lstPSCC;

        // Create ps catalog attribute
        List<ps_catalog_attribute__c> lstPsCatAttb = Test_Utils.createPSCatalogAttributes(5);
        lstPsCatAttb[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        lstPsCatAttb[1].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        lstPsCatAttb[2].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        lstPsCatAttb[3].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        lstPsCatAttb[4].gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        insert lstPsCatAttb;

        // Create ps catalog condition attributes
        List<ps_catalog_condition_attribute__c> lstPsCatCondAttb = new List<ps_catalog_condition_attribute__c>();
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[0], lstPsCatAttb));
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[1], lstPsCatAttb));
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[2], lstPsCatAttb));
        lstPsCatCondAttb.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[3], lstPsCatAttb));
        for (Integer i=0; i<lstPsCatCondAttb.size(); i++) {
            lstPsCatCondAttb[i].gf_psc_condition_attribute_id__c = 'canonical.uniqueid.' + i;
        }
        insert lstPsCatCondAttb;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPACommEditPkg = Test_Utils.createProfAnalysis(1, lstCommPkgEditAcc[0]);
        for (profitability_analysis__c paCommEditPkg : lstPACommEditPkg) {
            paCommEditPkg.gf_pa_management_type_name__c = 'New';
            paCommEditPkg.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paCommEditPkg.gf_pa_mgmt_status_type_name__c = 'Analysis';
        }

        insert lstPACommEditPkg;

        // Create profitability analysis participant
        Set<Id> lstCommPkgEditChildId = new Set<Id>();
        for (Account acc : lstCommPkgEditChildAcc) {
            lstCommPkgEditChildId.add(acc.Id);
        }
        List<Id> lstId = new List<Id>();
        lstId.addAll(lstCommPkgEditChildId);

        final List<profitability_analysis_participant__c> lstPAPCommEdit = new List<profitability_analysis_participant__c>();
        lstPAPCommEdit.addAll(Test_Utils.createProfAnalysisParticipant(1, lstPACommEditPkg[0].Id, lstId));
        insert lstPAPCommEdit;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPACCommPkg = new List<profitability_analysis_condition__c>();
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[0], lstPSCC[0]));
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[0], lstPSCC[1]));
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[0], lstPSCC[2]));
        lstPACCommPkg.addAll(Test_Utils.createProfAnalysisConditons(1, lstPACommEditPkg[0], lstPSCC[3]));
        lstPACCommPkg[0].gf_pa_cond_atrb_source_type__c = 'COMMERCIAL_PACKAGE';
        lstPACCommPkg[0].gf_pa_source_cust_package_id__c = 'B00000003C0003';

        insert lstPACCommPkg;

        final List<ps_catalog_package__c> lstPackage = new List<ps_catalog_package__c>();
        lstPackage.addAll(Test_Utils.createPSCatalogPackage(1, 'C'));
        lstPackage.addAll(Test_Utils.createPSCatalogPackage(1, 'F'));
        lstPackage.addAll(Test_Utils.createPSCatalogPackage(1, 'G'));
        Insert lstPackage;

        List<client_package__c> lstPackages = Test_Utils.createClientPackage(3, lstCommPkgEditChildAcc, lstPackage);
        Insert lstPackages;

        // Create profitability analysis pkg req
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqCommEditPkg = new List<profitability_analysis_pkg_request__c>();
        lstPAPkgReqCommEditPkg.addAll(Test_Utils.createProfAnPkgReq(1, lstPACommEditPkg[0].Id, 'Extension'));
        lstPAPkgReqCommEditPkg.addAll(Test_Utils.createProfAnPkgReq(1, lstPACommEditPkg[0].Id, 'New'));
        lstPAPkgReqCommEditPkg.addAll(Test_Utils.createProfAnPkgReq(1, lstPACommEditPkg[0].Id, 'Modification'));

        lstPAPkgReqCommEditPkg[0].gf_cust_package_id__c = lstPackages[0].Id;
        lstPAPkgReqCommEditPkg[0].gf_psc_package_id__c = lstPackage[0].Id;
        lstPAPkgReqCommEditPkg[1].gf_cust_package_id__c = lstPackages[1].Id;
        lstPAPkgReqCommEditPkg[1].gf_psc_package_id__c = lstPackage[1].Id;
        lstPAPkgReqCommEditPkg[2].gf_cust_package_id__c = lstPackages[2].Id;
        lstPAPkgReqCommEditPkg[2].gf_psc_package_id__c = lstPackage[2].Id;
        insert lstPAPkgReqCommEditPkg;

        List<profitability_analysis_flat_rates__c> profAnalFlatRate = Test_Utils.createPaFlatRate(new List<Id>{lstPACommEditPkg[0].Id}, 'New');
        Insert profAnalFlatRate;
    }

    @IsTest
    static void priceNegotiationHelperTest1() {

        final User adminUser = [SELECT Id FROM User WHERE UserName = 'testProfi@example.com' LIMIT 1];
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA = paSelector.selectByName(setNamesPA);
        final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA[0].Id);
        Test.startTest();
            System.runAs(adminUser) {
                final PriceNegotiation_Helper pdlHelper = new PriceNegotiation_Helper(paWrapper);
                final HttpResponse response = pdlHelper.callWs('newPriceNegotiation');
                System.assertEquals(response.getStatusCode(), 200, 'Err at PriceNegotiation_Helper_Test - priceNegotiationHelperTest1');
            }
        Test.stopTest();
    }
}