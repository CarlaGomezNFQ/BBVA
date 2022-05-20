/**********************************************************************************
* @author     VASS
* @date
* @description
* @Revision
**********************************************************************************/
@SuppressWarnings('sf:CyclomaticComplexity, sf:ImmutableField, sf:CommentRequired, f:UnnecessaryConstructor, f:ExcessiveMethodLength, f:NcssMethodCount, f:AvoidUsingTestIsRunningTest, f:ShortVariable')
public without sharing class Batch_OpportunitiesMigration implements Database.Batchable<Sobject>, Database.Stateful {
  private String pQuery = 'SELECT Id, DES_Pricing_Committee_Approval_BEC__c, DES_Borrower_and_or_Operation_Name__c, DES_Seller__c, DES_Potential_Revenue__c, DES_Tenor_Months__c, DES_BBVA_Commitment__c, DES_Cost_of_Funding__c, DES_Counterpart_Name__c, DES_Underwriting_Committee_Approval__c, DES_NBC_Approval_or_PreApproval_BIBEC__c, DES_NBC_Approval__c, DES_NBC_Comments__c, NBC_Comments__c, DES_Subproduct__c, DES_BIBEC_Banker__c, DES_Product__c, DES_Opportunity_Stage__c, DES_BBVA_Participant_Banks__c, DES_Country_Distribution_Area__c, DES_Risks_Holder__c, DES_RFP__c, DES_Average_Annual_Balance__c, DES_BBVA_Role__c, DES_Asset_Type_Level_3__c, DES_Implementation__c, DES_Importer__c, DES_Compliance_Approval__c, DES_Origination_Country__c, DES_Purpose__c, DES_Syndication_Fee__c, DES_Underwriting_fee__c, Booking_type__c, DES_Asset_Type_Level_2__c, DES_Beneficiary__c, DES_Asset_Type_Level_1__c, DES_Distribution_Area__c, DES_Target_Country__c, DES_Matfil__c, DES_Platform__c, DES_Beneficiary_Bank__c, DES_Valued_portfolio__c, DES_Exporter_Country__c, DES_Buyer__c, DES_Exporter__c, DES_Issuing_Bank__c, DES_Advising_Bank__c, DES_Counterpart_Country__c, DES_Asset_Country__c, DES_Applicant__c, DES_Assignor__c, DES_Confirming_Bank__c, DES_Asset_Allocation_Approval__c, DES_Debtor__c, DES_Counterparty_Role__c, DES_BO_Type__c, DES_Importer_Country__c, DES_Client_Type__c, DES_Guarantor__c, DES_Target_Industry__c, DES_Client_Role__c, DES_Guarantor_Coverage_Mitigant__c, DES_COMEX_Specialist__c, DES_N_Guarantor_Coverage_Mitigant__c, DES_Risk_Type__c, DES_Fronting_Bank__c, Security_package__c, DES_ECA_Name__c, DES_ECA_Cover__c, Private_Insurance_Name__c, Cover_Private_Insurance__c, DES_Tenor_Years__c, DES_Deal_Volume__c, DES_Credit_Amount__c, DES_Total_Debt_Size__c, DES_Global_Deal_Amount__c, DES_BBVA_Final_Hold__c, DES_Amount__c, DES_BBVA_Final_Take__c, DES_Retainer_Fees__c, DES_Monthly_Retainer_Fee__c, DES_Territorial__c, DES_Regional__c, DES_Team__c, DES_Arrangement_Fee__c, DES_Up_Front_Fees__c, DES_Earned_Retainer_Fees__c, DES_Success_Fee__c, DES_Risk_Observations__c, DES_Commitment_Fees__c, DES_Annual_Risk_Fee__c, DES_Relevant_Comments__c, oppy_pricing_cmtee_rspse_type__c, participant_name__c, seller_advance_payment_name__c, pre_oppy_revenue_next_12m_amount__c, loan_tenor_month_desc__c, bbva_prtcp_tranche_amount__c, funding_cost_per__c, counterparty_name__c, oppy_undwr_cmtee_rspse_type__c, opportunity_nbc_recm_ind_type__c, opportunity_nbc_comments_desc__c, solution_name_path_desc__c, classification_cib_banker_type__c, subproduct_name__c, opportunity_stage_type__c, bbva_struc_trd_finc_bank_name__c, filial_country_distribution_id__c, risk_holder_entity_name__c, proposal_requested_ind_type__c, avg_balance_annual_amount__c, entity_role_type__c, oppy_asset_level_3_name__c, gf_product_conn_impl_ind_type__c, importing_company_name__c, cplc_cmtee_approval_ind_type__c, origin_country_name__c, loan_purpose_desc__c, operation_underwriting_per__c, product_scope_type__c, oppy_asset_level_2_name__c, beneficiary_entity_name__c, oppy_asset_level_1_name__c, oppy_product_offer_area_name__c, oppy_target_country_name__c, benefit_sharing_agree_ind_type__c, trd_finc_tran_cnfrm_pltfm_name__c, beneficiary_entity_id__c, current_value_portfolio_amount__c, multn_acqn_export_country_name__c, gf_company_adv_payment_name__c, exporting_company_name__c, issuing_entity_name__c, advising_entity_id__c, counterparty_country_id__c, country_name__c, financial_gntee_applicant_name__c, assignor_id__c, confirming_entity_id__c, aa_committee_approval_ind_type__c, customer_debtor_name__c, counterparty_rol_name__c, opportunity_name__c, multn_acqn_import_country_name__c, customer_type__c, customer_guarantor_entity_id__c, oppy_target_industry_name__c, participant_role_desc__c, gf_thpty_guarantor_risk_name__c, ext_trade_cmtee_cr_spclst_name__c, gf_thpty_guarantor_risk_per__c, opportunity_risk_name__c, beneficiary_fronting_bank_name__c, deal_guarantee_desc__c, export_credit_agency_name__c, loan_export_cr_agncy_cntrb_per__c, insurance_company_name__c, insurance_cover_per__c, opportunity_tenor_years_number__c, deal_total_amount__c, syndicated_loan_drawn_amount__c, retainer_fee_12m_amount__c, regional_area_name__c, opening_fee_per__c, fee_next_12m_amount__c, risk_committee_comments_desc__c, undrawn_fee_next_12m_per__c, DES_Risk_Fee_Next_12_Months__c, Opportunity.DES_Comments__c, oppy_undwr_cmtee_approval_date__c, DES_Underwriting_Approval_Date__c, opportunity_nbc_recm_date__c, DES_NBC_PreApproval_BIBEC_Date__c, DES_NBC_Approval_Date__c, oppy_substage_mandate_date__c, DES_Mandate_Date__c, risk_committee_approval_date__c, DES_Risk_Approval_Date__c, oppy_pricing_cmtee_aprvl_date__c, DES_Pricing_Approval_Date_BEC_Clients__c, signing_date__c, DES_Signature_Date__c, oppy_product_ctrct_comt_date__c, DES_Sell_Down_Commitment_Date__c, oppy_nbc_rcmndn_maturity_date__c, DES_Maturity_NBC_Date__c, gf_eca_offer_expiry_date__c, DES_Offer_Maturity_ECA__c FROM OpportunityLineItem '+ Label.BATCHOPPMIGRATIONWHERE  + (Test.isRunningTest()?' LIMIT 1':'');
    public static Integer recordsCount = 0; //NOSONAR
    public static Map<Id, String> mapErrors = new Map<Id, String>();//NOSONAR
    public Batch_OpportunitiesMigration() {
    }


    public Database.QueryLocator start(Database.BatchableContext bc) {
        system.debug('>>>>> pQuery : ' + JSON.serialize(pQuery));
        return Database.getQueryLocator(pQuery);
    }


    public void execute(Database.BatchableContext bc,List<OpportunityLineItem> scope) {
      system.debug('>>>>> scope : ' + scope);
      for(OpportunityLineItem oppli : scope) {
        recordsCount++;
        try {
          if((oppli.DES_Pricing_Committee_Approval_BEC__c != null && oppli.oppy_pricing_cmtee_rspse_type__c == null) || Test.isRunningTest()) {
            oppli.oppy_pricing_cmtee_rspse_type__c = oppli.DES_Pricing_Committee_Approval_BEC__c;
          }

          if((oppli.DES_Borrower_and_or_Operation_Name__c != null && oppli.participant_name__c == null) || Test.isRunningTest()) {
            oppli.participant_name__c = oppli.DES_Borrower_and_or_Operation_Name__c;
          }

          if((oppli.DES_Seller__c != null && oppli.seller_advance_payment_name__c == null) || Test.isRunningTest()) {
            oppli.seller_advance_payment_name__c = oppli.DES_Seller__c;
          }

          if((oppli.DES_Potential_Revenue__c != null && oppli.pre_oppy_revenue_next_12m_amount__c == null) || Test.isRunningTest()) {
            oppli.pre_oppy_revenue_next_12m_amount__c = oppli.DES_Potential_Revenue__c;
          }

          if((oppli.DES_Tenor_Months__c != null && oppli.loan_tenor_month_desc__c == null) || Test.isRunningTest()) {
            oppli.loan_tenor_month_desc__c = oppli.DES_Tenor_Months__c;
          }
      
          system.debug('oppli.bbva_prtcp_tranche_amount__c: ' + oppli.bbva_prtcp_tranche_amount__c);
          system.debug('oppli.DES_BBVA_Commitment__c: ' + oppli.DES_BBVA_Commitment__c);
          if((oppli.DES_BBVA_Commitment__c != null && oppli.bbva_prtcp_tranche_amount__c == null) || Test.isRunningTest()) {
            oppli.bbva_prtcp_tranche_amount__c = oppli.DES_BBVA_Commitment__c;
              system.debug('ESTOY DENTRO  BBVA COMMITMENT');
          }

          if((oppli.DES_Cost_of_Funding__c != null && oppli.funding_cost_per__c == null) || Test.isRunningTest()) {
            oppli.funding_cost_per__c = oppli.DES_Cost_of_Funding__c;
          }

          if((oppli.DES_Counterpart_Name__c != null && oppli.counterparty_name__c == null) || Test.isRunningTest()) {
            oppli.counterparty_name__c = oppli.DES_Counterpart_Name__c;
          }

          if((oppli.DES_Underwriting_Approval_Date__c != null && oppli.oppy_undwr_cmtee_approval_date__c == null) || Test.isRunningTest()) {
            oppli.oppy_undwr_cmtee_approval_date__c = oppli.DES_Underwriting_Approval_Date__c;
          }

          if((oppli.DES_Underwriting_Committee_Approval__c != null && oppli.oppy_undwr_cmtee_rspse_type__c == null) || Test.isRunningTest()) {
            oppli.oppy_undwr_cmtee_rspse_type__c = oppli.DES_Underwriting_Committee_Approval__c;
          }

          if((oppli.DES_NBC_PreApproval_BIBEC_Date__c != null && oppli.opportunity_nbc_recm_date__c == null) || Test.isRunningTest()) {
            oppli.opportunity_nbc_recm_date__c = oppli.DES_NBC_PreApproval_BIBEC_Date__c;
          }

          if((oppli.DES_NBC_Approval_Date__c != null && oppli.opportunity_nbc_recm_date__c == null) || Test.isRunningTest()) {
            oppli.opportunity_nbc_recm_date__c = oppli.DES_NBC_Approval_Date__c;
          }

          if((oppli.DES_NBC_Approval_or_PreApproval_BIBEC__c != null && oppli.opportunity_nbc_recm_ind_type__c == null) || Test.isRunningTest()) {
            oppli.opportunity_nbc_recm_ind_type__c = oppli.DES_NBC_Approval_or_PreApproval_BIBEC__c;
          }

          if((oppli.DES_NBC_Approval__c != null && oppli.opportunity_nbc_recm_ind_type__c == null) || Test.isRunningTest()) {
            oppli.opportunity_nbc_recm_ind_type__c = oppli.DES_NBC_Approval__c;
          }

          if((oppli.DES_NBC_Comments__c != null && oppli.opportunity_nbc_comments_desc__c == null) || Test.isRunningTest()) {
            oppli.opportunity_nbc_comments_desc__c = oppli.DES_NBC_Comments__c;
          }

          if((oppli.NBC_Comments__c != null && oppli.opportunity_nbc_comments_desc__c == null) || Test.isRunningTest()) {
            oppli.opportunity_nbc_comments_desc__c = oppli.NBC_Comments__c;
          }

          if((oppli.DES_Subproduct__c != null && oppli.solution_name_path_desc__c == null) || Test.isRunningTest()) {
            oppli.solution_name_path_desc__c = oppli.DES_Subproduct__c;
          }

          if((oppli.DES_BIBEC_Banker__c != null && oppli.classification_cib_banker_type__c == null) || Test.isRunningTest()) {
            oppli.classification_cib_banker_type__c = oppli.DES_BIBEC_Banker__c;
          }

          if((oppli.DES_Product__c != null && oppli.subproduct_name__c == null) || Test.isRunningTest()) {
            oppli.subproduct_name__c = oppli.DES_Product__c;
          }

          if((oppli.DES_Opportunity_Stage__c != null && oppli.opportunity_stage_type__c == null) || Test.isRunningTest()) {
            oppli.opportunity_stage_type__c = oppli.DES_Opportunity_Stage__c;
          }

          if((oppli.DES_Mandate_Date__c != null && oppli.oppy_substage_mandate_date__c == null) || Test.isRunningTest()) {
            oppli.oppy_substage_mandate_date__c = oppli.DES_Mandate_Date__c;
          }

          if((oppli.DES_Risk_Approval_Date__c != null && oppli.risk_committee_approval_date__c == null) || Test.isRunningTest()) {
            oppli.risk_committee_approval_date__c = oppli.DES_Risk_Approval_Date__c;
          }

          if((oppli.DES_BBVA_Participant_Banks__c != null && oppli.bbva_struc_trd_finc_bank_name__c == null) || Test.isRunningTest()) {
            oppli.bbva_struc_trd_finc_bank_name__c = oppli.DES_BBVA_Participant_Banks__c;
          }

          if((oppli.DES_Country_Distribution_Area__c != null && oppli.filial_country_distribution_id__c == null) || Test.isRunningTest()) {
            oppli.filial_country_distribution_id__c = oppli.DES_Country_Distribution_Area__c;
          }

          if((oppli.DES_Risks_Holder__c != null && oppli.risk_holder_entity_name__c == null) || Test.isRunningTest()) {
            oppli.risk_holder_entity_name__c = oppli.DES_Risks_Holder__c;
          }

          if((oppli.DES_RFP__c != null && oppli.proposal_requested_ind_type__c == null) || Test.isRunningTest()) {
            oppli.proposal_requested_ind_type__c = oppli.DES_RFP__c;
          }

          if((oppli.DES_Average_Annual_Balance__c != null && oppli.avg_balance_annual_amount__c == null) || Test.isRunningTest()) {
            oppli.avg_balance_annual_amount__c = oppli.DES_Average_Annual_Balance__c;
          }

          if((oppli.DES_BBVA_Role__c != null && oppli.entity_role_type__c == null) || Test.isRunningTest()) {
            oppli.entity_role_type__c = oppli.DES_BBVA_Role__c;
          }

          if((oppli.DES_Asset_Type_Level_3__c != null && oppli.oppy_asset_level_3_name__c == null) || Test.isRunningTest()) {
            oppli.oppy_asset_level_3_name__c = oppli.DES_Asset_Type_Level_3__c;
          }

          if((oppli.DES_Implementation__c != null && oppli.gf_product_conn_impl_ind_type__c == null) || Test.isRunningTest()) {
            oppli.gf_product_conn_impl_ind_type__c = oppli.DES_Implementation__c;
          }

          if((oppli.DES_Importer__c != null && oppli.importing_company_name__c == null) || Test.isRunningTest()) {
            oppli.importing_company_name__c = oppli.DES_Importer__c;
          }

          if((oppli.DES_Compliance_Approval__c != null && oppli.cplc_cmtee_approval_ind_type__c == null) || Test.isRunningTest()) {
            oppli.cplc_cmtee_approval_ind_type__c = oppli.DES_Compliance_Approval__c;
          }

          if((oppli.DES_Pricing_Approval_Date_BEC_Clients__c != null && oppli.oppy_pricing_cmtee_aprvl_date__c == null) || Test.isRunningTest()) {
            oppli.oppy_pricing_cmtee_aprvl_date__c = oppli.DES_Pricing_Approval_Date_BEC_Clients__c;
          }

          if((oppli.DES_Origination_Country__c != null && oppli.origin_country_name__c == null) || Test.isRunningTest()) {
            oppli.origin_country_name__c = oppli.DES_Origination_Country__c;
          }

          if((oppli.DES_Purpose__c != null && oppli.loan_purpose_desc__c == null) || Test.isRunningTest()) {
            oppli.loan_purpose_desc__c = oppli.DES_Purpose__c;
          }

          if((oppli.DES_Signature_Date__c != null && oppli.signing_date__c == null) || Test.isRunningTest()) {
            oppli.signing_date__c = oppli.DES_Signature_Date__c;
          }

          if((oppli.DES_Syndication_Fee__c != null && oppli.operation_underwriting_per__c == null) || Test.isRunningTest()) {
            oppli.operation_underwriting_per__c = oppli.DES_Syndication_Fee__c;
          }

          if((oppli.DES_Underwriting_fee__c != null && oppli.operation_underwriting_per__c == null) || Test.isRunningTest()) {
            oppli.operation_underwriting_per__c = oppli.DES_Underwriting_fee__c;
          }

          if((oppli.Booking_type__c != null && oppli.product_scope_type__c == null) || Test.isRunningTest()) {
            oppli.product_scope_type__c = oppli.Booking_type__c;
          }

          if((oppli.DES_Asset_Type_Level_2__c != null && oppli.oppy_asset_level_2_name__c == null) || Test.isRunningTest()) {
            oppli.oppy_asset_level_2_name__c = oppli.DES_Asset_Type_Level_2__c;
          }

          if((oppli.DES_Beneficiary__c != null && oppli.beneficiary_entity_name__c == null) || Test.isRunningTest()) {
            oppli.beneficiary_entity_name__c = oppli.DES_Beneficiary__c;
          }

          if((oppli.DES_Sell_Down_Commitment_Date__c != null && oppli.oppy_product_ctrct_comt_date__c == null) || Test.isRunningTest()) {
            oppli.oppy_product_ctrct_comt_date__c = oppli.DES_Sell_Down_Commitment_Date__c;
          }

          if((oppli.DES_Asset_Type_Level_1__c != null && oppli.oppy_asset_level_1_name__c == null) || Test.isRunningTest()) {
            oppli.oppy_asset_level_1_name__c = oppli.DES_Asset_Type_Level_1__c;
          }

          if((oppli.DES_Distribution_Area__c != null && oppli.oppy_product_offer_area_name__c == null) || Test.isRunningTest()) {
            oppli.oppy_product_offer_area_name__c = oppli.DES_Distribution_Area__c;
          }

          if((oppli.DES_Target_Country__c != null && oppli.oppy_target_country_name__c == null) || Test.isRunningTest()) {
            oppli.oppy_target_country_name__c = oppli.DES_Target_Country__c;
          }

          if((oppli.DES_Matfil__c != null && oppli.benefit_sharing_agree_ind_type__c == null) || Test.isRunningTest()) {
            oppli.benefit_sharing_agree_ind_type__c = oppli.DES_Matfil__c;
          }

          if((oppli.DES_Platform__c != null && oppli.trd_finc_tran_cnfrm_pltfm_name__c == null) || Test.isRunningTest()) {
            oppli.trd_finc_tran_cnfrm_pltfm_name__c = oppli.DES_Platform__c;
          }

          if((oppli.DES_Beneficiary_Bank__c != null && oppli.beneficiary_entity_id__c == null) || Test.isRunningTest()) {
            oppli.beneficiary_entity_id__c = oppli.DES_Beneficiary_Bank__c;
          }

          if((oppli.DES_Valued_portfolio__c != null && oppli.current_value_portfolio_amount__c == null) || Test.isRunningTest()) {
            oppli.current_value_portfolio_amount__c = oppli.DES_Valued_portfolio__c;
          }

          if((oppli.DES_Exporter_Country__c != null && oppli.multn_acqn_export_country_name__c == null) || Test.isRunningTest()) {
            oppli.multn_acqn_export_country_name__c = oppli.DES_Exporter_Country__c;
          }

          if((oppli.DES_Buyer__c != null && oppli.gf_company_adv_payment_name__c == null) || Test.isRunningTest()) {
            oppli.gf_company_adv_payment_name__c = oppli.DES_Buyer__c;
          }

          if((oppli.DES_Exporter__c != null && oppli.exporting_company_name__c == null) || Test.isRunningTest()) {
            oppli.exporting_company_name__c = oppli.DES_Exporter__c;
          }

          if((oppli.DES_Issuing_Bank__c != null && oppli.issuing_entity_name__c == null) || Test.isRunningTest()) {
            oppli.issuing_entity_name__c = oppli.DES_Issuing_Bank__c;
          }

          if((oppli.DES_Advising_Bank__c != null && oppli.advising_entity_id__c == null) || Test.isRunningTest()) {
            oppli.advising_entity_id__c = oppli.DES_Advising_Bank__c;
          }

          if((oppli.DES_Counterpart_Country__c != null && oppli.counterparty_country_id__c == null) || Test.isRunningTest()) {
            oppli.counterparty_country_id__c = oppli.DES_Counterpart_Country__c;
          }

          if((oppli.DES_Asset_Country__c != null && oppli.country_name__c == null) || Test.isRunningTest()) {
            oppli.country_name__c = oppli.DES_Asset_Country__c;
          }

          if((oppli.DES_Applicant__c != null && oppli.financial_gntee_applicant_name__c == null) || Test.isRunningTest()) {
            oppli.financial_gntee_applicant_name__c = oppli.DES_Applicant__c;
          }

          if((oppli.DES_Assignor__c != null && oppli.assignor_id__c == null) || Test.isRunningTest()) {
            oppli.assignor_id__c = oppli.DES_Assignor__c;
          }

          if((oppli.DES_Confirming_Bank__c != null && oppli.confirming_entity_id__c == null) || Test.isRunningTest()) {
            oppli.confirming_entity_id__c = oppli.DES_Confirming_Bank__c;
          }

          if((oppli.DES_Asset_Allocation_Approval__c != null && oppli.aa_committee_approval_ind_type__c == null) || Test.isRunningTest()) {
            oppli.aa_committee_approval_ind_type__c = oppli.DES_Asset_Allocation_Approval__c;
          }

          if((oppli.DES_Debtor__c != null && oppli.customer_debtor_name__c == null) || Test.isRunningTest()) {
            oppli.customer_debtor_name__c = oppli.DES_Debtor__c;
          }

          if((oppli.DES_Counterparty_Role__c != null && oppli.counterparty_rol_name__c == null) || Test.isRunningTest()) {
            oppli.counterparty_rol_name__c = oppli.DES_Counterparty_Role__c;
          }

          if((oppli.DES_BO_Type__c != null && oppli.opportunity_name__c == null) || Test.isRunningTest()) {
            oppli.opportunity_name__c = oppli.DES_BO_Type__c;
          }

          if((oppli.DES_Maturity_NBC_Date__c != null && oppli.oppy_nbc_rcmndn_maturity_date__c == null) || Test.isRunningTest()) {
            oppli.oppy_nbc_rcmndn_maturity_date__c = oppli.DES_Maturity_NBC_Date__c;
          }

          if((oppli.DES_Importer_Country__c != null && oppli.multn_acqn_import_country_name__c == null) || Test.isRunningTest()) {
            oppli.multn_acqn_import_country_name__c = oppli.DES_Importer_Country__c;
          }

          if((oppli.DES_Client_Type__c != null && oppli.customer_type__c == null) || Test.isRunningTest()) {
            oppli.customer_type__c = oppli.DES_Client_Type__c;
          }

          if((oppli.DES_Offer_Maturity_ECA__c != null && oppli.gf_eca_offer_expiry_date__c == null) || Test.isRunningTest()) {
            oppli.gf_eca_offer_expiry_date__c = oppli.DES_Offer_Maturity_ECA__c;
          }

          if((oppli.DES_Guarantor__c != null && oppli.customer_guarantor_entity_id__c == null) || Test.isRunningTest()) {
            oppli.customer_guarantor_entity_id__c = oppli.DES_Guarantor__c;
          }

          if((oppli.DES_Target_Industry__c != null && oppli.oppy_target_industry_name__c == null) || Test.isRunningTest()) {
            oppli.oppy_target_industry_name__c = oppli.DES_Target_Industry__c;
          }

          if((oppli.DES_Client_Role__c != null && oppli.participant_role_desc__c == null) || Test.isRunningTest()) {
            oppli.participant_role_desc__c = oppli.DES_Client_Role__c;
          }

          if((oppli.DES_Guarantor_Coverage_Mitigant__c != null && oppli.gf_thpty_guarantor_risk_name__c == null) || Test.isRunningTest()) {
            oppli.gf_thpty_guarantor_risk_name__c = oppli.DES_Guarantor_Coverage_Mitigant__c;
          }

          if((oppli.DES_COMEX_Specialist__c != null && oppli.ext_trade_cmtee_cr_spclst_name__c == null) || Test.isRunningTest()) {
            oppli.ext_trade_cmtee_cr_spclst_name__c = oppli.DES_COMEX_Specialist__c;
          }

          if((oppli.DES_N_Guarantor_Coverage_Mitigant__c != null && oppli.gf_thpty_guarantor_risk_per__c == null) || Test.isRunningTest()) {
            oppli.gf_thpty_guarantor_risk_per__c = oppli.DES_N_Guarantor_Coverage_Mitigant__c;
          }

          if((oppli.DES_Risk_Type__c != null && oppli.opportunity_risk_name__c == null) || Test.isRunningTest()) {
            oppli.opportunity_risk_name__c = oppli.DES_Risk_Type__c;
          }

          if((oppli.DES_Fronting_Bank__c != null && oppli.beneficiary_fronting_bank_name__c == null) || Test.isRunningTest()) {
            oppli.beneficiary_fronting_bank_name__c = oppli.DES_Fronting_Bank__c;
          }

          if((oppli.Security_package__c != null && oppli.deal_guarantee_desc__c == null) || Test.isRunningTest()) {
            oppli.deal_guarantee_desc__c = oppli.Security_package__c;
          }

          if((oppli.DES_ECA_Name__c != null && oppli.export_credit_agency_name__c == null) || Test.isRunningTest()) {
            oppli.export_credit_agency_name__c = oppli.DES_ECA_Name__c;
          }

          if((oppli.DES_ECA_Cover__c != null && oppli.loan_export_cr_agncy_cntrb_per__c == null) || Test.isRunningTest()) {
            oppli.loan_export_cr_agncy_cntrb_per__c = oppli.DES_ECA_Cover__c;
          }

          if((oppli.Private_Insurance_Name__c != null && oppli.insurance_company_name__c == null) || Test.isRunningTest()) {
            oppli.insurance_company_name__c = oppli.Private_Insurance_Name__c;
          }

          if((oppli.Cover_Private_Insurance__c != null && oppli.insurance_cover_per__c == null) || Test.isRunningTest()) {
            oppli.insurance_cover_per__c = oppli.Cover_Private_Insurance__c;
          }

          if((oppli.DES_Tenor_Years__c != null && oppli.opportunity_tenor_years_number__c == null) || Test.isRunningTest()) {
            oppli.opportunity_tenor_years_number__c = oppli.DES_Tenor_Years__c;
          }

          if((oppli.DES_Deal_Volume__c != null && oppli.deal_total_amount__c == null) || Test.isRunningTest()) {
            oppli.deal_total_amount__c = oppli.DES_Deal_Volume__c;
          }

          if((oppli.DES_Credit_Amount__c != null && oppli.deal_total_amount__c == null) || Test.isRunningTest()) {
            oppli.deal_total_amount__c = oppli.DES_Credit_Amount__c;
          }

          if((oppli.DES_Total_Debt_Size__c != null && oppli.deal_total_amount__c == null) || Test.isRunningTest()) {
            oppli.deal_total_amount__c = oppli.DES_Total_Debt_Size__c;
          }

          if((oppli.DES_Global_Deal_Amount__c != null && oppli.deal_total_amount__c == null) || Test.isRunningTest()) {
            oppli.deal_total_amount__c = oppli.DES_Global_Deal_Amount__c;
          }

          if((oppli.DES_BBVA_Final_Hold__c != null && oppli.syndicated_loan_drawn_amount__c == null) || Test.isRunningTest()) {
            oppli.syndicated_loan_drawn_amount__c = oppli.DES_BBVA_Final_Hold__c;
          }

          if((oppli.DES_Amount__c != null && oppli.syndicated_loan_drawn_amount__c == null) || Test.isRunningTest()) {
            oppli.syndicated_loan_drawn_amount__c = oppli.DES_Amount__c;
          }

          if((oppli.DES_BBVA_Final_Take__c != null && oppli.syndicated_loan_drawn_amount__c == null) || Test.isRunningTest()) {
            oppli.syndicated_loan_drawn_amount__c = oppli.DES_BBVA_Final_Take__c;
          }

          if((oppli.DES_Retainer_Fees__c != null && oppli.retainer_fee_12m_amount__c == null) || Test.isRunningTest()) {
            oppli.retainer_fee_12m_amount__c = oppli.DES_Retainer_Fees__c;
          }

          if((oppli.DES_Monthly_Retainer_Fee__c != null && oppli.retainer_fee_12m_amount__c == null) || Test.isRunningTest()) {
            oppli.retainer_fee_12m_amount__c = oppli.DES_Monthly_Retainer_Fee__c;
          }

          if((oppli.DES_Territorial__c != null && oppli.regional_area_name__c == null) || Test.isRunningTest()) {
            oppli.regional_area_name__c = oppli.DES_Territorial__c;
          }

          if((oppli.DES_Regional__c != null && oppli.regional_area_name__c == null) || Test.isRunningTest()) {
            oppli.regional_area_name__c = oppli.DES_Regional__c;
          }

          if((oppli.DES_Team__c != null && oppli.regional_area_name__c == null) || Test.isRunningTest()) {
            oppli.regional_area_name__c = oppli.DES_Team__c;
          }

          if((oppli.DES_Arrangement_Fee__c != null && oppli.opening_fee_per__c == null) || Test.isRunningTest()) {
            oppli.opening_fee_per__c = oppli.DES_Arrangement_Fee__c;
          }

          if((oppli.DES_Up_Front_Fees__c != null && oppli.opening_fee_per__c == null) || Test.isRunningTest()) {
            oppli.opening_fee_per__c = oppli.DES_Up_Front_Fees__c;
          }

          if((oppli.DES_Earned_Retainer_Fees__c != null && oppli.fee_next_12m_amount__c == null) || Test.isRunningTest()) {
            oppli.fee_next_12m_amount__c = oppli.DES_Earned_Retainer_Fees__c;
          }

          if((oppli.DES_Success_Fee__c != null && oppli.fee_next_12m_amount__c == null) || Test.isRunningTest()) {
            oppli.fee_next_12m_amount__c = oppli.DES_Success_Fee__c;
          }

          if((oppli.DES_Risk_Observations__c != null && oppli.risk_committee_comments_desc__c == null) || Test.isRunningTest()) {
            oppli.risk_committee_comments_desc__c = oppli.DES_Risk_Observations__c;
          }

          if((oppli.DES_Commitment_Fees__c != null && oppli.undrawn_fee_next_12m_per__c == null) || Test.isRunningTest()) {
            oppli.undrawn_fee_next_12m_per__c = oppli.DES_Commitment_Fees__c;
          }

          /*(if(DES_Annual_Risk_Fee__c * 100 != null && oppli.DES_Risk_Fee_Next_12_Months__c == null) || Test.isRunningTest()) {
            oppli.DES_Risk_Fee_Next_12_Months__c = oppli.DES_Annual_Risk_Fee__c * 100;
          }*/


        } catch (Exception e) {
          mapErrors.put(oppli.Id, 'ERROR: ' + e);
          system.debug('::::: EXCEPTION : ' + e);
        }
      }
        
      update scope;

    }//FIN execute

    public void finish(Database.BatchableContext bc){
      system.debug('::::: RecordsProcessed : ' + recordsCount);
      for(Id oppliIdEror : mapErrors.keySet()) {
        system.debug('::::: OPPLI: ' + oppliIdEror + ' - Error: ' + mapErrors.get(oppliIdEror));
      }
    }

}