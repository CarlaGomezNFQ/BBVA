/**
  * ────────────────────────────────────────────────────────────────────
  * Dynamic_Pricing_Helper
  * Controller helper for Dynamic_Pricing_Ctrl controller
  * ────────────────────────────────────────────────────────────────────
  * @author     Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-04-29
  * @modified
  * @systemLayer Presentation
  * ────────────────────────────────────────────────────────────────────
  * @changes
  *
  * ────────────────────────────────────────────────────────────────────
  */
  public with sharing class Dynamic_Pricing_Helper {
    // Private constructor to avoid sonar err
    @TestVisible
    private Dynamic_Pricing_Helper() {}
    /**
      * @description Returns a wrapper to show in the component
      * @param List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList : List of Flat Rates DP
      * @param Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt : Map with catalog flat rates dp attributes
      * @return DP_Clasification_Wrapper
      */
    public static DP_Clasification_Wrapper  fillWrapper(List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList, Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt) {
        flatRatesDPList.sort();
        final DP_Clasification_Wrapper flatWrapper = new DP_Clasification_Wrapper();
        final List<DP_Clasification_Wrapper.crossDPAtt> crossList = new List<DP_Clasification_Wrapper.crossDPAtt>();
        DP_Clasification_Wrapper.NonCrossDPTable table = new DP_Clasification_Wrapper.NonCrossDPTable();
        final Map<String,String> headers = getHeaders(flatRatesDPList,  mapDPAtt);
        Map<String, Map<String, List<String>>> mapStr = new Map<String, Map<String, List<String>>>();
        Map<String, List<String>> mapAux = new Map<String, List<String>>();
        for (FlatRates_Wrapper.FlatRatesDP flatDp : flatRatesDPList) {
            flatDp.dpAttributeList.sort();
            for (FlatRates_Wrapper.DPAttribute atr : flatDp.dpAttributeList) {
                if (mapDPAtt.containsKey(atr.canonicalId)) {
                    final ps_catalog_flat_rates_dp_attribute__c cat = mapDPAtt.get(atr.canonicalId);

                    if (cat.gf_psc_fr_dynamic_pricing_id__c != null && cat.gf_psc_fr_dynamic_pricing_id__r.gf_dp_item_crscls_ind_type__c) {
                        final DP_Clasification_Wrapper.crossDPAtt cross = new DP_Clasification_Wrapper.crossDPAtt();
                        cross.name = cat.gf_psc_atribute_id__r.Name;
                        cross.value = atr.value;
                        final List<String> decimalLstValues = new List<String>{'Number', 'Currency', 'Percent'};
                        if (decimalLstValues.contains(atr.valueTypeName)) {
                            final Integer lengthValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + atr.destinyApiName).getDescribe().getPrecision();
                            final Integer decimalValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + atr.destinyApiName).getDescribe().getScale();
                            cross.lengthValue = String.valueOf(lengthValue);
                            cross.decimalValue = String.valueOf(decimalValue);
                            cross.isDecimal = true;
                        } else {
                            cross.isDecimal = false;
                        }
                        crossList.add(cross);

                    } else {
                        final Map<String,Object> mapObj = new Map<String,Object>();
                        mapObj.put('flatDp',flatDp);
                        mapObj.put('cat',cat);
                        mapObj.put('headers',headers);
                        mapObj.put('table',table);
                        mapObj.put('mapAux',mapAux);
                        mapObj.put('mapStr',mapStr);
                        final Map<String,Object> mapTable =  fillTable(mapObj);
                        table = (DP_Clasification_Wrapper.NonCrossDPTable)mapTable.get('table');
                        mapAux = (Map<String,List<String>>)mapTable.get('mapAux');
                        mapStr = (Map<String,Map<String,List<String>>>)mapTable.get('mapStr');
                    }
                }
            }
        }
        List<DP_Clasification_Wrapper.classification> clasList = getClasList(mapStr);

        table.classificationsList = clasList;
        flatWrapper.NonCrossDPTable = table;
        flatWrapper.crossDPAttList = crossList;

        return flatWrapper;
    }
    /**
      * @description Fills the table
      * @param FlatRates_Wrapper.FlatRatesDP flatDp
      * @param ps_catalog_flat_rates_dp_attribute__c cat
      * @param List<String> headers
      * @param DP_Clasification_Wrapper.NonCrossDPTable table
      * @param  Map<String, List<String>> mapAux
      * @param Map<String, Map<String, List<String>>> mapStr
      * @return  Map<String,Object>
      */
    public static Map<String,Object> fillTable(Map<String,Object> mapObj) {
    final FlatRates_Wrapper.FlatRatesDP flatDp = (FlatRates_Wrapper.FlatRatesDP)mapObj.get('flatDp');
    final ps_catalog_flat_rates_dp_attribute__c cat = (ps_catalog_flat_rates_dp_attribute__c)mapObj.get('cat');
    final Map<String,String> headers = (Map<String,String>) mapObj.get('headers');
    final DP_Clasification_Wrapper.NonCrossDPTable table = (DP_Clasification_Wrapper.NonCrossDPTable)mapObj.get('table');
    final Map<String, List<String>> mapAux = (Map<String, List<String>>) mapObj.get('mapAux');
    final Map<String,Map<String, List<String>>> mapStr = (Map<String,Map<String, List<String>>>) mapObj.get('mapStr');

        Map<String,Object> mapToRet = new Map<String,Object> ();
        Map<String, List<String>> mapToAux = new Map<String, List<String>> ();
        headers.put(cat.cuco__gf_psc_atribute_id__r.cuco__gf_psc_attribute_id__c, cat.cuco__gf_psc_atribute_id__r.Name);

        if (mapStr.containsKey(cat.gf_psc_fr_dynamic_pricing_id__r.gf_dp_item_classification_desc__c)) {
            mapToAux = mapAux;
            mapToAux = getTableValues(mapAux, headers, cat, flatDp.dpAttributeList);
            mapStr.put(cat.gf_psc_fr_dynamic_pricing_id__r.gf_dp_item_classification_desc__c, mapToAux);
        } else {
            mapToAux = getTableValues(mapToAux, headers, cat, flatDp.dpAttributeList);
            mapStr.put(cat.gf_psc_fr_dynamic_pricing_id__r.gf_dp_item_classification_desc__c, mapToAux);
        }
        if (!headers.values().isEmpty()) {
            table.headersList = headers.values();
        }
        mapToRet.put('table', table);
        mapToRet.put('mapAux', mapToAux);
        mapToRet.put('mapStr', mapStr);
        return mapToRet;
    }
    /**
      * @description Get Classification list for the wrapper
      * @param Map<String,Map<String, List<String>>> mapStr : Map with Map and list of String
      * @param Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt : Map with catalog flat rates dp attributes
      * @return List<DP_Clasification_Wrapper.classification>
      */
    public static List<DP_Clasification_Wrapper.classification> getClasList(Map<String,Map<String, List<String>>> mapStr) {
        final List<DP_Clasification_Wrapper.classification> clasList = new List<DP_Clasification_Wrapper.classification>();
        for (String key : mapStr.keySet()){
            final Map<String, List<String>> mapAux2 = mapStr.get(key);
            final List<DP_Clasification_Wrapper.nonCrossDP> nonCrossDPList = new List<DP_Clasification_Wrapper.nonCrossDP>();
            final DP_Clasification_Wrapper.classification clasf = new DP_Clasification_Wrapper.classification();
            clasf.name = key;
            for (String name : mapAux2.keySet()) {
                final DP_Clasification_Wrapper.nonCrossDP nonCross = new DP_Clasification_Wrapper.nonCrossDP();
                List<DP_Clasification_Wrapper.NonCrossAttb> attValuesList = new List<DP_Clasification_Wrapper.NonCrossAttb>();
                List<String> lstAuxWithComma = mapAux2.get(name);
                Integer blockNumber = 0;
                for (Integer i = 0; i<(lstAuxWithComma.size()/3); i++) {
                    DP_Clasification_Wrapper.NonCrossAttb newAttb = new DP_Clasification_Wrapper.NonCrossAttb();
                    newAttb.name = name;
                    newAttb.value = lstAuxWithComma[blockNumber];
                    newAttb.decimalValue = lstAuxWithComma[blockNumber+1];
                    newAttb.isDecimal = Boolean.valueOf(lstAuxWithComma[blockNumber+2]);
                    blockNumber = blockNumber + 3;
                    attValuesList.add(newAttb);
                }
                nonCross.attValuesList = attValuesList;
                nonCrossDPList.add(nonCross);
            }
            clasf.nonCrossDPList = nonCrossDPList;
            clasList.add(clasf);
        }
        return clasList;
    }
    /**
      * @description Fill in the values for the table
      * @param Map<String, List<String>> mapAux, List<String> headers : headers for the table
      * @param ps_catalog_flat_rates_dp_attribute__c crDpAtt
      * @param List<FlatRates_Wrapper.DPAttribute> wrapper
      * @return Map<String, List<String>>
      */
    public static Map<String, List<String>> getTableValues(Map<String, List<String>> mapAux, Map<String,String> headers, ps_catalog_flat_rates_dp_attribute__c crDpAtt, List<FlatRates_Wrapper.DPAttribute> wrapper) {
        final List<String> attList = new List<String>();
        Map <String,Integer> mapPosition = new Map <String,Integer>();
        List<String> keys = new List<String>();
        keys.addAll(headers.keySet());
        for (Integer i=0; i< keys.size();i++) {
            attList.add(' ');
            attList.add(' ');
            attList.add(' ');
            mapPosition.put(keys[i],i);
        }
        for (FlatRates_Wrapper.DPAttribute flat : wrapper) {
            if (flat.canonicalId == crDpAtt.gf_psc_dynamic_pricing_atrb_id__c && headers.containsKey(crDpAtt.gf_psc_atribute_id__r.gf_psc_attribute_id__c)) {
                Integer position;
                position = mapPosition.get(crDpAtt.gf_psc_atribute_id__r.gf_psc_attribute_id__c);
                attList.set(position*3,flat.value);
                attList.set(position*3+1,flat.decimalValue);
                attList.set(position*3+2,String.valueOf(flat.isDecimal));
            }
        }
        if (mapAux.containsKey(crDpAtt.gf_psc_fr_dynamic_pricing_id__r.Name)) {
            List<String> auxList = mapAux.get(crDpAtt.gf_psc_fr_dynamic_pricing_id__r.Name);
            for(Integer i = 0; i< auxList.size();i++){
                if(auxList[i] == ' '){
                    auxList[i] = attList[i];
                }
            }
            mapAux.put(crDpAtt.gf_psc_fr_dynamic_pricing_id__r.Name, auxList);
        } else {
            mapAux.put(crDpAtt.gf_psc_fr_dynamic_pricing_id__r.Name, attList);
        }
        return mapAux;
    }
    /**
      * @description Get the table headers
      * @param List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList : List with flat rates dp
      * @param Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt : Map with catalog flat rates dp attributes
      * @returnMap<String,String>
      */
    public static Map<String,String> getHeaders(List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList, Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt){
        Map<String,String> headers = new Map<String,String>();
        for (FlatRates_Wrapper.FlatRatesDP flatDp : flatRatesDPList){
            flatDp.dpAttributeList.sort();
            for (FlatRates_Wrapper.DPAttribute atr : flatDp.dpAttributeList){
                if (mapDPAtt.containsKey(atr.canonicalId)){
                    ps_catalog_flat_rates_dp_attribute__c cat = mapDPAtt.get(atr.canonicalId);
                    if (cat.gf_psc_fr_dynamic_pricing_id__c != null && !cat.gf_psc_fr_dynamic_pricing_id__r.gf_dp_item_crscls_ind_type__c){
                        headers.put(cat.gf_psc_atribute_id__r.gf_psc_attribute_id__c,cat.gf_psc_atribute_id__r.Name);
                    }
                }
            }
        }
        return headers;
    }
}