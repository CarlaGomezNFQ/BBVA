/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Testing_Util
* @Author   BBVA Developers
* @Date     Created: 2020-06-30
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description this class is the controller for the table.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-06-30 BBVA Developers.
*              Class creation.
* 2020-10-20  alexander.munguia.contractor@bbva.com
*              Change api names in picklist of arce__Activity_Split__c
* 2021-07-29  saimassimilianno.jordana.contractor@bbva.com
*              crteActvtySplt2012 methods created for 2012 model tests.
* ------------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_Testing_Util {
    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Analysis__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ return arce__Analysis__c
    * @ example Arc_Gen_Testing_Util.createAnalisis()
    *--------------------------------------------------------------------------------
    **/
    public static arce__Analysis__c createAnalisis() {
        arce__Analysis__c analisis = new arce__Analysis__c();
        return analisis;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Analysis__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ return arce__Analysis__c
    * @ example Arc_Gen_Testing_Util.createAnalisis()
    *--------------------------------------------------------------------------------
    **/
    public static arce__Analysis__c createAnalisis2012() {
        final arce__Analysis__c analisis = new arce__Analysis__c();
        analisis.Name = '2012';
        return analisis;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Account_has_Analysis__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ param String idAnalisis
    * @ return arce__Account_has_Analysis__c
    * @ example Arc_Gen_Testing_Util.createAccountHasAnalisis('XXXXXXXXX')
    *--------------------------------------------------------------------------------
    **/
    public static arce__Account_has_Analysis__c createAccountHasAnalisis(String idAnalisis) {
        arce__Account_has_Analysis__c aha = new arce__Account_has_Analysis__c();
        aha.arce__Analysis__c = idAnalisis;
        return aha;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Activity_Split__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ return arce__Activity_Split__c
    * @ example Arc_Gen_Testing_Util.createActivitySplit()
    *--------------------------------------------------------------------------------
    **/
    public static arce__Activity_Split__c createActivitySplit() {
        String sector = 'D';
        String subsector = 'DF';
        String activity = 'DBB';
        String subactivity = '842';
        String template = '10';
        Decimal percent = 25;
        String tipoPercent = '1';
        return createActivitySplit(sector, subsector, activity, subactivity, template, percent, tipoPercent);
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Activity_Split__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ param String sector
    * @ param String subsector
    * @ param String activity
    * @ param String subactivity
    * @ param String template
    * @ param Decimal percent
    * @ param String tipoPercent
    * @ return arce__Activity_Split__c
    * @ example Arc_Gen_Testing_Util.createActivitySplit(sector, subsector, activity, subactivity, template, percent, tipoPercent);
    *--------------------------------------------------------------------------------
    **/
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static arce__Activity_Split__c createActivitySplit(String sector, string subsector, string activity, string subactivity, string template, decimal percent, string tipoPercent) {
        arce__Activity_Split__c activitySplit = new arce__Activity_Split__c();
        activitySplit.arce__sector_id__c = sector;
        activitySplit.arce__Subsector_id__c = subsector;
        activitySplit.arce__gf_company_economic_actvy_id__c = activity;
        activitySplit.arce__gf_subactivity_id__c = subactivity;
        activitySplit.arce__Template_type__c = template;
        activitySplit.arce__gf_subindustry_weight_per__c = percent;
        activitySplit.arce__gf_activity_split_per_type__c = tipoPercent;
        return activitySplit;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Geographic_Split__c
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-06-30
    * @ param String pais
    * @ param Decimal percent
    * @ param Id activitySplitId
    * @ param String tipoPercent
    * @ return arce__Activity_Split__c
    * @ example Arc_Gen_Testing_Util.createActivitySplit(pais, percent, activitySplitId, tipoPercent);
    *--------------------------------------------------------------------------------
    **/
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static arce__Geographic_Split__c createGeographicSplit(String pais, Decimal percent, Id activitySplitId, String tipoPercent) {
        arce__Geographic_Split__c geographicSplit = new arce__Geographic_Split__c();
        geographicSplit.arce__Country__c = pais;
        geographicSplit.arce__gf_geography_weight_per__c = percent;
        geographicSplit.arce__Activity_Split__c = activitySplitId;
        geographicSplit.arce__gf_geography_split_per_type__c = tipoPercent;
        return geographicSplit;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Activity_Split_2012__c
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contactor@bbva.com
    * @ Date 2020-07-26
    * @ return arce__Activity_Split_2012__c
    * @ example Arc_Gen_Testing_Util.crteActvtySplt2012()
    *--------------------------------------------------------------------------------
    **/
    public static arce__Activity_Split_2012__c crteActvtySplt2012() {
        return crteActvtySplt2012('A', 'AD', 'AAB', 'AAB2', '102', 97, '1', 'ES');
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description create new arce__Activity_Split_2012__c
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contactor@bbva.com
    * @ Date 2020-07-26
    * @ param String sector
    * @ param String subsector
    * @ param String activity
    * @ param String subactivity
    * @ param String template
    * @ param Decimal percent
    * @ param String tipoPercent
    * @ return arce__Activity_Split_2012__c
    * @ example Arc_Gen_Testing_Util.crteActvtySplt2012(sector, subsector, activity, subactivity, template, percent, tipoPercent);
    *--------------------------------------------------------------------------------
    **/
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static arce__Activity_Split_2012__c crteActvtySplt2012(String sector, string subsector, string activity, string subactivity, string template, decimal percent, string tipoPercent, string country) {
        final arce__Activity_Split_2012__c activitySplit = new arce__Activity_Split_2012__c();
        activitySplit.arce__sector_id__c = sector;
        activitySplit.arce__Subsector_id__c = subsector;
        activitySplit.arce__gf_company_economic_actvy_id__c = activity;
        activitySplit.arce__gf_subactivity_id__c = subactivity;
        activitySplit.arce__Template_type__c = template;
        activitySplit.arce__gf_subindustry_weight_per__c = percent;
        activitySplit.arce__gf_activity_split_per_type__c = tipoPercent;
        activitySplit.arce__Country__c = country;
        return activitySplit;
    }
}