/**
* ────────────────────────────────────────────────────────────────────
* Catalog_Helper
* ────────────────────────────────────────────────────────────────────
* @author      Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-24
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Catalog_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Catalog_Helper() {}

    /**
    * @description constructor getStandardValues
    * @param
    *@return String
    */
    public static String getStandardValues () {
        final List<cuco__ps_catalog_condition_standard__c> catalogConditions = getActiveStandardValues();
        String jsonToReturn;
        List<Object> lst = new List<Object>();
        Map<String,Object> mapCondition;
        if(!catalogConditions.isEmpty()){
            String auxMapping ;
            for(cuco__ps_catalog_condition_standard__c ccStandard : catalogConditions){
                String termMapping = '{"id":"#LABEL#","value":{"standard":"#VAR#","min":"#MIN#","max":"#MAX#"}}';
                auxMapping = notNulls('#LABEL#', ccStandard.gf_psc_condition_attribute_id__r.gf_psc_condition_attribute_id__c, termMapping);
                auxMapping = notNulls('#VAR#', ccStandard.cuco__gf_cond_atrb_standard_val_name__c , auxMapping);
                auxMapping = notNulls('#MAX#', ccStandard.cuco__gf_cond_atrb_max_val_name__c, auxMapping);
                auxMapping = notNulls('#MIN#', ccStandard.cuco__gf_cond_atrb_min_val_name__c, auxMapping);
                if (auxMapping != null) {
                    mapCondition = (Map<String,Object>) JSON.deserializeUntyped(auxMapping);
                    lst.add(mapCondition);
                }
            }
        }
        jsonToReturn=JSON.serialize(lst);
        return jsonToReturn;
    }

    /**
    * @description method to reduce complexity
    * @param
    *@return String
    */
    public static String notNulls (String label, String value, String termMapping) {
        String auxMapping = termMapping.replace(label,value == null ? '' : value);
        return auxMapping;
    }

    /**
    * @description active records from selector
    * @return List<cuco__ps_catalog_condition_standard__c>
    */
    public static List<cuco__ps_catalog_condition_standard__c> getActiveStandardValues() {
        final PsCatalogConditionStandard_Selector selector = new PsCatalogConditionStandard_Selector(true);
        return selector.selectActive();
    }

}