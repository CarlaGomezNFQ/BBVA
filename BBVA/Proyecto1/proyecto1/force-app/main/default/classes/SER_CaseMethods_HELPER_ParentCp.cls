/*-----------------------------------------------------------------
    Author:    Juan Carlos Terrón
    Company:     Accenture
    Description:   This class contains helper and auxiliar methods
                  to not overload the main casemethods class of logic parent.

    History:
    <Date>      <Author>        <Description>
    04/07/2017    Juan Carlos Terrón    Initial Version.
    -------------------------------------------------------------------*/
public without sharing class SER_CaseMethods_HELPER_ParentCp {

  private SER_CaseMethods_HELPER_ParentCp() {
  }

  /*------------------------------------------------------------------------------------------------
      Author:    Juan Carlos Terrón
      Company:     Accenture
      Description:   Copy Fields from a Parent Case to its children.

      IN:
      OUT:       Void

      History:
      <Date>          <Author>        <Change Description>
      26/09/2017        Juan Carlos Terrón    Initial Version
      12/11/2018        Jose Luis Aranda      Add GNC
      13/03/2020        Jose Luis Aranda      Add EGS
      ---------------------------------------------------------------------------------------------------*/
  public static void copyParentFieldsUPDATE(Case caso, Case casoPadre, Map<String,String> mapPicklistValues) {
    System.debug('JCT - ENTRO en la asignación : '+caso.Id);

    Boolean case1;
    case1 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE;
    Boolean case2;
    case2 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_GM && caso.SER_Close__c != true;
    Boolean case3;
    case3 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_GNC && caso.SER_Close__c != true;
    Boolean case4;
    case4 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_EGS; //NOSONAR

    if(case1) {//STE Business Logic
      caso.SER_Close__c           = casoPadre.SER_Close__c;
      caso.SER_Type_EST__c        = casoPadre.SER_Type_EST__c;
      caso.SER_Subtype_STE__c     = casoPadre.SER_Subtype_STE__c;
      caso.SER_Web_App__c         = casoPadre.SER_Web_App__c;
      caso.Subject                = casoPadre.Subject;
      caso.Description            = casoPadre.Description;
      caso.SER_Classification__c  = casoPadre.SER_Classification__c;
      if(casoPadre.Status == mapPicklistValues.get('Closed')) {//Parent case is being closed
        caso.Status = mapPicklistValues.get('Closed');
      } else {
        caso.Status = mapPicklistValues.get('Linked to Master Case');
        caso.SER_Skip_validations__c = true;
      }
      //Victor: se agrego condicion caso.SER_Close__c != true para que no actualizara los hijos que estan cerrados cuando el padre se modifica
    } else if(case2) {
      //GM Bussines Logic
      System.debug('JCT - CAMBIO LOS CAMPOS de  : '+caso.Id);
      asignarAssetPtoC (caso, casoPadre);
      /**
        * Description: Add if for clientName casopadre in empty
        * @autor: Victor Velandia (VV)
        */
      if(caso.AccountId != casoPadre.AccountId && caso.AccountId == null) {
        caso.AccountId                = casoPadre.AccountId;
      }
      caso.SER_Type_GM__c             = casoPadre.SER_Type_GM__c; //Typologia
      caso.SER_Subtype_GM__c          = casoPadre.SER_Subtype_GM__c; // Reason
      caso.SER_Classification__c      = casoPadre.SER_Classification__c; //Classification
      caso.SER_MailingGroup__c        = casoPadre.SER_MailingGroup__c; //Mailing Group
      caso.SER_Outbound_Mailbox__c    = casoPadre.SER_Outbound_Mailbox__c; //Email outbox
      caso.SER_Pre_liquidacion__c     = casoPadre.SER_Pre_liquidacion__c; //Pre-liquidation
      caso.SER_Post_liquidation__c    = casoPadre.SER_Post_liquidation__c; //Post-liquidation
      copyStatusClose (caso, casoPadre);
      // Victor: se agrego condicion caso.SER_Close__c != true para que no actualizara los hijos que estan cerrados cuando el padre se modifica
    } else if(case3) {//GNC Bussines Logic
      /**
        * Description: Add AccountID and Subject
        * @autor: Victor Velandia (VV)
        */
      herenciaCamposGNC(caso,casoPadre);
      copyStatusClose (caso, casoPadre);
    } else if(case4) {//EGS Bussines Logic
      herenciaCamposEGS(caso,casoPadre);
      caso.SER_Skip_validations__c = true;
    }
  }
  private static void copyStatusClose (Case caso, Case casoPadre) {
    if(casoPadre.SER_Close__c && !caso.SER_Close__c) {
      if(casoPadre.AccountId != null
          && (caso.AccountId == null || caso.AccountId == Label.SER_InternalContactAccountID)
          && caso.AccountId != casoPadre.AccountId) {
        caso.AccountId    =     casoPadre.AccountId;
      }
      caso.SER_Close__c = true;
      system.debug('--->>> VV true');
    }
  }
  /*---------------------------------------------------------------------
      Author:    Juan Carlos Terrón
      Company:     Accenture
      Description:   Copy Fields from a Parent Case to its children.

      IN:
      OUT:       Void

      History:
      <Date>          <Author>        <Change Description>
      26/09/2017        Juan Carlos Terrón    Initial Version
      12/11/2018        Jose Luis Aranda      Add GNC
      13/03/2020        Jose Luis Aranda      Add EGS
      ------------------------------------------------------------------------*/
  public static void copyParentFieldsINSERT(Case caso, Case casoPadre, Map<String,String> mapPicklistValues) {
    Boolean case1;
    case1 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_STE;
    Boolean case2;
    case2 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_GM && caso.SER_Close__c != true;
    Boolean case3;
    case3 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_GNC && caso.SER_Close__c != true;
    Boolean case4;
    case4 = caso.SER_Business_Case_Type__c == SER_Constant.BUSINESS_EGS; //NOSONAR

    if(case1) {//STE Bussines Logic
      caso.SER_Close__c           = casoPadre.SER_Close__c;
      caso.SER_Type_EST__c        = casoPadre.SER_Type_EST__c;
      caso.SER_Subtype_STE__c     = casoPadre.SER_Subtype_STE__c;
      caso.SER_Web_App__c         = casoPadre.SER_Web_App__c;
      caso.Subject                = casoPadre.Subject;
      caso.Description            = casoPadre.Description;
      caso.SER_Classification__c  = casoPadre.SER_Classification__c;
      caso.Status = mapPicklistValues.get('Linked to Master Case'); //Case is being linked to a master case.
      caso.SER_Skip_validations__c = true;
      //Victor: se agrego condicion caso.SER_Close__c != true para que no actualizara los hijos que estan cerrados cuando el padre se modifica
    } else if(case2) {//GM Bussines Logic
      asignarAssetPtoC (caso, casoPadre);
      asignarSernovaClientPtoC (caso, casoPadre);    
      caso.SER_Type_GM__c           = casoPadre.SER_Type_GM__c;
      caso.SER_Subtype_GM__c        = casoPadre.SER_Subtype_GM__c;
      caso.SER_Classification__c    = casoPadre.SER_Classification__c;
      caso.SER_MailingGroup__c      = casoPadre.SER_MailingGroup__c;
      caso.SER_Outbound_Mailbox__c  = casoPadre.SER_Outbound_Mailbox__c;
      caso.SER_Pre_liquidacion__c   = casoPadre.SER_Pre_liquidacion__c;
      caso.SER_Post_liquidation__c  = casoPadre.SER_Post_liquidation__c;
      asignarAccountPtoC(caso, casoPadre);
      //Victor: se agrego condicion caso.SER_Close__c != true para que no actualizara los hijos que estan cerrados cuando el padre se modifica
    } else if(case3) {//GNC Bussines Logic
      /**
        * Description: AddClient Name and Subject
        * @autor: Victor Velandia (VV)
        */
      herenciaCamposGNC(caso,casoPadre);
    } else if(case4) {//EGS Bussines Logic
      herenciaCamposEGS(caso,casoPadre);
      caso.SER_Skip_validations__c = true;
    }
  }
  private static void asignarAccountPtoC (Case caso, Case casoPadre) {
    if(casoPadre.AccountId != null && (caso.AccountId == null || caso.AccountId == Label.SER_InternalContactAccountID) && caso.AccountId != casoPadre.AccountId && caso.SER_IsSernova__c == false) {
      caso.AccountId = casoPadre.AccountId;
    }
  }
  private static void herenciaCamposEGS (Case caso, Case casoPadre) {

    boolean casoReopen;  // Si el caso padre se ha reabierto, hay que quitar el check de close del caso hijo
    casoReopen = casoPadre.Status == SER_Constant.WORKING 
              && casoPadre.activity_status_type__c == SER_Constant.WORKING 
              && caso.Status == SER_Constant.CLOSED;
    if(casoReopen) {
      caso.SER_Close__c                  = casoPadre.SER_Close__c;  // Close (checkbox)
    }

    boolean hijoSinTareas;  // Si el hijo no tiene tareas abiertas son substatus 'Open task', se heredan los estados
    hijoSinTareas = caso.activity_status_type__c != SER_Constant.OPEN_TASKS;
    if(hijoSinTareas) {
      caso.Status                          = casoPadre.Status; //Status
      caso.case_status_type__c             = casoPadre.case_status_type__c; //Case Stage
      caso.activity_status_type__c         = casoPadre.activity_status_type__c; //Substatus
    }

    caso.RecordTypeId                    = casoPadre.RecordTypeId ;  //RecordTypeId    

    //Heredamos los cinco campo que SIEMPRE van a heredarse del padre, tengan o no información en el hijo
    caso.validation_criticality_type__c  = casoPadre.validation_criticality_type__c;  //Severity
    caso.Subject                         = casoPadre.Subject;   //Subject
    caso.gf_case_area_name__c            = casoPadre.gf_case_area_name__c; //Origin
    caso.gf_case_cause_on_closure_desc__c= casoPadre.gf_case_cause_on_closure_desc__c;  //Close Category
    caso.SER_Solution__c                 = casoPadre.SER_Solution__c;  //Solución

    //Si vamos a heredar el status 'Working', 'Resolve' o 'Close' comprobamos si están rellenos también estos cinco campos.
    //Si están rellenos en el hijo, no se tocan. Si están vacíos, heredamos el valor del padre.
    boolean casoWorking;
    casoWorking = casoPadre.Status == SER_Constant.WORKING 
                  || casoPadre.Status == SER_Constant.RESOLVED 
                  || casoPadre.Status == SER_Constant.CLOSED;

    if(casoWorking) {
      boolean typoNull;
      typoNull = caso.gf_case_channel_source_name__c == null;
      if(typoNull) {
        caso.gf_case_channel_source_name__c  = casoPadre.gf_case_channel_source_name__c; //Typology
      }
      boolean channelNull;
      channelNull = caso.case_channel_source_type__c == null;
      if(channelNull) {
      caso.case_channel_source_type__c     = casoPadre.case_channel_source_type__c; //Channel
      }
      boolean descrNull;
      descrNull = caso.Description == null;
      if(descrNull) {
      caso.Description                     = casoPadre.Description;  //Descripción
      }
      boolean entornoNull;
      entornoNull = caso.gf_case_environment_name__c == null;
      if(entornoNull) {
      caso.gf_case_environment_name__c     = casoPadre.gf_case_environment_name__c; //Environment
      }
      boolean classNull;
      classNull = caso.SER_Classification__c == null;
      if(classNull) {
      caso.SER_Classification__c           = casoPadre.SER_Classification__c; //Clasificación
      }
      boolean classDiscart;
      classDiscart = caso.SER_Classification__c == 'Discarded / Duplicated' 
                      && casoPadre.SER_Classification__c != 'Discarded / Duplicated';
      if(classDiscart) {
      caso.SER_Classification__c           = caso.SER_Initial_Classification__c; //Clasificación
      }
    }

    //Si vamos a pasar a 'Resolve' o a 'Close', se revisan de igual forma estos dos campos
    boolean casoClosed;
    casoClosed = casoPadre.Status == SER_Constant.RESOLVED 
                  || casoPadre.Status == SER_Constant.CLOSED;
    if(casoClosed) {
      boolean countryNull;
      countryNull = caso.gf_case_countries_desc__c == null;
      if(countryNull) {
      caso.gf_case_countries_desc__c       = casoPadre.gf_case_countries_desc__c; //Country Issue
      }

      boolean detectedNull;
      detectedNull = caso.gf_case_creation_type__c == null;
      if(detectedNull) {
      caso.gf_case_creation_type__c        = casoPadre.gf_case_creation_type__c;  //Detected by
      }
    }

  }
  private static void herenciaCamposGNC (Case caso, Case casoPadre) {
    caso.SER_Classification__c    = casoPadre.SER_Classification__c;
    caso.SER_Country__c           = casoPadre.SER_Country__c;
    caso.SER_Type_GNC__c          = casoPadre.SER_Type_GNC__c;
    caso.SER_Subtype_GNC__c       = casoPadre.SER_Subtype_GNC__c;
    caso.Subject                  = casoPadre.Subject; //VV
    caso.Description              = casoPadre.Description;
    caso.SER_Solution__c          = casoPadre.SER_Solution__c;
  }
  /**
  * Description: Add if for clientName casopadre
  * @autor: Victor Velandia (VV)
  */
  private static void asignarsernovaClientPtoC (Case caso, Case casoPadre) {
    final boolean sameAccount = caso.AccountId != casoPadre.AccountId && caso.AccountId == null;   
    if(sameAccount) {
      Id sernovaSupId;
      sernovaSupId = [select Id,Name from Account where Client_STAR_ID__C = :Label.SER_SernovaAccountNAME and SER_CClient__c = :Label.SER_SernovaAccountNAME limit 1].Id;
      Boolean sernovaSupplier;
      sernovaSupplier = caso.SER_IsSernova__c == true && sernovaSupId != null;
      if(sernovaSupplier) {
        caso.AccountId = sernovaSupId;
      } else {
        caso.AccountId = casoPadre.AccountId;
      }
    }
  }
  private static void asignarAssetPtoC (Case caso, Case casoPadre) {
    if(casoPadre.SER_Asset__c != null && caso.SER_Asset__c != casoPadre.SER_Asset__c) {
      caso.SER_Asset__c         = casoPadre.SER_Asset__c;
    }
  }
}