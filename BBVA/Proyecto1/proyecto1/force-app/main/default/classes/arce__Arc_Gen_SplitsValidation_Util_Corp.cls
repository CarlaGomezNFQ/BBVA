/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SplitsValidation_Util_Corp
* @Author   jose.hijar.contractor@bbva.com
* @Date     Created: 2020/10/15
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Logic class for Geographic and Activity splits weight validation
* ------------------------------------------------------------------------------------------------
* @Changes
* |2020/10/15 Class creation
* |2021-11-01 saimassimilianno.jordana.contractor@bbva.com
*             Duplicated validation added to activitySubIndWValidation meth0d.
* ------------------------------------------------------------------------------------------------
*/
public class Arc_Gen_SplitsValidation_Util_Corp {
    /**
    * --------------------------------------------------------------------------------------
    * @description private constructor for avoiding sonar issues
    **/
    private Arc_Gen_SplitsValidation_Util_Corp() {}

    /**
    * @Description: response format for validation.
    */
    public class ValidationWrapper {
        /**
        * @Description: Status of the validation.
        */
        @AuraEnabled
        public Boolean validated {get;set;}
        /**
        * @Description: Message if the validation fails
        */
        @AuraEnabled
        public String errorMessg {get;set;}

        /**
        * @Description: Constructor.
        */
        public ValidationWrapper() {
            this.validated = true;
            this.errorMessg = '';
        }
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Author   jose.hijar.contractor@bbva.com
    * @description validates Activity split weight
    * @param lstRecords List<Object> records to validate
    * @return returns a boolean indicating whether pass the validation or not
    * @example Arc_Gen_SplitsValidation_Util_Corp.activitySubIndWValidation(List<Object> lstRecords)
    **/
    public static ValidationWrapper activitySubIndWValidation(List<Object> lstRecords) {
        final ValidationWrapper ret = new ValidationWrapper();
        Decimal subIndustryWeight=0;

        if(!lstRecords.isEmpty()) {
            final Set<String> noDuplicates = new Set<String>();
            for (Object activity : lstRecords) {

                String strJson = JSON.serialize(activity);
                Map<String, Object> mapObj = (Map<String, Object>)JSON.deserializeUntyped(strJson);

                if(mapObj.get('arce__gf_subindustry_weight_per__c')!=null) {
                    subIndustryWeight+=Decimal.valueOf(String.valueOf(mapObj.get('arce__gf_subindustry_weight_per__c')));
                }

                final String keyToAdd = String.isNotBlank((String) mapObj.get('arce__Country__c')) ? (String) mapObj.get('arce__sector_id__c') + (String) mapObj.get('arce__Template_type__c') + (String)mapObj.get('arce__Country__c') : (String) mapObj.get('arce__sector_id__c') + (String) mapObj.get('arce__gf_subactivity_id__c') + (String) mapObj.get('arce__Template_type__c');
                if(noDuplicates.add(keyToAdd) == false) {
                    ret.validated = false;
                    ret.errorMessg = Label.Arc_Gen_ActivitySubIndDupl_error;
                    break;
                }
            }
        }
        if(subIndustryWeight>100) {
            ret.validated = false;
            ret.errorMessg = Label.Arc_Gen_ActivitySubIndW_error;
        }

        return ret;
    }

    /**
    * --------------------------------------------------------------------------------------
    * @Author   jose.hijar.contractor@bbva.com
    * @description validates Geographic split weight
    * @param lstRecords List<Object> records to validate
    * @return returns a boolean indicating whether pass the validation or not
    * @example Arc_Gen_SplitsValidation_Util_Corp.geoGeographicWeightValidation(List<Object> lstRecords)
    **/
    public static Boolean geoGeographicWeightValidation(List<Object> lstRecords) {
        Boolean ret=true;
        Decimal geographicWeight=0;

        if(!lstRecords.isEmpty()) {
            for (Object geographicSplit : lstRecords) {

                String strJson = JSON.serialize(geographicSplit);
                Map<String, Object> mapObj = (Map<String, Object>)JSON.deserializeUntyped(strJson);

                if(mapObj.get('arce__gf_geography_weight_per__c')!=null) {
                    geographicWeight+=Decimal.valueOf(String.valueOf(mapObj.get('arce__gf_geography_weight_per__c')));
                }
            }
        }
        if(geographicWeight>100) {
            ret=false;
        }

        return ret;
    }
}