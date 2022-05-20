/**
* ────────────────────────────────────────────────────────────────────
* Flat_Rates_Service
* Service class for Flat_Rates_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-10
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Flat_Rates_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Flat_Rates_Service() {}

    /**
    * @description Get flat rates info to show
    * @param contextRecordId : Id of the related Profitability Sheet / Profitability Analysis
    * @return Map<String, Object>, with needed info
    */
    public static Map<String, Object> getFlatRatesInfo(Id contextRecordId) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get sObjectName from recordId
        String sObjectName = Utils.getObjectAPIName(contextRecordId);

        // Obtain the current active version of general config mtd, and get dynamic pricing field value
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        retMap.put('dynamicPricing', genConfig.dynamic_pricing__c);

        // In funciton of sObjectName, get flat rate wrapper and needed info
        if (sObjectName == 'cuco__profitability_sheet__c') {
            retMap.putAll(Flat_Rates_Helper.getPSFlatRatesData(contextRecordId));
        } else if (sObjectName == 'cuco__profitability_analysis__c') {
            retMap.putAll(Flat_Rates_Helper.getPAFlatRatesData(contextRecordId));
        }

        return retMap;
    }

    /**
    * @description Retrieve the needed info of flat rates setup to fill form
    * @param recordId : Id of the profitability analysis context record
    * @param lstConditions : List of conditions ids of selected conditions on the previous wizard step
    * @return Map<String, Object>, with info to fill form
    */
    public static Map<String, Object> getFlatRatesSetupInfo(Id recordId, List<Id> lstConditions) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd, and get dynamic pricing field value
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        retMap.put('dynamicPricing', genConfig.dynamic_pricing__c);

        // Get Prof Analysis details and typology
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{recordId});
        retMap.put('typology', lstPA[0].gf_pa_management_type_name__c);

        // Fill map with first section info
        retMap.put('firstSection', Flat_Rates_Setup_Helper.fillFirstSectionFRSetup(lstPA[0]));

        // Fill map with second section info
        Id paFlatRateId;
        Map<String, Object> firstSectionMap = (Map<String, Object>) retMap.get('firstSection');
        if (firstSectionMap.get('paFlatRateId') != null) {
            paFlatRateId = (Id) firstSectionMap.get('paFlatRateId');
        }
        retMap.put('secondSection', Flat_Rates_Setup_Helper.fillSecondSectionFRSetup(lstPA[0], paFlatRateId));

        // Fill map with third section info
        Set<Id> setConditionsId = new Set<Id>();
        for (Id condId : lstConditions) {
            setConditionsId.add(condId);
        }
        retMap.put('thirdSection', Flat_Rates_Setup_Helper.fillThirdSectionFRSetup(lstPA[0], setConditionsId));
        return retMap;
    }

    /**
    * @description Do save actions with form data
    * @param profAnalysisId : Id of the profitability analysis context record
    * @param mapData : Map with save data from flat rates setup form
    * @return Map<String, Object>, with info to fill form
    */
    public static Map<String, Object> doFlatRatesSetupSave(Id profAnalysisId, Map<String, Object> mapData) {
        Map<String, Object> retMap = new Map<String, Object>();
        Boolean hasError = false;
        final Savepoint savePoint = Database.setSavepoint();

        // Flat rates actions
        Map<String, Object> flatRatesMap = Flat_Rates_Setup_Helper.doFlatRatesActions(profAnalysisId, mapData);

        if ((Boolean) flatRatesMap.get('isSuccess')) {

            // Flat rates account actions
            Id profAnalysisFlatRateId = (Id) flatRatesMap.get('profAnalysisFlatRateId');
            Map<String, Object> flatRatesAccMap = Flat_Rates_Setup_Helper.doFlatRatesAccActions(profAnalysisId, profAnalysisFlatRateId, mapData);
            if ((Boolean) flatRatesAccMap.get('isSuccess')) {

                // Flat rates account actions
                Map<String, Object> flatRatesCondMap = Flat_Rates_Setup_Helper.doFlatRatesCondActions(profAnalysisId, mapData);
                if ((Boolean) flatRatesCondMap.get('isSuccess')) {
                    retMap.put('isSuccess', true);
                    retMap.put('profAnalysisFlatRateId', flatRatesMap.get('profAnalysisFlatRateId'));
                } else {
                    hasError = true;
                    retMap.put('isSuccess', false);
                    retMap.put('errMessage', flatRatesCondMap.get('errMessage'));
                }
            } else {
                hasError = true;
                retMap.put('isSuccess', false);
                retMap.put('errMessage', flatRatesAccMap.get('errMessage'));
            }
        } else {
            hasError = true;
            retMap.put('isSuccess', false);
            retMap.put('errMessage', flatRatesMap.get('errMessage'));
        }


        if (hasError) {
            Database.rollback(savePoint);
        }

        return retMap;
    }
}