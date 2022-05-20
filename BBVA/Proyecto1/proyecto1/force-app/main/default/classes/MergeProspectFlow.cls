/**
 * @description       :
 * @author            : David Rodríguez
 * @group             :
 * @last modified on  : 05-05-2021
 * @last modified by  : David Rodríguez
 * Modifications Log
 * Ver   Date         Author            Modification
 * 1.0   04-20-2021   David Rodríguez   Initial Version
**/
@SuppressWarnings('sf:AvoidLiteralsInIfCondition')
public without sharing class MergeProspectFlow {
  /**
  * SINGLETON PATTERN
  */
  private static MergeProspectFlow instance;

  /**
  * Constructor
  */
  private MergeProspectFlow() {
  }

  /**
  * getInstance
  */
  public static MergeProspectFlow gtInstance() {
    if(instance == null) {
      instance = new MergeProspectFlow();
    }
    return instance;
  }

  /*
  * Proceso de merge
  */
  @InvocableMethod(label='MergeProcess' description='Process to merge')
  public static void mergeProcess(List<WrapperMerge> mgList) {
    system.debug('** Entrada -> ' + JSON.serialize(mgList[0]));

    final List<Account> prospect = new List<Account>([
      SELECT Id, Name, DES_ID_Fiscal__c, participant_id__c, customer_stock_exchange_name__c, gf_customer_prospect_id__c,
      participant_status_type__c, gf_stock_exchange_company_id__c, gf_cust_orig_prospect_ind_type__c, DES_Prospect_status__c
      FROM Account WHERE Id = :mgList[0].idProspect
    ]);

    final List<Account> clientToMerge = new List<Account>([
      SELECT Id, Name, DES_ID_Fiscal__c, participant_id__c, customer_stock_exchange_name__c, gf_customer_prospect_id__c,
      participant_status_type__c, gf_stock_exchange_company_id__c, gf_cust_orig_prospect_ind_type__c
      FROM Account WHERE Id = :mgList[0].idClient
    ]);

    final List<Opportunity> oppsProspect = new List<Opportunity>([
      SELECT Id, Name, AccountId
      FROM Opportunity
      WHERE AccountId = :mgList[0].idProspect
    ]);

    final List<dwp_kitv__Visit__c> visitsProspect = new List<dwp_kitv__Visit__c>([
      SELECT Id, Name, dwp_kitv__account_id__c
      FROM dwp_kitv__Visit__c
      WHERE dwp_kitv__account_id__c = :mgList[0].idProspect
    ]);

    final List<Contact> contactsProspect = new List<Contact>([
      SELECT Id, Name, AccountId
      FROM Contact
      WHERE AccountId = :mgList[0].idProspect
    ]);


    final List<Contact> contactsToUpdate = addToList(contactsProspect, mgList[0].idClient, 'AccountId');
    final List<Opportunity> oppsToUpdate = addToList(oppsProspect, mgList[0].idClient, 'AccountId');
    final List<dwp_kitv__Visit__c> visitsToUpdate = addToList(visitsProspect, mgList[0].idClient, 'dwp_kitv__account_id__c');


    migrateFields(clientToMerge.get(0), prospect.get(0));
    updateList(contactsToUpdate);
    updateList(oppsToUpdate);
    updateList(visitsToUpdate);

    if(mgList[0].arceList != null && mgList[0].hasNoArce) {
      final List<arce__Account_has_Analysis__c> arceProspect = updateAHA(mgList.get(0), true);

      final Set<Id> arceIds = new Set<Id>();
      for(arce__Account_has_Analysis__c aHa : arceProspect) {
        arceIds.add(aHa.arce__Analysis__c);
      }
      updateAnalysis(arceIds, true, clientToMerge.get(0), mgList.get(0));

    } else if (mgList[0].arceList != null && !mgList[0].hasNoArce) {
      final List<arce__Account_has_Analysis__c> arceProspect = updateAHA(mgList.get(0), false);

      final Set<Id> arceIds = new Set<Id>();
      final List<arce__Account_has_Analysis__c> aHaToUpdate = new List<arce__Account_has_Analysis__c>();
      for(arce__Account_has_Analysis__c aHa : arceProspect) {
        arceIds.add(aHa.arce__Analysis__c);
        if(aHa.arce__Analysis__r.arce__Stage__c == '3') {
          aHa.arce__CustomAccountID__c = mgList[0].idLocalClient;
          aHa.DES_Local_Client__c = mgList[0].idLocalClient;
          aHa.arce__Customer__c = mgList[0].idClient;
          aHa.arce__group_risk_detail_part_name__c = mgList[0].lClientName;
          aHa.arce__participant_name__c = mgList[0].lClientName;
          aHaToUpdate.add(aHa);
        }
      }

      updateList(aHaToUpdate);

      updateAnalysis(arceIds, false, clientToMerge.get(0), mgList.get(0));
    }
    final DES_Arc_ProspectController.WrapperService wrap = new DES_Arc_ProspectController.WrapperService(prospect.get(0), mgList[0].lClientAlpha, false);
    callWSConvert(JSON.serialize(wrap));
    deleteGroupsPros(prospect.get(0).participant_id__c, mgList[0].idProspect);    
  }

  /*
  * Private method to add record to List
  */
  @Future(callout=true)
  public static void callWSConvert(String wrapJson) {
    final DES_Arc_ProspectController.WrapperService wrap = (DES_Arc_ProspectController.WrapperService) JSON.deserialize(wrapJson, DES_Arc_ProspectController.WrapperService.class);
    if(wrap.pros.DES_Prospect_status__c == Label.Prospect_created) {
      DES_Arc_ProspectController.callConvertProspect(wrap.pros.Name, wrap.pros.DES_ID_Fiscal__c, wrap.pros.gf_customer_prospect_id__c, wrap.alphacode);
    } else if (DES_Arc_ProspectController.callCreateProspect(wrap.pros, wrap.toUpdate)) {
      DES_Arc_ProspectController.callConvertProspect(wrap.pros.Name, wrap.pros.DES_ID_Fiscal__c, wrap.pros.gf_customer_prospect_id__c, wrap.alphacode);
    }
  }

  /*
  * Private method to add record to List
  */
  private static List<SObject> addToList(List<SObject> sourceList, String clientId, String field) {
    final List<SObject> listToReturn = new List<SObject>();
    for(SObject obj : sourceList) {
      obj.put(field, clientId);
      listToReturn.add(obj);
    }
    return listToReturn;
  }

  /*
  * Private method to update List
  */
  private static void updateList(List<SObject> sourceList) {
    if(!sourceList.isEmpty()) {
      update sourceList;
    }
  }

  /*
  * Private method to migrate fields from Prospect to account
  */
  private static void migrateFields(Account acc, Account prospect) {
    acc.customer_stock_exchange_name__c = prospect.customer_stock_exchange_name__c;
    acc.participant_status_type__c = prospect.participant_status_type__c;
    acc.gf_stock_exchange_company_id__c = prospect.gf_stock_exchange_company_id__c;
    acc.gf_cust_orig_was_prospect_ind_type__c = true;
    update acc;
  }

  /**
  * Private method to delete prospect group
  */
  private static void deleteGroupsPros(String groupId, String idProspect) {
    final List <Account> accsToDelete = new List <Account>();
    final List<Account> prosNotConvert = new List<Account>([
      SELECT Id, DES_ID_Fiscal__c, participant_id__c FROM Account WHERE participant_id__c = :groupId AND participant_id__r.RecordType.DeveloperName = 'Prospect_Group' AND RecordType.DeveloperName = 'Prospect_Subsidiary'
    ]);

    if(prosNotConvert.size() == 1) {
      final Account accAux = new Account(Id = groupId);
      accsToDelete.add(accAux);
    }
    final Account accAux1 = new Account(Id = idProspect);
    accsToDelete.add(accAux1);
    delete accsToDelete;
  }

  /*
  * Private method update AccountHasAnalysis
  */
  private static List<arce__Account_has_Analysis__c> updateAHA(WrapperMerge mgList, Boolean hasNoArce) {
    final Set<Id> aHaIds = new Set<Id>();
      for(arce__Account_has_Analysis__c arce : mgList.arceList) {
        aHaIds.add(arce.Id);
      }

      final List<arce__Account_has_Analysis__c> arceProspect = new List<arce__Account_has_Analysis__c>([
        SELECT Id, DES_Local_Client__c, arce__Customer__c, arce__Analysis__c, arce__Analysis__r.arce__Stage__c
        FROM arce__Account_has_Analysis__c WHERE Id IN :aHaIds
      ]);

      if(hasNoArce) {
        final List<arce__Account_has_Analysis__c> arcesToUpdate = new List<arce__Account_has_Analysis__c>();
        for(arce__Account_has_Analysis__c arce : arceProspect) {
          arce.DES_Local_Client__c = mgList.idLocalClient;
          arce.arce__CustomAccountID__c = mgList.idLocalClient;
          arce.arce__Customer__c = mgList.idClient;
          arce.arce__group_risk_detail_part_name__c = mgList.lClientName;
          arce.arce__participant_name__c = mgList.lClientName;
          arcesToUpdate.add(arce);
        }
        updateList(arcesToUpdate);
      }

      return arceProspect;
  }

  /*
  * Private method to update Analysis
  */
  private static void updateAnalysis(Set<Id> arceIds, Boolean hasNoArce, Account clientToMerge, WrapperMerge mgList) {
    final List<arce__Analysis__c> analysisPros = new List<arce__Analysis__c >([
      SELECT Id, Name, arce__Stage__c
      FROM arce__Analysis__c WHERE Id IN :arceIds
    ]);

    final List<arce__Analysis__c> analysisToUpdate = new List<arce__Analysis__c>();
    final List<arce__Analysis__c> arceDelete = new List<arce__Analysis__c>();

    for(arce__Analysis__c analysis : analysisPros) {
      if(hasNoArce || (!hasNoArce && analysis.arce__Stage__c == '3')) {
        final List<String> nameSplit = analysis.Name.split('-');
        analysis.Name = analysis.Name.replace(nameSplit[1], ' ' + mgList.lClientName + ' ');
        analysis.arce__Group__c = clientToMerge.Id;
        analysisToUpdate.add(analysis);
      } else {
        arceDelete.add(analysis);
      } 
    }
    updateList(analysisToUpdate);
    if(!arceDelete.isEmpty()) {
      delete arceDelete;
    }
  }

  /*
  * Entrada del method invocable addMemberGroup
  */
  public class WrapperMerge {
    /*
    * Id del prospect
    */
    @InvocableVariable(label='Id del prospect' required=false)
    public String idProspect; //NOSONAR

    /**
    * Id del cliente al que se va a mergear
    */
    @InvocableVariable(label='Id del cliente' required=false)
    public String idClient; //NOSONAR

    /**
    * Id del localClient
    */
    @InvocableVariable(label='Id del cliente local' required=false)
    public String idLocalClient; //NOSONAR

    /**
    * Lista de Arces
    */
    @InvocableVariable(label='Lista de Arce' required=false)
    public List<arce__Account_has_Analysis__c> arceList; //NOSONAR

    /**
    * Lista de Arces
    */
    @InvocableVariable(label='Tiene ARCE' required=false)
    public Boolean hasNoArce; //NOSONAR

    /**
    * Nombre local client
    */
    @InvocableVariable(label='Local Client Name' required=false)
    public String lClientName; //NOSONAR

    /**
    * Nombre local client
    */
    @InvocableVariable(label='Local Client Alpha' required=false)
    public String lClientAlpha; //NOSONAR
  }

}