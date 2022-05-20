/**
* ────────────────────────────────────────────────────────────────────
* RequestPicasso_Helper_Test
* Test class for RequestPicasso_Helper apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-06-01
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:NcssMethodCount, sf:ExcessiveMethodLength')
@IsTest
public class RequestPicasso_Helper_Test {

    @TestSetup
    static void makeDataSendPicassoRequestHelper(){

        // Create parent acc
        final List<Account> lstPicassoAcc = Test_Utils.createAccounts(1);
        lstPicassoAcc[0].AccountNumber = 'B99999999';
        insert lstPicassoAcc;

        // Create child accs
        final List<Account> lstPicassoChildAcc = Test_Utils.createAccounts(12);
        for (Account acc : lstPicassoChildAcc) {
            acc.ParentId = lstPicassoAcc[0].Id;
        }
        insert lstPicassoChildAcc;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCF = Test_Utils.createPSCatalogFamilies(1);
        insert lstPSCF;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCC = Test_Utils.createPSCatalogConditons(5, lstPSCF[0]);
        insert lstPSCC;

        // Create ps catalog attribute
        final List<ps_catalog_attribute__c> lstPsCatAttbPicasso = Test_Utils.createPSCatalogAttributes(5);
        lstPsCatAttbPicasso[0].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_pmg_number__c';
        lstPsCatAttbPicasso[1].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_min_amount__c';
        lstPsCatAttbPicasso[2].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_max_amount__c';
        lstPsCatAttbPicasso[3].gf_stored_prps_atrb_field_name__c = 'gf_pa_cond_prps_prc_type_name__c';
        lstPsCatAttbPicasso[4].gf_stored_prps_atrb_field_name__c = 'gf_prps_pmail_exe_ind_type__c';
        insert lstPsCatAttbPicasso;

        // Create ps catalog condition attributes
        final List<ps_catalog_condition_attribute__c> lstPsCatCondAttbPicasso = new List<ps_catalog_condition_attribute__c>();
        lstPsCatCondAttbPicasso.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[0], lstPsCatAttbPicasso));
        lstPsCatCondAttbPicasso.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[1], lstPsCatAttbPicasso));
        lstPsCatCondAttbPicasso.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[2], lstPsCatAttbPicasso));
        lstPsCatCondAttbPicasso.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[3], lstPsCatAttbPicasso));
        lstPsCatCondAttbPicasso.addAll(Test_Utils.createPSCatalogConditonAttributes(5, lstPSCC[4], lstPsCatAttbPicasso));
        for (Integer i=0; i<lstPsCatCondAttbPicasso.size(); i++) {
            lstPsCatCondAttbPicasso[i].gf_psc_condition_attribute_id__c = 'canonical.uniqueid.' + i;
            switch on Math.mod(i, 5) {
                when  0 {
                    lstPsCatCondAttbPicasso[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 1 {
                    lstPsCatCondAttbPicasso[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 2 {
                    lstPsCatCondAttbPicasso[i].gf_psc_ca_exemption_name__c = '1.0';
                }
                when 3 {
                    lstPsCatCondAttbPicasso[i].gf_psc_ca_exemption_name__c = 'IF';
                }
                when 4 {
                    lstPsCatCondAttbPicasso[i].gf_psc_ca_exemption_name__c = 'true';
                }
            }
        }
        insert lstPsCatCondAttbPicasso;

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgPicasso = new List<ps_catalog_package__c>();
        lstPSCatPkgPicasso.addAll(Test_Utils.createPSCatalogPackage(10, 'F'));
        lstPSCatPkgPicasso.addAll(Test_Utils.createPSCatalogPackage(10, 'C'));
        lstPSCatPkgPicasso.addAll(Test_Utils.createPSCatalogPackage(10, 'G'));
        lstPSCatPkgPicasso[0].gf_psc_pkg_geo_scope_type_name__c = 'All';
        lstPSCatPkgPicasso[10].gf_psc_pkg_geo_scope_type_name__c = 'All';
        lstPSCatPkgPicasso[20].gf_psc_pkg_geo_scope_type_name__c = 'All';
        insert lstPSCatPkgPicasso;

        // Create ps catalog pkg condition
        final List<ps_catalog_pkg_condition__c> lstPSCatPkgCondPicasso = new List<ps_catalog_pkg_condition__c>();
        lstPSCatPkgCondPicasso.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgPicasso[0], lstPSCC));
        lstPSCatPkgCondPicasso.addAll(Test_Utils.createPSCatalogPkgCondition(4, lstPSCatPkgPicasso[1], lstPSCC));
        insert lstPSCatPkgCondPicasso;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSPicasso = Test_Utils.createProfSheet(1, lstPicassoAcc[0]);
        lstPSPicasso[0].gf_prftbly_sheet_end_date__c = Date.valueOf('2021-01-01');
        insert lstPSPicasso;

        // Create ps_catalog_attributes
        List<ps_catalog_attribute__c> lstPsCatAttb = Test_Utils.createPSCatalogAttributesFlat();
        insert lstPsCatAttb;

        // Create ps_catalog_flat_rates_attribute__c
        List<ps_catalog_flat_rates_attribute__c> lstPsCatFlatRatesAttb = Test_Utils.createPSCatalogFlatRatesAttributes(lstPsCatAttb);
        insert lstPsCatFlatRatesAttb;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPAPicasso = Test_Utils.createProfAnalysis(4, lstPicassoAcc[0]);
        for (profitability_analysis__c paPicasso : lstPAPicasso) {
            paPicasso.gf_pa_mgmt_stage_type_name__c = 'Analysis';
            paPicasso.gf_pa_mgmt_status_type_name__c = 'Analysis';
            paPicasso.gf_profitability_sheet_id__c = lstPSPicasso[0].Id;
            paPicasso.gf_pa_cond_appl_expiry_date__c = Date.valueOf('2021-02-01');
            paPicasso.gf_all_ct_apply_cond_ind_type__c = true;
        }
        lstPAPicasso[0].gf_pa_management_type_name__c = 'Renewal';
        lstPAPicasso[1].gf_pa_management_type_name__c = 'New';
        lstPAPicasso[2].gf_pa_management_type_name__c = 'Novation';
        lstPAPicasso[3].gf_pa_management_type_name__c = 'Cancellation';
        insert lstPAPicasso;

        // Create profitability analysis participants
        List<Id> childIdsPicasso = new List<Id>();
        for (Account accPicasso : lstPicassoChildAcc) {
            childIdsPicasso.add(accPicasso.Id);
        }
        final List<profitability_analysis_participant__c> lstPAPPicasso = new List<profitability_analysis_participant__c>();
        lstPAPPicasso.addAll(Test_Utils.createProfAnalysisParticipant(6, lstPAPicasso[0].Id, childIdsPicasso));
        lstPAPPicasso.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAPicasso[1].Id, new List<Id>{childIdsPicasso[6], childIdsPicasso[7]}));
        lstPAPPicasso.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAPicasso[2].Id, new List<Id>{childIdsPicasso[8], childIdsPicasso[9]}));
        lstPAPPicasso.addAll(Test_Utils.createProfAnalysisParticipant(2, lstPAPicasso[3].Id, new List<Id>{childIdsPicasso[10], childIdsPicasso[11]}));
        insert lstPAPPicasso;

        // Create profitability analysis flat rates
        final List<profitability_analysis_flat_rates__c> lstPAFRPicasso = Test_Utils.createPaFlatRate(new List<Id>{lstPAPicasso[0].Id, lstPAPicasso[1].Id, lstPAPicasso[2].Id, lstPAPicasso[3].Id}, 'New');
        lstPAFRPicasso[0].gf_pa_fr_request_type__c = null;
        lstPAFRPicasso[0].gf_pa_fr_price_type__c = 'EF';
        lstPAFRPicasso[0].gf_pa_fr_charge_type__c = '1';
        lstPAFRPicasso[0].gf_pa_fr_charge_pdicy_type__c = '1';
        lstPAFRPicasso[0].gf_pa_fr_currency_type__c = 'EUR';
        lstPAFRPicasso[0].gf_pa_fr_charge_date_type__c = '1';
        lstPAFRPicasso[0].gf_pa_fr_pv_wrkdy_ch_meth_type__c = 'A';
        lstPAFRPicasso[0].gf_pa_fr_ac_no_bal_method_type__c = 'C';
        lstPAFRPicasso[0].gf_pa_fr_ac_comments_desc__c ='Account Comments';
        lstPAFRPicasso[0].gf_pa_fr_invoice_comments_desc__c = 'Invoice Comments';
        lstPAFRPicasso[1].gf_pa_fr_request_type__c = 'Cancellation';
        lstPAFRPicasso[2].gf_pa_fr_request_type__c = 'Modification';
        lstPAFRPicasso[3].gf_pa_fr_request_type__c = 'New';
        insert lstPAFRPicasso;

        // Create ps_catalog_flat_rates_account__c
        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAccPicasso = Test_Utils.createPSCatFlatRatesAcc();
        insert lstPsCatFlatRatesAccPicasso;

        // Create profitability_analysis_flatrates_account__c
        final List<profitability_analysis_flatrates_account__c> lstPAFlatRatesAccsP = Test_Utils.createPAFlatRatesAccounts(new List<profitability_analysis_flat_rates__c>{lstPAFRPicasso[0], lstPAFRPicasso[0]}, new List<ps_catalog_flat_rates_account__c>{lstPsCatFlatRatesAccPicasso[0], lstPsCatFlatRatesAccPicasso[1]}, new List<Decimal>{22.50,50.00});
        insert lstPAFlatRatesAccsP;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPACPicasso = new List<profitability_analysis_condition__c>();
        lstPACPicasso.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAPicasso[0], lstPSCC[0]));
        lstPACPicasso.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAPicasso[0], lstPSCC[1]));
        lstPACPicasso.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAPicasso[0], lstPSCC[2]));
        lstPACPicasso.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAPicasso[0], lstPSCC[3]));
        lstPACPicasso.addAll(Test_Utils.createProfAnalysisConditons(1, lstPAPicasso[0], lstPSCC[4]));
        lstPACPicasso[0].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPACPicasso[0].gf_pa_source_cust_package_id__c = 'B00000000F0001';
        lstPACPicasso[4].gf_pa_cond_atrb_source_type__c = 'COMMISSIONS_FLAT';
        insert lstPACPicasso;

        // Create client packages
        final List<client_package__c> lstCPPicasso = new List<client_package__c>();
        lstCPPicasso.addAll(Test_Utils.createClientPackage(1, new List<Account>{lstPicassoChildAcc[0]}, new List<ps_catalog_package__c>{lstPSCatPkgPicasso[0]})); // Forfait
        lstCPPicasso.addAll(Test_Utils.createClientPackage(1, new List<Account>{lstPicassoChildAcc[1]}, new List<ps_catalog_package__c>{lstPSCatPkgPicasso[10]})); // Comm
        lstCPPicasso.addAll(Test_Utils.createClientPackage(1, new List<Account>{lstPicassoChildAcc[2]}, new List<ps_catalog_package__c>{lstPSCatPkgPicasso[20]})); // Gip
        insert lstCPPicasso;

        // Create profitability analysis pkg request
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqPicasso = new List<profitability_analysis_pkg_request__c>();
        lstPAPkgReqPicasso.addAll(Test_Utils.createProfAnPkgReq(3, lstPAPicasso[0].Id, 'New'));
        lstPAPkgReqPicasso.addAll(Test_Utils.createProfAnPkgReq(3, lstPAPicasso[0].Id, 'Modification'));
        lstPAPkgReqPicasso.addAll(Test_Utils.createProfAnPkgReq(2, lstPAPicasso[0].Id, 'Cancellation'));
        lstPAPkgReqPicasso.addAll(Test_Utils.createProfAnPkgReq(4, lstPAPicasso[0].Id, 'Extension'));

        // Forfait
        lstPAPkgReqPicasso[0].gf_psc_package_id__c = lstPSCatPkgPicasso[1].Id; //F0001
        lstPAPkgReqPicasso[0].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[0].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[3].gf_psc_package_id__c = lstPSCatPkgPicasso[2].Id; //F0002
        lstPAPkgReqPicasso[3].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[3].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[6].gf_psc_package_id__c = lstPSCatPkgPicasso[3].Id; //F0003
        lstPAPkgReqPicasso[6].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[6].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[8].gf_psc_package_id__c = lstPSCatPkgPicasso[4].Id; //F0004
        lstPAPkgReqPicasso[8].gf_pa_pkg_ext_req_st_type_name__c = 'Add';
        lstPAPkgReqPicasso[8].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[8].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[9].gf_psc_package_id__c = lstPSCatPkgPicasso[6].Id; //F0006
        lstPAPkgReqPicasso[9].gf_pa_pkg_ext_req_st_type_name__c = 'Remove';
        lstPAPkgReqPicasso[9].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[9].gf_pa_pkg_charge_pdicy_type__c = 'D';
        // Comm
        lstPAPkgReqPicasso[1].gf_psc_package_id__c = lstPSCatPkgPicasso[11].Id; //C0001
        lstPAPkgReqPicasso[1].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[1].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[4].gf_psc_package_id__c = lstPSCatPkgPicasso[12].Id; //C0002
        lstPAPkgReqPicasso[4].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[4].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[7].gf_psc_package_id__c = lstPSCatPkgPicasso[13].Id; //C0003
        lstPAPkgReqPicasso[7].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[7].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[10].gf_psc_package_id__c = lstPSCatPkgPicasso[14].Id; //C0004
        lstPAPkgReqPicasso[10].gf_pa_pkg_ext_req_st_type_name__c = 'Add';
        lstPAPkgReqPicasso[10].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[10].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[11].gf_psc_package_id__c = lstPSCatPkgPicasso[16].Id; //C0006
        lstPAPkgReqPicasso[11].gf_pa_pkg_ext_req_st_type_name__c = 'Remove';
        lstPAPkgReqPicasso[11].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[11].gf_pa_pkg_charge_pdicy_type__c = 'D';
        // Gip
        lstPAPkgReqPicasso[2].gf_psc_package_id__c = lstPSCatPkgPicasso[21].Id; //G0001
        lstPAPkgReqPicasso[2].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[2].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqPicasso[5].gf_psc_package_id__c = lstPSCatPkgPicasso[22].Id; //G0002
        lstPAPkgReqPicasso[5].participant_id__c = lstPAPPicasso[5].Id;
        lstPAPkgReqPicasso[5].gf_pa_pkg_charge_pdicy_type__c = 'D';
        insert lstPAPkgReqPicasso;

        final ps_catalog_flat_rates_dp__c psCatalogdpPicasso = new ps_catalog_flat_rates_dp__c(
            Name = 'Office',
            cuco__gf_dp_item_crscls_ind_type__c = false
        );
        insert psCatalogdpPicasso;

        // PS Catalog attributes flat rates dp
        final List<ps_catalog_attribute__c> lstPsCatAttbDP = new List<ps_catalog_attribute__c>();
        final ps_catalog_attribute__c psCatFlatDP1 = new ps_catalog_attribute__c(
            Name = 'P (Precio Unitario EUR)',
            cuco__gf_psc_attribute_id__c = 'dypri.p',
            cuco__gf_pscd_atrb_dp_apply_ind_type__c = true,
            cuco__gf_stored_fnl_atrb_field_name__c = 'gf_ps_fr_dp_annual_prc_amount__c',
            cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_fr_dp_annual_prc_amount__c'
        );
        lstPsCatAttbDP.add(psCatFlatDP1);
        final ps_catalog_attribute__c psCatFlatDP2 = new ps_catalog_attribute__c(
            Name = 'Q (Operaciones Anuales Negociadas)',
            cuco__gf_psc_attribute_id__c = 'dypri.q',
            cuco__gf_pscd_atrb_dp_apply_ind_type__c = true,
            cuco__gf_stored_fnl_atrb_field_name__c = 'gf_ps_fr_dp_neg_anl_ope_amount__c',
            cuco__gf_stored_prps_atrb_field_name__c = 'gf_pa_fr_dp_neg_anl_ope_amount__c'
        );
        lstPsCatAttbDP.add(psCatFlatDP2);
        insert lstPsCatAttbDP;

        final profitability_analysis_flat_rates_dp__c paFlatRateDPPicasso = new profitability_analysis_flat_rates_dp__c(
            gf_pa_flat_rate_id__c = lstPAFRPicasso[0].Id,
            gf_fr_dynamic_pricing_item_id__c = psCatalogdpPicasso.Id
        );
        insert paFlatRateDPPicasso;

        final List<ps_catalog_flat_rates_dp_attribute__c> lstPSCatFlatRateDpAttb = new List<ps_catalog_flat_rates_dp_attribute__c>();
        final ps_catalog_flat_rates_dp_attribute__c psCatalogdpAtt1 = new ps_catalog_flat_rates_dp_attribute__c(
            gf_psc_fr_dynamic_pricing_id__c = psCatalogdpPicasso.Id,
            gf_psc_atribute_id__c = psCatFlatDP1.Id,
            gf_psc_atrb_active_dp_ind_type__c = true
        );
        lstPSCatFlatRateDpAttb.add(psCatalogdpAtt1);
        final ps_catalog_flat_rates_dp_attribute__c psCatalogdpAtt2 = new ps_catalog_flat_rates_dp_attribute__c(
            gf_psc_fr_dynamic_pricing_id__c = psCatalogdpPicasso.Id,
            gf_psc_atribute_id__c = psCatFlatDP1.Id,
            gf_psc_atrb_active_dp_ind_type__c = true
        );
        lstPSCatFlatRateDpAttb.add(psCatalogdpAtt2);
        insert lstPSCatFlatRateDpAttb;
    }

    @IsTest
    static void sendPicassoRequestHelperTest1() {

        final ProfitabilityAnalysis_Selector paSelector1 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = paSelector1.selectByName(setNamesPA1);
        final ProfitabilityAnalysis_Wrapper paWrapper1 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA1[0].Id);
        final String requestDecision1 = '10';
        final String requestComments1 = 'Test comments';
        Test.startTest();
            final RequestPicasso_Helper sprHelper1 = new RequestPicasso_Helper(paWrapper1, requestDecision1, requestComments1);
            final HttpResponse response1 = sprHelper1.callWs();
            System.assertEquals(response1.getStatusCode(), 200, 'Err at RequestPicasso_Helper_Test - sendPicassoRequestHelperTest1');
        Test.stopTest();
    }

    @IsTest
    static void sendPicassoRequestHelperTest2() {

        final ProfitabilityAnalysis_Selector paSelector2 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA2 = paSelector2.selectByName(setNamesPA2);
        lstPA2[0].gf_all_ct_apply_cond_ind_type__c = false;
        update lstPA2;
        final ProfitabilityAnalysis_Wrapper paWrapper2 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA2[0].Id);
        final String requestDecision2 = '10';
        final String requestComments2 = 'Test comments';
        Test.startTest();
            final RequestPicasso_Helper sprHelper2 = new RequestPicasso_Helper(paWrapper2, requestDecision2, requestComments2);
            final HttpResponse response2 = sprHelper2.callWs();
            System.assertEquals(response2.getStatusCode(), 200, 'Err at RequestPicasso_Helper_Test - sendPicassoRequestHelperTest2');
        Test.stopTest();
    }

    @IsTest
    static void sendPicassoRequestHelperTest3() {

        final ProfitabilityAnalysis_Selector paSelector3 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA3 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA3 = paSelector3.selectByName(setNamesPA3);
        final ProfitabilityAnalysis_Wrapper paWrapper3 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA3[0].Id);
        final String requestDecision3 = '10';
        final String requestComments3 = 'Test comments';
        Test.startTest();
            final RequestPicasso_Helper sprHelper3 = new RequestPicasso_Helper(paWrapper3, requestDecision3, requestComments3);
            final HttpResponse response3 = sprHelper3.callWs();
            System.assertEquals(response3.getStatusCode(), 200, 'Err at RequestPicasso_Helper_Test - sendPicassoRequestHelperTest3');
        Test.stopTest();
    }

    @IsTest
    static void sendPicassoRequestHelperTest4() {

        final ProfitabilityAnalysis_Selector paSelector4 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA4 = new Set<String>{'Prof Analysis Test 2'};
        final List<profitability_analysis__c> lstPA4 = paSelector4.selectByName(setNamesPA4);
        final ProfitabilityAnalysis_Wrapper paWrapper4 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA4[0].Id);
        final String requestDecision4 = '05';
        final String requestComments4 = 'Test comments';
        Test.startTest();
            final RequestPicasso_Helper sprHelper4 = new RequestPicasso_Helper(paWrapper4, requestDecision4, requestComments4);
            final HttpResponse response4 = sprHelper4.callWs();
            System.assertEquals(response4.getStatusCode(), 200, 'Err at RequestPicasso_Helper_Test - sendPicassoRequestHelperTest4');
        Test.stopTest();
    }

    @IsTest
    static void sendPicassoRequestHelperTest5() {

        final ProfitabilityAnalysis_Selector paSelector5 = new ProfitabilityAnalysis_Selector();
        final Set<String> setNamesPA5 = new Set<String>{'Prof Analysis Test 3'};
        final List<profitability_analysis__c> lstPA5 = paSelector5.selectByName(setNamesPA5);
        final ProfitabilityAnalysis_Wrapper paWrapper5 = ProfitabilityAnalysis_Helper.getProfAnalysis(lstPA5[0].Id);
        final String requestDecision5 = 'Test';
        final String requestComments5 = 'Test comments';
        Test.startTest();
            final RequestPicasso_Helper sprHelper5 = new RequestPicasso_Helper(paWrapper5, requestDecision5, requestComments5);
            final HttpResponse response5 = sprHelper5.callWs();
            System.assertEquals(response5.getStatusCode(), 200, 'Err at RequestPicasso_Helper_Test - sendPicassoRequestHelperTest5');
        Test.stopTest();
    }
}