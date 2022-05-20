/**
* ────────────────────────────────────────────────────────────────────
* RequestPicasso_Helper
* Helper class for sendPicassoRequest ws
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-27
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:NcssMethodCount, sf:TooManyMethods')
public class RequestPicasso_Helper {

    /**
    * @description String with user code value
    */
    public String userCode {get;set;}

    /**
    * @description String with external id value
    */
    public String externalId {get;set;}

    /**
    * @description String with channel id value
    */
    public String channelId {get;set;}

    /**
    * @description String with request type code value
    */
    public String requestTypeCode {get;set;}

    /**
    * @description String with branch code value
    */
    public String officeCode {get;set;}

    /**
    * @description String with operation branch code value
    */
    public String operationBranchCode {get;set;}

    /**
    * @description String with product information value
    */
    public String productInformation {get;set;}

    /**
    * @description Public constructor to RequestPicasso_Helper
    * @param profAnalysis: Wrapper with prof analysis record info
    * @param requestDecision: String with decision value
    * @param requestComments: String with comments value
    */
    public RequestPicasso_Helper(ProfitabilityAnalysis_Wrapper profAnalysis, String requestDecision, String requestComments) {

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        // Fill attributes
        this.userCode = ProfitabilityAnalysis_Service.obtainUserInfo((Id) UserInfo.getUserId());
        this.externalId = profAnalysis.id;
        this.channelId = genConfig.picasso_channel_id__c;
        this.requestTypeCode = genConfig.picasso_request_type__c;
        this.officeCode = profAnalysis.branchCode;
        this.operationBranchCode = profAnalysis.branchCode;
        this.productInformation = generateProductInformation(profAnalysis, requestDecision, requestComments);
    }

    /**
    * @description Helper method to fill product information string to send on the request
    * @param profAnalysis: Wrapper with prof analysis record info
    * @param requestDecision: String with decision value
    * @param requestComments: String with comments value
    * @return String, with the json serialize
    */
    private static String generateProductInformation(ProfitabilityAnalysis_Wrapper profAnalysis, String requestDecision, String requestComments) {
        final Map<String, Object> mapProductInformation = new Map<String, Object>();

        // taxonomy
        mapProductInformation.put('taxonomy', profAnalysis.manualFormRequestId == null ? '01' : '02');

        // request decision
        mapProductInformation.putAll(generateRequestDecision(requestDecision));

        // request description
        mapProductInformation.put('request.description', requestComments);

        // request operation
        mapProductInformation.put('request.operation', generateRequestOperation(profAnalysis));

        // request participants
        mapProductInformation.put('request.participants', generateRequestParticipants(profAnalysis.participantsList));

        // request conditions
        mapProductInformation.put('request.conditions', generateRequestConditions(profAnalysis));

        // request flat
        mapProductInformation.putAll(generateRequestFlat(profAnalysis));

        // Only if packages is filled
        if (profAnalysis.packages != null) {
            // request commPackages
            mapProductInformation.put('request.commPackages', generateRequestCommPackages(profAnalysis));

            // request forfaitPackages
            mapProductInformation.put('request.forfaitPackages', generateRequestForfaitPackages(profAnalysis));

            // request gipPackages
            mapProductInformation.put('request.gipPackages', generateRequestGipPacakges(profAnalysis));
        }
        return JSON.serialize(mapProductInformation).escapeJava().replace('%','&#37;');
    }

    /**
    * @description Helper method to fill request decision id and description to main map
    * @param requestDecision: String with decision value
    * @return Map<String, Object>, with the request decision values to main map
    */
    private static Map<String, Object> generateRequestDecision(String requestDecision) {
        final Map<String, Object> mapRequestDecision = new Map<String, Object>();
        mapRequestDecision.put('request.decision.id', requestDecision);
        switch on requestDecision {
            when '05' {
                mapRequestDecision.put('request.decision.description', Label.picasso_rqt_formalization);
            }
            when '10' {
                mapRequestDecision.put('request.decision.description', Label.picasso_rqt_notification);
            }
            when else {
                mapRequestDecision.put('request.decision.description', null);
            }
        }
        return mapRequestDecision;
    }

    /**
    * @description Helper method to fill request operation map to main map
    * @param profAnalysis: Wrapper with prof analysis record info
    * @return List<Object>, with the request operation values
    */
    private static List<Object> generateRequestOperation(ProfitabilityAnalysis_Wrapper profAnalysis) {
        final List<Object> lstRequestOperation = new List<Object>();

        // request id
        final Map<String, Object> mapRequestId = new Map<String, Object>();
        mapRequestId.put('id', 'request.type.id');
        mapRequestId.put('value', profAnalysis.typology);
        mapRequestId.put('description', Label.picasso_rqt_id_label);
        mapRequestId.put('formatType', 'Text');
        lstRequestOperation.add(mapRequestId);

        // request desc
        lstRequestOperation.add(generateRequestDesc(profAnalysis.typology));

        // request name
        final Map<String, Object> mapRequestName = new Map<String, Object>();
        mapRequestName.put('id', 'name');
        mapRequestName.put('value', profAnalysis.originName == null ? profAnalysis.Name : profAnalysis.originName);
        mapRequestName.put('description', Label.picasso_rqt_name_label);
        mapRequestName.put('formatType', 'Text');
        lstRequestOperation.add(mapRequestName);

        // request code
        final Map<String, Object> mapRequestCode = new Map<String, Object>();
        mapRequestCode.put('id', 'code');
        mapRequestCode.put('value', profAnalysis.code == null ? profAnalysis.autoFormRequestId  : profAnalysis.code);
        mapRequestCode.put('description', Label.picasso_rqt_code_label);
        mapRequestCode.put('formatType', 'Text');
        lstRequestOperation.add(mapRequestCode);

        // request branch code
        final Map<String, Object> mapRequestBranchCode = new Map<String, Object>();
        mapRequestBranchCode.put('id', 'branch.code');
        mapRequestBranchCode.put('value', profAnalysis.branchCode);
        mapRequestBranchCode.put('description', Label.picasso_rqt_branch_label);
        mapRequestBranchCode.put('formatType', 'Text');
        lstRequestOperation.add(mapRequestBranchCode);

        // request start date
        final Map<String, Object> mapRequestStartDate = new Map<String, Object>();
        mapRequestStartDate.put('id', 'request.start.date');
        mapRequestStartDate.put('value', profAnalysis.startDate);
        mapRequestStartDate.put('description', Label.picasso_rqt_start_date_label);
        mapRequestStartDate.put('formatType', 'Date');
        lstRequestOperation.add(mapRequestStartDate);

        // request end date
        final Map<String, Object> mapRequestEndDate = new Map<String, Object>();
        mapRequestEndDate.put('id', 'request.end.date');
        mapRequestEndDate.put('value', profAnalysis.endDate);
        mapRequestEndDate.put('description', Label.picasso_rqt_end_date_label);
        mapRequestEndDate.put('formatType', 'Date');
        lstRequestOperation.add(mapRequestEndDate);

        // request owner name
        final Map<String, Object> mapRequestOwnerName = new Map<String, Object>();
        mapRequestOwnerName.put('id', 'owner.name');
        mapRequestOwnerName.put('value', profAnalysis.ownerName);
        mapRequestOwnerName.put('description', Label.picasso_rqt_owner_name_label);
        mapRequestOwnerName.put('formatType', 'Text');
        lstRequestOperation.add(mapRequestOwnerName);

        // request specific contract flag
        final Map<String, Object> mapRequestSpecificContractFlag = new Map<String, Object>();
        mapRequestSpecificContractFlag.put('id', 'specific.contract.flag');
        mapRequestSpecificContractFlag.put('value', String.valueOf(profAnalysis.isSpecificContractsScope));
        mapRequestSpecificContractFlag.put('description', Label.picasso_rqt_contracts_flag_label);
        mapRequestSpecificContractFlag.put('formatType', 'Boolean');
        lstRequestOperation.add(mapRequestSpecificContractFlag);

        // request specific contract flag desc
        final Map<String, Object> mapRequestSpecificContractFlagDesc = new Map<String, Object>();
        mapRequestSpecificContractFlagDesc.put('id', 'specific.contract.flag.desc');
        mapRequestSpecificContractFlagDesc.put('value', profAnalysis.contractsScopeDesc);
        mapRequestSpecificContractFlagDesc.put('description', Label.picasso_rqt_contracts_flag_desc_label);
        mapRequestSpecificContractFlagDesc.put('formatType', 'Text');
        lstRequestOperation.add(mapRequestSpecificContractFlagDesc);

        // request transactional offer
        final Map<String, Object> mapRequestTransactionalOffer = new Map<String, Object>();
        mapRequestTransactionalOffer.put('id', 'transactional.offer');
        mapRequestTransactionalOffer.put('value', profAnalysis.originTransOffer);
        mapRequestTransactionalOffer.put('description', Label.picasso_rqt_trans_offer_label);
        mapRequestTransactionalOffer.put('formatType', 'Text');
        lstRequestOperation.add(mapRequestTransactionalOffer);

        return lstRequestOperation;
    }

    /**
    * @description Helper method to fill request desc to avoid NCSS sonar
    * @param typology: String with typology of prof analysis
    * @return Map<String, Object>, with the request desc values
    */
    private static Map<String, Object> generateRequestDesc(String typology) {
        final Map<String, Object> mapRequestDesc = new Map<String, Object>();
        mapRequestDesc.put('id', 'request.type.desc');
        switch on typology {
            when 'New' {
                mapRequestDesc.put('value', Label.picasso_rqt_new);
            }
            when 'Novation' {
                mapRequestDesc.put('value', Label.picasso_rqt_novation);
            }
            when 'Renewal' {
                mapRequestDesc.put('value', Label.picasso_rqt_renewal);
            }
            when 'Cancellation' {
                mapRequestDesc.put('value', Label.picasso_rqt_cancellation);
            }
        }
        mapRequestDesc.put('description', Label.picasso_rqt_desc_label);
        mapRequestDesc.put('formatType', 'Text');
        return mapRequestDesc;
    }

    /**
    * @description Helper method to fill request participants map to main map
    * @param profAnalysis: Wrapper with prof analysis record info
    * @return List<Object>, with the request participants values
    */
    private static List<Object> generateRequestParticipants(List<ProfitabilityAnalysis_Wrapper.Participants> lstParticipants) {
        final List<Object> lstRequestParticipants = new List<Object>();
        for (ProfitabilityAnalysis_Wrapper.Participants participant : lstParticipants) {
            final Map<String, Object> mapParticipant = new Map<String, Object>();
            mapParticipant.put('name', participant.name);
            mapParticipant.put('documentNumber', participant.documentNum);
            mapParticipant.put('clientCode', participant.code);
            lstRequestParticipants.add(mapParticipant);
        }
        return lstRequestParticipants;
    }

    /**
    * @description Helper method to fill request conditions map to main map
    * @param profAnalysis: Wrapper with prof analysis record info
    * @return List<Object>, with the request conditions values
    */
    private static List<Object> generateRequestConditions(ProfitabilityAnalysis_Wrapper profAnalysis) {
        List<Object> lstRequestConditions = new List<Object>();
        List<ProfitabilityAnalysis_Wrapper.Condition> lstConditions = profAnalysis.conditionsList;
        if (profAnalysis.isSpecificContractsScope) { // If true, only cond with empty source
            for (ProfitabilityAnalysis_Wrapper.Condition condition : lstConditions) {
                if (condition.source == null) {
                    lstRequestConditions.add(generateCondValues(condition));
                }
            }
        } else {
            // Search for a forfait or gip pkg with certain info
            Boolean hasPkgConditions = checkPkgConditions(profAnalysis);
            lstRequestConditions = generateCondWithoutSpecificContracts(hasPkgConditions, lstConditions);
        }
        return lstRequestConditions;
    }

    /**
    * @description Helper method to evaluate pkg conditions to know which conditions need to add
    * @param profAnalysis: Wrapper with profAnalysis info
    * @return Boolean, with the evaluate response
    */
    private static Boolean checkPkgConditions(ProfitabilityAnalysis_Wrapper profAnalysis) {
        Boolean hasPkgConditions = false;
        final List<Package_Wrapper> lstForfait = profAnalysis.packages.forfaitPackageList;
        final List<Package_Wrapper> lstGip = profAnalysis.packages.gipPackageList;

        final List<String> lstScope = new List<String>{'International', 'All'};
        if (lstForfait != null) {
            for (Package_Wrapper pkgForfaitWrapp : lstForfait) {
                if (lstScope.contains(pkgForfaitWrapp.scope.id)) {
                    hasPkgConditions = true;
                }
            }
        }

        if (!hasPkgConditions && lstGip != null) {
            for (Package_Wrapper pkgGipWrapp : lstGip) {
                if (lstScope.contains(pkgGipWrapp.scope.id)) {
                    hasPkgConditions = true;
                }
            }
        }
        return hasPkgConditions;
    }

    /**
    * @description Helper method to evaluate pkg conditions without specific contracts to know which conditions need to add
    * @param hasPkgConditions: Boolean with pkg evaluate result to know which filter use in conditions need to add
    * @param profAnalysis: Wrapper with profAnalysis info
    * @return Boolean, with the evaluate response
    */
    private static List<Object> generateCondWithoutSpecificContracts(Boolean hasPkgConditions, List<ProfitabilityAnalysis_Wrapper.Condition> lstConditions) {
        final List<Object> lstRequestConditions = new List<Object>();
        if (hasPkgConditions) {
            for (ProfitabilityAnalysis_Wrapper.Condition condition : lstConditions) {
                if (condition.source == null && (condition.formMethod == 'Manual' || condition.pkgInternationalScopeReview)) {
                    lstRequestConditions.add(generateCondValues(condition));
                }
            }
        } else {
            for (ProfitabilityAnalysis_Wrapper.Condition condition : lstConditions) {
                if (condition.source == null && condition.formMethod == 'Manual') {
                    lstRequestConditions.add(generateCondValues(condition));
                }
            }
        }
        return lstRequestConditions;
    }

    /**
    * @description Helper method to fill request condition with values
    * @param condition: Wrapper with condition info
    * @return Map<String, Object>, with the request condition
    */
    private static Map<String, Object> generateCondValues(ProfitabilityAnalysis_Wrapper.Condition condition) {
        final Map<String, Object> mapCondition = new Map<String, Object>();
        mapCondition.put('product', condition.product);
        mapCondition.put('family', condition.family);
        mapCondition.put('name', condition.name);
        mapCondition.put('id', condition.canonicalId);
        final List<Object> lstAttributes = new List<Object>();
        for (ProfitabilityAnalysis_Wrapper.Attribute attribute : condition.attributesList) {
            final Map<String, Object> mapAttribute = new Map<String, Object>();
            mapAttribute.put('description', attribute.name);
            if (attribute.valueType == 'Checkbox' && attribute.value == 'true') {
                mapAttribute.put('value', Label.picasso_yes);
                mapAttribute.put('formatType', 'Text');
            } else if (attribute.valueType == 'Checkbox' && attribute.value == 'false') {
                mapAttribute.put('value', Label.picasso_no);
                mapAttribute.put('formatType', 'Text');
            } else {
                mapAttribute.put('value', attribute.value);
                mapAttribute.put('formatType', attribute.valueType);
            }
            mapAttribute.put('id', attribute.canonicalId);
            lstAttributes.add(mapAttribute);
        }
        mapCondition.put('attributes', lstAttributes);
        return mapCondition;
    }

    /**
    * @description Helper method to fill request flat map to request map
    * @param profAnalysis: Wrapper with prof analysis record info
    * @return Map<String, Object>, with the request flat values
    */
    private static Map<String, Object> generateRequestFlat(ProfitabilityAnalysis_Wrapper profAnalysis) {
        final Map<String, Object> mapFlat = new Map<String, Object>();
        final List<String> lstTypology = new List<String>{'Renewal', 'Novation'};
        final List<String> lstFlatRequestType = new List<String>{'New', 'Modification', 'Cancellation'};

        if (profAnalysis.flatRate != null && ((lstTypology.contains(profAnalysis.typology) && profAnalysis.originEndDate != profAnalysis.endDate) || (lstFlatRequestType.contains(profAnalysis.flatRate.requestType)))) {
            // request flat request
            switch on profAnalysis.flatRate.requestType {
                when 'New' {
                    mapFlat.put('request.flat.request.id', Label.picasso_rqt_flat_new_id);
                    mapFlat.put('request.flat.request.description', Label.picasso_rqt_flat_new_desc);
                }
                when 'Modification' {
                    mapFlat.put('request.flat.request.id', Label.picasso_rqt_flat_modify_id);
                    mapFlat.put('request.flat.request.description', Label.picasso_rqt_flat_modify_desc);
                }
                when 'Cancellation' {
                    mapFlat.put('request.flat.request.id', Label.picasso_rqt_flat_cancel_id);
                    mapFlat.put('request.flat.request.description', Label.picasso_rqt_flat_cancel_desc);
                }
                when else {
                    mapFlat.put('request.flat.request.id', Label.picasso_rqt_flat_review_id);
                    mapFlat.put('request.flat.request.description', Label.picasso_rqt_flat_review_desc);
                }
            }

            // request flat general
            mapFlat.put('request.flat.general', generateReqFlatGeneral(profAnalysis.flatRate.flatRatesInfoAttList));

            // request flat accounts
            if (profAnalysis.flatRate.flatRateAccountsList != null) {
                mapFlat.putAll(generateReqFlatAccs(profAnalysis.flatRate));
            }

            // request flat conditions
            mapFlat.put('request.flat.conditions', generateReqFlatConditions(profAnalysis.flatRate.flatConditionsList));

            // request flat dynamicPricing
            mapFlat.put('request.flat.dynamicPricing', generateReqFlatDynamicPricing(profAnalysis.flatRate));
        } else {
            mapFlat.put('request.flat.request.id', null);
            mapFlat.put('request.flat.request.description', null);
            mapFlat.put('request.flat.general', new List<Object>());
            mapFlat.put('request.flat.accounts.comments', null);
            mapFlat.put('request.flat.accounts.accounts', new List<Object>());
            mapFlat.put('request.flat.conditions', new List<Object>());
            mapFlat.put('request.flat.dynamicPricing', new List<Object>());
        }
        return mapFlat;
    }

    /**
    * @description Helper method to fill request flat general list to request flat map
    * @param lstFlatAttbs: Wrapper with prof analysis flat rates attributes info
    * @return List<Object>, with the request flat general values
    */
    private static List<Object> generateReqFlatGeneral(List<ProfitabilityAnalysis_Wrapper.Attribute> lstFlatAttbs) {
        Map<String, ps_catalog_flat_rates_attribute__c> mapPSCatFRAttb = getCurrentPsCatFRAttbRecords();
        final List<Object> lstFlatGeneral = new List<Object>();
        for (ProfitabilityAnalysis_Wrapper.Attribute flatAttb : lstFlatAttbs) {
            mapPSCatFRAttb.remove(flatAttb.canonicalId);
            if (flatAttb.canonicalId != 'comflat.pygcomments') {
                final Map<String, Object> mapFlatAttb = new Map<String, Object>();
                mapFlatAttb.put('description', flatAttb.name);
                if (flatAttb.valueType == 'Checkbox' && flatAttb.value == 'true') {
                    mapFlatAttb.put('value', Label.picasso_yes);
                    mapFlatAttb.put('formatType', 'Text');
                } else if (flatAttb.valueType == 'Checkbox' && flatAttb.value == 'false') {
                    mapFlatAttb.put('value', Label.picasso_no);
                    mapFlatAttb.put('formatType', 'Text');
                } else {
                    mapFlatAttb.put('value', flatAttb.value);
                    mapFlatAttb.put('formatType', flatAttb.valueType);
                }
                mapFlatAttb.put('id', flatAttb.canonicalId);
                lstFlatGeneral.add(mapFlatAttb);
            }
        }

        if (!mapPSCatFRAttb.isEmpty()) {
            lstFlatGeneral.addAll(fillEmptyFlatGeneral(mapPSCatFRAttb));
        }
        return lstFlatGeneral;
    }

    /**
    * @description Helper method to get pyg attb from flat
    * @param lstFlatAttbs: Wrapper with prof analysis flat rates attibutes
    * @return ProfitabilityAnalysis_Wrapper.Attribute, with the attribute pyg
    */
    private static ProfitabilityAnalysis_Wrapper.Attribute getPYGCommentsAttb(List<ProfitabilityAnalysis_Wrapper.Attribute> lstFlatAttbs) {
        final ProfitabilityAnalysis_Wrapper.Attribute pygAttb;
        for (ProfitabilityAnalysis_Wrapper.Attribute flatAttb : lstFlatAttbs) {
            if (flatAttb.canonicalId == 'comflat.pygcomments') {
                pygAttb = flatAttb;
            }
        }
        return pygAttb;
    }

    /**
    * @description Helper method to fill request flat accounts map to request flat map
    * @param profAnalysisFlatRate: Wrapper with prof analysis flat rates info
    * @return Map<String, Object>, with the request flat accounts values
    */
    private static Map<String, Object> generateReqFlatAccs(ProfitabilityAnalysis_Wrapper.FlatRate profAnalysisFlatRate) {
        final Map<String, Object> mapReqFlatAcc = new Map<String, Object>();
        ProfitabilityAnalysis_Wrapper.Attribute pygAttb = getPYGCommentsAttb(profAnalysisFlatRate.flatRatesInfoAttList);
        if (pygAttb != null) {
            mapReqFlatAcc.put('request.flat.accounts.comments', pygAttb.value);
        }
        final List<Object> lstFlatAccs = new List<Object>();
        for (ProfitabilityAnalysis_Wrapper.FlatRteAccount flatRateAcc : profAnalysisFlatRate.flatRateAccountsList) {
            final Map<String, Object> mapFlatRateAcc = new Map<String, Object>();
            mapFlatRateAcc.put('code', flatRateAcc.code);
            mapFlatRateAcc.put('name', flatRateAcc.name);
            mapFlatRateAcc.put('percent', flatRateAcc.accountAttribute.value);
            mapFlatRateAcc.put('id', flatRateAcc.accountAttribute.canonicalId);
            lstFlatAccs.add(mapFlatRateAcc);
        }
        mapReqFlatAcc.put('request.flat.accounts.accounts', lstFlatAccs);
        return mapReqFlatAcc;
    }

    /**
    * @description Helper method to fill request flat conditions list to request flat map
    * @param lstFlatCond: Wrapper with prof analysis flat rates conditions info
    * @return List<Object>, with the request flat conditions values
    */
    private static List<Object> generateReqFlatConditions(List<ProfitabilityAnalysis_Wrapper.FlatCondition> lstFlatCond) {
        final List<Object> lstConditions = new List<Object>();
        for (ProfitabilityAnalysis_Wrapper.FlatCondition flatCond : lstFlatCond) {
            final Map<String, Object> mapFlatCondition = new Map<String, Object>();
            mapFlatCondition.put('product', flatCond.product);
            mapFlatCondition.put('family', flatCond.family);
            mapFlatCondition.put('name', flatCond.name);
            mapFlatCondition.put('id', flatCond.canonicalId);
            mapFlatCondition.put('volume', flatCond.estimatedVolume);
            lstConditions.add(mapFlatCondition);
        }
        return lstConditions;
    }

    /**
    * @description Helper method to fill request flat dynamic pricing list to request flat map
    * @param profAnalysisFlatRate: Wrapper with prof analysis flat rates info
    * @return List<Object>, with the request flat dynamic pricing values
    */
    private static List<Object> generateReqFlatDynamicPricing(ProfitabilityAnalysis_Wrapper.FlatRate profAnalysisFlatRate) {
        final List<Object> lstDP = new List<Object>();
        final List<ProfitabilityAnalysis_Wrapper.DpItem> lstFlatDP = profAnalysisFlatRate.dpItemList;
        for (ProfitabilityAnalysis_Wrapper.DpItem dpItem : lstFlatDP) {
            Map<String, Object> mapFlatDP = new Map<String, Object>();
            mapFlatDP.put('classification', dpItem.classification);
            mapFlatDP.put('name', dpItem.name);
            mapFlatDP.put('id', dpItem.canonicalId);
            mapFlatDP.put('cross', String.valueOf(dpItem.cross));
            final List<Object> lstDPAttbs = new List<Object>();
            for (ProfitabilityAnalysis_Wrapper.Attribute flatDPAttb : dpItem.dpAttList) {
                    final Map<String, Object> mapFlatDPAttb = new Map<String, Object>();
                    if (flatDPAttb.valueType == 'Checkbox' && flatDPAttb.value == 'true') {
                        mapFlatDPAttb.put('value', Label.picasso_yes);
                        mapFlatDPAttb.put('formatType', 'Text');
                    } else if (flatDPAttb.valueType == 'Checkbox' && flatDPAttb.value == 'false') {
                        mapFlatDPAttb.put('value', Label.picasso_no);
                        mapFlatDPAttb.put('formatType', 'Text');
                    } else {
                        mapFlatDPAttb.put('value', flatDPAttb.value);
                        mapFlatDPAttb.put('formatType', flatDPAttb.formatType);
                    }
                    mapFlatDPAttb.put('id', flatDPAttb.canonicalId);
                    mapFlatDPAttb.put('description', flatDPAttb.name);
                    lstDPAttbs.add(mapFlatDPAttb);
            }
            mapFlatDP.put('attributes', lstDPAttbs);
            lstDP.add(mapFlatDP);
        }
        return lstDP;
    }

    /**
    * @description Helper method to fill request commPackages map to request map
    * @param profAnalysis: Wrapper with prof analysis record info
    * @return List<Object>, with the request commPackages values
    */
    private static List<Object> generateRequestCommPackages(ProfitabilityAnalysis_Wrapper profAnalysis) {
        List<Object> lstCommPackages = new List<Object>();
        final List<Package_Wrapper> lstCommWrapp = profAnalysis.packages.commPackageList;
        if (lstCommWrapp != null) {
            for (Package_Wrapper commPW : lstCommWrapp) {
                if (profAnalysis.isSpecificContractsScope) {
                    lstCommPackages = checkCommDataWithSpecificContractTrue(commPW, lstCommPackages);
                } else {
                    lstCommPackages = checkCommDataWithSpecificContractFalse(commPW, lstCommPackages);
                }

            }
        }
        return lstCommPackages;
    }

    /**
    * @description Helper method to avoid sonar complexity and to check previous filters to add comm pkg with isSpecificContract set as true
    * @param commPW: Current comm package to evaluate info
    * @param lstCommPackages: List of current comm pkg
    * @return List<Object>, with the current list of comm pkg
    */
    private static List<Object> checkCommDataWithSpecificContractTrue(Package_Wrapper commPW, List<Object> lstCommPackages) {
        final List<String> lstCommScope = new List<String>{'International', 'All'};
        final List<String> lstCommStatus = new List<String>{'Add_Extension', 'Remove_Extension'};
        if (lstCommScope.contains(commPW.scope.id) || (commPW.requestStatus != null && lstCommStatus.contains(commPW.requestStatus.id))) {
            lstCommPackages.add(fillCommDataWithSpecificContractTrue(commPW));
        }
        return lstCommPackages;
    }

    /**
    * @description Helper method to avoid sonar complexity and to fill data of comm pkg with isSpecificContract set as true
    * @param commPW: Current comm package to evaluate info
    * @return Map<String, Object>, with the request values
    */
    private static Map<String, Object> fillCommDataWithSpecificContractTrue(Package_Wrapper commPW) {
        final Map<String, Object> mapCommTrue = new Map<String, Object>();

        if (commPW.requestStatus == null) {
            mapCommTrue.put('request.id', Label.picasso_rqt_pkg_review_id);
            mapCommTrue.put('request.description', Label.picasso_rqt_pkg_review_desc);
        } else {
            switch on commPW.requestStatus.id {
                when 'Add_Extension' {
                    mapCommTrue.put('request.id', Label.picasso_rqt_pkg_add_ext_id);
                    mapCommTrue.put('request.description', Label.picasso_rqt_pkg_add_ext_desc);
                }
                when 'Remove_Extension' {
                    mapCommTrue.put('request.id', Label.picasso_rqt_pkg_remove_ext_id);
                    mapCommTrue.put('request.description', Label.picasso_rqt_pkg_remove_ext_desc);
                }
                when else {
                    mapCommTrue.put('request.id', Label.picasso_rqt_pkg_review_id);
                    mapCommTrue.put('request.description', Label.picasso_rqt_pkg_review_desc);
                }
            }
        }
        mapCommTrue.put('code', commPW.code);
        mapCommTrue.put('name', commPW.description);
        mapCommTrue.put('clientName', commPW.participant.name);
        mapCommTrue.put('clientDocumentNumber', commPW.participant.documentNumber);
        mapCommTrue.put('clientCode', commPW.participant.accountCode);
        mapCommTrue.put('endDate', commPW.endDate);
        mapCommTrue.put('scope.id', commPW.scope == null ? null : commPW.scope.id);
        mapCommTrue.put('scope.value', commPW.scope == null ? null : commPW.scope.value);
        mapCommTrue.put('operationType', commPW.operationType);
        mapCommTrue.put('operationalLimit', commPW.operationalLimit);
        return mapCommTrue;
    }

    /**
    * @description Helper method to avoid sonar complexity and to check previous filters to add comm pkg with isSpecificContract set as true
    * @param commPW: Current comm package to evaluate info
    * @param lstCommPackages: List of current comm pkg
    * @return List<Object>, with the current list of comm pkg
    */
    private static List<Object> checkCommDataWithSpecificContractFalse(Package_Wrapper commPW, List<Object> lstCommPackages) {
        final List<String> lstCommScope = new List<String>{'International', 'All'};
        if (lstCommScope.contains(commPW.scope.id)) {
            lstCommPackages.add(fillCommDataWithSpecificContractFalse(commPW));
        }
        return lstCommPackages;
    }

    /**
    * @description Helper method to avoid sonar complexity and to fill data of comm pkg with isSpecificContract set as false
    * @param commPW: Current comm package to evaluate info
    * @return Map<String, Object>, with the request values
    */
    private static Map<String, Object> fillCommDataWithSpecificContractFalse(Package_Wrapper commPW) {
        final Map<String, Object> mapCommFalse = new Map<String, Object>();
        mapCommFalse.put('request.id', Label.picasso_rqt_pkg_review_id);
        mapCommFalse.put('request.description', Label.picasso_rqt_pkg_review_desc);
        mapCommFalse.put('code', commPW.code);
        mapCommFalse.put('name', commPW.description);
        mapCommFalse.put('clientName', commPW.participant.name);
        mapCommFalse.put('clientDocumentNumber', commPW.participant.documentNumber);
        mapCommFalse.put('clientCode', commPW.participant.accountCode);
        mapCommFalse.put('endDate', commPW.endDate);
        mapCommFalse.put('scope.id', commPW.scope == null ? null : commPW.scope.id);
        mapCommFalse.put('scope.value', commPW.scope == null ? null : commPW.scope.value);
        mapCommFalse.put('operationType', commPW.operationType);
        mapCommFalse.put('operationalLimit', commPW.operationalLimit);
        return mapCommFalse;
    }

    /**
    * @description Helper method to fill request forfaitPackages map to request map
    * @param profAnalysis: Wrapper with prof analysis record info
    * @return List<Object>, with the request forfaitPackages values
    */
    private static List<Object> generateRequestForfaitPackages(ProfitabilityAnalysis_Wrapper profAnalysis) {
        List<Object> lstForfaitPackages = new List<Object>();
        final List<Package_Wrapper> lstForfaitWrapp = profAnalysis.packages.forfaitPackageList;
        if (lstForfaitWrapp != null) {
            for (Package_Wrapper forfaitPW : lstForfaitWrapp) {
                if (forfaitPW.requestStatus == null) {
                    lstForfaitPackages = checkForfaitWithoutReq(profAnalysis, forfaitPW, lstForfaitPackages);
                } else {
                    lstForfaitPackages = checkForfaitWithReq(profAnalysis, forfaitPW, lstForfaitPackages);
                }
            }
        }
        return lstForfaitPackages;
    }

    /**
    * @description Helper method to fill request forfaitPackages map without request
    * @param profAnalysis: Wrapper with prof analysis record info
    * @param forfaitPW: Forfait pw info
    * @param lstForfaitPackages: List of current forfait pkg
    * @return List<Object>, with the request forfaitPackages values
    */
    private static List<Object> checkForfaitWithoutReq(ProfitabilityAnalysis_Wrapper profAnalysis, Package_Wrapper forfaitPW, List<Object> lstForfaitPackages) {
        if (((profAnalysis.typology == 'Renewal' || profAnalysis.typology == 'Novation') && profAnalysis.originEndDate != profAnalysis.endDate) || forfaitPW.scope.id == 'International' || forfaitPW.scope.id == 'All') {
            Map<String, Object> mapForfait = fillForfaitPkg(forfaitPW);
            mapForfait.put('request.id', Label.picasso_rqt_pkg_review_id);
            mapForfait.put('request.description', Label.picasso_rqt_pkg_review_desc);
            lstForfaitPackages.add(mapForfait);
        }
        return lstForfaitPackages;
    }

    /**
    * @description Helper method to fill request forfaitPackages map with request
    * @param profAnalysis: Wrapper with prof analysis record info
    * @param forfaitPW: Forfait pw info
    * @param lstForfaitPackages: List of current forfait pkg
    * @return List<Object>, with the request forfaitPackages values
    */
    private static List<Object> checkForfaitWithReq(ProfitabilityAnalysis_Wrapper profAnalysis, Package_Wrapper forfaitPW, List<Object> lstForfaitPackages) {
        final List<String> requestStatusNoExt = new List<String>{'Cancellation', 'New', 'Modification'};
        final List<String> requestStatusExt = new List<String>{'Add_Extension', 'Remove_Extension'};
        if (requestStatusNoExt.contains(forfaitPW.requestStatus.id)) {
            Map<String, Object> mapForfaitNoExt = fillForfaitPkg(forfaitPW);
            mapForfaitNoExt.putAll(generateRequestForfaitNoExt(forfaitPW.requestStatus));
            lstForfaitPackages.add(mapForfaitNoExt);
        } else if (requestStatusExt.contains(forfaitPW.requestStatus.id)) {
            if (profAnalysis.isSpecificContractsScope || (!profAnalysis.isSpecificContractsScope && (forfaitPW.scope.id == 'International' || forfaitPW.scope.id == 'All'))) {
                Map<String, Object> mapForfaitExt = fillForfaitPkg(forfaitPW);
                mapForfaitExt.putAll(generateRequestForfaitExt(forfaitPW.requestStatus));
                lstForfaitPackages.add(mapForfaitExt);
            }
        }
        return lstForfaitPackages;
    }

    /**
    * @description Helper method to fill forfait data
    * @param forfaitPW: Forfait pw info
    * @return Map<String, Object>, with the request forfaitPackages values
    */
    private static Map<String, Object> fillForfaitPkg(Package_Wrapper forfaitPW) {
        final Map<String, Object> mapForfait = new Map<String, Object>();
        mapForfait.put('code', forfaitPW.code);
        mapForfait.put('name', forfaitPW.description);
        mapForfait.put('clientName', forfaitPW.participant.name);
        mapForfait.put('clientDocumentNumber', forfaitPW.participant.documentNumber);
        mapForfait.put('clientCode', forfaitPW.participant.accountCode);
        mapForfait.put('endDate', forfaitPW.endDate);
        mapForfait.put('scope.id', forfaitPW.scope == null ? null : forfaitPW.scope.id);
        mapForfait.put('scope.value', forfaitPW.scope == null ? null : forfaitPW.scope.value);
        mapForfait.put('operationType', forfaitPW.operationType);
        mapForfait.put('operationalLimit', forfaitPW.operationalLimit);
        mapForfait.put('chargeAccount', forfaitPW.chargeAccount);
        mapForfait.put('chargeAmount', forfaitPW.chargeAmount);
        mapForfait.put('chargePeriodicity.id', forfaitPW.chargePeriodicity == null ? null : forfaitPW.chargePeriodicity.id);
        mapForfait.put('chargePeriodicity.value', forfaitPW.chargePeriodicity == null ? null : forfaitPW.chargePeriodicity.value);
        mapForfait.put('clientRepName', forfaitPW.clientRepName);
        mapForfait.put('clientRepDocNumber', forfaitPW.clientRepDocNumber);
        mapForfait.put('bankRepName', forfaitPW.bankRepName);
        mapForfait.put('bankRepDocNumber', forfaitPW.bankRepDocNumber);
        mapForfait.put('signingLocation', forfaitPW.signingLocation);
        mapForfait.put('comments', forfaitPW.comments);
        if (forfaitPW.extensionRequestId == null) {
            mapForfait.put('extension.request.id', null);
            mapForfait.put('extension.request.description', null);
        } else {
            if (forfaitPW.isExtended) {
                mapForfait.put('extension.request.id', Label.picasso_rqt_pkg_add_ext_id);
                mapForfait.put('extension.request.description', Label.picasso_rqt_pkg_add_ext_desc);
            } else {
                mapForfait.put('extension.request.id', Label.picasso_rqt_pkg_remove_ext_id);
                mapForfait.put('extension.request.description', Label.picasso_rqt_pkg_remove_ext_desc);
            }
        }
        return mapForfait;
    }

    /**
    * @description Helper method to avoid sonar complexity and to fill request forfait map with extension
    * @param requestStatus: Wrapper with request status of package
    * @return Map<String, Object>, with the returned map
    */
    private static Map<String, Object> generateRequestForfaitExt(Package_Wrapper.RequestStatus requestStatus) {
        final Map<String, Object> mapForfaitReqExt = new Map<String, Object>();
        switch on requestStatus.id {
            when 'Add_Extension' {
                mapForfaitReqExt.put('request.id', Label.picasso_rqt_pkg_add_ext_id);
                mapForfaitReqExt.put('request.description', Label.picasso_rqt_pkg_add_ext_desc);
            }
            when 'Remove_Extension' {
                mapForfaitReqExt.put('request.id', Label.picasso_rqt_pkg_remove_ext_id);
                mapForfaitReqExt.put('request.description', Label.picasso_rqt_pkg_remove_ext_desc);
            }
        }
        return mapForfaitReqExt;
    }

    /**
    * @description Helper method to avoid sonar complexity and to fill request forfait map with no extension
    * @param requestStatus: Wrapper with request status of package
    * @return Map<String, Object>, with the returned map
    */
    private static Map<String, Object> generateRequestForfaitNoExt(Package_Wrapper.RequestStatus requestStatus) {
        final Map<String, Object> mapForfaitReqNoExt = new Map<String, Object>();
        switch on requestStatus.id {
            when 'New' {
                mapForfaitReqNoExt.put('request.id', Label.picasso_rqt_pkg_new_id);
                mapForfaitReqNoExt.put('request.description', Label.picasso_rqt_pkg_new_desc);
            }
            when 'Cancellation' {
                mapForfaitReqNoExt.put('request.id', Label.picasso_rqt_pkg_cancellation_id);
                mapForfaitReqNoExt.put('request.description', Label.picasso_rqt_pkg_cancellation_desc);
            }
            when 'Modification' {
                mapForfaitReqNoExt.put('request.id', Label.picasso_rqt_pkg_modification_id);
                mapForfaitReqNoExt.put('request.description', Label.picasso_rqt_pkg_modification_desc);
            }
        }
        return mapForfaitReqNoExt;
    }

    /**
    * @description Helper method to fill request gipPackages map to request map
    * @param profAnalysis: Wrapper with prof analysis record info
    * @return List<Object>, with the request gipPackages values
    */
    private static List<Object> generateRequestGipPacakges(ProfitabilityAnalysis_Wrapper profAnalysis) {
        List<Object> lstGipPackages = new List<Object>();
        final List<Package_Wrapper> lstGipWrapp = profAnalysis.packages.gipPackageList;
        if (lstGipWrapp != null) {
            for (Package_Wrapper gipPW : lstGipWrapp) {
                if (gipPW.requestStatus == null) {
                    lstGipPackages = checkGipDataWithoutRequestStatus(profAnalysis, gipPW, lstGipPackages);
                } else {
                    lstGipPackages = checkGipDataWithRequestStatus(gipPW, lstGipPackages);
                }
            }
        }
        return lstGipPackages;
    }

    /**
    * @description Helper method to avoid sonar complexity and to check previous filters to add gip pkg with requestStatus empty
    * @param profAnalysis: Wrapper with prof analysis record info
    * @param gipPW: Current gip package to evaluate info
    * @param lstGipPackages: List of current gip pkg
    * @return List<Object>, with the current list of gip pkg
    */
    private static List<Object> checkGipDataWithoutRequestStatus(ProfitabilityAnalysis_Wrapper profAnalysis, Package_Wrapper gipPW, List<Object> lstGipPackages) {
        if ((profAnalysis.typology == 'Renewal' || profAnalysis.typology == 'Novation') && profAnalysis.originEndDate != profAnalysis.endDate) {
            final Map<String, Object> mapGipWithputRS = new Map<String, Object>();
            mapGipWithputRS.put('request.id', Label.picasso_rqt_pkg_review_id);
            mapGipWithputRS.put('request.description', Label.picasso_rqt_pkg_review_desc);
            mapGipWithputRS.put('name', gipPW.description);
            mapGipWithputRS.put('clientName', gipPW.participant.name);
            mapGipWithputRS.put('clientDocumentNumber', gipPW.participant.documentNumber);
            mapGipWithputRS.put('clientCode', gipPW.participant.accountCode);
            mapGipWithputRS.put('endDate', gipPW.endDate);
            mapGipWithputRS.put('clientRepName', gipPW.clientRepName);
            mapGipWithputRS.put('clientRepDocNumber', gipPW.clientRepDocNumber);
            mapGipWithputRS.put('bankRepName', gipPW.bankRepName);
            mapGipWithputRS.put('bankRepDocNumber', gipPW.bankRepDocNumber);
            mapGipWithputRS.put('signingLocation', gipPW.signingLocation);
            mapGipWithputRS.put('comments', gipPW.comments);
            lstGipPackages.add(mapGipWithputRS);
        }
        return lstGipPackages;
    }

    /**
    * @description Helper method to avoid sonar complexity and to check previous filters to add gip pkg with requestStatus filled
    * @param gipPW: Current gip package to evaluate info
    * @param lstGipPackages: List of current gip pkg
    * @return List<Object>, with the current list of gip pkg
    */
    private static List<Object> checkGipDataWithRequestStatus(Package_Wrapper gipPW, List<Object> lstGipPackages) {
        final Map<String, Object> mapGipWithRS = new Map<String, Object>();
        switch on gipPW.requestStatus.id {
            when 'New' {
                mapGipWithRS.put('request.id', Label.picasso_rqt_pkg_new_id);
                mapGipWithRS.put('request.description', Label.picasso_rqt_pkg_new_desc);
            }
            when 'Cancellation' {
                mapGipWithRS.put('request.id', Label.picasso_rqt_pkg_cancellation_id);
                mapGipWithRS.put('request.description', Label.picasso_rqt_pkg_cancellation_desc);
            }
            when 'Modification' {
                mapGipWithRS.put('request.id', Label.picasso_rqt_pkg_modification_id);
                mapGipWithRS.put('request.description', Label.picasso_rqt_pkg_modification_desc);
            }
        }
        mapGipWithRS.put('name', gipPW.description);
        mapGipWithRS.put('clientName', gipPW.participant.name);
        mapGipWithRS.put('clientDocumentNumber', gipPW.participant.documentNumber);
        mapGipWithRS.put('clientCode', gipPW.participant.accountCode);
        mapGipWithRS.put('endDate', gipPW.endDate);
        mapGipWithRS.put('clientRepName', gipPW.clientRepName);
        mapGipWithRS.put('clientRepDocNumber', gipPW.clientRepDocNumber);
        mapGipWithRS.put('bankRepName', gipPW.bankRepName);
        mapGipWithRS.put('bankRepDocNumber', gipPW.bankRepDocNumber);
        mapGipWithRS.put('signingLocation', gipPW.signingLocation);
        mapGipWithRS.put('comments', gipPW.comments);
        lstGipPackages.add(mapGipWithRS);
        return lstGipPackages;
    }

    /**
    * @description Helper method to get current ps catalog flat rates attribute records
    * @return Map<String, ps_catalog_flat_rates_attribute__c>, with the records in map
    */
    private static Map<String, ps_catalog_flat_rates_attribute__c> getCurrentPsCatFRAttbRecords() {
        final PsCatalogFlatRatesAttribute_Selector psCatFRAttbSelector = new PsCatalogFlatRatesAttribute_Selector(true);
        final List<ps_catalog_flat_rates_attribute__c> lstPsCatFRAttb = psCatFRAttbSelector.selectAll(100);
        final Map<String, ps_catalog_flat_rates_attribute__c> mapPSCatFRAttb = new Map<String, ps_catalog_flat_rates_attribute__c>();
        for (ps_catalog_flat_rates_attribute__c psCatFRAttb : lstPsCatFRAttb) {
            if (psCatFRAttb.cuco__gf_psc_flat_attribute_id__c != 'comflat.pygcomments') {
                mapPSCatFRAttb.put(psCatFRAttb.cuco__gf_psc_flat_attribute_id__c, psCatFRAttb);
            }
        }
        return mapPSCatFRAttb;
    }

    /**
    * @description Helper method to fill flat general values with empty value
    * @param mapPSCatFRAttb: Map with current flat rates attbs which value is empty
    * @return List<Object>, with the new records to add to flat general list
    */
    private static List<Object> fillEmptyFlatGeneral(Map<String, ps_catalog_flat_rates_attribute__c> mapPSCatFRAttb) {
        // Avoid fill other value in price type values
        mapPSCatFRAttb.remove('comflat.variable.amount');
        mapPSCatFRAttb.remove('comflat.fixed.amount');

        final List<Object> lstFlatGeneral = new List<Object>();
        for (String faCanonicalId : mapPSCatFRAttb.keySet()) {
            final ps_catalog_flat_rates_attribute__c psCatFRAttb = mapPSCatFRAttb.get(faCanonicalId);
            final Map<String, Object> mapFlatAttb = new Map<String, Object>();
            mapFlatAttb.put('description', psCatFRAttb.gf_psc_attribute_id__r.Name);
            mapFlatAttb.put('value', '');
            mapFlatAttb.put('formatType', psCatFRAttb.gf_psc_attribute_id__r.gf_attribute_value_type_name__c);
            mapFlatAttb.put('id', faCanonicalId);
            lstFlatGeneral.add(mapFlatAttb);
        }
        return lstFlatGeneral;
    }

    /**
    * @description Method to serialize values to call webservice
    */
    public String generateRequest() {
        return JSON.serialize(this);
    }

    /**
    * @description Method to invocate webdservice
    */
    public HttpResponse callWs() {
        HttpResponse response;
        final iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance('sendPicassoRequest');
        if (serviceProp.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock('sendPicassoRequest', 200);
        } else {
            response = Utils.callWServices('sendPicassoRequest', generateRequest());
        }
        return response;
    }
}