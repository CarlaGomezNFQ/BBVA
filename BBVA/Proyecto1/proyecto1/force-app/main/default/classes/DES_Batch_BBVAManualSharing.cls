/*
* batch upadate subsidiary fields from group of matrix
*/
public without sharing class DES_Batch_BBVAManualSharing implements Database.Batchable<Sobject>, Database.Stateful {
    private final String pQuery;
    private String ADMINPROFILE = 'System Administrator';
    private String INTEGRATIONPROFILE = 'Desktop Integration';
    /*
    * constructor method
    */
    public DES_Batch_BBVAManualSharing() {
        pQuery = 'Select Id, DES_Client__c, DES_User__c, DES_Member_Role__c, DES_Clave_Externa__c, copy_record_approval_type__c from DES_BBVA_Management_team__c WHERE CreatedBy.Profile.Name = :INTEGRATIONPROFILE OR CreatedBy.Profile.Name = :ADMINPROFILE OR LastModifiedBy.Profile.Name = :INTEGRATIONPROFILE OR LastModifiedBy.Profile.Name = :ADMINPROFILE' + (Test.isRunningTest()?' LIMIT 1':'');
    }
    /*
    * start method
    */
    public Database.QueryLocator start(Database.BatchableContext bch) {
        return Database.getQueryLocator(pQuery);
    }
    /*
    * Execute method
    */
    public void execute(Database.BatchableContext bch, List<DES_BBVA_Management_team__c> scope) {
        final DES_BBVAManagementTeamTriggerHandler handler = DES_BBVAManagementTeamTriggerHandler.getInstance();
        handler.createManualSharing(scope, true);
        final List<altm__Commercial_Alert__Share> commAlertShare = DES_BBVAManagementTeamTriggerHandler.insertCommAlertManualSharing(scope);
        if(!commAlertShare.isEmpty()) {
            insert commAlertShare;
        }
        DES_BBVAManagementTeam_Helper.insAlertMember(scope);
    }
    /*
    * Finish method
    */
    public void finish(Database.BatchableContext bch) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bch.getJobId()];
        System.debug('>>>>> SUMMARY: ');
        System.debug('>>>>>   Batches Created: ' + job.JobItemsProcessed);
        System.debug('>>>>>   Number of Errors: ' + job.NumberOfErrors);
        System.debug('>>>>>   Status: ' + job.Status);
    }

}