/**
* ────────────────────────────────────────────────────────────────────
* Participants_Add_Ctrl
* Controller class for participants_add_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-17
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Participants_Add_Ctrl {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Participants_Add_Ctrl() {}

    /**
    * @description Returns the needed info to display on table
    * @param recordId : Id of the related profitability analysis
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> retrieveTableData(Id recordId) {
        try {
            return Participants_Service.retrieveParticipantsAddData(recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check permissions and create the new acc participants to the prof analysis
    * @param profAnalysisId : Prof analysis context record id
    * @param lstAccId : List of accs ids ready to include as participants at the related prof analysis
    * @return Map<String, Object>, with the execution response
    */
    @AuraEnabled
    public static Map<String, Object> manageNewParticipants(Id profAnalysisId, List<Id> lstAccId) {
      try {
          return Participants_Service.manageAddNewParticipants(profAnalysisId, lstAccId);
      } catch (Exception e) { // NOSONAR
          throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
      }
    }
}