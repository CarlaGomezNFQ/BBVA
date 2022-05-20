/**
* ──────────────────────────────────────────────────────────────────────────────────────
* ProfitabilityList_Service
* Service class for ProfitabilityList_Crtl apex class
* ──────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-17
* @modified
* @systemLayer Business Logic
* ──────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ──────────────────────────────────────────────────────────────────────────────────────
*/
public class ProfitabilityList_Service {
    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ProfitabilityList_Service() {}

    /**
    * @description Returns the info to show on the table
    * @param profRecordId : Current record Id
    * @param sObjectName : String with the api SObject Name of the context record
    * @return Map<String, Object>, with the config info and info to build front
    */
    public static Map<String, Object> retriveParticipantHchy(Id participantId, String sObjectName) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Obtain the participant hierarchy related to the account Id
        final ParticipantHierarchy_Wrapper partHierWrapp = ProfitabilityList_Helper.getParticipantHierarchy(genConfig, participantId);

        // Build the response to the lightning component
        retMap = buildInitResponse(participantId, partHierWrapp, genConfig);

        return retMap;
    }

    /**
    * @description Check if current user can do add action
    * @param recordId : Current record Id
    * @return Map<String, Object>, with the response
    */
    public static Map<String, Object> checkCreatePermissions(Id recordId) {
        Map<String, Object> retMap = new Map<String, Object>();
        // Obtain the current active version of general config mtd
        pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        // Check Create permissions to current user
        retMap = ProfitabilityList_Helper.checkCreatePermissions(genConfig, recordId);
        return retMap;
    }

    /**
    * @description Build the initial map to return to lightning component
    * @param profRecordId: Context record Id
    * @param participantMap: Map with the related hierarchy of the related accountId context record
    * @param sObjectName: sObject Name of the context record
    * @param genConfig : Metadata record with the general configuration of classes
    * @return Map<String, Object>, fill with info in function of logic
    */
    public static Map<String, Object> buildInitResponse(Id participantId, ParticipantHierarchy_Wrapper partHierWrapp, pa_general_configuration__mdt genConfig) {
        Map<String, Object> retMap = new Map<String, Object>();
        final Map<String, Object> currentPs = ProfitabilityList_Helper.getcurrentPS(participantId);
        final String participantType = partHierWrapp.type;
        switch on participantType {
            when 'group' {
                Set<Id> partigpIds = new Set<Id>();
                partigpIds = partHierWrapp.childIdsSet;
                partigpIds.add(participantId);
                retMap.put('LName', Label.group);
                retMap.put('Name', partHierWrapp.name);
                retMap.put('Type', partHierWrapp.type);
                retMap.put('tableTitle', Label.available_group_ps);
                Map<String, Object> treeDataMap = ProfitabilityList_Helper.getTreeGridData(partigpIds,partHierWrapp,genConfig);
                retMap.put('gritdata', (String) treeDataMap.get('treeGridData'));
                //retMap.put('subtableTitle', ProfitabilityList_Helper.getSubtableTitle((Map<String, Object>) treeDataMap.get('subtitleData'))); Commented for rollback in future, if needed
            }
            when 'orphan' {
                final Set<Id> partiorpIds = new Set<Id>();
                partiorpIds.add(participantId);
                retMap.put('LName', Label.client);
                retMap.put('Name', partHierWrapp.name);
                retMap.put('Type', partHierWrapp.type);
                retMap.put('tableTitle', Label.available_client_ps);
                Map<String, Object> treeDataMap2 = ProfitabilityList_Helper.getTreeGridData(partiorpIds,partHierWrapp,genConfig);
                retMap.put('gritdata', (String) treeDataMap2.get('treeGridData'));
                //retMap.put('subtableTitle', ProfitabilityList_Helper.getSubtableTitle((Map<String, Object>) treeDataMap2.get('subtitleData'))); Commented for rollback in future, if needed
            }
            when 'subsidiary' {
                Set<Id> partiSubIds = new Set<Id>();
                partiSubIds = partHierWrapp.childIdsSet;
                partiSubIds.add(participantId);
                retMap.put('LName', Label.client);
                retMap.put('Name', partHierWrapp.name);
                retMap.put('Type', partHierWrapp.type);
                retMap.put('currentId', currentPs.get('currentId'));
                retMap.put('currentps', currentPs.get('currentps'));
                retMap.put('tableTitle', Label.available_group_ps);
                Map<String, Object> treeDataMap3 = ProfitabilityList_Helper.getTreeGridData(partiSubIds,partHierWrapp,genConfig);
                retMap.put('gritdata', (String) treeDataMap3.get('treeGridData'));
                //retMap.put('subtableTitle', ProfitabilityList_Helper.getSubtableTitle((Map<String, Object>) treeDataMap3.get('subtitleData'))); Commented for rollback in future, if needed
            }
        }
        return retMap;
    }
}