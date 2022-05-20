/**
* ____________________________________________________________________________
* Price Service
* Service class
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-13
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
public class Price_Service {

    /**
    * @description Private constructor
    */
    @TestVisible
    private Price_Service() {}

    /**
    * @description returns DelegatedValues from service
    * @param profAnalysisId : profitability analysis Id
    * @return JSON String
    */
    public static String getDelegatedValues(Id profAnalysisId) {

        List<Map<String, Object>> res = new List<Map<String, Object>>();
        final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();

        if(config.price_approval_type__c && config.retrieve_delegated_values_type__c) {
            res = Price_Helper.getDelegatedValues(profAnalysisId);
        }
        return JSON.serialize(res);
    }

}