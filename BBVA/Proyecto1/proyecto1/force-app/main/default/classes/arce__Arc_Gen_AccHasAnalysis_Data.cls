/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_AccHasAnalysis_Data
* @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
* @Date     Created: 24/06/2019
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Data class for object arce__Account_has_Analysis__c
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-06-24 mariohumberto.ramirez.contractor@bbva.com
*             Class creation.
* |2019-10-03 mariohumberto.ramirez.contractor@bbva.com
*             Added new field 'arce__Analysis__r.arce__Stage__c' to retrieve in method
*             getAccHasRelation.
* |2019-10-03 mariohumberto.ramirez.contractor@bbva.com
*             Change of param in the method getRatingStatus, now is of type list
* |2019-10-11 mariohumberto.ramirez.contractor@bbva.com
*             Addes new field 'arce__Analysis__r.arce__analysis_risk_sanction_date__c' to retrieve
*             in method getAccHasAnalysis
* |2019-12-02 german.sanchez.perez.contractor@bbva.com | franciscojavier.bueno@bbva.com
*             api names modified with the correct name on business glossary
* |2019-12-02 manuelhugo.castillo.contractor@bbva.com
*             Include filed api arce__Customer__r.ParentId in query from method 'getAccHasAnalysis'
* |2019-12-19 german.sanchez.perez.contractor@bbva.com | franciscojavier.bueno@bbva.com
*             Added new field arce__Customer__r.AccountNumber in the query of the method
*             getAccHasRelation
* |2019-30-19 mariohumberto.ramirez.contractor@bbva.com
*             Added new fields (arce__prop_int_mod_rec_type__c,arce__risk_unit_confirm_desc__c,
*             arce__contrast_risk_unit_type__c,arce__contrast_risk_unit_neg_desc__c,
*             arce__contrast_risk_unit_posi_desc__c) to the query in the method getAccHasAnalysis
* |2020-17-01 mariohumberto.ramirez.contractor@bbva.com
*             Change arce__Customer__r.ParentId for arce__group_asset_header_type__c in queries
* |2019-01-20 juanmanuel.perez.ortiz.contractor@bbva.com
*             Added new field (arce__group_asset_header_type__c) to the query in the method getAccHasRelation
* |2020-01-28 mariohumberto.ramirez.contractor@bbva.com
*             Add new fields in the method getAccHasAnalysis() 'arce__call_limit_service__c, arce__last_update_policie__c,
*             arce__last_update_position__c, arce__outstanding_carrousel__c'
* |2019-02-08 ricardo.almanza.contractor@bbva.com
*             adedd fields to getAccHasAnFromArce
* |2019-02-07 juanignacio.hita.contractor@bbva.com
*             Added methods setDeleteLogic and getListAHAWrapper
* |2019-02-17 manuelhugo.castillo.contractor@bbva.com
*             add methods 'getAHAbyArcePrep', 'createAnalizedClient'
* |2019-02-18 ricardo.almanza.contractor@bbva.com
*             adedd fields to getAccHasAnFromArce for override
* |2020-02-28 mariohumberto.contractor@bbva.com
*             Added new method getRelatedData
* |2020-03-09 eduardoefrain.hernandez.contractor@bbva.com
*             adedd methods because of Indepentent Rating (RAIP)
* |2020-03-09 eduardoefrain.hernandez.contractor@bbva.com
*             adedd group formalized and approved limit fields
* |2020-03-16 juanignacio.hita.contractor@bbva.com
*             adedd new method "getAllAccFromArce"
* |2020-03-30 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getAccHasAnById
* |2020-04-09 ricardo.almanza.contractor@bbva.com
*             modified getByARCEandClient to be used on triage
* |2020-04-14 mariohumberto.contractor@bbva.com
*             Added new fields in getAccHasAnalysis and getAccHasAnFromArce
* |2020-04-21 joseluis.garcia4.contractor@bbva.com
*             Added rating/prerating indicator to AHA query.
* |2020-04-27 ricardo.almanza.contractor@bbva.com
*             Added arce__customer_arce_scope_type__c to getAccHasAnalysis method.
* |2020-04-27 joseluis.garcia4.contractor@bbva.com
*             Added rating tool ID to AHA query.
* |2020-04-29 eduardoefrain.hernandez.contractor@bbva.com
*             Add fields to accHasAnByArce method
* |2020-05-04 juanmanuel.perez.ortiz.contractor@bbva.com
*             Add fields in accHasAnByArce method, create new methods called (accHasAnByIds,      getAccThirdPersonsData,getAccGeographiesData)
* |2020-05-06 joseluis.garcia4.contractor@bbva.com
*             Added primary analysis type to AHA query.
* |2020-06-01 joseluis.garcia4.contractor@bbva.com
*             adedd arce__currency_id__c to getAccHasRelation() method.
* |2020-06-11 juanignacio.hita.contractor@bbva.com
*             adedd arce__magnitude_unit_type__c, arce__currency_id__c to getAccHasAnFromArce() method.
* |2020-06-18 manuelhugo.castillo.contractor@bbva.com
*             Add new fields arce__gf_cmnt_fin_re_solv_co_desc__c,arce__cust_economic_position_desc__c in method 'accHasAnByIds'
* |2020-06-22 mariohumberto.ramirez.contractor@bbva.com
*             Add field 'arce__gf_cmnt_fin_re_solv_co_desc__c' in 'getAccHasRelation' method
* |2020-06-24 mariohumberto.ramirez.contractor@bbva.com
*             Add 'arce__currency_id__c' field in 'getAccHasAnFromArce' method
* |2020-06-24 juanmanuel.perez.ortiz.contractor@bbva.com
*             Added field in accHasAnByIds method
* |2020-06-26 eduardoefrain.hernandez.contractor@bbva.com
*             Add fields to getAccHasAnalysis method
* |2020-06-30 joseluis.garcia4.contractor@bbva.com
*             Add getAccHasAnalysisFields() method.
* |2020-07-02 javier.soto.carrascosa@bbva.com
*             Add fields to getAccHasRelation method
* |2020-07-09 mariohumberto.ramirez.contractor@bbva.com
*             Added arce__ffss_for_rating_id__r.arce__rating_long_value_type__c field to getAllAccFromArce method
* |2020-07-07 juanmanuel.perez.ortiz.contractor@bbva.com
*             Modified return in getCustomersData method
* |2020-07-10 ricardo.almanza.contractor@bbva.com
*             Added arce__analysis_template_id__c field to getAccHasAnalysis method
* |2020-07-23 juanmanuel.perez.ortiz.contractor@bbva.com
*             Added arce__Customer__r.OwnerId field to accHasAnByArce method
* |2020-07-24 ricardo.almanza.contractor@bbva.com
*             Added arce__Analysis__r.arce__triageStatus__c field to getAccHasAnalysis method
* |2020-07-27 mariohumberto.ramirez.contractor@bbva.com
*             Added getAccHasAnforRiskDetTable and getInfoforLeverTable methods
* |2020-07-28 joseluis.garcia4.contractor@bbva.com
*             Added arce__last_update_position__c field to getAccHasRelation method
* |2020-08-05 juanmanuel.perez.ortiz.contractor@bbva.com
*             Add arce__group_risk_detail_part_name__c,arce__gf_shareholders_detail_desc__c in accHasAnbyIds method
* |2020-08-11 javier.soto.carrascosa@bbva.com
*             Update sector field
* |2020-08-12 mariohumberto.ramirez.contractor@bbva.com
*             Add getAccMainBanksData and copyAccHasAnforReno methods
* |2020-08-25 mariohumberto.ramirez.contractor@bbva.com
*             Add new field arce__Analysis__c in getAllAccFromArce method
* |2020-08-24 eduardoefrain.hernandez.contractor@bbva.com
*             Add arce__anlys_wkfl_sub_process_type__c,arce__rating_prerating_type__c on getByARCEandClient method
* |2020-09-02 joseluis.garcia4.contractor@bbva.com
*             Add arce__analysis_customer_relation_type__c field to getAccHasAnalysis()/accHasAnByArce() methods.
* |2020-09-24 joseluis.garcia4.contractor@bbva.com
*             Add rating info to getAccHasAnalysis().
* |2020-09-24 eduardoefrain.hernandez.contractor@bbva.com
*             Add getAhaByRiskAssessment,getAhaGroupOfArce methods
* |2020-10-05 joseluis.garcia4.contractor@bbva.com
*             Add arce__anlys_wkfl_cnsld_ffss_type__c field to accHasAnByArce() query.
* |2020-10-13 eduardoefrain.hernandez.contractor@bbva.com
*             Delete accHasAnByIds method & Add copyAccHasAnforModification,separateListsByFFSSDate,validateFFSSAge,getDyFrmTabs methods
*             Update copyAccHasAnforReno method
* |2020-10-22 eduardoefrain.hernandez.contractor@bbva.com
*             Update getAhaByDyFrmFields method to exclude qualitative questions in the copy
* |2020-11-01 manuelhugo.castillo.contractor@bbva.com
*             Add fields in query (arce__cust_delay_payment_desc__c, arce__bureau_warning_prevention_desc__c,
*             arce__bureau_warn_prvnt_owner_desc__c,arce__bureau_warn_prvnt_action_desc__c
* |2020-11-13 joseluis.garcia4.contractor@bbva.com
*             added fields to getAccHasAnFromArce
* |2020-11-17 joseluis.garcia4.contractor@bbva.com
*             Use approved field arce__limit_exposure_ext_ind_type__c for extended policies indicator.
* |2020-11-18 juanignacio.hita.contractor@bbva.com
*             add arce__rating_scale_type__c,arce__short_rating_value_type__c fields to getAccHasAnFromArce method
*             add arce__rating_scale_type__c, arce__ffss_for_rating_id__r.arce__rating_final__c in getAccHasAnforRiskDetTable method
* |2020-11-24 juanignacio.hita.contractor@bbva.com
*             add arce__rating_scale_type__c fields to getAllAccFromArce method
* |2020-12-03 juanignacio.hita.contractor@bbva.com
*             Add Name in getAccHasAnFromArce method
* |2020-12-16 juanmanuel.perez.ortiz.contractor@bbva.com
*             Update getAhaByDyFrmFields to conditional to evaluate RENOVATION or MODIFICATION
* |2021-01-06 juanmanuel.perez.ortiz.contractor@bbva.com
*             Remove field references for unused fields (namings nivelation)
* |2021-01-07 eduardoefrain.hernandez.contractor@bbva.com
*             Remove field references for unused fields (namings nivelation)
* |2021-01-13 antonio.munoz.perez.contractor@bbva.com
*             Created getRatingAnalysis() method.
* |2021-01-12 juanignacio.hita.contractor@bbva.com
*             Add arce__bbva_committees_type__c and name fields to getAccHasAnFromArce method
* |2021-01-14 mariohumberto.ramirez.contractor@bbva.com
*             Added 'arce__ll_after_adj_ind_type__c' field to the query in getAccHasRelation method
* |2021-01-15 jose.hijar.contractor@bbva.com
*             Added some fields for overlay rating storie
* |2021-01-18 luisdavid.rivera.ortiz@bbva.com
*             Revome field references for usused fields (namings nivelation)
* |2021-01-21 juanignacio.hita.contractor@bbva.com
*             Added arce__ffss_for_rating_id__r.arce__rating_long_value_type__c,arce__ffss_for_rating_id__r.arce__magnitude_unit_type__c to
*             getAccHasAnFromArce method
* |2021-01-25 joseluis.garcia4.contractor@bbva.com
*             Added arce__ffss_for_rating_id__r.CurrencyIsoCode to getAccHasAnFromArce method
* |2021-01-20 saimassimilianno.jordana.contractor@bbva.com
*             Add arce__CustomAccountID__c field to all queries and add getCorrectIdWAhas and getCorrectIdWId meth0ds
* |2021-03-15 juanignacio.hita.contractor@bbva.com
*             Add arce__status_limit_pers_service__c field to getAccHasAnalysis method
* |2021-03-18 luisdavid.rivera.ortiz@bbva.com
*             Change arce__total_debt_amount__c to arce__gf_total_debt_amount__c in reference query
* |2021-03-24 eduardoefrain.hernandez.contractor@bbva.com
*             Add copying of autoretail table in modification and renovation - Add arce__year_id__c field
* |2021-04-16 jose.hijarcontractor@bbva.com
*             Add arce__IRP_Workflow__c field for query in getAccHasAnalysis method
* |2021-05-06 saimassimilianno.jordana.contractor@bbva.com
*             Add arce__IRP_Workflow__c field for query in accHasAnByArce method
* |2021-05-24 ronald.pisco.contractor@bbva.com
*             Add arce__gf_customer_cif_id__c,arce__gf_group_id__c,arce__gf_group_name__c in getAccThirdPersonsData method
* |2021-06-01 israel.rodriguez.ramos.contractor@bbva.com
*             Add arce__ffss_for_rating_id__r.arce__rating_long_value_type__c,arce__ffss_for_rating_id__r.arce__pd_per__c in accHasAnByArce method
* |2021-06-02 israel.rodriguez.ramos.contractor@bbva.com
*             Add arce__ffss_for_rating_id__r.arce__rating_long_value_type__c,arce__ffss_for_rating_id__r.arce__pd_per__c in getAccHasAnalysis method
* |2021-06-02 joseluis.garcia4.contractor@bbva.com
*             Add arce__rating_override_comment__c to query.
* |2021-06-14 juanignacio.hita.contractor@bbva.com
*             Revert changes pull request 33 and create new version
* |2021-06-29 juanignacio.hita.contractor@bbva.com
*             Added ffss.arce__financial_statement_end_date__c to getAccHasAnalysis method
* |2021-09-20 otiliaramona.veres.contractor@bbva.com
*             Added arce__ffss_for_rating_id__r.arce__ffss_certification_type__c  to getAccHasAnalysis method
* |2021-09-27 juanignacio.hita.contractor@bbva.com
*             Add rating arce__status_type__c field to getAccHasAnforRiskDetTable method
* |2021-10-11 juanignacio.hita.contractor@bbva.com
*             Add field to getAccHasAnalysis method
* |2021-05-11 juanignacio.hita.contractor@bbva.com
*             Adds ffss_for_rating_id__c to getAccHasAnforRiskDetTable method
* |2021-11-15 francisco.munoz.torres.contractor@bbva.com
*             Refactor getAhaByDyFrmFields and add arce__limit_exposure_ext_ind_type__c field to renovation and modification
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.ExcessivePublicCount, sf:TooManyMethods, sf:AvoidSoqlWithNegativeLogic, PMD.ExcessiveClassLength')
global without sharing class Arc_Gen_AccHasAnalysis_Data {
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 24/06/2019
    * @param void
    * @return void
    * @example Arc_Gen_AccHasAnalysis_Data data = new Arc_Gen_AccHasAnalysis_Data()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    global Arc_Gen_AccHasAnalysis_Data() {

    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of all fields in arce__Account_has_Analysis__c object
    * -----------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 24/06/2019
    * @param recordId - List of ids of the arce__Account_has_Analysis__c object to consult
    * @return List<arce__Account_has_Analysis__c> - List of all fields in arce__Account_has_Analysis__c object
    * @example getAccHasAnalysis(recordId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAccHasAnalysis(List<String> recordId) {
        return [SELECT id,arce__Analysis__r.OwnerId,arce__Analysis__r.arce__parent_analysis_id__c,arce__Analysis__r.arce__analysis_risk_sanction_date__c,arce__Analysis__r.arce__proposeUser__c,
        arce__ffss_for_rating_id__r.arce__financial_statement_id__c,arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c, arce__Analysis__r.arce__rating_prerating_type__c,arce__Analysis__r.arce__analysis_customer_relation_type__c,
        arce__ffss_for_rating_id__r.arce__rating_id__c,arce__ffss_for_rating_id__r.arce__rating_id__r.arce__rating_id__c,arce__ffss_for_rating_id__r.arce__rating_final__c,arce__Account_has_Analysis__c.arce__branch_id__c,
        arce__economic_activity_sector_desc__c,arce__gf_company_economic_actvy_id__c,arce__current_formalized_amount__c,arce__last_approved_amount__c,arce__Analysis__r.arce__Group__c,
        arce__adj_long_rating_value_id__c,arce__adj_total_rating_score_number__c,arce__IRP_Workflow__c,
        arce__ll_adj_ebitda_amount__c,arce__ll_adj_debt_amount__c,arce__persistance_callback_status_type__c,
        arce__Analysis__c,arce__significant_variables_type__c,arce__stage_collective_ind_type__c,
        arce__ffss_for_rating_id__r.arce__ffss_valid_type__c,arce__Customer__r.AccountNumber,
        arce__limit_asset_allocation_amount__c,arce__data_adjusted_score_number__c,arce__ll_adj_debt_auditor_amount__c,
        arce__ll_adj_ebitda_auditor_amount__c,arce__cust_evolution_cyr_ind_type__c,arce__backlog_desc__c,arce__backlog_sales_desc__c,
        arce__bbva_financial_debt_share_per__c,arce__cust_budget_cyr_ind_type__c,arce__ffss_auditor_qlfn_type__c,
        arce__backlog_less_70_per_type__c,arce__backlog_less_70_per_desc__c,arce__enterprise_group_type__c,
        arce__enterprise_group_desc__c,arce__ll_test_scope_ind_type__c,arce__ebitda_less_70_peer_avg_desc__c,arce__ebitda_less_70_peer_avg_type__c,
        arce__level_concentration_geo_type__c,arce__sales_less_70_peer_avg_desc__c,arce__sales_less_70_peer_avg_type__c,
        arce__cust_public_private_cmprn_desc__c,arce__cust_proj_2yr_3yr_desc__c,arce__significant_variables_desc__c,
        arce__cust_evolution_cyr_desc__c,arce__Syn_expct_evol_short_term_txt__c,arce__off_balance_rlvnt_info_desc__c,
        arce__off_balance_treasury_desc__c,arce__Syn_client_situation_txt__c,arce__regulated_sector_desc__c,arce__exch_rate_vulnerability_desc__c,
        arce__competition_sector_desc__c,arce__level_conc_sector_desc__c,arce__level_concentration_geo_desc__c,
        arce__bbva_financial_debt_share_desc__c,arce__cust_budget_incl_ffss_desc__c,arce__co_actvy_prtcp_group_desc__c,
        arce__cust_contract_capacity_desc__c,arce__gf_covenant_desc__c,arce__fin_aggressiveness_mngmt_desc__c,
        arce__gntee_given_backlog_range_desc__c,arce__guarantee_given_desc__c,arce__struct_change_invst_desc__c,
        arce__shrhldr_Financialsponsor_profile_desc__c,arce__management_style_desc__c,arce__other_operation_desc__c,
        arce__other_contracted_product_desc__c,arce__shareholder_disagreement_desc__c,arce__capital_provision_desc__c,
        arce__rar_profitability_desc__c,arce__RAR_rating_tool_id__c,arce__anlys_wkfl_cnsld_ffss_type__c,arce__investment_relevant_fact_desc__c,arce__client_refinanced_desc__c,
        arce__shareholder_agreement_desc__c,arce__shrhldr_sig_movement_desc__c,arce__stage_collective_desc__c,
        arce__risk_position_summary_type__c,arce__shareholder_support_desc__c,arce__breakdown_activity_desc__c,
        arce__breakdown_geography_desc__c,arce__risk_position_summary_desc__c,arce__debt_comt_not_disb_amount__c,
        arce__debt_comt_not_disb_local_amount__c,arce__entity_covenants_type__c,
        CreatedById,CurrencyIsoCode,arce__outstanding_amount__c,arce__current_proposed_amount__c,arce__ffss_for_rating_id__r.currencyIsoCode,
        arce__current_proposed_local_amount__c,arce__Customer__c,arce__customer_multi_country_type__c,arce__customer_multi_country_desc__c,
        arce__arce_ctmr_flag__c,arce__cust_conc_clients_desc__c,arce__prev_magnitude_unit_type__c,arce__limit_asset_allocation_date__c,
        arce__exposure_at_default_date__c,arce__bbva_avg_prblty_default_date__c,arce__cust_prblty_default_date__c,
        arce__sector_avg_prblty_dflt_date__c,arce__ll_adj_deb_excl_amount__c,arce__ll_acquisition_debt_type__c,
        arce__competition_sector_type__c,arce__level_conc_sector_type__c,arce__market_situation_desc__c,arce__cust_conc_clients_type__c,
        arce__concentration_suppliers_type__c,arce__Funds_destination_type__c,arce__banking_pool_desc__c,arce__ead_amount__c,
        arce__ll_adj_ebitda_excl_amount__c,arce__economic_capital_amount__c,arce__ffss_submitted_type__c,arce__limit_exposure_ext_ind_type__c,
        arce__equity_total_asset_20_type__c,arce__Syn_equity_type__c,arce__equity_desc__c,arce__cost_structure_desc__c,
        arce__Syn_expct_evol_short_term_type__c,arce__ebitda_3yr_evolution_desc__c,
        arce__sales_evolution_desc__c,arce__account_payable_desc__c,arce__explantation_margin_desc__c,
        arce__export_range_year_type__c,arce__long_rating_value_id__c,arce__rating_short_value_type__c,
        arce__fin_covenants_breach_type__c,arce__fin_covenants_breach_desc__c,
        arce__fin_spnsr_relnshp_exprnc_type__c,arce__fin_spnsr_relnshp_exprnc_desc__c,arce__shrhldr_fin_sponsor_profl_type__c,
        arce__shrhldr_fin_sponsor_strat_type__c,arce__ffss_for_rating_id__c,arce__gl_fixed_asset_amount__c,
        arce__financial_flexibility_type__c,arce__manual_rating_value_type__c,arce__oper_guarantee_given_type__c,
        arce__conc_geography_activity_type__c,arce__gross_financial_debt_amount__c,arce__gross_financial_debt_local_amount__c,
        arce__gross_fin_debt_ebitda_number__c,arce__group_asset_header_type__c,arce__hats_risk_qualification_number__c,
        arce__sector_building_desc__c,arce__import_range_year_type__c,arce__InReview__c,
        arce__investment_relevant_fact_type__c,arce__off_balance_rlvnt_info_type__c,arce__ebitda_interest_number__c,
        arce__ebitda_interest_local_number__c,arce__invty_work_in_progress_desc__c,arce__struct_change_invst_type__c,LastModifiedById,
        arce__customer_last_projects_desc__c,arce__participant_leveraged_type__c,arce__ll_after_adj_ind_type__c,arce__ll_before_adj_ind_type__c,
        arce__ll_previous_anlys_ind_type__c,arce__ll_previous_anlys_clsfn_type__c,arce__ll_after_adj_clsfn_type__c,arce__ll_collective_type__c,
        arce__ll_before_adj_clsfn_type__c,arce__ll_test_manl_excl_rsn_type__c,arce__lgd_per__c,arce__financial_liquidity_desc__c,
        arce__main_affiliates_desc__c,arce__property_ownership_type__c,arce__main_subsidiary_ind_type__c,arce__years_experience_mngmt_type__c,
        arce__years_experience_mngmt_desc__c,arce__fin_aggressiveness_mngmt_type__c,arce__management_style_type__c,
        arce__market_growth_forecast_desc__c,arce__market_share_type__c,arce__maturity_date__c,
        arce__debt_maturity_available_type__c,Name,arce__newFFSS_ind__c,arce__ffss_auditor_fullname_name__c,arce__number_entity_type__c,
        arce__dvrsfn_product_service_desc__c,arce__dvrsfn_product_service_type__c,arce__assessment_opportunities_desc__c,
        arce__ll_other_adj_debt_amount__c,arce__ll_other_adj_ebitda_amount__c,arce__other_contracted_product_type__c,
        arce__other_operation_type__c,arce__geography_outlook_type__c,arce__path__c,
        arce__probability_default_per__c,arce__sector_avg_prblty_default_per__c,arce__Peer_information_ind_type__c,
        arce__ffss_cnsld_perimeter_desc__c,arce__risk_policy_type__c,arce__off_balance_treasury_type__c,arce__portfolio_class_type__c,
        arce__shareholder_disagreement_type__c,arce__cust_budget_incl_ffss_ind_type__c,arce__pd_per__c,arce__property_ownership_desc__c,
        arce__capital_provision_per__c,arce__cust_proj_2yr_3yr_ind_type__c,arce__smes_eur_comuty_defn_type__c,arce__customer_qualitative_type__c,
        arce__rar_profitability_per__c,arce__long_rating_value_type__c,arce__short_rating_value_type__c,arce__rating_model_type__c,
        arce__rating_scale_type__c,arce__total_rating_score_number__c,arce__ll_adj_debt_ebitda_number__c,arce__gntee_given_backlog_range_type__c,
        arce__total_debt_ebitda_per__c,arce__regulated_sector_type__c,arce__other_relevant_fact_type__c,arce__new_business_venture_type__c,
        arce__new_business_venture_desc__c,arce__other_relevant_fact_desc__c,arce__client_refinanced_type__c,arce__risk_request_desc__c,
        arce__risk_growth_amount__c,arce__sector_desc__c,arce__sector_outlook_type__c,arce__rating_econ_sector_tmpl_id__c,
        arce__service_type_name__c,arce__cust_multi_business_line_type__c,arce__shareholder_agreement_type__c,
        arce__shrhldr_sig_movement_type__c,arce__client_situation_type__c,arce__Stage__c,arce__stage_collective_type__c,
        arce__assessment_strengths_desc__c,arce__subsector_desc__c,arce__shareholder_support_type__c,arce__cust_contract_capacity_type__c,
        arce__cust_contract_category_type__c,arce__assessment_threats_desc__c,arce__ffss_auditor_opinion_type__c,arce__ffss_certification_type__c,
        arce__ffss_auditor_opinion_desc__c,arce__currency_id__c,arce__total_asset_amount__c,arce__total_asset_local_amount__c,arce__gf_total_debt_amount__c,
        arce__gf_total_revenues_ytd_amount__c,arce__total_revenues_local_amount__c,arce__customer_product_usage_desc__c,arce__Institution_type__c,
        arce__magnitude_unit_type__c,arce__var_over_20_balance_desc__c,arce__var_vary_10_and_10_bal_desc__c,arce__variables_vary_20_balance_desc__c,
        arce__equity_vary_not_expln_desc__c,arce__ll_anlys_clsfn_var_rsn_id__c,arce__total_revenuesvariation_percentage__c,
        arce__exch_rate_vulnerability_type__c,arce__assessment_weaknesses_desc__c,arce__anlys_wkfl_sbanlys_status_type__c,arce__WF_Stage_WF_Status__c,
        arce__gf_backlog_sales_cyr_number__c,arce__gf_backlog_sales_pyr_number__c,arce__gf_backlog_pending_cyr_amount__c,arce__gf_backlog_pending_pyr_amount__c,
        arce__prop_int_mod_rec_type__c,arce__risk_unit_confirm_desc__c,arce__contrast_risk_unit_type__c,arce__contrast_risk_unit_neg_desc__c,arce__contrast_risk_unit_posi_desc__c,
        arce__Analysis__r.arce__wf_status_id__c,arce__Analysis__r.arce__Stage__c,arce__call_limit_service__c,arce__last_update_policie__c,arce__last_update_position__c,arce__outstanding_carrousel__c,
        arce__gf_market_share_desc__c,arce__mngmt_aggressiveness_type__c,arce__adj_long_rating_value_type__c,arce__rating_override_reason_desc__c,arce__rating_override_comment__c,arce__Is_Deleted__c,arce__customer_arce_scope_type__c,
        arce__currency_fin_info_gp_val__c,arce__unit_fin_info_gp_val__c,arce__year_fin_info_gp_val__c,arce__currency_fin_info_gp_prev__c,arce__unit_fin_info_gp_prev__c,arce__year_fin_info_gp_prev__c,
        arce__long_rating_value_prev_year_id__c,arce__debt_maturity_desc__c,arce__dependency_degree_cust_type__c,arce__analysis_template_id__c,
        arce__Analysis__r.arce__triageStatus__c,arce__cust_delay_payment_desc__c, arce__bureau_warning_prevention_desc__c,arce__bureau_warn_prvnt_owner_desc__c,
        arce__bureau_warn_prvnt_action_desc__c, arce__CustomAccountID__c, arce__arce_Gen_ExceptionsParrilla__c, arce__status_limit_pers_service__c,arce__year_id__c,arce__g_rtg_tool_typ_id__c,
        arce__ffss_for_rating_id__r.arce__rating_long_value_type__c, arce__ffss_for_rating_id__r.arce__pd_per__c, arce__ffss_for_rating_id__r.arce__financial_statement_end_date__c,arce__ffss_for_rating_id__r.arce__ffss_certification_type__c
                FROM arce__Account_has_Analysis__c
                WHERE Id = :recordId];
    }
    /**
    * -------------------------------------------------------------------------------------------------------
    * @Description - Method that returns the specified fields in arce__Account_has_Analysis__c
    * -------------------------------------------------------------------------------------------------------
    * @Author   joseluis.garcia4.contractor@bbva.com
    * @Date     Created: 30/06/2020
    * @param ahaId - id of the arce__Account_has_Analysis__c object to consult
    * @param fieldList - List of the API names of the fields to be retrieved.
    * @return the retrieved AHA record or null if no such record exists.
    * -------------------------------------------------------------------------------------------------------
    **/
    global static arce__Account_has_Analysis__c getAccHasAnalysisFields(String ahaId, List<String> fieldList) {
        arce__Account_has_Analysis__c result = null;   //NOSONAR
        if (!fieldList.isEmpty()) {
            final String fieldListStr = String.escapeSingleQuotes(String.join(fieldList, ','));
            final String query = 'SELECT ' + fieldListStr + ' FROM arce__Account_has_Analysis__c WHERE Id = :ahaId';
            final List<SObject> resultList = Database.query(query);
            if (!resultList.isEmpty()) {
                result = (arce__Account_has_Analysis__c) resultList[0];
            }
        }
        return result;
    }
    /**
    * -------------------------------------------------------------------------------------------------------
    * @Description - Method that return some related fields in arce__Account_has_Analysis__c
    * -------------------------------------------------------------------------------------------------------
    * @Author   eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 24/06/2019
    * @param recordId - id of the arce__Account_has_Analysis__c object to consult
    * @return arce__Account_has_Analysis__c - Object with all related fields in arce__Account_has_Analysis__c
    * @example getAccHasAnalysis(recordId)
    * -------------------------------------------------------------------------------------------------------
    **/
    global static List<Arc_Gen_Account_Has_Analysis_Wrapper> getByARCEandClient(String idARCE, List<String> customerNumbers) {
        List<arce__Account_has_Analysis__c> listAHA = [SELECT Id,arce__Analysis__r.OwnerId,arce__Analysis__r.arce__parent_analysis_id__c,arce__Analysis__r.arce__analysis_risk_sanction_date__c,
        arce__ffss_for_rating_id__r.arce__financial_statement_id__c,arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c,arce__Analysis__r.arce__rating_prerating_type__c,
        arce__ffss_for_rating_id__r.arce__rating_id__c,arce__Account_has_Analysis__c.arce__branch_id__c,arce__Analysis__r.arce__Group__c,
        arce__Customer__r.AccountNumber,arce__adj_long_rating_value_type__c,arce__adj_short_rating_value_type__c,arce__adj_total_rating_score_number__c,
        arce__ll_adj_ebitda_amount__c,arce__ll_adj_debt_amount__c,arce__analysis_template_id__c,
        arce__Analysis__c,arce__Syn_significant_extraordinary_variab__c,
        arce__limit_asset_allocation_amount__c,arce__data_adjusted_score_number__c,arce__ll_adj_debt_auditor_amount__c,
        arce__ll_adj_ebitda_auditor_amount__c,arce__backlog_desc__c,arce__backlog_sales_desc__c,
        arce__bbva_financial_debt_share_per__c,
        arce__backlog_less_70_per_type__c,arce__backlog_less_70_per_desc__c,arce__participant_group_type__c,
        arce__ll_test_scope_ind_type__c,arce__level_concentration_geo_type__c,
        arce__Syn_expct_evol_short_term_txt__c,arce__Syn_client_situation_txt__c,arce__regulated_sector_desc__c,arce__exch_rate_vulnerability_desc__c,
        arce__competition_sector_desc__c,arce__level_conc_sector_desc__c,arce__level_concentration_geo_desc__c,
        arce__bbva_financial_debt_share_desc__c,arce__co_actvy_prtcp_group_desc__c,
        arce__cust_contract_capacity_desc__c,arce__guarantee_given_desc__c,arce__struct_change_invst_desc__c,
        arce__shrhldr_Financialsponsor_profile_desc__c,arce__management_style_desc__c,arce__other_operation_desc__c,
        arce__other_contracted_product_desc__c,arce__shareholder_disagreement_desc__c,arce__capital_provision_desc__c,
        arce__rar_profitability_desc__c,arce__investment_relevant_fact_desc__c,
        arce__shareholder_agreement_desc__c,arce__shrhldr_sig_movement_desc__c,arce__stage_collective_desc__c,
        arce__risk_position_summary_type__c,arce__shareholder_support_desc__c,arce__breakdown_activity_desc__c,
        arce__breakdown_geography_desc__c,arce__risk_position_summary_desc__c,arce__debt_comt_not_disb_amount__c,
        arce__debt_comt_not_disb_local_amount__c,arce__entity_covenants_type__c,
        CreatedById,CurrencyIsoCode,arce__outstanding_amount__c,arce__current_proposed_amount__c,
        arce__current_proposed_local_amount__c,arce__Customer__c,arce__customer_multi_country_type__c,arce__customer_multi_country_desc__c,
        arce__arce_ctmr_flag__c,arce__cust_conc_clients_desc__c,arce__magnitude_unit_type__c,arce__prev_magnitude_unit_type__c,arce__limit_asset_allocation_date__c,
        arce__exposure_at_default_date__c,arce__bbva_avg_prblty_default_date__c,arce__cust_prblty_default_date__c,
        arce__sector_avg_prblty_dflt_date__c,arce__ll_adj_deb_excl_amount__c,arce__ll_acquisition_debt_type__c,
        arce__competition_sector_type__c,arce__level_conc_sector_type__c,arce__market_situation_desc__c,arce__cust_conc_clients_type__c,
        arce__concentration_suppliers_type__c,arce__Funds_destination_type__c,arce__banking_pool_desc__c,arce__ead_amount__c,
        arce__ll_adj_ebitda_excl_amount__c,arce__economic_capital_amount__c,arce__ffss_submitted_type__c,arce__limit_exposure_ext_ind_type__c,
        arce__Syn_equity_type__c,arce__equity_desc__c,arce__Syn_expct_evol_short_term_type__c,arce__arce_Gen_ExceptionsParrilla__c,
        arce__sales_evolution_desc__c,arce__explantation_margin_desc__c,
        arce__export_range_year_type__c,arce__rating_long_value_type__c,arce__rating_short_value_type__c,
        arce__fin_covenants_breach_type__c,arce__fin_covenants_breach_desc__c,
        arce__fin_spnsr_relnshp_exprnc_type__c,arce__fin_spnsr_relnshp_exprnc_desc__c,
        arce__ffss_for_rating_id__c,arce__gl_fixed_asset_amount__c,
        arce__gross_financial_debt_amount__c,arce__gross_financial_debt_local_amount__c,
        arce__gross_fin_debt_ebitda_number__c,arce__group_asset_header_type__c,arce__hats_risk_qualification_number__c,
        arce__sector_building_desc__c,arce__import_range_year_type__c,arce__InReview__c,
        arce__investment_relevant_fact_type__c,arce__ebitda_interest_number__c,
        arce__ebitda_interest_local_number__c,arce__invty_work_in_progress_desc__c,arce__struct_change_invst_type__c,
        LastModifiedById,arce__customer_last_projects_desc__c,arce__participant_leveraged_type__c,arce__ll_after_adj_ind_type__c,arce__ll_before_adj_ind_type__c,
        arce__ll_previous_anlys_ind_type__c,arce__ll_previous_anlys_clsfn_type__c,arce__ll_after_adj_clsfn_type__c,arce__ll_collective_type__c,
        arce__ll_before_adj_clsfn_type__c,arce__ll_test_manl_excl_rsn_type__c,arce__lgd_per__c,arce__financial_liquidity_desc__c,arce__main_affiliates_desc__c,
        arce__main_subsidiary_ind_type__c,arce__mngmt_aggressiveness_type__c,arce__market_growth_forecast_desc__c,arce__market_share_type__c,arce__maturity_date__c,
        arce__debt_maturity_available_type__c,Name,arce__newFFSS_ind__c,arce__ffss_auditor_fullname_name__c,arce__number_entity_type__c,
        arce__dvrsfn_product_service_type__c,arce__assessment_opportunities_desc__c,arce__ll_other_adj_debt_amount__c,
        arce__ll_other_adj_ebitda_amount__c,arce__other_contracted_product_type__c,arce__other_operation_type__c,arce__geography_outlook_type__c,
        arce__path__c,arce__probability_default_per__c,arce__sector_avg_prblty_default_per__c,
        arce__Peer_information_ind_type__c,arce__ffss_cnsld_perimeter_desc__c,arce__risk_policy_type__c,arce__Portfolio_class_type__c,
        arce__shareholder_disagreement_type__c,arce__pd_per__c,arce__capital_provision_per__c,arce__AFAS_projection_type__c,
        arce__customer_qualitative_type__c,arce__rar_profitability_per__c,arce__long_rating_value_type__c,
        arce__short_rating_value_type__c,arce__rating_model_type__c,arce__rating_scale_type__c,arce__total_rating_score_number__c,arce__ll_adj_debt_ebitda_number__c,
        arce__gntee_given_backlog_range_type__c,arce__total_debt_ebitda_per__c,arce__regulated_sector_type__c,arce__other_relevant_fact_type__c,
        arce__new_business_venture_type__c,arce__new_business_venture_desc__c,arce__other_relevant_fact_desc__c,
        arce__risk_request_desc__c,arce__risk_growth_amount__c,arce__sector_desc__c,arce__sector_outlook_type__c,
        arce__service_type_name__c,arce__cust_multi_business_line_type__c,arce__shareholder_agreement_type__c,arce__shrhldr_sig_movement_type__c,
        arce__client_situation_type__c,arce__Stage__c,arce__stage_collective_type__c,arce__assessment_strengths_desc__c,
        arce__subsector_desc__c,arce__shareholder_support_type__c,
        arce__cust_contract_capacity_type__c,arce__cust_contract_category_type__c,arce__assessment_threats_desc__c,arce__ffss_auditor_opinion_type__c,
        arce__ffss_certification_type__c,arce__ffss_auditor_opinion_desc__c,arce__currency_id__c,arce__total_asset_amount__c,arce__total_asset_local_amount__c,
        arce__gf_total_debt_amount__c,arce__total_revenues_local_amount__c,arce__customer_product_usage_desc__c,
        arce__Institution_type__c,arce__var_over_20_balance_desc__c,arce__var_vary_10_and_10_bal_desc__c,
        arce__total_revenuesvariation_percentage__c,arce__CustomAccountID__c,
        arce__exch_rate_vulnerability_type__c,arce__assessment_weaknesses_desc__c,arce__anlys_wkfl_sbanlys_status_type__c,arce__WF_Stage_WF_Status__c
        FROM arce__Account_has_Analysis__c WHERE arce__Analysis__c =: idARCE];
        List<Arc_Gen_Account_Has_Analysis_Wrapper> listAHAWrapper = getListAHAWrapper(listAHA);
        List<Arc_Gen_Account_Has_Analysis_Wrapper> listAHAWFiltered = new List<Arc_Gen_Account_Has_Analysis_Wrapper>();
        for(Arc_Gen_Account_Has_Analysis_Wrapper aha : listAHAWrapper) {
            if(customerNumbers.contains(aha.accWrapperObj.accNumber)) {
                listAHAWFiltered.add(aha);
            }
        }
        Return listAHAWFiltered;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Todos los Account Has Analysis relacionados  a un ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author  eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 24/06/2019
    * @param analysisId - Standard Id of the ARCE analysis
    * @return List<arce__Account_has_Analysis__c> - List of analyzed clients (Chromes)
    * @example List<arce__Account_has_Analysis__c> ex = Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(String analysisId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> accHasAnByArce(List<String> analysisId) {
        return [SELECT arce__Customer__r.OwnerId,arce__Customer__r.Name,arce__Analysis__r.OwnerId,arce__Analysis__r.arce__parent_analysis_id__c,arce__Analysis__r.arce__analysis_risk_sanction_date__c,arce__Analysis__r.arce__analysis_customer_relation_type__c,
        arce__ffss_for_rating_id__r.arce__financial_statement_id__c,arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c,arce__Analysis__r.arce__rating_prerating_type__c,
        arce__ffss_for_rating_id__r.arce__rating_id__c,arce__Account_has_Analysis__c.arce__branch_id__c,arce__participant_srty_age_number__c,
        arce__economic_activity_sector_desc__c,arce__gf_company_economic_actvy_id__c,arce__current_formalized_amount__c,arce__last_approved_amount__c,
        arce__adj_long_rating_value_id__c,arce__adj_total_rating_score_number__c,
        arce__ll_adj_ebitda_amount__c,arce__ll_adj_debt_amount__c,arce__analysis_template_id__c,
        arce__Analysis__c,arce__significant_variables_type__c,arce__Analysis__r.arce__Group__c,
        arce__limit_asset_allocation_amount__c,arce__data_adjusted_score_number__c,arce__ll_adj_debt_auditor_amount__c,
        arce__ll_adj_ebitda_auditor_amount__c,arce__cust_evolution_cyr_ind_type__c,arce__backlog_desc__c,arce__backlog_sales_desc__c,
        arce__bbva_financial_debt_share_per__c,arce__cust_budget_cyr_ind_type__c,arce__ffss_auditor_qlfn_type__c,
        arce__backlog_less_70_per_type__c,arce__backlog_less_70_per_desc__c,arce__enterprise_group_type__c,
        arce__enterprise_group_desc__c,arce__ll_test_scope_ind_type__c,arce__ebitda_less_70_peer_avg_desc__c,arce__ebitda_less_70_peer_avg_type__c,
        arce__level_concentration_geo_type__c,arce__sales_less_70_peer_avg_desc__c,arce__sales_less_70_peer_avg_type__c,
        arce__cust_public_private_cmprn_desc__c,arce__cust_proj_2yr_3yr_desc__c,arce__significant_variables_desc__c,
        arce__cust_evolution_cyr_desc__c,arce__Syn_expct_evol_short_term_txt__c,arce__off_balance_rlvnt_info_desc__c,
        arce__off_balance_treasury_desc__c,arce__Syn_client_situation_txt__c,arce__regulated_sector_desc__c,arce__exch_rate_vulnerability_desc__c,
        arce__competition_sector_desc__c,arce__level_conc_sector_desc__c,arce__level_concentration_geo_desc__c,
        arce__bbva_financial_debt_share_desc__c,arce__cust_budget_incl_ffss_desc__c,arce__co_actvy_prtcp_group_desc__c,
        arce__cust_contract_capacity_desc__c,arce__gf_covenant_desc__c,arce__fin_aggressiveness_mngmt_desc__c,
        arce__gntee_given_backlog_range_desc__c,arce__guarantee_given_desc__c,arce__struct_change_invst_desc__c,
        arce__shrhldr_Financialsponsor_profile_desc__c,arce__management_style_desc__c,arce__other_operation_desc__c,
        arce__other_contracted_product_desc__c,arce__shareholder_disagreement_desc__c,arce__capital_provision_desc__c,
        arce__rar_profitability_desc__c,arce__investment_relevant_fact_desc__c,arce__client_refinanced_desc__c,
        arce__shareholder_agreement_desc__c,arce__shrhldr_sig_movement_desc__c,arce__stage_collective_desc__c,
        arce__risk_position_summary_type__c,arce__shareholder_support_desc__c,arce__breakdown_activity_desc__c,
        arce__breakdown_geography_desc__c,arce__risk_position_summary_desc__c,arce__debt_comt_not_disb_amount__c,
        arce__debt_comt_not_disb_local_amount__c,arce__entity_covenants_type__c,
        CreatedById,CurrencyIsoCode,arce__outstanding_amount__c,arce__anlys_wkfl_cnsld_ffss_type__c,arce__current_proposed_amount__c,
        arce__current_proposed_local_amount__c,arce__Customer__c,arce__customer_multi_country_type__c,arce__customer_multi_country_desc__c,
        arce__arce_ctmr_flag__c,arce__cust_conc_clients_desc__c,arce__prev_magnitude_unit_type__c,arce__limit_asset_allocation_date__c,
        arce__exposure_at_default_date__c,arce__bbva_avg_prblty_default_date__c,arce__cust_prblty_default_date__c,
        arce__sector_avg_prblty_dflt_date__c,arce__ll_adj_deb_excl_amount__c,arce__ll_acquisition_debt_type__c,
        arce__competition_sector_type__c,arce__level_conc_sector_type__c,arce__market_situation_desc__c,arce__cust_conc_clients_type__c,
        arce__concentration_suppliers_type__c,arce__Funds_destination_type__c,arce__banking_pool_desc__c,arce__ead_amount__c,
        arce__ll_adj_ebitda_excl_amount__c,arce__economic_capital_amount__c,arce__ffss_submitted_type__c,arce__limit_exposure_ext_ind_type__c,
        arce__equity_total_asset_20_type__c,arce__Syn_equity_type__c,arce__equity_desc__c,arce__cost_structure_desc__c,
        arce__Syn_expct_evol_short_term_type__c,arce__arce_Gen_ExceptionsParrilla__c,arce__ebitda_3yr_evolution_desc__c,
        arce__sales_evolution_desc__c,arce__account_payable_desc__c,arce__explantation_margin_desc__c,
        arce__export_range_year_type__c,arce__long_rating_value_id__c,arce__rating_short_value_type__c,
        arce__fin_covenants_breach_type__c,arce__fin_covenants_breach_desc__c,
        arce__fin_spnsr_relnshp_exprnc_type__c,arce__fin_spnsr_relnshp_exprnc_desc__c,arce__shrhldr_fin_sponsor_profl_type__c,
        arce__shrhldr_fin_sponsor_strat_type__c,arce__ffss_for_rating_id__c,arce__gl_fixed_asset_amount__c,
        arce__financial_flexibility_type__c,arce__manual_rating_value_type__c,arce__oper_guarantee_given_type__c,
        arce__conc_geography_activity_type__c,arce__gross_financial_debt_amount__c,arce__gross_financial_debt_local_amount__c,
        arce__gross_fin_debt_ebitda_number__c,arce__group_asset_header_type__c,arce__hats_risk_qualification_number__c,
        arce__sector_building_desc__c,arce__import_range_year_type__c,arce__InReview__c,
        arce__investment_relevant_fact_type__c,arce__off_balance_rlvnt_info_type__c,arce__ebitda_interest_number__c,
        arce__ebitda_interest_local_number__c,arce__invty_work_in_progress_desc__c,arce__struct_change_invst_type__c,LastModifiedById,
        arce__customer_last_projects_desc__c,arce__participant_leveraged_type__c,arce__ll_after_adj_ind_type__c,arce__ll_before_adj_ind_type__c,
        arce__ll_previous_anlys_ind_type__c,arce__ll_previous_anlys_clsfn_type__c,arce__ll_after_adj_clsfn_type__c,arce__ll_collective_type__c,
        arce__ll_before_adj_clsfn_type__c,arce__ll_test_manl_excl_rsn_type__c,arce__lgd_per__c,arce__financial_liquidity_desc__c,
        arce__main_affiliates_desc__c,arce__property_ownership_type__c,arce__main_subsidiary_ind_type__c,arce__years_experience_mngmt_type__c,
        arce__years_experience_mngmt_desc__c,arce__fin_aggressiveness_mngmt_type__c,arce__management_style_type__c,
        arce__market_growth_forecast_desc__c,arce__market_share_type__c,arce__maturity_date__c,
        arce__debt_maturity_available_type__c,Name,arce__newFFSS_ind__c,arce__ffss_auditor_fullname_name__c,arce__number_entity_type__c,
        arce__dvrsfn_product_service_desc__c,arce__dvrsfn_product_service_type__c,arce__assessment_opportunities_desc__c,
        arce__ll_other_adj_debt_amount__c,arce__ll_other_adj_ebitda_amount__c,arce__other_contracted_product_type__c,
        arce__other_operation_type__c,arce__geography_outlook_type__c,arce__path__c,
        arce__probability_default_per__c,arce__sector_avg_prblty_default_per__c,arce__Peer_information_ind_type__c,
        arce__ffss_cnsld_perimeter_desc__c,arce__risk_policy_type__c,arce__off_balance_treasury_type__c,arce__portfolio_class_type__c,
        arce__shareholder_disagreement_type__c,arce__cust_budget_incl_ffss_ind_type__c,arce__pd_per__c,arce__property_ownership_desc__c,
        arce__capital_provision_per__c,arce__cust_proj_2yr_3yr_ind_type__c,arce__smes_eur_comuty_defn_type__c,arce__customer_qualitative_type__c,
        arce__rar_profitability_per__c,arce__long_rating_value_type__c,arce__short_rating_value_type__c,arce__rating_model_type__c,
        arce__rating_scale_type__c,arce__total_rating_score_number__c,arce__ll_adj_debt_ebitda_number__c,arce__gntee_given_backlog_range_type__c,
        arce__total_debt_ebitda_per__c,arce__regulated_sector_type__c,arce__other_relevant_fact_type__c,arce__new_business_venture_type__c,
        arce__new_business_venture_desc__c,arce__other_relevant_fact_desc__c,arce__client_refinanced_type__c,arce__risk_request_desc__c,
        arce__risk_growth_amount__c,arce__sector_desc__c,arce__sector_outlook_type__c,arce__rating_econ_sector_tmpl_id__c,
        arce__service_type_name__c,arce__cust_multi_business_line_type__c,arce__shareholder_agreement_type__c,
        arce__shrhldr_sig_movement_type__c,arce__client_situation_type__c,arce__Stage__c,arce__stage_collective_type__c,
        arce__assessment_strengths_desc__c,arce__subsector_desc__c,arce__shareholder_support_type__c,
        arce__cust_contract_capacity_type__c,
        arce__cust_contract_category_type__c,arce__assessment_threats_desc__c,arce__ffss_auditor_opinion_type__c,arce__ffss_certification_type__c,
        arce__ffss_auditor_opinion_desc__c,arce__currency_id__c,arce__total_asset_amount__c,arce__total_asset_local_amount__c,arce__gf_total_debt_amount__c,
        arce__gf_total_revenues_ytd_amount__c,arce__total_revenues_local_amount__c,arce__customer_product_usage_desc__c,arce__Institution_type__c,
        arce__magnitude_unit_type__c,arce__var_over_20_balance_desc__c,arce__var_vary_10_and_10_bal_desc__c,arce__variables_vary_20_balance_desc__c,
        arce__equity_vary_not_expln_desc__c,arce__ll_anlys_clsfn_var_rsn_id__c,arce__total_revenuesvariation_percentage__c,
        arce__exch_rate_vulnerability_type__c,arce__assessment_weaknesses_desc__c,arce__anlys_wkfl_sbanlys_status_type__c,arce__WF_Stage_WF_Status__c,
        arce__gf_backlog_sales_cyr_number__c,arce__gf_backlog_sales_pyr_number__c,arce__gf_backlog_pending_cyr_amount__c,arce__gf_backlog_pending_pyr_amount__c,
        arce__prop_int_mod_rec_type__c,arce__risk_unit_confirm_desc__c,arce__contrast_risk_unit_type__c,arce__contrast_risk_unit_neg_desc__c,arce__contrast_risk_unit_posi_desc__c,
        arce__Analysis__r.arce__wf_status_id__c,arce__Analysis__r.arce__Stage__c, arce__CustomAccountID__c,arce__year_id__c, arce__IRP_Workflow__c,
        arce__ffss_for_rating_id__r.arce__rating_long_value_type__c, arce__ffss_for_rating_id__r.arce__pd_per__c
                FROM arce__Account_has_Analysis__c
                WHERE arce__Analysis__c = :analysisId];
    }
    /**
    * -------------------------------------------------------------------------------------------------------
    * @Description - Method that return some related fields in arce__Account_has_Analysis__c
    * -------------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 24/06/2019
    * @param recordId - id of the arce__Account_has_Analysis__c object to consult
    * @return arce__Account_has_Analysis__c - Object with all related fields in arce__Account_has_Analysis__c
    * @example getAccHasAnalysis(recordId)
    * -------------------------------------------------------------------------------------------------------
    **/
    global static arce__Account_has_Analysis__c getAccHasRelation(Id recordId) {
        return [SELECT arce__analysis_template_id__c, arce__ll_after_adj_ind_type__c, arce__CustomAccountID__c, arce__Customer__c, arce__group_asset_header_type__c,arce__last_update_position__c,arce__Customer__r.Name,arce__Customer__r.ParentId,arce__Customer__r.AccountNumber, arce__Analysis__c, arce__Analysis__r.arce__Group__c, arce__Analysis__r.arce__Group__r.Name, arce__Analysis__r.arce__Stage__c,arce__Analysis__r.arce__analysis_customer_relation_type__c,arce__ffss_for_rating_id__r.arce__rating_id__r.arce__rating_id__c, arce__Customer__r.OwnerId, arce__currency_id__c, arce__anlys_wkfl_cnsld_ffss_type__c FROM arce__Account_has_Analysis__c WHERE Id = :recordId];
    }
    /**
    * -------------------------------------------------------------------------------------------------------
    * @Description - Method that insert or update arce__Account_has_Analysis__c list
    * -------------------------------------------------------------------------------------------------------
    * @param ltsObjects - List of SObject to insert or update
    * @return void
    * @example upsertObjects(ltsObjects)
    * -------------------------------------------------------------------------------------------------------
    **/
    global static void upsertObjects (List<sObject> ltsObjects) {
        if ( !ltsObjects.isEmpty() ) {
            upsert ltsObjects;
        }
    }
    /**
    * -------------------------------------------------------------------------------------------------------
    * @Description - Method that returns the status of the rating
    * -------------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 12/07/2019
    * @param recordId - Id of the account has analysis object
    * @return arce__Account_has_Analysis__c - account has analysis object
    * @example getRatingStatus(recordId)
    * -------------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getRatingStatus(List<Id> recordId) {
        return [SELECT Id, arce__Customer__c, arce__CustomAccountID__c, arce__Customer__r.Name, arce__ffss_for_rating_id__r.arce__rating_id__r.arce__status_type__c FROM arce__Account_has_Analysis__c WHERE Id = :recordId];
    }
    /**
    * -------------------------------------------------------------------------------------------------------
    * @Description - Method that returns the status of the rating
    * -------------------------------------------------------------------------------------------------------
    * @Author   Luis Aturo Parra Rosas
    * @Date     Created: 12/07/2019
    * @param recordId - Id of the account has analysis object
    * @return arce__Account_has_Analysis__c - account has analysis object
    * @example   global static arce__Account_has_Analysis__c getAccForResume(Id recordId)
    * -------------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAccForResume(Set<Id> recordId) {
        return [SELECT Id, arce__CustomAccountID__c FROM arce__Account_has_Analysis__c WHERE arce__Customer__c IN :recordId];
    }
    /**
    *-------------------------------------------------------------------------------
    * @description get customers who are in review
    --------------------------------------------------------------------------------
    * @author luisarturo.parra.contractor@bbva.com
    * @date 5/10/2019
    * @param String record Id to query
    * @return List < arce__Account_has_Analysis__c > list that match the condition
    * @example global static List < arce__Account_has_Analysis__c > getCustomersData()
    **/
    global static  arce__Account_has_Analysis__c getCustomersData(String customer) {
        return [SELECT Id,arce__Customer__c, arce__CustomAccountID__c FROM arce__Account_has_Analysis__c WHERE arce__InReview__c = true AND Id = : customer limit 1 ];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of all fields in arce__Account_has_Analysis__c object with the variable InReview in True for an ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author   Juan Ignacio Hita juanignacio.hita.contractor@bbva.com
    * @Date     Created: 06/11/2019
    * @return List<arce__Account_has_Analysis__c> - List of arce__Account_has_Analysis__c object
    * @example getAccHasAnFromArce(arceId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAccHasAnFromArce(Id arceId) {
        return [SELECT Id,Name,arce__currency_id__c,arce__magnitude_unit_type__c,arce__participant_name__c,arce__long_rating_value_id__c,arce__long_rating_value_prev_year_id__c,
        arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c, arce__ffss_for_rating_id__r.arce__rating_id__c, arce__main_subsidiary_ind_type__c, arce__Customer__r.Name,
        arce__ffss_for_rating_id__r.arce__rating_final__c,arce__ffss_for_rating_id__c, arce__group_asset_header_type__c,arce__Customer__r.ParentId,arce__Customer__r.AccountNumber,
        arce__Customer__c, arce__Analysis__c, arce__Analysis__r.arce__analysis_customer_relation_type__c, arce__Analysis__r.arce__bbva_committees_type__c,arce__rating_scale_type__c,
        arce__ffss_for_rating_id__r.arce__rating_long_value_type__c,arce__ffss_for_rating_id__r.arce__magnitude_unit_type__c,arce__ffss_for_rating_id__r.CurrencyIsoCode, arce__CustomAccountID__c
        FROM arce__Account_has_Analysis__c WHERE arce__InReview__c = true AND arce__Analysis__c = :arceId];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of main banks data of account has analysis to cloned ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author   Juan Manuel Perez Ortiz juanmanuel.perez.ortiz.contractor@bbva.com
    * @Date     Created: 01/09/2020
    * @param    accHasAnaIds - Set of AccHasAnalysis Ids
    * @return   List<arce__main_banks__c> - List of arce__main_banks__c object
    * @example  getAccMainBanksData(Set<Id> accHasAnaIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__main_banks__c> getAccMainBanksData(Set<Id> accHasAnaIds) {
        return [SELECT arce__entity_name__c,arce__entity_quota_share_per__c, arce__account_has_analysis_id__c FROM arce__main_banks__c  WHERE arce__account_has_analysis_id__c IN :accHasAnaIds];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of all fields in arce__Account_has_Analysis__c object with the variable InReview in True for an ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author   Juan Ignacio Hita juanignacio.hita.contractor@bbva.com
    * @Date     Created: 06/11/2019
    * @param    arceId - Id
    * @return   List<arce__Account_has_Analysis__c> - List of arce__Account_has_Analysis__c object
    * @example  getAccHasAnFromArce(arceId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAllAccFromArce(Id arceId) {
        return [SELECT Id, arce__Analysis__c, arce__ffss_for_rating_id__r.arce__rating_long_value_type__c, arce__main_subsidiary_ind_type__c, arce__Customer__r.Name, arce__ffss_for_rating_id__r.arce__rating_final__c, arce__ffss_for_rating_id__c, arce__group_asset_header_type__c,arce__Customer__r.ParentId,arce__Customer__r.AccountNumber, arce__Customer__c, arce__rating_scale_type__c, arce__CustomAccountID__c FROM arce__Account_has_Analysis__c WHERE arce__Analysis__c = :arceId];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that update a list of arce_Account_has_Analysis__c
    * -----------------------------------------------------------------------------------------------
    * @Author   Juan Ignacio Hita juanignacio.hita.contractor@bbva.com
    * @Date     Created: 06/11/2019
    * @param lstAccHasAnalysis - List of arce__Account_has_Analysis__c object to update
    * @return void
    * @example updateAccHasAnalysis(lstAccHasAnalysis)
    * -----------------------------------------------------------------------------------------------
    **/
    global static void updateAccHasAnalysis(List<arce__Account_has_Analysis__c> lstAccHasAnalysis) {
        update lstAccHasAnalysis;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description return the ids of child accounts
    *--------------------------------------------------------------------------------
    * @date 21/11/2019
    * @author luisarturo.parra.contractor@bbva.com
    * @param parenId Account
    * @return a List<arce__Account_has_Analysis__c> that contains the child ids of a parent account
    * @example getIdsOfChildAccountNotSelected(Id groupId)
    */
    global static List<arce__Account_has_Analysis__c> getIdsOfChildAccountNotSelected(Id groupId) {
        return [SELECT Id, arce__Customer__c, arce__CustomAccountID__c From arce__Account_has_Analysis__c WHERE arce__group_asset_header_type__c = '1' AND arce__InReview__c =: true];
    }
    /***
    *-------------------------------------------------------------------------------
    * @description returns a list of account_has_analysis related to the given ARCE id
    *--------------------------------------------------------------------------------
    * @date		10/12/2019
    * @author	manuelhugo.castillo.contractor@bbva.com
    * @param	String arceId - ARCE Id
    * @return	List<arce__Account_has_Analysis__c>
    * @example	global static List<arce__Account_has_Analysis__c> getAllAnalysis(String arceId)
    */
    global static List<Arc_Gen_Account_Has_Analysis_Wrapper> getAllAnalysis(String arceId) {
        Id arce = [SELECT arce__Analysis__c FROM arce__Account_has_Analysis__c WHERE Id =:arceId].arce__Analysis__c;
        List<arce__Account_has_Analysis__c> miniArceList = [SELECT Id, arce__CustomAccountID__c, arce__Customer__c,arce__Customer__r.Name,arce__group_asset_header_type__c,arce__Customer__r.ParentId,arce__Customer__r.AccountNumber FROM arce__Account_has_Analysis__c WHERE arce__Analysis__c =: arce AND arce__InReview__c = true];
        Set<Id> setAccWithAHA = new Set<Id>();
        for(arce__Account_has_Analysis__c aha : miniArceList) {
            setAccWithAHA.add(aha.arce__Customer__c);
        }
        List<Id> lstAccsId = new List<Id>(setAccWithAHA);
        Map<Id, Arc_Gen_Account_Wrapper> mapAccount = Arc_Gen_Account_Locator.getAccountInfoById(lstAccsId);
        List<Arc_Gen_Account_Has_Analysis_Wrapper> lstAHAWrapper = new List<Arc_Gen_Account_Has_Analysis_Wrapper>();
        for(arce__Account_has_Analysis__c aha : miniArceList) {
            Arc_Gen_Account_Has_Analysis_Wrapper newAHAWrapper = new Arc_Gen_Account_Has_Analysis_Wrapper();
            newAHAWrapper.ahaObj = aha;
            newAHAWrapper.accWrapperObj = mapAccount.get(aha.arce__Customer__c);
            lstAHAWrapper.add(newAHAWrapper);
        }
        Return lstAHAWrapper;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that gets an AccountHasAnalysis record
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 28/05/2019
    * @param String analysisId - Analysis Id
    * @param String customerId - Customer Id
    * @return List<arce__Account_has_Analysis__c> - List of Account Has Analysis
    * @example global List<arce__Account_has_Analysis__c> getAccountHasAnalysis(String analysisId,String customerId)
    **/
    global static List<Arc_Gen_Account_Has_Analysis_Wrapper> getAccountHasAnalysis(String analysisId,String customerId) {
        final Id customer = customerId;
        List<arce__Account_has_Analysis__c> ltsAHAs = new List<arce__Account_has_Analysis__c>();
        if(customer.getSObjectType().getDescribe().getName() == 'Account') {
            ltsAHAs = [SELECT id,Name,arce__path__c,arce__Customer__c, arce__CustomAccountID__c,arce__Customer__r.AccountNumber FROM arce__Account_has_Analysis__c WHERE arce__Analysis__c =: analysisId AND arce__Customer__c =: customer];
        } else {
            ltsAHAs = [SELECT id,Name,arce__path__c,arce__Customer__c, arce__CustomAccountID__c,arce__Customer__r.AccountNumber FROM arce__Account_has_Analysis__c WHERE arce__Analysis__c =: analysisId AND arce__CustomAccountID__c =: customer];
        }

        return getListAHAWrapper(ltsAHAs);
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that gets an AccountHasAnalysis record
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 28/05/2019
    * @param String analysisId - Analysis Id
    * @param String customerId - Customer Id
    * @return List<arce__Account_has_Analysis__c> - List of Account Has Analysis
    * @example global List<arce__Account_has_Analysis__c> getAccountHasAnalysis(String analysisId,String customerId)
    **/
    global static List<Arc_Gen_Account_Has_Analysis_Wrapper> getAccountHasAnalysisAndCustomer(List<String> accHasAnalysisId) {
        return getListAHAWrapper(getAccHasAnalysis(accHasAnalysisId));
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method 'getListAHAWrapper' that gets Account Has Analysis Wrapper List
    --------------------------------------------------------------------------------
    * @author manuelhugo.castillo.contractor@bbva.com
    * @date 11/12/2019
    * @param List<arce__Account_has_Analysis__c> ltsAHAs - Account Has Analysis List
    * @return List<Arc_Gen_Account_Has_Analysis_Wrapper> - List of Account Has Analysis wrapper
    * @example List<Arc_Gen_Account_Has_Analysis_Wrapper> getListAHAWrapper(List<arce__Account_has_Analysis__c> ltsAHAs)
    **/
    global static List<Arc_Gen_Account_Has_Analysis_Wrapper> getListAHAWrapper(List<arce__Account_has_Analysis__c> ltsAHAs) {
        Set<Id> setAccWithAHA = new Set<Id>();
        for (arce__Account_has_Analysis__c aha : ltsAHAs) {
            setAccWithAHA.add(getCorrectIdWAhas(aha));
        }
        List<Id> lstAccsId = new List<Id>(setAccWithAHA);
        final Map<Id, Arc_Gen_Account_Wrapper> mapAccount = Arc_Gen_Account_Locator.getAccountInfoById(lstAccsId);
        List<Arc_Gen_Account_Has_Analysis_Wrapper> lstAHAWrapper = new List<Arc_Gen_Account_Has_Analysis_Wrapper>();
        for (arce__Account_has_Analysis__c aha : ltsAHAs) {
            Arc_Gen_Account_Has_Analysis_Wrapper newAHAWrapper = new Arc_Gen_Account_Has_Analysis_Wrapper();
            newAHAWrapper.ahaObj = aha;
            newAHAWrapper.accWrapperObj = mapAccount.get(getCorrectIdWAhas(aha));
            lstAHAWrapper.add(newAHAWrapper);
        }
        return lstAHAWrapper;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description set delete logic - update the field arce__Is_Deleted__c
    *--------------------------------------------------------------------------------
    * @date		05/02/2020
    * @author	juanignacio.hita.contractor@bbva.com
    * @param	List<Id> list of record id of account has analysis
    * @return	void
    * @example	Arc_Gen_AccHasAnalysis_Data.setDeleteLogic(new List<Id>{accHasId});
    */
    global static void setDeleteLogic(Map<String, String> lstIds) {
        List<String> lstKeys = new List<String>();
        lstKeys.addAll(lstIds.keySet());
        final List<arce__Account_has_Analysis__c> lstAccHasAnalysis = getAccHasAnalysis(lstKeys);
        for (arce__Account_has_Analysis__c acc : lstAccHasAnalysis) {
            acc.arce__Is_Deleted__c = true;
            acc.arce__InReview__c = false;
        }
        upsertObjects(lstAccHasAnalysis);
    }

    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Method to get data of account has analysis object
    * ----------------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2020-02-28
    * @param mapFields - List with the api name of the field to query
    * @param recordId - id of the arce__Account_has_Analysis__c object
    * @return List<arce__Account_has_Analysis__c> object
    * @example getRelatedData(mapFields,recordId)
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getRelatedData(List<String> mapFields, String recordId) {
        final String fields = String.join(mapFields,',');
        final string query = String.escapeSingleQuotes('SELECT id,' + fields + ' FROM arce__Account_has_Analysis__c WHERE Id = :recordId');
        return Database.query(query);
    }
    /**
    * -------------------------------------------------------------------------------------------------------
    * @Description - Obtenemos los Account Has Analysis relacionados a un Cliente
    * -------------------------------------------------------------------------------------------------------
    * @Author   Jhovanny De La Cruz Cruz
    * @Date     Created: 28/10/2019
    * @param recordId - Id of the account
    * @return arce__Account_has_Analysis__c - account has analysis object
    * @example   global static List<arce__Account_has_Analysis__c> getAccHasAnById(String recordId) {
    * -------------------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAccHasAnById(String recordId) {
        return [SELECT Id,arce__Analysis__c FROM arce__Account_has_Analysis__c WHERE arce__Customer__c =: recordId];
    }
    /**
    *--------------------------------------------------------------------------------
    * @description  Method to update records
    *--------------------------------------------------------------------------------
    * @author mariohumberto.ramirez.contractor@bbva.com
    * @date 2020-04-14
    * @param accHasAn - arce__Account_has_Analysis__c object
    * @return  Arc_Gen_ServiceAndSaveResponse wrapper
    * @example updateRecords(accHasAn)
    *--------------------------------------------------------------------------------
    **/
    global static Arc_Gen_ServiceAndSaveResponse updateRecords(arce__Account_has_Analysis__c accHasAn) {
        Arc_Gen_ServiceAndSaveResponse result = new Arc_Gen_ServiceAndSaveResponse();
        try {
            result.saveStatus = 'true';
            Database.SaveResult saveResp = database.update(accHasAn);
            result.saveMessage = Json.serialize(saveResp);
        } catch (Exception ex) {
            result.saveStatus = 'false';
            result.saveMessage = ex.getMessage();
        }
        return result;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of third participants data of account has analysis to cloned ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author   Juan Manuel Perez Ortiz juanmanuel.perez.ortiz.contractor@bbva.com
    * @Date     Created: 04/21/2020
    * @return   List<arce__Third_Participant_Details__c> - List of arce__Third_Participant_Details__c object
    * @example  getAccThirdPersonsData(Set<Id> accHasAnaIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Third_Participant_Details__c> getAccThirdPersonsData(Set<Id> accHasAnaIds) {
        return [SELECT Name,Id,arce__third_participant_role_type__c,arce__Third_Participant_id__c,arce__account_has_analysis_id__r.Name,arce__third_participant_per__c,arce__third_participant_desc__c,arce__economic_activity_sector_desc__c,arce__consolidation_method_id__c,arce__non_customer_type__c,arce__shrhldr_financial_sponsor_type__c,arce__shareholder_sponsor_year_id__c,recordTypeId,arce__gf_customer_cif_id__c,arce__gf_group_id__c,arce__gf_group_name__c FROM arce__Third_Participant_Details__c WHERE arce__account_has_analysis_id__c IN :accHasAnaIds];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of geographies data of account has analysis to cloned ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author   Juan Manuel Perez Ortiz juanmanuel.perez.ortiz.contractor@bbva.com
    * @Date     Created: 04/21/2020
    * @return   List<arce__Table_Content_per_Analysis__c> - List of arce__Table_Content_per_Analysis__c object
    * @example  getAccGeographiesData(Set<Id> accHasAnaIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Table_Content_per_Analysis__c> getAccGeographiesData(Set<Id> accHasAnaIds, List<String> recordTypeList) {
        return [SELECT Id,arce__Data_Collection_Id__c,arce__table_content_value__c,arce__table_content_percentage__c,arce__collection_order_type__c,arce__collection_table__c,Name,arce__account_has_analysis_id__r.Name,arce__table_content_year__c,recordTypeId,arce__Data_collection_name__c FROM arce__Table_Content_per_Analysis__c WHERE arce__account_has_analysis_id__c IN :accHasAnaIds AND recordType.DeveloperName IN :recordTypeList];
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the info to build the risk detail table for group
    * -----------------------------------------------------------------------------------------------
    * @Author  mariohumberto.ramirez.contractor@bbva.com
    * @Date    Created: 22-07-2020
    * @param   arceId - id of arce
    * @return  List<arce__Account_has_Analysis__c>
    * @example getAccHasAnforRiskDetTable(arceId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAccHasAnforRiskDetTable(Id arceId) {
        return [SELECT Id, arce__group_risk_detail_part_name__c, arce__economic_activity_sector_desc__c, arce__long_rating_value_id__c,
                arce__bbva_financial_debt_share_per__c, arce__last_approved_amount__c, arce__current_formalized_amount__c,
                arce__outstanding_amount__c, arce__current_proposed_local_amount__c, arce__group_asset_header_type__c, arce__CustomAccountID__c,
                arce__rating_scale_type__c, arce__ffss_for_rating_id__r.arce__rating_final__c, arce__ffss_for_rating_id__c,
                arce__ffss_for_rating_id__r.arce__rating_long_value_type__c, arce__adj_short_rating_value_type__c,
                arce__adj_long_rating_value_type__c, arce__ffss_for_rating_id__r.arce__rating_id__r.arce__status_type__c
                FROM arce__Account_has_Analysis__c
                WHERE arce__InReview__c = true AND arce__Analysis__c = :arceId];
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the info to build the leveraged table for group
    * -----------------------------------------------------------------------------------------------
    * @Author  mariohumberto.ramirez.contractor@bbva.com
    * @Date    Created: 22-07-2020
    * @param   arceId - id of arce
    * @return  List<arce__Account_has_Analysis__c>
    * @example getInfoforLeverTable(arceId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getInfoforLeverTable(Id arceId) {
        return [SELECT Id, arce__participant_name__c, arce__CustomAccountID__c, arce__ll_after_adj_ind_type__c, arce__ll_after_adj_clsfn_type__c
                FROM arce__Account_has_Analysis__c
                WHERE arce__InReview__c = true AND arce__Analysis__c = :arceId AND  arce__group_asset_header_type__c = '2' AND arce__ll_after_adj_ind_type__c = '1'];
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the records of renovation
    * -----------------------------------------------------------------------------------------------
    * @Author  Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date    Created: 12-10-2020
    * @param   ids - Set of ids of account has analysis object
    * @return  Map<String, Set<Id>> - 'inForce' => Id Set of the aha with valid FS, 'notInForce' => Id Set of the aha with novalid FS
    * @example separateListsByFFSSDate(ids)
    * -----------------------------------------------------------------------------------------------
    **/
    global static Map<String, Set<Id>> separateListsByFFSSDate(Set<id> ids) {
        final List<arce__Account_has_Analysis__c> ahaList = [SELECT Id, arce__ffss_for_rating_id__c, arce__CustomAccountID__c, arce__ffss_for_rating_id__r.arce__financial_statement_end_date__c,arce__group_asset_header_type__c FROM arce__Account_has_Analysis__c WHERE Id IN : ids];
        final Set<Id> inForceIds = new Set<Id>();
        final Set<Id> notInForceIds = new Set<Id>();
        for(arce__Account_has_Analysis__c aha : ahaList) {
            final Date endDate = aha.arce__ffss_for_rating_id__r.arce__financial_statement_end_date__c;
            if(validateFFSSAge(endDate)) {
                inForceIds.add(aha.Id);
            } else {
                notInForceIds.add(aha.Id);
            }
        }
        return new Map<String, Set<Id>>{'inForce' => inForceIds, 'notInForce' => notInForceIds};
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return accHasAnalysis if contain customAccount.
    * -----------------------------------------------------------------------------------------------
    * @Author  saimassimilianno.jordana.contractor@bbva.com
    * @Date    Created: 11-12-2020
    * @param   arceId - id of arce
    * @return  List<arce__Account_has_Analysis__c>
    * @example Arc_Gen_AccHasAnalysis_Data.getAhasWithNoacc(accId, subprocessType)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAhasWithNoacc(List<Id> accId, String subprocessType) {

        return [SELECT Id, arce__Customer__c, arce__CustomAccountID__c, arce__Analysis__c
                FROM arce__Account_has_Analysis__c
                WHERE 	arce__CustomAccountID__c = :accId AND arce__Analysis__r.arce__Stage__c != '3' AND arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c = :subprocessType
                LIMIT 1];
    }

    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - Return a list of AHAS that contain custom Accounts and is from the Arce analysis
    * -----------------------------------------------------------------------------------------------
    * @Author  saimassimilianno.jordana.contractor@bbva.com
    * @Date    Created: 16-12-2020
    * @param   arceId - id of arce
    * @return  List<arce__Account_has_Analysis__c>
    * @example Arc_Gen_AccHasAnalysis_Data.getInfoForCustom(arceId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getInfoForCustom(Id arceId) {

        return [SELECT Id, arce__Customer__c, arce__CustomAccountID__c, arce__Analysis__c, arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c
                FROM arce__Account_has_Analysis__c
                WHERE arce__Analysis__c = :arceId AND arce__CustomAccountID__c != null AND arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c = '4'
                LIMIT 1];
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the records of renovation
    * -----------------------------------------------------------------------------------------------
    * @Author  Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date    Created: 12-10-2020
    * @param   Date endDate - End date of the financial statement
    * @return  Boolean - If true, the FFSS is still valid and the records of financial risk will be copied
    * @example validateFFSSAge(Date endDate)
    * -----------------------------------------------------------------------------------------------
    **/
    global static Boolean validateFFSSAge(Date endDate) {
        Boolean resp = false;
        if(endDate == null) {
            resp = false;
        } else {
            if(endDate.monthsBetween(Date.today()) <= Arc_Gen_Constants.MAXIMUM_FFSS_AGE) {
                resp = true;
            } else {
                resp = false;
            }
        }
        return resp;
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the records of renovation
    * -----------------------------------------------------------------------------------------------
    * @Author  mariohumberto.ramirez.contractor@bbva.com
    * @Date    Created: 22-07-2020
    * @param   ids - Set of ids of account has analysis object
    * @return  List<arce__Account_has_Analysis__c> - List of analyzed clients
    * @example copyAccHasAnforReno(ids)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> copyAccHasAnforReno(Set<id> ids, String modRenVar) {
        final List<dyfr__Tab__c> tabCodesLts = getDyFrmTabs(false);
        final List<String> tabCodes = new List<String>();
        for (dyfr__Tab__c tabCode: tabCodesLts) {
            tabCodes.add(tabCode.dyfr__Tab_Code__c);
        }
        return getAhaByDyFrmFields(tabCodes, ids, modRenVar);
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that obtains the tabs of the dynamic form
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date Created: 12-10-2020
    * @param Boolean isFFSSInForce - Indicates if there are valid FFSS
    * @return List<dyfr__Tab__c> - List of dyfr__Tab__c
    * @example getDyFrmTabs(Boolean isFFSSInForce)
    **/
    global static List<dyfr__Tab__c> getDyFrmTabs(Boolean isFFSSInForce) {
        return isFFSSInForce ? [SELECT dyfr__Tab_Code__c FROM dyfr__Tab__c WHERE (NOT dyfr__Tab_Code__c LIKE '%RAIP%') AND (dyfr__Tab_Code__c LIKE '%BusinessRisk%' OR dyfr__Tab_Code__c LIKE '%BasicData%' OR dyfr__Tab_Code__c LIKE '%IndustryAnalysis%' OR dyfr__Tab_Code__c LIKE '%BankingRelationship%' OR dyfr__Tab_Code__c LIKE '%Assessment%' OR dyfr__Tab_Code__c LIKE '%FinancialRisk%')] :
            [SELECT dyfr__Tab_Code__c FROM dyfr__Tab__c WHERE (NOT dyfr__Tab_Code__c LIKE '%RAIP%') AND (dyfr__Tab_Code__c LIKE '%BusinessRisk%' OR dyfr__Tab_Code__c LIKE '%BasicData%' OR dyfr__Tab_Code__c LIKE '%IndustryAnalysis%' OR dyfr__Tab_Code__c LIKE '%BankingRelationship%' OR dyfr__Tab_Code__c LIKE '%Assessment%')];
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return a list of AHA with the fields obtained by the given tabs
    * -----------------------------------------------------------------------------------------------
    * @Author  Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date    Created: 12-10-2020
    * @param   List<String> tabCodesids - List of tabs to review
    * @param   Set<id> ids - Set of ids of account has analysis object
    * @return  List<arce__Account_has_Analysis__c>
    * @example getAhaByDyFrmFields(List<String> tabCodes, Set<id> ids)
    * -----------------------------------------------------------------------------------------------
    **/
    @SuppressWarnings('sf:UnusedFormalParameter')//The parameter is already in use in dynamic query
    global static List<arce__Account_has_Analysis__c> getAhaByDyFrmFields(List<String> tabCodes, Set<id> ids, String modRenVar) {
        Set<String> qualitQuestions = Arc_Gen_PersistenceQualitative_Data.getQualitativeVariablesDefinition().keySet();

        final List<dyfr__Field_Config__c> fConfigsLts = [SELECT dyfr__Map_field__c FROM dyfr__Field_Config__c
                                                    WHERE dyfr__Tab__r.dyfr__Tab_Code__c = :tabCodes
                                                    AND dyfr__Map_field__c != null
                                                    AND dyfr__Type__c != 'lightning component'
                                                    AND dyfr__Type__c != 'blank'
                                                    AND dyfr__Hidden__c = false
                                                    AND dyfr__Read_only__c = false];
        final Set<String> mapFields = new Set<String>();
        for (dyfr__Field_Config__c fconfig: fConfigsLts) {
            if(!qualitQuestions.contains(fconfig.dyfr__Map_field__c)) {
                mapFields.add(fconfig.dyfr__Map_field__c);
            }
        }

        mapFields.add('id');
        mapFields.add('arce__magnitude_unit_type__c');
        mapFields.add('arce__group_risk_detail_part_name__c');
        mapFields.add('arce__participant_name__c');
        mapFields.add('arce__Analysis__c');
        mapFields.add('arce__gf_pv_anlys_sbanlys_ind_type__c');
        mapFields.add('arce__group_asset_header_type__c');
        mapFields.add('arce__InReview__c');
        mapFields.add('arce__Customer__c');
        mapFields.add('arce__Customer__r.OwnerId');
        mapFields.add('arce__Customer__r.AccountNumber');
        mapFields.add('arce__year_id__c');
        mapFields.add('arce__limit_exposure_ext_ind_type__c');
        mapFields.add('arce__participant_srty_age_number__c');

        if (modRenVar != Arc_Gen_Constants.RENOVATION_CODE) {
            mapFields.add('arce__currency_id__c');
            mapFields.add('arce__arce_Gen_ExceptionsParrilla__c');
            mapFields.add('arce__risk_policy_type__c');
            mapFields.add('arce__gf_anlys_risk_prps_expiry_date__c');
            mapFields.add('arce__employees_number__c');
            mapFields.add('arce__total_asset_local_amount__c');
            mapFields.add('arce__total_revenues_local_amount__c');
            mapFields.add('arce__current_proposed_amount__c');
            mapFields.add('arce__smes_eur_comuty_defn_type__c');
            mapfields.add('arce__newFFSS_ind__c');
            mapFields.add('arce__ffss_for_rating_id__c');
            mapfields.add('arce__ffss_submitted_type__c');
        }

        String fields = '';
        if(!mapFields.isEmpty()){
            fields = String.join(new List<String>(mapFields),',');
        }

        final string query =
            'SELECT ' + fields +
            '  FROM arce__Account_has_Analysis__c ' +
            ' WHERE Id = :ids';

        return Database.query(String.escapeSingleQuotes(query));
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a list of all fields in arce__Account_has_Analysis__c object
    * -----------------------------------------------------------------------------------------------
    * @Author   Eduardo Efraí­n Hernández Rendón - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 01/09/2020
    * @param List<String> riskAssessmentIds - List of risk Assessment Ids (Account Has Analysis standard Name)
    * @return List<arce__Account_has_Analysis__c> - List of all fields in arce__Account_has_Analysis__c object
    * @example Arc_Gen_AccHasAnalysis_Data.getAhaByRiskAssessment(List<String> riskAssessmentIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__Account_has_Analysis__c> getAhaByRiskAssessment(List<String> riskAssessmentIds) {
        return [SELECT id,arce__Analysis__r.OwnerId,arce__Analysis__r.arce__parent_analysis_id__c,arce__Analysis__r.arce__analysis_risk_sanction_date__c,arce__Analysis__r.arce__proposeUser__c,
        arce__ffss_for_rating_id__r.arce__financial_statement_id__c,arce__Analysis__r.arce__anlys_wkfl_sub_process_type__c, arce__Analysis__r.arce__rating_prerating_type__c,
        arce__ffss_for_rating_id__r.arce__rating_id__c,arce__Account_has_Analysis__c.arce__branch_id__c,
        arce__economic_activity_sector_desc__c,arce__gf_company_economic_actvy_id__c,arce__current_formalized_amount__c,arce__last_approved_amount__c,
        arce__adj_long_rating_value_id__c,arce__adj_total_rating_score_number__c,
        arce__ll_adj_ebitda_amount__c,arce__ll_adj_debt_amount__c,arce__persistance_callback_status_type__c,
        arce__Analysis__c,arce__significant_variables_type__c,
        arce__limit_asset_allocation_amount__c,arce__data_adjusted_score_number__c,arce__ll_adj_debt_auditor_amount__c,
        arce__ll_adj_ebitda_auditor_amount__c,arce__cust_evolution_cyr_ind_type__c,arce__backlog_desc__c,arce__backlog_sales_desc__c,
        arce__bbva_financial_debt_share_per__c,arce__cust_budget_cyr_ind_type__c,arce__ffss_auditor_qlfn_type__c,
        arce__backlog_less_70_per_type__c,arce__backlog_less_70_per_desc__c,arce__enterprise_group_type__c,
        arce__enterprise_group_desc__c,arce__ll_test_scope_ind_type__c,arce__ebitda_less_70_peer_avg_desc__c,arce__ebitda_less_70_peer_avg_type__c,
        arce__level_concentration_geo_type__c,arce__sales_less_70_peer_avg_desc__c,arce__sales_less_70_peer_avg_type__c,
        arce__cust_public_private_cmprn_desc__c,arce__cust_proj_2yr_3yr_desc__c,arce__significant_variables_desc__c,
        arce__cust_evolution_cyr_desc__c,arce__Syn_expct_evol_short_term_txt__c,arce__off_balance_rlvnt_info_desc__c,
        arce__off_balance_treasury_desc__c,arce__Syn_client_situation_txt__c,arce__regulated_sector_desc__c,arce__exch_rate_vulnerability_desc__c,
        arce__competition_sector_desc__c,arce__level_conc_sector_desc__c,arce__level_concentration_geo_desc__c,
        arce__bbva_financial_debt_share_desc__c,arce__cust_budget_incl_ffss_desc__c,arce__co_actvy_prtcp_group_desc__c,
        arce__cust_contract_capacity_desc__c,arce__gf_covenant_desc__c,arce__fin_aggressiveness_mngmt_desc__c,
        arce__gntee_given_backlog_range_desc__c,arce__guarantee_given_desc__c,arce__struct_change_invst_desc__c,
        arce__shrhldr_Financialsponsor_profile_desc__c,arce__management_style_desc__c,arce__other_operation_desc__c,
        arce__other_contracted_product_desc__c,arce__shareholder_disagreement_desc__c,arce__capital_provision_desc__c,
        arce__rar_profitability_desc__c,arce__RAR_rating_tool_id__c,arce__anlys_wkfl_cnsld_ffss_type__c,arce__investment_relevant_fact_desc__c,arce__client_refinanced_desc__c,
        arce__shareholder_agreement_desc__c,arce__shrhldr_sig_movement_desc__c,arce__stage_collective_desc__c,
        arce__risk_position_summary_type__c,arce__shareholder_support_desc__c,arce__breakdown_activity_desc__c,
        arce__breakdown_geography_desc__c,arce__risk_position_summary_desc__c,arce__debt_comt_not_disb_amount__c,
        arce__debt_comt_not_disb_local_amount__c,arce__entity_covenants_type__c,
        CreatedById,CurrencyIsoCode,arce__outstanding_amount__c,arce__current_proposed_amount__c,arce__ffss_for_rating_id__r.currencyIsoCode,
        arce__current_proposed_local_amount__c,arce__Customer__c,arce__customer_multi_country_type__c,arce__customer_multi_country_desc__c,
        arce__arce_ctmr_flag__c,arce__cust_conc_clients_desc__c,arce__prev_magnitude_unit_type__c,arce__limit_asset_allocation_date__c,
        arce__exposure_at_default_date__c,arce__bbva_avg_prblty_default_date__c,arce__cust_prblty_default_date__c,
        arce__sector_avg_prblty_dflt_date__c,arce__ll_adj_deb_excl_amount__c,arce__ll_acquisition_debt_type__c,
        arce__competition_sector_type__c,arce__level_conc_sector_type__c,arce__market_situation_desc__c,arce__cust_conc_clients_type__c,
        arce__concentration_suppliers_type__c,arce__Funds_destination_type__c,arce__banking_pool_desc__c,arce__ead_amount__c,
        arce__ll_adj_ebitda_excl_amount__c,arce__economic_capital_amount__c,arce__ffss_submitted_type__c,
        arce__equity_total_asset_20_type__c,arce__Syn_equity_type__c,arce__equity_desc__c,arce__cost_structure_desc__c,
        arce__Syn_expct_evol_short_term_type__c,arce__arce_Gen_ExceptionsParrilla__c,arce__ebitda_3yr_evolution_desc__c,
        arce__sales_evolution_desc__c,arce__account_payable_desc__c,arce__explantation_margin_desc__c,
        arce__export_range_year_type__c,arce__long_rating_value_id__c,arce__rating_short_value_type__c,
        arce__fin_covenants_breach_type__c,arce__fin_covenants_breach_desc__c,
        arce__fin_spnsr_relnshp_exprnc_type__c,arce__fin_spnsr_relnshp_exprnc_desc__c,arce__shrhldr_fin_sponsor_profl_type__c,
        arce__shrhldr_fin_sponsor_strat_type__c,arce__ffss_for_rating_id__c,arce__gl_fixed_asset_amount__c,
        arce__financial_flexibility_type__c,arce__manual_rating_value_type__c,arce__oper_guarantee_given_type__c,
        arce__conc_geography_activity_type__c,arce__gross_financial_debt_amount__c,arce__gross_financial_debt_local_amount__c,
        arce__gross_fin_debt_ebitda_number__c,arce__group_asset_header_type__c,arce__hats_risk_qualification_number__c,
        arce__sector_building_desc__c,arce__import_range_year_type__c,arce__InReview__c,
        arce__investment_relevant_fact_type__c,arce__off_balance_rlvnt_info_type__c,arce__ebitda_interest_number__c,
        arce__ebitda_interest_local_number__c,arce__invty_work_in_progress_desc__c,arce__struct_change_invst_type__c,LastModifiedById,
        arce__customer_last_projects_desc__c,arce__participant_leveraged_type__c,arce__ll_after_adj_ind_type__c,arce__ll_before_adj_ind_type__c,
        arce__ll_previous_anlys_ind_type__c,arce__ll_previous_anlys_clsfn_type__c,arce__ll_after_adj_clsfn_type__c,arce__ll_collective_type__c,
        arce__ll_before_adj_clsfn_type__c,arce__ll_test_manl_excl_rsn_type__c,arce__lgd_per__c,arce__financial_liquidity_desc__c,
        arce__main_affiliates_desc__c,arce__property_ownership_type__c,arce__main_subsidiary_ind_type__c,arce__years_experience_mngmt_type__c,
        arce__years_experience_mngmt_desc__c,arce__fin_aggressiveness_mngmt_type__c,arce__management_style_type__c,
        arce__market_growth_forecast_desc__c,arce__market_share_type__c,arce__maturity_date__c,
        arce__debt_maturity_available_type__c,Name,arce__newFFSS_ind__c,arce__ffss_auditor_fullname_name__c,arce__number_entity_type__c,
        arce__dvrsfn_product_service_desc__c,arce__dvrsfn_product_service_type__c,arce__assessment_opportunities_desc__c,
        arce__ll_other_adj_debt_amount__c,arce__ll_other_adj_ebitda_amount__c,arce__other_contracted_product_type__c,
        arce__other_operation_type__c,arce__geography_outlook_type__c,arce__path__c,
        arce__probability_default_per__c,arce__sector_avg_prblty_default_per__c,arce__Peer_information_ind_type__c,
        arce__ffss_cnsld_perimeter_desc__c,arce__risk_policy_type__c,arce__off_balance_treasury_type__c,arce__portfolio_class_type__c,
        arce__shareholder_disagreement_type__c,arce__cust_budget_incl_ffss_ind_type__c,arce__pd_per__c,arce__property_ownership_desc__c,
        arce__capital_provision_per__c,arce__cust_proj_2yr_3yr_ind_type__c,arce__smes_eur_comuty_defn_type__c,arce__customer_qualitative_type__c,
        arce__rar_profitability_per__c,arce__long_rating_value_type__c,arce__short_rating_value_type__c,arce__rating_model_type__c,
        arce__rating_scale_type__c,arce__total_rating_score_number__c,arce__ll_adj_debt_ebitda_number__c,arce__gntee_given_backlog_range_type__c,
        arce__total_debt_ebitda_per__c,arce__regulated_sector_type__c,arce__other_relevant_fact_type__c,arce__new_business_venture_type__c,
        arce__new_business_venture_desc__c,arce__other_relevant_fact_desc__c,arce__client_refinanced_type__c,arce__risk_request_desc__c,
        arce__risk_growth_amount__c,arce__sector_desc__c,arce__sector_outlook_type__c,arce__rating_econ_sector_tmpl_id__c,
        arce__service_type_name__c,arce__cust_multi_business_line_type__c,arce__shareholder_agreement_type__c,
        arce__shrhldr_sig_movement_type__c,arce__client_situation_type__c,arce__Stage__c,arce__stage_collective_type__c,
        arce__assessment_strengths_desc__c,arce__subsector_desc__c,arce__shareholder_support_type__c,
        arce__cust_contract_capacity_type__c,
        arce__cust_contract_category_type__c,arce__assessment_threats_desc__c,arce__ffss_auditor_opinion_type__c,arce__ffss_certification_type__c,
        arce__ffss_auditor_opinion_desc__c,arce__currency_id__c,arce__total_asset_amount__c,arce__total_asset_local_amount__c,arce__gf_total_debt_amount__c,
        arce__gf_total_revenues_ytd_amount__c,arce__total_revenues_local_amount__c,arce__customer_product_usage_desc__c,arce__Institution_type__c,
        arce__magnitude_unit_type__c,arce__var_over_20_balance_desc__c,arce__var_vary_10_and_10_bal_desc__c,arce__variables_vary_20_balance_desc__c,
        arce__equity_vary_not_expln_desc__c,arce__ll_anlys_clsfn_var_rsn_id__c,arce__total_revenuesvariation_percentage__c,
        arce__exch_rate_vulnerability_type__c,arce__assessment_weaknesses_desc__c,arce__anlys_wkfl_sbanlys_status_type__c,arce__WF_Stage_WF_Status__c,
        arce__gf_backlog_sales_cyr_number__c,arce__gf_backlog_sales_pyr_number__c,arce__gf_backlog_pending_cyr_amount__c,arce__gf_backlog_pending_pyr_amount__c,
        arce__prop_int_mod_rec_type__c,arce__risk_unit_confirm_desc__c,arce__contrast_risk_unit_type__c,arce__contrast_risk_unit_neg_desc__c,arce__contrast_risk_unit_posi_desc__c,
        arce__Analysis__r.arce__wf_status_id__c,arce__Analysis__r.arce__Stage__c,arce__call_limit_service__c,arce__last_update_policie__c,arce__last_update_position__c,arce__outstanding_carrousel__c,
        arce__gf_market_share_desc__c,arce__mngmt_aggressiveness_type__c,arce__adj_long_rating_value_type__c,arce__rating_override_reason_desc__c,arce__Is_Deleted__c,arce__customer_arce_scope_type__c,
        arce__currency_fin_info_gp_val__c,arce__unit_fin_info_gp_val__c,arce__year_fin_info_gp_val__c,arce__currency_fin_info_gp_prev__c,arce__unit_fin_info_gp_prev__c,arce__year_fin_info_gp_prev__c,
        arce__long_rating_value_prev_year_id__c,arce__debt_maturity_desc__c,arce__dependency_degree_cust_type__c,arce__analysis_template_id__c,
        arce__Analysis__r.arce__triageStatus__c, arce__CustomAccountID__c
                FROM arce__Account_has_Analysis__c
                WHERE name = :riskAssessmentIds];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return a the main AccountHasAnalysis of the ARCE
    * -----------------------------------------------------------------------------------------------
    * @Author   Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 01/09/2020
    * @param String arceId - Standard Id of the ARCE
    * @return arce__Account_has_Analysis__c - AccountHasAnalysis group of the ARCE
    * @example Arc_Gen_AccHasAnalysis_Data.getAhaGroupOfArce(String arceId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static arce__Account_has_Analysis__c getAhaGroupOfArce(String arceId) {
        arce__Account_has_Analysis__c ahaGroup = new arce__Account_has_Analysis__c();
        final List<arce__Account_has_Analysis__c> ahaList = accHasAnByArce(new List<String>{arceId});
        for(arce__Account_has_Analysis__c aha : ahaList) {
            if(aha.arce__group_asset_header_type__c == Arc_Gen_Constants.ONE_S) {
                ahaGroup = aha;
            }
        }
        return ahaGroup;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that returns the correct clientId if customAccount exits
    * -----------------------------------------------------------------------------------------------
    * @Author   Sai Jordana - saimassimilianno.jordana.contractor@bbva.com
    * @Date     Created: 20/01/2021
    * @param arce__Account_has_Analysis__c ahas
    * @return String (id of client)
    * @example Arc_Gen_AccHasAnalysis_Data.getCorrectIdWAhas(ahas)
    * -----------------------------------------------------------------------------------------------
    **/
    global static String getCorrectIdWAhas(arce__Account_has_Analysis__c ahas) {
        return ahas.arce__CustomAccountID__c == null ? ahas.arce__customer__c : ahas.arce__CustomAccountID__c;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description returns a list of account_has_analysis related to the given ARCE id
    *--------------------------------------------------------------------------------
    * @date		2021-01-13
    * @author	antonio.munoz.perez.contractor@bbva.com
    * @param	String arceId - ARCE
    * @return	List<arce__Account_has_Analysis__c>
    * @example	public static List<arce__Account_has_Analysis__c> getRatingAnalysis(String arceId)
    */
    global static List<Arc_Gen_Account_Has_Analysis_Wrapper> getRatingAnalysis(String arceId) {
        final Id arce = [SELECT arce__Analysis__c FROM arce__Account_has_Analysis__c WHERE Id =:arceId].arce__Analysis__c;
        final List<arce__Account_has_Analysis__c> miniArceList = [SELECT Id,arce__CustomAccountID__c,arce__Customer__c,arce__anlys_wkfl_cnsld_ffss_type__c,arce__InReview__c,arce__Customer__r.Name,arce__group_asset_header_type__c,arce__main_subsidiary_ind_type__c,arce__Customer__r.ParentId,arce__Customer__r.AccountNumber FROM arce__Account_has_Analysis__c WHERE arce__Analysis__c =: arce ];
        final Set<Id> setAccWithAHA = new Set<Id>();
        for(arce__Account_has_Analysis__c aha : miniArceList) {
            setAccWithAHA.add(aha.arce__Customer__c);
        }
        final List<Id> lstAccsId = new List<Id>(setAccWithAHA);
        final Map<Id, Arc_Gen_Account_Wrapper> mapAccount = Arc_Gen_Account_Locator.getAccountInfoById(lstAccsId);
        final List<Arc_Gen_Account_Has_Analysis_Wrapper> lstAHAWrapper = new List<Arc_Gen_Account_Has_Analysis_Wrapper>();
        for(arce__Account_has_Analysis__c aha : miniArceList) {
            final Arc_Gen_Account_Has_Analysis_Wrapper newAHAWrapper = new Arc_Gen_Account_Has_Analysis_Wrapper();
            newAHAWrapper.ahaObj = aha;
            newAHAWrapper.accWrapperObj = mapAccount.get(aha.arce__Customer__c);
            lstAHAWrapper.add(newAHAWrapper);
        }
        Return lstAHAWrapper;
    }
}