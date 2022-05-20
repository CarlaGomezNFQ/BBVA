/***************************************************************************************
* @author       BBVA
* @date         05-06-2020
* @description  Controlador del aura component SER_BEISearchEngine.

****************************************************************************************/
public with sharing class SER_BEISearchEngine_CONTROLLER {
  /**CONSTANTE 'Group'*/
  public static final String GROUPOBJ = 'Group';
  /**CONSTANTE 'Client'*/
  public static final String CLIENT = 'Client';
  /**CONSTANTE 'Local Client'*/
  public static final String LOCALCLIENT = 'LocalClient';
  /**CONSTANTE 'Local Reference'*/
  public static final String LOCALREFERENCE = 'LocalReference';
  /**CONSTANTE 'Local Reference'*/
  public static final String BLANKLUERROR = 'ERRORSelect any record';
  /**Valor nulo*/
  public static final sObject NULLVALUE = null;
  /**Valor nulo*/
  public static final Id NULLVALUEID = null;

  /*---------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Constructor privado.
  ---------------------------------------------------------------------------------------*/
  private SER_BEISearchEngine_CONTROLLER() {}

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   create the lookup between the case and the selected record.

    IN:            Id caseId.
    IN:            Id lookupId.
    OUT:           String. Id of new Case or error message.

    History:
    <Date>            <Author>            <Change Description>
    09/06/2020      Javier Touchard         Initial Version
  ---------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static string createLookUp(Id caseId, Id lookupId, String objectType) {
    String response;
    response = '';
    try {
      if(String.isNotBlank(lookupId)) {
        Case caso;
        caso = new case();
        caso.Id = caseId;
        if(GROUPOBJ.equalsIgnoreCase(objectType)) {
          caso.gf_group_incidence_case_name__c = lookupId;
        } else if(CLIENT.equalsIgnoreCase(objectType)) {
          caso.AccountId = lookupId;
        } else if(LOCALCLIENT.equalsIgnoreCase(objectType)) {
          caso.customer_system_id__c = lookupId;
        } else if(LOCALREFERENCE.equalsIgnoreCase(objectType)) {
          caso.gf_reference_id__c = lookupId;
        }
        update caso;
        response = caso.Id;
      } else {
        response = BLANKLUERROR;
      }
      return response;
    } catch (Exception exc) {
      String errorMessage;
      errorMessage = ' , StackTrace: ' + exc.getStackTraceString();
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + exc + ' ' + errorMessage);
    }
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   checks the case's lookups for group, client, local client and
                    local reference.

    IN:        Case
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    11/06/2020      Cintia Carmona         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static void checkLookupsEGS(Map<Id,Case> newMap,Map<Id,Case> oldMap) {
    system.debug('******* SER_BEISearchEngine_CONTROLLER.checkLookupsEGS');
    Map<Id,case> mapCasesToProcess;
    mapCasesToProcess = new Map<Id,case>();
    Map<Id,case> mapCasesToProcOld;
    mapCasesToProcOld = new Map<Id,case>();

    for(Case casoItem: newMap.values()) {
      Case oldCase = new Case();
      oldCase = oldMap.get(casoItem.Id);
      boolean tratarCaso;
      tratarCaso = casoItem.SER_Business_Case_Type__c != null &&  casoItem.SER_Business_Case_Type__c.equalsIgnoreCase('EGS')
               && (casoItem.gf_group_incidence_case_name__c != oldCase.gf_group_incidence_case_name__c  //Grupo
                || casoItem.AccountId != oldCase.AccountId                                              // Cliente Filial
                || casoItem.customer_system_id__c != oldCase.customer_system_id__c                      // CLiente Local
                || casoItem.gf_reference_id__c != oldCase.gf_reference_id__c);                          // Referencia Local

      Boolean borrarBEI;
      borrarBEI = casoItem.SER_Business_Case_Type__c != null &&  casoItem.SER_Business_Case_Type__c.equalsIgnoreCase('EGS')
                && casoItem.gf_group_incidence_case_name__c == NULLVALUEID
                && casoItem.AccountId == NULLVALUEID
                && casoItem.customer_system_id__c == NULLVALUEID
                && casoItem.gf_reference_id__c == NULLVALUEID;

      if(tratarCaso) {
        mapCasesToProcess.put(casoItem.Id, casoItem);
        mapCasesToProcOld.put(oldCase.Id, oldCase);
      }

      if(borrarBEI) {
        casoItem.gf_bei_id__c = '';
      }
    }

    if(!mapCasesToProcess.isEmpty()) {
      processLookups(mapCasesToProcess,mapCasesToProcOld);
    }
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   checks the case's lookups for group, client, local client and 
                    local reference.

    IN:        Case
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    11/06/2020      Cintia Carmona         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static void processLookups(Map<Id,Case> casosNew, Map<Id,Case> casosOld) {
    system.debug('******* SER_BEISearchEngine_CONTROLLER.processLookups');
    Map<Id,case> mapFillLookups;
    mapFillLookups = new Map<Id,case>();
    Map<Id,case> mapCasesAntiguos;
    mapCasesAntiguos = new Map<Id,case>();
    Map<Id,case> mapDelLookups;
    mapDelLookups = new Map<Id,case>();

    for(Case casoItem : casosNew.values()) {
      Case oldCase = new Case();
      oldCase = casosOld.get(casoItem.Id);

      boolean rellenarLookups;
      boolean borrarLookups;

      rellenarLookups = (casoItem.gf_reference_id__c != oldCase.gf_reference_id__c
                      && casoItem.gf_reference_id__c != null)
                     || (casoItem.customer_system_id__c != oldCase.customer_system_id__c
                      && casoItem.customer_system_id__c != null)
                     || (casoItem.AccountId != oldCase.AccountId
                      && casoItem.AccountId != null)
                     || (casoItem.gf_group_incidence_case_name__c != oldCase.gf_group_incidence_case_name__c
                      && casoItem.gf_group_incidence_case_name__c != null);

      borrarLookups = (casoItem.gf_group_incidence_case_name__c != oldCase.gf_group_incidence_case_name__c
                    && casoItem.gf_group_incidence_case_name__c == null)
                   || (casoItem.AccountId != oldCase.AccountId
                    && casoItem.AccountId == null)
                   || (casoItem.customer_system_id__c != oldCase.customer_system_id__c
                    && casoItem.customer_system_id__c == null)
                   || (casoItem.gf_reference_id__c != oldCase.gf_reference_id__c
                      && casoItem.gf_reference_id__c == null);

      if(rellenarLookups) {
        mapFillLookups.put(casoItem.Id, casoItem);
        mapCasesAntiguos.put(casoItem.Id, oldCase);
      } else if(borrarLookups) {
        mapDelLookups.put(casoItem.Id, casoItem);
      }
    }

    if(!mapFillLookups.isEmpty()) {
      fillLookups(mapFillLookups, mapCasesAntiguos);
    }

    if(!mapDelLookups.isEmpty()) {
      deleteLookups(mapDelLookups);
    }
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   checks the case's lookups for group, client, local client and 
                    local reference.

    IN:        Case
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    11/06/2020      Cintia Carmona         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static void fillLookups(Map<Id,Case> casos, Map<Id,Case> casosAntiguos) {
    system.debug('******* SER_BEISearchEngine_CONTROLLER.fillLookups');
    for(Case casoItem : casos.values()) {
      Case oldCase = new Case();
      oldCase = casosAntiguos.get(casoItem.Id);

      boolean referencia; 
      referencia = casoItem.gf_reference_id__c != null && casoItem.gf_reference_id__c != oldCase.gf_reference_id__c;
      boolean clienteLocal; 
      clienteLocal = casoItem.customer_system_id__c != null && casoItem.customer_system_id__c != oldCase.customer_system_id__c;
      boolean cliente; 
      cliente = casoItem.AccountId != null && casoItem.AccountId != oldCase.AccountId;
      boolean grupo; 
      grupo = casoItem.gf_group_incidence_case_name__c != null && casoItem.gf_group_incidence_case_name__c != oldCase.gf_group_incidence_case_name__c;

      if(referencia) {
        casoItem = SER_BEISearchEngine_HELPER.createLocalClientLookUp(casoItem, casoItem.gf_reference_id__c);
        casoItem = SER_BEISearchEngine_HELPER.checkService(casoItem, casoItem.gf_reference_id__c);
        casoItem.gf_bei_id__c = fillCaseBEI(casoItem.gf_reference_id__c, LOCALREFERENCE);
      } else if(clienteLocal) {
        casoItem = SER_BEISearchEngine_HELPER.createClientLookUp(casoItem, casoItem.customer_system_id__c);
        casoItem.gf_reference_id__c = NULLVALUEID;
        casoItem.solution_cateogry_id__c = NULLVALUEID;
        casoItem.gf_bei_id__c = fillCaseBEI(casoItem.customer_system_id__c, LOCALCLIENT);
      } else if(cliente) {
        casoItem = SER_BEISearchEngine_HELPER.createGroupLookUp(casoItem, casoItem.AccountId);
        casoItem.customer_system_id__c = NULLVALUEID;
        casoItem.gf_reference_id__c = NULLVALUEID;
        casoItem.solution_cateogry_id__c = NULLVALUEID;
        casoItem.gf_bei_id__c = fillCaseBEI(casoItem.AccountId, CLIENT);
      } else if(grupo) {
        casoItem = SER_BEISearchEngine_HELPER.createMatrixLookUp(casoItem, casoItem.gf_group_incidence_case_name__c);
        casoItem.customer_system_id__c = NULLVALUEID;
        casoItem.gf_reference_id__c = NULLVALUEID;
        casoItem.solution_cateogry_id__c = NULLVALUEID;
        casoItem.gf_bei_id__c = fillCaseBEI(casoItem.gf_group_incidence_case_name__c, GROUPOBJ);
      }
    }
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   return the BEI code of the selected object.

    IN:        Id lookupId.
    IN:        String ObjectType.
    OUT:       String.

    History:
    <Date>            <Author>            <Change Description>
    17/06/2020      Javier Touchard         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static String fillCaseBEI(Id lookupId, String objectType) {
    String bei;
    bei = '';
    if(LOCALREFERENCE.equalsIgnoreCase(objectType)) {
      bei = [SELECT gf_bei_Id__c FROM Local_Reference__c WHERE Id = :lookupId].gf_bei_Id__c;
    } else if(LOCALCLIENT.equalsIgnoreCase(objectType)) {
      bei = [SELECT gf_bei_id__c FROM Local_Client_EGS__c WHERE Id = :lookupId].gf_bei_id__c;
    } else if(CLIENT.equalsIgnoreCase(objectType)) {
      bei = [SELECT gf_bei_Id__c FROM Account WHERE Id = :lookupId].gf_bei_Id__c;
    } else if(GROUPOBJ.equalsIgnoreCase(objectType)) {
      bei = [SELECT Group_BEI__c FROM Account WHERE Id = :lookupId].Group_BEI__c;
    }

    return bei;
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   checks the case's lookups for group, client, local client and 
                    local reference.

    IN:        Case
    OUT:       Void

    History:
    <Date>            <Author>            <Change Description>
    11/06/2020      Cintia Carmona         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static void deleteLookups(Map<Id,Case> casos) {
    system.debug('******* SER_BEISearchEngine_CONTROLLER.deleteLookups');
    for(Case casoItem : casos.values()) { 
      Case caso;
      caso = new case();
      if(casoItem.gf_group_incidence_case_name__c == null) {
        casoItem.AccountId = NULLVALUEID;
        casoItem.customer_system_id__c = NULLVALUEID;
        casoItem.gf_reference_id__c = NULLVALUEID;
        casoItem.solution_cateogry_id__c = NULLVALUEID;
      } else if(casoItem.AccountId == null) {
        casoItem.customer_system_id__c = NULLVALUEID;
        casoItem.gf_reference_id__c = NULLVALUEID;
        casoItem.solution_cateogry_id__c = NULLVALUEID;
        caso = SER_BEISearchEngine_HELPER.createMatrixLookUp(casoItem, casoItem.gf_group_incidence_case_name__c);
        casoItem.AccountId = caso.AccountId;
      } else if(casoItem.customer_system_id__c == null) {
        casoItem.gf_reference_id__c = NULLVALUEID;
        casoItem.solution_cateogry_id__c = NULLVALUEID;
      } else if(casoItem.gf_reference_id__c == null) {
        casoItem.solution_cateogry_id__c = NULLVALUEID;
      }
    }
  }

}