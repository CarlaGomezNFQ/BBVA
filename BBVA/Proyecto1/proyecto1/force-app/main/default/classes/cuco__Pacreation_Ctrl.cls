/**
* ──────────────────────────────────────────────────────────────────────────────────────────
* Pacreation_Ctrl
* Controller class for pacreation_cmp Lightning Component
* ──────────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-17
* @modified
* @systemLayer Presentation
* ─────────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ──────────────────────────────────────────────────────────────────────────────────────────
*/
public class Pacreation_Ctrl {
    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Pacreation_Ctrl() {}

    /**
    * @description Returns the needed info to display on table
    * @param recordId : Id
    * @return Map<String, Object>, with info of table params and table info
    */
    @AuraEnabled
    public static Map<String, Object> retrieveTableData(Id recordId) {
        try {
            return Pacreation_Service.retrieveParticipantsAddData(recordId);
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Check permissions and create the new acc participants to the prof sheets
    * @param profsheetId : Prof sheet context record id
    * @param lstAccId : List of accs ids ready to include as participants at the related prof analysis
    * @return Map<String, Object>, with the execution response
    */
    @AuraEnabled
    public static Map<String, Object> manageNewPfanalisis(Id profAnalisisId, List<Id> lstAccId, String pfAname) {
      try {
          return Pacreation_Service.manageCreateNewPAnalisis(profAnalisisId, lstAccId, pfAname);
      } catch (Exception e) { // NOSONAR
          throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
      }
    }
}