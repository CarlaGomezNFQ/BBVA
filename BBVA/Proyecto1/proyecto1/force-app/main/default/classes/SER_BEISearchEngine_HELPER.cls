/***************************************************************************************
* @author       BBVA
* @date         18-06-2020
* @description  Helper de la clase SER_BEISearchEngine_CONTROLLER.

****************************************************************************************/
public with sharing class SER_BEISearchEngine_HELPER {

  /*---------------------------------------------------------------------------------------
    Company:       BBVA
    Description:   Constructor privado.
  ---------------------------------------------------------------------------------------*/
  private SER_BEISearchEngine_HELPER() {}

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   checks if the case's service and the selected reference have a relationship.
                   If not deletes the case's service.

    IN:            Case caso.
    IN:            Id referenceId.
    OUT:           Case.

    History:
    <Date>            <Author>            <Change Description>
    10/06/2020      Javier Touchard         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static case checkService(Case caso, Id referenceId) {
    Case casoWServ;
    casoWServ = [SELECT solution_cateogry_id__c FROM Case WHERE Id = :caso.Id][0];
    List<LocalRef_and_Service__c> refAndServList;
    if(casoWServ != SER_BEISearchEngine_CONTROLLER.NULLVALUE) {
      refAndServList = [SELECT Id FROM LocalRef_and_Service__c WHERE gf_reference_id__c = :referenceId AND solution_category_id__c = :casoWServ.solution_cateogry_id__c];
    }
    if(refAndServList.isEmpty()) {
      caso.solution_cateogry_id__c = SER_BEISearchEngine_CONTROLLER.NULLVALUEID;
    }
    return caso;
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   retrieves the Group Id from the Client. 
                   Creates the lookup between the case and the group.

    IN:            Case caso.
    IN:            Id clientId.
    OUT:           Case.

    History:
    <Date>            <Author>            <Change Description>
    10/06/2020      Javier Touchard         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static case createGroupLookUp(Case caso, Id clientId) {
    Account cliente;
    cliente = [SELECT Id, DES_Main_Parent__c FROM Account WHERE Id = :clientId LIMIT 1];
    if(cliente == SER_BEISearchEngine_CONTROLLER.NULLVALUE && cliente.DES_Main_Parent__c == SER_BEISearchEngine_CONTROLLER.NULLVALUEID) {
      caso.gf_group_incidence_case_name__c = SER_BEISearchEngine_CONTROLLER.NULLVALUEID;
    } else if(cliente != SER_BEISearchEngine_CONTROLLER.NULLVALUE && cliente.DES_Main_Parent__c != SER_BEISearchEngine_CONTROLLER.NULLVALUEID) {
      caso.gf_group_incidence_case_name__c = cliente.DES_Main_Parent__c;
    }
    return caso;
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   retrieves the Client Id from the Local Client. 
                   Creates the lookup between the case and the Client.

    IN:            Case caso.
    IN:            Id localClientId.
    OUT:           Case.

    History:
    <Date>            <Author>            <Change Description>
    10/06/2020      Javier Touchard         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static case createClientLookUp(Case caso, Id localClientId) {
    Case casoTest;
    casoTest = caso;
    Local_Client_EGS__c localClientOb;
    localClientOb = [SELECT Id, company_customer_id__c FROM Local_Client_EGS__c WHERE Id = :localClientId LIMIT 1];
    if(localClientOb != SER_BEISearchEngine_CONTROLLER.NULLVALUE && localClientOb.company_customer_id__c != SER_BEISearchEngine_CONTROLLER.NULLVALUEID) {
      casoTest.AccountId = localClientOb.company_customer_id__c;
      casoTest = createGroupLookUp(casoTest, localClientOb.company_customer_id__c);
    }
    return casoTest;
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   retrieves the Local Client Id from the Reference. 
                   Creates the lookup between the case and the Local Client.

    IN:            Case caso.
    IN:            Id localClientId.
    OUT:           Case.

    History:
    <Date>            <Author>            <Change Description>
    10/06/2020      Javier Touchard         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static case createLocalClientLookUp(Case caso, Id referenceId) {
    Case casoTest;
    casoTest = caso;
    Local_Reference__c localReferenceOb;
    localReferenceOb = [SELECT Id, customer_system_id__c FROM Local_Reference__c WHERE Id = :referenceId LIMIT 1];
    if(localReferenceOb != SER_BEISearchEngine_CONTROLLER.NULLVALUE && localReferenceOb.customer_system_id__c != SER_BEISearchEngine_CONTROLLER.NULLVALUEID) {
      casoTest.customer_system_id__c = localReferenceOb.customer_system_id__c;
      casoTest = createClientLookUp(casoTest, localReferenceOb.customer_system_id__c);
    }
    return casoTest;
  }

  /*---------------------------------------------------------------------------------------
    Company:       BBVA.
    Description:   retrieves the Matrix Id from the Group.
                   Creates the lookup CLient Name between the case and the group.

    IN:            Case caso.
    IN:            Id groupId.
    OUT:           Case.

    History:
    <Date>            <Author>            <Change Description>
    10/06/2020      Javier Touchard         Initial Version
  ---------------------------------------------------------------------------------------*/
  public static case createMatrixLookUp(Case caso, Id groupId) {
    Account cliente;
    cliente = [SELECT Id, DES_Client_Matrix__c FROM Account WHERE Id = :groupId LIMIT 1];
    final boolean existeMatriz = cliente != SER_BEISearchEngine_CONTROLLER.NULLVALUE && cliente.DES_Client_Matrix__c != SER_BEISearchEngine_CONTROLLER.NULLVALUEID;
    if(existeMatriz) {
      caso.AccountId = cliente.DES_Client_Matrix__c;
    } else {
      caso.AccountId = SER_BEISearchEngine_CONTROLLER.NULLVALUEID;
    }
    return caso;
  }
}