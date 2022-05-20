/**
* ────────────────────────────────────────────────────────────────────
* Price_approval_Service
* Service class for price aprproval implementation apex classes
* ────────────────────────────────────────────────────────────────────
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-07
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Price_approval_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Price_approval_Service() {}

    /**
    * @description Check if user can do request creation action
    * @param profSheetId : Current record Id
    * @param typology : typology of profSheet
    * @return Map<String, Object> : A map with the response
    */
    public static Map<String,Object> requestData (Id recordId) {

        final Map<String,Object> mapToReturn = new Map<String,Object>();

        //Obtain the input profitability analysis details
        final ProfitabilityAnalysis_Selector paSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> paList = paSelector.selectById(new Set<Id>{recordId});

        if (paList != null && !paList.isEmpty()) {

            final ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis(recordId);
            //call price negotiation service
            String negotiationId = paWrapper.priceApprovalId != null ? paWrapper.priceApprovalId : null;
            final HttpResponse response = Price_approval_Helper.callPriceNegotiation(paWrapper, negotiationId);
            //if the call response is ok and has 200
            if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {

                final String priceResponse = response.getBody();

                if (paWrapper.originStartDate != null && paWrapper.originEndDate != null) {
                    mapToReturn.put('originStartDate', paWrapper.originStartDate.format() + ' - ' + paWrapper.originEndDate.format());
                    mapToReturn.put('originEndDate', paWrapper.originEndDate);
                }
                if (paWrapper.endDate != null) {
                    mapToReturn.put('proposedEndDate', paWrapper.endDate);
                }
                mapToReturn.put('typology', paWrapper.typology);
                mapToReturn.put('profAnalysisWrapp', paWrapper);
                //get ARCE date
                final Date fecha = ProfitabilityAnalysis_Service.getARCEDate(recordId);
                mapToReturn.put('dateArce', fecha != null ? fecha.format() : null);

                //make the profitability update
                final Map<String,Object> mapUpdateResp = Price_approval_Helper.updateProfitAnalys(paList, priceResponse);
                mapToReturn.put('paUpdateSuccess', mapUpdateResp.get('paUpdateSuccess'));
                mapToReturn.put('paUpdateMessage', mapUpdateResp.get('paUpdateMessage'));

                //get service price decisions
                final Map<String,Object> mapPriceDeci = Price_approval_Helper.getDecisionsFromService(priceResponse, paWrapper);
                mapToReturn.put('decisionWrapperList', mapPriceDeci.get('decisionWrapperList'));

                //get service price conditions
                final Map<String,Object> mapPriceCond = Price_approval_Helper.getConditionsFromService(priceResponse);
                mapToReturn.put('listaConditions', mapPriceCond.get('listaConditions'));

                //get service price exceptions
                final List<Object> lstExceptions = Price_approval_Helper.getExceptionsFromService(priceResponse);
                mapToReturn.put('lstExceptions', lstExceptions);
            }
            mapToReturn.put('priceStatusCode', response.getStatusCode());
            mapToReturn.put('priceResponseBody', response.getBody());
        }
        return mapToReturn;
    }

    /**
    * @description method to call price decision service and persist data
    * @param inputAttributes : Map with the info from component: profAnalId, decisionCode, proposedEndDate, decisionComments and screenshot
    * @return Map<String, Object> :map with the response
    */
    public static Map<String,Object> persistData (Map<String,Object> inputAttributes) {

        Map<String,Object> mapReturn = new Map<String,Object>();
        ProfitabilityAnalysis_Wrapper paWrapper = ProfitabilityAnalysis_Helper.getProfAnalysis((Id) inputAttributes.get('profAnalId'));
        final HttpResponse decisionResp = Price_approval_Helper.callPriceDecision (paWrapper, (String) inputAttributes.get('decisionCode'), (String) inputAttributes.get('decisionComments'));

        if (decisionResp.getStatusCode() == 200 || decisionResp.getStatusCode() == 201) {
            paWrapper = Price_approval_Helper.updatedelegatedBranch(paWrapper, decisionResp.getBody());
            paWrapper.endDate = Date.valueOf((String)inputAttributes.get('proposedEndDate'));

            mapReturn = ProfitabilityAnalysis_Service.setPriceDecision(paWrapper, (String) inputAttributes.get('decisionCode'), (String) inputAttributes.get('decisionComments'), (String) inputAttributes.get('screenshot'));
        } else {
            String error = null;
            final Map<String,Object> mapDecisionResp = (Map<String,Object>) JSON.deserializeUntyped(decisionResp.getBody());
            if (mapDecisionResp.containsKey('error-message')) {
                error = Label.price_decision_error_detail + (String) mapDecisionResp.get('error-message');
            } else {
                error = Label.price_decision_error_generic;
            }
            mapReturn.put('message', error);
        }

        return mapReturn;
    }
}