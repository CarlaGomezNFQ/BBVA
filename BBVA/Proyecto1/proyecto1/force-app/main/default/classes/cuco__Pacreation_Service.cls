/**
* ────────────────────────────────────────────────────────────────────────────────────
* Pacreation_Service
* Service class for Pacreation_Ctrl apex class
* ────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-11
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────────────────────
*/
public class Pacreation_Service {
  /**
  * @description Private constructor to avoid sonar err
  */
  @TestVisible
  private Pacreation_Service() {}
  /**
  * @description Returns the info to display on the table
  * @param recordId : Current prof analysis record Id
  * @return Map<String, Object>, with the config info and info to build front
  */
  public static Map<String, Object> retrieveParticipantsAddData(Id participantId) {
      Map<String, Object> retMap = new Map<String, Object>();

      // Obtain the current active version of general config mtd
      final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

      // Obtain the participant hierarchy related to the account Id
      final ParticipantHierarchy_Wrapper partHierWrapp = Participants_Helper.getParticipantHierarchy(genConfig, participantId);

      // Build the response to the lightning component
      retMap = Pacreation_Helper.buildParticipantsAddResponse(participantId, partHierWrapp, genConfig);

      return retMap;
  }

  /**
  * @description Check add permissions, create new prof. ana. participants and remove cancellation pkg request related
  * @param participantId: Context prof analysis record Id
  * @param pfAname: Name of profitability analysis
  * @param lstAccId : List of accs ids ready to include as participants at the related prof analysis
  * @return Map<String, Object>, fill with info in function of logic
  */
  public static Map<String, Object> manageCreateNewPAnalisis(Id participantId, List<Id> lstAccsId, String pfAname) {
    Map<String, Object> retMap = new Map<String, Object>();
    // Obtain the current active version of general config mtd
    final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

    // Obtain the participant hierarchy related to the account Id
    final ParticipantHierarchy_Wrapper partHierWrapp = Pacreation_Helper.getParticipantHierarchy(genConfig, participantId);

    // Check if the context user can create particiapnts (Has create permissions)
    final Map<String, Object> addMap = Permissions_Helper.checkCreatePermissions(genConfig, participantId);
    if ((Boolean) addMap.get('create')) {
      // If ve create permissions, check if param list is filled
      if (lstAccsId.isEmpty() && partHierWrapp.type == 'subsidiary') {
        retMap.put('showEmptyErr', true);
        retMap.put('errMessage', Label.madatory_subsidiary_selection);
      } else {
        final String participantType = partHierWrapp.type;
        switch on participantType {
          when 'group' {
            // try to create and insert the new prof analysis participants group
            retMap = Pacreation_Helper.createNewProfAnalisis(participantId, lstAccsId, pfAname, genConfig);
          }
          when 'orphan' {
            //  try to create and insert the new prof analysis participants orphan
            lstAccsId.add(participantId);
            retMap = Pacreation_Helper.createNewProfAnalisis(participantId, lstAccsId, pfAname, genConfig);
          }
          when 'subsidiary' {
            //  try to create and insert the new prof analysis participants subsidiary
            retMap = Pacreation_Helper.createNewProfAnalisis(partHierWrapp.parentId, lstAccsId, pfAname, genConfig);
          }
        }
      }
    } else {
      // If cannot ve create permissions, returns the error message
      retMap.put('showToast', true);
      retMap.put('toastType', 'warning');
      retMap.put('errMessage', addMap.get('createMessage'));
    }
    return retMap;
  }
}