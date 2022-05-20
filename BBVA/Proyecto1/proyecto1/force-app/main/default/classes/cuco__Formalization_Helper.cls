/**
* ────────────────────────────────────────────────────────────────────
* Formalization_Helper
* Helper
* ────────────────────────────────────────────────────────────────────
* @author     Javier Soto
* @modifiedBy
* @version     1.0
* @created     2021-04-30
* @modified
* @systemLayer Service
* ────────────────────────────────────────────────────────────────────
* @changes
* @author 			Oscar Gomez
* @modifiedDate     2021-05-11
* @description		logic for formalize_cmp
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Formalization_Helper {

    // Private constructor to avoid sonar err
    @TestVisible
    private Formalization_Helper() {}

    // String with Combined value
    private static final String COMBINED_STRING = 'Combined';

    // String with Automatic value
    private static final String AUTOMATIC_STRING = 'Automatic';

    /**
    * @description Returns formalization Type (Automatic or Combined)
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @return String with formalization Type (Automatic or Combined)
    */
    public static String getFormType(ProfitabilityAnalysis_Wrapper profAnalysis) {
        String returnType;
        if(profAnalysis.isSpecificContractsScope) {
            returnType = COMBINED_STRING;
        } else {
            if (profAnalysis.flatRate != null && Utils.isFilled(profAnalysis.flatRate.requestType)) {
                returnType = COMBINED_STRING;
            } else {
                returnType = checkAdditionalConditions(profAnalysis,returnType);
                returnType = checkManualConditions(profAnalysis,returnType);
                returnType = checkPkgRequests(profAnalysis,returnType);
                returnType = checkPkgScope(profAnalysis,returnType);
            }
        }
        return Utils.isFilled (returnType) ? returnType : AUTOMATIC_STRING;
    }
    /**
    * @description Updates returnType according to business logic
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param returnType : String with formalization Type (Automatic or Combined)
    * @return void
    */
    private static String checkAdditionalConditions(ProfitabilityAnalysis_Wrapper profAnalysis, String returnType) {
        String finalReturnType = returnType;
        if ((profAnalysis.typology == 'Renewal' || profAnalysis.typology == 'Novation') && profAnalysis.originEndDate != profAnalysis.endDate && (Utils.isFilledList(profAnalysis.packages.forfaitPackageList) || Utils.isFilledList(profAnalysis.packages.gipPackageList) || Utils.isFilledObject(profAnalysis.flatRate))) {
            finalReturnType = COMBINED_STRING;
        }
        return finalReturnType;
    }
    /**
    * @description Updates returnType according to business logic
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param returnType : String with formalization Type (Automatic or Combined)
    * @return void
    */
    private static String checkManualConditions(ProfitabilityAnalysis_Wrapper profAnalysis, String returnType) {
        String finalReturnType = returnType;
        if(!Utils.isFilled(returnType) && Utils.isFilledObject(profAnalysis.conditionsList)) {
            for (ProfitabilityAnalysis_Wrapper.Condition unitCondition : profAnalysis.conditionsList) {
                if (unitCondition.formMethod == 'Manual') {
                    finalReturnType = COMBINED_STRING;
                }
            }

        }
        return finalReturnType;
    }
    /**
    * @description Updates returnType according to business logic
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param returnType : String with formalization Type (Automatic or Combined)
    * @return void
    */
    private static String checkPkgRequests(ProfitabilityAnalysis_Wrapper profAnalysis, String returnType) {
        String finalReturnType = returnType;
        if(!Utils.isFilled(returnType) && Utils.isFilledObject(profAnalysis.packages)) {
            List<Package_Wrapper> combinedForfaitGip = new List<Package_Wrapper>();
            if(Utils.isFilledList(profAnalysis.packages.forfaitPackageList)) {
                combinedForfaitGip.addAll(profAnalysis.packages.forfaitPackageList);
            }
            if(Utils.isFilledList(profAnalysis.packages.gipPackageList)) {
                combinedForfaitGip.addAll(profAnalysis.packages.gipPackageList);
            }
            for (Package_Wrapper pkgGipForfait : combinedForfaitGip) {
                if (Utils.isFilled(pkgGipForfait.editRequestId) || Utils.isFilled(pkgGipForfait.cancellationRequestId) || Utils.isFilled(pkgGipForfait.newRequestId)) {
                    finalReturnType = COMBINED_STRING;
                    break;
                }
            }
        }
        return finalReturnType;
    }
    /**
    * @description Updates returnType according to business logic
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param returnType : String with formalization Type (Automatic or Combined)
    * @return void
    */
    private static String checkPkgScope(ProfitabilityAnalysis_Wrapper profAnalysis, String returnType) {
        String finalReturnType = returnType;
        if(!Utils.isFilled(returnType) && Utils.isFilledObject(profAnalysis.packages)) {
            List<Package_Wrapper> combinedForfaitComm = new List<Package_Wrapper>();
            if(Utils.isFilledList(profAnalysis.packages.forfaitPackageList)) {
                combinedForfaitComm.addAll(profAnalysis.packages.forfaitPackageList);
            }
            if(Utils.isFilledList(profAnalysis.packages.commPackageList)) {
                combinedForfaitComm.addAll(profAnalysis.packages.commPackageList);
            }
            for (Package_Wrapper pkgCommForfait : combinedForfaitComm) {
                if (pkgCommForfait.scope.id == 'All' || pkgCommForfait.scope.id == 'International') {
                    finalReturnType = COMBINED_STRING;
                    break;
                }
            }
        }
        return finalReturnType;
    }

    /**
    * @description Updates profitability analysis wrapper info
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param mapParameters : Map<String,Object> with parameters to handle
    * @return profAnalysis
    */
    public static Map<String,Object> callService(ProfitabilityAnalysis_Wrapper profAnalysis, Map<String,Object> mapParameters) {
        Map<String,Object> returnMap = new Map<String,Object>();
        final Date startDate = (Date) mapParameters.get('startDate');
        final Date expiryDate = (Date) mapParameters.get('expiryDate');
        final String comments = (String) mapParameters.get('comments');

        /* Update wrapper */
        profAnalysis.startDate = startDate;
        profAnalysis.endDate = expiryDate;

        /* Call services */
        final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();

        /* Check comments and call decision price */
        String finalComments;
        if(comments == null || comments == '') {
            finalComments = Label.form_default_comments;
        } else {
            finalComments = comments;
        }
        mapParameters.put('finalComments', finalComments);

        if (profAnalysis.status == 'Pending Send for Manual Formalization') {
            returnMap = callPicasso(profAnalysis, returnMap, mapParameters);
        } else {
            if(cmt.price_approval_type__c == true && profAnalysis.priceApprovalId != null) {

                final PriceDecision_Helper decision = new PriceDecision_Helper(profAnalysis, cmt.cuco__price_init_form_decision_id__c, finalComments);
                final HttpResponse respDecision = decision.callWs();

                switch on respDecision.getStatusCode() {
                    when 200 {
                        returnMap = Formalization_Helper.checkTypology(profAnalysis, returnMap, mapParameters);
                    }
                    when else {
                        String error = null;
                        Map<String,Object> errorMap = (Map<String,Object>) JSON.deserializeUntyped(respDecision.getBody());
                        if (errorMap.containsKey('error-message')) {
                            error = (String) errorMap.get('error-message');
                        }
                        if (error == null) {
                            returnMap.put('success', false);
                            returnMap.put('message', Label.price_init_form_error_generic);
                        } else {
                            returnMap.put('success', false);
                            returnMap.put('message', Label.price_init_form_error_detail  + ' ' + error);
                        }
                    }
                }
            } else {
                returnMap = Formalization_Helper.checkTypology(profAnalysis, returnMap, mapParameters);
            }
        }

        returnMap.put('wrapper',profAnalysis);
        return returnMap;
    }

    /**
    * @description private method to check typology and continue operating
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param mapResponse : map with current response
    * @param mapParameters : Map<String,Object> with parameters to handle
    * @return Map<String,Object>
    */
    private static Map<String,Object> checkTypology(ProfitabilityAnalysis_Wrapper profAnalysis, Map<String,Object> mapResponse, Map<String,Object> mapParameters) {
        Map<String,Object> returnMap = new Map<String,Object>();
        returnMap = mapResponse;
        switch on profAnalysis.typology {
            when 'New' {
                final RequestCondNotebook_Helper backendNew = new RequestCondNotebook_Helper(profAnalysis);
                String typeRequest = '';
                HttpResponse respNew;
                if(profAnalysis.autoFormRequestId == null) {
                    respNew = backendNew.callWs('requestCondNotebookCreation');
                    typeRequest = 'requestCondNotebookCreation';
                } else {
                    respNew = backendNew.callWs('requestCondNotebookRenovation');
                }
                mapParameters.put('response', respNew);
                mapParameters.put('typeRequest', typeRequest);
                returnMap = Formalization_Helper.backendAction(profAnalysis, returnMap, mapParameters);
            }
            when 'Novation','Renewal' {
                final RequestCondNotebook_Helper backendNovRen = new RequestCondNotebook_Helper(profAnalysis);
                final HttpResponse respNovRen = backendNovRen.callWs('requestCondNotebookRenovation');
                mapParameters.put('response', respNovRen);
                mapParameters.put('typeRequest', '');
                returnMap = Formalization_Helper.backendAction(profAnalysis, returnMap, mapParameters);
            }
            when 'Cancellation' {
                final RequestCondNotebookCancellation_Helper backendCan = new RequestCondNotebookCancellation_Helper(profAnalysis);
                final HttpResponse respCan = backendCan.callWs();
                mapParameters.put('response', respCan);
                mapParameters.put('typeRequest', '');
                returnMap = Formalization_Helper.backendAction(profAnalysis, returnMap, mapParameters);
            }
        }
        return returnMap;
    }

    /**
    * @description private method to continue calling services
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param mapResponse : map with current response
    * @param mapParameters : Map<String,Object> with parameters to handle
    * @return Map<String,Object>
    */
    private static Map<String,Object> backendAction(ProfitabilityAnalysis_Wrapper profAnalysis, Map<String,Object> mapResponse, Map<String,Object> mapParameters) {
        Map<String,Object> returnMap = new Map<String,Object>();
        final String typeRequest = (String) mapParameters.get('typeRequest');
        final HttpResponse response = (HttpResponse) mapParameters.get('response');
        returnMap = mapResponse;

        switch on response.getStatusCode() {
            when 201, 204 {
                if(profAnalysis.typology == Label.new && typeRequest == 'requestCondNotebookCreation') {
                    final String headerType = response.getHeader('location');
                    final String autoFormReqId = headerType.substringAfterLast('/');
                    profAnalysis.autoFormRequestId = autoFormReqId;
                } else if (profAnalysis.typology != Label.new) {
                    profAnalysis.autoFormRequestId = profAnalysis.code;
                }
                returnMap = callPicasso(profAnalysis, returnMap, mapParameters);
            }
            when else {

                String error = null;
                Map<String,Object> errorMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                if (errorMap.containsKey('messages')) {
                    List<Object> messageMapList = (List <Object>) errorMap.get('messages');
                    Map<String,Object> messageMap = (Map<String,Object>) messageMapList[0];
                    if (messageMap.containsKey('message')) {
                        error = (String) messageMap.get('message');
                    }
                }
                if (error == null) {
                    returnMap.put('success', false);
                    returnMap.put('message', Label.automatic_form_error_generic);
                } else {
                    returnMap.put('success', false);
                    returnMap.put('message', Label.automatic_form_error_detail  + ' ' + error);
                }
            }
        }

        return returnMap;
    }

    /**
    * @description private method to continue calling services
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper with profitability analysis information
    * @param mapResponse : map with current response
    * @param mapParameters : Map<String,Object> with parameters to handle
    * @return Map<String,Object>
    */
    private static Map<String,Object> callPicasso(ProfitabilityAnalysis_Wrapper profAnalysis, Map<String,Object> mapResponse, Map<String,Object> mapParameters) {
        Map<String,Object> returnMap = new Map<String,Object>();
        final String finalComments = (String) mapParameters.get('finalComments');
        final String screenShot = (String) mapParameters.get('screenShot');
        returnMap = mapResponse;
        final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();
        final Type permissionsClass = Type.forName(cmt.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        final String formType = Formalization_Helper.getFormType(profAnalysis);

        if(formType == Label.form_combined_method) {
            final RequestPicasso_Helper picasso = new RequestPicasso_Helper(profAnalysis, cmt.picasso_formalization_id__c, finalComments);
            final HttpResponse response = picasso.callWs();
            switch on response.getStatusCode() {
                when 200 {
                    final List<Map<String, Object>> res = new List<Map<String, Object>>();
                    final Map<String, Object> mapValues = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    for (Object elem : (List<Object>)mapValues.get('request')) {
                        final Map<String, Object> mapRequest = (Map<String, Object>)elem;
                        res.add(mapRequest);
                    }
                    profAnalysis.manualFormRequestId = (String) res[0].get('operationId');
                    returnMap = profAnalysisItf.setPAFormalization(profAnalysis, formType, finalComments, screenShot);
                }
                when else {
                    if (response.getBody() == null) {
                        returnMap.put('success', false);
                        returnMap.put('message', Label.manual_form_error_generic);
                    } else {
                        final Map<String, Object> mapValuesErr = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                        String errMessage;
                        if (mapValuesErr.get('error-message') == null) {
                            errMessage = Label.manual_form_error_generic;
                        } else {
                            errMessage = Label.manual_form_error_detail + ' ' + (String) mapValuesErr.get('error-message');
                        }
                        returnMap.put('success', false);
                        returnMap.put('message', errMessage);
                    }
                    if (profAnalysis.status != 'Pending Send for Manual Formalization') {
                        profAnalysisItf.setPAFormalization(profAnalysis, null, null, null);
                    }
                }
            }
        } else {
            returnMap = profAnalysisItf.setPAFormalization(profAnalysis, formType, finalComments, screenShot);
        }

        return returnMap;
    }
}