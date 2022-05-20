/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_initFinalRating_Controller
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 31/08/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Arc_Gen_initFinalRating_Controller
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |31-08-2021 saimassimilianno.jordana.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_initFinalRating_Controller {
    /**
    * --------------------------------------------------------------------------------------
    * Constructor
    **/
    @TestVisible
    private Arc_Gen_initFinalRating_Controller() {}

    /**
    * @Description: string with a type of variable detail
    */
    Static Final String ACTIVITY_TEMPLATE = 'ACTIVITY_TEMPLATE';
    /**
    * @Description: string with a type of variable detail
    */
    Static Final String DATA_2012 = 'DATA_2012';

    /**
    * @description update activity split 2012 records to show it at final rating table.
    * @author saimassimilianno.jordana.contractor@bbva.com | Date 31-08-2021
    * @param String aHasAnalysId
    * @return String (JSON)
    **/
    @AuraEnabled
    public static String updateActSplit2012(String aHasAnalysId) {
        arce.Arc_Gen_RatingGlobal_data.SaveResult response = new arce.Arc_Gen_RatingGlobal_data.SaveResult();
        final List<arce__Activity_Split_2012__c> tuUpdt = new List<arce__Activity_Split_2012__c>();
        final List<sObject> tuUpdtSobj = new List<sObject>();
        final arce.Arc_Gen_RatingGlobal_data dataClass = new arce.Arc_Gen_RatingGlobal_data();

        final Set<String> parentIdSet = new Set<String>();
        parentIdSet.add(aHasAnalysId);

        final Set<String> modType = new Set<String>();
        modType.add('DATA_2012');
        modType.add('ACTIVITY_TEMPLATE');

        final arce__rating__c currentRating = dataClass.getCurrentRating(aHasAnalysId);

        final List<arce__Activity_Split_2012__c> lstActSplit = Arc_Gen_Activities_Util.getAllActByParent2012(parentIdSet);

        final List<arce__rating_variables_detail__c> lstVarDetail = Arc_Gen_Rating_Utils.getRatingDetByAha(parentIdSet, modType);

        final Map<String,String> mapScores = bringMapScores(lstVarDetail);

        for (arce__Activity_Split_2012__c current2012 : lstActSplit) {
            final String subactvId = current2012.arce__gf_subactivity_id__c.leftPad(5,'0');
            final String varCountry = current2012.arce__Country__c;
            final arce__Activity_Split_2012__c split2012 = new arce__Activity_Split_2012__c();
            split2012.id = current2012.id;
            split2012.arce__Financial_risk_score__c = Decimal.valueOf(mapScores.get(subactvId+'01000'+varCountry));
            split2012.arce__Business_risk_score__c = Decimal.valueOf(mapScores.get(subactvId+'02000'+varCountry));

            final String getKey1 = current2012.arce__gf_subactivity_id__c.leftPad(5,'0') + current2012.arce__Country__c + current2012.arce__Template_type__c + 'score';
            split2012.arce__Total_score__c = Decimal.valueOf(mapScores.get(getKey1));

            final String getKey2 = current2012.arce__gf_subactivity_id__c.leftPad(5,'0') + current2012.arce__Country__c + current2012.arce__Template_type__c + 'rating';
            split2012.arce__Rating_score__c = mapScores.get(getKey2);

            tuUpdt.add(split2012);
        }

        currentRating.arce__Diversification_Adjustment__c =  Decimal.valueOf(mapScores.get('DA00002001'));

        //insertamos t0d0s los split 2012
        tuUpdtSobj.addAll(tuUpdt);

        //insertamos el rating modificado
        tuUpdtSobj.add(currentRating);

        response = Arc_Gen_Corporate_Utils.updateRecords2012(tuUpdtSobj);

        return JSON.serialize(response);
    }

    /**
    * @description Map constructor to get data from variables.
    * @author saimassimilianno.jordana.contractor@bbva.com | Date 31-08-2021
    * @param List<arce__rating_variables_detail__c> lstVarDtl
    * @return Map<String,Double>
    **/
    public static Map<String,String> bringMapScores(List<arce__rating_variables_detail__c> lstVarDtl) {
        final Map<String,String> returnMap = new Map<String,String>();
        for(arce__rating_variables_detail__c varDet : lstVarDtl) {
            if (varDet.arce__rating_modifier_adj_type__c == DATA_2012) {
                returnMap.put(varDet.arce__rating_variable_large_id__c, String.valueOf(varDet.arce__rating_var_score_number__c));
            }
            if (varDet.arce__rating_modifier_adj_type__c == ACTIVITY_TEMPLATE) {
                final String keyMap1 = varDet.arce__activity_sub_industry_id__c.leftPad(5,'0') + varDet.arce__activity_country__c + varDet.arce__activity_template__c + 'score';
                returnMap.put(keyMap1, String.valueOf(varDet.arce__rating_var_score_number__c));
                final String keyMap2 = varDet.arce__activity_sub_industry_id__c.leftPad(5,'0') + varDet.arce__activity_country__c + varDet.arce__activity_template__c + 'rating';
                returnMap.put(keyMap2, varDet.arce__adj_short_rating_value_type__c);
            }
        }
        return returnMap;
    }
}