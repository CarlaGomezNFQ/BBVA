/**
  * ------------------------------------------------------------------------------------------------
  * @Name     Arc_GBL_ModRen_Utils
  * @Author   Mario Humberto Ramirez Lio mariohumberto.ramirez.contractor@bbva.com
  * @Date     Created: 2020-08-04
  * @Group    ARCE
  * ------------------------------------------------------------------------------------------------
  * @Description Utils class to manage modification and renovation logic of an ARCE
  * ------------------------------------------------------------------------------------------------
  * @Changes
  * |2020-08-04 mariohumberto.ramirez.contractor@bbva.com
  *             Class Creation
  * |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
  *             Added arce. namespace to all classes that are now in the arce-dependencies package
  * |2020-09-24 eduardoefrain.hernandez.contractor@bbva.com
  *             Update associateAccHasAn2Arce method parameters
  * |2020-10-13 eduardoefrain.hernandez.contractor@bbva.com
  *             Update getRelatedRecordsArce method to change response.lsaha assignment for modification
  * |2020-12-10 juanignacio.hita.contractor@bbva.com
  *             Add analysisId attribute of group aha in manageTraceability method
  * |2020-12-16 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Update copyAccHasAnforModification
  * |2020-12-16 mariohumberto.ramirez.contractor@bbva.com
  *             Copied evolution of the main products table records in the modification and renovation flow
  * |2021-03-11 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Added Matrix Name and Matrix CIF population.
  * |2021-03-24 eduardoefrain.hernandez.contractor@bbva.com
  *             Add copying of autoretail table in modification and renovation
  * |2021-03-29 eduardoefrain.hernandez.contractor@bbva.com
  *             Add associateRecords2AccHasAnAuto call
  * |2021-05-13 otiliaramona.veres.contractor.capacitacion@bbva.com
  *             Added static final String from ratiosList
  * |2021-05-21 juanignacio.hita.contractor@bbva.com
  *             Add exclusionFields method and call in getAhaAndRatiosList
  * |2021-05-21 juanmanuel.perez.ortiz.contractor@bbva.com
  *             Add logic to copy hotels tables records
  * |2021-05-31 juanignacio.hita.contractor@bbva.com
  *             Add at getRelatedRecordsArce method. For renovation mode the affiliates/subsidiaries tables won't copy
  *             Add exclusionMainClientSupl method for renovation mode the affiliates/subsidiaries tables won't copy
  * |2021-06-07 mariohumberto.ramirez.contractor@@bbva.com
  *             Fields were added to be excluded in renewal - GADRDCDE-2149 Marco sectoriales
  **/
@SuppressWarnings('sf:UseSingleton')
public without sharing class Arc_GBL_ModRen_Utils implements Arc_Gen_ModRen_Interface {
    /*
        @Description: String with the api value of the option Orphan customer in the picklist arce__analysis_customer_relation_type__c
    */
    static final String S_GROUP = '01';
    /*
        @Description: String with the api value of the option SUBSIDIARY in the picklist arce__group_asset_header_type__c
    */
    static final String SUBSIDIARY = '2';
    /*
        @Description: String with the character |
    */
    static final String SEPARATOR = ' | ';
    /*
        @Description: String with the value ratiosList
    */
    static final String RATIOS_LIST = 'ratiosList';
    /*
        @Description: Shareholders table identifier
    */
    static final String TBL_SHAREHOLD = '03';
    /*
        @Description: Affiliates table identifier
    */
    static final String TBL_AFFILIATES = '04';
    /**
    *-------------------------------------------------------------------------------
    * @description retrieves a wrapper (Arc_Gen_CloneWrapper) with all the objects
    *              copied from the ARCE to renew or modify.
    *-------------------------------------------------------------------------------
    * @date 04/05/2020
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param String analysisId - Analysis Id
    * @param String modRenVar - Justificacion value for setting in ARCE name or Renovation code
    * @return Arc_Gen_CloneWrapper
    * @example  public static Arc_Gen_CloneWrapper getRelatedRecordsArce(String analysisId) {
    */
    public static Arc_Gen_CloneWrapper getRelatedRecordsArce(String analysisId, String modRenVar) {
        final Set<Id> setaha = new Set<Id>();
        for(arce__Account_has_Analysis__c las : arce.Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(new List<String>{analysisId})) {
            if(String.isNotBlank(las.id)) {
                setaha.add(las.id);
            }
        }
        final Map<String, Object> ahaMap = getAhaAndRatiosList(setaha, modRenVar);
        final Arc_Gen_CloneWrapper response = new Arc_Gen_CloneWrapper();
        final List<arce__Third_Participant_Details__c> lstThirdDetails = arce.Arc_Gen_AccHasAnalysis_Data.getAccThirdPersonsData(setaha);
        response.lsarc = arce.Arc_Gen_ArceAnalysis_Data.getArceAnalysisDataToModification(new List<Id>{analysisId});
        response.lsaha = (List<arce__Account_has_Analysis__c>)ahaMap.get('ahaList');
        response.lsThirdPerson = modRenVar == arce.Arc_Gen_Constants.RENOVATION_CODE ? exclusionMainClientSupl(lstThirdDetails) : lstThirdDetails;
        response.lsGeo = arce.Arc_Gen_AccHasAnalysis_Data.getAccGeographiesData(setaha, new List<String>{'Maturity_table','Geographies','Activities'});
        response.lsMainBanks = arce.Arc_Gen_AccHasAnalysis_Data.getAccMainBanksData(setaha);
        response.lsLimExp = modRenVar == arce.Arc_Gen_Constants.RENOVATION_CODE ? arce.Arc_Gen_LimitsExposures_Data.getExposurDataRen(new List<Id>(setaha)) : arce.Arc_Gen_LimitsExposures_Data.getExposurDataMod(new List<Id>(setaha));
        response.lsRatios = (List<arce__Table_Content_per_Analysis__c>)ahaMap.get(RATIOS_LIST);
        response.lsMainContApp = Arc_Gen_HotelsTableRecords_Data.getAccContractsAppraisalsData(setaha);
        response.lsDatePeriod = Arc_Gen_HotelsTableRecords_Data.getAccDatePeriodData(setaha);
        response.lsHotelCategory = Arc_Gen_HotelsTableRecords_Data.getAccHotelCategoryData(setaha);
        response.lsHotelProjection = Arc_Gen_HotelsTableRecords_Data.getAccHotelProjectionData(setaha);
        response.evolProducts = Arc_Gen_evol_main_prod_agro_Locator.getRecordsByAccHasIds(setaha);
        response.lsAutoRetTable = Arc_Gen_AutoRetailBehaviorTable_Data.getAutoRetailToCopy(setaha);
        return response;
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the list of aha & ratios tables to copy
    * -----------------------------------------------------------------------------------------------
    * @Author  Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date    Created: 12-10-2020
    * @param   Set<Id> setaha - Set of ids of account has analysis object
    * @param   String modRenVar - Indicates if the subprocess is a renovation or a modification
    * @return  Map<String, Object>
    * @example getAhaAndRatiosList(setaha, modRenVar)
    * -----------------------------------------------------------------------------------------------
    **/
    private static Map<String, Object> getAhaAndRatiosList(Set<Id> setaha, String modRenVar) {
        Map<String, Object> ahaMap = new Map<String, Object>();
        if(modRenVar == arce.Arc_Gen_Constants.RENOVATION_CODE) {
            final List<String> fields = new List<String> {'arce__gf_cust_conn_oth_cust_ind_type__c','arce__gf_rpv_sctr_type__c','arce__gf_rpv_subsec_type__c','arce__gf_sctr_ases_cmnt_desc__c'};
            ahaMap.put('ahaList', exclusionFields(arce.Arc_Gen_AccHasAnalysis_Data.copyAccHasAnforReno(setaha, modRenVar), fields));
            ahaMap.put('ratiosList', new List<arce__Table_Content_per_Analysis__c>());
        } else {
            ahaMap = copyAccHasAnforModification(setaha, modRenVar);
        }
        return ahaMap;
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the list of aha with fields excludeds
    * -----------------------------------------------------------------------------------------------
    * @Author  juanignacio.hita.contractor@bbva.com
    * @Date    Created: 13-05-2021
    * @param   List<arce__Account_has_Analysis__c> lstAcc - List of account has analysis object
    * @param   List<String> lstFields - List of fields to be excluded
    * @return  List<arce__Account_has_Analysis__c>
    * @example exclusionFields(arce.Arc_Gen_AccHasAnalysis_Data.copyAccHasAnforReno(setaha, modRenVar), fields)
    * -----------------------------------------------------------------------------------------------
    **/
    private static List<arce__Account_has_Analysis__c> exclusionFields(List<arce__Account_has_Analysis__c> lstAcc, List<String> lstFields) {
        final Schema.SObjectType accSchema = Schema.getGlobalDescribe().get('arce__Account_has_Analysis__c');
        final Map<String, Schema.SObjectField> fieldMap = accSchema.getDescribe().fields.getMap();
        for ( arce__Account_has_Analysis__c acc : lstAcc ) {
            for ( String fieldName : fieldMap.keySet() ) {
                if (lstFields.contains(fieldName)) {
                    acc.put(fieldName, '');
                }
            }
        }
        return lstAcc;
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - return the records of modification
    * -----------------------------------------------------------------------------------------------
    * @Author  Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date    Created: 12-10-2020
    * @param   ids - Set of ids of account has analysis object
    * @return  Map<String, Object> - ahaList -> List of Aha to copy, ratiosList -> List of ratios tables to copy
    * @example copyAccHasAnforModification(ids)
    * -----------------------------------------------------------------------------------------------
    **/
    private static Map<String, Object> copyAccHasAnforModification(Set<id> ids, String modRenVar) {
        final Map<String, Object> ahaMap = new Map<String, Object>();
        final List<arce__Account_has_Analysis__c> ahaList = new List<arce__Account_has_Analysis__c>();
        final Map<String, Set<Id>> idsByFSAge = arce.Arc_Gen_AccHasAnalysis_Data.separateListsByFFSSDate(ids);
        ahaMap.put(RATIOS_LIST, new List<arce__Table_Content_per_Analysis__c>());
        if(!idsByFSAge.get('inForce').isEmpty()) {
            final List<String> tabCodesWithoutFS = new List<String>();
            for(dyfr__Tab__c tabCode: arce.Arc_Gen_AccHasAnalysis_Data.getDyFrmTabs(true)) {
                    tabCodesWithoutFS.add(tabCode.dyfr__Tab_Code__c);
            }
            ahaList.addAll(arce.Arc_Gen_AccHasAnalysis_Data.getAhaByDyFrmFields(tabCodesWithoutFS, idsByFSAge.get('inForce'), modRenVar));
            ahaMap.put(RATIOS_LIST, arce.Arc_Gen_AccHasAnalysis_Data.getAccGeographiesData(idsByFSAge.get('inForce'), new List<String>{'Balance_Sheet_Summary','Cash_Flow_Analysis','Income_Statement', 'Ratios_Magnitudes'}));
        }
        if(!idsByFSAge.get('notInForce').isEmpty()) {
            final List<String> tabCodesWithFS = new List<String>();
            for(dyfr__Tab__c tabCode: arce.Arc_Gen_AccHasAnalysis_Data.getDyFrmTabs(false)) {
                    tabCodesWithFS.add(tabCode.dyfr__Tab_Code__c);
            }
            ahaList.addAll(setEmptyFFSS(arce.Arc_Gen_AccHasAnalysis_Data.getAhaByDyFrmFields(tabCodesWithFS, idsByFSAge.get('notInForce'), modRenVar)));
        }
        ahaMap.put('ahaList', ahaList);
        return ahaMap;
    }
    /*
    * -----------------------------------------------------------------------------------------------
    * @Description - Sets the empty FFSS to a given AHA list
    * -----------------------------------------------------------------------------------------------
    * @Author  Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @Date    Created: 12-10-2020
    * @param   List<arce__Account_has_Analysis__c> ahaList - List of analyzed clients to copy
    * @return  List<arce__Account_has_Analysis__c> - ahaList -> List of Aha with the empty FFSS
    * @example setEmptyFFSS(ahaList)
    * -----------------------------------------------------------------------------------------------
    **/
    private static List<arce__Account_has_Analysis__c> setEmptyFFSS(List<arce__Account_has_Analysis__c> ahaList) {
        List<arce__Account_has_Analysis__c> ahaListUpdated = ahaList;
        final String emptyFFSS = arce.Arc_Gen_FinancialStatements_locator.getEmptyFFSS()[0].Id;
        for(arce__Account_has_Analysis__c aha : ahaListUpdated) {
            aha.arce__ffss_for_rating_id__c = emptyFFSS;
        }
        return ahaListUpdated;
    }

    /**
    *-------------------------------------------------------------------------------
    * @description clone all the information stored in Arc_Gen_CloneWrapper
    *              and retrieves the cloned records
    *-------------------------------------------------------------------------------
    * @date 04/05/2020
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param Arc_Gen_CloneWrapper records
    * @return Arc_Gen_CloneWrapper
    * @example  public static Arc_Gen_CloneWrapper cloneRecords(Arc_Gen_CloneWrapper records){
    */
    public static Arc_Gen_CloneWrapper cloneRecords(Arc_Gen_CloneWrapper records, String modRenVar) {
        final Arc_Gen_CloneWrapper response = new Arc_Gen_CloneWrapper();
        response.lsarc = records.lsarc.deepClone(false,false,false);
        response.lsaha = records.lsaha.deepClone(false,false,false);
        response.lsThirdPerson = records.lsThirdPerson.deepClone(false,false,false);
        response.lsGeo =records.lsGeo.deepClone(false,false,false);
        response.lsMainBanks = records.lsMainBanks.deepClone(false,false,false);
        response.lsLimExp = records.lsLimExp.deepClone(false, false, false);
        response.lsRatios = records.lsRatios.deepClone(false, false, false);
        response.evolProducts = records.evolProducts.deepClone(false, false, false);
        response.lsAutoRetTable = records.lsAutoRetTable.deepClone(false, false, false);
        response.lsMainContApp = records.lsMainContApp.deepClone(false,false,false);
        response.lsDatePeriod = records.lsDatePeriod.deepClone(false,false,false);
        response.lsHotelCategory = records.lsHotelCategory.deepClone(false,false,false);
        response.lsHotelProjection = records.lsHotelProjection.deepClone(false,false,false);
        response.lsarc[0].arce__Stage__c = '1';
        response.lsarc[0].arce__wf_status_id__c = '01';
        if (modRenVar == arce.Arc_Gen_Constants.RENOVATION_CODE) {
            response.lsarc[0].arce__anlys_wkfl_sub_process_type__c = '1';
        } else {
            response.lsarc[0].arce__anlys_wkfl_sub_process_type__c = '3';
            response.lsarc[0].arce__gf_curr_anlys_mod_justn_type__c = modRenVar;
        }
        List<sObject> recordsToInsert = new List<sObject>();
        recordsToInsert.addAll(response.lsThirdPerson);
        recordsToInsert.addAll(response.lsGeo);
        recordsToInsert.addAll(response.lsRatios);
        recordsToInsert.addAll(response.lsMainBanks);
        recordsToInsert.addAll(response.evolProducts);
        Arc_Gen_ModificationArce_Data.insertRecords(response.lsarc);
        Arc_Gen_NewAnalysis_data.updateArceName(response.lsarc[0].id);
        Arc_Gen_ModificationArce_Data.insertRecords(recordsToInsert);
        arce.Arc_Gen_LimitsExposures_Data.insertExposureData(response.lsLimExp);
        response.lsAutoRetByYear = setAutoRetByYear(response.lsAutoRetTable);
        Arc_Gen_ModificationArce_Data.insertRecords(response.lsAutoRetByYear);
        Arc_Gen_ModificationArce_Data.insertRecords(response.lsMainContApp);
        Arc_Gen_ModificationArce_Data.insertRecords(response.lsDatePeriod);
        Arc_Gen_ModificationArce_Data.insertRecords(response.lsHotelCategory);
        Arc_Gen_ModificationArce_Data.insertRecords(response.lsHotelProjection);
        return response;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description sets and associates all account has analysis records that
    *              were previously cloned to the object Analysis
    *-------------------------------------------------------------------------------
    * @date 2020-08-04
    * @author mariohumberto.ramirez.contractor@bbva.com
    * @param response - Arc_Gen_CloneWrapper
    * @param customerRelation - arce relation type
    * @param emptyFFSS - id of the empty ffss
    * @param Boolean persistanceInd - Indicator of the persistance metadata config
    * @param Map<String, String> data - Map with some data used for account has analysis creation
    * @return List<arce__Account_has_Analysis__c> - account has analysis records
    * @example   associateAccHasAn2Arce(response, customerRelation, persistanceStatus, Map<String, String> data)
    *-------------------------------------------------------------------------------
    */
    public static List<arce__Account_has_Analysis__c> associateAccHasAn2Arce(Arc_Gen_CloneWrapper response, String customerRelation, Boolean persistanceStatus, Map<String, String> data) {
        final String isHolding = (String) data.get('isHolding');
        final String accountswraper = (String)data.get('accountswraper');
        final List<arce.Arc_Gen_Account_Wrapper> accountsWrapLts = (List<arce.Arc_Gen_Account_Wrapper>) JSON.deserialize(accountswraper, List<arce.Arc_Gen_Account_Wrapper>.Class);
        final Map<String, Boolean> mapIsHolding = (Map<String, Boolean>) JSON.deserialize(isHolding, Map<String, Boolean>.Class);
        String mName = ''; //Matrix Name
        String mDocNumber = ''; //Matrix CIF
        if(mapIsHolding != null) {
            for (arce.Arc_Gen_Account_Wrapper acw : accountsWrapLts) {
                if (mapIsHolding.get(acw.accNumber) != null && mapIsHolding.get(acw.accNumber)) {
                    mName = acw.Name;
                    mDocNumber = acw.docNumber;
                }
            }
        }
        final List<arce__Account_has_Analysis__c> accHasAnLtsRet = response.lsaha;
        for (arce__Account_has_Analysis__c aha: accHasAnLtsRet) {
            Boolean holdingValue = mapIsHolding.get(aha.arce__customer__r.AccountNumber);
            aha.arce__Analysis__c =  response.lsarc[0].id;
            aha.arce__analysis_template_id__c = '1';
            aha.arce__gf_pv_anlys_sbanlys_ind_type__c = getInReview(aha.arce__InReview__c);
            aha.arce__persistance_callback_status_type__c = getPersistanceStatus(persistanceStatus);
            aha.arce__gf_matrix_house_name__c = Arc_Gen_NewAnalysis_Service.emptyIfNull(mName);
            aha.arce__gf_matrix_house_cif_id__c = Arc_Gen_NewAnalysis_Service.emptyIfNull(mDocNumber);
            aha.arce__main_subsidiary_ind_type__c = Arc_Gen_NewAnalysis_Service.getIsHolding(holdingValue);
            if(customerRelation == S_GROUP && aha.arce__group_asset_header_type__c == SUBSIDIARY) {
                aha.arce__InReview__c = false;
            }
        }
        return accHasAnLtsRet;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description associates all previously cloned objects to all new account has analysis objects
    *-------------------------------------------------------------------------------
    * @date 2020-08-04
    * @author mariohumberto.ramirez.contractor@bbva.com
    * @param response - Arc_Gen_CloneWrapper
    * @param mapaha - Map<String,arce__Account_has_Analysis__c>
    * @param String modRenVar - Justificacion value for setting in ARCE name or Renovation code
    * @return List<arce__Account_has_Analysis__c> - account has analysis records
    * @example   associateRecords2AccHasAn(response, mapaha, modRenVar)
    *-------------------------------------------------------------------------------
    */
    public static String associateRecords2AccHasAn(Arc_Gen_CloneWrapper response, Map<String,arce__Account_has_Analysis__c> mapaha, String modRenVar) {
        for(arce__Third_Participant_Details__c thperson : response.lsThirdPerson) {
            if(String.isNotBlank( thperson.arce__account_has_analysis_id__c)) {
                thperson.arce__account_has_analysis_id__c = mapaha.get( thperson.arce__account_has_analysis_id__c ).id;
            }
        }
        for(arce__Table_Content_per_Analysis__c geo : response.lsGeo) {
            if(String.isNotBlank( geo.arce__account_has_analysis_id__c)) {
                geo.arce__account_has_analysis_id__c = mapaha.get( geo.arce__account_has_analysis_id__c ).id;
            }
        }
        for(arce__Table_Content_per_Analysis__c ratio : response.lsRatios) {
            if(String.isNotBlank(ratio.arce__account_has_analysis_id__c)) {
                ratio.arce__account_has_analysis_id__c = mapaha.get( ratio.arce__account_has_analysis_id__c ).id;
            }
        }
        associateRecords2AccHasAnAuto(response, mapaha);
        for(arce__main_banks__c mb : response.lsMainBanks) {
            if(String.isNotBlank( mb.arce__account_has_analysis_id__c)) {
                mb.arce__account_has_analysis_id__c = mapaha.get( mb.arce__account_has_analysis_id__c ).id;
            }
        }
        //Associate records hotels template
        associateRecords2AccHasAnHot(response, mapaha);
        associateEvolProdRecords2AccHasAn(response, mapaha);
        List<arce__Table_Content_per_Analysis__c> tableContentList = new List<arce__Table_Content_per_Analysis__c>();
        tableContentList.addAll(response.lsGeo);
        tableContentList.addAll(response.lsRatios);

        Arc_Gen_ModificationArce_Data.updateRecords(response.lsThirdPerson);
        Arc_Gen_ModificationArce_Data.updateRecords(tableContentList);
        Arc_Gen_ModificationArce_Data.updateRecords(response.lsMainBanks);
        Arc_Gen_ModRenArce_Helper.updateLimitsExposureData(response, mapaha, modRenVar);
        return response.lsarc[0].id;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description associates all previously cloned objects to all new account has analysis objects for hotels template
    *-------------------------------------------------------------------------------
    * @date 2020-12-29
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param response - Arc_Gen_CloneWrapper - Wrapper with data from clone records
    * @param mapaha - Map<String,arce__Account_has_Analysis__c> - Map with account has analysis data
    * @return void
    * @example   associateRecords2AccHasAnHot(response, mapaha)
    *-------------------------------------------------------------------------------
    */
    public static void associateRecords2AccHasAnHot (Arc_Gen_CloneWrapper response, Map<String,arce__Account_has_Analysis__c> mapaha) {
        for(arce__contracts_and_appraisals__c thcontAppr : response.lsMainContApp) {
            thcontAppr.arce__account_has_analysis_id__c = mapaha.get( thcontAppr.arce__account_has_analysis_id__c ).id;
        }
        for(arce__hotel_analysis_date_period__c thdatePeriod: response.lsDatePeriod) {
            thdatePeriod.arce__account_has_analysis_id__c = mapaha.get( thdatePeriod.arce__account_has_analysis_id__c ).id;
        }
        for(arce__hotel_analysis_category__c thHotelCat : response.lsHotelCategory) {
            thHotelCat.arce__account_has_analysis_id__c = mapaha.get( thHotelCat.arce__account_has_analysis_id__c ).id;
        }
        for(arce__hotel_projection__c thHotelProj : response.lsHotelProjection) {
            thHotelProj.arce__account_has_analysis_id__c = mapaha.get( thHotelProj.arce__account_has_analysis_id__c ).id;
        }
        Arc_Gen_ModificationArce_Data.updateRecords(response.lsMainContApp);
        Arc_Gen_ModificationArce_Data.updateRecords(response.lsDatePeriod);
        Arc_Gen_ModificationArce_Data.updateRecords(response.lsHotelCategory);
        Arc_Gen_ModificationArce_Data.updateRecords(response.lsHotelProjection);
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description manage the traceability messagge
    *-------------------------------------------------------------------------------
    * @date 2020-08-04
    * @author mariohumberto.ramirez.contractor@bbva.com
    * @param arceId - id of the arce analysis
    * @param String modRenVar - Justificacion value for setting in ARCE name or Renovation code
    * @return void
    * @example   manageTraceability(arceId, modRenVar)
    *-------------------------------------------------------------------------------
    */
    public static void manageTraceability(String arceId, String modRenVar) {
        final String subprocessName = modRenVar == 'ren' ? Label.Arc_Gen_RenovationText : Label.Arc_Gen_modificationText;
        final string traceComments = Label.Arc_Gen_TraceabilityOffice + ': Placeholder Office' + ' | ' + Label.Arc_Gen_TraceabilitySubprocess + ': ' + subprocessName;
        final arce__Account_has_Analysis__c accHasGroup = arce.Arc_Gen_AccHasAnalysis_Data.getAhaGroupOfArce(arceId);
        final Map<String, String> auditAttrVal = Arc_Gen_Traceability.genAuditAttr(Label.Arc_Gen_Traceability_01, 'approve', traceComments.abbreviate(255), accHasGroup.Name);
        final Map<String, String> auditWFVal = new Map<String, String>();
        Arc_Gen_Traceability.saveTrace(arceId, auditAttrVal, auditWFVal);
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description associates evolution products table records with new acc has analysis
    *-------------------------------------------------------------------------------
    * @date 2021-02-16
    * @author mariohumberto.ramirez.contractor@bbva.com
    * @param response - Arc_Gen_CloneWrapper
    * @param mapaha - Map<String,arce__Account_has_Analysis__c>
    * @return void
    * @example   associateEvolProdRecords2AccHasAn(response, mapaha)
    *-------------------------------------------------------------------------------
    */
    public static void associateEvolProdRecords2AccHasAn(Arc_Gen_CloneWrapper response, Map<String,arce__Account_has_Analysis__c> mapaha) {
        for(arce__evol_main_prod_agro__c evolProd : response.evolProducts) {
            if(String.isNotBlank( evolProd.arce__account_has_analysis_agro_id__c)) {
                evolProd.arce__account_has_analysis_agro_id__c = mapaha.get( evolProd.arce__account_has_analysis_agro_id__c ).id;
            }
        }
        Arc_Gen_ModificationArce_Data.updateRecords(response.evolProducts);
    }
    /*
    * @description Method that get the inReview value
    *-------------------------------------------------------------------------------
    * @date 11/03/2021
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param Boolean inReview
    * @return Value of inReview
    * @example Boolean newVal = getInReview(inReview);
    */
    public static String getInReview(Boolean inReview) {
        return inReview ? Label.Arc_Gen_Yes : Label.Arc_Gen_No;
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that get the persistanceStatus value
    *-------------------------------------------------------------------------------
    * @date 11/03/2021
    * @author juanmanuel.perez.ortiz.contractor@bbva.com
    * @param Boolean persistanceStatus
    * @return Value of persistanceStatus
    * @example Boolean newVal = getPersistanceStatus(persistanceStatus);
    */
    public static String getPersistanceStatus(Boolean persistanceStatus) {
        return persistanceStatus ? '1' : '4';
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description associates all previously cloned objects to all new account has analysis objects for auto retail template
    *-------------------------------------------------------------------------------
    * @date 2021-03-24
    * @author Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @param response - Arc_Gen_CloneWrapper
    * @param mapaha - Map<String,arce__Account_has_Analysis__c>
    * @return void
    * @example   associateRecords2AccHasAnAuto(response, mapaha)
    *-------------------------------------------------------------------------------
    */
    public static void associateRecords2AccHasAnAuto (Arc_Gen_CloneWrapper response, Map<String,arce__Account_has_Analysis__c> mapaha) {
        for(arce__autoretail_behavior_table__c autoTableRecord : response.lsAutoRetTable) {
            autoTableRecord.arce__account_has_analysis_id__c = mapaha.get( autoTableRecord.arce__account_has_analysis_id__c ).id;
        }
        Arc_Gen_ModificationArce_Data.updateRecords(response.lsAutoRetTable);
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Clone the autoretail table records by year
    *-------------------------------------------------------------------------------
    * @date 2021-03-24
    * @author Eduardo Efrain Hernandez Rendon - eduardoefrain.hernandez.contractor@bbva.com
    * @param lsAutoRetTable - List of auto retail table records
    * @return List<arce__autoretail_behavior_by_year__c> - List of autoretail table records by year
    * @example setAutoRetByYear(List<arce__autoretail_behavior_table__c> lsAutoRetTable)
    *-------------------------------------------------------------------------------
    */
    private static List<arce__autoretail_behavior_by_year__c> setAutoRetByYear(List<arce__autoretail_behavior_table__c> lsAutoRetTable) {
        final List<arce__autoretail_behavior_by_year__c> yearsToInsert = new List<arce__autoretail_behavior_by_year__c>();
        for (arce__autoretail_behavior_table__c record : lsAutoRetTable) {
            for (arce__autoretail_behavior_by_year__c year : record.arce__Auto_Retail_Behavior_by_Year__r) {
                final arce__autoretail_behavior_by_year__c yearToCreate = new arce__autoretail_behavior_by_year__c(
                    arce__autoretail_behavior_table_id__c = record.Id,
                    arce__year_id__c = year.arce__year_id__c,
                    arce__gf_prd_typ_sold_units_number__c = year.arce__gf_prd_typ_sold_units_number__c,
                    arce__gf_stock_rotation_desc__c = year.arce__gf_stock_rotation_desc__c
                );
                yearsToInsert.add(yearToCreate);
            }
        }
        return yearsToInsert;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Exclude records of main clients / suppliers third participant details records
    *-------------------------------------------------------------------------------
    * @date    2021-06-08
    * @author  juanignacio.hita.contractor@bbva.com
    * @param   lstThirdDetails - List<arce__Third_Participant_Details__c>
    * @return  List<arce__Third_Participant_Details__c>
    * @example List<arce__Third_Participant_Details__c> lst = exclusionMainClientSupl(lstThirdDetails);
    *-------------------------------------------------------------------------------
    */
    public static List<arce__Third_Participant_Details__c> exclusionMainClientSupl(List<arce__Third_Participant_Details__c> lstThirdDetails) {
        final List<arce__Third_Participant_Details__c> lstNewThirdPart = new List<arce__Third_Participant_Details__c>();
        for (arce__Third_Participant_Details__c thirdPart : lstThirdDetails) {
            if (thirdPart.arce__third_participant_role_type__c == TBL_SHAREHOLD || thirdPart.arce__third_participant_role_type__c == TBL_AFFILIATES) {
                lstNewThirdPart.add(thirdPart);
            }
        }
        return lstNewThirdPart;
    }
}