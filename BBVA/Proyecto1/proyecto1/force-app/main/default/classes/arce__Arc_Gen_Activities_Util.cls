/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Activities_Util
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020-05-20
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Utility class for Activity Split object.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-05-20 ivan.cons.contractor@bbva.com.
*              Class creation.
* |2020-05-20 saimassimilianno.jordana.contractor@bbva.com.
*             getAllActByParent2012 meth0d added to get all arce__Activity_Split_2012__c records related.
* |2020-05-20 saimassimilianno.jordana.contractor@bbva.com.
*             getOveralActivitiesPrcntg2012 meth0d added to get percentage of 2012 model activities.
* |2020-08-17 saimassimilianno.jordana.contractor@bbva.com.
*             new field added to getAllActByParent2012 method.
* |2021-09-10 amunguia.contractor@bbva.com.
*             new query Activity Split 2012 by Id.
* |2020-09-01 saimassimilianno.jordana.contractor@bbva.com.
*             getActivitiesWeightByTemplate and getRelativeWeightSum methods modified to work with ActSpl2012.
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_Activities_Util {
  /**
  * --------------------------------------------------------------------------------------
  * Constructor
  **/
  @TestVisible
  private Arc_Gen_Activities_Util() {}
  /**
  * @Description: string with name arce__Activity_Split__c object
  */
  final private static String ACTTY = 'arce__Activity_Split__c';
  /**
  * @Description: string with name arce__Activity_Split_2012__c object
  */
  final private static String ACTTY2012 = 'arce__Activity_Split_2012__c';
  /**
  * @Description: initial SOQL string.
  */
  final private static String SOQLINIT = 'SELECT ';
  /**
  * --------------------------------------------------------------------------------------
  * @description Builds and returns the wrapper with the chart parameters.
  * @param parentIdSet Set with the account has analysis Ids.
  * @return Returns all the activities related.
  **/
  public static List<arce__Activity_Split__c> getAllActivitiesByParent(Set<String> parentIdSet){
    String queryString = SOQLINIT + Arc_Gen_Corporate_Utils.getAllFields(ACTTY);
    queryString += ' FROM arce__Activity_Split__c WHERE arce__Account_has_Analysis__c IN: parentIdSet';
    final List<arce__Activity_Split__c> activitiesList = Database.query(String.escapeSingleQuotes(queryString));
    return activitiesList;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Builds and returns the wrapper with the chart parameters.
  * @param parentIdSet Set with the account has analysis Ids.
  * @return Returns all the activities related.
  **/
  public static List<arce__Activity_Split_2012__c> getAllActByParent2012(Set<String> parentIdSet) {
    String queryString = 'SELECT arce__Account_has_Analysis__r.Id, ' + Arc_Gen_Corporate_Utils.getAllFields(ACTTY2012);
    queryString += ' FROM arce__Activity_Split_2012__c WHERE arce__Account_has_Analysis__c IN: parentIdSet';
    return Database.query(String.escapeSingleQuotes(queryString));
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Builds and returns the wrapper with the chart parameters.
  * @param parentIdSet Set with the account has analysis Ids.
  * @return Returns all the activities related.
  **/
  public static List<arce__Activity_Split_2012__c> getAllActByParent2012ById(Set<String> parentIdSet) {
    String queryString = SOQLINIT + Arc_Gen_Corporate_Utils.getAllFields(ACTTY2012);
    queryString += ' FROM arce__Activity_Split_2012__c WHERE Id IN: parentIdSet';
    return Database.query(String.escapeSingleQuotes(queryString));
  }
  /**
  * --------------------------------------------------------------------------------------
  * @description Builds and returns the wrapper with the chart parameters.
  * @param parentIdSet Set with the account has analysis Ids.
  * @return Returns all the activities related and its geographies.
  **/
  public static List<arce__Activity_Split__c> getAllActivitiesAndChildsByParent(Set<String> parentIdSet){
    String queryString = SOQLINIT + Arc_Gen_Corporate_Utils.getAllFields(ACTTY);
    queryString += ',(SELECT ' + Arc_Gen_Corporate_Utils.getAllFields('arce__Geographic_Split__c') + ' FROM arce__Geographic_Splits__r)';
    queryString += ' FROM arce__Activity_Split__c WHERE arce__Account_has_Analysis__c IN: parentIdSet';
    final List<arce__Activity_Split__c> activitiesList = Database.query(String.escapeSingleQuotes(queryString));
    return activitiesList;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Builds and returns the wrapper with the chart parameters.
  * @param acttyIds Set with the activity split Ids.
  * @return Returns all the activities related.
  **/
  public static List<arce__Activity_Split__c> getAllActivitiesById(Set<Id> acttyIds){
    String queryString = SOQLINIT + Arc_Gen_Corporate_Utils.getAllFields(ACTTY);
    queryString += ' FROM arce__Activity_Split__c WHERE Id IN: acttyIds';
    final List<arce__Activity_Split__c> activitiesList = Database.query(String.escapeSingleQuotes(queryString));
    return activitiesList;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Get the total percentage for a given account has analysis.
  * @param activitiesList Set with the activity split Ids.
  * @return Returns the total percentage
  **/
  public static Decimal getOveralActivitiesPercentage(List<arce__Activity_Split__c > activitiesList) {
    Decimal percentage = 0;
    for(arce__Activity_Split__c activityS : activitiesList) {
      percentage += activityS.arce__gf_subindustry_weight_per__c;
    }
    return percentage;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Get the total percentage for a given account has analysis.
  * @param activitiesList Set with the activity split Ids.
  * @return Returns the total percentage
  **/
  public static Decimal getOveralActivitiesPrcntg2012(List<arce__Activity_Split_2012__c > activitiesList) {
    Decimal percentage = 0;
    for(arce__Activity_Split_2012__c activityS : activitiesList) {
      percentage += activityS.arce__gf_subindustry_weight_per__c;
    }
    return percentage;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Returns a list of activities of specified parents (Account_has_analysis__c object) and templates
  * @param parentIdSet Set of Account_has_analysis id to filter for
  * @param templates Set of activity templates id to filter for
  * @return Returns all the activities related.
  **/
  public static List<arce__Activity_Split__c> getAllActivitiesByParentAndTemplate(Set<String> parentIdSet, Set<String> templates){
    String queryString = SOQLINIT + Arc_Gen_Corporate_Utils.getAllFields(ACTTY);
    queryString += ' FROM arce__Activity_Split__c WHERE arce__Account_has_Analysis__c IN: parentIdSet AND arce__Template_type__c IN :templates';
    final List<arce__Activity_Split__c> activitiesList = Database.query(String.escapeSingleQuotes(queryString));
    return activitiesList;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description Returns a an AggregateResult containing the total weight per template for a given Account_has_analysis__c
  * @param parentId Account_has_analysis id to filter for
  * @param templates Set of activity templates id to get theirs weight
  * @return Returns all the activities related.
  **/
  public static List<AggregateResult> getActivitiesWeightByTemplate(String parentId, Set<String> templates){
    List<AggregateResult> ret;
    final String rarRatingTool = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{parentId})[0].arce__RAR_rating_tool_id__c;
    final String objectToUse = rarRatingTool.left(4) == '2012' ? ACTTY2012 : ACTTY;

    if(templates == null || templates.isEmpty()){
      ret = Database.query('SELECT arce__Template_type__c, SUM(arce__gf_subindustry_weight_per__c) weight FROM ' + objectToUse + ' WHERE arce__Account_has_Analysis__c = :parentId GROUP BY arce__Template_type__c');
    }else {
      ret = Database.query('SELECT arce__Template_type__c, SUM(arce__gf_subindustry_weight_per__c) weight FROM ' + objectToUse + ' WHERE arce__Account_has_Analysis__c = :parentId AND arce__Template_type__c IN :templates GROUP BY arce__Template_type__c');
    }
    return ret;
  }

  /**
  * --------------------------------------------------------------------------------------
  * @description REturns the non-absolute sum of the weights of the activities
  * @param parentIdSet Account_has_analysis id to filter for
  * @return Returns an AggregateResult object containing the sum of all weights of activities
  **/
  public static AggregateResult getRelativeWeightSum(String parentId){
    AggregateResult ret;

    final String rarRatingTool = arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysis(new List<String>{parentId})[0].arce__RAR_rating_tool_id__c;
    final String objectToUse = rarRatingTool.left(4) == '2012' ? ACTTY2012 : ACTTY;

    final List<AggregateResult> listVal = Database.query('SELECT SUM(arce__gf_subindustry_weight_per__c) relativeWeight FROM ' + objectToUse + ' WHERE arce__Account_has_Analysis__c = :parentId');
    ret = listVal.isEmpty() ? ret : listVal.get(0);
    return ret;
  }
}