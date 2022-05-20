/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RAIP_Propose_controller
* @Author   eduardoefrain.hernandez.contractor@bbva.com
* @Date     Created: 14/02/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Controller class to propose an independent rating
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-11-15 eduardoefrain.hernandez.contractor@bbva.com
*             Class creation
* |2019-03-31 juanignacio.hita.contractor@bbva.com
*             Refactoring to integrate workflow interface
* |2020-08-18 joseluis.garcia4.contractor@bbva.com
*             Add check for permissions.
* |2020-09-11 eduardoefrain.hernandez.contractor@bbva.com
*             Remove ValidateRatingClass
* |2020-09-23 saimassimilianno.jordana.contractor@bbva.com
*             Added arce. namespace to all classes that are now in the arce-dependencies package
* |2020-12-04 juanignacio.hita.contractor@bbva.com
*             Adds aha name (analysisId) param in traceability record
* |2021-04-07 joseluis.garcia4.contractor@bbva.com
*             Change references to Arc_Gen_RatingGlobal_* classes.
* |2021/08/31 amunguia.contractor@bbva.com
*             it is checked that overlay has been calculated.
* -----------------------------------------------------------------------------------------------
*/
public class Arc_Gen_RAIP_Propose_controller {
    /**
    *-------------------------------------------------------------------------------
    * @description Custom Exception that extends exception
    *--------------------------------------------------------------------------------
    * @date		30/03/2020
    */
    public virtual class CustomException extends Exception {}
    /**
    *-------------------------------------------------------------------------------
    * @description empty constructor to sonar validations
    *--------------------------------------------------------------------------------
    * @date		27/01/2020
    * @author	eduardoefrain.hernandez.contractor@bbva.com
    */
    @testVisible
    private Arc_Gen_RAIP_Propose_controller() {

    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that return
    *--------------------------------------------------------------------------------
    * @date 19/02/2020
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @param Id arceId - Standard Id of the ARCE record
    * @return returns boolean
    * @example getAmbits(Id recordId)
    */
    @AuraEnabled
    public static String initDelegation(Id accHasAnalysisId) {
        try {
            final arce__Analysis__c arceVar = arce.Arc_Gen_ArceAnalysis_Data.gerArce(accHasAnalysisId);
            final Boolean hasValidRating = arce.Arc_Gen_GenericUtilities.validateAllRatingsInArce(arceVar.Id, '2');
            if (hasValidRating) {
                final arce.Arc_Gen_User_Wrapper wrpUser = arce.Arc_Gen_User_Locator.getUserInfo(System.UserInfo.getUserId());
                final Arc_Gen_Delegation_Wrapper wrapper = Arc_Gen_Propose_Helper.initDelegation(wrpUser.ambitUser, arceVar.Id, 'RAIP-PROPOSE');
                return JSON.serialize(wrapper);
            } else {
                throw new CustomException(Label.Lc_Arc_RAIP_NoCalculatedRating); //NOSONAR
            }
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.Arc_Gen_ApexCallError + ': ' + e); //NOSONAR
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that return
    *--------------------------------------------------------------------------------
    * @date 19/02/2020
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @param Id arceId - Standard Id of the ARCE record
    * @param String selectedAmbit - Ambito seleccionado
    * @return returns boolean
    * @example getAmbits(Id recordId)
    */
    @AuraEnabled
    public static String toProposeRaip(String arceId, String selectedAmbit, String selectedUser) {
        final List<arce__Account_has_Analysis__c> ahaList = arce.Arc_Gen_AccHasAnalysis_Data.accHasAnByArce(new List<String> { arceId });
        if (ahaList.isEmpty() || !arce.Arc_Gen_GenericUtilities.isButtonAvailable(ahaList[0].Id, 'Arc_Gen_RAIP_Propose')) {
            throw new AuraHandledException(System.Label.Arc_Gen_Generic_ButtonNotAllowed);
        }

        try {
            final arce.Arc_Gen_RatingGlobal_data.saveResult response = Arc_Gen_RAIP_Propose_service.toPropose(arceId, selectedUser, selectedAmbit, ahaList[0]);
            return JSON.serialize(response);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.Arc_Gen_ApexCallError + ': ' + e); //NOSONAR
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Check that overlay has been calculated
    *--------------------------------------------------------------------------------
    * @date 30/08/2021
    * @author amunguia.contractor@bbva.com
    * @param Id recordId
    * @return String
    */
    @AuraEnabled
    public static Boolean getPermissionOverlay(Id recordId) {
        Boolean result = true;
        final List<arce__Arce_Config__mdt> configs = arce.Arc_Gen_Arceconfigs_locator.getConfigurationInfo('EnableOverlays');
        final arce__Account_has_Analysis__c aha = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String> {recordId})[0];
        Boolean overlaysEnabled = configs.isEmpty() ? false : Boolean.valueOf(configs[0].arce__Value1__c);
        if(!overlaysEnabled && (aha.arce__RAR_rating_tool_id__c.contains('IRP') || aha.arce__RAR_rating_tool_id__c.contains('ARP'))) {
            final arce__Overlay__c overlayObj= arce.Arc_Gen_Overlays_Utils.getOverlaysByAha(new Set<String> { aha.Id })[0];
            result = String.isNotEmpty(overlayObj.arce__Arc_Gen_Potential_ICR_Short_Rating__c);
            result = (String.isNotEmpty(overlayObj.arce__Arc_Gen_Overlay_visibility_control__c) && overlayObj.arce__Arc_Gen_Overlay_visibility_control__c.contains('03')) ? String.isNotEmpty(overlayObj.arce__Arc_Gen_FC_Sovereign_Short_Rating__c) : result;
        }
        return result;
    }
    
    /**
    *-------------------------------------------------------------------------------
    * @description Method that return
    *--------------------------------------------------------------------------------
    * @date		11/03/2021
    * @author	Global Desktop
    * @param Id arceId - Standard Id of the ARCE record
    * @param String selectedAmbit - Ambito seleccionado
    * @return returns boolean
    * @example getAmbits(Id recordId)
    */
    @AuraEnabled
    public static String fetchUsers(String selectedAmbit) {
        try {
            final Arc_Gen_Delegation_Wrapper wrapper = DES_Arc_GBL_Workflow_Helper.fetchUsersProposeRaip(selectedAmbit);
            return JSON.serialize(wrapper);
        } catch (Exception e) {
            throw new AuraHandledException(System.Label.Arc_Gen_ApexCallError + ': ' + e); //NOSONAR
        }
    }
}