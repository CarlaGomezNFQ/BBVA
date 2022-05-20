/* ────────────────────────────────────────────────────────────────────
* RequestCondNotebook_Helper
* Helper class for profitability sheet creation and modify web service calls
* ────────────────────────────────────────────────────────────────────
* @author      Sara Rodriguez Ferro
* @modifiedBy
* @version     1.0
* @created
* @modified
* @systemLayer Service
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.ExcessivePublicCount')

public class RequestCondNotebook_Helper {
    /**
    ** @Description : Literal for request type cancellation
    */
    private static final String CANCELLATION = 'Cancellation';
    /**
    ** @Description : String for origin comission flat
    */
    private static final String ORIGIN_FLAT = 'COMMISSIONS_FLAT';
    /**
    ** @Description : String to fill conditions object when there are no conditions
    */
    private static final String WS_DEFAULT_LABEL = 'DEFAULT_INTERNAL';
    /**
    ** @Description : profitability sheet to modifies's code
    */
    public String profSheetCode { get; set; }
    /**
    * @Description : context user code
    */
    public String userCode { get; set; }

    /**
    * @Description : branch code
    */
    public String branchCode { get; set; }

    /**
    * @Description : specifies whether the profitability sheet is asociated to a group or a individual client
    */
    public String notebookType { get; set; }

    /**
    * @Description : segment type
    */
    public String segmentType { get; set; }


    /**
    * @Description : end date
    */
    public String endDate { get; set; }

    /**
    * @Description : start date
    */
    public String startDate { get; set; }

    /**
    * @Description : price approval id
    */
    public String priceApprovalInfo { get; set; }

    /**
    * @Description : specifies whether the profitability sheet will only apply to specific contracts
    */
    public String contractsFlag { get; set; }

    /**
    * @Description : owner code
    */
    public String ownerCode { get; set; }

    /**
    * @Description : participant's list
    */
    public String participantsList { get; set; }

    /**
    * @Description : condition's list
    */
    public String conditionsList { get; set; }

    /**
    * @Description : name
    */
    public String name { get; set; }

    /**
    * @description Default public constructor to RequestCondNotebook_Helper
    * @param paWrapper: profitability analysis wrapper
    */
    public RequestCondNotebook_Helper(ProfitabilityAnalysis_Wrapper paWrapper ) {

        // Fill general information
        this.userCode = ProfitabilityAnalysis_Service.obtainUserInfo((Id) UserInfo.getUserId());
        this.branchCode = paWrapper.branchCode;
        this.endDate = String.valueOf(paWrapper.endDate);
        this.contractsFlag = String.valueOf(paWrapper.isSpecificContractsScope);
        this.ownerCode = paWrapper.ownerCode;
        this.name = paWrapper.name;

        //Fill price approval information, if applies
        if(paWrapper.priceApprovalId != null) {
            String sanction = '"sanction": {"id": "##"}';
            this.priceApprovalInfo = sanction.replace('##', paWrapper.priceApprovalId) + ',';
        } else {
            this.priceApprovalInfo = '';
        }

        //Fill participants information

        this.participantsList = JSON.serialize(getParticipants(paWrapper));

        //Fill conditions information
        this.conditionsList = JSON.serialize(getConditions(paWrapper));

        //Fill requet type specific information
        if(paWrapper.typology == 'Renewal' || paWrapper.typology == 'Novation') {
            this.profSheetCode = paWrapper.code;
            this.startDate = String.valueOf(paWrapper.startDate);
        } else if(paWrapper.typology == 'New' && paWrapper.autoFormRequestId != null) {
            this.profSheetCode = paWrapper.autoFormRequestId;
            this.startDate = String.valueOf(paWrapper.startDate);
        } else{
            this.notebookType = getNotebookType(paWrapper);
            this.segmentType = paWrapper.segment;
        }
    }

    /**
    * @description Method to obtain the notebook's type
    */
    public static String getNotebookType(ProfitabilityAnalysis_Wrapper paWrapper) {

        String notebookType;

        ProfitabilityAnalysis_Wrapper.MainParticipant mainParticipant = paWrapper.mainParticipant;

        if(mainParticipant.type == 'group') {
            notebookType = 'GROUPAL';
        } else {
            notebookType = 'INDIVIDUAL';
        }

        return notebookType;
    }

    /**
    * @description Method to obtain the list of participants
    */
    public static List<Map<String,Object>> getParticipants(ProfitabilityAnalysis_Wrapper paWrapper) {

        List<Map<String,Object>> participantsList = new List<Map<String,Object>>();

        List<ProfitabilityAnalysis_Wrapper.Participants> inputPartList = new List<ProfitabilityAnalysis_Wrapper.Participants>();

        if(paWrapper.participantsList != null) {

            inputPartList = paWrapper.participantsList;

            for(ProfitabilityAnalysis_Wrapper.Participants part : inputPartList) {
                Map<String,Object> participantMap = new Map<String,Object>();
                String partIntegrationId = part.integrationId;
                String partId = partIntegrationId.Substring(0,partIntegrationId.length()-1);
                participantMap.put('id',partId);
                participantsList.add(participantMap);
            }
        }

        return participantsList;

    }

    /**
    * @description Method to obtain the list of conditions
    */
    public static List<Map<String,Object>> getConditions(ProfitabilityAnalysis_Wrapper paWrapper) {

        List<Map<String,Object>> conditionsList = new List<Map<String,Object>>();

        final boolean hasFlatNoCancel = paWrapper.flatRate != null && paWrapper.flatRate.requestType != CANCELLATION;

        //Check if there are conditions
        if(paWrapper.conditionsList != null) {

            // Fill individual conditions, packages extension conditions and conditions included in flat configuration
            List<ProfitabilityAnalysis_Wrapper.Condition> inputCondList = new List<ProfitabilityAnalysis_Wrapper.Condition>();
            inputCondList = paWrapper.conditionsList;
            conditionsList.addAll(getIndCond(inputCondList,hasFlatNoCancel));

        }

        // Check if there is an extended package
        if(paWrapper.packages != null) {
            ProfitabilityAnalysis_Wrapper.Packages packages = paWrapper.packages;
            if(packages.extendedPackages != null && packages.extendedPackages.size()>0) {
                // Extended package condition
                conditionsList.add(getExtPkgCon(packages.extendedPackages.get(0)));
            }
        }

        // Check if there is flat configuration that is not being cancelled
        if(hasFlatNoCancel) {

            // Fill flat configuration
            ProfitabilityAnalysis_Wrapper.FlatRate flatRate = paWrapper.flatRate;
            conditionsList.addAll(getFlatRateCond(flatRate));
        }

        if(conditionsList.isEmpty()) {
            // Default condition
            conditionsList.add(getExtPkgCon(WS_DEFAULT_LABEL));
        }

        return conditionsList;
    }


    /**
    * @description Method to obtain the details of the flat rate configuration
    */
    public static List<Map<String,Object>> getFlatRateCond(ProfitabilityAnalysis_Wrapper.FlatRate flatRate) {

        List<Map<String,Object>> flatRateCondList = new List<Map<String,Object>>();

        // Fill flat configuration general details
        List<ProfitabilityAnalysis_Wrapper.Attribute> flatAttList = new List<ProfitabilityAnalysis_Wrapper.Attribute>();
        flatAttList = flatRate.flatRatesInfoAttList;
        flatRateCondList.addAll(getFlatCond(flatAttList));

        //Fill flat configuration accounts details
        if(flatRate.flatRateAccountsList != null && flatRate.flatRateAccountsList.size() > 0) {
            List<ProfitabilityAnalysis_Wrapper.FlatRteAccount> flatRateAccountsList = new List<ProfitabilityAnalysis_Wrapper.FlatRteAccount>();
            flatRateAccountsList = flatRate.flatRateAccountsList;
            flatRateCondList.addAll(getFlatAccCond(flatRateAccountsList));
        }

        //Fill flat configuration dynamic pricing details
        if(flatRate.dpItemList != null && flatRate.dpItemList.size() > 0) {
            List<ProfitabilityAnalysis_Wrapper.DpItem> flatRateDPList = new List<ProfitabilityAnalysis_Wrapper.DpItem>();
            flatRateDPList = flatRate.dpItemList;
            flatRateCondList.addAll(getFlatDPCond(flatRateDPList));
        }


        return flatRateCondList;
    }

    /**
    * @description Method to obtain the details of the flat rate dynamic pricing information
    */
    public static List<Map<String,Object>> getFlatDPCond(List<ProfitabilityAnalysis_Wrapper.DpItem> flatRateDPList) {

        List<Map<String,Object>> flatDPCondList = new List<Map<String,Object>>();

        for(ProfitabilityAnalysis_Wrapper.DpItem dp : flatRateDPList) {
            List<ProfitabilityAnalysis_Wrapper.Attribute> flatDPAttList = dp.dpAttList;
            flatDPCondList.addAll(getFlatDPAttCond(flatDPAttList));
        }

        return flatDPCondList;
    }

    /**
    * @description Method to obtain the details of the dynamic pricing attributes information
    */
    public static List<Map<String,Object>> getFlatDPAttCond(List<ProfitabilityAnalysis_Wrapper.Attribute> flatDPAttList) {

        List<Map<String,Object>> flatDPCondList = new List<Map<String,Object>>();

        for(ProfitabilityAnalysis_Wrapper.Attribute att : flatDPAttList) {

            if(att.formType != null &&  att.formType != '' && att.formType == 'Automatic'){
                Map<String,Object> flatDPAttMap = new Map<String,Object>();
                flatDPAttMap.put('id',att.canonicalId);
                flatDPAttMap.put('conditionType','SIMPLE');
                flatDPAttMap.put('isAutomaticManagement',false);

                // Set origin
                Map<String,Object> flatOringMap = new Map<String,Object>();
                flatOringMap.put('id','DYNAMIC_PRICING');
                flatDPAttMap.put('origin',flatOringMap);

                // Set value
                flatDPAttMap.put('formats',getAttValue(att));

                flatDPCondList.add(flatDPAttMap);
            }
        }

        return flatDPCondList;
    }

    /**
    * @description Method to obtain the details of the flat rate accounts information
    */
    public static List<Map<String,Object>> getFlatAccCond(List<ProfitabilityAnalysis_Wrapper.FlatRteAccount> flatRateAccountsList) {

        List<Map<String,Object>> flatAccCondList = new List<Map<String,Object>>();

        for(ProfitabilityAnalysis_Wrapper.FlatRteAccount flatAcc : flatRateAccountsList){

            ProfitabilityAnalysis_Wrapper.Attribute att = flatAcc.accountAttribute;

            Map<String,Object> flatAccAttMap = new Map<String,Object>();
            flatAccAttMap.put('id',att.canonicalId);
            flatAccAttMap.put('conditionType','SIMPLE');
            flatAccAttMap.put('isAutomaticManagement',false);

            // Set origin
            Map<String,Object> flatAccOringMap = new Map<String,Object>();
            flatAccOringMap.put('id','PROFIT_LOSS_ACCOUNT');
            flatAccAttMap.put('origin',flatAccOringMap);

            // Set value
            flatAccAttMap.put('formats',getAttValue(att));

            flatAccCondList.add(flatAccAttMap);
        }

        return flatAccCondList;
    }

    /**
    * @description Method to obtain the details of the flat rate general information
    */
    public static List<Map<String,Object>> getFlatCond(List<ProfitabilityAnalysis_Wrapper.Attribute> flatAttList) {

        List<Map<String,Object>> flatCondList = new List<Map<String,Object>>();

        for(ProfitabilityAnalysis_Wrapper.Attribute att : flatAttList) {

            if(att.formType != null &&  att.formType != '' && att.formType == 'Automatic'){
                Map<String,Object> flatAttMap = new Map<String,Object>();
                flatAttMap.put('id',att.canonicalId);
                flatAttMap.put('conditionType','SIMPLE');
                flatAttMap.put('isAutomaticManagement',false);

                // Set origin
                Map<String,Object> flatOringMap = new Map<String,Object>();
                flatOringMap.put('id','FLAT_INFORMATION');
                flatAttMap.put('origin',flatOringMap);

                // Set value
                flatAttMap.put('formats',getAttValue(att));

                flatCondList.add(flatAttMap);
            }
        }

        return flatCondList;
    }


    /**
    * @description Method to obtain the details of the extended package condition
    */
    public static Map<String,Object> getExtPkgCon(String extendedPkgValue) {

        Map<String,Object> extCondMap = new Map<String,Object>();
        extCondMap.put('id','extended.package');
        extCondMap.put('conditionType','SIMPLE');
        extCondMap.put('isAutomaticManagement',false);

        Map<String,Object> formatDetailMap = new Map<String,Object>();
        formatDetailMap.put('formatType','TEXT');
        formatDetailMap.put('text',extendedPkgValue);
        Map<String,Object> formatMap = new Map<String,Object>();
        List<Map<String,Object>> formatMapList = new List<Map<String,Object>>();
        formatMap.put('format',formatDetailMap);
        formatMapList.add(formatMap);
        extCondMap.put('formats',formatMapList);

        return extCondMap;
    }

    /**
    * @description Method to obtain the details of the input conditions list
    */
    public static List<Map<String,Object>> getIndCond(List<ProfitabilityAnalysis_Wrapper.Condition> conditionsList, Boolean hasFlatNoCancel) {

        List<Map<String,Object>> condDetailsList = new List<Map<String,Object>>();

        for(ProfitabilityAnalysis_Wrapper.Condition cond : conditionsList) {
            if (cond.source == ORIGIN_FLAT && !hasFlatNoCancel) {
                continue;
            }

            List<ProfitabilityAnalysis_Wrapper.Attribute> attributesList = new List<ProfitabilityAnalysis_Wrapper.Attribute>();
            attributesList = cond.attributesList;

            for(ProfitabilityAnalysis_Wrapper.Attribute att : attributesList) {

                if(att.formType != null &&  att.formType != ''){
                    condDetailsList.add(getCondAttribute(att, cond.source));
                }

            }
        }

        return condDetailsList;
    }

    /**
    * @description Method to obtain the details of the input attribute
    */
    public static Map<String,Object> getCondAttribute(ProfitabilityAnalysis_Wrapper.Attribute att, String source) {

        Map<String,Object> condAttMap = new Map<String,Object>();
        condAttMap.put('id',att.canonicalId);
        condAttMap.put('conditionType','SIMPLE');

        if(att.formType == 'Automatic'){
            condAttMap.put('isAutomaticManagement',true);
        } else {
            condAttMap.put('isAutomaticManagement',false);
        }

        if(source != null && source != ''){
            Map<String,Object> oringMap = new Map<String,Object>();
            oringMap.put('id',source);
            condAttMap.put('origin',oringMap);
        }

        condAttMap.put('formats',getAttValue(att));

        return condAttMap;
    }

    /**
    * @description Method to obtain a condition attribute's value structure
    */
    public static List<Map<String,Object>> getAttValue(ProfitabilityAnalysis_Wrapper.Attribute att) {

        Map<String,Object> formatMap = new Map<String,Object>();
        List<Map<String,Object>> formatMapList = new List<Map<String,Object>>();
        Map<String,Object> formatDetailMap = new Map<String,Object>();

        // Check the value format type
        String formatType = att.formatType;
        formatDetailMap.put('formatType',formatType);

        switch on formatType {

            when 'RATE' {
                formatDetailMap.put('rateUnit',att.formatUnitType);
                formatDetailMap.put('value',decimal.valueof(att.valueId));
            }
            when 'AMOUNT' {

                Map<String,Object>  amountMap = new Map<String,Object> ();
                amountMap.put('amount',decimal.valueof(att.valueId));
                amountMap.put('currency','EUR');

                formatDetailMap.put('amount',amountMap);

            }
            when 'TERM' {

                formatDetailMap.put('termUnit',att.formatUnitType);
                formatDetailMap.put('termValue',decimal.valueof(att.valueId));

            }
            when 'DATE' {
                formatDetailMap.put('date',att.valueId);
            }
            when else {
                formatDetailMap.put('text',checkTextAttribute(att));
            }
        }

        formatMap.put('format',formatDetailMap);
        formatMapList.add(formatMap);

        return formatMapList;
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
            response = Utils.getResponseMock(wsName, null);
        } else {
            response = Utils.callWServices(wsName, generateRequest());
        }
        return response;
    }
    /**
    * @description Method to return text attribute values
    */
    private static String checkTextAttribute(ProfitabilityAnalysis_Wrapper.Attribute att) {
        String returnAtt;
        if(att.valueType == 'Checkbox' && att.value == 'true') {
            returnAtt = 'S';
        }
        else {
            returnAtt = att.valueId;
        }
        return returnAtt;
    }
}