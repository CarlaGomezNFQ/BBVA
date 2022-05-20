/**
* ____________________________________________________________________________
* Conditions sample
* Sample implementation of the interface Conditions_itf
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-21
* @modified
* @systemLayer Sample
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('PMD.AvoidGlobalModifier, PMD.ExcessiveParameterList')
global with sharing class ConditionsSample implements Conditions_itf {

    /**
    * @description Validates input values from conditions_change component
    * @param inputConditions: conditions input information to validate
    * @return ConditionsValidationErrors_Wrapper
    */
    global ConditionsValidationErrors_Wrapper validateInputConditionValues(ConditionsValidationInput_Wrapper inputConditions) {

        final ConditionsValidationErrors_Wrapper validationsResult = new ConditionsValidationErrors_Wrapper();

        final List<ConditionsValidationErrors_Wrapper.Condition> outputCondErrorList = new List<ConditionsValidationErrors_Wrapper.Condition>();

        if(inputConditions.conditions != null) {
            // Get and structure the input conditions and catalog information
            final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputConditions);

            final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

            final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputConditions, condDetailsMap, condAttMap);

            final Map<String,cuco__ps_catalog_attribute__c> attDetailsMap =  ValidationsCond_Helper.getAttDetails();

            final Map<String,Map<String,cuco__ps_catalog_condition_standard__c>> standardValuesMap = ValidationsCond_Helper.getStandardValues(condAttMap);
            for(cuco__ps_catalog_condition__c cond : condDetailsMap.values()) {

                final List<String> condErrorList =  new List<String> ();

                // Basic validations
                final List<String> booleanErrorList =  ValidationsCond_Helper.checkBooleanAtts(valuePerAttMap.get(cond.cuco__gf_psc_condition_id__c), attDetailsMap);
                condErrorList.addAll(booleanErrorList);

                final List<String> mandatoryErrorList = ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get(cond.cuco__gf_psc_condition_id__c), cond);
                condErrorList.addAll(mandatoryErrorList);

                if(condErrorList.isEmpty()) {

                    final List<String> maxMinErrorList =  ValidationsCond_Helper.checkMinVSMax(valuePerAttMap.get(cond.cuco__gf_psc_condition_id__c));
                    condErrorList.addAll(maxMinErrorList);

                    final List<String> rangeErrorList =  ValidationsCond_Helper.checkAttRange(valuePerAttMap.get(cond.cuco__gf_psc_condition_id__c), standardValuesMap.get(cond.cuco__gf_psc_condition_id__c), attDetailsMap);
                    condErrorList.addAll(rangeErrorList);

                    final List<String> transferErrorList =  ValidationsCond_Helper.checkTransferAtts(valuePerAttMap.get(cond.cuco__gf_psc_condition_id__c), cond, valuePerAttMap);
                    condErrorList.addAll(transferErrorList);

                    final List<String> cardsErrorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get(cond.cuco__gf_psc_condition_id__c), cond);
                    condErrorList.addAll(cardsErrorList);

                    if(!condErrorList.isEmpty()){
                        final ConditionsValidationErrors_Wrapper.Condition condError = new ConditionsValidationErrors_Wrapper.Condition();
                        condError.title = cond.Name;
                        condError.messages = condErrorList;
                        outputCondErrorList.add(condError);
                    }

                } else {
                    final ConditionsValidationErrors_Wrapper.Condition condError = new ConditionsValidationErrors_Wrapper.Condition();
                    condError.title = cond.Name;
                    condError.messages = condErrorList;
                    outputCondErrorList.add(condError);
                }
            }
        }

        if(!outputCondErrorList.isEmpty()){
            validationsResult.conditions = outputCondErrorList;
        }
        return validationsResult;
    }


}