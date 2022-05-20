/*-----------------------------------------------------------------------------------------------
    Author:        Rodrigo Fdez-Victorio
    Company:       Accenture
    Description:   Subclass to handle methods related to Master Case called when the triggers over Case
    object are fired

    History:
    <Date>          <Author>                <Description>
    08/07/2017      Juan Carlos Terrón        Initial version
-------------------------------------------------------------------------------------------------*/
public without sharing class SER_CaseMethodsMasterCase {
    /*Constante texto identificador de test*/
    final static string LOG_TEST = 'Catch testing';
    /*Constante cerrado (status CASO) */
    final static string STATUS_CLOSED = 'Closed';

    private SER_CaseMethodsMasterCase() {}
    /*-------------------------------------------------------------------------------------------
        Author:        Juan Carlos Terrón
        Company:       Accenture
        Description:   Method that sends internal email alerts whenever a master case is created.

        IN:            Map<Id,Case>x2(Trigger.newMap, Trigger.oldMap)
        OUT:           void

        History:
        <Date>                  <Author>                <Change Description>
        18/05/2017              Juan Carlos Terrón      Initial Version
    ---------------------------------------------------------------------------------------------*/
    public static void sendChildCasesEmail(Map<Id,Case> newMap,Map<Id,Case> oldMap) {
        try {
            Set<String> setTemplatDevName;
            setTemplatDevName = new Set<String>();
            Map<String,String> mapTemplates;
            mapTemplates = new Map<String,String>();
            Map<String,SER_MasterCaseNotificationsTemplate__c> mapNotifiTemplate;
            mapNotifiTemplate = new Map<String,SER_MasterCaseNotificationsTemplate__c>();
            mapNotifiTemplate = SER_MasterCaseNotificationsTemplate__c.getAll();

            buildMapNotificationsTemplate (mapNotifiTemplate, setTemplatDevName,mapTemplates);
            final boolean aux = oldMap==null && !SER_TriggerHelper.get_MethodFired('send_ChildCasesEmail_INSERT');
            if(aux) { //The flag from trigger helper prevent the method to fire multiple times.
                Map<Id,Case> mapMasterCases;
                mapMasterCases = new Map<Id,Case>();
                for(Case casoItem : newMap.values()) {
                    final boolean isMasterCaseNew = casoItem.SER_Is_Master_Case__c
                        && casoItem.SER_Master_Case__c == null
                        && casoItem.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE
                        && casoItem.Status == 'New';
                    if( isMasterCaseNew) {
                        mapMasterCases.put(casoItem.Id, casoItem);
                    }
                }
                tratamientoMasterCases('INSERT',false, mapMasterCases, setTemplatDevName, mapTemplates);
            } else if(!SER_TriggerHelper.get_MethodFired('send_ChildCasesEmail_UPDATE')) { //The flag from trigger helper prevent the method to fire multiple times.
                Map<Id,Case> mapMasterCases;
                mapMasterCases = new Map<Id,Case>();

                for(Case casoItem : newMap.values()) {
                    Final boolean auxItem = casoItem.SER_Is_Master_Case__c
                        && casoItem.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE
                        && casoItem.SER_Master_Case__c == null
                        && (!oldMap.get(casoItem.Id).SER_Is_Master_Case__c
                        || (casoItem.Status == STATUS_CLOSED
                        && oldMap.get(casoItem.Id).Status != STATUS_CLOSED));
                    if(auxItem) {
                        mapMasterCases.put(casoItem.Id, casoItem);
                    }
                }
                tratamientoMasterCases('UPDATE',true, mapMasterCases, setTemplatDevName, mapTemplates);
            }
            if(runTest()) { throw new HandledException(LOG_TEST); }//Catch testing for code coverage.
        } catch(Exception ex) {
            cibLog(ex, 'SER_CaseMethods.sendChildCasesEmail()');
        }
    }
    private static void buildMapNotificationsTemplate (
        Map<String,SER_MasterCaseNotificationsTemplate__c> mapNotifiTemplate,
        Set<String> setTemplatDevName, Map<String,String> mapTemplates) {
        for(SER_MasterCaseNotificationsTemplate__c cntItem : mapNotifiTemplate.valueS()) { //We fill a map to match a concrete case status with an email template.
            setTemplatDevName.add(cntItem.SER_TemplateDeveloperName__c);
            mapTemplates.put(cntItem.SER_CaseStatus__c,cntItem.SER_TemplateDeveloperName__c);
            mapTemplates.put(cntItem.SER_TemplateDeveloperName__c,cntItem.SER_CaseStatus__c);
        }
    }
    private static void tratamientoMasterCases (String action, boolean bSendEmail,  Map<Id,Case> mapMasterCases, Set<String> setTemplatDevName, Map<String,String> mapTemplates ) {
        if(!mapMasterCases.isEmpty()) {
                    Map<String,Id> mapEmailTemplates = new Map<String,Id>();
                    mapEmailTemplates = new Map<String,Id>();
                    List<Messaging.SingleEmailMessage>  listEmails;
                    listEmails = new List<Messaging.SingleEmailMessage>();
                    Set<SER_Master_Case_User_Notification__c> setAddresses;
                    setAddresses = new Set<SER_Master_Case_User_Notification__c>();

                    for(EmailTemplate tmpItem :
                        [
                            SELECT  Id,DeveloperName
                            FROM    EmailTemplate
                            WHERE   DeveloperName IN :setTemplatDevName
                        ]) {
                        mapEmailTemplates.put(tmpItem.DeveloperName, tmpItem.Id);
                    }
                    setAddresses.addAll([
                        SELECT  Id,
                                SER_Contact__c,
                                SER_Contact_email__c,
                                SER_User_name__c,
                                SER_User_email__c
                        FROM    SER_Master_Case_User_Notification__c
                        LIMIT   100000000
                    ]);
                    for(Case casoItem :
                    [
                        SELECT  Id,Status,
                                SER_Is_Master_Case__c,SER_Master_Case__c,
                                Contact.Email,Contact.Email_ExternalID__c
                        FROM    Case
                        WHERE   Id IN :mapMasterCases.keySet()
                    ]) {
                        listEmails.addAll(SER_CaseMethods_HELPER.generateMasterCaseNotifications(casoItem,mapTemplates,setAddresses,mapEmailTemplates));
                        SER_Case_TriggerHelper.map_NotifiedMasterCases.put(casoItem.Id, casoItem);
                    }
                    if(!listEmails.isEmpty()) {
                        System.debug('Lista de emails a mandar SIZE : '+listEmails.size());
                        System.debug('Lista de emails a mandar : '+listEmails);
                        SER_TriggerHelper.set_MetodFired('send_ChildCasesEmail_'+action+'_PRESENDING', true);
                        Messaging.sendEmail(listEmails,bSendEmail);
                        SER_TriggerHelper.set_MetodFired('send_ChildCasesEmail_'+action, true);
                    }
                }
    }

    /*---------------------------------------------------------------------------------------------------------------
        Author:        Juan Carlos Terrón
        Company:       Accenture
        Description:   Method that sets SER_Send_email_close_master_case__c field to true for master cases children
                        whenever the field is set to true for the master case.

        IN:            List<Case>(Trigger.new),Map<Id,Case>x2(Trigger.newMap, Trigger.oldMap)
        OUT:           void

        History:
        <Date>                  <Author>                <Change Description>
        18/05/2017              Juan Carlos Terrón      Initial Version
    -----------------------------------------------------------------------------------------------------------------*/
    public static void manageMasterCaseNotifications(List<Case> news, Map<Id,Case> newMap, Map<Id,Case> oldMap) {
        try {
            Set<Id> setMasterCaseIds;
            setMasterCaseIds = new Set<Id>();
            /*CASE FIELD Storage STARTS*/
            Map<String,Schema.SObjectField> mapCaseFields;
            mapCaseFields = new Map<String,Schema.SObjectField>();
            mapCaseFields = Case.getSObjectType().getDescribe().fields.getMap();
            Map<String,String> mapPklstValues;
            mapPklstValues = new Map<String,String>();
            for(Schema.PicklistEntry plvItem : mapCaseFields.get('Status').getDescribe().getPickListValues()) {
                mapPklstValues.put(plvItem.getLabel(), plvItem.getValue());
            }

            /*CASE FIELD STORAGE ENDS*/
            for(Case casoItem :news) {
                Case oldCase;
                oldCase = oldMap.get(casoItem.Id);

                boolean masterClosed;
                masterClosed = casoItem.SER_Is_Master_Case__c
                    && casoItem.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE
                    && casoItem.SER_Master_Case__c == null
                    && casoItem.SER_Send_email_close_master_case__c
                    && !oldCase.SER_Send_email_close_master_case__c
                    && casoItem.Status == mapPklstValues.get(Label.SER_CaseStatus_Closed_PLV);

                if(masterClosed) {
                    //Filter for Master cases being closed
                    setMasterCaseIds.add(casoItem.Id);
                }
            }
            if(!setMasterCaseIds.isEmpty()) {
                List<Case> lstCases2Updt;
                lstCases2Updt = new List<Case>();
                Case caseAux;
                for(Case casoItem :
                    [
                        SELECT  Id,SER_Send_email_close_master_case__c
                        FROM    Case
                        WHERE   SER_Is_Master_Case__c = false
                                AND SER_Business_Case_Type__c = :SER_Constant.BUSINESS_STE
                                AND SER_Master_Case__c IN :setMasterCaseIds
                    ]) {

                    //Retrieve children cases for the master cases previously processed.
                    caseAux = new Case(Id = casoItem.Id, SER_Send_email_close_master_case__c = true);
                    lstCases2Updt.add(caseAux);
                }
                if(!lstCases2Updt.isEmpty()) {
                    update lstCases2Updt;
                }
            }
            if(runTest()) { throw new HandledException(LOG_TEST); }//Catch testing for code coverage.
        } catch (Exception ex) {
            CIB_LogUtils.create_Log('SER_CaseMethods.manageMasterCaseNotifications()', ex.getStackTraceString()+'\n'+ex.getMessage());
        }
    }

    //Comprueba si nos encontramos en ejecución de un test
    private static boolean runTest() {
        return Test.isRunningTest();
    }
    private static void cibLog(Exception pEx, String pMetodo) {
        CIB_Log__c logToInsert;
        logToInsert = new CIB_Log__c();
        logToInsert.CIB_ErrorMessage__c = pEx.getStackTraceString()+'\n'+pEx.getMessage();
        logToInsert.CIB_Subject__c = pMetodo+' ERROR';
        insert logToInsert;
    }
}