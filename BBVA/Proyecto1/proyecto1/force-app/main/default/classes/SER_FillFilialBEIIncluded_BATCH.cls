/**
* Author: BBVA
* Description:  Proceso batch que rellena el campo BEI_Included__c de las Filiales cuando
*               no tienen BEI pero tienen Clientes Locales con BEI asociados.
* History:
*   <Date>       <Author>          <Description>
* 26/11/2020   Javier Touchard   V 1.0 Initial version
*/
global without sharing class SER_FillFilialBEIIncluded_BATCH implements Database.Batchable<sObject> { //NOSONAR Avoid Global Clases: Tiene que ser Global por si en algún momento fuese necesario llamar desde APX.

  /*Query que va a determinar el scope de el Batch*/
  final String query;

  /**
  * Constructor 1.
  * @Params String query: scope.
  */
  global SER_FillFilialBEIIncluded_BATCH(String query) {
    this.query = query;
  }

  /**
  * Constructor 2.
  */
  global SER_FillFilialBEIIncluded_BATCH() {
    this.query = 'SELECT Id, Name, company_customer_id__c, company_customer_id__r.Name FROM Local_Client_EGS__c WHERE gf_bei_id__c <> null AND company_customer_id__r.gf_bei_id__c = null AND company_customer_id__r.BEI_Included__c = FALSE AND company_customer_id__r.SER_CClient__c <> null';
  }

  /**
  * Method que determina el scope del job.
  * @Params Database.BatchableContext bcctx: contexto.
  * @Return Database.QueryLocator: Scope.
  */
  global Database.QueryLocator start(Database.BatchableContext bcctx) { //NOSONAR Avoid Global Clases: Tiene que ser Global por si en algún momento fuese necesario llamar desde APX.
    return Database.getQueryLocator(this.query);
  }

  /**
  * Method principal donde se encuentra toda la logica del Batch.
  * @Params: Database.BatchableContext bcctx: contexto.
  * @Params: List<sObject> scope: Registros que van a ser tratados.
  * @Return: Void
  */
  global void execute(Database.BatchableContext bcctx, List<sObject> scope) {
    /* Mensaje que se va a insertar en el CIB_Log__c */
    String logMSG = 'FILIALES: ';
    /* Filiales para actualizar */
    Set<Account> filialsToUpdate;
    filialsToUpdate = new Set<Account>();

    for(Object obj : scope) {
      Local_Client_EGS__c localClient;
      localClient = (Local_Client_EGS__c)obj;
      Account filial;
      filial = new Account(Id = localClient.company_customer_id__c, BEI_Included__c = true);
      filialsToUpdate.add(filial);
      logMSG += '\n' + localClient.company_customer_id__r.Name + ', Id: ' + localClient.company_customer_id__c + ' , BEI_Included__c = true, Local Client asociados: ' + localClient.Name + ', Id: ' + localClient.Id;
    }

    if(filialsToUpdate.isEmpty() == false) {
      update new List<Account>(filialsToUpdate);

      /*Log que se inserta para realizar un seguimiento de el Batch*/
      CIB_Log__c logToInsertE;
      logToInsertE = new CIB_Log__c();
      logToInsertE.CIB_Subject__c = 'SER_FillFilialBEIIncluded_BATCH';
      logToInsertE.CIB_ErrorMessage__c = logMSG;
      insert logToInsertE;
    }

  }

  /**
  * Method que se ejecuta al finalizar el Batch.
  * @Params: Database.BatchableContext bcctx: contexto.
  * @Return: Void
  */
  global void finish(Database.BatchableContext bcctx) {
    System.debug('Finish SER_FillFilialBEIIncluded_BATCH');

    final AsyncApexJob job = [SELECT NumberOfErrors,ExtendedStatus
                              FROM AsyncApexJob WHERE Id =: bcctx.getJobId()];

    //Insertamos un CIB_Log con la excepcion
    if(String.isNotBlank(JOB.ExtendedStatus)) {
      CIB_Log__c logToInsertF;
      logToInsertF = new CIB_Log__c();
      logToInsertF.CIB_Subject__c = 'ERROR: SER_FillFilialBEIIncluded_BATCH';
      logToInsertF.CIB_ErrorMessage__c = 'Nº errores: ' + JOB.NumberOfErrors + '\n ExtendedStatus' + JOB.ExtendedStatus;
      insert logToInsertF;
    }
  }
}