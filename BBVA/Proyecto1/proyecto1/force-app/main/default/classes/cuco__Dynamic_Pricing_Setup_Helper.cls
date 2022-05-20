/**
* ────────────────────────────────────────────────────────────────────
* Dynamic_Pricing_Setup_Helper
* Controller helper for Dynamic_Pricing_Setup_Ctrl controller
* ────────────────────────────────────────────────────────────────────
* @author     Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-19
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Dynamic_Pricing_Setup_Helper {

    // Private constructor to avoid sonar err
    @TestVisible
    private Dynamic_Pricing_Setup_Helper() {}

    /**
    * @description main logic for creating data to show
    * @param flatRateId : id the profitability analysis flat rate DP
    * @return Map<String, Object>
    */
    public static Map<String,Object> formatDataToDynamicSetupForm(List<ps_catalog_flat_rates_dp_attribute__c> psCatalogAttDP, List<ps_catalog_flat_rates_dp__c> psCatalogRates, Map<Id, profitability_analysis_flat_rates_dp__c> mapFlatRate) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // 1. For each ps_catalog_flat_rates_dp__c, get related ps_catalog_flat_rates_dp_attribute__c records
        final Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>> mapAttributes = new Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>>();
        final Set<String> setDPAttCross = new Set<String>();
        final Map<Id, DynamicNonCross.HeaderAttribute> mapAttNonCross = new Map<Id, DynamicNonCross.HeaderAttribute>();
        for (ps_catalog_flat_rates_dp_attribute__c attb : psCatalogAttDP) {
            if (mapAttributes.get(attb.cuco__gf_psc_fr_dynamic_pricing_id__c) == null) {
                final List<ps_catalog_flat_rates_dp_attribute__c> lstAttb = new List<ps_catalog_flat_rates_dp_attribute__c>();
                lstAttb.add(attb);
                mapAttributes.put(attb.cuco__gf_psc_fr_dynamic_pricing_id__c, lstAttb);
            } else {
                final List<ps_catalog_flat_rates_dp_attribute__c> lstAttb = mapAttributes.get(attb.cuco__gf_psc_fr_dynamic_pricing_id__c);
                lstAttb.add(attb);
                mapAttributes.put(attb.cuco__gf_psc_fr_dynamic_pricing_id__c, lstAttb);
            }

            // Check if is Cross or NonCross
            if(attb.cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_dp_item_crscls_ind_type__c) {
                setDPAttCross.add(attb.gf_psc_atribute_id__r.Name);
            } else {
                if (mapAttNonCross.get(attb.gf_psc_atribute_id__c) == null) {
                    final DynamicNonCross.HeaderAttribute newHeaderAttb = new DynamicNonCross.HeaderAttribute();
                    newHeaderAttb.id = attb.gf_psc_atribute_id__c;
                    newHeaderAttb.name = attb.gf_psc_atribute_id__r.Name;
                    mapAttNonCross.put(attb.gf_psc_atribute_id__c, newHeaderAttb);
                }
            }
        }

        final Map<String, DynamicNonCross.DynamicClassification> mapNonCross = new Map<String, DynamicNonCross.DynamicClassification>();
        final List<DynamicNonCross.CrossAttributes> lstCross = new List<DynamicNonCross.CrossAttributes>();
        for (ps_catalog_flat_rates_dp__c psCatRate : psCatalogRates) {
            // Separate by cross reference
            if (psCatRate.gf_dp_item_crscls_ind_type__c) {
                lstCross.addAll(getCrossValue(psCatRate, mapFlatRate, mapAttributes));
            } else {
                final Map<String, Object> mapNonCrossParams = new Map<String, Object>();
                mapNonCrossParams.put('psCatRate', psCatRate);
                mapNonCrossParams.put('mapFlatRate', mapFlatRate);
                mapNonCrossParams.put('mapAttributes', mapAttributes);
                mapNonCrossParams.put('mapNonCross', mapNonCross);
                mapNonCrossParams.put('mapAttNonCross', mapAttNonCross);
                mapNonCross.put(psCatRate.cuco__gf_dp_item_classification_desc__c, getNonCrossValues(mapNonCrossParams));
            }
        }

        retMap.put('mapNonCross', mapNonCross.values());
        retMap.put('lstCross', lstCross);
        retMap.put('setDPAttCross', setDPAttCross);
        retMap.put('mapAttNonCross', mapAttNonCross.values());
        return retMap;
    }

    /**
    * @description Helper method to handle cross values
    * @param psCatRate : Current PS Cat flat Rate dp record
    * @param mapFlatRate : Map with middle table to extract related attbs
    * @param mapAttributes : Map with attbs
    * @return List<DynamicNonCross.CrossAttributes>, with cross values
    */
    private static List<DynamicNonCross.CrossAttributes> getCrossValue(ps_catalog_flat_rates_dp__c psCatRate, Map<Id, profitability_analysis_flat_rates_dp__c> mapFlatRate, Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>> mapAttributes) {
        final List<DynamicNonCross.CrossAttributes> lstCrossAttb = new List<DynamicNonCross.CrossAttributes>();
        if (mapFlatRate.get(psCatRate.Id) == null) {
            final List<ps_catalog_flat_rates_dp_attribute__c> lstRelatedAttbs = mapAttributes.get(psCatRate.Id);
            for (ps_catalog_flat_rates_dp_attribute__c attb : lstRelatedAttbs) {
                final DynamicNonCross.CrossAttributes crossAttb = getNewAttbCrossValue(attb, psCatRate);
                lstCrossAttb.add(crossAttb);
            }
        } else {
            final profitability_analysis_flat_rates_dp__c currentProfAnalysisFlatRateDp = mapFlatRate.get(psCatRate.Id);
            final List<ps_catalog_flat_rates_dp_attribute__c> lstRelatedAttbs = mapAttributes.get(psCatRate.Id);
            for (ps_catalog_flat_rates_dp_attribute__c attb : lstRelatedAttbs) {
                final DynamicNonCross.CrossAttributes crossAttb = getNewAttbCrossValue(attb, psCatRate);
                crossAttb.value = String.valueOf(currentProfAnalysisFlatRateDp.get(attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c));
                crossAttb.flatId = currentProfAnalysisFlatRateDp.Id;
                lstCrossAttb.add(crossAttb);
            }
        }
        return lstCrossAttb;
    }

    /**
    * @description Helper method to handle non cross values
    * @param params : Map with needed info
    * @return DynamicNonCross.DynamicClassification, with non cross values
    */
    private static DynamicNonCross.DynamicClassification getNonCrossValues(Map<String, Object> params) {
        // Get values
        final ps_catalog_flat_rates_dp__c psCatRate = (ps_catalog_flat_rates_dp__c) params.get('psCatRate');
        final Map<Id, profitability_analysis_flat_rates_dp__c> mapFlatRate = (Map<Id, profitability_analysis_flat_rates_dp__c>) params.get('mapFlatRate');
        final Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>> mapAttributes = (Map<Id, List<ps_catalog_flat_rates_dp_attribute__c>>) params.get('mapAttributes');
        final Map<String, DynamicNonCross.DynamicClassification> mapNonCross = (Map<String, DynamicNonCross.DynamicClassification>) params.get('mapNonCross');
        final Map<Id, DynamicNonCross.HeaderAttribute> mapAttNonCross = (Map<Id, DynamicNonCross.HeaderAttribute>) params.get('mapAttNonCross');

        // Search by family
        DynamicNonCross.DynamicClassification classifitacionItem = new DynamicNonCross.DynamicClassification();
        if (mapNonCross.get(psCatRate.cuco__gf_dp_item_classification_desc__c) == null) {
            // Non family added
            classifitacionItem.name = psCatRate.cuco__gf_dp_item_classification_desc__c;
        } else {
            // Family added
            classifitacionItem = mapNonCross.get(psCatRate.cuco__gf_dp_item_classification_desc__c);
        }
        List<DynamicNonCross.DynamicCondition> lstDynamicCond = new List<DynamicNonCross.DynamicCondition>();
        if (classifitacionItem.lstDynamicCond != null) {
            lstDynamicCond = classifitacionItem.lstDynamicCond;
        }

        final List<DynamicNonCross.DynamicAttribute> lstDynamicAttbs = new List<DynamicNonCross.DynamicAttribute>();
        // No value
        if (mapFlatRate.get(psCatRate.Id) == null) {

            // Get attributes
            final List<ps_catalog_flat_rates_dp_attribute__c> lstRelatedAttbs = mapAttributes.get(psCatRate.Id);
            for (ps_catalog_flat_rates_dp_attribute__c attb : lstRelatedAttbs) {
                DynamicNonCross.DynamicAttribute newNotValueAttb = getNewAttbNonCrossValue(attb, mapAttNonCross);
                lstDynamicAttbs.add(newNotValueAttb);
            }

            // Get condition
            final DynamicNonCross.DynamicCondition newNotValueCondition = new DynamicNonCross.DynamicCondition();
            newNotValueCondition.name = psCatRate.Name;
            newNotValueCondition.lstDynamicAttb = lstDynamicAttbs;
            newNotValueCondition.idDynamicPricing = psCatRate.Id;
            lstDynamicCond.add(newNotValueCondition);

        } else {
            final profitability_analysis_flat_rates_dp__c currentProfAnalysisFlatRateDp = mapFlatRate.get(psCatRate.Id);

            // Get attributes
            final List<ps_catalog_flat_rates_dp_attribute__c> lstRelatedAttbs = mapAttributes.get(psCatRate.Id);
            for (ps_catalog_flat_rates_dp_attribute__c attb : lstRelatedAttbs) {
                DynamicNonCross.DynamicAttribute newValueAttb = getNewAttbNonCrossValue(attb, mapAttNonCross);
                newValueAttb.value = String.valueOf(currentProfAnalysisFlatRateDp.get(attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c));
                lstDynamicAttbs.add(newValueAttb);
            }

            // Get condition
            final DynamicNonCross.DynamicCondition newValueCondition = new DynamicNonCross.DynamicCondition();
            newValueCondition.idFlat = currentProfAnalysisFlatRateDp.Id;
            newValueCondition.idDynamicPricing = psCatRate.Id;
            newValueCondition.name = psCatRate.Name;
            newValueCondition.lstDynamicAttb = lstDynamicAttbs;
            lstDynamicCond.add(newValueCondition);
        }
        classifitacionItem.lstDynamicCond = lstDynamicCond;
        return classifitacionItem;
    }

    private static DynamicNonCross.CrossAttributes getNewAttbCrossValue(ps_catalog_flat_rates_dp_attribute__c attb, ps_catalog_flat_rates_dp__c psCatRate) {
        final DynamicNonCross.CrossAttributes crossAttb = new DynamicNonCross.CrossAttributes();
        crossAttb.name = attb.cuco__gf_psc_atribute_id__r.Name;
        crossAttb.valueType = attb.cuco__gf_psc_atribute_id__r.cuco__gf_attribute_value_type_name__c;
        crossAttb.apiName = attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c;
        crossAttb.id = attb.cuco__gf_psc_atribute_id__c;
        crossAttb.idDynamicPricing = psCatRate.Id;

        final List<String> decimalLst = new List<String>{'Number', 'Currency', 'Percent'};
        if (decimalLst.contains(attb.cuco__gf_psc_atribute_id__r.cuco__gf_attribute_value_type_name__c)) {
            final Integer lengthValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c).getDescribe().getPrecision();
            final Integer decimalValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c).getDescribe().getScale();
            crossAttb.maxLength = lengthValue;
            if (decimalValue > 0) {
                final String baseStr = '0.';
                crossAttb.step = baseStr.rightPad(decimalValue + 1, '0') + '1';
            }
        }
        return crossAttb;
    }
    /**
    * @description Auxiliar methods to create new attribute value (Non cross)
    * @param attb : Attribute fields info
    * @param mapAttNonCross : Attributes related to each row on form
    * @return DynamicNonCross.DynamicAttribute, with new attb
    */
    private static DynamicNonCross.DynamicAttribute getNewAttbNonCrossValue(ps_catalog_flat_rates_dp_attribute__c attb, Map<Id, DynamicNonCross.HeaderAttribute> mapAttNonCross) {
        final DynamicNonCross.DynamicAttribute newValueAttb = new DynamicNonCross.DynamicAttribute();
        newValueAttb.name = attb.cuco__gf_psc_atribute_id__r.Name;
        newValueAttb.valueType = attb.cuco__gf_psc_atribute_id__r.cuco__gf_attribute_value_type_name__c;
        newValueAttb.apiName = attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c;
        newValueAttb.id = attb.cuco__gf_psc_atribute_id__c;
        newValueAttb.position = new List<Id>(mapAttNonCross.keySet()).indexOf(attb.cuco__gf_psc_atribute_id__c);

        final List<String> decimalLst = new List<String>{'Number', 'Currency', 'Percent'};
        if (decimalLst.contains(attb.cuco__gf_psc_atribute_id__r.cuco__gf_attribute_value_type_name__c)) {
            final Integer lengthValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c).getDescribe().getPrecision();
            final Integer decimalValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + attb.cuco__gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c).getDescribe().getScale();
            newValueAttb.maxLength = lengthValue;
            if (decimalValue > 0) {
                final String baseStr = '0.';
                newValueAttb.step = baseStr.rightPad(decimalValue + 1, '0') + '1';
            }
        }
        return newValueAttb;
    }

    /**
    * @description Do save actions with the dynamic setup form values
    * @param strValues : string with info to operate
    * @param profAnFlatRateId : id of the profitability analysis flat rate DP
    * @param mapAttbId2Api : Map with attribute and api name to save related
    * @return Map<String, Object>, with DML ops response
    */
    public static Map<String,Object> doSaveActions(String strValues, String profAnFlatRateId, Map<Id, String> mapAttbId2Api) {
        final Map<String,Object> mapReturn = new Map<String,Object>();
        mapReturn.put('success', true);
        final Map<String, Object> flatRatesNonCross = (Map<String, Object>)JSON.deserializeUntyped(strValues);
        final List<Object> lst2InsertNonCross = (List<Object>) flatRatesNonCross.get('lst2Insert');
        final List<Object> lst2UpdateNonCross = (List<Object>) flatRatesNonCross.get('lst2Update');
        final List<Object> lst2DeleteNonCross = (List<Object>) flatRatesNonCross.get('lst2Delete');

        List<cuco__profitability_analysis_flat_rates_dp__c> lstPAFRdp2Upsert = new List<cuco__profitability_analysis_flat_rates_dp__c>();

        // New records to insert
        lstPAFRdp2Upsert.addAll(Dynamic_Pricing_Setup_Helper.getInsertFlatRatesDPRecords(lst2InsertNonCross, profAnFlatRateId, mapAttbId2Api));

        // Records to update
        lstPAFRdp2Upsert.addAll(Dynamic_Pricing_Setup_Helper.getUpdateFlatRatesDPRecords(lst2UpdateNonCross, mapAttbId2Api));

        // Records to delete
        final List<cuco__profitability_analysis_flat_rates_dp__c> lstPAFRdp2Delete = new List<cuco__profitability_analysis_flat_rates_dp__c>();
        for (Object obj2Delete : lst2DeleteNonCross) {
            final Map<String, Object> mapObj2Delete = (Map<String, Object>) obj2Delete;
            lstPAFRdp2Delete.add(new cuco__profitability_analysis_flat_rates_dp__c(Id = (Id) mapObj2Delete.get('flatId')));
        }

        // DML Ops
        if (!lstPAFRdp2Upsert.isEmpty()) {
            final Utils.DML_Wrapper retUpsert = PAPackage_Service.upsertPAFlatDP(lstPAFRdp2Upsert);
            mapReturn.put('success', retUpsert.isSuccess);
            mapReturn.put('errMessage', retUpsert.lstErrMessage.toString());
        }

        if (!lstPAFRdp2Delete.isEmpty() && (Boolean) mapReturn.get('success')) {
            final Utils.DML_Wrapper retDelete = PAPackage_Service.deletePAFlatDP(lstPAFRdp2Delete);
            mapReturn.put('success', retDelete.isSuccess);
            mapReturn.put('errMessage', retDelete.lstErrMessage.toString());
        }
        return mapReturn;
    }

    /**
    * @description Get list with new records to insert
    * @param lst2InsertNonCross : List of new records to insert
    * @param profAnFlatRateId : Id of the related prof analysis flat rate id
    * @param mapAttbId2Api : Map with attribute and api name to save related
    * @return List<cuco__profitability_analysis_flat_rates_dp__c>, with values to save
    */
    private static List<cuco__profitability_analysis_flat_rates_dp__c> getInsertFlatRatesDPRecords(List<Object> lst2InsertNonCross, String profAnFlatRateId, Map<Id, String> mapAttbId2Api) {
        final List<cuco__profitability_analysis_flat_rates_dp__c> lstNewFlatRates = new List<cuco__profitability_analysis_flat_rates_dp__c>();
        for (Object obj2InsertNonCross : lst2InsertNonCross) {
            final Map<String, Object> mapObj2InsertNonCross = (Map<String, Object>) obj2InsertNonCross;
            final List<Object> lstAttb = (List<Object>) mapObj2InsertNonCross.get('attb');
            final String dynamicPricingId = (String) mapObj2InsertNonCross.get('dynamicPricingId');
            profitability_analysis_flat_rates_dp__c paFlatRateDp = new profitability_analysis_flat_rates_dp__c();
            paFlatRateDp.gf_pa_flat_rate_id__c = profAnFlatRateId;
            paFlatRateDp.gf_fr_dynamic_pricing_item_id__c = dynamicPricingId;
            for (Object objAttb : lstAttb) {
                String apiName;
                String value;
                final Map<String, Object> mapAttb = (Map<String, Object>) objAttb;
                value = (String) mapAttb.get('value');
                for (Id attbId : mapAttbId2Api.keySet()) {
                    if (attbId == (Id) mapAttb.get('id')) {
                        apiName = mapAttbId2Api.get(attbId);
                    }
                }
                paFlatRateDp = Dynamic_Pricing_Setup_Helper.setAttributeFieldsValueFlat(apiName, value, paFlatRateDp);
            }
            lstNewFlatRates.add(paFlatRateDp);
        }
        return lstNewFlatRates;
    }

    /**
    * @description Get list with new records to update
    * @param lst2UpdateNonCross : List of new records to update
    * @param mapAttbId2Api : Map with attribute and api name to save related
    * @return List<cuco__profitability_analysis_flat_rates_dp__c>, with values to save
    */
    private static List<cuco__profitability_analysis_flat_rates_dp__c> getUpdateFlatRatesDPRecords(List<Object> lst2UpdateNonCross, Map<Id, String> mapAttbId2Api) {
        final List<cuco__profitability_analysis_flat_rates_dp__c> lstUpdateFlatRates = new List<cuco__profitability_analysis_flat_rates_dp__c>();
        for (Object obj2Update : lst2UpdateNonCross) {
            final Map<String, Object> mapObj2Update = (Map<String, Object>) obj2Update;
            final List<Object> lstAttb = (List<Object>) mapObj2Update.get('attb');
            final String flatId = (String) mapObj2Update.get('flatId');
            profitability_analysis_flat_rates_dp__c paFlatRateDp = new profitability_analysis_flat_rates_dp__c();
            paFlatRateDp.Id = flatId;
            for (Object objAttb : lstAttb) {
                String apiName;
                String value;
                final Map<String, Object> mapAttb = (Map<String, Object>) objAttb;
                value = (String) mapAttb.get('value');
                for (Id attbId : mapAttbId2Api.keySet()) {
                    if (attbId == (Id) mapAttb.get('id')) {
                        apiName = mapAttbId2Api.get(attbId);
                    }
                }
                paFlatRateDp = Dynamic_Pricing_Setup_Helper.setAttributeFieldsValueFlat(apiName, value, paFlatRateDp);
            }
            lstUpdateFlatRates.add(paFlatRateDp);
        }
        return lstUpdateFlatRates;
    }

    /**
    * @description Helper method to set dynamically falues from attributes to conditions
    * @param apiName : Api name of the field to fill
    * @param value : Value of the field to fill
    * @param paFlatRateDp: Current record to fill with new values
    * @return profitability_analysis_flat_rates_dp__c, fill with the new values
    */
    private static profitability_analysis_flat_rates_dp__c  setAttributeFieldsValueFlat(String apiName, String value, profitability_analysis_flat_rates_dp__c paFlatRateDp) {
        if (value == '' || value == null) {
            paFlatRateDp.put('cuco__' + apiName, null);
        } else {
            Schema.SObjectType schemaType = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c');
            Schema.DescribeSObjectResult schemaSObjectResult = schemaType.getDescribe();
            Schema.DescribeFieldResult fieldResult = schemaSObjectResult.fields.getMap().get(String.valueOf('cuco__' + apiName)).getDescribe();
            final String currentType = String.valueOf(fieldResult.getType());
            switch on currentType {
                when 'CURRENCY', 'DECIMAL', 'PERCENT' {
                    paFlatRateDp.put('cuco__' + apiName, Decimal.valueof(value));
                }
                when 'DOUBLE' {
                    paFlatRateDp.put('cuco__' + apiName, Double.valueof(value));
                }
                when 'BOOLEAN' {
                    paFlatRateDp.put('cuco__' + apiName, Boolean.valueof(value));
                }
                when else {
                    paFlatRateDp.put('cuco__' + apiName,  String.valueof(value));
                }
            }
        }
        return paFlatRateDp;
    }
}