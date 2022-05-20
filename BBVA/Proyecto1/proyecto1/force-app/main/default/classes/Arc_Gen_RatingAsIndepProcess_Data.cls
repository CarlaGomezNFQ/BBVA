/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_RatingAsIndepProcess_Data
* @Author   saimassimilianno.jordana.contractor@bbva.com
* @Date     Created: 2021-04-09
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Data class of the new rating as independent process
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-01-08 saimassimilianno.jordana.contractor@bbva.com
*             Class creation.setFFSSWAhasName
* |2020-05-05 saimassimilianno.jordana.contractor@bbva.com
*             Parameter Deleted and added new one in setFFSSWAhasName meth0d.
* -----------------------------------------------------------------------------------------------
*/
public  with sharing class Arc_Gen_RatingAsIndepProcess_Data {

    /**
    * @description: Empty constructor
    **/
    @TestVisible
    private Arc_Gen_RatingAsIndepProcess_Data() {

    }

    /**
    *---------------------------------------------------------------------------------------
    * @Description  Method  that inserts the ffss with Ahas Name and relate an empty rating
    *---------------------------------------------------------------------------------------
    * @Author   Sai Jordana  saimassimilianno.jordana.contractor@bbva.com
    * @Date     Created: 2021-02-24
    * @param String rarRatingTool - Rar Rating Tool selected by the user.
    * @return   arce__Financial_Statements__c
    * @example  setFFSSWAhasName()
    * -------------------------------------------------------------------------------
    */
    public static arce__Financial_Statements__c setFFSSWAhasName(String rarRatingTool) {
        final arce__rating__c emptyRating = new arce__rating__c();
        if (String.isNotBlank(rarRatingTool)) {
            emptyRating.arce__rar_rating_tool_id__c = rarRatingTool;
        }
        insert emptyRating;

        final arce__Financial_Statements__c ffss = new arce__Financial_Statements__c(arce__rating_id__c = emptyRating.Id);
        insert ffss;

        return ffss;
    }
}