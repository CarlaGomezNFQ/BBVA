/**
* ────────────────────────────────────────────────────────────────────────────────────
* AvailableActions_itf
* AvailableActions_itf apex class
* ────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.Mastrogiorigo.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-21
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global interface AvailableActions_itf {
    /**
    * @description Returns user permissions to manage conditions in the specified Profitability Analysis
    * @param profAnalysisId : Id of the Profitability Analysis
    * @param userId : Id of the User
    * @return Map<String, Boolean> map with the actions and permissions
    */
    Map<String, Object> checkAvailableAction(String action, Id profAnalysisId);
}