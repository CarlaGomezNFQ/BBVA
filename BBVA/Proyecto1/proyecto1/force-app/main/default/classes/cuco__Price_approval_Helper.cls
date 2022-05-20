/**
* ────────────────────────────────────────────────────────────────────
* Price_approval_Helper
* Service class for price aprproval helper implementation apex classes
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-08
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Price_approval_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Price_approval_Helper() {}

    /**
    * @description make negotiation price call
    * @param negotiationId : negotiation id
    * @return HttpResponse, with the price response
    */
    public static HttpResponse callPriceNegotiation (ProfitabilityAnalysis_Wrapper paWrapper, String negotiationId) {

        final PriceNegotiation_Helper pnh = new PriceNegotiation_Helper (paWrapper);
        HttpResponse priceResponse;
        if (negotiationId != null && negotiationId != '' ) {
            priceResponse = pnh.callWS('updatePriceNegotiation');
        } else {
            priceResponse = pnh.callWS('newPriceNegotiation');
        }
        return priceResponse;
    }

    /**
    * @description make the profitability analysis update
    * @param paList : List<profitability_analysis__c>
    * @param priceResponse : String
    * @return Map<String,Object>, with the update result
    */
    public static Map<String,Object> updateProfitAnalys (List<profitability_analysis__c> paList, String priceResponse) {

        final Map<String,Object> mapToreturn = new Map<String,Object>();
        final Map<String,Object> mapPriceResponse = (Map<String,Object>) JSON.deserializeUntyped(priceResponse);
        if (mapPriceResponse.containsKey('negotiationId')) {
            //save the negotiation Id
            paList[0].cuco__gf_price_aprvl_process_req_id__c = (String) mapPriceResponse.get('negotiationId');
            paList[0].cuco__gf_pa_price_negotiated_date__c = Date.today();
            //Update profitability analysis
            final Utils.DML_Wrapper updateResult = ProfitabilityAnalysis_Helper.updatePA(paList);
            //add to returned map the result
            mapToReturn.put('paUpdateSuccess', updateResult.isSuccess);
            mapToReturn.put('paUpdateMessage', updateResult.lstErrMessage.toString());
        }
        return mapToreturn;
    }

    /**
    * @description get the price decisions from response
    * @param paList : List<profitability_analysis__c>
    * @return Map<String,Object>, with the update result
    */
    public static Map<String,Object> getDecisionsFromService (String priceResponse, ProfitabilityAnalysis_Wrapper paWrapper) {

        final Map<String,Object> mapToreturn = new Map<String,Object>();
        final Map<String,Object> mapPriceResponse = (Map<String,Object>) JSON.deserializeUntyped(priceResponse);
        if (mapPriceResponse.containsKey('decisions')) {
            final List<Object> lstObjDecis = (List<Object>) mapPriceResponse.get('decisions');
            final List<String> lstDecisions = new List<String>();
            for(Object decision : lstObjDecis) {
                final Map<String,Object> mapdecision = (Map<String,Object>)decision;
                if(mapdecision.containsKey('id')) {
                    lstDecisions.add((String)mapdecision.get('id'));
                }
            }
            final List<PriceDecision_Wrapper> pdwList = ProfitabilityAnalysis_Service.getPriceDecision(lstDecisions, paWrapper.status);
            mapToReturn.put('decisionWrapperList', pdwList);
        }
        return mapToreturn;
    }

    /**
    * @description get the price decisions from response
    * @param paList : List<profitability_analysis__c>
    * @return Map<String,Object>, with the update result
    */
    public static Map<String,Object> getConditionsFromService (String priceResponse) {

        final Map<String,Object> mapToreturn = new Map<String,Object>();
        final Map<String,Object> mapPriceResponse = (Map<String,Object>) JSON.deserializeUntyped(priceResponse);
        if (mapPriceResponse.containsKey('conditions')) {
            final List<PriceConditionsToReview_Wrapper> lstToOrder = getConditions(priceResponse);
            if (!lstToOrder.isEmpty()) {
                lstToOrder.sort();
                mapToReturn.put('listaConditions', getCondPerFam(lstToOrder));
            }
        }
        return mapToreturn;
    }

    /**
    * @description get the price conditions to review from response
    * @param priceResponse : List<PriceConditionsToReview_Wrapper>
    * @return Map<String,Object>, with the conditions to review
    */
    public static List<PriceConditionsToReview_Wrapper> getConditions (String priceResponse) {

        final Map<String,Object> mapPriceResponse = (Map<String,Object>) JSON.deserializeUntyped(priceResponse);
        final List<Object> lstObjCondi = (List<Object>) mapPriceResponse.get('conditions');

        final PsCatalogConditionAttribute_Selector pscca = new PsCatalogConditionAttribute_Selector(true);
        final List<ps_catalog_condition_attribute__c> psccaList = pscca.getCatalogConditionsAttribute(1000);

        final Map<String, ps_catalog_condition_attribute__c> mapPscca = new Map<String, ps_catalog_condition_attribute__c>();
        for (ps_catalog_condition_attribute__c item : psccaList) {
            mapPscca.put(item.gf_psc_condition_attribute_id__c, item);
        }

        final PsCatalogCondition_Selector pscSelector = new PsCatalogCondition_Selector(true);
        final List<ps_catalog_condition__c> lstPsc = pscSelector.selectActiveCatalogConditions();
        final Map<Id, ps_catalog_condition__c> mapCatCond = new Map<Id, ps_catalog_condition__c>();
        for (ps_catalog_condition__c item : lstPsc) {
            mapCatCond.put(item.Id, item);
        }

        final List<PriceConditionsToReview_Wrapper> listToReturn = new List<PriceConditionsToReview_Wrapper>();
        for (Object condition : lstObjCondi) {
            final Map<String,Object> mapCondition = (Map<String,Object>) condition;
            if (mapCondition.containsKey('name') && (String) mapCondition.get('name') != 'exception') {
                final Map<String,Object> mapValue = (Map<String,Object>) mapCondition.get('value');
                if (mapValue.containsKey('isReviewIndicator') && (Boolean) mapValue.get('isReviewIndicator') == true && mapPscca.containsKey((String) mapCondition.get('name'))) {
                    final PriceConditionsToReview_Wrapper pctr = new PriceConditionsToReview_Wrapper();
                    pctr.family = mapCatCond.get(mapPscca.get((String) mapCondition.get('name')).gf_psc_condition_id__c).gf_psc_family_id__r.gf_psc_family_product_name__c + ' / ' + mapCatCond.get(mapPscca.get((String) mapCondition.get('name')).gf_psc_condition_id__c).gf_psc_family_id__r.Name;
                    pctr.condition = mapPscca.get((String) mapCondition.get('name')).gf_psc_atribute_id__r.Name + ' - ' + mapPscca.get((String) mapCondition.get('name')).gf_psc_condition_id__r.Name;
                    pctr.orderCondition = mapPscca.get((String) mapCondition.get('name')).gf_psc_condition_id__r.gf_psc_cond_visual_ord_number__c;
                    pctr.orderFamily = mapPscca.get((String) mapCondition.get('name')).gf_psc_condition_id__r.gf_psc_family_id__r.cuco__gf_psc_fmly_visual_ord_number__c;
                    pctr.proposed = getValue((String) mapValue.get('value'));
                    String inputMin = null;
                    String inputMax = null;
                    if (mapValue.containsKey('minimun') && mapValue.get('minimun') != null) {
                        inputMin = (String) mapValue.get('minimun');
                    }
                    if (mapValue.containsKey('maximun') && mapValue.get('maximun') != null) {
                        inputMax = (String) mapValue.get('maximun');
                    }
                    pctr.delegated = getRange(inputMin, inputMax);
                    listToReturn.add(pctr);
                }
            }
        }
        return listToReturn;
    }
    /**
    * @description get rounded value
    * @param String : string value to round
    * @return String, with the rounded value
    */
    public static String getValue (String inputValue) {
        return String.valueOf(Decimal.valueOf(inputValue.replace(',','.')).setScale(2, System.RoundingMode.HALF_EVEN));
    }

    /**
    * @description get range for min and max
    * @param inputMin : String with the min value
    * @param inputMax : String with the max value
    * @return String, with the range of both conditions
    */
    public static String getRange (String inputMin, String inputMax) {

        String range = '';
        if (inputMin != null && inputMax != null) {
            range = getValue(inputMin) + ' - ' + getValue(inputMax);
        } else if (inputMin != null) {
            range = 'min ' + getValue(inputMin);
        } else if (inputMax != null) {
            range = 'max ' + getValue(inputMax);
        } else {
            range = '';
        }
        return range;
    }

    /**
    * @description get conditions per family
    * @param inputConditions : List<PriceConditionsToReview_Wrapper>
    * @return List<PriceFamily_Wrapper>, with the price conditions per family
    */
    public static List<PriceFamily_Wrapper> getCondPerFam (List<PriceConditionsToReview_Wrapper> inputConditions) {

        final List<PriceFamily_Wrapper> listToReturn = new List<PriceFamily_Wrapper>();
        final Map<String, List<PriceConditionsToReview_Wrapper>> mapCondiPerFam = new Map<String, List<PriceConditionsToReview_Wrapper>>();
        for (PriceConditionsToReview_Wrapper item : inputConditions) {
            if (mapCondiPerFam.containsKey(item.family)) {
                mapCondiPerFam.get(item.family).add(item);
            } else {
                final List<PriceConditionsToReview_Wrapper> lstPfw = new List<PriceConditionsToReview_Wrapper>();
                lstPfw.add(item);
                mapCondiPerFam.put(item.family, lstPfw);
            }
        }

        for (String fam : mapCondiPerFam.keySet()) {
            final PriceFamily_Wrapper pfw = new PriceFamily_Wrapper();
            pfw.family = fam;
            pfw.conditionList = mapCondiPerFam.get(fam);
            listToReturn.add(pfw);
        }
        return listToReturn;
    }

    /**
    * @description make decision price call
    * @param profAnalysis : profitability analysis wrapper object
    * @param decisionCode : decision code
    * @param decisionComments : decision comments
    * @return HttpResponse, with the price response
    */
    public static HttpResponse callPriceDecision (ProfitabilityAnalysis_Wrapper profAnalysis, String decisionCode, String decisionComments) {

        final PriceDecision_Helper pdh = new PriceDecision_Helper(profAnalysis, decisionCode, decisionComments);
        return pdh.callWS();
    }

    /**
    * @description get the service branch and put in wrapper
    * @param paWrapper : ProfitabilityAnalysis_Wrapper
    * @param decisionResponse : String
    * @return ProfitabilityAnalysis_Wrapper : with the branch code update
    */
    public static ProfitabilityAnalysis_Wrapper updatedelegatedBranch (ProfitabilityAnalysis_Wrapper paWrapper, String decisionResponse) {

        final Map<String,Object> mapDecisionResp = (Map<String,Object>) JSON.deserializeUntyped(decisionResponse);
        if (mapDecisionResp.containsKey('negotiationDecision')) {
            final Map<String,Object> mapdecision = (Map<String,Object>) mapDecisionResp.get('negotiationDecision');
            if (mapdecision.containsKey('destinationBranchCode')) {
                paWrapper.delegatedBranchCode = (String) mapdecision.get('destinationBranchCode');
            }
        }
        return paWrapper;
    }

    /**
    * @description Get exceptions list from service response
    * @param priceResponse : JSON response from price WS
    * @return Map<String,Object>, with the update result
    */
    public static List<Object> getExceptionsFromService (String priceResponse) {
        List<Object> lstToReturn = new List<Object>();
        final Map<String,Object> mapPriceResponse = (Map<String,Object>) JSON.deserializeUntyped(priceResponse);
        if (mapPriceResponse.containsKey('exceptions')) {
            List<Object> lstExceptions = (List<Object>) mapPriceResponse.get('exceptions');
            for (Object excptObj : lstExceptions) {
                final Map<String, Object> dataException = (Map<String, Object>) excptObj;
                dataException.put('name', String.valueOf(dataException.get('name')).subString(0,1).toUpperCase() + String.valueOf(dataException.get('name')).subString(1).toLowerCase());
                lstToReturn.add(dataException);
            }
        }
        return lstToReturn;
    }
}