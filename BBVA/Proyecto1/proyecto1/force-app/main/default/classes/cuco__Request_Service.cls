/**
* ────────────────────────────────────────────────────────────────────
* Request_Service
* Service class for requests implementation apex classes
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-21
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Request_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Request_Service() {}

    /**
    * @description Check if user can do request creation action
    * @param profSheetId : Current record Id
    * @param typology : typology of profSheet
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> requestData (Id profSheetId, String typology) {
        Map<String, Object> retMap = new Map<String, Object>();

        //Obtain the profSheet detail wrapper info
        final Map<String,Object> mapDetails = ProfitabilitySheet_Service.getProfSheetFullDetails(profSheetId);
        if((Boolean) mapDetails.get('success')) {
            final ProfitabilitySheet_Wrapper wrapperInfo = (ProfitabilitySheet_Wrapper) mapDetails.get('profSheetDetails');

            //Check validations for the request
            final Map<String,Object> validations = Request_Helper.checkValidations(wrapperInfo,typology);

            if(validations.get('success') == true) {
                //Check permissions for the request
                final Map<String,Object> permissions = Request_Helper.checkPermissions(wrapperInfo, userInfo.getUserId(),typology);
                if(permissions.get('canCreate') == true) {
                    final Map<String,Object> mapAnalysisFinal = Request_Helper.createProfAnalysis(wrapperInfo, typology);
                    retMap = Request_Service.checkAnalysis(mapAnalysisFinal);
                } else {
                    retMap.put('success',false);
                    retMap.put('errMessage',permissions.get('message'));
                }
            } else {
                retMap.put('success',false);
                retMap.put('errMessage',validations.get('errMessage'));
            }
        } else {
            retMap.put('success',false);
            retMap.put('errMessage',mapDetails.get('errorMessage'));
        }

        return retMap;
    }

    /**
* @description private method to check if profitability analysis has been created
* @param mapAnalysisFinal : Map with info to catch
* @return Map<String,Object> map with info to return
*/

    private static Map<String,Object> checkAnalysis(Map<String,Object> mapAnalysisFinal) {
        final Map<String,Object> retMap = new Map<String,Object>();
        if(mapAnalysisFinal.get('isSuccess') == true) {
            retMap.put('success',true);
            retMap.put('profAId',mapAnalysisFinal.get('profAId'));
        } else {
            retMap.put('success',false);
            retMap.put('errMessage',Label.creation_error + mapAnalysisFinal.get('errMessage'));
        }
        return retMap;
    }
}