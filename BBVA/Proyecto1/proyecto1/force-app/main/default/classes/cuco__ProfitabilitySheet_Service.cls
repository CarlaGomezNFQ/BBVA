/**
* ____________________________________________________________________________
* Profitability Sheet Service
* Service class for the object profitability_sheet__c
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-18
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
global class ProfitabilitySheet_Service {

    /**
    * @description private constructor
    */
    @TestVisible
    private ProfitabilitySheet_Service() {}

    /*
    * @description Returns a String with branch code
    * @param genConfig : Metadata record with the general configuration of classes
    * @param userId : Id user
    * @return String, with the user Code
    */
    public static String getBranchCode(Id contextId) {
        return ProfitabilityAnalysis_Service.getBranchCode(contextId);
    }

    /**
    * @description returns conditions from a Profitability Sheet
    * @param profSheetId : Ids of Profitability Sheet
    * @return Map<String,Object>, lwith details
    */
    global static Map<String,Object> getProfSheetFullDetails(Id profSheetId) {

        Map<String,Object> res = new Map<String,Object>();
        final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();

        if (config.retrieve_ps_from_backend_type__c) {
            res = BackendIntegration_Helper.getProfSheetFullDetails(profSheetId);
        } else {
            res = ProfitabilitySheet_Helper.getProfSheetFullDetails(profSheetId);
        }
        return res;
    }

    /**
    * @description returns conditions from a Profitability Sheet
    * @param profSheetId : Ids of Profitability Sheet
    * @return JSON String with details
    */
    public static String getPSActualValues(Id profSheetId) {
        final List<Map<String, Object>> res = getPSActualValuesMap(profSheetId);
        return JSON.serialize(res);
    }

    /**
    * @description returns conditions from a Profitability Sheet
    * @param profSheetId : Ids of Profitability Sheet
    * @return List<Map<String, Object>> with details
    */
    public static List<Map<String, Object>> getPSActualValuesMap(Id profSheetId) {
        final Map<String,Object> fullDetails = getProfSheetFullDetails(profSheetId);
        final List<Map<String, Object>> res = getPSActualValuesMap(fullDetails);
        return res;
    }

    /**
    * @description returns conditions from a Profitability Sheet
    * @param fullDetails : Map<String, Object> as from getProfSheetFullDetails;
    * @return List<Map<String, Object>> with details
    */
    public static List<Map<String, Object>> getPSActualValuesMap(Map<String, Object> fullDetails) {

        final Boolean success = (Boolean)fullDetails.get('success');
        final List<Map<String, Object>> res = new List<Map<String, Object>>();

        if(success) {
            final ProfitabilitySheet_Wrapper psDetails = (ProfitabilitySheet_Wrapper)fullDetails.get('profSheetDetails');
            for (ProfitabilitySheet_Wrapper.Condition condition : psDetails.conditionsList) {
                if(condition.source == null || condition.source == '') {
                    for (ProfitabilitySheet_Wrapper.Attribute attribute : condition.attributesList) {
                        res.add(new Map<String, Object>{'id' => attribute.canonicalId, 'value' => attribute.value});
                    }
                }
            }
        }
        return res;
    }

    /**
    * @description returns conditions from a Profitability Sheet
    * @param profSheetId : Ids of Profitability Sheet
    * @return Map<String,Set<String>> lwith details
    */
    public static Map<String,Set<String>> getPSExtendedPkgs(Id profSheetId) {

        final Map<String,Object> fullDetails = getProfSheetFullDetails(profSheetId);
        final Boolean success = (Boolean)fullDetails.get('success');
        final List<String> sources = new List<String>{'COMMERCIAL_PACKAGE', 'GIP_PACKAGE', 'FORFAIT'};
        final Map<String,Set<String>> res = new Map<String,Set<String>>();

        if(success) {
            final ProfitabilitySheet_Wrapper psDetails = (ProfitabilitySheet_Wrapper)fullDetails.get('profSheetDetails');
            for (ProfitabilitySheet_Wrapper.Condition condition : psDetails.conditionsList) {
                if(condition.sourceCode != null && sources.contains(condition.source)) {
                    Integer length = condition.sourceCode.length();
                    String key = condition.sourceCode.substring(0, length-5);
                    String value = condition.sourceCode.substring(length-5,length);
                    if(res.get(key) != null) {
                        res.get(key).add(value);
                    } else {
                        res.put(key, new Set<String>{value});
                    }
                }
            }
        }
        return res;
    }

}