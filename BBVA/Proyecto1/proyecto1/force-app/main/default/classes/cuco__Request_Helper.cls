/**
* ────────────────────────────────────────────────────────────────────
* Request_Helper
* Helper class for Request_Service
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-16
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Request_Helper {

    // Private constructor to avoid sonar err
    @TestVisible
    private Request_Helper() {}

    /**
    * @description check validations for requests
    * @param profSheet : ProfitabilitySheet_Wrapper
    * @param typology : String
    * @return Map<String,Object> with info for passing to the next step
    */
    public static Map<String,Object> checkValidations(ProfitabilitySheet_Wrapper profSheet, String typology) {
        Map<String,Object> mapRetValid = new Map<String,Object>();
        final Set<String> psCodeSet = new Set<String>{profSheet.code};
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector();
        final List<profitability_analysis__c> lstPA = paSelector.selectOpenByParent(psCodeSet);

        if (lstPA.isEmpty()) {
            if (profSheet.status == 'Pending Request') {
                mapRetValid.put('success',false);
                mapRetValid.put('errMessage',Label.ps_status_pending_request);
            } else {
                final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();
                final Integer numDays = Integer.valueOf(cmt.cuco__renewals_max_due_term__c);
                mapRetValid = Request_Helper.switchTypology(profSheet,typology,numDays);
            }
        } else {
            mapRetValid.put('success',false);
            mapRetValid.put('errMessage',Label.in_progress_request_error);
        }
        return mapRetValid;
    }

    /**
    * @description check permissions for requests
    * @param profSheet : ProfitabilitySheet_Wrapper
    * @param userId : id of current user
    * @return Map<String,Object> with info for checking permissions
    */
    public static Map<String,Object> checkPermissions(ProfitabilitySheet_Wrapper profSheet, Id userId, String typology) {
        return Permissions_Service.checkCreateRequestPermissions(profSheet, userId, typology);
    }

    /**
    * @description instantiate and create records of profitability analysis
    * @param profSheet : ProfitabilitySheet_Wrapper
    * @param typology : String value of profSheet typology
    * @return Map<String,Object> with info of the new record of profitability analysis in case is created or creation errors
    */
    public static Map<String,Object> createProfAnalysis(ProfitabilitySheet_Wrapper profSheet, String typology) {
        Map<String,Object> retMap = new Map<String,Object>();

        //Create savePoint
        final Savepoint savePoint = Database.setSavepoint();

        Date selectedDateEff = null;
        Date selectedDateExp = null;
        if(typology == Label.renewal) {
            selectedDateEff = profSheet.endDate.addDays(1);
            selectedDateExp = profSheet.endDate.addMonths(12);
        } else if(typology == Label.novation) {
            selectedDateEff = profSheet.startDate;
            selectedDateExp = profSheet.endDate;
        }

        final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();
        final profitability_analysis__c profAnalysis = new profitability_analysis__c(
            Name = profSheet.name,
            cuco__participant_id__c = profSheet.groupId,
            cuco__gf_profitability_sheet_id__c = profSheet.id,
            cuco__gf_pa_management_type_name__c = typology,
            cuco__segment_type__c = cmt.segment_type__c,
            cuco__gf_pa_cond_appl_eff_date__c = selectedDateEff,
            cuco__gf_pa_cond_appl_expiry_date__c = selectedDateExp,
            cuco__gf_pa_mgmt_stage_type_name__c = 'Analysis',
            cuco__gf_pa_mgmt_status_type_name__c = 'Analysis',
            cuco__gf_all_ct_apply_cond_ind_type__c = profSheet.isSpecificContractsScope,
            cuco__gf_pa_forced_mf_mgmt_ind_type__c = profSheet.isForcedManualManagement
        );

        final profitability_analysis__c setPARecord = ProfitabilityAnalysis_Service.setPADefaultRequestData(profAnalysis, profSheet.branchCode, profSheet.ownerCode);
        final List<profitability_analysis__c> lstPA = new List<profitability_analysis__c>();
        lstPA.add(setPARecord);

        final Utils.DML_Wrapper retDMLInsertPA = PAPackage_Service.insertPA(lstPA);
        retMap.put('isSuccess', retDMLInsertPA.isSuccess);
        retMap.put('errMessage', retDMLInsertPA.lstErrMessage);
        if(retMap.get('isSuccess') == true) {

            final String profAnalysisId = lstPA[0].Id;
            retMap.put('profAId',profAnalysisId);
            retMap = Request_Helper.createMoreData(retMap, profAnalysisId, profSheet, typology);
        }

        if (!(Boolean) retMap.get('isSuccess')) {
            Database.rollback(savePoint);
        }

        //Return id of profitability analysis
        return retMap;
    }

    /**
    * @description private method to fill a map with the result of creation data
    * @param retMap : Map<String,Object> with the response
    * @param profAnalysisId : String with id of profitability analysis
    * @param profSheet : ProfitabilitySheet_Wrapper
    * @param typology : String with typology of profitability analysis
    * @return Map<String,Object> with response
    */
    private static Map<String,Object> createMoreData(Map<String,Object> retMap, String profAnalysisId, ProfitabilitySheet_Wrapper profSheet, String typology) {
        Map<String,Object> retMapData = new Map<String,Object>();
        retMapData = retMap;

        //Participants
        final List<profitability_analysis_participant__c> partList = instanProfAPart(profSheet,profAnalysisId);
        Map<String,profitability_analysis_participant__c> mapParticipants = new Map<String,profitability_analysis_participant__c>();
        if(!partList.isEmpty()) {
            final Utils.DML_Wrapper retDMLInsertPAP = PAPackage_Service.insertPAP(partList);
            retMapData.put('isSuccess', retDMLInsertPAP.isSuccess);
            retMapData.put('errMessage', retDMLInsertPAP.lstErrMessage);
            mapParticipants = Request_Helper.createMapPart(retMapData, profAnalysisId);
        }

        //Conditions
        final List<profitability_analysis_condition__c> condList = instanProfACond(profSheet,profAnalysisId,typology);
        if(!condList.isEmpty()) {
            final Utils.DML_Wrapper retDMLInsertPAC = PAPackage_Service.insertPAC(condList);
            retMapData.put('isSuccess', retDMLInsertPAC.isSuccess);
            retMapData.put('errMessage', retDMLInsertPAC.lstErrMessage);
        }

        //Flats
        final FlatRates_Wrapper flatRatesWrapp = profSheet.flatRates;
        if(flatRatesWrapp != null) {
            retMapData = Request_Helper.createFlats(flatRatesWrapp,profAnalysisId,typology,retMap);
        }

        //Request Packages
        final List<Package_Wrapper> lstPackWrapp = profSheet.packagesList;
        if(lstPackWrapp != null && typology == Label.cancellation) {
            retMapData = Request_Helper.createReqPackages(profAnalysisId,lstPackWrapp,retMap,mapParticipants);
        }

        return retMapData;
    }

    /**
    * @description private method to fill a map with the result of a loop over created profitability analysis participants
    * @param retMap : Map<String,Object> with the response
    * @param profAnalysisId : String with id of profitability analysis
    * @return Map of new profitability analysis participant with participantId as key
    */
    private static Map<String,profitability_analysis_participant__c> createMapPart(Map<String,Object> retMap, String profAnalysisId) {
        Map<String,profitability_analysis_participant__c> mapParticipants = new Map<String,profitability_analysis_participant__c>();
        if(retMap.get('isSuccess') == true) {
            final Set<Id> paParticipantsId = new Set<Id>{profAnalysisId};
            final PAPArticipant_Selector papSelector = new PAPArticipant_Selector(true);
            final List<profitability_analysis_participant__c> participants = papSelector.selectByProfAnalysis(paParticipantsId);
            for(profitability_analysis_participant__c part : participants) {
                mapParticipants.put(part.cuco__participant_id__c,part);
            }
        }
        return mapParticipants;
    }

    /**
    * @description private method to fill a map with the result of a switch selection
    * @param profSheet : ProfitabilitySheet_Wrapper
    * @param typology : typology of profSheet
    * @param numDays : numDays to do validations
    * @return List of new profitability analysis participant
    */

    private static Map<String,Object> switchTypology(ProfitabilitySheet_Wrapper profSheet,String typology, Integer numDays) {
        final Map<String,Object> mapRetValid = new Map<String,Object>();
        switch on typology {
            when 'Renewal' {
                final Date todayDate = Date.today();
                if(profSheet.status == Label.valid || (profSheet.status == Label.expired && todayDate <= profSheet.endDate.addDays(numDays))) {
                    mapRetValid.put('success',true);
                } else {
                    mapRetValid.put('success',false);
                    mapRetValid.put('errMessage',Label.ps_status_renewal);
                }
            }
            when 'Novation' {
                if(profSheet.status == Label.valid) {
                    mapRetValid.put('success',true);
                } else {
                    mapRetValid.put('success',false);
                    mapRetValid.put('errMessage',Label.ps_status_novation);
                }
            }
            when 'Cancellation' {
                if(profSheet.status == Label.valid) {
                    mapRetValid.put('success',true);
                } else {
                    mapRetValid.put('success',false);
                    mapRetValid.put('errMessage',Label.ps_status_cancellation);
                }
            }
            when else {
                mapRetValid.put('success',false);
                mapRetValid.put('errMessage',Label.wrong_typology);
            }
        }
        return mapRetValid;
    }

    /**
* @description private method to instantiate records of profitability analysis participant
* @param profAnalysisId : profitability analysis record id
* @param profSheet : ProfitabilitySheet_Wrapper
* @return List of new profitability analysis participant
*/

    private static List<profitability_analysis_participant__c> instanProfAPart(ProfitabilitySheet_Wrapper profSheet, String profAnalysisId) {
        final List<profitability_analysis_participant__c> lstPart = new List<profitability_analysis_participant__c>();
        final List<ProfitabilitySheet_Wrapper.Participant> participants = profSheet.participantsList;
        if(!participants.isEmpty()) {
            for(ProfitabilitySheet_Wrapper.Participant psPart : participants) {
                final profitability_analysis_participant__c newProfAPart = new profitability_analysis_participant__c(
                    cuco__gf_profitablity_analysis_id__c = profAnalysisId,
                    cuco__participant_id__c = psPart.id
                );
                lstPart.add(newProfAPart);
            }
        }

        return lstPart;
    }

    /**
* @description private method to instantiate records of profitability analysis condition
* @param profAnalysisId : profitability analysis record id
* @param profSheet : ProfitabilitySheet_Wrapper
* @param typology : typology of profSheet
* @return List of new profitability analysis condition
*/

    public static List<profitability_analysis_condition__c> instanProfACond(ProfitabilitySheet_Wrapper profSheet, String profAnalysisId, String typology) {
        final List<profitability_analysis_condition__c> lstCond = new List<profitability_analysis_condition__c>();
        final List<ProfitabilitySheet_Wrapper.Condition> conditions = profSheet.conditionsList;
        if(!conditions.isEmpty()) {
            final Map<Id,ps_catalog_attribute__c> mapAttributes = new Map<Id,ps_catalog_attribute__c>();
            final Map<Id,ps_catalog_condition__c> mapConditions = new Map<Id,ps_catalog_condition__c>();
            final Map<Id,ps_catalog_condition__c> mapConditActiv = new Map<Id,ps_catalog_condition__c>();

            final PsCatalogAttribute_Selector psCatAttSelector = new PsCatalogAttribute_Selector(true);
            final List<ps_catalog_attribute__c> lstPSCatAtt = psCatAttSelector.selectAllAttributes(100);
            final PsCatalogCondition_Selector psCatCondSelector = new PsCatalogCondition_Selector(true);
            final List<ps_catalog_condition__c> lstPSCatCond = psCatCondSelector.selectPriceClassConditions();
            final List<ps_catalog_condition__c> lstPSCatCondActive = psCatCondSelector.selectActiveCatalogConditions();

            for(ps_catalog_attribute__c att : lstPSCatAtt) {
                mapAttributes.put(att.Id,att);
            }
            for(ps_catalog_condition__c cond : lstPSCatCond) {
                mapConditions.put(cond.Id,cond);
            }
            for(ps_catalog_condition__c condi : lstPSCatCondActive) {
                mapConditActiv.put(condi.Id,condi);
            }

            for(ProfitabilitySheet_Wrapper.Condition profACond : conditions) {
                final List<ProfitabilitySheet_Wrapper.Attribute> listAttributes = profACond.attributesList;
                if(typology != Label.cancellation || (typology == Label.cancellation && profACond.source != 'COMMERCIAL_PACKAGE' && profACond.source != 'GIP_PACKAGE' && profACond.source != 'FORFAIT')) {
                    final profitability_analysis_condition__c newProfACond = new profitability_analysis_condition__c(
                        cuco__gf_profitablity_analysis_id__c = profAnalysisId,
                        cuco__gf_psc_condition_id__c = profACond.id,
                        cuco__gf_pa_cond_atrb_source_type__c = profACond.source,
                        cuco__gf_pa_source_cust_package_id__c = profACond.sourceCode
                    );

                    //fill attributes
                    Request_Helper.fillAttributes(mapAttributes, listAttributes, newProfACond);

                    //fill conditions with price class type
                    Request_Helper.fillConditions(mapConditions, profACond, newProfACond);

                    if (typology == Label.cancellation) {
                        lstCond.add(newProfACond);
                    } else if (mapConditActiv.containsKey(profACond.id)) {
                        lstCond.add(newProfACond);
                    }
                }
            }
        }
        return lstCond;
    }

    /**
* @description private method to fill attributes
* @param mapAttributes : Map<Id,ps_catalog_attribute__c>
* @param listAttributes : List<ProfitabilitySheet_Wrapper.Attribute>
* @param newProfACond : profitability_analysis_condition__c
*/

    private static void fillAttributes(Map<Id,ps_catalog_attribute__c> mapAttributes, List<ProfitabilitySheet_Wrapper.Attribute> listAttributes, profitability_analysis_condition__c newProfACond) {
        for(ProfitabilitySheet_Wrapper.Attribute attribute : listAttributes) {
            if(mapAttributes.containsKey(attribute.Id)) {
                final String dataType = mapAttributes.get(attribute.Id).cuco__gf_attribute_value_type_name__c;
                if(dataType == 'Permillage' || dataType == 'Currency' || dataType == 'Number' || dataType == 'Percent') {
                    final Decimal valueDecimal = Decimal.valueOf(attribute.value);
                    newProfACond.put(mapAttributes.get(attribute.Id).cuco__gf_stored_prps_atrb_field_name__c,valueDecimal);
                } else if(dataType == 'Checkbox') {
                    final Boolean valueBoolean =  attribute.value == 'S' ? true : Boolean.valueOf(attribute.value);
                    newProfACond.put(mapAttributes.get(attribute.Id).cuco__gf_stored_prps_atrb_field_name__c,valueBoolean);
                } else {
                    newProfACond.put(mapAttributes.get(attribute.Id).cuco__gf_stored_prps_atrb_field_name__c,attribute.value);
                }
            }
        }
    }

    /**
* @description private method to fill conditions
* @param mapConditions : Map<Id,ps_catalog_condition__c>
* @param listAttributes : List<ProfitabilitySheet_Wrapper.Condition>
* @param newProfACond : profitability_analysis_condition__c
*/

    private static void fillConditions(Map<Id,ps_catalog_condition__c> mapConditions, ProfitabilitySheet_Wrapper.Condition profACond, profitability_analysis_condition__c newProfACond) {
        if(mapConditions.containsKey(profACond.id)) {
            if(newProfACond.cuco__gf_pa_cond_prps_fix_amount__c == null) {
                newProfACond.cuco__gf_pa_cond_prps_prc_type_name__c = 'EF';
            } else {
                newProfACond.cuco__gf_pa_cond_prps_prc_type_name__c = 'IF';
            }
        }
    }

    /**
* @description public method to impelemnt logic for profitability analysis flat rates creation
* @param profAnalysisId : profitability analysis record id
* @param flatRatesWrapp : FlatRates_Wrapper
* @param typology : typology of profSheet
* @param retMap : Map<String,Object> with previous status
* @return map with the response
*/
    public static Map<String,Object> createFlats(FlatRates_Wrapper flatRatesWrapp, String profAnalysisId, String typology, Map<String,Object> retMap) {
        Map<String,Object> retMapFlatDp = new Map<String,Object>();
        retMapFlatDp = retMap;
        final List<profitability_analysis_flat_rates__c> flatList = instPAFlatRates(flatRatesWrapp,profAnalysisId,typology);
        if(!flatList.isEmpty()) {
            final Utils.DML_Wrapper retDMLInsertFlat = PAPackage_Service.insertPAFlatRates(flatList);
            retMapFlatDp.put('isSuccess', retDMLInsertFlat.isSuccess);
            retMapFlatDp.put('errMessage', retDMLInsertFlat.lstErrMessage);
            if(retMapFlatDp.get('isSuccess') == true) {
                //Logic for flatRatesAccountList and flatRatesDPList
                final String paFlatRateId = flatList[0].Id;

                //try to insert flatRatesAccountList
                final List<profitability_analysis_flatrates_account__c> lstPAFlatAcc = checkAccList(flatRatesWrapp,paFlatRateId);
                if(!lstPAFlatAcc.isEmpty()) {
                    final Utils.DML_Wrapper retDMLInsFlatAcc = PAPackage_Service.insertPAFlatAcc(lstPAFlatAcc);
                    retMapFlatDp.put('isSuccess', retDMLInsFlatAcc.isSuccess);
                    retMapFlatDp.put('errMessage', retDMLInsFlatAcc.lstErrMessage);
                }

                //try to insert flatRatesDPList
                final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();
                if(cmt.dynamic_pricing__c) {
                    final List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP = checkDPList(flatRatesWrapp,paFlatRateId);
                    retMapFlatDp = Request_Helper.callInsPAFlatDP(lstPAFlatDP,retMap);
                }
            }
        }
        return retMapFlatDp;
    }

    /**
* @description private method to impelemnt logic for inserting profitability analysis flats dp
* @param lstPAFlatDP : List<profitability_analysis_flat_rates_dp__c>
* @param retMap : Map<String,Object> with previous status
* @return map with the response
*/

    private static Map<String,Object> callInsPAFlatDP(List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP, Map<String,Object> retMap) {
        if(!lstPAFlatDP.isEmpty()) {
            final Utils.DML_Wrapper retDMLInsFlatDP = PAPackage_Service.insertPAFlatDP(lstPAFlatDP);
            retMap.put('isSuccess', retDMLInsFlatDP.isSuccess);
            retMap.put('errMessage', retDMLInsFlatDP.lstErrMessage);
        }
        return retMap;
    }

    /**
* @description private method to instantiate records of profitability analysis flat rates
* @param profAnalysisId : profitability analysis record id
* @param flatRatesWrapp : FlatRates_Wrapper
* @param typology : typology of profSheet
* @return List of new profitability analysis flat rates
*/

    private static List<profitability_analysis_flat_rates__c> instPAFlatRates(FlatRates_Wrapper flatRatesWrapp, String profAnalysisId, String typology) {
        final List<profitability_analysis_flat_rates__c> lstPAFlat = new List<profitability_analysis_flat_rates__c>();
        String requestType = '';
        if(typology == Label.cancellation) {
            requestType = Label.cancellation;
        }
        if(flatRatesWrapp != null) {
            final profitability_analysis_flat_rates__c flatRate = new profitability_analysis_flat_rates__c(
                cuco__gf_profitablity_analysis_id__c = profAnalysisId,
                cuco__gf_pa_fr_price_type__c = flatRatesWrapp.priceType,
                cuco__gf_pa_fr_fixed_annual_amount__c = flatRatesWrapp.fixedAmount,
                cuco__gf_pa_fr_variable_amount_desc__c = flatRatesWrapp.variableAmountDesc,
                cuco__gf_pa_fr_charge_pdicy_type__c = flatRatesWrapp.periodicityChageType,
                cuco__gf_pa_fr_charge_type__c = flatRatesWrapp.chargeType,
                cuco__gf_pa_fr_currency_type__c = flatRatesWrapp.currencyType,
                cuco__gf_pa_fr_charge_date_type__c = flatRatesWrapp.chargeDay,
                cuco__gf_pa_fr_pv_wrkdy_ch_meth_type__c = flatRatesWrapp.nonWorkingDayChargeMethod,
                cuco__gf_pa_fr_ac_no_bal_method_type__c = flatRatesWrapp.accWithoutBalanceMethod,
                cuco__gf_pa_fr_request_type__c = requestType
            );
            lstPAFlat.add(flatRate);
        }
        return lstPAFlat;
    }

    /**
* @description private method to instantiate records of profitability analysis flat rates
* @param paFlatRateId : profitability analysis flat rate record id
* @param flatRatesWrapp : FlatRates_Wrapper
* @return List of new profitability analysis flat rates account
*/

    private static List<profitability_analysis_flatrates_account__c> checkAccList(FlatRates_Wrapper flatRatesWrapp, String paFlatRateId) {
        final List<profitability_analysis_flatrates_account__c> lstPAFlatAcc = new List<profitability_analysis_flatrates_account__c>();
        if(flatRatesWrapp.flatRatesAccountList != null) {
            final List<FlatRates_Wrapper.FlatRatesAccount> lstAccountWrapp = flatRatesWrapp.flatRatesAccountList;
            if(!lstAccountWrapp.isEmpty()) {
                for(FlatRates_Wrapper.FlatRatesAccount flRatAccWrapp : lstAccountWrapp) {
                    final profitability_analysis_flatrates_account__c flatRateAcc = new profitability_analysis_flatrates_account__c(
                        cuco__gf_pa_flat_rate_id__c = paFlatRateId,
                        cuco__gf_pa_flat_rate_account_id__c = flRatAccWrapp.id,
                        cuco__gf_pa_fr_ac_use_per__c = flRatAccWrapp.usePercent
                    );
                    lstPAFlatAcc.add(flatRateAcc);
                }
            }
        }
        return lstPAFlatAcc;
    }

    /**
* @description private method to instantiate records of profitability analysis flat rates
* @param paFlatRateId : profitability analysis flat rate record id
* @param flatRatesWrapp : FlatRates_Wrapper
* @return List of new profitability analysis flat rates account
*/

    private static List<profitability_analysis_flat_rates_dp__c> checkDPList(FlatRates_Wrapper flatRatesWrapp, String paFlatRateId) {
        final List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP = new List<profitability_analysis_flat_rates_dp__c>();
        if(flatRatesWrapp.flatRatesDPList != null) {
            final List<FlatRates_Wrapper.FlatRatesDP> lstDPWrapp = flatRatesWrapp.flatRatesDPList;
            if(!lstDPWrapp.isEmpty()) {
                final Map<Id,ps_catalog_attribute__c> mapAttributes = new Map<Id,ps_catalog_attribute__c>();
                final PsCatalogAttribute_Selector psCatAttSelector = new PsCatalogAttribute_Selector(true);
                final List<ps_catalog_attribute__c> lstPSCatAtt = psCatAttSelector.selectAllAttributes(100);

                for(ps_catalog_attribute__c att : lstPSCatAtt) {
                    mapAttributes.put(att.Id,att);
                }

                for(FlatRates_Wrapper.FlatRatesDP flRatDPWrapp : lstDPWrapp) {
                    final List<FlatRates_Wrapper.DPAttribute> listAttributesDP = flRatDPWrapp.dpAttributeList;
                    final profitability_analysis_flat_rates_dp__c newflatRateDP = new profitability_analysis_flat_rates_dp__c(
                        cuco__gf_pa_flat_rate_id__c = paFlatRateId
                    );

                    for(FlatRates_Wrapper.DPAttribute attDP : listAttributesDP) {
                        //fill ps catalog attributes dp
                        Request_Helper.fillAttributesDP(mapAttributes, attDP, newflatRateDP);

                        //fill pricing
                        newflatRateDP.cuco__gf_fr_dynamic_pricing_item_id__c = flRatDPWrapp.Id;
                    }

                    lstPAFlatDP.add(newflatRateDP);
                }
            }
        }
        return lstPAFlatDP;
    }

    /**
* @description private method to fill attributes dp
* @param mapAttributes : Map<Id,ps_catalog_attribute__c>
* @param attDP : FlatRates_Wrapper.DPAttribute
* @param newflatRateDP : profitability_analysis_flat_rates_dp__c
*/

    private static void fillAttributesDP(Map<Id,ps_catalog_attribute__c> mapAttributes, FlatRates_Wrapper.DPAttribute attDP, profitability_analysis_flat_rates_dp__c newflatRateDP) {
        if(mapAttributes.containsKey(attDP.id)) {
            final String dataType = mapAttributes.get(attDP.Id).cuco__gf_attribute_value_type_name__c;
            if(dataType == 'Permillage' || dataType == 'Currency' || dataType == 'Number' || dataType == 'Percent') {
                final Decimal valueDecimal = Decimal.valueOf(attDP.value);
                newflatRateDP.put(mapAttributes.get(attDP.Id).cuco__gf_stored_prps_atrb_field_name__c,valueDecimal);
            } else if(dataType == 'Checkbox') {
                final Boolean valueBoolean = Boolean.valueOf(attDP.value);
                newflatRateDP.put(mapAttributes.get(attDP.Id).cuco__gf_stored_prps_atrb_field_name__c,valueBoolean);
            } else {
                newflatRateDP.put(mapAttributes.get(attDP.Id).cuco__gf_stored_prps_atrb_field_name__c,attDP.value);
            }
        }
    }

    /**
* @description private method to impelemnt logic for request packages creation
* @param profAnalysisId : profitability analysis record id
* @param lstPackWrapp : List<Package_Wrapper>
* @param retMap : Map<String,Object> with previous status
* @param mapParticipants : Map<String,profitability_analysis_participant__c> with profitability analysis participants
* @return map with the response
*/
    private static Map<String,Object> createReqPackages(String profAnalysisId, List<Package_Wrapper> lstPackWrapp, Map<String,Object> retMap, Map<String,profitability_analysis_participant__c> mapParticipants) {
        Map<String,Object> retMapReqPack = new Map<String,Object>();
        retMapReqPack = retMap;
        final List<profitability_analysis_pkg_request__c> lstRequestPck = instReqPackages(profAnalysisId, lstPackWrapp, mapParticipants);
        if(!lstRequestPck.isEmpty()) {
            final Utils.DML_Wrapper retDMLInsertPack = PAPackage_Service.insertPAPR(lstRequestPck);
            retMapReqPack.put('isSuccess', retDMLInsertPack.isSuccess);
            retMapReqPack.put('errMessage', retDMLInsertPack.lstErrMessage);
        }
        return retMapReqPack;
    }

    /**
* @description private method to instantiate records of request package
* @param profAnalysisId : profitability analysis record id
* @param lstPackWrapp : List<Package_Wrapper>
* @param mapParticipants : Map<String,profitability_analysis_participant__c>
* @return List of new request packages
*/

    private static List<profitability_analysis_pkg_request__c> instReqPackages(String profAnalysisId, List<Package_Wrapper> lstPackWrapp, Map<String,profitability_analysis_participant__c> mapParticipants) {
        final List<profitability_analysis_pkg_request__c> lstRequestPck = new List<profitability_analysis_pkg_request__c>();
        for(Package_Wrapper packageInfo : lstPackWrapp) {

            /* get participant */
            final Package_Wrapper.Participant part = packageInfo.participant;
            String participantId = null;
            if(part != null && !mapParticipants.isEmpty()) {
                participantId = mapParticipants.get(part.accountId).Id;
            }

            /* get status */
            final Package_Wrapper.Status stat = packageInfo.status;
            final String status = stat.id;

            /* check type */
            if((packageInfo.type == 'G' || packageInfo.type == 'F') && status == Label.valid) {
                final cuco__profitability_analysis_pkg_request__c reqPackCan = new cuco__profitability_analysis_pkg_request__c(
                    cuco__gf_profitablity_analysis_id__c = profAnalysisId,
                    cuco__gf_cust_package_id__c = packageInfo.clientPackageId,
                    cuco__participant_id__c = participantId,
                    cuco__gf_pa_pkg_request_type_name__c = 'Cancellation',
                    cuco__gf_psc_package_id__c = packageInfo.catalogId,
                    cuco__gf_pa_pkg_req_comments_desc__c = Label.remove_pkg_manual_cancel_comments
                );
                lstRequestPck.add(reqPackCan);
            }
            /* check if is extended */
            if((Boolean)packageInfo.isExtended == true) {
                final cuco__profitability_analysis_pkg_request__c reqPackDex = new cuco__profitability_analysis_pkg_request__c(
                    cuco__gf_profitablity_analysis_id__c = profAnalysisId,
                    cuco__gf_pa_pkg_request_type_name__c = 'Extension',
                    cuco__gf_cust_package_id__c = packageInfo.clientPackageId,
                    cuco__gf_psc_package_id__c = packageInfo.catalogId,
                    cuco__participant_id__c = participantId,
                    cuco__gf_pa_pkg_ext_req_st_type_name__c = 'Remove'
                );
                lstRequestPck.add(reqPackDex);
            }
        }
        return lstRequestPck;
    }
}