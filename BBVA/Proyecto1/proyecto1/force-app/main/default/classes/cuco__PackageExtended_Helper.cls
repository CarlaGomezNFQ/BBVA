/**
* ────────────────────────────────────────────────────────────────────
* PackageExtended_Helper
* Helper class for Packages_Service apex class to extended packages
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-15
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class PackageExtended_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PackageExtended_Helper() {}

    /**
    * @description Helper method to check if current profitability analysis context record already have an extended pkg
    * @param profAnalysisId : Current profitability analysis id
    * @param setConditions : Set of conditions to filter search
    * @return List<profitability_analysis_condition__c>, with the param conditions that the profitability analysis have
    */
    public static List<profitability_analysis_condition__c> checkConditionsInProfAnalysis(Id profAnalysisId, List<ps_catalog_pkg_condition__c> lstPSCatPkgCond) {
        final Set<String> setConditions = new Set<String>();
        for (ps_catalog_pkg_condition__c psCatCond : lstPSCatPkgCond) {
            setConditions.add(psCatCond.gf_psc_condition_id__r.gf_psc_condition_id__c);
        }
        final ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> lstPAC = pacSelector.selectConditionsInProfAnalysis(new Set<Id>{profAnalysisId}, setConditions);
        return lstPAC;
    }

    /**
    * @description Helper method to get PS Catalog Cond Attributes related to pkg conditions
    * @param lstPSCatPkgCond : List of catalog pkg condition to get attbs
    * @return Map<String, Object>, with the attbs related to cond
    */
    public static Map<String, List<ps_catalog_condition_attribute__c>> getAttributesFromConditions(List<ps_catalog_pkg_condition__c> lstPSCatPkgCond) {
        final Map<String, List<ps_catalog_condition_attribute__c>> retMap = new Map<String, List<ps_catalog_condition_attribute__c>>();
        final Set<Id> setIdConditions = new Set<Id>();
        for (ps_catalog_pkg_condition__c psCatCond : lstPSCatPkgCond) {
            setIdConditions.add(psCatCond.gf_psc_condition_id__c);
        }
        final List<ps_catalog_condition_attribute__c> lstCatCondAttb = PsCatalogConditionAttribute_Helper.getConditionAttributesFromConditionIds(setIdConditions);
        for (ps_catalog_condition_attribute__c psCatCondAttb : lstCatCondAttb) {
            if (retMap.get(psCatCondAttb.gf_psc_condition_id__c) == null) {
                final List<ps_catalog_condition_attribute__c> lstPSCA = new List<ps_catalog_condition_attribute__c>{psCatCondAttb};
                retMap.put(psCatCondAttb.gf_psc_condition_id__c, lstPSCA);
            } else {
                final List<ps_catalog_condition_attribute__c> lstPSCA = retMap.get(psCatCondAttb.gf_psc_condition_id__c);
                lstPSCA.add(psCatCondAttb);
                retMap.put(psCatCondAttb.gf_psc_condition_id__c, lstPSCA);
            }
        }
        return retMap;
    }

    /**
    * @description Helper method to do some actions with prof analysis pkg req and pkg conditions in funcion of edit comm pkg decision
    * @param lstPAC : Current profitability analysis conditions of ext pkg on the current prof analysis
    * @param packageWrapper : Package wrapper with the related package info
    * @param params: Map with rest of params to do logic
    * @return Map<String, Object>, with the result of the actions
    */
    public static Map<String, Object> doExtensionPkg(List<profitability_analysis_condition__c> lstPAC, Package_Wrapper pkgWrapper, Map<String, Object> params) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Id profAnalysisId = (Id) params.get('profAnalysisId');
        final String decision = (String) params.get('decision');
        final Savepoint savePoint = Database.setSavepoint();

        // First step: Handle profitability analysis pkg request in funcion of decision
        final Map<String, Object> retMapPkgReq = doExtensionPkgReqActions(profAnalysisId, decision, pkgWrapper);
        if ((Boolean) retMapPkgReq.get('isSuccess')) {
            // Second step: Handle pkg conditions in function of decision
            final Map<String, Object> retMapCond = doExtensionConditionsActions(lstPAC, pkgWrapper, params);
            if ((Boolean) retMapCond.get('isSuccess')) {
                retMap.put('isSuccess', true);
            } else {
                Database.rollback(savePoint);
                retMap.put('isSuccess', false);
                retMap.put('errMessage', Label.comm_pkg_edit_error + ' ' + retMapCond.get('errMessage'));
            }
        } else {
            Database.rollback(savePoint);
            retMap.put('isSuccess', false);
            retMap.put('errMessage', Label.comm_pkg_edit_error + ' ' + retMapPkgReq.get('errMessage'));
        }
        return retMap;
    }

    /**
    * @description Helper method to handle profitability analysis pkg req in funcion of extended pkg
    * @param profAnalysisId : Current profitability analysis id
    * @param decision : String with decision of extend of deextend current pkg
    * @param pkgWrapper : Wrapper with package info
    * @return Map<String, Object>, with the result of the check
    */
    private static Map<String, Object> doExtensionPkgReqActions(Id profAnalysisId, String decision, Package_Wrapper pkgWrapper) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // First check if exist a profitability analysis pkg req record with request type 'Extension' for this client package
        // and participant included on the pkg wrapper
        final PAPackageRequest_Selector paprSelector = new PAPackageRequest_Selector();
        final List<profitability_analysis_pkg_request__c> lstPAPR = paprSelector.selectPkgReqByReqType(new Set<Id>{pkgWrapper.clientPackageId}, profAnalysisId, new List<String>{'Extension'});

        // If record exist, delete. If no exist, create a new one in funcion of decision
        if (lstPAPR.isEmpty()) {
            final profitability_analysis_pkg_request__c newPAPR = new profitability_analysis_pkg_request__c();
            newPAPR.gf_profitablity_analysis_id__c = profAnalysisId;
            newPAPR.gf_pa_pkg_request_type_name__c = 'Extension';
            newPAPR.gf_cust_package_id__c = pkgWrapper.clientPackageId;
            newPAPR.gf_psc_package_id__c = pkgWrapper.catalogId;
            newPAPR.participant_id__c = pkgWrapper.participant.id;
            switch on decision {
                when 'extend' {
                    newPAPR.gf_pa_pkg_ext_req_st_type_name__c = 'Add';
                }
                when 'deextend' {
                    newPAPR.gf_pa_pkg_ext_req_st_type_name__c = 'Remove';
                }
            }
            final Utils.DML_Wrapper retDMLInsertPAPR = PAPackage_Service.insertPAPR(new List<profitability_analysis_pkg_request__c>{newPAPR});
            retMap.put('isSuccess', retDMLInsertPAPR.isSuccess);
            retMap.put('errMessage', retDMLInsertPAPR.lstErrMessage);
        } else {
            final Utils.DML_Wrapper retDMLDeletePAPR = PAPackage_Service.deletePAPR(lstPAPR);
            retMap.put('isSuccess', retDMLDeletePAPR.isSuccess);
            retMap.put('errMessage', retDMLDeletePAPR.lstErrMessage);
        }
        return retMap;
    }

    /**
    * @description Helper method to handle conditions actions to extend comm pkg
    * @param lstPAC : Current profitability analysis conditions of ext pkg on the current prof analysis
    * @param packageWrapper : Package wrapper with the related package info
    * @param params: Map with rest of params to do logic
    * @return Map<String, Object>, with the result of the check
    */
    private static Map<String, Object> doExtensionConditionsActions(List<profitability_analysis_condition__c> lstPAC, Package_Wrapper pkgWrapper, Map<String, Object> params) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final String decision = (String) params.get('decision');

        switch on decision {
            when 'extend' {
                final Id profAnalysisId = (Id) params.get('profAnalysisId');
                final Map<String, List<ps_catalog_condition_attribute__c>> mapCatCondAttb = (Map<String, List<ps_catalog_condition_attribute__c>>) params.get('mapCatCondAttb');
                Set<String> setCurrentCond = new Set<String>();
                final Map<String, profitability_analysis_condition__c> mapCurrentCond = new Map<String, profitability_analysis_condition__c>();
                final List<profitability_analysis_condition__c> newLstPAC = new List<profitability_analysis_condition__c>();
                if (!lstPAC.isEmpty()) {
                    for (profitability_analysis_condition__c pac : lstPAC) {
                        mapCurrentCond.put(pac.gf_psc_condition_id__r.gf_psc_condition_id__c, pac);
                    }
                    setCurrentCond = mapCurrentCond.keySet();
                }

                // Add the new one
                final List<ps_catalog_pkg_condition__c> lstCatCond = (List<ps_catalog_pkg_condition__c>) params.get('lstCatCond');
                for (ps_catalog_pkg_condition__c catCond : lstCatCond) {
                    if (setCurrentCond.contains(catCond.gf_psc_condition_id__r.gf_psc_condition_id__c)) {
                        profitability_analysis_condition__c currentPAC = mapCurrentCond.get(catCond.gf_psc_condition_id__r.gf_psc_condition_id__c);
                        currentPAC.gf_pa_cond_atrb_source_type__c = pkgWrapper.type == 'F' ? 'FORFAIT' : 'COMMERCIAL_PACKAGE';
                        currentPAC.gf_pa_source_cust_package_id__c = pkgWrapper.participant.accountCode + pkgWrapper.type + pkgWrapper.code;

                        final List<ps_catalog_condition_attribute__c> lstPsCatCondAttb = mapCatCondAttb.get(catCond.gf_psc_condition_id__r.Id);
                        currentPAC = setAttributeFieldsValue(lstPsCatCondAttb, currentPAC);
                        newLstPAC.add(currentPAC);
                    } else {
                        profitability_analysis_condition__c newPAC = new profitability_analysis_condition__c();
                        newPAC.gf_profitablity_analysis_id__c = profAnalysisId;
                        newPAC.gf_psc_condition_id__c = catCond.gf_psc_condition_id__r.Id;
                        newPAC.gf_pa_cond_atrb_source_type__c = pkgWrapper.type == 'F' ? 'FORFAIT' : 'COMMERCIAL_PACKAGE';
                        newPAC.gf_pa_source_cust_package_id__c = pkgWrapper.participant.accountCode + pkgWrapper.type + pkgWrapper.code;

                        final List<ps_catalog_condition_attribute__c> lstPsCatCondAttb = mapCatCondAttb.get(catCond.gf_psc_condition_id__r.Id);
                        newPAC = setAttributeFieldsValue(lstPsCatCondAttb, newPAC);
                        newLstPAC.add(newPAC);
                    }
                }
                final Utils.DML_Wrapper retDMLUpsertPAC = PAPackage_Service.upsertExtendedPkg(newLstPAC);
                retMap.put('isSuccess', retDMLUpsertPAC.isSuccess);
                retMap.put('errMessage', retDMLUpsertPAC.lstErrMessage);
            }
            when 'deextend' {
                final Utils.DML_Wrapper retDMLDeletePAC = PAPackage_Service.deleteExtendedPkg(lstPAC);
                retMap.put('isSuccess', retDMLDeletePAC.isSuccess);
                retMap.put('errMessage', retDMLDeletePAC.lstErrMessage);
            }
        }
        return retMap;
    }

    /**
    * @description Helper method to set dynamically falues from attributes to conditions
    * @param lstPsCatCondAttb : List of records which relate attributes with conditions
    * @param mapAttbsInfo : Map with info of each attribute
    * @param currentPAC: Current record to fill with new values
    * @return profitability_analysis_condition__c, fill with the new values
    */
    private static profitability_analysis_condition__c setAttributeFieldsValue(List<ps_catalog_condition_attribute__c> lstPsCatCondAttb, profitability_analysis_condition__c currentPAC) {
        for (ps_catalog_condition_attribute__c psCatCondAttb : lstPsCatCondAttb) {
            if (psCatCondAttb.gf_psc_ca_exemption_name__c == null) {
                currentPAC.put(String.valueof(psCatCondAttb.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c), null);
            } else {
                Schema.SObjectType schemaType = Schema.getGlobalDescribe().get('cuco__profitability_analysis_condition__c');
                Schema.DescribeSObjectResult schemaSObjectResult = schemaType.getDescribe();
                Schema.DescribeFieldResult fieldResult = schemaSObjectResult.fields.getMap().get(String.valueOf('cuco__' + psCatCondAttb.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c)).getDescribe();
                final String currentType = String.valueOf(fieldResult.getType());
                switch on currentType {
                    when 'CURRENCY', 'DECIMAL' {
                        currentPAC.put(String.valueof(psCatCondAttb.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c),  Decimal.valueof(psCatCondAttb.gf_psc_ca_exemption_name__c));
                    }
                    when 'DOUBLE' {
                        currentPAC.put(String.valueof(psCatCondAttb.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c), Double.valueof(psCatCondAttb.gf_psc_ca_exemption_name__c));
                    }
                    when 'BOOLEAN' {
                        currentPAC.put(String.valueof(psCatCondAttb.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c), Boolean.valueof(psCatCondAttb.gf_psc_ca_exemption_name__c));
                    }
                    when else {
                        currentPAC.put(String.valueof(psCatCondAttb.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c),  String.valueof(psCatCondAttb.gf_psc_ca_exemption_name__c));
                    }
                }
            }
        }
        return currentPAC;
    }
}