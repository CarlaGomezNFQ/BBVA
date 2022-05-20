/**
* ────────────────────────────────────────────────────────────────────
* ConditionsChange_Ctrl
* Controller class for conditions_change_cmp Aura Component
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-21
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.ExcessivePublicCount, PMD.ExcessiveParameterList')
global with sharing class ConditionsChange_Ctrl {

    /*
    * @description constructor
    */
    @TestVisible
    private ConditionsChange_Ctrl() {}

    /**
    * private functions to reduce cyclomatic complexity
    */
    private static Set<Id> getAllConditions(Map<String, Object> inputMap) {
        final Set<Id> allConditions = new Set<Id>();
        for (Object cnd : (List<Object>)inputMap.get('conditions')) {
            Map<String, Object> cndMap = (Map<String, Object>)cnd;
            allConditions.add((String)cndMap.get('id'));
        }
        return allConditions;
    }

    private static Set<Id> getConditionsIncluded(Map<String, Object> inputMap) {
        final Set<Id> conditionsIncluded = new Set<Id>();
        for (Object cnd : (List<Object>)inputMap.get('conditions')) {
            Map<String, Object> cndMap = (Map<String, Object>)cnd;
            if ((Boolean)cndMap.get('isIncluded')) {
                conditionsIncluded.add((String)cndMap.get('id'));
            }
        }
        return conditionsIncluded;
    }

    private static List<AttributeOption> getPickListOptions(String fieldName) {

        List<AttributeOption> options = new List<AttributeOption>();
        List<Schema.PicklistEntry> entries = Schema.getGlobalDescribe().get('cuco__profitability_analysis_condition__c').getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues();

        for (Schema.PicklistEntry entry : entries) {
            AttributeOption option = new AttributeOption();
            option.label = entry.getLabel();
            option.value = entry.getValue();
            options.add(option);
        }
        return options;
    }

    private static String getMapValue(Map<String, Object> haystack, String needle, String default2) {
        String res = default2;
        if (haystack.containsKey(needle)) {
            res = (String)haystack.get(needle);
        }
        return res;
    }

    private static String addCucoPrefix(String str) {
        string res = '';
        if (!String.isEmpty(str)) {
            res = (str.substring(0,6) != 'cuco__') ? 'cuco__' + str : str;
        }
        return res;
    }

    /**
    * @description read from configuration
    * @return Boolean
    */
    private static Boolean retrieveStandardValues() {
        final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();
        return (Boolean)config.retrieve_standard_values_type__c;
    }

    /**
    * @description read from configuration
    * @return Boolean
    */
    private static void retrieveStandardValues(ps_catalog_condition_attribute__c pscConditionAttribute, Map<String, Object> standardValues, List<AttributeValue> values) {
        if (retrieveStandardValues()) {
            AttributeValue official = new AttributeValue();
            official.name = 'official';
            official.value = getMapValue(standardValues, pscConditionAttribute.gf_psc_condition_attribute_id__c, '');
            official.max = getMapValue(standardValues, pscConditionAttribute.gf_psc_condition_attribute_id__c + '_max', '');
            official.min = getMapValue(standardValues, pscConditionAttribute.gf_psc_condition_attribute_id__c + '_min', '');
            values.add(official);
        }
    }

    /**
    * @description read from configuration
    * @return Boolean
    */
    private static Boolean retrieveDelegatedValues() {
        final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();
        return (Boolean)config.retrieve_delegated_values_type__c;
    }

    /**
    * @description read from configuration
    * @return Boolean
    */
    private static void retrieveDelegatedValues(ps_catalog_condition_attribute__c pscConditionAttribute, Map<String, Object> delegatedValues, List<AttributeValue> values) {
        if (retrieveDelegatedValues()) {
            AttributeValue delegated = new AttributeValue();
            delegated.name = 'delegated';
            delegated.value = getMapValue(delegatedValues, pscConditionAttribute.gf_psc_condition_attribute_id__c, '');
            values.add(delegated);
        }
    }

    /**
    * @description parse JSON String Input.
    * @param jsonInput : JSON String
    * @return Map with Condition ids and attribs.
    */
    @AuraEnabled
    public static ConditionsChange_Ctrl.Conditions getConditionsFromJSON(String jsonInput) {

        final Conditions res = new Conditions();
        res.conditions = new List<Condition>();

        final Map<String, Object> inputMap = (Map<String,Object>) JSON.deserializeUntyped(jsonInput);
        final String familyId = (String)inputMap.get('familyId');
        final String profAnalysisId = (String)inputMap.get('profAnalysisId');
        final Map<String, Object> currentValues = getValues((List<Object>)inputMap.get('actual'));
        Map<String, Object> standardValues = new Map<String, Object>();
        Map<String, Object> delegatedValues = new Map<String, Object>();

        if (retrieveStandardValues()) {
            standardValues = getValues((List<Object>)inputMap.get('standard'));
        }

        if (retrieveDelegatedValues()) {
            delegatedValues = getValues((List<Object>)inputMap.get('delegation'));
        }

        final Set<Id> conditionsIncluded = getConditionsIncluded(inputMap);
        final Set<Id> allConditions = getAllConditions(inputMap);

        final List<profitability_analysis_condition__c> paConditions = ProfitabilityAnalysisCondition_Service.getConditionsFromCatalogIds(profAnalysisId, conditionsIncluded);
        final List<ps_catalog_condition__c> psCatalogConditions = PsCatalogCondition_Service.getCatalogConditionsFromIds(allConditions);

        Map<String, profitability_analysis_condition__c> paConditionsIncluded = new Map<String, profitability_analysis_condition__c>();
        for (profitability_analysis_condition__c paCondition: paConditions) {
            paConditionsIncluded.put(paCondition.gf_psc_condition_id__c, paCondition);
        }

        res.name = psCatalogConditions[0].gf_psc_family_id__r.gf_psc_family_product_name__c + ' / ' + psCatalogConditions[0].gf_psc_family_id__r.Name;
        res.profAnalysisId = profAnalysisId;
        res.familyId = familyId;

        final List<ps_catalog_condition_attribute__c> pscConditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromConditionIds(allConditions);

        Boolean hasInfCond = false;
        for (ps_catalog_condition__c psCatalogCondition : psCatalogConditions) {

            profitability_analysis_condition__c currentPaCondition = new profitability_analysis_condition__c();

            if(paConditionsIncluded.containsKey(psCatalogCondition.Id)) {
                currentPaCondition = (profitability_analysis_condition__c)paConditionsIncluded.get(psCatalogCondition.Id);
            }

            Condition condition = new Condition();
            List<Attribute> attributes = new List<Attribute>();

            condition.name = psCatalogCondition.Name;
            condition.conditionId = psCatalogCondition.Id;
            condition.order = psCatalogCondition.gf_psc_cond_visual_ord_number__c;
            condition.familyLevel = psCatalogCondition.gf_psc_cond_fmly_lvl_ind_type__c;
            condition.formalizationMethod = psCatalogCondition.gf_psc_fa_frmlz_proc_type_name__c;
            if (psCatalogCondition.gf_psc_fa_frmlz_proc_type_name__c == 'Informative') {
                hasInfCond = true;
            }

            for (ps_catalog_condition_attribute__c pscConditionAttribute : pscConditionAttributes) {

                if (pscConditionAttribute.gf_psc_condition_id__c == psCatalogCondition.Id && pscConditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_visible_ind_type__c) {
                    Attribute attribute = new Attribute();
                    List<AttributeValue> values = new List<AttributeValue>();

                    attribute.label = pscConditionAttribute.gf_psc_atribute_id__r.Name;
                    attribute.attributeId = pscConditionAttribute.Id;
                    attribute.conditionAttributeId = pscConditionAttribute.gf_psc_condition_attribute_id__c;
                    attribute.order = (Integer)pscConditionAttribute.gf_psc_atribute_id__r.gf_psc_atrb_vslztn_ord_number__c;
                    attribute.type = pscConditionAttribute.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                    attribute.unitType = pscConditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_fmt_unit_type__c;
                    attribute.format = pscConditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_format_type__c;
                    attribute.fieldName = addCucoPrefix(pscConditionAttribute.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c);

                    retrieveStandardValues(pscConditionAttribute, standardValues, values);

                    retrieveDelegatedValues(pscConditionAttribute, delegatedValues, values);

                    AttributeValue current = new AttributeValue();
                    current.name = 'current';
                    current.value = getMapValue(currentValues, pscConditionAttribute.gf_psc_condition_attribute_id__c, '');
                    values.add(current);

                    attribute.values = values;

                    switch on attribute.type {
                        when  'List'{
                            attribute.requestedValue = Utils.getPicklistLabel('cuco__profitability_analysis_condition__c', attribute.fieldName, String.valueOf(currentPaCondition.get(attribute.fieldName)));
                            attribute.options = getPicklistOptions(attribute.fieldName);
                        }
                        when 'Checkbox' {
                            attribute.requestedValue = String.valueOf(currentPaCondition.get(attribute.fieldName)) ;

                            List<AttributeOption> options = new List<AttributeOption>();
                            attribute.options = options;

                            AttributeOption optionYes = new AttributeOption();
                            optionYes.label = Label.Yes;
                            optionYes.value = 'true';
                            options.add(optionYes);

                            AttributeOption optionNo = new AttributeOption();
                            optionNo.label = Label.No;
                            optionNo.value = 'false';
                            options.add(optionNo);

                            attribute.options = options;
                        }
                        when else {
                            attribute.requestedValue = String.valueOf(currentPaCondition.get(attribute.fieldName)) ;
                        }
                    }

                    attributes.add(attribute);
                }
            }
            condition.attributes = attributes;
            res.conditions.add(condition);
            res.hasInformativeConditions = hasInfCond;
        }
        return res;
    }

    /**
    * @description validateInputValues
    * @param profAnalysisId : ProfitabilityAnalysis Id
    * @param inputValues : JSON String
    * @return JSON with result and validation errors if any.
    */
    @AuraEnabled
    public static String validateInputValues(Id profAnalysisId, String inputValues) {
        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(inputValues, ConditionsValidationInput_Wrapper.class);
        final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();
        final Type conditionsClass = Type.forName(config.condition_itf_name__c);
        final Conditions_itf conditionsItf = (Conditions_itf)conditionsClass.newInstance();
        final ConditionsValidationErrors_Wrapper res = conditionsItf.validateInputConditionValues(inputCondList);
        return JSON.serialize(res);
    }

    /**
    * @description returns map with ids and values.
    * @param lObjects List<Object> from parsed jsonInput
    * @return Map with ids and values
    */
    private static Map<String, Object> getValues(List<Object> lObjects) {
        Map<String, Object> res = new Map<String, Object>();
        for (Object obj : lObjects) {
            Map<String, Object> obj2Map = (Map<String, Object>)obj;
            res.put((String)obj2Map.get('id'), (String)obj2Map.get('value'));
            if(obj2Map.containsKey('min')) {
                res.put((String)obj2Map.get('id') + '_min', (String)obj2Map.get('min'));
            }
            if(obj2Map.containsKey('max')) {
                res.put((String)obj2Map.get('id') + '_max', (String)obj2Map.get('max'));
            }
        }
        return res;
    }

    /**
    * @description upsert conditions.
    * @param updateMap List<profitability_analysis_condition__c> of exisiting records to update
    * @param insertMap List<profitability_analysis_condition__c> of new records to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    private static Utils.DML_Wrapper upsertConditions(Map<string, Object> updateMap, Map<string, Object> insertMap) {

        List<String> errors = new List<String>();
        Boolean success = true;
        final List<profitability_analysis_condition__c> conditionsToUpsert = new List<profitability_analysis_condition__c>();

        for (String conditionKey : updateMap.keySet()) {
            profitability_analysis_condition__c conditionToUpdate = (profitability_analysis_condition__c)updateMap.get(conditionKey);
            conditionsToUpsert.add(conditionToUpdate);
        }

        for (String conditionKey : insertMap.keySet()) {
            profitability_analysis_condition__c conditionToInsert = (profitability_analysis_condition__c)insertMap.get(conditionKey);
            conditionsToUpsert.add(conditionToInsert);
        }

        if (conditionsToUpsert.size() > 0) {
            Utils.DML_Wrapper upsertConditions = profitabilityAnalysisCondition_Helper.updateProfitabilityAnalysisCondition(conditionsToUpsert);
            success = upsertConditions.isSuccess;
            errors.addAll(upsertConditions.lstErrMessage);
        }
        return new Utils.DML_Wrapper(success, errors);
    }

    /**
    * @description fill maps with conditions.
    * @param updateMap List<profitability_analysis_condition__c> of exisiting records to update
    * @param insertMap List<profitability_analysis_condition__c> of new records to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    private static void addCondition(Id profAnalysisId, Map<string, Object> paConditionsMap, Map<string, Object> newConditionsMap, ps_catalog_condition_attribute__c pscConditionAttribute, Map<String, Object> attributes) {

        final String attributeId = (String)pscConditionAttribute.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c;
        final String attributeName = (String)pscConditionAttribute.gf_psc_condition_attribute_id__c;

        final Map<String, Object> attributeMap = (Map<String, Object>)attributes.get(attributeName);
        final String value = (String)attributeMap.get('proposed');
        final String type = (String)pscConditionAttribute.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
        profitability_analysis_condition__c condition = new profitability_analysis_condition__c();

        if (paConditionsMap.containsKey(pscConditionAttribute.gf_psc_condition_id__c)) {
            condition = (profitability_analysis_condition__c)paConditionsMap.get(pscConditionAttribute.gf_psc_condition_id__c);
        } else {
            if (newConditionsMap.containsKey(pscConditionAttribute.gf_psc_condition_id__c)) {
                condition = (profitability_analysis_condition__c)newConditionsMap.get(pscConditionAttribute.gf_psc_condition_id__c);
            } else {
                condition.gf_profitablity_analysis_id__c  = profAnalysisId;
                condition.gf_psc_condition_id__c = pscConditionAttribute.gf_psc_condition_id__c;
                newConditionsMap.put(pscConditionAttribute.gf_psc_condition_id__c, condition);
            }
        }

        if (pscConditionAttribute.gf_psc_condition_id__r.gf_psc_cond_prc_class_ind_type__c == true) {
            if (pscConditionAttribute.gf_psc_atribute_id__r.gf_psc_attribute_id__c == 'amount') {
                condition.gf_pa_cond_prps_prc_type_name__c = (String.isEmpty(value)) ? 'EF' : 'IF' ;
            } else {
                condition.gf_pa_cond_prps_prc_type_name__c = 'EF';
            }
        }

        if (String.isEmpty(value)) {
            condition.put('cuco__' + attributeId, null);
        } else {
            switch on type {
                when 'Number', 'Currency', 'Permillage', 'Percent' {
                    condition.put('cuco__' + attributeId, Double.valueOf(value));
                }
                when 'List' {
                    condition.put('cuco__' + attributeId, String.valueOf(value));
                }
                when 'Checkbox' {
                    condition.put('cuco__' + attributeId, Boolean.valueOf(value));
                }
            }
        }
    }

    /**
    * @description update values
    * @param profAnalysisId : ProfitabilityAnalysis Id
    * @param conditionAttValuesJSON : JSON String
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    @AuraEnabled
    public static Utils.DML_Wrapper updateConditions(Id profAnalysisId, String conditionAttValuesJSON) {

        List<String> errors = new List<String>();
        Boolean success = true;

        try {
            final Map<String, Object> inputMap = (Map<String,Object>) JSON.deserializeUntyped(conditionAttValuesJSON);
            final Set<Id> pscConditionIds = new Set<Id>();
            final Set<String> attributeNames = new Set<String>();

            final Map<string, Object> conditions = new Map<String, Object>();
            final Map<String, Object> attributes = new Map<String, Object>();

            final Map<string, Object> paConditionsMap = new Map<String, Object>();
            final Map<string, Object> newConditionsMap = new Map<String, Object>();

            for (Object objCondition : (List<Object>)inputMap.get('conditions')) {
                Map<string, Object> condition = (Map<string, Object>)objCondition;
                pscConditionIds.add((Id)condition.get('id'));
                conditions.put((Id)condition.get('id'), new List<String>());
                List<String> conditionAttributes = (List<String>)conditions.get((Id)condition.get('id'));

                for (Object objAttribute : (List<Object>)condition.get('attributes')) {
                    Map<string, Object> attribute = (Map<String, Object>)objAttribute;
                    attributes.put((String)attribute.get('id'), new Map<String, Object>{'proposed' => String.valueOf(attribute.get('proposed')), 'condition' => (Id)condition.get('id')});
                    conditionAttributes.add((String)attribute.get('id'));
                    attributeNames.add((String)attribute.get('id'));
                }
            }

            final List<profitability_analysis_condition__c> paConditions = ProfitabilityAnalysisCondition_Service.getConditionsFromCatalogIds(profAnalysisId, pscConditionIds);

            for (profitability_analysis_condition__c paCondition : paConditions) {
                paConditionsMap.put(paCondition.gf_psc_condition_id__c, paCondition);
            }

            final List<ps_catalog_condition_attribute__c> pscConditionAttributes = PsCatalogConditionAttribute_Service.getConditionAttributesFromCanonicalNames(pscConditionIds, attributeNames);

            for (ps_catalog_condition_attribute__c pscConditionAttribute : pscConditionAttributes) {
                addCondition(profAnalysisId, paConditionsMap, newConditionsMap, pscConditionAttribute, attributes);
            }

            Utils.DML_Wrapper upsertConditions = upsertConditions(paConditionsMap, newConditionsMap);
            success = upsertConditions.isSuccess;
            errors.addAll(upsertConditions.lstErrMessage);

        } catch (Exception e) { //NOSONAR
            success = false;
            errors.add(e.getMessage());
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
        return new Utils.DML_Wrapper(success, errors);
    }

    /**
    * @description Wrapper to return reults
    */
    global class Conditions {
        /**
        * @description: name
        */
        @AuraEnabled
        public String name {get; set;}

        /**
        * @description: profitability analysis id
        */
        @AuraEnabled
        public String profAnalysisId {get; set;}

        /**
        * @description: family id
        */
        @AuraEnabled
        public String familyId {get; set;}

        /**
        * @description: conditions included
        */
        @AuraEnabled
        public List<Condition> conditions {get; set;}

        /**
        * @description: hasInformativeConditions
        */
        @AuraEnabled
        public Boolean hasInformativeConditions {get; set;}
    }

    global class Condition {
        /**
        * @description: name
        */
        @AuraEnabled
        public String name {get; set;}

        /**
        * @description: condition Id
        */
        @AuraEnabled
        public String conditionId {get; set;}

        /**
        * @description: is family Level condition
        */
        @AuraEnabled
        public Boolean familyLevel {get; set;}

        /**
        * @description: visualization order
        */
        @AuraEnabled
        public Decimal order {get; set;}

        /**
        * @description: condition attributes
        */
        @AuraEnabled
        public List<Attribute> attributes {get; set;}

        /**
        * @description: formalizationMethod
        */
        @AuraEnabled
        public String formalizationMethod {get; set;}
    }

    global class Attribute {
        /**
        * @description: attribute label
        */
        @AuraEnabled
        public String label {get; set;}

        /**
        * @description: Attribute Id
        */
        @AuraEnabled
        public String attributeId {get; set;}

        /**
        * @description: condition Attribute id
        */
        @AuraEnabled
        public String conditionAttributeId {get; set;}

        /**
        * @description: visualization order
        */
        @AuraEnabled
        public Integer order {get; set;}

        /**
        * @description: attribute type
        */
        @AuraEnabled
        public String type {get; set;}

        /**
        * @description: attr unit type
        */
        @AuraEnabled
        public String unitType {get; set;}

        /**
        * @description: attr format
        */
        @AuraEnabled
        public String format {get; set;}

        /**
        * @description: attr field name
        */
        @AuraEnabled
        public String fieldName {get; set;}

        /**
        * @description: proposed value
        */
        @AuraEnabled
        public String requestedValue {get; set;}

        /**
        * @description: attr min
        */
        @AuraEnabled
        public String min {get; set;}

        /**
        * @description: max
        */
        @AuraEnabled
        public String max {get; set;}

        /**
        * @description: attr drop down options
        */
        @AuraEnabled
        public List<AttributeOption> options {get; set;}

        /**
        * @description: attr values
        */
        @AuraEnabled
        public List<AttributeValue> values {get; set;}
    }

    global class AttributeValue {
        /**
        * @description: name
        */
        @AuraEnabled
        public String name {get; set;}

        /**
        * @description: value
        */
        @AuraEnabled
        public String value {get; set;}

        /**
        * @description: min
        */
        @AuraEnabled
        public String min {get; set;}

        /**
        * @description: max
        */
        @AuraEnabled
        public String max {get; set;}
    }

    global class AttributeOption {
        /**
        * @description: label
        */
        @AuraEnabled
        public String label {get; set;}

        /**
        * @description: value
        */
        @AuraEnabled
        public String value {get; set;}
    }

}