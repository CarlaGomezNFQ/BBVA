/**
* ────────────────────────────────────────────────────────────────────
* ValidationsCond_Helper
* Class with various methods to validate input condition's values
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
global class ValidationsCond_Helper {

    /**
    * @description get the catalog conditions information.
    * @param inputCondList : input conditions to validate
    * @return Map<Id,ps_catalog_condition__c>
    */
    global static Map<Id,cuco__ps_catalog_condition__c> getCondDetails(ConditionsValidationInput_Wrapper inputCondList) {

        final Map<Id,cuco__ps_catalog_condition__c> condMap = new Map<Id,cuco__ps_catalog_condition__c>();

        final Set<Id> inputCondSet = new Set<Id>();

        if(inputCondList.conditions != null ){
            for(ConditionsValidationInput_Wrapper.Condition inputCond : inputCondList.conditions) {
                inputCondSet.add(inputCond.id);
            }
        }

        if(inputCondSet != null && inputCondSet.size()>0) {
            final PsCatalogCondition_Selector psCatConSelector = new PsCatalogCondition_Selector(true);
            final List<cuco__ps_catalog_condition__c> catCondList = psCatConSelector.selectCatalogConditionsFromIds(inputCondSet);

            for(cuco__ps_catalog_condition__c catCond : catCondList) {
                condMap.put(catCond.Id, catCond);
            }
        }

        return condMap;
    }

    /**
    * @description get the catalog condition attributes information.
    * @param conditionsIdsSet : conditions id set
    * @return Map<Id,cuco__ps_catalog_condition_attribute__c>
    */
    global static Map<String,cuco__ps_catalog_condition_attribute__c> getCatCondAtt(Set<Id> conditionsIdsSet) {

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = new Map<String,cuco__ps_catalog_condition_attribute__c>();

        final PsCatalogConditionAttribute_Selector catCondAttSelector = new PsCatalogConditionAttribute_Selector(true);
        final List<cuco__ps_catalog_condition_attribute__c> catCondAttList = catCondAttSelector.selectConditionAttributesFromConditionIds(conditionsIdsSet);

        for(cuco__ps_catalog_condition_attribute__c catCondAtt :catCondAttList) {
            condAttMap.put(catCondAtt.cuco__gf_psc_condition_attribute_id__c,catCondAtt);
        }

        return condAttMap;
    }

    /**
    * @description completes the input conditions validations with the catalog information
    * @param inputCondList : input conditions to validate
    * @param condDetailsMap : conditions catalog information
    * @return Map<String,Map<String,String>>
    */
    global static Map<String,Map<String,String>> getAttributesByCondition(ConditionsValidationInput_Wrapper inputCondList, Map<Id,cuco__ps_catalog_condition__c > condDetailsMap, Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap) {

        final Map<String,Map<String,String>> attByCondMap = new Map<String,Map<String,String>>();

        for(ConditionsValidationInput_Wrapper.Condition inputCond : inputCondList.conditions) {

            final Map<String,String> attValueMap = new Map<String,String>();
            for(ConditionsValidationInput_Wrapper.Attribute inputAtt: inputCond.attributes) {

                String proposedValue = null;
                if(!checkAttEmpty(inputAtt.proposed)) {
                    proposedValue = inputAtt.proposed;
                }

                attValueMap.put(condAttMap.get(inputAtt.id).cuco__gf_psc_atribute_id__r.cuco__gf_psc_attribute_id__c,proposedValue);

            }
            attByCondMap.put(condDetailsMap.get(inputCond.id).cuco__gf_psc_condition_id__c,attValueMap);

        }

        return attByCondMap;
    }

    /**
    * @description get the standard values information
    * @param condAttMap : conditions catalog information
    * @return Map<String,Map<String,cuco__ps_catalog_condition_standard__c>>
    */
    global static Map<String,Map<String,cuco__ps_catalog_condition_standard__c>> getStandardValues(Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap){

        final Map<String,Map<String,cuco__ps_catalog_condition_standard__c>>  stdCondByAttCondMap = new Map<String,Map<String,cuco__ps_catalog_condition_standard__c>>();

        final PsCatalogConditionStandard_Selector stdCondSelector = new PsCatalogConditionStandard_Selector(true);
        final List<cuco__ps_catalog_condition_standard__c> catStdCondList = stdCondSelector.selectActive();

        for(cuco__ps_catalog_condition_standard__c stdCond : catStdCondList){

            if(condAttMap.containsKey(stdCond.cuco__gf_psc_condition_attribute_id__r.cuco__gf_psc_condition_attribute_id__c)){

                if(stdCondByAttCondMap.containsKey(condAttMap.get(stdCond.cuco__gf_psc_condition_attribute_id__r.cuco__gf_psc_condition_attribute_id__c).cuco__gf_psc_condition_id__r.cuco__gf_psc_condition_id__c)) {
                    stdCondByAttCondMap.get(condAttMap.get(stdCond.cuco__gf_psc_condition_attribute_id__r.cuco__gf_psc_condition_attribute_id__c).cuco__gf_psc_condition_id__r.cuco__gf_psc_condition_id__c).put(condAttMap.get(stdCond.cuco__gf_psc_condition_attribute_id__r.cuco__gf_psc_condition_attribute_id__c).cuco__gf_psc_atribute_id__r.cuco__gf_psc_attribute_id__c,stdCond);
                } else {
                    final Map<String,cuco__ps_catalog_condition_standard__c> attStdMap = new Map<String,cuco__ps_catalog_condition_standard__c>();

                    attStdMap.put(condAttMap.get(stdCond.cuco__gf_psc_condition_attribute_id__r.cuco__gf_psc_condition_attribute_id__c).cuco__gf_psc_atribute_id__r.cuco__gf_psc_attribute_id__c,stdCond);

                    stdCondByAttCondMap.put(condAttMap.get(stdCond.cuco__gf_psc_condition_attribute_id__r.cuco__gf_psc_condition_attribute_id__c).cuco__gf_psc_condition_id__r.cuco__gf_psc_condition_id__c,attStdMap);
                }
            }
        }

        return stdCondByAttCondMap;
    }

    /**
    * @description get the catalog attributes information.
    * @return Map<String,cuco__ps_catalog_attribute__c>
    */
    global static Map<String,cuco__ps_catalog_attribute__c> getAttDetails() {

        final Map<String,cuco__ps_catalog_attribute__c> attMap = new Map<String,cuco__ps_catalog_attribute__c>();

        final PsCatalogAttribute_Selector catAttSelector = new PsCatalogAttribute_Selector(true);
        final List<cuco__ps_catalog_attribute__c> catAttList = catAttSelector.selectAllAttributes(100);

        for(cuco__ps_catalog_attribute__c catdAtt :catAttList) {
            attMap.put(catdAtt.cuco__gf_psc_attribute_id__c,catdAtt);
        }

        return attMap;
    }

    /**
    * @description check if the Boolean att are marked
    * @param valuePerAttMap: attributes proposed values
    * @param valuePerAttMap: attributes details on the catalog
    * @return List<String>
    */
    global static List<String> checkBooleanAtts(Map<String,String> valuePerAttMap, Map<String,ps_catalog_attribute__c> attDetailsMap) {

        final List<String> errorList = new List<String>();

        for(String att : valuePerAttMap.keySet()){
            if(attDetailsMap.containsKey(att) && attDetailsMap.get(att).cuco__gf_attribute_value_type_name__c == 'Checkbox' && valuePerAttMap.get(att) == 'false') {
                errorList.add(Label.cuco.cond_false_checkbox_error);
            }
        }

        return errorList;
    }

    /**
    * @description check if all the mandatory fields are informed
    * @param valuePerAttMap: attributes proposed values
    * @param condition: condition catalog information
    * @return List<String>
    */
    global static List<String> checkMandatoryAtts(Map<String,String> valuePerAttMap, cuco__ps_catalog_condition__c condition){

        List<String> errorList = new List<String>();

        if(condition.cuco__gf_psc_cond_prc_class_ind_type__c) {

            final String condFamily = condition.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c;

            if(condFamily == 'stock.domestic' || condFamily == 'stock.inter') {

                errorList = mandatoryStock(valuePerAttMap,errorList);

            } else {
                errorList = mandatoryNonStock(valuePerAttMap,errorList);
            }
        } else {

            Boolean missingField = false;
            for(String att : valuePerAttMap.keySet()){
                if(checkAttEmpty(valuePerAttMap.get(att))) {
                    missingField = true;
                }
            }

            if(missingField) {
                errorList.add(Label.cuco.cond_missing_fields_error);
            }
        }

        return errorList;
    }

    /**
    * @description check consistency between max and min values
    * @param valuePerAttMap: attributes proposed values
    * @return List<String>
    */
    global static List<String> checkMinVSMax(Map<String,String> valuePerAttMap){

        final List<String> errorList = new List<String>();

        if(valuePerAttMap.containsKey('max') && !checkAttEmpty(valuePerAttMap.get('max')) && valuePerAttMap.containsKey('min') && !checkAttEmpty(valuePerAttMap.get('min')) ) {
            if(Decimal.valueOf(valuePerAttMap.get('min')) > Decimal.valueOf(valuePerAttMap.get('max'))) {
                errorList.add(Label.cuco.cond_min_greater_max_error);
            }
        }

        return errorList;
    }

    /**
    * @description check consistency between max, min and type values on the np.transfer family
    * @param valuePerAttMap: attributes proposed values
    * @param condition: condition information in catalog
    * @param attPerCondMap: input family conditions
    * @return List<String>
    */
    global static List<String> checkTransferAtts(Map<String,String> valuePerAttMap, cuco__ps_catalog_condition__c condition, Map<String,Map<String,String>> attPerCondMap){

        final List<String> errorList = new List<String>();

        if(attPerCondMap.containsKey('np.transfer.mail.expenses') && condition.cuco__gf_psc_cond_prc_class_ind_type__c == true && !checkAttEmpty(valuePerAttMap.get('min')) && !checkAttEmpty(valuePerAttMap.get('type')) && !checkAttEmpty(valuePerAttMap.get('max'))) {

            if(Decimal.valueOf(valuePerAttMap.get('type')) == 0 && Decimal.valueOf(valuePerAttMap.get('max')) != Decimal.valueOf(valuePerAttMap.get('min')) ) {
                errorList.add(Label.cuco.cond_transfer_min_max_not_equal_error);
            } else if (Decimal.valueOf(valuePerAttMap.get('type')) != 0 && Decimal.valueOf(valuePerAttMap.get('max')) == Decimal.valueOf(valuePerAttMap.get('min')) ) {
                errorList.add(Label.cuco.cond_transfer_min_max_equal_error);
            }
        }

        return errorList;
    }

    /**
    * @description check values of the cards product conditions
    * @param valuePerAttMap: attributes proposed values
    * @param condition: condition information in catalog
    * @return List<String>
    */
    global static List<String> checkCardsAtts(Map<String,String> valuePerAttMap, cuco__ps_catalog_condition__c condition){

        final List<String> errorList = new List<String>();

        final Set<Decimal> cardBusValueSet = new Set<Decimal>{0,0.00,10,10.00,20,20.00,30,30.00,40,40.00};
        final Set<Decimal> cardCorpValueSet = new Set<Decimal>{0,0.00,20,20.00,40,40.00,60,60.00,80,80.00};
        final Set<Decimal> cardExpValueSet = new Set<Decimal>{0,0.00,3,3.00,6,6.00,9,9.00};
        final Set<Decimal> cardGiftValueSet = new Set<Decimal>{0,0.00,0.5,0.50,3,3.00,9,9.00};

        if(condition.cuco__gf_psc_condition_id__c == 'card.bbva.business' && !cardBusValueSet.contains(Decimal.valueOf(valuePerAttMap.get('fee'))) ) {
            errorList.add(Label.cuco.cond_card_business_value_error);
        }
        if(condition.cuco__gf_psc_condition_id__c == 'card.bbva.corporate' && !cardCorpValueSet.contains(Decimal.valueOf(valuePerAttMap.get('fee'))) ) {
            errorList.add(Label.cuco.cond_card_corporate_value_error);
        }
        if(condition.cuco__gf_psc_condition_id__c == 'card.bbva.others.express' && !cardExpValueSet.contains(Decimal.valueOf(valuePerAttMap.get('fee')))) {
            errorList.add(Label.cuco.cond_card_express_value_error);
        }
        if(condition.cuco__gf_psc_condition_id__c == 'card.bbva.others.gift' && !cardGiftValueSet.contains(Decimal.valueOf(valuePerAttMap.get('fee')))) {
            errorList.add(Label.cuco.cond_card_gift_value_error);
        }

        return errorList;
    }

    /**
    * @description check if the attributes values are in the allowed range
    * @param valuePerAttMap: attributes proposed values
    * @param standardValuesMap: standard values catalog information
    * @return List<String>
    */
    global static List<String> checkAttRange(Map<String,String> valuePerAttMap, Map<String,ps_catalog_condition_standard__c> standardValuesMap, Map<String,ps_catalog_attribute__c> attDetailsMap){

        final List<String> errorList = new List<String>();
        for(String att: valuePerAttMap.keySet()) {

            if(standardValuesMap != null && standardValuesMap.containsKey(att) && valuePerAttMap.containsKey(att) && !checkAttEmpty(valuePerAttMap.get(att))) {

                final Decimal attValue = Decimal.valueOf(valuePerAttMap.get(att));

                if(standardValuesMap.get(att).cuco__gf_cond_atrb_max_val_name__c != null &&  standardValuesMap.get(att).cuco__gf_cond_atrb_min_val_name__c != null){
                    final Decimal rangeMax = Decimal.valueOf(standardValuesMap.get(att).cuco__gf_cond_atrb_max_val_name__c);
                    final Decimal rangeMin = Decimal.valueOf(standardValuesMap.get(att).cuco__gf_cond_atrb_min_val_name__c);

                    if(attValue > rangeMax || attValue < rangeMin) {
                        final String rangeError = attDetailsMap.get(att).Name + ': ' + valuePerAttMap.get(att) + ' ' + Label.cuco.cond_range_value_error_1 + ' ' + standardValuesMap.get(att).cuco__gf_cond_atrb_min_val_name__c + ' ' + Label.cond_range_value_error_2 + ' ' + standardValuesMap.get(att).cuco__gf_cond_atrb_max_val_name__c;
                        errorList.add(rangeError);
                    }
                } else if (standardValuesMap.get(att).cuco__gf_cond_atrb_max_val_name__c != null) {
                    final Decimal rangeMax = Decimal.valueOf(standardValuesMap.get(att).cuco__gf_cond_atrb_max_val_name__c);

                    if(attValue > rangeMax) {
                        final String maxError = attDetailsMap.get(att).Name + ': ' + valuePerAttMap.get(att) + ' ' + Label.cuco.cond_range_max_error + ' ' + standardValuesMap.get(att).cuco__gf_cond_atrb_max_val_name__c;
                        errorList.add(maxError);
                    }

                } else if (standardValuesMap.get(att).cuco__gf_cond_atrb_min_val_name__c != null) {
                    final Decimal rangeMin = Decimal.valueOf(standardValuesMap.get(att).cuco__gf_cond_atrb_min_val_name__c);

                    if(attValue < rangeMin) {
                        final String minError = attDetailsMap.get(att).Name + ': ' + valuePerAttMap.get(att) + ' ' + Label.cuco.cond_range_min_error + ' ' + standardValuesMap.get(att).cuco__gf_cond_atrb_min_val_name__c;
                        errorList.add(minError);
                    }
                }

            }

        }

        return errorList;
    }

    /**
    * @description check if an attribute value is empty
    * @param attValue: value to evaluate
    * @return Boolean
    */
    private static Boolean checkAttEmpty(String attValue) {

        Boolean isEmpty = true;

        if(attValue != null && attValue != '') {
            isEmpty = false;
        }

        return isEmpty;
    }
    /**
    * @description check mandatory attributes for Stock
    * @param valuePerAttMap: value to evaluate
    * @param errorList: inital error List
    * @return List<String>
    */
    private static List<String> mandatoryStock(Map<String,String> valuePerAttMap, List<String> errorList) {
        final List<String> returnErrorList = new List<String>();
        returnErrorList.addAll(errorList);

        if(checkAttEmpty(valuePerAttMap.get('amount'))  && (checkAttEmpty(valuePerAttMap.get('type')) || checkAttEmpty(valuePerAttMap.get('min')))) {
            returnErrorList.add(Label.cuco.cond_stoke_variable_missing_fields);
        } else if (!checkAttEmpty(valuePerAttMap.get('amount')) && (!checkAttEmpty(valuePerAttMap.get('type')) || !checkAttEmpty(valuePerAttMap.get('min')))) {
            returnErrorList.add(Label.cuco.cond_stoke_variable_extra_fields);
        }
        return returnErrorList;
    }
    /**
    * @description check mandatory attributes for Stock
    * @param valuePerAttMap: value to evaluate
    * @param errorList: inital error List
    * @return List<String>
    */
    private static List<String> mandatoryNonStock(Map<String,String> valuePerAttMap, List<String> errorList) {
        final List<String> returnErrorListNS = new List<String>();
        returnErrorListNS.addAll(errorList);
        if(checkAttEmpty(valuePerAttMap.get('amount')) && (checkAttEmpty(valuePerAttMap.get('type')) || checkAttEmpty(valuePerAttMap.get('min')) || checkAttEmpty(valuePerAttMap.get('max')))) {
            returnErrorListNS.add(Label.cuco.cond_variable_missing_fields);
        } else if (!checkAttEmpty(valuePerAttMap.get('amount')) && (!checkAttEmpty(valuePerAttMap.get('type')) || !checkAttEmpty(valuePerAttMap.get('min')) || !checkAttEmpty(valuePerAttMap.get('max')))) {
            returnErrorListNS.add(Label.cuco.cond_variable_extra_fields);
        }
        return returnErrorListNS;
    }


}