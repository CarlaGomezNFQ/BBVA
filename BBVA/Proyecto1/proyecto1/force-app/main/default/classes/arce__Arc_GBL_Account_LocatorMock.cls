//Creada por necesidad de los test
global without sharing class Arc_GBL_Account_LocatorMock implements Arc_Gen_Account_Interface {
    /**
            * @Description: String with value "Group"
        */
        static final string S_GROUP = 'GROUP';
        /**
            * @Description: String with value "Client"
        */
        static final string CLIENT = 'SUBSIDIARY';
        /**
            * @Description: String with value "Financial statement type"
        */
        private final static String TYPE = '1';
        /**
        *-------------------------------------------------------------------------------
        * @description  Method "getAccountInfoById" that retrieves full user information from a list of account Id
        --------------------------------------------------------------------------------
        * @author juanignacio.hita.contractor@bbva.com
        * @date 2019-11-15
        * @param List<Id> listAccountId
        * @return   Map with Account Wrappers
        * @example Map<Id, Arc_Gen_Account_Wrapper> list = Arc_GBL_Account_Locator.getAccountInfoById(listAccountId);
        **/
        public Map<Id, Arc_Gen_Account_Wrapper> getAccountInfoById(List<Id> listAccountId) {
            Map<Id, Arc_Gen_Account_Wrapper> mapWrapper = new Map<Id, Arc_Gen_Account_Wrapper>();
            try {
                final List<Account> lstAcc = [SELECT Id, CurrencyIsoCode, Name, AccountNumber, ParentId, OwnerId
                    FROM Account WHERE Id =: listAccountId];
                for(Account acc : lstAcc) {
                    final Arc_Gen_Account_Wrapper wrapper = new Arc_Gen_Account_Wrapper();
                    wrapper.accId = acc.Id;
                    wrapper.accNumber = acc.AccountNumber;
                    wrapper.name = acc.Name;
                    wrapper.participantType = acc.ParentId == null ? S_GROUP : CLIENT;
                    wrapper.docType = 'EXAMPLE';
                    wrapper.docNumber = '0000000A';
                    wrapper.participantOwnerId = acc.OwnerId;
                    wrapper.accParentId = acc.ParentId;
                    wrapper.currentLimit = math.random() * 100;
                    wrapper.commited = math.random() * 100;
                    wrapper.unCommited = math.random() * 100;
                    wrapper.outstanding =  math.random() * 100;
                    wrapper.currencyType = 'EUR';
                    wrapper.unit = 'UNIT';
                    wrapper.branchId = '000';
                    wrapper.country = 'FR';
                    mapWrapper.put(acc.Id, wrapper);
                }
            } catch(Exception ex) {
                final Arc_Gen_Account_Wrapper wrapper = new Arc_Gen_Account_Wrapper();
                wrapper.error = ex.getMessage();
                mapWrapper.put(null, wrapper);
            }
            return mapWrapper;
        }
        /**
        *-------------------------------------------------------------------------------
        * @description  Method "getAccountByAccNumber" gets all account fields filtered by AccountNumber
        --------------------------------------------------------------------------------
        * @author manuelhugo.castillo.contractor@bbva.com
        * @date 2019-11-25
        * @param List<String> listAccountNum
        * @return   Map with Account Wrappers
        * @example Map<Id, Arc_Gen_Account_Wrapper> list = Arc_GBL_Account_Locator.getAccountByAccNumber(listAccountNum);
        **/
        public Map<String, Arc_Gen_Account_Wrapper> getAccountByAccNumber(List<String> listAccountNum) {
            final Map<String, Arc_Gen_Account_Wrapper> mapWrapper = new Map<String, Arc_Gen_Account_Wrapper>();
            try {
                final List<Account> lstAcc = [SELECT Id, CurrencyIsoCode, Name, AccountNumber, OwnerId, ParentId
                    FROM Account WHERE AccountNumber IN: listAccountNum];
                for(Account acc : lstAcc) {
                    final Arc_Gen_Account_Wrapper wrapper = new Arc_Gen_Account_Wrapper();
                    wrapper.accId = acc.Id;
                    wrapper.name = acc.Name;
                    wrapper.accNumber = acc.AccountNumber;
                    wrapper.docType = 'EXAMPLE';
                    wrapper.docNumber = '0000000A';
                    wrapper.participantType = acc.ParentId == null ? S_GROUP : CLIENT;
                    wrapper.participantOwnerId = acc.OwnerId;
                    wrapper.accParentId = acc.ParentId;
                    wrapper.country = 'FR';
                    mapWrapper.put(acc.AccountNumber, wrapper);
                }
            } catch(Exception ex) {
                final Arc_Gen_Account_Wrapper wrapper = new Arc_Gen_Account_Wrapper();
                wrapper.error = ex.getMessage();
                mapWrapper.put(null, wrapper);
            }
            return mapWrapper;
        }
        /**
        *-------------------------------------------------------------------------------
        * @description  Method "accountsForLookup" gets account fields filtered by searchWord
        --------------------------------------------------------------------------------
        * @author manuelhugo.castillo.contractor@bbva.com
        * @date 2019-11-25
        * @param String searchWord
        * @return   Account Wrappers List
        * @example List<Arc_Gen_Account_Wrapper> map = Arc_GBL_Account_Locator.accountsForLookup(String searchWord)
        **/
        public List<Arc_Gen_Account_Wrapper> accountsForLookup(String searchWord) {
            final List<Arc_Gen_Account_Wrapper> lstAccWrapper = new List<Arc_Gen_Account_Wrapper>();
            final String searchQuery = 'FIND \'' + String.escapeSingleQuotes(searchWord) + '\' IN ALL FIELDS RETURNING Account (id, name, OwnerId, ParentId)';
            final List < List < Account >> accountsforshow = search.query(searchQuery);
            for(Account acc : accountsforshow[0]) {
                final Arc_Gen_Account_Wrapper wrapper = new Arc_Gen_Account_Wrapper();
                wrapper.accId = acc.Id;
                wrapper.name = acc.Name;
                wrapper.participantOwnerId = acc.OwnerId;
                lstAccWrapper.add(wrapper);
            }
            return lstAccWrapper;
        }
        /**
        *-------------------------------------------------------------------------------
        * @description  Method "accountUpdate" updates a map of Account Ids and attributes
        --------------------------------------------------------------------------------
        * @author javier.soto.carrascosa@bbva.com
        * @date 2020-01-15
        * @param Map<Id, Map<String,String>> lstAccUp
        * @return   Arc_Gen_ServiceAndSaveResponse
        * @example Arc_Gen_ServiceAndSaveResponse accountUpdate(Map<Id, Map<String,String>> lstAccUp)
        **/
        public static Arc_Gen_ServiceAndSaveResponse accountUpdate(Map<Id, Map<String,Object>> lstAccUp) {
            Arc_Gen_ServiceAndSaveResponse result = new Arc_Gen_ServiceAndSaveResponse();
            List<Account> lstUp = new List<Account>();
            for (Id accId : lstAccUp.keySet()) {
            Account accUp = new Account(Id=accId);
            accUp = putFieldsFromMap(accUp,lstAccUp.get(accId));
            lstUp.add(accUp);
            }
            try {
                result.saveStatus = null;
                final List<Database.SaveResult> sare = database.update(lstUp);
                result.saveMessage = Json.serialize(sare);
            } catch (Exception ex) {
                result.saveStatus = 'false';
                result.saveMessage = ex.getMessage();
            }
            return result;
        }
        /**
        *-------------------------------------------------------------------------------
        * @description  Method "createGroup" create group account
        --------------------------------------------------------------------------------
        * @author javier.soto.carrascosa@bbva.com
        * @date 2020-01-15
        * @param Map<String,String> accAttr
        * @return  Arc_Gen_ServiceAndSaveResponse
        * @example Arc_Gen_ServiceAndSaveResponse createGroup(Map<String,String> accAttr)
        **/
        public static Arc_Gen_ServiceAndSaveResponse createGroup(Map<String,Object> accAttr) {
            Arc_Gen_ServiceAndSaveResponse result = new Arc_Gen_ServiceAndSaveResponse();
            Account grpAccount = new Account();
            grpAccount = putFieldsFromMap(grpAccount,accAttr);
            try {
                result.saveStatus = null;
                Database.SaveResult sare = database.insert(grpAccount);
                result.saveMessage = Json.serialize(sare);
                result.createdRsr = new List<Id>{sare.getId()};
            } catch (Exception ex) {
                result.saveStatus = 'false';
                result.saveMessage = ex.getMessage();
            }
            return result;
        }
        /**
        *-------------------------------------------------------------------------------
        * @description  Method "putFieldsFromMap" retrieves updated object from input fields and values
        --------------------------------------------------------------------------------
        * @author javier.soto.carrascosa@bbva.com
        * @date 2020-01-15
        * @param Account acc
        * @param Map<String,String> mapValues
        * @return   Account
        * @example Account putFieldsFromMap(Account acc,Map<String,String> mapValues)
        **/
        private static Account putFieldsFromMap(Account acc, Map<String,Object> mapValues) {
            for (String fieldName : mapValues.keySet()) {
                acc.put(fieldName, mapValues.get(fieldName));
            }
            return acc;
        }
        /**
        *-------------------------------------------------------------------------------
        * @description  Method "getRatingGCPByAccountNumber" retrieves Financial statement By Accnumbers
        --------------------------------------------------------------------------------
        * @author alexander.munguia.contractor@bbva.com
        * @date 2021-03-17
        * @param List<String> accountNumber
        * @return   Map<String,arce__Financial_Statements__c>
        * @example Map<String,arce__Financial_Statements__c> list =  getRatingGCPByAccountNumber(List<String> accountNumber)
        **/
        public static Map<String,arce__Financial_Statements__c> getRatingGCPByAccountNumber (List<String> accountNumber) {
            Map<String,arce__Financial_Statements__c> result = new Map<String,arce__Financial_Statements__c>();
            final List<String> conditions = new List <String>{'arce__ffss_submitted_type__c =: TYPE', 'arce__ffss_valid_type__c =: TYPE'};
            final Set<String> ahaByParentId = new Set<String>();
            for(arce__Account_has_Analysis__c aha : [SELECT Id FROM arce__Account_has_Analysis__c WHERE arce__Customer__r.AccountNumber IN:accountNumber]) {
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
            String queryString = 'SELECT Id, arce__total_rating_score_number__c, arce__financial_statement_start_date__c, arce__rating_final__c';
            queryString += ', arce__account_has_analysis_id__r.arce__Customer__r.AccountNumber, arce__account_has_analysis_id__r.arce__total_rating_score_number__c'+
                ', arce__account_has_analysis_id__r.arce__short_rating_value_type__c, arce__account_has_analysis_id__r.arce__long_rating_value_type__c';
            queryString += ' FROM arce__Financial_Statements__c where arce__account_has_analysis_id__c IN: ahaId '+condition;
                for (arce__Financial_Statements__c ffee : Database.query(String.escapeSingleQuotes(queryString))) {
                    if(!result.containsKey(ffee.arce__account_has_analysis_id__r.arce__Customer__r.AccountNumber)) {
                        result.put(ffee.arce__account_has_analysis_id__r.arce__Customer__r.AccountNumber, ffee);
                    }
                }
            return result;
        }
    }