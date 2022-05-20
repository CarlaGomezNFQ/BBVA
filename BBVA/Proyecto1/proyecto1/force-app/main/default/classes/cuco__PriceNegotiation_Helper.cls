/**
* ____________________________________________________________________________
* Price Negotiation Integration Helper
* Name class: PriceNegotiation_Helper
* ____________________________________________________________________________
* @author      Miguel Cabrera <miguel.cabrera@bbvaitspain.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-30
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class PriceNegotiation_Helper  {

    /**
    * @description String with user userId value
    */
    private String userId {get;set;}
    /**
    * @description String with user profAnalysisId value
    */
    private String profAnalysisId {get;set;}
    /**
    * @description String with classification value
    */
    private String classification {get;set;}
    /**
    * @description String with first level value
    */
    private String firstLevel {get;set;}
    /**
    * @description String with second level value
    */
    private String secondLevel {get;set;}
    /**
    * @description String with branch code value
    */
    private String branchCode {get;set;}
    /**
    * @description String with bankCode value
    */
    private String bankCode {get;set;}
    /**
    * @description String with countryCode value
    */
    private String countryCode {get;set;}
    /**
    * @description String with participantDocType value
    */
    private String participantDocType {get;set;}
    /**
    * @description String with participantDocNumber value
    */
    private String participantDocNumber {get;set;}
    /**
    * @description String with participantName value
    */
    private String participantName {get;set;}
    /**
    * @description String with participantIntegrationId value
    */
    private String participantIntegrationId {get;set;}
    /**
    * @description String with conditionsList value
    */
    private String conditionsList {get;set;}
    /**
    * @description String with negotiationId value
    */
    private String negotiationId {get;set;}


    /**
    * @description Default public constructor to PriceNegotiation_Helper
    * @param profAnalysisId: Id of related profitability analysis record
    */
    public PriceNegotiation_Helper(ProfitabilityAnalysis_Wrapper paWrapper) {

        // Obtain the current active version of general config mtd
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        //Fill basic information
        this.userId = ProfitabilityAnalysis_Service.obtainUserInfo((Id) UserInfo.getUserId());
        this.classification = genConfig.price_classification_name__c;
        this.firstLevel = genConfig.price_first_level_name__c;
        this.secondLevel = genConfig.price_second_level_name__c;
        this.profAnalysisId = paWrapper.id;
        this.countryCode = 'ES';
        this.bankCode = '0182';
        this.branchCode = paWrapper.delegatedBranchCode != null ? paWrapper.delegatedBranchCode : paWrapper.branchCode;

        // Check if is a new or update negotiation
        if (paWrapper.priceApprovalId != null) {
            this.negotiationId = paWrapper.priceApprovalId;
        }

        // Fill participant information
        if (paWrapper.participantsList != null && !paWrapper.participantsList.isEmpty()) {
            ProfitabilityAnalysis_Wrapper.Participants participant = paWrapper.participantsList.get(0);
            this.participantDocType = getDocumentType(participant.documentType);
            this.participantDocNumber = participant.documentNum;
            this.participantName = participant.name;
            this.participantIntegrationId = participant.integrationId;
        }

        // Fill conditions information
        this.conditionsList = JSON.serialize(getConditions(paWrapper));
    }

    /**
    * @description Method to obtain the document type description
    */
    private static String getDocumentType(String docTypeCode) {

        String documentType = '';
        switch on docTypeCode {
            when '1' {
                documentType = 'PERSON_DOCUMENT';
            }
            when '2' {
                documentType = 'COMPANY_DOCUMENT';
            }
            when '3' {
                documentType = 'FOREIGN_COMPANY_DOCUMENT';
            }
            when '5' {
                documentType = 'MINOR_PERSON_DOCUMENT';
            }
            when '6' {
                documentType = 'FOREIGN_PERSON_DOCUMENT';
            }
            when '7' {
                documentType = 'PASSPORT_DOCUMENT';
            }
            when '9' {
                documentType = 'COMPANY_INTERNATIONAL_DOCUMENT';
            }
            when else {
                documentType = 'OTHER';
            }
        }
        return documentType;
    }

    /**
    * @description Method to obtain the document type description
    */
    private static List<Map<String,Object>> getConditions(ProfitabilityAnalysis_Wrapper paWrapper) {

        List<Map<String,Object>> conditionsList = new List<Map<String,Object>>();
        ProfitabilityAnalysis_Wrapper.MainParticipant mainParticipant = paWrapper.mainParticipant;

        //Fill individual conditions
        conditionsList = fillIndConditions(paWrapper);

        //Fill RORC condition
        Map<String,Object> condRORCMap = new Map<String,Object>();
        condRORCMap.put('type','SIMPLE');
        condRORCMap.put('name','rorc.type');
        Map<String,Object> valRORCMap = new Map<String,Object>();
        valRORCMap.put('value', mainParticipant.type == 'group' ? 'G' : 'C');
        condRORCMap.put('value',valRORCMap);
        conditionsList.add(condRORCMap);

        //Fill group condition
        if (mainParticipant.type == 'group') {

            Map<String,Object> condGroupCMap = new Map<String,Object>();
            condGroupCMap.put('type','SIMPLE');
            condGroupCMap.put('name','group.id');
            Map<String,Object> valGroupMap = new Map<String,Object>();
            valGroupMap.put('value', mainParticipant.integrationId);
            condGroupCMap.put('value',valGroupMap);
            conditionsList.add(condGroupCMap);
        }

        if (paWrapper.packages != null) {

            ProfitabilityAnalysis_Wrapper.Packages packages = paWrapper.packages;

            //Fill package requests condition
            Integer numPkgRequests = checkPackageRequest(packages);
            if (numPkgRequests > 0) {

                Map<String,Object> condPkgMap = new Map<String,Object>();
                condPkgMap.put('type','SIMPLE');
                condPkgMap.put('name','commercial.package');
                Map<String,Object> valPkgMap = new Map<String,Object>();
                valPkgMap.put('value', 'S');
                condPkgMap.put('value',valPkgMap);
                conditionsList.add(condPkgMap);
            }

            //Fill package extension condition
            Integer numExtRequests = checkExtRequest(packages);

            if (numExtRequests > 0) {

                Map<String,Object> condExtMap = new Map<String,Object>();
                condExtMap.put('type','SIMPLE');
                condExtMap.put('name','extended.package');
                Map<String,Object> valExtMap = new Map<String,Object>();
                valExtMap.put('value', 'S');
                condExtMap.put('value',valExtMap);
                conditionsList.add(condExtMap);
            }
        }

        //Fill flat configuration request condition
        if (paWrapper.flatRate != null) {
            ProfitabilityAnalysis_Wrapper.FlatRate flatRate = paWrapper.flatRate;
            if (flatRate.requestType != null && (flatRate.requestType == 'New' || flatRate.requestType == 'Modification' )) {
                Map<String,Object> condFlatMap = new Map<String,Object>();
                condFlatMap.put('type','SIMPLE');
                condFlatMap.put('name','commission.flat');
                Map<String,Object> valFlatMap = new Map<String,Object>();
                valFlatMap.put('value', 'S');
                condFlatMap.put('value',valFlatMap);
                conditionsList.add(condFlatMap);
            }
        }
        return conditionsList;
    }

    /**
    * @description Method to obtain the individual conditions that apply to the price negotiation
    */
    private static List<Map<String,Object>> fillIndConditions(ProfitabilityAnalysis_Wrapper paWrapper) {

        List<Map<String,Object>> conditionsList = new  List<Map<String,Object>>();
        //Fill individual conditions
        if (paWrapper.conditionsList != null) {
            List<Map<String,Object>> indvConditionsList = getIndConditions(paWrapper.conditionsList);
            if (!indvConditionsList.isEmpty()) {
                conditionsList.addAll(indvConditionsList);
            }
        }
        return conditionsList;
    }

    /**
    * @description Method to obtain the individual conditions that apply to the price negotiation
    */
    private static List<Map<String,Object>> getIndConditions(List<ProfitabilityAnalysis_Wrapper.Condition> conditionsList) {

        List<Map<String,Object>> indvConditionsList = new List<Map<String,Object>>();
        for (ProfitabilityAnalysis_Wrapper.Condition indvCondition : conditionsList) {
            if (indvCondition.source == null || indvCondition.source == '') {
                List<Map<String,Object>> priceAttList = getPriceAttributes(indvCondition.attributesList);
                if (!priceAttList.isEmpty()) {
                    indvConditionsList.addAll(priceAttList);
                }
            }
        }
        return indvConditionsList;
    }

    /**
    * @description Method to obtain an individual condition attributes that apply to the price negotiation
    */
    private static List<Map<String,Object>>  getPriceAttributes(List<ProfitabilityAnalysis_Wrapper.Attribute> attributesList) {

        List<Map<String,Object>> priceAttList = new List<Map<String,Object>>();
        for (ProfitabilityAnalysis_Wrapper.attribute att : attributesList) {
            if (att.isPriceAtt) {
                Map<String,Object> condAttMap = new Map<String,Object>();
                condAttMap.put('type','SIMPLE');
                condAttMap.put('name',att.canonicalId);
                Map<String,Object> valAttMap = new Map<String,Object>();
                if (att.valueType == 'Checkbox' && att.value == 'true') {
                    valAttMap.put('value', 'S');
                    condAttMap.put('value',valAttMap);
                    priceAttList.add(condAttMap);
                } else if (att.valueType != 'Checkbox' ) {
                    valAttMap.put('value', att.valueId);
                    condAttMap.put('value',valAttMap);
                    priceAttList.add(condAttMap);
                }
            }
        }
        return priceAttList;
    }

    /**
    * @description Method to obtain the number of commercial or forfait packages with an add extension request
    */
    private static Integer checkExtRequest(ProfitabilityAnalysis_Wrapper.Packages packages) {

        Integer numExtRequests = 0;
        // Check if any forfait package has an add extension request
        if (packages.forfaitPackageList != null) {
            for (Package_Wrapper forfaitPkg : packages.forfaitPackageList) {
                if (forfaitPkg.extensionRequestId != null && forfaitPkg.isExtended) {
                    numExtRequests = numExtRequests +1;
                }
            }
        }
        // Check if any commercial package has an add extension request
        if (packages.commPackageList != null) {
            for (Package_Wrapper commPkg : packages.commPackageList) {
                if (commPkg.extensionRequestId != null || commPkg.isExtended) {
                    numExtRequests = numExtRequests +1;
                }
            }
        }
        return numExtRequests;
    }

    /**
    * @description Method to obtain the number of forfait or gip packages with a new or modification request
    */
    private static Integer checkPackageRequest(ProfitabilityAnalysis_Wrapper.Packages packages) {

        Integer numPkgRequests = 0;
        // Check if any forfait package has a new or modification request
        if (packages.forfaitPackageList != null) {
            for (Package_Wrapper forfaitPkg : packages.forfaitPackageList) {
                if (forfaitPkg.newRequestId != null || forfaitPkg.editRequestId != null) {
                    numPkgRequests = numPkgRequests +1;
                }
            }
        }

        // Check if any gip package has a new or modification request
        if (packages.gipPackageList != null) {
            for (Package_Wrapper gipPkg : packages.gipPackageList) {
                if (gipPkg.newRequestId != null || gipPkg.editRequestId != null) {
                    numPkgRequests = numPkgRequests +1;
                }
            }
        }
        return numPkgRequests;
    }

    /**
    * @description Method to serialize values to call webservice
    */
    public String generateRequest() {
        return JSON.serialize(this, true);
    }

    /**
    * @description Method to invocate webdservice
    */
    public HttpResponse callWs(String wsName) {

        HttpResponse response;
        final iaso__GBL_integration_service__mdt serviceProp = iaso__GBL_integration_service__mdt.getInstance(wsName);
        if (serviceProp.iaso__Retrieve_Mock_LTA__c) {
            response = Utils.getResponseMock(wsName, 200);
        } else {
            response = Utils.callWServices(wsName, generateRequest());
        }
        return response;
    }
}