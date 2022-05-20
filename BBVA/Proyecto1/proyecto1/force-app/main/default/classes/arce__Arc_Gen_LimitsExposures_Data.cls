/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_LimitsExposures_Data
* @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
* @Date     Created: 2019-06-20
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Data class for arce__limits_exposures__c object
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2019-06-20 mariohumberto.ramirez.contractor@bbva.com
*             Class creation.
* |2019-06-27 ricardo.almanza.contractor@bbva.com
*             Class moded for Executive Summary adding tipologyL1, tipologyL2, modalityFull and getFieldList.
* |2019-09-30 mariohumberto.ramirez.contractor@bbva.com
*             Added new fields "arce__debt_desc__c, arce__account_Id__c, arce__account_Id__r.Name" to the query in getExposureData arce__debt_desc__c
* |2019-09-30 mariohumberto.ramirez.contractor@bbva.com
*             Added new method updateExposureData getExposureByDevName
* |2019-10-25 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getExposureByDevName
* |2019-11-01 mariohumberto.ramirez.contractor@bbva.com
*             Added new method getExposureDataPolicies
* |2019-14-01 mariohumberto.ramirez.contractor@bbva.com
*             Fix query filter in getExposureDataPolicies
* |2019-11-26 ricardo.almanza.contractor@bbva.com
*             Modified method getLabels to get it by Static Map.
* |2019-11-11 luisarturo.parra.contractor@bbva.com
*             Added new method get exposures by aha id
* |2019-12-02 german.sanchez.perez.contractor@bbva.com | franciscojavier.bueno@bbva.com
*             Api names modified with the correct name on business glossary
* |2019-12-16 mariohumberto.ramirez.contractor@bbva.com
*             Deleted method getExposureDataPolicies
* |2020-01-17 jhovanny.delacruz.cruz@bbva.com
*             The tipologyL1 method is modified to show limit exposure records dynamically
* |2020-01-28 mariohumberto.ramirez.contractor@bbva.com
*             Added new field in method getExposureData 'arce__limits_typology_id__r.arce__risk_typo_ext_id__c'
* |2020-06-12 mariohumberto.ramirez.contractor@bbva.com
*             Added 'getExposurDataMod' and 'getLimExpByAccHasMap' methods
* |2020-08-12 mariohumberto.ramirez.contractor@bbva.com
*             Added arce__current_apprv_limit_term_type__c,arce__curr_apprv_deleg_dchan_amount__c,arce__curr_apprv_deleg_rm_amount__c fields in getExposureData method
*             Added 'getExposurDataRen' method
* |2020-08-12 mariohumberto.ramirez.contractor@bbva.com
*             Added arce__account_has_analysis_id__r.arce__magnitude_unit_type__c field in the method getExposureData
* |2020-10-06 juanignacio.hita.contractor@bbva.com
*             Created getMapExposureDataAha method and added arce__limits_typology_id__r.arce__risk_typo_ext_id__c,
*             arce__account_has_analysis_id__r.arce__currency_id__c,arce__account_has_analysis_id__r.arce__magnitude_unit_type__c
*             fields to getExposurDataMod method.
* |2020-11-17 joseluis.garcia4.contractor@bbva.com
*             Use approved field arce__limit_exposure_ext_ind_type__c for extended policies indicator.
* |2020-12-14 juanignacio.hita.contractor@bbva.com
*             Add arce__limits_typology_id__r.arce__risk_typology_level_id__c in getExposurDataMod method and modify getMapExposureDataAha method
* |2021-02-02 luisdavid.rivera.ortiz@bbva.com
*             Eliminated unused fields
* |2021-05-12 juanignacio.hita.contractor@bbva.com
*             Add arce__account_has_analysis_id__r.arce__limit_exposure_ext_ind_type__c getExposurDataMod method
* |2021-06-02 israel.rodriguez.ramos.contractor@bbva.com
*             Add arce__curr_apprv_deleg_rm_amount__c in getExposureByDevName method
* |2021-06-03 juanignacio.hita.contractor@bbva.com
*             Adds condition arce__Product_id__c = null in query getExposureDatafromIds
* |2021-06-14 juanignacio.hita.contractor@bbva.com
*             Revert changes pull request 33 and create new version. Add arce__current_apprv_limit_term_type__c getExposurDataMod
* -----------------------------------------------------------------------------------------------
*/
global without sharing class Arc_Gen_LimitsExposures_Data {
    /**
    *   Limit map to obtain fields and labels
    * @author Ricardo Almanza
    */
    Static Map<String, Schema.SObjectField>  mapaLim = Schema.getGlobalDescribe().get('arce__limits_exposures__c').getDescribe().fields.getMap();
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example Arc_Gen_LimitsExposures_Data data = new Arc_Gen_LimitsExposures_Data()
    * ----------------------------------------------------------------------------------------------------
    **/
    @TestVisible
    global Arc_Gen_LimitsExposures_Data() {

    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description Wrapper that contain an error message
    * -----------------------------------------------------------------------------------------------
    * @param - void
    * @return - String with an error message
    * @example ResponseWrapper wrapper = new ResponseWrapper()
    * -----------------------------------------------------------------------------------------------
    **/
    global class ResponseWrapper {
        /**
        * @Description: String with an error message
        */
        @AuraEnabled global String gblErrorResponse {get;set;}
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Return arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @param recordIds - List<Id> of account has analysis object
    * @return List of arce__limits_exposures__c data
    * @example getExposureData(recordIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__limits_exposures__c> getExposureData(List<Id> recordIds) {
        return [SELECT Id, arce__debt_desc__c, arce__account_Id__c, arce__account_Id__r.Name, arce__limits_typology_id__c,
                arce__limits_typology_id__r.arce__Typology_Order__c, arce__limits_typology_id__r.arce__risk_typology_level_id__c,
                arce__limits_typology_id__r.arce__risk_typo_ext_id__c, arce__Product_id__r.Name, arce__limits_typology_id__r.Name,
                arce__limits_exposures_parent_id__c, arce__limits_exposures_parent_id__r.arce__limits_exposures_parent_id__c,
                arce__account_has_analysis_id__c, arce__last_approved_amount__c, arce__curr_approved_commited_amount__c,
                arce__curr_apprv_uncommited_amount__c, arce__current_formalized_amount__c, arce__current_proposed_amount__c,
                arce__current_approved_amount__c, arce__current_apprv_limit_term_id__c, arce__collection_payment_period_id__c,
                arce__break_clause_frequency_id__c, arce__cust_amortized_oblg_type__c, arce__amortization_type_desc__c, arce__grace_months_number__c,
                arce__currency_id__c, arce__ltv_per__c, arce__shareholder_gntee_limit_type__c,arce__current_apprv_limit_term_type__c,
                arce__real_guarantee_type__c, arce__no_real_guarantee_type__c, arce__notary_certification_type__c, arce__outstanding_amount__c,
                RecordTypeId, arce__curr_apprv_deleg_dchan_amount__c,arce__curr_apprv_deleg_rm_amount__c,
                arce__account_has_analysis_id__r.arce__magnitude_unit_type__c
                FROM arce__limits_exposures__c
                WHERE arce__account_has_analysis_id__c = :recordIds];
    }

    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that return the Id of the arce__limits_exposures__c object to delete
    * -----------------------------------------------------------------------------------------------
    * @param recordId - Id of account has analysis object
    * @return arce__limits_exposures__c - Object with the data to eliminate
    * @example conRecord2Delete(recordId)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__limits_exposures__c> conRecord2Delete(Id recordId) {
        return [SELECT Id FROM arce__limits_exposures__c WHERE (Id = :recordId OR arce__limits_exposures_parent_id__c = :recordId)];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that insert or update arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @param data - List of arce__limits_exposures__c data to insert
    * @return void
    * @example insertExposureData(data)
    * -----------------------------------------------------------------------------------------------
    **/
    global static void insertExposureData (List<arce__limits_exposures__c> data) {
        if (!data.isEmpty()) {
            upsert data;
        }
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that delete arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @param data - List of arce__limits_exposures__c data to delete
    * @return void
    * @example deleteExpRecord(listToDelete)
    * -----------------------------------------------------------------------------------------------
    **/
    global static void deleteExpRecord(List<arce__limits_exposures__c> listToDelete) {
        delete listToDelete;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Query to verify if there are records in arce__limits_exposures__c
    * -----------------------------------------------------------------------------------------------
    * @Author Mario Humberto Ramirez Lio mariohumberto.ramirez.contractor@bbva.com
    * @Date 2019-06-28
    * @param names - List of names of the records to consult
    * @return List<arce__limits_exposures__c> - A list of records
    * @example verifyProductsData(names)
    * -----------------------------------------------------------------------------------------------
    **/
    global static arce__limits_exposures__c[] tipologyL1(Id rid) {
        List<arce__Account_has_Analysis__c> accHas= Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{String.valueOf(rid)});
        final String expReduc= String.isBlank(accHas[0].arce__limit_exposure_ext_ind_type__c) ? '2' : accHas[0].arce__limit_exposure_ext_ind_type__c;
        return expReduc == '1' ? [Select Id, arce__curr_apprv_deleg_rm_amount__c, arce__limits_typology_id__c, arce__limits_typology_id__r.arce__Typology_Order__c, arce__limits_typology_id__r.arce__risk_typology_level_id__c, arce__Product_id__r.Name, arce__limits_typology_id__r.Name, arce__limits_exposures_parent_id__c, arce__limits_exposures_parent_id__r.arce__limits_exposures_parent_id__c, arce__account_has_analysis_id__c, arce__curr_approved_commited_amount__c, arce__curr_apprv_uncommited_amount__c, arce__current_formalized_amount__c, RecordTypeId,toLabel(arce__cust_amortized_oblg_type__c), arce__curr_apprv_deleg_dchan_amount__c, toLabel(arce__break_clause_frequency_id__c), arce__treasury_break_clause_date__c, toLabel(arce__project_finc_calification_type__c), toLabel(arce__undly_hedge_treasury_type__c), arce__currency_id__c, toLabel(arce__notary_certification_type__c), arce__grace_months_number__c, arce__last_approved_amount__c, toLabel(arce__project_finance_rating_id__c), toLabel(arce__collection_payment_period_id__c), arce__days_period_number__c, arce__ltv_per__c, toLabel(arce__netting_type__c), toLabel(arce__no_real_guarantee_type__c), arce__outstanding_amount__c, toLabel(arce__project_finance_lgd_range_id__c), toLabel(arce__treasury_prehedge_id__c), arce__current_proposed_amount__c, arce__current_approved_amount__c, toLabel(arce__real_guarantee_type__c), toLabel(arce__shareholder_gntee_limit_type__c), toLabel(arce__current_apprv_limit_term_id__c), toLabel(arce__amortization_type_desc__c) From arce__limits_exposures__c where arce__limits_exposures_parent_id__c = null and arce__limits_typology_id__r.arce__Typology_Order__c >=1 and arce__limits_typology_id__r.arce__Typology_Order__c <= 7 and arce__account_has_analysis_id__c = :rid order by arce__limits_typology_id__r.arce__Typology_Order__c] : [Select Id, arce__curr_apprv_deleg_rm_amount__c, arce__limits_typology_id__c, arce__limits_typology_id__r.arce__Typology_Order__c, arce__limits_typology_id__r.arce__risk_typology_level_id__c, arce__Product_id__r.Name, arce__limits_typology_id__r.Name, arce__limits_exposures_parent_id__c, arce__limits_exposures_parent_id__r.arce__limits_exposures_parent_id__c, arce__account_has_analysis_id__c, arce__curr_approved_commited_amount__c, arce__curr_apprv_uncommited_amount__c, arce__current_formalized_amount__c, RecordTypeId,toLabel(arce__cust_amortized_oblg_type__c), arce__curr_apprv_deleg_dchan_amount__c, toLabel(arce__break_clause_frequency_id__c), arce__treasury_break_clause_date__c, toLabel(arce__project_finc_calification_type__c), toLabel(arce__undly_hedge_treasury_type__c), arce__currency_id__c, toLabel(arce__notary_certification_type__c), arce__grace_months_number__c, arce__last_approved_amount__c, toLabel(arce__project_finance_rating_id__c), toLabel(arce__collection_payment_period_id__c), arce__days_period_number__c, arce__ltv_per__c, toLabel(arce__netting_type__c), toLabel(arce__no_real_guarantee_type__c), arce__outstanding_amount__c, toLabel(arce__project_finance_lgd_range_id__c), toLabel(arce__treasury_prehedge_id__c), arce__current_proposed_amount__c, arce__current_approved_amount__c, toLabel(arce__real_guarantee_type__c), toLabel(arce__shareholder_gntee_limit_type__c), toLabel(arce__current_apprv_limit_term_id__c), toLabel(arce__amortization_type_desc__c) From arce__limits_exposures__c where arce__limits_exposures_parent_id__c = null and arce__account_has_analysis_id__c = :rid and arce__limits_typology_id__r.arce__Typology_Order__c >=1 and arce__limits_typology_id__r.arce__Typology_Order__c <= 5 order by arce__limits_typology_id__r.arce__Typology_Order__c];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that obtain tipology Levl 2 arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @param rid - id of the arce__account_has_analysis_id__c to obtain
    * @return arce__limits_exposures__c[] tipology L2
    * @example Arc_Gen_LimitsExposures_Data.tipologyL2(rid)
    * -----------------------------------------------------------------------------------------------
    **/
    global static arce__limits_exposures__c[] tipologyL2(Id rid) {
        return [Select Id, arce__curr_apprv_deleg_rm_amount__c, arce__limits_typology_id__c, arce__limits_typology_id__r.arce__Typology_Order__c, arce__limits_typology_id__r.arce__risk_typology_level_id__c, arce__Product_id__r.Name, arce__limits_typology_id__r.Name, arce__limits_exposures_parent_id__c, arce__limits_exposures_parent_id__r.arce__limits_typology_id__r.Name, arce__account_has_analysis_id__c, arce__curr_approved_commited_amount__c, arce__curr_apprv_uncommited_amount__c, arce__current_formalized_amount__c, RecordTypeId, toLabel(arce__cust_amortized_oblg_type__c), arce__curr_apprv_deleg_dchan_amount__c, toLabel(arce__break_clause_frequency_id__c), arce__treasury_break_clause_date__c, toLabel(arce__project_finc_calification_type__c), toLabel(arce__undly_hedge_treasury_type__c), arce__currency_id__c, toLabel(arce__notary_certification_type__c), arce__grace_months_number__c, arce__last_approved_amount__c, toLabel(arce__project_finance_rating_id__c), toLabel(arce__collection_payment_period_id__c), arce__days_period_number__c, arce__ltv_per__c, toLabel(arce__netting_type__c), toLabel(arce__no_real_guarantee_type__c), arce__outstanding_amount__c, toLabel(arce__project_finance_lgd_range_id__c), toLabel(arce__treasury_prehedge_id__c), arce__current_proposed_amount__c, arce__current_approved_amount__c, toLabel(arce__real_guarantee_type__c), toLabel(arce__shareholder_gntee_limit_type__c), toLabel(arce__current_apprv_limit_term_id__c), toLabel(arce__amortization_type_desc__c) From arce__limits_exposures__c where arce__limits_exposures_parent_id__c != null and arce__limits_typology_id__c != null and arce__account_has_analysis_id__c = :rid order by arce__limits_typology_id__r.arce__Typology_Order__c];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that obtain Modality of arce__limits_exposures__c data with all the fields
    * -----------------------------------------------------------------------------------------------
    * @param rid - id of the arce__account_has_analysis_id__c to obtain
    * @return arce__limits_exposures__c[] Modality
    * @example Arc_Gen_LimitsExposures_Data.modalityFull(rid)
    * -----------------------------------------------------------------------------------------------
    **/
    global static arce__limits_exposures__c[] modalityFull(Id rid) {
        return [Select Id, Name, arce__curr_apprv_deleg_rm_amount__c, arce__Product_id__r.Name, arce__limits_typology_id__c, toLabel(arce__cust_amortized_oblg_type__c), arce__curr_apprv_deleg_dchan_amount__c, toLabel(arce__break_clause_frequency_id__c), arce__treasury_break_clause_date__c, toLabel(arce__project_finc_calification_type__c), toLabel(arce__undly_hedge_treasury_type__c), arce__currency_id__c, toLabel(arce__notary_certification_type__c), arce__grace_months_number__c, arce__last_approved_amount__c, toLabel(arce__project_finance_rating_id__c), toLabel(arce__collection_payment_period_id__c), arce__days_period_number__c, arce__ltv_per__c, toLabel(arce__netting_type__c), toLabel(arce__no_real_guarantee_type__c), arce__outstanding_amount__c, toLabel(arce__project_finance_lgd_range_id__c), toLabel(arce__treasury_prehedge_id__c), arce__current_proposed_amount__c, arce__current_approved_amount__c, toLabel(arce__real_guarantee_type__c), toLabel(arce__shareholder_gntee_limit_type__c), toLabel(arce__current_apprv_limit_term_id__c), toLabel(arce__amortization_type_desc__c), arce__limits_exposures_parent_id__c, arce__limits_exposures_parent_id__r.Name, arce__limits_exposures_parent_id__r.arce__limits_typology_id__r.Name From arce__limits_exposures__c where arce__limits_typology_id__c = null and arce__account_has_analysis_id__c =:rid order by arce__limits_typology_id__r.arce__Typology_Order__c];
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that obtain labels of fields on arce__limits_exposures__c
    * -----------------------------------------------------------------------------------------------
    * @param fields list of strings with api names of fields
    * @return List of Strings with Label name of the fields
    * @example Arc_Gen_LimitsExposures_Data.getLabels(headers)
    * -----------------------------------------------------------------------------------------------
    **/
    global static String[] getLabels(String[] fields) {
        final String[] result = new List<String>();
        for(String field:fields) {
            result.add(mapaLim.get(field).getDescribe().getLabel());
        }
        return result;
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Method that update arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2019-09-30
    * @param data - List of arce__limits_exposures__c data to update
    * @return void
    * @example updateExposureData(data)
    * -----------------------------------------------------------------------------------------------
    **/
    global static void updateExposureData (List<arce__limits_exposures__c> data) {
        if (!data.isEmpty()) {
            update data;
        }
    }
    /**
    * -----------------------------------------------------------------------------------------------
    * @Description - Return arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @Author mariohumberto.ramirez.contractor@bbva.com
    * @Date 2019-10-25
    * @param recordIds - List<Id> of account has analysis object
    * @return List of arce__limits_exposures__c data
    * @example getExposureData(recordIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__limits_exposures__c> getExposureByDevName(List<Id> recordIds, List<String> typologiesDevName) {
        return [SELECT Id, arce__debt_desc__c, arce__account_Id__c, arce__account_Id__r.Name, arce__limits_typology_id__c, arce__limits_typology_id__r.arce__Typology_Order__c, arce__limits_typology_id__r.arce__risk_typology_level_id__c, arce__Product_id__r.Name, arce__limits_typology_id__r.Name, arce__limits_exposures_parent_id__c, arce__limits_exposures_parent_id__r.arce__limits_exposures_parent_id__c, arce__account_has_analysis_id__c, arce__last_approved_amount__c, arce__curr_approved_commited_amount__c, arce__curr_apprv_uncommited_amount__c, arce__current_formalized_amount__c, arce__current_proposed_amount__c, arce__current_approved_amount__c, arce__current_apprv_limit_term_id__c, arce__collection_payment_period_id__c, arce__break_clause_frequency_id__c, arce__cust_amortized_oblg_type__c, arce__amortization_type_desc__c, arce__grace_months_number__c, arce__currency_id__c, arce__ltv_per__c, arce__shareholder_gntee_limit_type__c, arce__real_guarantee_type__c, arce__no_real_guarantee_type__c, arce__notary_certification_type__c, arce__outstanding_amount__c, RecordTypeId, arce__curr_apprv_deleg_rm_amount__c
                FROM arce__limits_exposures__c
                WHERE arce__account_has_analysis_id__c = :recordIds AND arce__limits_typology_id__r.arce__risk_typology_level_id__c = :typologiesDevName];
    }
    /* -----------------------------------------------------------------------------------------------
    * @Description - Return arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @param recordIds - List<Id> of account has analysis object
    * @return List of arce__limits_exposures__c data
    * @example getExposureData(recordIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__limits_exposures__c> getExposureDatafromIds(Set<Id> recordId) {
        return [SELECT Id,arce__account_has_analysis_id__r.arce__Customer__r.Name,arce__account_has_analysis_id__r.arce__Customer__c, arce__limits_typology_id__c, arce__limits_typology_id__r.arce__Typology_Order__c,
        arce__limits_typology_id__r.arce__risk_typology_level_id__c, arce__Product_id__r.Name, arce__limits_typology_id__r.Name, arce__limits_exposures_parent_id__c, arce__limits_exposures_parent_id__r.arce__limits_exposures_parent_id__c,
        arce__account_has_analysis_id__c, arce__last_approved_amount__c, arce__curr_approved_commited_amount__c, arce__curr_apprv_uncommited_amount__c, arce__current_formalized_amount__c,
        arce__current_proposed_amount__c, arce__current_approved_amount__c, arce__current_apprv_limit_term_id__c, arce__collection_payment_period_id__c, arce__break_clause_frequency_id__c, arce__cust_amortized_oblg_type__c,
        arce__amortization_type_desc__c, arce__grace_months_number__c, arce__currency_id__c, arce__ltv_per__c, arce__shareholder_gntee_limit_type__c, arce__real_guarantee_type__c, arce__no_real_guarantee_type__c,
        arce__notary_certification_type__c, arce__outstanding_amount__c, RecordTypeId FROM arce__limits_exposures__c WHERE arce__Product_id__c = null AND arce__account_has_analysis_id__c IN :recordId];
    }
    /* -----------------------------------------------------------------------------------------------
    * @Description - Return arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @param recordIds - List<Id> of account has analysis object
    * @return List of arce__limits_exposures__c data
    * @example getExposurDataMod(recordIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__limits_exposures__c> getExposurDataMod(List<Id> accHasIdlts) {
        return [SELECT Id, arce__account_Id__c,arce__cust_amortized_oblg_type__c,arce__account_has_analysis_id__c,arce__treasury_break_clause_date__c,
                    arce__project_finc_calification_type__c,arce__debt_desc__c,arce__undly_hedge_treasury_type__c,CreatedById,arce__currency_id__c,
                    CurrencyIsoCode,arce__current_apprv_limit_term_id__c,arce__current_apprv_limit_term_type__c,arce__curr_apprv_deleg_rm_amount__c,
                    arce__curr_apprv_deleg_dchan_amount__c,arce__notary_certification_type__c,arce__grace_months_number__c,arce__grace_type__c,LastModifiedById,
                    arce__magnitude_unit_type__c,arce__risk_policy_type__c,arce__limit_exposure_group_amount__c,arce__project_finance_lgd_range_id__c,arce__treasury_prehedge_id__c,
                    arce__break_clause_frequency_id__c,arce__project_finance_rating_id__c,arce__collection_payment_period_id__c,arce__limits_typology_id__c,
                    arce__days_period_number__c,arce__ltv_per__c,Name,arce__netting_type__c,arce__no_real_guarantee_type__c,
                    OwnerId,arce__limits_exposures_parent_id__c,arce__Product_id__c,arce__current_proposed_amount__c,
                    arce__real_guarantee_type__c,RecordTypeId,arce__shareholder_gntee_limit_type__c,
                    arce__treasury_investment_grade_type__c,arce__amortization_type_desc__c,arce__Typology_Order__c,
                    arce__limits_typology_id__r.arce__risk_typology_level_type__c,arce__limits_exposures_parent_id__r.arce__limits_typology_id__c,
                    arce__last_approved_amount__c,arce__curr_approved_commited_amount__c,arce__curr_apprv_uncommited_amount__c,arce__current_formalized_amount__c,arce__outstanding_amount__c,
                    arce__current_approved_amount__c,arce__limits_typology_id__r.arce__risk_typology_parent_id__c,arce__limits_typology_id__r.arce__risk_typo_ext_id__c,
                    arce__account_has_analysis_id__r.arce__currency_id__c,arce__account_has_analysis_id__r.arce__magnitude_unit_type__c, arce__limits_typology_id__r.arce__risk_typology_level_id__c,
                    arce__account_has_analysis_id__r.arce__limit_exposure_ext_ind_type__c
                FROM arce__limits_exposures__c
                WHERE arce__account_has_analysis_id__c= :accHasIdlts
                ORDER BY arce__account_has_analysis_id__c, arce__limits_typology_id__r.arce__risk_typology_level_type__c];
    }
    /* -----------------------------------------------------------------------------------------------
    * @Description - Return arce__limits_exposures__c data
    * -----------------------------------------------------------------------------------------------
    * @param recordIds - List<Id> of account has analysis object
    * @return List of arce__limits_exposures__c data
    * @example getExposurDataMod(recordIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static List<arce__limits_exposures__c> getExposurDataRen(List<Id> accHasIdlts) {
        return [SELECT Id, arce__account_Id__c,arce__account_has_analysis_id__c,arce__limits_typology_id__c,
                    arce__limits_exposures_parent_id__c,arce__Product_id__c,arce__current_proposed_amount__c,
                    arce__Typology_Order__c,arce__limits_typology_id__r.arce__risk_typology_level_type__c,
                    arce__limits_exposures_parent_id__r.arce__limits_typology_id__c,RecordTypeId,
                    arce__last_approved_amount__c,arce__curr_approved_commited_amount__c,arce__curr_apprv_uncommited_amount__c,
                    arce__current_formalized_amount__c,arce__outstanding_amount__c,arce__days_period_number__c,arce__grace_months_number__c,
                    arce__current_approved_amount__c,arce__limits_typology_id__r.arce__risk_typology_parent_id__c
                FROM arce__limits_exposures__c
                WHERE arce__account_has_analysis_id__c= :accHasIdlts
                ORDER BY arce__account_has_analysis_id__c, arce__limits_typology_id__r.arce__risk_typology_level_type__c];
    }
    /* -----------------------------------------------------------------------------------------------
    * @Description - return a Map<Id,Map<String,arce__limits_exposures__c>>
    * -----------------------------------------------------------------------------------------------
    * @param recordIds - Set<Id> of account has analysis object
    * @return  Map<Id,Map<String,arce__limits_exposures__c>>
    * @example getLimExpByAccHasMap(recordIds)
    * -----------------------------------------------------------------------------------------------
    **/
    global static Map<Id,Map<String,arce__limits_exposures__c>> getLimExpByAccHasMap(Set<Id> accHasIdlts, String modRenVar) {
        Map<Id,Map<String,arce__limits_exposures__c>> limExpStructure = new Map<Id,Map<String,arce__limits_exposures__c>>();
        Map<String,arce__limits_exposures__c> limExpAux = new Map<String,arce__limits_exposures__c>();
        final List<arce__limits_exposures__c> limExpLts = modRenVar== 'ren' ? getExposurDataRen(new List<Id>(accHasIdlts)) : getExposurDataMod(new List<Id>(accHasIdlts));
        for (Id accHasId: accHasIdlts) {
            for (arce__limits_exposures__c limExp: limExpLts) {
                if (String.isBlank(limExp.arce__Product_id__c) && limExp.arce__account_has_analysis_id__c == accHasId) {
                    limExpAux.put(limExp.arce__limits_typology_id__c, limExp);
                }
            }
            limExpStructure.put(accHasId, limExpAux);
            limExpAux = new Map<String,arce__limits_exposures__c>();
        }
        return limExpStructure;
    }
    /* -----------------------------------------------------------------------------------------------
    * @Description - Method that returns a map with limit id as key and limit exposure object
    * -----------------------------------------------------------------------------------------------
    * @param   Id accHas Id
    * @param   List<Id> lstLimitId
    * @return  Map<Id,Map<String,arce__limits_exposures__c>>
    * @example Map<Id, arce__limits_exposures__c> mapExpos = getMapExposureDataAha(accHasId, limitId);
    * -----------------------------------------------------------------------------------------------
    **/
    global static Map<Id, arce__limits_exposures__c> getMapExposureDataAha(Id accHasId, List<Id> lstLimitId) {
        final Map<Id, arce__limits_exposures__c> mapLimitsData = new Map<Id, arce__limits_exposures__c>();
        final List<arce__limits_exposures__c> lstLimits = getExposurDataMod(new List<Id>{accHasId});
        for (arce__limits_exposures__c limitUnit : lstLimits) {
            if (lstLimitId.isEmpty()) {
                mapLimitsData.put(limitUnit.Id, limitUnit);
            } else if (lstLimitId.contains(limitUnit.Id)) {
                mapLimitsData.put(limitUnit.Id, limitUnit);
            }
        }
        return mapLimitsData;
    }
}