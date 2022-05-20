/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Remove_Helper
* Helper class for Flat_Rates_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-15
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled, PMD.TooManyMethods')
public class Flat_Rates_Remove_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Remove_Helper() {}

    /**
    * @description Returns whether the user can remove flat rates
    * @param profSheet : Wrapper with Profitability information
    * @param userId : Id of the User
    * @param typology : String with profSheet typology
    * @return Map<String, Object> map with the actions and permissions
    */
    public static Map<String, Object> checkRemoveFlatRatesPermissions(Id recordId) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        return Permissions_Helper.checkRemoveFlatRatesPermissions(genConfig, recordId);
    }

    /**
    * @description Returns the context profitability analysis complete record
    * @param recordId : Id of the flat rate record
    * @return profitability_analysis__c map with the actions and permissions
    */
    public static profitability_analysis__c getContextProfAnalysis(Id recordId) {
        return Permissions_Helper.getContextProfAnalysis(recordId);
    }

    /**
    * @description Returns the actions result  to update and delete flat rates and conditions
    * @param profAnalysisFlatRates : profitability_analysis_flat_rates__c flat rate record
    * @return Map<String, Object> a map with the return state of updates/deletes
    */
    public static Map<String, Object> checkRequestType(profitability_analysis_flat_rates__c profAnalysisFlatRates) {

        String profAnalysisId = profAnalysisFlatRates.gf_profitablity_analysis_id__c;

        Map <String, Object> mapToReturn = new Map<String, Object>();
        switch on profAnalysisFlatRates.cuco__gf_pa_fr_request_type__c {
            when 'New' {
                final Savepoint spNew = Database.setSavepoint();
                mapToReturn = removeFlatRates(profAnalysisFlatRates);
                mapToReturn = removeFlatConditions(profAnalysisFlatRates.gf_profitablity_analysis_id__c);
                checkIfNeedRollback(spNew, (Boolean) mapToReturn.get('isSuccess'));
            }
            when 'Modification' {
                String profSheetIdM = profAnalysisFlatRates.cuco__gf_profitablity_analysis_id__r.cuco__gf_profitability_sheet_id__c != null ? profAnalysisFlatRates.cuco__gf_profitablity_analysis_id__r.cuco__gf_profitability_sheet_id__c : '' ;
                Map<String, Object> mapOriginalModPS = getPSFullDetails(profSheetIdM);
                if ((Boolean) mapOriginalModPS.get('isSuccess')) {
                    final Savepoint spModification = Database.setSavepoint();
                    final ProfitabilitySheet_Wrapper psWrapper = (ProfitabilitySheet_Wrapper) mapOriginalModPS.get('profSheetDetails');
                    mapToReturn = removeFlatConditions(profAnalysisFlatRates.gf_profitablity_analysis_id__c);
                    mapToReturn = removeFlatRates(profAnalysisFlatRates);
                    mapToReturn = refreshFlat(psWrapper, profAnalysisId, false);
                    checkIfNeedRollback(spModification, (Boolean) mapToReturn.get('isSuccess'));
                } else {
                    mapToReturn.putAll(mapOriginalModPS);
                }
            }
            when 'Cancellation' {
                String profSheetIdC = profAnalysisFlatRates.cuco__gf_profitablity_analysis_id__r.cuco__gf_profitability_sheet_id__c != null ? profAnalysisFlatRates.cuco__gf_profitablity_analysis_id__r.cuco__gf_profitability_sheet_id__c : '' ;
                Map<String, Object> mapOriginalCancelPS = getPSFullDetails(profSheetIdC);
                if ((Boolean) mapOriginalCancelPS.get('isSuccess')) {
                    final Savepoint spCancellation = Database.setSavepoint();
                    final ProfitabilitySheet_Wrapper psWrapper = (ProfitabilitySheet_Wrapper) mapOriginalCancelPS.get('profSheetDetails');
                    mapToReturn = removeFlatConditions(profAnalysisFlatRates.gf_profitablity_analysis_id__c);
                    mapToReturn = removeFlatRates(profAnalysisFlatRates);
                    mapToReturn = refreshFlat(psWrapper, profAnalysisId, true);
                    checkIfNeedRollback(spCancellation, (Boolean) mapToReturn.get('isSuccess'));
                } else {
                    mapToReturn.putAll(mapOriginalCancelPS);
                }
            }
            when else {
                final Savepoint spOther = Database.setSavepoint();
                mapToReturn = removeFlatConditions(profAnalysisFlatRates.gf_profitablity_analysis_id__c);
                mapToReturn = updateFlatRequestType(profAnalysisFlatRates, 'Cancellation');
                checkIfNeedRollback(spOther, (Boolean) mapToReturn.get('isSuccess'));
            }
        }
        return mapToReturn;
    }

    /**
    * @description Update the context profitability analysis flat rates with the request type passed as a parameter
    * @param profAnalysisFlatRates : profitability analysis flat rate context object
    * @param requestType : string with the new value to update
    * @return Map <String, Object> map with the actions result
    */
    public static Map <String, Object> updateFlatRequestType(profitability_analysis_flat_rates__c profAnalysisFlatRates, String requestType) {

        // actualiza el flat rate con el request type pasado
        final Map <String, Object> mapToReturn = new Map<String, Object>();
        profAnalysisFlatRates.cuco__gf_pa_fr_request_type__c = requestType;
        Utils.DML_Wrapper updateResult = updateProfitabilityAnalysisFlatRates(new List<profitability_analysis_flat_rates__c>{profAnalysisFlatRates});
        mapToReturn.put('isSuccess', updateResult.isSuccess);
        mapToReturn.put('lstErrMessage', updateResult.lstErrMessage);
        return mapToReturn;
    }

    /**
    * @description Returns a map with the delete asociated flat conditions result
    * @param profAnalysisId : Id of the context profitability analysis
    * @return Map <String, Object> map with the actions result
    */
    public static Map <String, Object> removeFlatConditions(Id profAnalysisId) {

        final Map <String, Object> mapToReturn = new Map<String, Object>();
        //get profitability conditions to delete where source = COMMISSIONS_FLAT
        final ProfitabilityAnalysisCondition_Selector psConditionSelector = new ProfitabilityAnalysisCondition_Selector(true);
        List<profitability_analysis_condition__c> lstPsConditionSelector = psConditionSelector.byProfAnalysisIdFlatComm(new Set<Id>{profAnalysisId}, 'COMMISSIONS_FLAT');
        if (lstPsConditionSelector != null && !lstPsConditionSelector.isEmpty()) {
            Utils.DML_Wrapper deleteResult = ProfitabilityAnalysisCondition_Helper.deleteProfitabilityAnalysisCondition(lstPsConditionSelector);
            mapToReturn.put('isSuccess', deleteResult.isSuccess);
            mapToReturn.put('lstErrMessage', deleteResult.lstErrMessage);
        } else {
            mapToReturn.put('isSuccess', true);
        }
        return mapToReturn;
    }

    /**
    * @description Delete profitability analysis flat rates
    * @param profAnalysisFlatRates : object record to delete
    * @return Map <String, Object> map with the delete result
    */
    public static Map <String, Object> removeFlatRates(profitability_analysis_flat_rates__c profAnalysisFlatRates) {

        //borra el flat rate pasado como parametro
        final Map <String, Object> mapToReturn = new Map<String, Object>();
        Utils.DML_Wrapper deleteResult = deleteProfitabilityAnalysisFlatRates(new List<profitability_analysis_flat_rates__c>{profAnalysisFlatRates});
        mapToReturn.put('isSuccess', deleteResult.isSuccess);
        mapToReturn.put('lstErrMessage', deleteResult.lstErrMessage);
        return mapToReturn;
    }

    /**
    * @description Update profitability analysis flat rates
    * @param paFlatRates List<profitability_analysis_flat_rates__c> : flat rates to be updated
    * @return Utils.DML_Wrapper with the response of the DML operation
    */
    public static Utils.DML_Wrapper updateProfitabilityAnalysisFlatRates(List<profitability_analysis_flat_rates__c> paFlatRates) {
        final List<String> errors = new List<String>();
        final List<Database.SaveResult> responses = Database.update(paFlatRates, false);
        for (Database.SaveResult response : responses) {
            if (!response.isSuccess()) {
                for (Database.Error error : response.getErrors()) {
                    errors.add(error.getMessage());
                    System.debug('update profitability_analysis_flat_rates__c ERROR: ' + userInfo.getUserName() + ', ' + error.getStatusCode() + ': ' + error.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errors.isEmpty(), errors);
    }

    /**
    * @description Delete profitability analysis flat rates
    * @param paFlatRates List<profitability_analysis_flat_rates__c> : flat rates to delete
    * @return Utils.DML_Wrapper with the response of the DML operation
    */
    public static Utils.DML_Wrapper deleteProfitabilityAnalysisFlatRates(List<profitability_analysis_flat_rates__c> paFlatRates) {
        final List<String> errors = new List<String>();
        final List<Database.DeleteResult> responses = Database.delete(paFlatRates, false);
        for (Database.DeleteResult response : responses) {
            if (!response.isSuccess()) {
                for (Database.Error error : response.getErrors()) {
                    errors.add(error.getMessage());
                    System.debug('delete profitability_analysis_flat_rates__c ERROR: ' + userInfo.getUserName() + ', ' + error.getStatusCode() + ': ' + error.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errors.isEmpty(), errors);
    }

    /**
    * @description Helper method to obtain Prof sheet wrapper original data
    * @param profSheetId : Id of the profitability sheet id
    * @return Map<String, Object> with the response
    */
    private static Map<String, Object> getPSFullDetails(String profSheetId) {
        Map<String, Object> mapToReturn = new Map<String, Object>();
        final Map<String, Object> res = ProfitabilitySheet_Service.getProfSheetFullDetails(profSheetId);
        if ((Boolean) res.get('success')) {
            mapToReturn.put('isSuccess', true);
            mapToReturn.put('profSheetDetails', res.get('profSheetDetails'));
        } else {
            mapToReturn.put('isSuccess', false);
            mapToReturn.put('lstErrMessage', new List<String>{(String) res.get('errorMessage')});
        }
        return mapToReturn;
    }

    /**
    * @description refresh profitability analysis flat rates
    * @param wrapper : Wrapper with profitability sheet data
    * @param profAnalysisId : String with related profitability analysis id
    * @param refreshConditions : Boolean to refresh flat conditions
    * @return Map<String, Object> with the response of the DML operation
    */
    public static Map<String, Object> refreshFlat(ProfitabilitySheet_Wrapper wrapper, String profAnalysisId, Boolean refreshConditions) {
        Map<String, Object> mapToReturn = new Map<String, Object>();
        final FlatRates_Wrapper wrapperFlat = wrapper.flatRates;
        final String typology = refreshConditions ? 'Novation' : 'Cancellation';
        Map<String, Object> resMap = new Map<String, Object>();
        resMap = Request_Helper.createFlats(wrapperFlat, profAnalysisId, typology, mapToReturn);
        Map<String, Object> resMapFlat = new Map<String, Object>();
        if ((Boolean) resMap.get('isSuccess')) {
            //refresh flat conditions
            if (refreshConditions) {
                resMapFlat = refreshFlatConditions(wrapper, profAnalysisId, typology);
                mapToReturn = resMapFlat;
            } else {
                mapToReturn.put('isSuccess', true);
            }
        } else {
            mapToReturn.put('isSuccess', false);
            mapToReturn.put('lstErrMessage', new List<String>{(String) resMap.get('errMessage')});
        }
        return mapToReturn;
    }

    /**
    * @description refresh profitability analysis flat rates
    * @param paFlatRates List<profitability_analysis_flat_rates__c> : flat rates to refresh
    * @param requestType : string with the value of the requestType
    * @return Map<String, Object> with the response of the DML operation
    */
    public static Map<String, Object> refreshFlatConditions(ProfitabilitySheet_Wrapper wrapper, Id profAnalysisId, String typology) {

        Map<String, Object> mapToReturn = new Map<String, Object>();
        final ProfitabilityAnalysisCondition_Selector psConditionSelector = new ProfitabilityAnalysisCondition_Selector(true);

        Map<String, profitability_analysis_condition__c> mapExistingConditions = new Map<String, profitability_analysis_condition__c>();
        for (profitability_analysis_condition__c cond : psConditionSelector.byProfitabiliyAnalysisId(new Set<Id>{profAnalysisId})) {
            mapExistingConditions.put(cond.cuco__gf_psc_condition_id__c, cond);
        }
        final List<profitability_analysis_condition__c> condList = Request_Helper.instanProfACond(wrapper, profAnalysisId, typology);
        if (condList != null && !condList.isEmpty()) {
            final List<profitability_analysis_condition__c> lstToUpdate = new List<profitability_analysis_condition__c>();
            final List<profitability_analysis_condition__c> lstToDelete = new List<profitability_analysis_condition__c>();
            for (profitability_analysis_condition__c condition : condList) {
                Map<String, Object> mapCondition = checkIfExist(mapExistingConditions, condition);
                if (condition.gf_pa_cond_atrb_source_type__c == 'COMMISSIONS_FLAT') {
                    if ((Boolean) mapCondition.get('exist') && ((String) mapCondition.get('source') != 'FORFAIT' && (String) mapCondition.get('source') != 'COMMERCIAL_PACKAGE')) {
                        lstToDelete.add((profitability_analysis_condition__c) mapCondition.get('conditionToRemove'));
                        lstToUpdate.add(condition);
                    } else {
                        lstToUpdate.add(condition);
                    }
                }
            }
            if (lstToUpdate != null && !lstToUpdate.isEmpty()) {
                final Utils.DML_Wrapper insertResult = insertPAConditions(lstToUpdate);
                mapToReturn.put('isSuccess', insertResult.isSuccess);
                mapToReturn.put('lstErrMessage', insertResult.lstErrMessage);
            }

            if (lstToDelete != null && !lstToDelete.isEmpty()) {
                final Utils.DML_Wrapper insertResult = deletePAConditions(lstToDelete);
                mapToReturn.put('isSuccess', insertResult.isSuccess);
                mapToReturn.put('lstErrMessage', insertResult.lstErrMessage);
            }
        } else{
            mapToReturn.put('isSuccess', true);
        }
        return mapToReturn;
    }

    /**
    * @description Insert the Profitability Analysis records passed as parameters
    * @param lstPA: List of Profitability Analysis records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAConditions (List<profitability_analysis_condition__c> lstPAConditions) {

        List<String> errLstInsertPA = new List<String>();
        final List<Database.SaveResult> sResults = Database.insert(lstPAConditions, false);
        for (Database.SaveResult sResult : sResults) {
            if (!sResult.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPA : sResult.getErrors()) {
                    errLstInsertPA.add(errInsPA.getMessage());
                    System.debug('Insert profitability_analysis_condition__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPA.getStatusCode() + ': ' + errInsPA.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsertPA.isEmpty(), errLstInsertPA);
    }

    /**
    * @description Insert the Profitability Analysis records passed as parameters
    * @param lstPA: List of Profitability Analysis records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Map<String, Object> checkIfExist (Map<String, profitability_analysis_condition__c> lstPAConditions, profitability_analysis_condition__c condition) {

        Map<String, Object> mapToReturn = new Map<String, Object>();
        if (lstPAConditions.containsKey(condition.cuco__gf_psc_condition_id__c)) {
            mapToReturn.put('exist', true);
            mapToReturn.put('source', (String) lstPAConditions.get(condition.cuco__gf_psc_condition_id__c).cuco__gf_pa_cond_atrb_source_type__c);
            mapToReturn.put('conditionToRemove', (profitability_analysis_condition__c) lstPAConditions.get(condition.cuco__gf_psc_condition_id__c));
        } else {
            mapToReturn.put('exist', false);
        }
        return mapToReturn;
    }

    /**
    * @description Insert the Profitability Analysis records passed as parameters
    * @param lstPA: List of Profitability Analysis records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAConditions (List<profitability_analysis_condition__c> lstDeleteConditions) {

        List<String> errLstInsertPA = new List<String>();
        final List<Database.DeleteResult> sResults = Database.delete(lstDeleteConditions, false);
        for (Database.DeleteResult sResult : sResults) {
            if (!sResult.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPA : sResult.getErrors()) {
                    errLstInsertPA.add(errInsPA.getMessage());
                    System.debug('Delete profitability_analysis_condition__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPA.getStatusCode() + ': ' + errInsPA.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsertPA.isEmpty(), errLstInsertPA);
    }

    /**
    * @description Helper method to do rollback if needed, due to cognitive complexity
    * @param savePoint: Savepoint of DB to do rollback
    * @param successFlow, with the value to check if need rollback
    */
    private static void checkIfNeedRollback(Savepoint savePoint, Boolean successFlow) {
        if (!successFlow) {
            Database.rollback(savePoint);
        }
    }
}