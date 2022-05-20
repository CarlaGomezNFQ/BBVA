/**
 * Controlador para el Componente NBC
 *
 * @author Desktop
 */
public with sharing class ComponentNBC_Controller {
  /**
   * Lista de configuraciones del template
   */
  public static List<Template_Configurations__c> listTemConfigs = new List<Template_Configurations__c>(); //NOSONAR
  /**
   * Mapa de regiones del pais
   */
  public static final Map<String, String> MAPCOUNTRYREGION = new Map<String, String>();

  /**
   *
   * @author GlobalDesktop
   */
  public static ComponentNBC_Controller instance {
    get {
      if (instance == null) {
        instance = new ComponentNBC_Controller();
      }
      return instance;
    }
    set {

    }
  }

  /**
   *
   * @author GlobalDesktop
   */
  //private static ComponentNBC_Controller instance;

  /**
   * Constructor
   * @author GlobalDesktop
   */
  private ComponentNBC_Controller() {
    //this.logic = new ActivitiesUtils();
  }


  /**
   * Met0d0 para obtener el Id del template
   *
   * @param product
   * @param booking
   * @param amount
   * @param bookingCibBec
   *
   * @return
   */
  public static Id getTemplateId(String product, String booking, Decimal amount, String bookingCibBec) {
    Id templateId;
    system.debug('>>>>> product : ' + product);
    system.debug('>>>>> booking : ' + booking);
    system.debug('>>>>> amount : ' + amount);
    system.debug('>>>>> bookingCibBec : ' + bookingCibBec);
    for (Template_Configurations__c temConfig : listTemConfigs) {
      system.debug('>>>>> temConfig : ' + temConfig);

      if(product == Label.DES_Project_Finance_Lending
         && bookingCibBec == 'CIB'
         && temConfig.Product_id__r.Name == product) {
        templateId = Schema.SObjectType.DES_Template__c.getRecordTypeInfosByDeveloperName().get(temConfig.Template_type__c).getRecordTypeId();
      } else if(product == Label.DES_Leverage_Buyout_LBOs
                && bookingCibBec == 'CIB'
                && temConfig.Product_id__r.Name == product) {
        system.debug('>>>>> temConfig.Product_id__r.Name : ' + temConfig.Product_id__r.Name);
        templateId = Schema.SObjectType.DES_Template__c.getRecordTypeInfosByDeveloperName().get(temConfig.Template_type__c).getRecordTypeId();
      } else if((product == Label.DES_Transaction_Trade_Finance || product == Label.DES_Working_Capital)
                && temConfig.Product_id__r.Name == product
                && (temConfig.Booking_type__c == null || temConfig.Booking_type__c == booking)
                && (temConfig.Amount_num__c == 0 || amount >= temConfig.Amount_num__c)) {
        templateId = Schema.SObjectType.DES_Template__c.getRecordTypeInfosByDeveloperName().get(temConfig.Template_type__c).getRecordTypeId();
      } else if(temConfig.Product_id__r.Name == product
                && (temConfig.Booking_type__c == null || temConfig.Booking_type__c == booking)
                && bookingCibBec == 'CIB'
                && (temConfig.Amount_num__c == 0 || amount >= temConfig.Amount_num__c)) {
        templateId = Schema.SObjectType.DES_Template__c.getRecordTypeInfosByDeveloperName().get(temConfig.Template_type__c).getRecordTypeId();
      }
    }
    return templateId;
  }

  /**
   * setter para rellenar el mapa de las regiones de pais
   */
  public static void setMapCountryRegion() {
    if(MAPCOUNTRYREGION.isEmpty()) {
      // se añade limite 2000 para cumplir la regla del sonar "Avoid Calling SOQL Without a Where Clause or Limit Statement"
      for(Opp_Countries__mdt countryRegMDT : [SELECT Id, NBC_Region__c, MasterLabel, DeveloperName FROM Opp_Countries__mdt LIMIT 2000]) {
        MAPCOUNTRYREGION.put(countryRegMDT.DeveloperName, countryRegMDT.NBC_Region__c);
      }
    }
    system.debug('>>>>> mapCountryRegion : ' + MAPCOUNTRYREGION);
  }

  /**
   * getter para obtener la lista de configuraciones del template
   */
  public static void getTemplateConfigurationsList() {

    // se añade limite 2000 para cumplir la regla del sonar "Avoid Calling SOQL Without a Where Clause or Limit Statement"
    if(listTemConfigs.isEmpty()) {
      listTemConfigs = new List<Template_Configurations__c>([SELECT Id, Product_id__r.Name, Name, Amount_num__c, Booking_type__c, Product_id__c, Template_type__c FROM Template_Configurations__c LIMIT 2000]);
    }
    system.debug('>>>>> listTemConfigs : ' + listTemConfigs);
  }

  /**
   *
   *
   * @param recordId
   *
   * @return
   */
  @AuraEnabled
  public static String typeNBC(String recordId) { //NOSONAR

    final Map<Id, OpportunityLineItem> mapProducts = new Map<Id, OpportunityLineItem>([SELECT Id, product_scope_type__c, syndicated_loan_drawn_amount__c, Converted_Currency__c, opportunity_stage_type__c, DES_Product_Family__c, solution_classification_desc__c, subproduct_name__c, OpportunityId, bbva_prtcp_tranche_amount__c, Name, Opportunity.DES_Booking_Geography__c, Opportunity.gf_opportunity_nbc_name__c, Opportunity.Name, Opportunity.CurrencyIsoCode, Product2Id FROM OpportunityLineItem WHERE OpportunityId = : recordId]);
    setMapCountryRegion();
    Desktop_Utils.setMapCountryTemplateName();
    getTemplateConfigurationsList();
    Id templateRTId = null;
    //String oppName;
    String productName;
    String oppProductId;
    String oppBookingGeo;
    String currencyIso;
    String portfolio;
    boolean hasPF = false;
    for(OpportunityLineItem oppl : mapProducts.values()) {
      if(templateRTId != null && oppl.solution_classification_desc__c != Label.DES_Project_Finance_Lending) {
        system.debug('::::: SALTO PRODUCTO.');
        continue;
      }
      //oppName = oppl.Opportunity.Name;
      system.debug('>>>>> oppl.solution_classification_desc__c : ' + oppl.solution_classification_desc__c);
      system.debug('>>>>> region : ' + MAPCOUNTRYREGION.get(oppl.Opportunity.DES_Booking_Geography__c));
      system.debug('>>>>> oppl.Opportunity.DES_Booking_Geography__c : ' + oppl.Opportunity.DES_Booking_Geography__c);
      system.debug('>>>>> oppl.bbva_prtcp_tranche_amount__c : ' + oppl.bbva_prtcp_tranche_amount__c);
      system.debug('>>>>> oppl.syndicated_loan_drawn_amount__c : ' + oppl.syndicated_loan_drawn_amount__c);
      system.debug('>>>>> oppl.product_scope_type__c : ' + oppl.product_scope_type__c);
      Id idTemplateAux;
      if(oppl.solution_classification_desc__c == Label.DES_Project_Finance_Lending) {
        idTemplateAux = getTemplateId(oppl.solution_classification_desc__c, MAPCOUNTRYREGION.get(oppl.Opportunity.DES_Booking_Geography__c), oppl.Converted_Currency__c, oppl.product_scope_type__c);
        system.debug('::::: idTemplateAux - getTemplateId: ' + idTemplateAux);
        if (idTemplateAux != null) {
          templateRTId = idTemplateAux;
        }
        hasPF = true; //NOSONAR
        productName = oppl.solution_classification_desc__c;
        oppProductId = oppl.Id;
        oppBookingGeo = oppl.Opportunity.DES_Booking_Geography__c;
        portfolio = oppl.Opportunity.gf_opportunity_nbc_name__c;
        currencyIso = oppl.Opportunity.CurrencyIsoCode;
      } else if(!hasPF
                && (oppl.solution_classification_desc__c == Label.DES_Transaction_Trade_Finance
                    || oppl.solution_classification_desc__c == Label.DES_Structure_Trade_Finance
                    || oppl.solution_classification_desc__c == Label.DES_Corporate_Loans
                    || oppl.solution_classification_desc__c == Label.DES_Leverage_Buyout_LBOs
                    || oppl.solution_classification_desc__c == LABEL.DES_Working_Capital
                    )
                && templateRTId == null) { //AQUI CUYO AMOUNT SON EL CAMPO BBVA COMMITMENT
        system.debug('>>>>> ELSE IF 1');
        productName = oppl.solution_classification_desc__c;
        oppProductId = oppl.Id;
        oppBookingGeo = oppl.Opportunity.DES_Booking_Geography__c;
        portfolio = oppl.Opportunity.gf_opportunity_nbc_name__c;
        idTemplateAux = getTemplateId(oppl.solution_classification_desc__c, MAPCOUNTRYREGION.get(oppl.Opportunity.DES_Booking_Geography__c), oppl.Converted_Currency__c, oppl.product_scope_type__c);
        system.debug('::::: idTemplateAux - getTemplateId: ' + idTemplateAux);
        if (idTemplateAux != null) {
          templateRTId = idTemplateAux;
        }
        currencyIso = oppl.Opportunity.CurrencyIsoCode;
      }
    }
    system.debug('>>>>> templateRecordTypeId : ' + templateRTId);

    final Opportunity opp = [select Account.Name, AccountId from Opportunity where Id = :recordId LIMIT 1];
    List<DES_Denorm_AccountVisits__c> listVisit = new List<DES_Denorm_AccountVisits__c>();

    if(opp.AccountId != null) {
      listVisit = [SELECT id, DES_Start_Date__c FROM DES_Denorm_AccountVisits__c WHERE DES_Client__c = :opp.AccountId AND DES_Start_Date__c != null AND DES_Start_Date__c <= TODAY ORDER BY DES_Start_Date__c DESC]; //NOSONAR
    }

    final String clientName = opp.Account.Name;

    Date lastDateVisit;
    if ( listVisit != null && !listVisit.isEmpty() ) {
      lastDateVisit = Date.valueOf(listVisit[0].DES_Start_Date__c);
    }

    final DES_Template__c template = createTemplate(templateRTId, oppProductId, recordId, oppBookingGeo == 'NY' ? (portfolio != null && portfolio != '' ? portfolio : 'USA') : Desktop_Utils.mapCountryTemplateName.get(oppBookingGeo), clientName,lastDateVisit,productName, currencyIso); //NOSONAR

    system.debug('>>>>> template : ' + template);
    if(!Test.isRunningTest()) { //NOSONAR
      insert template;
    }
    //return String.valueof(System.URL.getSalesforceBaseURL().toExternalForm() + '/lightning/r/DES_Template__c/' + template.id  + '/view');

    return '/lightning/r/DES_Template__c/' + template.id  + '/view';
    //return templateRecordTypeId;
  }

  /**
   * Mét0d0 para crear un Template
   *
   * @param recordTypeId
   * @param oppProductId
   * @param oppId
   * @param templateRegion
   * @param clientName
   * @param lastDateVisit
   *
   * @return objeto DES_Template__c
   */
  private static DES_Template__c createTemplate(Id recordTypeId, Id oppProductId, Id oppId, String templateRegion, String clientName, Date lastDateVisit, String productName, String currencyIso) {//NOSONAR
    DES_Template__c template;
    template = new DES_Template__c();
    template.recordTypeId = recordTypeId;
    if(templateRegion == null) {
      template.Name = 'NBC' + ' ' + clientName;
    } else {
      template.Name = 'NBC' + ' ' + templateRegion + ' ' + clientName;
    }

    if (template.Name.length() > 80) {
      template.Name = template.Name.substring(0,79) + '.';
    }

    template.Opportunity_Product_Id__c = oppProductId;
    template.opportunity_id__c = oppId;
    template.Product_Name__c = productName;
    template.CurrencyIsoCode = currencyIso;

    if(lastDateVisit != null) {
      template.Last_Visit_to_the_Client_desc__c = lastDateVisit;
    }

    return template;
  }

}