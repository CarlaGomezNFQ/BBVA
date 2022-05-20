/**********************************************************************************
* @author       Accenture
* @date         01/03/2016
* @description  Manejador del trigger para el objeto Account. No implementar logica aquí, para ello utilizar ActivitiesUtils
* @Revision
                2017/10/26 Se deja de utilizar customActivity (Activity__c) y se comentan las líneas de código que ya no aplican
                2018/06/11 Añadida lógica en el met0d0 assignRecordType para poner el Recordtype en las cargas de la parte de DESKTOP
                2018/06/14 Añadida lógica en el met0d0 assignRecordType para poner el Recordtype en las cargas antiguas de SALES del
                Dataloader para las contrapartidas de INTRANET
                2018/07/18 Añadido mét0d0 setRevenueUpdateEngloba para poner el valor de la fecha de Engloba
                2018/07/20 Actualizada lógica en el met0d0 assignRecordType para poner el Recordtype correctamente
                2018/08/10 Actualizada lógica en los met0d0s assignRecordType y setRecordType para el nuevo tipo NO_CLIENT
				2019/08/21 Actualizada lógica en el met0d0 assignRecordType para las cargas de Contrapartidas de Dataloader
**********************************************************************************/
@SuppressWarnings('sf:NcssMethodCount')
public with sharing class AccountTriggerHandler {
  //LOGIC
  //private final ActivitiesUtils logic;
  //private static final Integer timesExecuted = 0;
  /**
  *Nulo
   */
  private static final String NULO = '--null--';
  /*
  * @author Global Desktop
  **/
  public static String profileName;
  /**
  *userSettings
   */
  private final CIB_User_Org__c userSettings = CIB_User_Org__c.getInstance();
  //private Set<String> setAccIdHierarchyForOpp = new Set<String>();   //Set used to avoid duplicate id's

  //SINGLETON PATTERN
  /** instance */
  private static AccountTriggerHandler instance;
  /** getInstance */
  public static AccountTriggerHandler getInstance() {
    if (instance == null) {
        instance = new AccountTriggerHandler();
      }
      return instance;
  }

  /*
  * Get profile Name
  */
  public String getProfileName() { //NOSONAR
      if(profileName == null) {
          profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].get(0).Name;
      }
      return profileName;
  }

  //EVENT HANDLER
/*
    public void onAfterDelete(final List<Account> oldList) {
        system.debug(Logginglevel.INFO,'>>>>>>> Entrando trigger Account (after delete)');
        if (userSettings.CIB_Is_Sales__c){
            system.debug(Logginglevel.INFO,'>>>>>>> Sales User. Entering custom activities...');
            ActivitiesUtils.deleteActivityC(oldList);
        }
        timesExecuted ++;
    }
 */
  /**
  * Entran t0d0s los AbacoIds, repetidos o no, si viene el campo
  * auxiliar SAL_AbacoIdNull__c = '--null--' el abacoId es null.
  */
  public void asignarAbacoIdNull(List<Account> lstAccount) {
    if (!userSettings.CIB_Is_Desktop__c) {
      System.debug('jlb - Account: '+lstAccount);
      for(Account acc: lstAccount) {
        System.debug('jlb acc.SAL_AbacoIdNull__c: ' +acc.SAL_AbacoIdNull__c);
        if(acc.SAL_AbacoIdNull__c == NULO) {
          acc.SER_Abaco_ID__c = null; //NOSONAR
          acc.SAL_AbacoIdNull__c = '';
        }
      }
    }


  }
  /**
  * assignRecordType
  */
  public void assignRecordType(List<Account> triggerNew, Map<Id, Account> oldAccounts) {
    Boolean flag;
    Boolean isSystemDataloader = profileName == Label.DES_DATALOADER_PROFILE;
    System.debug('isSystemDataloader ' + isSystemDataloader);
    //final User usInfo = [SELECT id, Country, Profile.Name FROM User WHERE id = :UserInfo.getUserId() LIMIT 1];

    for(Account acc : triggerNew) {
      //No actualiza de ser un prospect
      flag = isProspect(acc);
      // Si no viene de la carga de dataloader pero es un registro de la parte antigua (parte de Sales y Service)
      if(!flag && acc.DES_Data_Origin_Intranet__c != null && acc.DES_Data_Origin_Intranet__c) {
        if (Trigger.isInsert && !(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_SALES_COUNTERPART).getRecordTypeId() && isSystemDataloader) ) {
          acc.RecordTypeId = setRecordType(acc);
        } else if(Trigger.isUpdate) { // no queremos que sobrescriba el valor de Segmentation y de Structure Type
           acc.DES_BBVA_Segmentation__c = oldAccounts.get(acc.Id).DES_BBVA_Segmentation__c;
           acc.DES_Structure_Type__c = oldAccounts.get(acc.Id).DES_Structure_Type__c;
        }

      } else if (!flag) {
           // SI SOLO SE INSERTA 1 CLIENTE Y NO TIENE NI EL CAMPO DES_Structure_Type__c NI EL DES_BBVA_Segmentation__c RELLENOS, SE PONE AUTOMATICAMENTE BEC GROUP
          if(Trigger.isInsert && triggerNew.size() == 1 && acc.DES_BBVA_Segmentation__c == null && acc.DES_Structure_Type__c == null && !isSystemDataloader) {
            if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_NO_CLIENT).getRecordTypeId()) {
              acc.DES_Structure_Type__c = Label.DES_STR_TYPE_NO_CLIENT;
            } else {
              if(acc.DES_Entity_Type__c == null) {
                acc.DES_Structure_Type__c = Label.DES_STR_TYPE_Subsidiary;
              } else {
                acc.DES_Structure_Type__c = acc.DES_Entity_Type__c;
              }
              acc.DES_BBVA_Segmentation__c = Label.DES_Segmentation_BEC;
            }
          }

          // Para la carga masiva via PT_CIB
          if( /*acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_NO_CLIENT).getRecordTypeId() ||*/
            acc.DES_BBVA_Segmentation__c != null && acc.DES_Structure_Type__c != null && !(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_SALES_COUNTERPART).getRecordTypeId() && isSystemDataloader) ) {
            acc.RecordTypeId = setRecordType(acc);
          }

      }// FIN ELSE

    }//FIN FOR
  }//FIN

  private Boolean isProspect(Account acc) { //NOSONAR
    Boolean result = false;
    if (((Trigger.isUpdate && acc.DES_Provisioning_Method__c != 'Datio') || Trigger.isInsert) &&
        acc.RecordTypeId != null && (acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Subsidiary').getRecordTypeId() ||
        acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Group').getRecordTypeId())) {

      result = true;
      acc.Website = acc.Website_Prospect__c;
      //acc.gf_customer_prospect_id__c = Desktop_Utils2.generateExtId();
      // acc.business_group_id__c = acc.participant_id__c;
      acc.DES_Main_Parent__c = acc.participant_id__c;
      acc.gf_cust_orig_prospect_ind_type__c = true;
      //acc.country_name__c = acc.country_name__c != null ? acc.country_name__c : usInfo.Country;
      acc.DES_BBVA_Segmentation__c = acc.CIB_Commercial_Prospect__c == Label.DES_Segmentation_CIB ? Label.DES_Segmentation_CIB : Label.DES_Segmentation_BEC;
      acc.DES_Structure_Type__c = (acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Subsidiary').getRecordTypeId()) ? Label.DES_RT_Subsidiary : Label.DES_RT_Group;
    } else if ((Trigger.isUpdate && acc.DES_Provisioning_Method__c == 'Datio') && acc.old_participant_id__c == null &&
        acc.RecordTypeId != null && (acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Subsidiary').getRecordTypeId())) {
        acc.old_participant_id__c = acc.participant_id__c;
    }
    return result;
  }


  /*
  * Method for show error when prospect has same id fiscal on account
  */
  public void checkErrorProspect(List<Account> lAcc, Map<Id, Account> oldAccounts) { //NOSONAR
    final Map<String, Account> mAccountCheck = new Map<String, Account> ();

    for(Account acc : lAcc) {
      if (acc.RecordTypeId != null &&
          (acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Subsidiary').getRecordTypeId() ||
          acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Group').getRecordTypeId()) &&
          acc.DES_ID_Fiscal__c != oldAccounts.get(acc.id).DES_ID_Fiscal__c &&
          acc.DES_ID_Fiscal__c != null) {

            mAccountCheck.put(acc.DES_ID_Fiscal__c, acc);
      }
    }
    if (!mAccountCheck.isEmpty()) {
      isIDFiscalProspect(mAccountCheck);
    }
  }


  private static void isIDFiscalProspect(Map<String, Account> mAcc) {
      final List<Account> lAccount = [SELECT id, Name, DES_ID_Fiscal__c FROM Account WHERE DES_ID_Fiscal__c = :mAcc.keySet()];
      //query solo con account
      String error;
      for (Account acc : lAccount) {
        error = Label.Error_Duplicate_ID_Fiscal.replace('%%name%%', +'"'+acc.Name+'"').replace('%%id_fiscal%%', +'"'+acc.DES_ID_Fiscal__c+'"');
        mAcc.get(acc.DES_ID_Fiscal__c).addError(error);
      }
  }

  /**
  * setRevenueUpdateEngloba
  */
  public void setRevenueUpdateEngloba(List<Account> triggerNew, Map<Id, Account> oldAccounts) {
    if (userSettings.CIB_Is_Desktop__c) {
      for(Account acc : triggerNew) {
        if(oldAccounts.get(acc.Id).DES_Revenue_Update_Engloba__c != null && oldAccounts.get(acc.Id).DES_Revenue_Update_Engloba__c != acc.DES_Revenue_Update_Engloba__c) {
          acc.DES_Previous_Revenue_Update_Engloba__c = oldAccounts.get(acc.Id).DES_Revenue_Update_Engloba__c;
        } else {
          acc.DES_Previous_Revenue_Update_Engloba__c = acc.DES_Revenue_Update_Engloba__c;
        }

        if(oldAccounts.get(acc.Id).DES_RAR_EVA_RORC_Update_Engloba__c != null && oldAccounts.get(acc.Id).DES_RAR_EVA_RORC_Update_Engloba__c != acc.DES_RAR_EVA_RORC_Update_Engloba__c) {
          acc.DES_Previous_RAR_EVA_RORC_Update_Engloba__c = oldAccounts.get(acc.Id).DES_RAR_EVA_RORC_Update_Engloba__c;
        } else {
          acc.DES_Previous_RAR_EVA_RORC_Update_Engloba__c = acc.DES_RAR_EVA_RORC_Update_Engloba__c;
        }
      }
    }
  }  //FIN

  /**
  * setRevenueInsertEngloba
  */
  public void setRevenueInsertEngloba(List<Account> triggerNew) {
    if (userSettings.CIB_Is_Desktop__c) {
      for(Account acc : triggerNew) {
        acc.DES_Previous_Revenue_Update_Engloba__c = acc.DES_Revenue_Update_Engloba__c;
        acc.DES_Previous_RAR_EVA_RORC_Update_Engloba__c = acc.DES_RAR_EVA_RORC_Update_Engloba__c;
      }
    }
  }  //FIN

  /**
  *updateAbacoIdNull
   */
  public void updateAbacoIdNull(Map<Id, Account> mapAccounts) {
    if (!userSettings.CIB_Is_Desktop__c) {
      for(String idAccount : mapAccounts.keySet()) {
        if(mapAccounts.get(idAccount).SAL_AbacoIdNull__c ==  NULO) {
          mapAccounts.get(idAccount).SER_Abaco_ID__c = null;  //NOSONAR
          mapAccounts.get(idAccount).SAL_AbacoIdNull__c =  '';
        }
      }
    }
  }

  private static Id setRecordType(Account acc) {
    Id recordType;
    system.debug('>>>>> setRecordType, Account : ' + acc);
    if(acc.DES_BBVA_Segmentation__c == Label.DES_Segmentation_Local) {
      system.debug('Se cambia Local rt');
      if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Subsidiary) {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_ARCE_LOCAL_SUBSIDIARY).getRecordTypeId();
      } else {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_ARCE_LOCAL_GROUP).getRecordTypeId();
      }
    } else if(acc.DES_BBVA_Segmentation__c == Label.DES_Segmentation_NBC) {
      system.debug('Se cambia NBC');
      recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_CLIENT_NBC).getRecordTypeId();
    } else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_COMMERCIAL_CLIENT).getRecordTypeId() ||
      acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_STR_TYPE_NIF).getRecordTypeId()) {
      //Si la cuenta tiene el recordtype de Cliente BEC
      //Se cambia el RT a Cliente BEC
      //acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_COMMERCIAL_CLIENT).getRecordTypeId();
      if(acc.DES_Entity_Type__c == Label.DES_STR_TYPE_Subsidiary) {
          recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_Subsidiary_Commercial_Client).getRecordTypeId();
      } else if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_NIF) {
          recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_STR_TYPE_NIF).getRecordTypeId();
          system.debug('>>>>> Se cambia el RT a NIF Client ('+ acc.Name +'): ' + recordType);
      } else {
          recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_BEC_Manually_Group).getRecordTypeId();
          system.debug('>>>>> Se cambia el RT a Cliente BEC ('+ acc.Name +'): ' + recordType);
      }
    } else if(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_BEC_Manually_Group).getRecordTypeId()) {
		  recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_BEC_Manually_Group).getRecordTypeId();
    } /*else if (acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_NO_CLIENT).getRecordTypeId()) {
      //Se cambia el RT a NO CLIENT
      recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NO_CLIENT).getRecordTypeId();
      system.debug('>>>>> Se cambia el RT a NO CLIENT ('+ acc.Name +'): ' + recordType);
    }*/ else if(acc.DES_BBVA_Segmentation__c == Label.DES_Segmentation_BEC) {
      if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Supragroup
         || acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Group
         || acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Subgroup
         || acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Shared_Manag_Group
         || acc.RecordType.Name == Label.DES_RT_NAME_COMMERCIAL_CLIENT) {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_COMMERCIAL_CLIENT).getRecordTypeId();
        system.debug('>>>>> Se cambia el RT a DES_RT_NAME_COMMERCIAL_CLIENT: ' + Label.DES_RT_NAME_COMMERCIAL_CLIENT);
      } else {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_Subsidiary_Commercial_Client).getRecordTypeId();
        system.debug('>>>>> Se cambia el RT a DES_RT_Subsidiary_Commercial_Client: ' + Label.DES_RT_Subsidiary_Commercial_Client);
      }
    } else if(acc.DES_BBVA_Segmentation__c == Label.DES_Segmentation_CIB) {
      if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Supragroup) {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_Supragroup).getRecordTypeId();
      } else if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Group) {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_Group).getRecordTypeId();
      } else if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Subgroup) {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_Subgroup).getRecordTypeId();
      } else if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Shared_Manag_Group) {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_Shared_Management_Group).getRecordTypeId();
      } else if(acc.DES_Structure_Type__c == Label.DES_STR_TYPE_Subsidiary) {
        recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_SER_SUBSIDIARY).getRecordTypeId();
      }
    }
    return recordType;
  }  //FIN setRecordType

  /**
  *ponerParentIdNull
   */
  public void ponerParentIdNull(Map<Id, Account> newAccounts, Map<Id, Account> oldAccounts) {
    if (!userSettings.CIB_Is_Desktop__c) {
      for(String idAccount : newAccounts.keySet()) {
        if(newAccounts.get(idAccount).SAL_LGT_ParentId_Null__c ==  NULO) {
          newAccounts.get(idAccount).parentId = null; //NOSONAR
          newAccounts.get(idAccount).SAL_LGT_ParentId_Null__c =  '';
        }
      }
    }
  }

  /**
  * @description
  * @author Global Desktop | 08-04-2021
  * @param newAccounts
  **/
  public void generateProspectId(Map<Id, Account> newAccounts) {
    final List<String> ids = new List<String>();
    for(String idAccount : newAccounts.keySet()) {
      if(newAccounts.get(idAccount).RecordTypeId != null && newAccounts.get(idAccount).RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect_Subsidiary').getRecordTypeId()) {
        ids.add(idAccount);
      }
    }
    final List<Account> accList = [Select Id, Name, DES_ID_Fiscal__c, gf_customer_prospect_id__c from Account where id in :ids];
    for(Account acc : accList) {
      acc.gf_customer_prospect_id__c = String.valueOf(acc.Id).substring(3);
      DES_Arc_ProspectController.WrapperService wrap = new DES_Arc_ProspectController.WrapperService(acc,'',true);
      //Llamada servicio alta
      DES_Arc_ProspectController.futureCreateProspect(Json.serialize(wrap));
    }

    update accList;
  }

/*
    public void setUnifiedExternalID(List<Account> triggerNew){
        for(Account auxAccount : triggerNew){
                if(auxAccount.DES_Group_Code__c != null){
                        System.debug('auxAccount.salesforce_unified_external_id__c grupo antes' + auxAccount.salesforce_unified_external_id__c);
                        auxAccount.salesforce_unified_external_id__c = auxAccount.DES_Group_Code__c;
                        System.debug('auxAccount.salesforce_unified_external_id__c grupo' + auxAccount.salesforce_unified_external_id__c);
                } else if (auxAccount.SER_CClient__c != null){
                        System.debug('auxAccount.salesforce_unified_external_id__c filial antes' + auxAccount.salesforce_unified_external_id__c);
                        auxAccount.salesforce_unified_external_id__c = auxAccount.SER_CClient__c;
                        System.debug('auxAccount.salesforce_unified_external_id__c filial' + auxAccount.salesforce_unified_external_id__c);
                } else if (auxAccount.Client_STAR_ID__c != null){
                        System.debug('auxAccount.salesforce_unified_external_id__c contrapartida antes' + auxAccount.salesforce_unified_external_id__c);
                        auxAccount.salesforce_unified_external_id__c = auxAccount.Client_STAR_ID__c;
                        System.debug('auxAccount.salesforce_unified_external_id__c contrapartida' + auxAccount.salesforce_unified_external_id__c);
                } else {
                        System.debug('auxAccount.salesforce_unified_external_id__c fiscal ID antes' + auxAccount.salesforce_unified_external_id__c);
                        auxAccount.salesforce_unified_external_id__c = auxAccount.DES_ID_Fiscal__c;
                        System.debug('auxAccount.salesforce_unified_external_id__c fiscal ID' + auxAccount.salesforce_unified_external_id__c);
                }
        }
    }
 */
/*public void checkIfSimilarAccounts(List<Account> triggerNew){
    if(triggerNew.size() == 1){
        id commercialClientId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_COMMERCIAL_CLIENT).getRecordTypeId();
        id nonClientId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NO_CLIENT).getRecordTypeId();
        //if(triggerNew.get(0).RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_COMMERCIAL_CLIENT).getRecordTypeId()){
            list<Account> accList = [SELECT id, Name, DES_ID_Fiscal__c, DES_Country_Client__c, DES_Entity_Type__c, BBVA_Entity__c, RecordTypeId
                                                            FROM Account WHERE
                                                            (DES_ID_Fiscal__c =: triggerNew.get(0).DES_ID_Fiscal__c
                                                            OR
                                                                (Name =: triggerNew.get(0).Name
                                                                AND DES_Country_Client__c =: triggerNew.get(0).DES_Country_Client__c
                                                                AND DES_Entity_Type__c =: triggerNew.get(0).DES_Entity_Type__c
                                                                AND BBVA_Entity__c =: triggerNew.get(0).BBVA_Entity__c
                                                                )
                                                            OR  (Name =: triggerNew.get(0).Name
                                                                AND DES_Country_Client__c =: triggerNew.get(0).DES_Country_Client__c
                                                                AND DES_Entity_Type__c =: triggerNew.get(0).DES_Entity_Type__c
                                                                )
                                                            )
                                                            ];
            for(Account a: accList){
                if(a.DES_ID_Fiscal__c == triggerNew.get(0).DES_ID_Fiscal__c
                && triggerNew.get(0).RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_COMMERCIAL_CLIENT).getRecordTypeId()){
                    triggerNew.get(0).addError('There is already another client with the same fiscal number: ' +a.Name);
                }else if(a.Name == triggerNew.get(0).Name && a.DES_Country_Client__c == triggerNew.get(0).DES_Country_Client__c &&
                        a.DES_Entity_Type__c == triggerNew.get(0).DES_Entity_Type__c && a.BBVA_Entity__c == triggerNew.get(0).BBVA_Entity__c
                        && !triggerNew.get(0).not_duplicated_client_type__c
                        && triggerNew.get(0).RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_COMMERCIAL_CLIENT).getRecordTypeId()
                        && a.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_COMMERCIAL_CLIENT).getRecordTypeId()){
                    triggerNew.get(0).addError('It seems that there is another Commercial Client in Global Desktop with the same information: ' +a.Name+
                    '. Marck the checkbox "Not duplicated Client" in case you want to go on with the process');
                }else if(a.Name == triggerNew.get(0).Name && a.DES_Country_Client__c == triggerNew.get(0).DES_Country_Client__c &&
                        a.DES_Entity_Type__c == triggerNew.get(0).DES_Entity_Type__c
                        && triggerNew.get(0).RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NEW_NO_CLIENT).getRecordTypeId()
                        && a.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.DES_RT_NAME_NO_CLIENT).getRecordTypeId()){
                    triggerNew.get(0).addError('It seems that there is another Non Client in Global Desktop with the same information: ' +a.Name+
                    '. Marck the checkbox "Not duplicated Client" in case you want to go on with the process');
                }

            }

    }
   }*/

  /*   private void setMatriz(Trigger.new){
          for (Account opp : listaOportunidades){
                 setAccIdHierarchyForOpp.clear();

                 if(opp.AccountId != null) { //para las opp de Lead no se aplica la lógica
                     recursiveFxn(opp.AccountId);
     }

     //Recursive function to set the matrix of the Account hierarchy for a given account
     private void matrizRecursiva(string accId) {
         Account filialMatriz = new Account ();
         if (accId != null) {
             system.debug('Adding Account Id >> Acc:' + accId);
             setAccIdHierarchyForOpp.add(accId);
         }

         //Retrieve the parents for the account passed
         List<dwp_acmh__GBL_Account_Relationship__c> listAccRel = [SELECT Id, dwp_acmh__Parent_Account__r.DES_Client_Matrix__c, dwp_acmh__Parent_Account__r.RecordTypeId,
                                                                   dwp_acmh__Child_Account__r.DES_Entity_Hierarchy__c, dwp_acmh__Child_Account__r.Id
                                                                   FROM dwp_acmh__GBL_Account_Relationship__c WHERE dwp_acmh__Child_Account__c = :accId];

         //iterate to recursively add the opportunity to each parent in the hierarchy
         for (dwp_acmh__GBL_Account_Relationship__c accRel : listAccRel) {
             // si la cuenta es matriz me guardo su id
             if (accRel.dwp_acmh__Child_Account__r.DES_Entity_Hierarchy__c == 'S'){
                 filialMatriz.Id = accRel.dwp_acmh__Child_Account__c;
             }
             // si su padre es grupo, guardo en el grupo el id de la matriz
             if (accRel.dwp_acmh__Parent_Account__r.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Group').getRecordTypeId()){
                 accRel.dwp_acmh__Parent_Account__r.DES_Client_Matrix__c = filialMatriz.Id;
             // si el padre no es grupo, sigo recorriendo hacia arriba
             } else {
                 matrizRecursiva(accRel.dwp_acmh__Parent_Account__c);
             }
         }
     }
   */

}