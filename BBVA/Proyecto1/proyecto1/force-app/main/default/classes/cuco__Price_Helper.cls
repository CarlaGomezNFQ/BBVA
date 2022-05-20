/**
* ____________________________________________________________________________
* Price Helper
* Helper class for Price_Service
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-12
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class Price_Helper {

    /**
    * @description Private constructor
    */
    @TestVisible
    private Price_Helper() {}

    /**
    * @description return conditions in service response
    * @param response : Map<String, Object> service response
    * @return List<Map<String, Object>>, conditions
    */
    private static List<Map<String, Object>> getConditionsReturned(String response) {
        final List<Map<String, Object>> res = new List<Map<String, Object>>();
        final Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response);
        if (responseMap.containsKey('data')) {
            final Map<String, Object> mapData = (Map<String, Object>) responseMap.get('data');
            if (mapData.containsKey('conditions')) {
                for (Object condition : (List<Object>)mapData.get('conditions')) {
                    Map<String, Object> mapCondition = (Map<String, Object>)condition;
                    res.add(mapCondition);
                }
            }
        }
        return res;
    }

    /**
    * @description extract and return attribute value, depending on the value type
    * @param formats : Map<String, Object> as returned from second service
    * @param type : tupe of attribute.
    * @return String
    */
    private static String getAttributeValue(List<Object> formats) {

        final Map<String, Object> formatMap = (Map<String, Object>)formats.get(0);
        final Map<String, Object> format = (Map<String, Object>)formatMap.get('format');
        String result = '';

        if (format.containsKey('rate'))  {
            final Map<String, Object> mapRate = (Map<String, Object>) format.get('rate');
            result = String.valueof((Decimal) mapRate.get('value'));
        }
        if (format.containsKey('amount'))  {
            final Map<String, Object> mapAmount = (Map<String, Object>) format.get('amount');
            final Map<String, Object> mapAmo = (Map<String, Object>) mapAmount.get('amount');
            result = String.valueof((Decimal) mapAmo.get('amount'));
        }
        if (format.containsKey('text'))  {
            result = (String) format.get('text');
        }
        if (format.containsKey('term'))  {
            final Map<String, Object> mapTerm = (Map<String, Object>) format.get('term');
            result = String.valueof((Integer) mapTerm.get('termValue'));
        }
        if (format.containsKey('date'))  {
            final Map<String, Object> mapDate = (Map<String, Object>) format.get('date');
            result = (String) mapDate.get('date');
        }

        return result;
    }

    /**
    * @description returns wrapper with Profitability Sheet info from ASO servcie
    * @param profAnalysisId : profitability analysis Id
    * @return Map<String,Object>, wrapper with Profitability Sheet info
    */
    public static List<Map<String,Object>> getDelegatedValues(Id profAnalysisId) {

        List<Map<String, Object>> res = new List<Map<String, Object>>();
        try {
            final PriceDelegationLevels_Helper service = new PriceDelegationLevels_Helper(profAnalysisId);
            final HttpResponse response = service.callWs();
            if(response.getStatusCode() == 201) {
                for (Map<String, Object> condition : getConditionsReturned(response.getBody())) {
                    if (condition.get('conditionType') == 'SIMPLE') {
                        res.add(new Map<String, Object>{'id' => condition.get('id') , 'value' => getAttributeValue((List<Object>)condition.get('formats')) });
                    }
                }
            }
        } catch (Exception e) { //NOSONAR
            System.debug('Error ' + e.getMessage());
        }
        return res;
    }
}