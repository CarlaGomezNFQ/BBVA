/**
* ────────────────────────────────────────────────────────────────────
* ValidationsCondGeneral_Helper
* Helper class for PA_Validation_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Fco Javier Berenguer <franciscojavier.berenguer.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-24
* @modified
* @systemLayer Service
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
global class ValidationsCondGeneral_Helper {

    /**
    * @description Private constructor to avoid sonar error
    */
    @TestVisible
    private ValidationsCondGeneral_Helper() {}

    /**
    * @description Method to get the conditions per family
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @return Map<String,Map<String,Map<String,String>>>, with response
    */
    global static Map<String,Map<String,Map<String,String>>> getConditionsPerFamily(ProfitabilityAnalysis_Wrapper paWrapper) {
        final Map<String,Map<String,Map<String,String>>> retMap = new Map<String,Map<String,Map<String,String>>>();
        for (ProfitabilityAnalysis_Wrapper.Condition condition : paWrapper.conditionsList) {
            if (!retMap.containsKey(condition.familyCanonicalId)) {
                retMap.put(condition.familyCanonicalId, new Map<String,Map<String,String>>());
            }
            if (!retMap.get(condition.familyCanonicalId).containsKey(condition.canonicalId)) {
                retMap.get(condition.familyCanonicalId).put(condition.canonicalId, new Map<String,String>());
            }
            for (ProfitabilityAnalysis_Wrapper.Attribute attribute : condition.attributesList) {
                retMap.get(condition.familyCanonicalId).get(condition.canonicalId).put(attribute.attCanonicalId, attribute.valueId);
            }
        }
        return retMap;
    }

    /**
    * @description Method to check if the att value ranges are valid
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @return List<String>, with response
    */
    global static List<String> checkValuesRange(ProfitabilityAnalysis_Wrapper paWrapper) {
        final List<String> retList = new List<String>();
        final Map<String,CatCondStdValue_Wrapper> mapStdValues = getMapStdValues();
        for (ProfitabilityAnalysis_Wrapper.Condition condition : paWrapper.conditionsList) {
            for (ProfitabilityAnalysis_Wrapper.Attribute attribute : condition.attributesList) {
                final CatCondStdValue_Wrapper catStdValue = mapStdValues.get(attribute.canonicalId);
                if (catStdValue != null) {
                    retList.addAll(checkAttValueRange(condition, attribute, catStdValue));
                }
            }
        }
        return retList;
    }

    /**
    * @description Method to check if the value ranges are valid
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @return List<String>, with response
    */
    global static List<String> checkMailExpenses(ProfitabilityAnalysis_Wrapper paWrapper) {
        final List<String> retList = new List<String>();
        final CondAttValue npMailExp = getCondAttValue('np.transfer.mail.expenses', 'np.transfer.mail.expenses.amount', paWrapper);
        final CondAttValue issMailExp =  getCondAttValue('EEEp.issued.mail', 'EEEp.issued.mail.amount', paWrapper);
        if (npMailExp.attValue != null && issMailExp.attValue != null && npMailExp.attValue != issMailExp.attValue) {
            if (String.isEmpty(npMailExp.source) && String.isEmpty(issMailExp.source)) {
                retList.Add(
                    Label.error_mail_expenses_1 + ' ' + npMailExp.name + ' (' + npMailExp.family + ') '
                    + Label.error_mail_expenses_2 + ' ' + issMailExp.name + ' (' + issMailExp.family + ')'
                );
            } else if (!String.isEmpty(npMailExp.source)) {
                retList.Add(issMailExp.name + ' (' + issMailExp.family + ') ' + Label.error_mail_expenses_3);
            } else if (!String.isEmpty(issMailExp.source)) {
                retList.Add(npMailExp.name + ' (' + npMailExp.family + ') ' + Label.error_mail_expenses_3);
            }
        }
        return retList;
    }

    /**
    * @description Method to check family condition np.nat.transfer
    * @param condPerFamily : Map with conditions per family info
    * @return List<String>, with response
    */
    global static List<String> checkNPTransCond(Map<String,Map<String,Map<String,String>>> condPerFamily) {
        final List<String> retList = new List<String>();
        final Map<String,Map<String,String>> famCond = condPerFamily.get('np.nat.transfer');
        if (famCond != null && famCond.containsKey('np.transfer.mail.expenses') && famCond.size() == 1) {
            retList.Add(Label.error_np_transfer_cond_missing);
        }
        return retList;
    }

    /**
    * @description Method to check family condition np.check
    * @param condPerFamily : Map with conditions per family info
    * @return List<String>, with response
    */
    global static List<String> checkNPCheckCond(Map<String,Map<String,Map<String,String>>> condPerFamily) {
        final List<String> retList = new List<String>();
        final Map<String,Map<String,String>> famCond = condPerFamily.get('np.check');
        if (famCond != null) {
            if (famCond.containsKey('np.bonus') && !famCond.containsKey('np.exempt.mail')) {
                retList.Add(Label.error_np_check_cond_missing);
            } else if (famCond.containsKey('np.exempt.mail') && !famCond.containsKey('np.bonus')) {
                retList.Add(Label.error_np_check_cond_missing);
            }
        }
        return retList;
    }

    /**
    * @description Method to check family condition debit.sepa
    * @param condPerFamily : Map with conditions per family info
    * @return List<String>, with response
    */
    global static List<String> checkSEPAPriceClass(Map<String,Map<String,Map<String,String>>> condPerFamily) {
        final List<String> retList = new List<String>();
        final Map<String,Map<String,String>> famCond = condPerFamily.get('debit.sepa');
        if (famCond != null) {
            if (hasCondDiffPriceAtt('debit.sepa.present', 'debit.sepa.present.other', famCond)) {
                retList.Add(Label.error_sepa_present_diff_price);
            }
            if (hasCondDiffPriceAtt('debit.sepa.present.other.btb', 'debit.sepa.present.btb', famCond)) {
                retList.Add(Label.error_sepa_present_b2b_diff_price);
            }
            if (hasCondDiffPriceAtt('debit.sepa.dev.preliquidation', 'debit.sepa.dev.preliquid.other', famCond)) {
                retList.Add(Label.error_sepa_pre_diff_price);
            }
            if (hasCondDiffPriceAtt('debit.sepa.dev.postliquidation', 'debit.sepa.dev.postliquid.other', famCond)) {
                retList.Add(Label.error_sepa_post_diff_price);
            }
        }
        return retList;
    }

    /**
    * @description Method to check condition pairs in debit.sepa condition family
    * @param condPerFamily : Map with conditions per family info
    * @return List<String>, with errors response
    */
    global static List<String> checkSEPAPairs(Map<String,Map<String,Map<String,String>>> condPerFamily) {
        final List<String> retList = new List<String>();
        final Map<String,Map<String,String>> famSEPACondMap = condPerFamily.get('debit.sepa');
        if (famSEPACondMap != null) {
            if (!hasCompletePair('debit.sepa.present.other', 'debit.sepa.present', famSEPACondMap)) {
                retList.Add(Label.error_sepa_present_missing_pair);
            }
            if (!hasCompletePair('debit.sepa.present.other.btb', 'debit.sepa.present.btb', famSEPACondMap)) {
                retList.Add(Label.error_sepa_present_b2b_missing_pair);
            }
            if (!hasCompletePair('debit.sepa.dev.preliquidation', 'debit.sepa.dev.preliquid.other', famSEPACondMap)) {
                retList.Add(Label.error_sepa_pre_missing_pair);
            }
            if (!hasCompletePair('debit.sepa.dev.postliquidation', 'debit.sepa.dev.postliquid.other', famSEPACondMap)) {
                retList.Add(Label.error_sepa_post_missing_pair);
            }
        }
        return retList;
    }

    /**
    * @description Method to check family condition cheque.rate
    * @param condPerFamily : Map with conditions per family info
    * @return List<String>, with response
    */
    global static List<String> checkRate55Cond(Map<String,Map<String,Map<String,String>>> condPerFamily) {
        final List<String> retList = new List<String>();
        final Map<String,Map<String,String>> famCond = condPerFamily.get('cheque.rate');
        if (famCond != null) {
            final Map<String,String> cond1 = famCond.get('cheque.rate99.bonus.type');
            if (cond1 != null && cond1.get('rate.type') == '55' && !hasAnyRate55Cond(famCond) ) {
                retList.Add(Label.error_check_rate_cond_missing);
            }
        }
        return retList;
    }

    /**
    * @description Method to check family condition cheque.rate
    * @param condPerFamily : Map with conditions per family info
    * @return List<String>, with response
    */
    global static List<String> checkRate(Map<String,Map<String,Map<String,String>>> condPerFamily) {
        final List<String> retList = new List<String>();
        final Map<String,Map<String,String>> famCond = condPerFamily.get('cheque.rate');
        if (famCond != null && hasAnyRate55Cond(famCond)) {
            final Map<String,String> cond1 = famCond.get('cheque.rate99.bonus.type');
            if (cond1 == null) {
                retList.Add(Label.error_check_rate_missing_value);
            } else if (cond1.get('rate.type') != '55') {
                retList.Add(Label.error_check_rate_wrong_value);
            }
        }
        return retList;
    }

    /**
    * @description Wrapper with info on catalog condition standard
    */
    public class CatCondStd_Wrapper {
        /**
        * @Description : id
        */
        @AuraEnabled
        public String id {get; set;}
        /**
        * @Description : value
        */
        @AuraEnabled
        public CatCondStdValue_Wrapper value {get; set;}
    }

    /**
    * @description Wrapper with info on catalog condition standard values
    */
    public class CatCondStdValue_Wrapper {
        /**
        * @Description : standard
        */
        @AuraEnabled
        public String standard {get; set;}
        /**
        * @Description : min
        */
        @AuraEnabled
        public String min {get; set;}
        /**
        * @Description : max
        */
        @AuraEnabled
        public String max {get; set;}
    }

    /**
    * @description Check mail expenses auxiliar class
    */
    private class CondAttValue {
        /**
        * @description : name
        */
        String name {get; set;}
        /**
        * @description : family
        */
        String family {get; set;}
        /**
        * @description : source
        */
        String source {get; set;}
        /**
        * @description : attribute value
        */
        String attValue {get; set;}
    }

    /**
    * @description Check values range auxiliar class
    */
    private class MinMaxRangeInfo {
        /**
        * @description : hasMin
        */
        Boolean hasMin {get; set;}
        /**
        * @description : hasMax
        */
        Boolean hasMax {get; set;}
        /**
        * @description : min
        */
        Decimal min {get; set;}
        /**
        * @description : max
        */
        Decimal max {get; set;}
        /**
        * @description : value
        */
        Decimal value {get; set;}

        /**
        * @description Constructor with value, min and max parameters
        */
        private MinMaxRangeInfo(String value, String min, String max) {
            this.hasMin = !String.isBlank(min);
            this.hasMax = !String.isBlank(max);
            this.min = Decimal.valueof(String.isBlank(min) ? '0' : min);
            this.max = Decimal.valueof(String.isBlank(max) ? '0' : max);
            this.value = Decimal.valueof(String.isBlank(value) ? '0' : value);
        }

        /**
        * @description Method to check if value is out of range
        */
        private Boolean isOutOfRange() {
            return (hasMin && value < min) || (hasMax && value > max);
        }
    }

    /**
    * @description return map with condition standard values
    */
    private static Map<String,CatCondStdValue_Wrapper> getMapStdValues() {
        final List<CatCondStd_Wrapper> catStdValues = (List<CatCondStd_Wrapper>)JSON.deserialize(Catalog_Helper.getStandardValues(), List<CatCondStd_Wrapper>.class);
        final Map<String,CatCondStdValue_Wrapper> mapStdValues = new Map<String,CatCondStdValue_Wrapper>();
        for (CatCondStd_Wrapper stdValues : catStdValues) {
            mapStdValues.put(stdValues.id, stdValues.value);
        }
        return mapStdValues;
    }

    /**
    * @description list of string with attribute out of range error
    */
    private static List<String> checkAttValueRange(ProfitabilityAnalysis_Wrapper.Condition condition,
        ProfitabilityAnalysis_Wrapper.Attribute attribute, CatCondStdValue_Wrapper catStdValue) {
        final List<String> retList = new List<String>();
        final MinMaxRangeInfo attStdMinMax = new MinMaxRangeInfo(attribute.value, catStdValue.min, catStdValue.max);
        if (attStdMinMax.isOutOfRange()) {
            if (attStdMinMax.hasMin && attStdMinMax.hasMax) {
                retList.add(
                    Label.error_cond_out_range_1 + ' ' + attribute.name + ' ' + Label.error_cond_out_range_2 + ' '
                        + condition.name + ' - ' + condition.family + ' ' + Label.error_cond_out_range_3 + ' '
                        + catStdValue.min + ' ' + Label.error_cond_out_range_4 + ' ' + catStdValue.max
                );
            } else if (attStdMinMax.hasMin) {
                retList.add(
                    Label.error_cond_out_range_1 + ' ' + attribute.name + ' ' + Label.error_cond_out_range_2 + ' '
                        + condition.name + ' - ' + condition.family + ' ' + Label.error_cond_out_range_5 + ' '
                        + catStdValue.min
                );
            } else if (attStdMinMax.hasMax) {
                retList.add(
                    Label.error_cond_out_range_1 + ' ' + attribute.name + ' ' + Label.error_cond_out_range_2 + ' '
                        + condition.name + ' - ' + condition.family + ' ' + Label.error_cond_out_range_6 + ' '
                        + catStdValue.max
                );
            }
        }
        return retList;
    }

    /**
    * @description return condition and att info for the specified canonicalId
    */
    private static CondAttValue getCondAttValue(String condCanonicalId, String condAttCanonicalId, ProfitabilityAnalysis_Wrapper paWrapper) {
        final CondAttValue retCondAttValue = new CondAttValue();
        final ProfitabilityAnalysis_Wrapper.Condition condition = getCondition(condCanonicalId, paWrapper);
        if (condition != null) {
            retCondAttValue.name = condition.name;
            retCondAttValue.family = condition.family;
            retCondAttValue.source = condition.source;
            retCondAttValue.attValue = getAttValue(condAttCanonicalId, condition);
        }
        return retCondAttValue;
    }

    /**
    * @description return condition for the specified canonicalId
    */
    private static ProfitabilityAnalysis_Wrapper.Condition getCondition(String canonicalId, ProfitabilityAnalysis_Wrapper paWrapper) {
        ProfitabilityAnalysis_Wrapper.Condition retCondition;
        for (ProfitabilityAnalysis_Wrapper.Condition condition : paWrapper.conditionsList) {
            if (condition.canonicalId == canonicalId) {
                retCondition = condition;
                break;
            }
        }
        return retCondition;
    }

    /**
    * @description return attribute value for the specified attCanonicalId
    */
    private static String getAttValue(String canonicalId, ProfitabilityAnalysis_Wrapper.Condition condition) {
        String retAttValue;
        for (ProfitabilityAnalysis_Wrapper.Attribute attribute : condition.attributesList) {
            if (attribute.canonicalId == canonicalId) {
                retAttValue = attribute.value;
                break;
            }
        }
        return retAttValue;
    }

    /**
    * @description return true if the specified canonical id conditions exists and has different price attribute value
    */
    private static Boolean hasCondDiffPriceAtt(String canonicalIdCondA, String canonicalIdCondB, final Map<String,Map<String,String>> famCond) {
        Boolean diffPrice = false;
        final Map<String,String> condA = famCond.get(canonicalIdCondA);
        final Map<String,String> condB = famCond.get(canonicalIdCondB);
        if (condA != null && condB != null && condA.get('price') != condB.get('price')) {
            diffPrice = true;
        }
        return diffPrice;
    }

    /**
    * @description Helper method to check if param cond map has both params condition includes
    * @param canonicalCondA : String with first condition to check in conditions map
    * @param canonicalCondB : String with second condition to check in conditions map
    * @param condMap : Map with conditions
    * @return Boolean, with result
    */
    private static Boolean hasCompletePair(String canonicalCondA, String canonicalCondB, Map<String, Map<String, String>> condMap) {
        Boolean hasCompletePair = true;
        if ((condMap.containsKey(canonicalCondA) && !condMap.containsKey(canonicalCondB)) || (!condMap.containsKey(canonicalCondA) && condMap.containsKey(canonicalCondB))) {
            hasCompletePair = false;
        }
        return hasCompletePair;
    }

    /**
    * @description return if family contains any of the rate 55 conditions
    */
    private static Boolean hasAnyRate55Cond(Map<String,Map<String,String>> famCond) {
        final List<String> rate55conditions = new List<String> {
            'cheque.rate55.alternate.branch',
            'cheque.rate55.alternate.digit',
            'cheque.rate55.claim.branch',
            'cheque.rate55.claim.digit',
            'cheque.rate55.comp.branch',
            'cheque.rate55.comp.digit',
            'cheque.rate55.comp.other.branch',
            'cheque.rate55.comp.other.digit',
            'cheque.rate55.refund.branch',
            'cheque.rate55.refund.digit',
            'cheque.rate55.comp.postal',
            'cheque.rate55.refund.postal'
        };
        Boolean hasAny = false;
        for (String rate55cond : rate55conditions) {
            if (famCond.containsKey(rate55cond)) {
                hasAny = true;
                break;
            }
        }
        return hasAny;
    }
}