/**
* ────────────────────────────────────────────────────────────────────
* PriceDelegationLevels_Helper
* Helper class for price delegation web service call
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-12
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:AvoidMethodsBeforeInitializers')
public class PriceDelegationLevels_Helper {

    /**
    * @description String with user Id value
    */
    public String userId {get;set;}

    /**
    * @description String with classification value
    */
    public String classification {get;set;}

    /**
    * @description String with first level value
    */
    public String firstLevel {get;set;}

    /**
    * @description String with second level value
    */
    public String secondLevel {get;set;}

    /**
    * @description String with branch code value
    */
    public String branchCode {get;set;}

    /**
    * @description String with participant integration id value
    */
    public String participantIntegrationId {get;set;}

    /**
    * @description String with condition list value
    */
    public String conditionsList {get;set;}

    /**
    * @description Default public constructor to PriceDelegationLevels_Helper
    * @param profAnalysisId: Id of related profitability analysis record
    */
    public PriceDelegationLevels_Helper(Id profAnalysisId) {

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Obtain info of param profitability analysis id
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> lstPA = paSelector.selectById(new Set<Id>{profAnalysisId});

        // Obtain info of related account to profitability analysis id param
        final List<Participant_Wrapper> lstPW = Participants_Helper.getParticipantDetails(genConfig, new Set<Id>{lstPA[0].participant_id__c});

        // Fill attributes
        this.userId = ProfitabilityAnalysis_Service.obtainUserInfo((Id) UserInfo.getUserId());
        this.classification = genConfig.price_classification_name__c;
        this.firstLevel = genConfig.price_first_level_name__c;
        this.secondLevel = genConfig.price_second_level_name__c;
        this.branchCode = lstPA[0].gf_pa_aprvl_proc_deleg_br_id__c == null ? ProfitabilityAnalysis_Helper.getBranchCode(genConfig, profAnalysisId): lstPA[0].gf_pa_aprvl_proc_deleg_br_id__c;
        this.participantIntegrationId = lstPW[0].participantIntegrationId;
        this.conditionsList = fillConditionsListAttb(genConfig, lstPA[0].participant_id__c);
    }

    /**
    * @description Helper method to fill conditions list
    * @param genConfig : Metadata record with the general configuration of classes
    * @param profAnalysisAcc: Id of related acc main of the profitability analysis
    */
    private static String fillConditionsListAttb(pa_general_configuration__mdt genConfig, Id profAnalysisAcc) {

        // Get participants hierarchy for the param account
        final ParticipantHierarchy_Wrapper partHierWrapp = Participants_Helper.getParticipantHierarchy(genConfig, profAnalysisAcc);

        // Fill conditions list
        final List<Object> lstConditions = new List<Object>();

        // First condition
        final List<Object> lstFormatsFirstCondition = new List<Object>();
        final Map<String, Object> firstFormatObj = new Map<String, Object>();
        final Map<String, Object> firstTextObj = new Map<String, Object>();
        final Map<String, Object> firstTextValues = new Map<String, Object>();
        firstTextValues.put('text', partHierWrapp.type == 'group' ? 'G' : 'C');
        firstTextValues.put('formatType', 'TEXT');
        firstTextObj.put('text', firstTextValues);
        firstFormatObj.put('format', firstTextObj);
        lstFormatsFirstCondition.add(firstFormatObj);
        final Map<String, Object> firstCondition = new Map<String, Object>();
        firstCondition.put('id', 'rorc.type');
        firstCondition.put('conditionType', 'SIMPLE');
        firstCondition.put('formats', lstFormatsFirstCondition);
        lstConditions.add(firstCondition);

        // Second condition (Only if main participant has group as type)
        if (partHierWrapp.type == 'group') {
            final List<Object> lstFormatsSecondCondition = new List<Object>();
            final Map<String, Object> secondFormatObj = new Map<String, Object>();
            final Map<String, Object> secondTextObj = new Map<String, Object>();
            final Map<String, Object> secondTextValues = new Map<String, Object>();
            secondTextValues.put('text', partHierWrapp.integrationId);
            secondTextValues.put('formatType', 'TEXT');
            secondTextObj.put('text', secondTextValues);
            secondFormatObj.put('format', secondTextObj);
            lstFormatsSecondCondition.add(secondFormatObj);
            final Map<String, Object> secondCondition = new Map<String, Object>();
            secondCondition.put('id', 'group.id');
            secondCondition.put('conditionType', 'SIMPLE');
            secondCondition.put('formats', lstFormatsSecondCondition);
            lstConditions.add(secondCondition);
        }

        return JSON.serialize(lstConditions);
    }

    /**
    * @description Method to serialize values to call webservice
    */
    public String generateRequest() {
        return JSON.serialize(this);
    }

    /**
    * @description Method to invocate webdservice
    */
    public HttpResponse callWs() {
        HttpResponse response;
        final iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance('calculateDelegationLevels');
        if (serviceProp.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock('calculateDelegationLevels', null);
        } else {
            response = Utils.callWServices('calculateDelegationLevels', generateRequest());
        }
        return response;
    }
}