/**
* ------------------------------------------------------------------------------------------------
* @Name     DES_Arc_Account_Locator
* -----------------------------------------------------------------------------------------------
* @Description Class "Arc_GBL_Account_Locator"
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:NPathComplexity, sf:CyclomaticComplexity, sf:TooManyMethods')
global without sharing class DES_Arc_Account_Locator implements arce.Arc_Gen_Account_Interface {

    /**
    * @Description: String with value "Group"
    */
    static final string S_GROUP = 'GROUP';

    /**
    * @Description: String with value "Client"
    */
    static final string CLIENT = 'SUBSIDIARY';

    /**
    * @Description: String with value "NIF"
    */
    static final string NIF = 'NIF';

    /**
    * @Description: String with value "NIF"
    */
    static final string BRANCHID = '9999';

    /**
        * @Description: String with value "Financial statement type"
    */
    private final static String TYPE = '1';

  /**
  * @description
  * @author Global Desktop | 07-30-2020
  * @param listAccountId
  * @return Map<Id, arce.Arc_Gen_Account_Wrapper>
  **/
  public Map<Id, arce.Arc_Gen_Account_Wrapper> getAccountInfoById(List<Id> listAccountId) {
    Map<Id,arce.Arc_Gen_Account_Wrapper> mapWrapper = new Map<Id,arce.Arc_Gen_Account_Wrapper>();
    try {
      final List<Id> standardAccounts = new List<Id>();
      final List<Id> customAccounts = new List<Id>();
      for(Id someId: listAccountId) {
        if(someId.getSObjectType().getDescribe().getName() == 'Account'){
          standardAccounts.add(someId);
          System.debug('--------> Account: ' + someId);
        } else {
          customAccounts.add(someId);
          System.debug('---------> CustomAccount: ' + someId);
        }
      }
      if(!standardAccounts.isEmpty()) {
        mapWrapper = completeProspect(mapWrapper, standardAccounts);
      }
      if(!customAccounts.isEmpty()) {
        mapWrapper = completeLocal(mapWrapper, customAccounts);
      }
      //Fin -- Adaptación para Custom Account

    } catch(Exception ex) {
      final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
      wrapper.error = ex.getMessage();
      mapWrapper.put(null, wrapper);
    }
    return mapWrapper;
  }

  /**
  * @description
  * @author Global Desktop | 07-30-2020
  * @param listAccountNum
  * @return Map<String, Arc_Gen_Account_Wrapper>
  **/
  public Map<String, arce.Arc_Gen_Account_Wrapper> getAccountByAccNumber(List<String> listAccountNum) {
    final Map<String, arce.Arc_Gen_Account_Wrapper> mapWrapper = new Map<String, arce.Arc_Gen_Account_Wrapper>();
    System.debug('>>>>>>>>>>>>>>> Entra getAccountByAccNumber');
    try {
      final List<Account> lstProps = [
        SELECT Id, Name, gf_customer_prospect_id__c, DES_Country_Client__c, DES_ID_Fiscal__c,
        DES_Entity_Hierarchy__c, OwnerId, participant_id__c
        FROM Account
        WHERE gf_customer_prospect_id__c IN: listAccountNum
      ];
      if(lstProps != null && !lstProps.isEmpty()) {
        for(Account acc : lstProps) {
          final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
          wrapper.accId = acc.Id;
          wrapper.accNumber = acc.gf_customer_prospect_id__c;
          wrapper.name = acc.Name;
          wrapper.bankId = getBankId(acc.DES_Country_Client__c);
          wrapper.participantType = acc.DES_Entity_Hierarchy__c == null ? CLIENT : acc.DES_Entity_Hierarchy__c == 'S' ? S_GROUP : CLIENT;
          wrapper.docType = NIF;
          wrapper.docNumber = acc.DES_ID_Fiscal__c == null ? BRANCHID : acc.DES_ID_Fiscal__c;
          wrapper.participantOwnerId = acc.OwnerId;
          wrapper.accParentId = acc.participant_id__c;
          wrapper.branchId = BRANCHID;
          wrapper.country = acc.DES_Country_Client__c;
          wrapper.globalId = wrapper.accNumber; // Alpha code
          mapWrapper.put(acc.gf_customer_prospect_id__c, wrapper);
        }
      }
      final List<Local_Client__c> lstAcc = [
        SELECT Id, Name, Cib_Client__c, country_id__c, g_residence_country_id__c, Alpha_code__c,taxpayer_id__c,  Cib_Client__r.DES_Entity_Hierarchy__c, OwnerId
        FROM Local_Client__c
        WHERE Alpha_Code__c IN: listAccountNum
      ];
      if(lstAcc != null && !lstAcc.isEmpty()) {
        for(Local_Client__c acc : lstAcc) {
          final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
          wrapper.accId = acc.Cib_Client__c;
          wrapper.accNumber = acc.Alpha_code__c;
          wrapper.name = acc.Name;
          wrapper.bankId = acc.Alpha_code__c == null ? '' :  acc.Alpha_code__c.subString(2,6);
          wrapper.participantType = acc.Cib_Client__r.DES_Entity_Hierarchy__c == null ? CLIENT : acc.cib_Client__r.DES_Entity_Hierarchy__c == 'S' ? S_GROUP : CLIENT;
          wrapper.docType = acc.taxpayer_id__c == null ? null : NIF;
          wrapper.docNumber = acc.taxpayer_id__c;
          wrapper.participantOwnerId = acc.OwnerId;
          wrapper.accParentId = acc.Cib_Client__c;
          wrapper.branchId = BRANCHID;
          wrapper.customAccount = acc.Id;
          wrapper.lookupName = 'DES_Local_Client__c';
          wrapper.country = acc.g_residence_country_id__c;
          wrapper.globalId = wrapper.accNumber; // Alpha code
          mapWrapper.put(acc.Alpha_Code__c, wrapper);
        }
      }
    } catch(Exception ex) {
      final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
      wrapper.error = ex.getMessage();
      mapWrapper.put(null, wrapper);
    }
    return mapWrapper;
  }

  /**
  * @description
  * @author Global Desktop | 07-30-2020
  * @param searchWord
  * @return List<arce.Arc_Gen_Account_Wrapper>
  **/
  public List<arce.Arc_Gen_Account_Wrapper> accountsForLookup(String searchWord) {
    final List<arce.Arc_Gen_Account_Wrapper> lstAccWrapper = new List<arce.Arc_Gen_Account_Wrapper>();
    final String searchQuery = 'FIND \'' + String.escapeSingleQuotes(searchWord) + '\' IN ALL FIELDS RETURNING Local_Client__c (id, participant_name__c, OwnerId)';
    final List < List < Local_Client__c >> accountsforshow = search.query(searchQuery);
    System.debug('>>>>>>>>>>>>>>> Entra accountsForLookup');
    if (accountsforshow != null && !accountsforshow.isEmpty()) {
      for(Local_Client__c acc : accountsforshow[0]) {
        final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
        wrapper.accId = acc.Id;
        wrapper.name = acc.participant_name__c;
        //wrapper.participantOwnerId = acc.OwnerId;
        wrapper.participantOwnerId = UserInfo.getUserId();
        lstAccWrapper.add(wrapper);
      }
    }
    final String searchQueryProps = 'FIND \'' + String.escapeSingleQuotes(searchWord) + '\' IN ALL FIELDS RETURNING Account (id, Name, OwnerId)';
    final List < List < Account >> prospforshow = search.query(searchQueryProps);
    if (prospforshow != null && !prospforshow.isEmpty()) {
      for(Account acc : prospforshow[0]) {
        final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
        wrapper.accId = acc.Id;
        wrapper.name = acc.Name;
        //wrapper.participantOwnerId = acc.OwnerId;
        wrapper.participantOwnerId = UserInfo.getUserId();
        lstAccWrapper.add(wrapper);
      }
    }
    return lstAccWrapper;
  }

  /**
  * @description
  * @author Global Desktop | 07-30-2020
  * @param lstAccUp
  * @return arce.Arc_Gen_ServiceAndSaveResponse
  **/
  public static arce.Arc_Gen_ServiceAndSaveResponse accountUpdate(Map<Id, Map<String,Object>> lstAccUp) {
    final arce.Arc_Gen_ServiceAndSaveResponse result = new arce.Arc_Gen_ServiceAndSaveResponse(); //NOSONAR
    return result;
  }

  /**
  * @description
  * @author Global Desktop | 07-30-2020
  * @param accAttr
  * @return arce.Arc_Gen_ServiceAndSaveResponse
  **/
  public static arce.Arc_Gen_ServiceAndSaveResponse createGroup(Map<String,Object> accAttr) {
    final arce.Arc_Gen_ServiceAndSaveResponse result = new arce.Arc_Gen_ServiceAndSaveResponse(); //NOSONAR
    return result;
  }

  /**
  * @description
  * @author Global Desktop | 02-25-2021
  * @param country
  * @param countryGlobal
  * @param cclient
  * @param soloEntity
  * @return String
  **/
  private static String getBankId(String country) {
    String bankId= '';
    switch on country {
      when 'ES' {
        bankId='0182';
      }
      when 'MX' {
        bankId='0074';
      }
      when 'CO' {
        bankId='0013';
      }
      when 'PE' {
        bankId='0011';
      }
      when 'AR' {
        bankId='0017';
      }
      when 'PY' {
        bankId='7714';
      }
      when 'CH ' {
        bankId='0069';
      }
    }
    return bankId;
  }

  /**
  * @description
  * @author Global Desktop | 02-25-2021
  * @param country
  * @param countryGlobal
  * @param cclient
  * @param soloEntity
  * @return String
  **/
  private static Map<Id,arce.Arc_Gen_Account_Wrapper> completeProspect(Map<Id,arce.Arc_Gen_Account_Wrapper> mapWrap, List<Id> standardAccounts) {
    final Map<Id,arce.Arc_Gen_Account_Wrapper> mapWrapper = mapWrap;
    final List<Account> lstProps = [
      SELECT Id, Name, gf_customer_prospect_id__c, DES_Country_Client__c, DES_ID_Fiscal__c,
      DES_Entity_Hierarchy__c, OwnerId, participant_id__c
      FROM Account WHERE Id =: standardAccounts
    ];

    for(Account acc : lstProps) {
      final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
      wrapper.accId = acc.Id;
      wrapper.accNumber = acc.gf_customer_prospect_id__c;
      wrapper.name = acc.Name;
      wrapper.bankId = getBankId(acc.DES_Country_Client__c);
      wrapper.participantType = acc.DES_Entity_Hierarchy__c == null ? CLIENT : acc.DES_Entity_Hierarchy__c == 'S' ? S_GROUP : CLIENT;
      wrapper.docType = NIF;
      wrapper.docNumber = acc.DES_ID_Fiscal__c == null ? BRANCHID : acc.DES_ID_Fiscal__c;
      wrapper.participantOwnerId = acc.OwnerId;
      wrapper.accParentId = acc.participant_id__c;
      wrapper.branchId = BRANCHID;
      wrapper.country = acc.DES_Country_Client__c;
      wrapper.globalId = wrapper.accNumber; // Alpha code
      mapWrapper.put(acc.Id, wrapper);
    }
    return mapWrapper;
  }

  /**
  * @description
  * @author Global Desktop | 02-25-2021
  * @param country
  * @param countryGlobal
  * @param cclient
  * @param soloEntity
  * @return String
  **/
  private static Map<Id,arce.Arc_Gen_Account_Wrapper> completeLocal(Map<Id,arce.Arc_Gen_Account_Wrapper> mapWrap, List<Id> customAccounts) {
    final Map<Id,arce.Arc_Gen_Account_Wrapper> mapWrapper = mapWrap;
    final List<Local_Client__c> lstAcc = [
      SELECT Id, Name, Cib_Client__c, Alpha_code__c, country_id__c, g_residence_country_id__c, taxpayer_id__c,  Cib_Client__r.DES_Entity_Hierarchy__c, OwnerId
      FROM Local_Client__c WHERE Id =: customAccounts
    ];

    for(Local_Client__c acc : lstAcc) {
      final arce.Arc_Gen_Account_Wrapper wrapper = new arce.Arc_Gen_Account_Wrapper();
      wrapper.accId = acc.Cib_Client__c;
      wrapper.accNumber = acc.Alpha_code__c;
      wrapper.name = acc.Name;
      wrapper.bankId = acc.Alpha_code__c == null ? '' :  acc.Alpha_code__c.subString(2,6);
      wrapper.participantType = acc.Cib_Client__r.DES_Entity_Hierarchy__c == null ? CLIENT : acc.cib_Client__r.DES_Entity_Hierarchy__c == 'S' ? S_GROUP : CLIENT;
      wrapper.docType = acc.taxpayer_id__c == null ? null : NIF;
      wrapper.docNumber = acc.taxpayer_id__c;
      wrapper.participantOwnerId = acc.OwnerId;
      wrapper.accParentId = acc.Cib_Client__c;
      wrapper.branchId = BRANCHID;
      wrapper.customAccount = acc.Id;
      wrapper.lookupName = 'DES_Local_Client__c';
      wrapper.country = acc.g_residence_country_id__c;
      wrapper.globalId = wrapper.accNumber; // Alpha code
      mapWrapper.put(acc.Id, wrapper);
    }
    return mapWrapper;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description  Method "getRatingGCPByAccountNumber" retrieves Financial statement By Accnumbers
  --------------------------------------------------------------------------------
  * @author Global Desktop
  * @date 2021-05-26
  * @param List<String> accountNumber
  * @return   Map<String,arce__Financial_Statements__c>
  * @example Map<String,arce__Financial_Statements__c> list =  getRatingGCPByAccountNumber(List<String> accountNumber)
  **/
  public static Map<String,arce__Financial_Statements__c> getRatingGCPByAccountNumber (List<String> accountNumber) {
   Map<String,arce__Financial_Statements__c> result = new Map<String,arce__Financial_Statements__c>();
        final List<String> conditions = new List <String>{'arce__ffss_submitted_type__c =: TYPE', 'arce__ffss_valid_type__c =: TYPE'};
        final Set<String> ahaByParentId = new Set<String>();
        for(arce__Account_has_Analysis__c aha : [SELECT Id FROM arce__Account_has_Analysis__c WHERE DES_Local_Client__r.Alpha_code__c IN: accountNumber
                                                    AND arce__Analysis__r.arce__Stage__c = '3' AND arce__Analysis__r.arce__wf_status_id__c = '13']) {
            ahaByParentId.add(aha.Id);
        }
        final String condition = ' AND ' + String.join(conditions, ' AND ') + ' ORDER BY CreatedDate DESC';
        result = getFinancialStatementByAha(ahaByParentId, condition);
        return result;
  }

  /**
    *-------------------------------------------------------------------------------
    * @description  Method "getFinancialStatementByAha" retrieves Financial statement By Accnumbers
    --------------------------------------------------------------------------------
    * @author alexander.munguia.contractor@bbva.com
    * @date 2021-03-17
    * @param Set<String> ahaId
    * @param String condition
    * @return   Map<String,arce__Financial_Statements__c>
    * @example Map<String,arce__Financial_Statements__c> list =  getFinancialStatementByAha(List<String> accountNumber)
    **/
    private static Map<String, arce__Financial_Statements__c> getFinancialStatementByAha (Set<String> ahaId, String condition) {
        final Map<String, arce__Financial_Statements__c> result = new Map<String, arce__Financial_Statements__c>();
        String queryString = 'SELECT Id, arce__total_rating_score_number__c, arce__financial_statement_id__c, arce__financial_statement_start_date__c,arce__financial_statement_end_date__c, arce__rating_final__c';
        queryString += ', arce__account_has_analysis_id__r.DES_Local_Client__r.Alpha_code__c, arce__account_has_analysis_id__r.arce__total_rating_score_number__c'+
            ',arce__rating_id__r.arce__rating_long_value_type__c, arce__rating_id__r.arce__rating_short_value_type__c' +
            ', arce__account_has_analysis_id__r.arce__short_rating_value_type__c, arce__account_has_analysis_id__r.arce__long_rating_value_type__c, arce__rar_rating_tool_id__c, arce__rating_id__r.arce__rating_id__c';
        queryString += ' FROM arce__Financial_Statements__c where arce__account_has_analysis_id__c IN: ahaId '+condition;
            for (arce__Financial_Statements__c ffee : Database.query(String.escapeSingleQuotes(queryString))) {
                if(!result.containsKey(ffee.arce__account_has_analysis_id__r.DES_Local_Client__r.Alpha_code__c)) {
                    result.put(ffee.arce__account_has_analysis_id__r.DES_Local_Client__r.Alpha_code__c, ffee);
                }
            }
        return result;
    }
}