/**
* @File Name          : Arc_Gen_NewAnalysis_data.cls
* @Description        : Data class to NewAnalysis
* @Author             : luisarturo.parra.contractor@bbva.com
* @Group              : ARCE
* @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
* @Last Modified On   : 04-30-2021
* @Modification Log   :
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    30/04/2019           eduardoefrain.hernandez.contractor@bbva.com     Initial Version
* 1.1    02/04/2019           diego.miguel.contractor@bbva.com                Added logic to redirect to valid ARCE
* 1.2    03/05/2019           diego.miguel.contractor@bbva.com                Added functions to save ARCE name AND subtype
* 1.3    09/05/2019           diego.miguel.contractor@bbva.com                Added functions to redirect acording to ARCE satatus AND update status
* 1.4    14/05/2019           diego.miguel.contractor@bbva.com                Added methods to groups ws support
* 1.5    04/11/2019           manuelhugo.castillo.contractor@bbva.com         Fix query stage ARCE
* 1.6    14/11/2019           mariohumberto.ramirez.contractor@bbva.com       Fix analysis type assigment
* 1.7    02/12/2019           luisarturo.parra.contractor@bbva.com            Refactorizacion
* 1.8    04/12/2019           manuelhugo.castillo.contractor@bbva.com         Modify methods 'getUniqueCustomerDatacl','getClientsByGroup','checkifhasgroup' replace Account to AccountWrapper
* 1.9    09/03/2020           eduardoefrain.hernandez.contractor@bbva.com     adedd methods because of Indepentent Rating (RAIP)
* 1.10    04/05/2020          juanmanuel.perez.ortiz.contractor@bbva.com      Modified updateArceName method to assing ARCE name when execute modified ARCE flow
* 1.11    20/05/2020          juanmanuel.perez.ortiz.contractor@bbva.com      Modified variable name in updateArceName method to avoid Sonar issue
* 1.12    28/07/2020          juanmanuel.perez.ortiz.contractor@bbva.com      Update arce name length
* 1.13    20/01/2021        saimassimilianno.jordana.contractor@bbva.com      Modified updateArceName meth0d to work with customAccount.
* 1.14   23/09/2020     saimassimilianno.jordana.contractor@bbva.com          Added arce. namespace to all classes that are
*                                                                             now in the arce-dependencies package
* 1.15    11/03/2021          juanmanuel.perez.ortiz.contractor@bbva.com      Fix if condition and add MODIFY_TEXT final variable
* 1.16    18/03/2021          juanignacio.hita.contractor@bbva.com            Added updateTypeAnalysis, getTypeWkflAnalysis and getTypeFfssAha methods
* 1.17    30/04/2021          otiliaramona.veres.contractor@bbva.com          Added an empty constructor method.
* 1.18    04/05/2021          otiliaramona.veres.contractor@bbva.com          Added annotation '@testVisible' to the empty constructor method.
* 1.19    28/05/2021          juanignacio.hita.contractor@bbva.com            Added call to getLocalCountryValue method in updateTypeAnalysis
**/
public without sharing class Arc_Gen_NewAnalysis_data {
    /**
    * @Description Subprocess type of RAIP.
    */
    public static final String MODIFY_TEXT = 'Modification';
/**
*-------------------------------------------------------------------------------
* @description Empty constructor method
*-------------------------------------------------------------------------------
*@author otiliaramona.veres.contractor@bbva.com
*@date 30/04/2021
*/
  @TestVisible
  private Arc_Gen_NewAnalysis_data() { }
/**
*-------------------------------------------------------------------------------
* @description Principal method that gets customer data
*-------------------------------------------------------------------------------
* @date 12/09/2019
* @author luisarturo.parra.contractor@bbva.com
* @param recordId- customer id
* @return arce.Arc_Gen_Account_Wrapper
* @example public static  Account getUniqueCustomerDatacl (String recordId)
*/
  public static arce.Arc_Gen_Account_Wrapper getUniqueCustomerDatacl(String recordId) {
      List<Id> lstIds = new List<Id>{Id.valueOf(recordId)};
      final Map<Id,arce.Arc_Gen_Account_Wrapper> accWrap = arce.Arc_Gen_Account_Locator.getAccountInfoById(lstIds);
      return accWrap.get(Id.valueOf(recordId));
  }
  /**
*-------------------------------------------------------------------------------
* @description methot to get recordtype info
*-------------------------------------------------------------------------------
* @date 12/09/2019
* @author luisarturo.parra.contractor@bbva.com
* @param sObjectType
* @return AnalysisResponse type class
* @example  public static  Id getRecordTypes(String sObjectType)
*/
  public static Id getRecordTypes(String sObjectType) {
      Id analysisType = [SELECT Id, Name FROM RecordType WHERE sObjectType = : sObjectType limit 1].Id;
      Return analysisType;
  }
  /**
*-------------------------------------------------------------------------------
* @description method that updates arce name
*-------------------------------------------------------------------------------
* @date 12/09/2019
* @author luisarturo.parra.contractor@bbva.com
* @param recordId- customer id
* @return void
* @example  public static  void updateArceName(String arceId)
*/
  public static void updateArceName(String arceId) {
    final List<arce__Account_has_Analysis__c> aHas = arce.Arc_Gen_AccHasAnalysis_Data.getInfoForCustom(arceId);
    final String nameNoAcc = aHas.isEmpty() ? '' : arce.Arc_Gen_Account_Locator.getAccountInfoById(new List<Id> {aHas[0].arce__CustomAccountID__c}).get(aHas[0].arce__CustomAccountID__c).name;
    arce__Analysis__c newAnalysis = new arce__Analysis__c();
    newAnalysis = [SELECT Id, name, arce__Group__r.Name, arce__parent_analysis_id__c, toLabel(arce__anlys_wkfl_sub_process_type__c), toLabel(arce__gf_curr_anlys_mod_justn_type__c) FROM arce__Analysis__c WHERE id =: arceId];
    final String nameSubProcess = newAnalysis.arce__anlys_wkfl_sub_process_type__c;
    if (newAnalysis != null) {
        final String maxGroupName = nameNoAcc == '' ? newAnalysis.arce__Group__r.Name.abbreviate(30) : nameNoAcc;
        final String maxSubpJust = nameSubProcess + ' - ' + newAnalysis.arce__gf_curr_anlys_mod_justn_type__c;
        final String nameArce = (newAnalysis.arce__anlys_wkfl_sub_process_type__c == MODIFY_TEXT) ? maxSubpJust.abbreviate(30) + ' - ' + maxGroupName + ' - ' + newAnalysis.arce__parent_analysis_id__c : nameSubProcess + ' - ' + maxGroupName + ' - ' + newAnalysis.arce__parent_analysis_id__c;
        final arce__Analysis__c updateAnalysis = new arce__Analysis__c(Id = newAnalysis.Id, Name = nameArce.abbreviate(80));
        update updateAnalysis;
    }
  }
  /**
*-------------------------------------------------------------------------------
* @description currentuser method
*-------------------------------------------------------------------------------
* @date 12/09/2019
* @author luisarturo.parra.contractor@bbva.com
* @return currentuser
* @example public static  user  currentuser()
*/
  public static user currentuser() {
      user currentUser = [select id, Name from user where id = : system.UserInfo.getUserId()];
      return currentUser;
  }
  /**
*-------------------------------------------------------------------------------
* @description set empty rating
*-------------------------------------------------------------------------------
* @date 12/09/2019
* @author luisarturo.parra.contractor@bbva.com
* @param account_has_analysis_id
* @example public static  arce__rating_variables_detail__c setEmptyRatingVariable(String analysisId)
*/
  public static void upsertObjects(List < sObject > ltsObjects) {
      if (!ltsObjects.isEmpty()) {
          upsert ltsObjects;
      }
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Update type analysis field to analysis
  --------------------------------------------------------------------------------
  * @author juanignacio.hita.contractor@bbva.com
  * @date   18/03/2021
  * @param  arce__Analysis__c newArceAnalysis
  * @param  List<arce__Account_has_Analysis__c> accHas2CreateLts
  * @return void
  * @example updateTypeAnalysis(analysis, accHas2CreateLts);
  **/
  public static void updateTypeAnalysis(arce__Analysis__c newArceAnalysis, List<arce__Account_has_Analysis__c> accHas2CreateLts) {
    final Map<String, Object> fieldValueMap = new Map<String, Object> {
      'arce__anlys_arce_type__c' => getTypeWkflAnalysis(newArceAnalysis, accHas2CreateLts)
    };
    final Map<String, Object> mapLocalCountry = Arc_Gen_NewAnalysis_Service_Helper.getLocalCountryValue(newArceAnalysis.Id);
    if (!mapLocalCountry.isEmpty()) {
      fieldValueMap.putAll(mapLocalCountry);
    }
    arce.Arc_Gen_ArceAnalysis_Data.editAnalysisFields(newArceAnalysis.Id, fieldValueMap);
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Return the type of analysis from subprocess and analysis customer relation type
  --------------------------------------------------------------------------------
  * @author juanignacio.hita.contractor@bbva.com
  * @date   08/02/2021
  * @param  arce__Analysis__c analysis
  * @param  List<arce__Account_has_Analysis__c> lstAccHas
  * @return String return string with the type analysis
  * @example String ret = getTypeWkflAnalysis(analysis, lstAccHas);
  **/
  public static String getTypeWkflAnalysis(arce__Analysis__c analysis, List<arce__Account_has_Analysis__c> lstAccHas) {
    String typeWkflAnlysis;
    // IRP
    if (analysis.arce__anlys_wkfl_sub_process_type__c == arce.Arc_Gen_Constants.FAMILY_IRP) {
        typeWkflAnlysis = arce.Arc_Gen_Constants.FAMILY_IRP;
    } else {
        if (analysis.arce__analysis_customer_relation_type__c == arce.Arc_Gen_Constants.CUSTOMER_RELATION_NON_ORPHAN) {
            typeWkflAnlysis = getTypeFfssAha(lstAccHas[0]);
        } else if (analysis.arce__analysis_customer_relation_type__c == arce.Arc_Gen_Constants.CUSTOMER_RELATION_ORPHAN) {
            // Orphan
            typeWkflAnlysis = arce.Arc_Gen_Constants.FAMILY_ORPHAN;
        }
    }
    return typeWkflAnlysis;
  }
  /**
  *-------------------------------------------------------------------------------
  * @description Return the type of analysis consolidated or not consolidated for group aha
  --------------------------------------------------------------------------------
  * @author juanignacio.hita.contractor@bbva.com
  * @date   08/02/2021
  * @param  arce__Account_has_Analysis__c accHas
  * @return String
  * @example String ret = getTypeFfssAha(accHas);
  **/
  public static String getTypeFfssAha(arce__Account_has_Analysis__c accHas) {
    return accHas.arce__anlys_wkfl_cnsld_ffss_type__c == '1' ? arce.Arc_Gen_Constants.FAMILY_NOT_CONSGROUP : arce.Arc_Gen_Constants.FAMILY_CONSGROUP;
  }
}