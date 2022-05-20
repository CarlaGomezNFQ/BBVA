/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_AccHasAnalysis_Data
* @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
* @Date     Created: 2020-01-13
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Data class for object arce__Account_has_Analysis__c
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2020-01-13 mariohumberto.ramirez.contractor@bbva.com
*             Class creation.
* |2020-05-22 joseluis.garcia4.contractor@bbva.com
*             Add getVariablesByLevel() and getQualitativeVariables() methods (that were previously
*             in Arc_Gen_RatingVariablesTable_data, now deleted).
* |2020-06-29 joseluis.garcia4.contractor@bbva.com
*             Add getOverrideVariable() method.
* |2020-11-13 juanignacio.hita.contractor@bbva.com
*             Add parent code filter in getVariablesByLevel method
* |2020-11-19 joseluis.garcia4.contractor@bbva.com
*             Makes getVariablesByLevel return qualitative block scoring (level 1).
* |2020-11-24 joseluis.garcia4.contractor@bbva.com
*             Makes getQualitativeVariables not return level 1 rating variables.
* |2021-06-16 joseluis.garcia4.contractor@bbva.com
*             Fix query for level 1/2 variables so all blocks are returned, instead of only 1, 2 and 3.
* -----------------------------------------------------------------------------------------------
*/
global with sharing class Arc_Gen_Rating_Var_detail_Data {
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Void Constructor to avoid warning in sonar qube
    * ----------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-01-13
    * @param void
    * @return void
    * @example Arc_Gen_Rating_Var_detail_Data data = new Arc_Gen_Rating_Var_detail_Data()
    * ----------------------------------------------------------------------------------------------------
    **/
    private Arc_Gen_Rating_Var_detail_Data() {

    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Set empty rating
    * ----------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-01-13
    * @param accHasId -  Id of the account has analysis object
    * @return arce__rating_variables_detail__c
    * @example Arc_Gen_Rating_Var_detail_Data data = new Arc_Gen_Rating_Var_detail_Data()
    * ----------------------------------------------------------------------------------------------------
    **/
    global static arce__rating_variables_detail__c setEmptyRatingVariable(String accHasId) {
        return new arce__rating_variables_detail__c(arce__account_has_analysis_id__c = accHasId);
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Gets variable with the rating override of an Account has Analysis.
    * ----------------------------------------------------------------------------------------------------
    * @Author   José Luis García Díaz  joseluis.garcia4.contractor@bbva.com
    * @Date     Created: 2020-06-29
    * @param accHasId -  Id of the account has analysis object
    * @return List<arce__rating_variables_detail__c>
    * ----------------------------------------------------------------------------------------------------
    **/
    global static List<arce__rating_variables_detail__c> getOverrideVariable(String accHasId) {
        return [SELECT arce__adj_long_rating_value_type__c FROM arce__rating_variables_detail__c WHERE arce__account_has_analysis_id__c = :accHasId AND arce__modifier_mix_type__c = '02-OVERRIDE'];
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that obtains the level one variables
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param String ratingId
    * @return List<arce__rating_variables_detail__c>
    * @example public List<arce__rating_variables_detail__c> getVariablesLevelOne(String ratingId)
    **/
    global static List<arce__rating_variables_detail__c> getVariablesByLevel(String ratingId, String level) {
        // Only fetch qualitative block (parent_code_number = '2') if querying for level 1 (block score).
        final String parentCodeFilter = level == '1' ? '' : 'arce__parent_code_number__c != \'2\' AND ';
        final String condition = parentCodeFilter + 'arce__rating_Id__c = \''+String.escapeSingleQuotes(ratingId)+'\' AND arce__rating_variable_level_id__c = \''+String.escapeSingleQuotes(level)+'\' ORDER BY arce__rating_variable_id__c ASC';
        final String query = 'SELECT id,ToLabel(arce__rating_variable_large_id__c),arce__rating_variable_name__c,arce__rating_var_value_amount__c,arce__rating_var_score_number__c,arce__rating_var_max_score_number__c,arce__parent_code_number__c FROM arce__rating_variables_detail__c WHERE ';
        return Database.query(query + condition);
    }
    /**
    *-------------------------------------------------------------------------------
    * @description Method that obtains the qualitative variables
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 30/4/2019
    * @param String ratingId
    * @return List<arce__rating_variables_detail__c>
    * @example public List<arce__rating_variables_detail__c> getVariablesLevelOne(String ratingId)
    **/
    global static List<arce__rating_variables_detail__c> getQualitativeVariables(String ratingId) {
        final String condition = 'arce__parent_code_number__c = \'2\' AND arce__rating_Id__c = \''+String.escapeSingleQuotes(ratingId)+'\' AND arce__rating_variable_level_id__c = \'2\' ORDER BY arce__rating_variable_id__c ASC';
        final String query = 'SELECT id,arce__rating_variable_large_id__c,arce__rating_variable_name__c,arce__rating_var_value_amount__c,arce__rating_var_score_number__c,arce__rating_var_max_score_number__c,arce__parent_code_number__c FROM arce__rating_variables_detail__c WHERE ';
        return Database.query(query + condition);
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Set empty rating
    * ----------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2020-01-13
    * @param accHasId -  Id of the account has analysis object
    * @return arce__rating_variables_detail__c
    * @example Arc_Gen_Rating_Var_detail_Data data = new Arc_Gen_Rating_Var_detail_Data()
    * ----------------------------------------------------------------------------------------------------
    **/
    global static void insertRatingVariables(List<arce__rating_variables_detail__c> ratingVarLts) {
        if (!ratingVarLts.isEmpty()) {
            insert ratingVarLts;
        }
    }
}