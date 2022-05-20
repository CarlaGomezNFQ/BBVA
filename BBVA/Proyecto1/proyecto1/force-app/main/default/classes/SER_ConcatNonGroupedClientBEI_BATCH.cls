/**
* Author: BBVA
* Description:  Proceso batch que rellena el BEI de los Clientes No Agrupados concatenando los BEIs
*               de los Clientes Locales asociados.
* History:
*   <Date>       <Author>          <Description>
* 14/10/2020   Javier Touchard   V 1.0 Initial version
*/
global without sharing class SER_ConcatNonGroupedClientBEI_BATCH implements Database.Batchable<sObject> {
  
  /*Query que va a determinar el scope de el Batch*/
  final String query;

  /**
  * Constructor 1.
  * @Params String query: scope.
  */
  global SER_ConcatNonGroupedClientBEI_BATCH(String query) {
    this.query = query;
  }

  /**
  * Constructor 2.
  */
  global SER_ConcatNonGroupedClientBEI_BATCH() {
    this.query = 'SELECT Id, gf_bei_id__c, (SELECT Id, gf_bei_id__c, company_customer_id__c FROM LocalClient_Affil__r WHERE gf_bei_id__c <> null) FROM Account WHERE SER_CClient__c <> null AND DES_Main_Parent__c = null AND RecordType.DeveloperName in (\'Non_Grouped_Client\',\'SER_Service_Account\')';
  }

  /**
  * Method que determina el scope del job.
  * @Params Database.BatchableContext bcctx: contexto.
  * @Return Database.QueryLocator: Scope.
  */
  global Database.QueryLocator start(Database.BatchableContext bcctx) {
    return Database.getQueryLocator(this.query);
  }

  /**
  * Method principal donde se encuentra toda la logica del Batch.
  * @Params: Database.BatchableContext bcctx: contexto.
  * @Params: List<sObject> scope: Registros que van a ser tratados.
  * @Return: Void
  */
  global void execute(Database.BatchableContext bcctx, List<sObject> scope) {
    List<Account> cNGToUpdate;
    cNGToUpdate = new List<Account>();
    for(Object obj : scope) {
      Account nonGClient;
      nonGClient = new Account();
      nonGClient = (Account) obj;
      set<String> beis;
      beis = new set<String>();
      if(nonGClient.LocalClient_Affil__r.isEmpty() == false) {
        for(Local_Client_EGS__c localClient : nonGClient.LocalClient_Affil__r) {
          if(localClient.gf_bei_id__c != null) {
            beis.add(localClient.gf_bei_id__c);
          }
        }
        if(beis.isEmpty() == false) {
          List<String> beisList;
          beisList = new List<String>(beis);
          beisList.sort();
          nonGClient.gf_bei_id__c = String.join(beisList, ', ');
        }
        nonGClient.BEI_Included__c = String.isNotBlank(nonGClient.gf_bei_id__c) ? true : false;
        cNGToUpdate.add(nonGClient);
      }
    }

    if(cNGToUpdate.isEmpty() == false) {
      update cNGToUpdate;
    }
  }

  /**
  * Method que se ejecuta al finalizar el Batch.
  * @Params: Database.BatchableContext bcctx: contexto.
  * @Return: Void
  */
  global void finish(Database.BatchableContext bcctx) {
    System.debug('Finish SER_ConcatNonGroupedClientBEI_BATCH');
  }
}