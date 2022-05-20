/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ChartBuilder
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020-05-20
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description: Class to process data and get specific JSON.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-05-20 ivan.cons.contractor@bbva.com.
*             Class creation.
* |2020-07-02 saimassimilianno.jordana.contractor@bbva.com.
*             getGeoDistribution2012 and getActDistribution2012 meth0ds added to process 2012 data charts.
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_ChartBuilder {

    /**
    * @Description: string with the type of chart to use.
    */
    static final String TYPEOFCHART = 'doughnut';

    /**
    * @Description: Literal used multiple times.
    */
    static final String OTHERS = 'Others';

    /**
    * --------------------------------------------------------------------------------------
    * @description Method to get a JSON with the correct data depending on type.
    * @param collectionType Type of chart that will be filled with the JSON to obtain.
    * @param parentId Analysis Id.
    * @param grandParentId Account has analysis Id.
    * @return Arc_Gen_ChartWrapper
    **/
    public static Arc_Gen_ChartWrapper getChartWrapper(String collectionType,String parentId, String grandParentId) {
        List<String> labels = new List<String>();
        List<String> dataList = new List<String>();
        List<String> backgroundColor = new List<String>();
        Arc_Gen_ChartWrapper chart = new Arc_Gen_ChartWrapper();
        switch on collectionType{
            when 'geographiesChart2019'{
                chart.JSON_Setup = new Arc_Gen_ChartSetupWrapper(false, 10,TYPEOFCHART,true, 'Geographic distribution', false, true,new List<Boolean>{false});
                getGeographicDistribution(grandParentId, dataList, labels, backgroundColor);
                chart.JSON_Data = new Arc_Gen_ChartDataWrapper(new List<List<String>>{dataList}, backgroundColor, labels);
            }
            when 'subActivityChart2019'{
                chart.JSON_Setup = new Arc_Gen_ChartSetupWrapper(false, 10,TYPEOFCHART,true, 'Subactivity distribution', false, true,new List<Boolean>{false});
                getSubActivityDistribution(grandParentId, dataList, labels, backgroundColor);
                chart.JSON_Data = new Arc_Gen_ChartDataWrapper(new List<List<String>>{dataList}, backgroundColor, labels);
            }
            when 'geographiesChart2012'{
                chart.JSON_Setup = new Arc_Gen_ChartSetupWrapper(false, 10,TYPEOFCHART,true, 'Geographic distribution', false, true,new List<Boolean>{false});
                getGeoDistribution2012(grandParentId, dataList, labels, backgroundColor);
                chart.JSON_Data = new Arc_Gen_ChartDataWrapper(new List<List<String>>{dataList}, backgroundColor, labels);
            }
            when 'subActivityChart2012'{
                chart.JSON_Setup = new Arc_Gen_ChartSetupWrapper(false, 10,TYPEOFCHART,true, 'Activity distribution', false, true,new List<Boolean>{false});
                getActDistribution2012(grandParentId, dataList, labels, backgroundColor);
                chart.JSON_Data = new Arc_Gen_ChartDataWrapper(new List<List<String>>{dataList}, backgroundColor, labels);
            }
        }
        return chart;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Set variables to process the Chart JSON.
    * @param aHasAnalysId Account has analysis Id.
    * @param dataList List with data of the activities distribution.
    * @param labels Labels list to set into the chart.
    * @param backgroundColor  Colors list of the differents sections into the chart.
    * @return N/A
    **/
    public static void getGeographicDistribution(String aHasAnalysId, List<String> dataList, List<String> labels, List<String> backgroundColor) {
        final List<String> allColors = System.Label.BackgroundColors.split(',');
        final List<arce__Activity_Split__c > activityList = Arc_Gen_Activities_Util.getAllActivitiesAndChildsByParent(new Set<String>{aHasAnalysId});
        Map<String, Decimal> geoDistributionMap = new Map<String,Decimal>();
        Decimal othersGeographies = 100;
        final Map<String,String> pickListLabelsMap = Arc_Gen_Corporate_Utils.getPicklistLabels('arce__Geographic_Split__c','arce__Country__c');
        for(arce__Activity_Split__c actty : activityList) {
            for(arce__Geographic_Split__c geo : actty.arce__Geographic_Splits__r) {
                Decimal distributionWeight = geo.arce__gf_geography_weight_per__c * actty.arce__gf_subindustry_weight_per__c/100;
                Arc_Gen_Corporate_Utils.fillDistributionMap(geoDistributionMap, geo.arce__Country__c, distributionWeight.setScale(2));
            }
        }
        for(String geo : geoDistributionMap.keySet()) {
            labels.add(pickListLabelsMap.get(geo));
            dataList.add(String.valueOf(geoDistributionMap.get(geo)));
            backgroundColor.add(allColors.get(backgroundColor.size()));
            othersGeographies -= geoDistributionMap.get(geo);
        }
        if(othersGeographies>0) {
          labels.add(OTHERS);
          dataList.add(String.valueOf(othersGeographies));
          backgroundColor.add(System.Label.GreyColor);
        }
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Set variables to process the Chart JSON.
    * @param aHasAnalysId Account has analysis Id.
    * @param dataList List with data of the activities distribution.
    * @param labels Labels list to set into the chart.
    * @param backgroundColor  Colors list of the differents sections into the chart.
    * @return N/A
    **/
    public static void getSubActivityDistribution(String aHasAnalysId, List<String> dataList, List<String> labels, List<String> backgroundColor) {
        final List<String> allColors = System.Label.BackgroundColors.split(',');
        final List<arce__Activity_Split__c > activityList = Arc_Gen_Activities_Util.getAllActivitiesByParent(new Set<String>{aHasAnalysId});
        Map<String, Decimal> acttyDistributionMap = new Map<String,Decimal>();
        Decimal othersActivities = 100;
        final Map<String,String> pickListLabelsMap = Arc_Gen_Corporate_Utils.getPicklistLabels('arce__Activity_Split__c','arce__gf_subactivity_id__c');
        for(arce__Activity_Split__c actty : activityList) {
            Arc_Gen_Corporate_Utils.fillDistributionMap(acttyDistributionMap, actty.arce__gf_subactivity_id__c, actty.arce__gf_subindustry_weight_per__c.setScale(2));
        }

        for(String actty : acttyDistributionMap.keySet()) {
            labels.add(pickListLabelsMap.get(actty));
            dataList.add(String.valueOf(acttyDistributionMap.get(actty)));
            backgroundColor.add(allColors.get(backgroundColor.size()));
            othersActivities -= acttyDistributionMap.get(actty);
        }

        if(othersActivities>0) {
          labels.add(OTHERS);
          dataList.add(String.valueOf(othersActivities));
          backgroundColor.add(System.Label.GreyColor);
        }
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Set variables to process the Chart JSON.
    * @param aHasAnalysId Account has analysis Id.
    * @param dataList List with data of the activities distribution.
    * @param labels Labels list to set into the chart.
    * @param backgroundColor  Colors list of the differents sections into the chart.
    * @return N/A
    **/
    public static void getGeoDistribution2012(String aHasAnalysId, List<String> dataList, List<String> labels, List<String> backgroundColor) {
        final List<String> allColors = System.Label.BackgroundColors.split(',');
        final List<arce__Activity_Split_2012__c > activityList = Arc_Gen_Activities_Util.getAllActByParent2012(new Set<String>{aHasAnalysId});
        Map<String, Decimal> geoDistributionMap = new Map<String,Decimal>();
        Decimal othersGeographies = 100;
        final Map<String,String> pickListLabelsMap = Arc_Gen_Corporate_Utils.getPicklistLabels('arce__Activity_Split_2012__c','arce__Country__c');
        for(arce__Activity_Split_2012__c actty : activityList) {
            Decimal distributionWeight = actty.arce__gf_subindustry_weight_per__c;
            Arc_Gen_Corporate_Utils.fillDistributionMap(geoDistributionMap, actty.arce__Country__c, distributionWeight.setScale(2));
        }

        for(String geo : geoDistributionMap.keySet()) {
            labels.add(pickListLabelsMap.get(geo));
            dataList.add(String.valueOf(geoDistributionMap.get(geo)));
            backgroundColor.add(allColors.get(backgroundColor.size()));
            othersGeographies -= geoDistributionMap.get(geo);
        }

        if(othersGeographies>0) {
          labels.add(OTHERS);
          dataList.add(String.valueOf(othersGeographies));
          backgroundColor.add(System.Label.GreyColor);
        }
    }

    /**
    * --------------------------------------------------------------------------------------
    * @description Set variables to process the Chart JSON.
    * @param aHasAnalysId Account has analysis Id.
    * @param dataList List with data of the activities distribution.
    * @param labels Labels list to set into the chart.
    * @param backgroundColor  Colors list of the differents sections into the chart.
    * @return N/A
    **/
    public static void getActDistribution2012(String aHasAnalysId, List<String> dataList, List<String> labels, List<String> backgroundColor) {
        final List<String> allColors = System.Label.BackgroundColors.split(',');
        final List<arce__Activity_Split_2012__c > activityList = Arc_Gen_Activities_Util.getAllActByParent2012(new Set<String>{aHasAnalysId});
        Map<String, Decimal> acttyDistributionMap = new Map<String,Decimal>();
        Decimal othersActivities = 100;
        final Map<String,String> pickListLabelsMap = Arc_Gen_Corporate_Utils.getPicklistLabels('arce__Activity_Split_2012__c','arce__gf_company_economic_actvy_id__c');
        for(arce__Activity_Split_2012__c actty : activityList) {
            Arc_Gen_Corporate_Utils.fillDistributionMap(acttyDistributionMap, actty.arce__gf_company_economic_actvy_id__c, actty.arce__gf_subindustry_weight_per__c.setScale(2));
        }

        for(String actty : acttyDistributionMap.keySet()) {
            labels.add(pickListLabelsMap.get(actty));
            dataList.add(String.valueOf(acttyDistributionMap.get(actty)));
            backgroundColor.add(allColors.get(backgroundColor.size()));
            othersActivities -= acttyDistributionMap.get(actty);
        }

        if(othersActivities>0) {
          labels.add(OTHERS);
          dataList.add(String.valueOf(othersActivities));
          backgroundColor.add(System.Label.GreyColor);
        }
    }
}