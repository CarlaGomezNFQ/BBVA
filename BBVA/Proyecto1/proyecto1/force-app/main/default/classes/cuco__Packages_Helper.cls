/**
* ────────────────────────────────────────────────────────────────────
* Packages_Helper
* Helper class for Packages_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-11
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.CyclomaticComplexity,sf:NcssMethodCount')
public class Packages_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private Packages_Helper() {}

    /**
    * @description Helper method to obtain related packages to a Profitability Sheet / Profitability Analysis
    * @param contextRecordId : Id of the related Profitability Sheet / Profitability Analysis
    * @param packageTypes : Set of packages types to obtain. Current values are COMMERCIAL_PACKAGE, GIP_PACKAGE and FORFAIT
    * @param extendedPkgs : Map with account identifier as key, and Set of current extended packages codes related with the key account
    * @return Map<String, List<Package_Wrapper>>, with each package type from param as key, and list with each package info as value
    */
    public static Map<String, List<Package_Wrapper>> getPackages(Id contextRecordId, Set<String> packageTypes, Map<String, Set<String>> extendedPkgs) {
        Map<String, List<Package_Wrapper>> retMap = new Map<String, List<Package_Wrapper>>();
        final List<client_package__c> lstCP = new List<client_package__c>();
        final List<profitability_analysis_pkg_request__c> lstPAPR = new List<profitability_analysis_pkg_request__c>();
        final ClientPackage_Selector cpSelector = new ClientPackage_Selector(new List<String>{'cuco__PackageHelper'});
        final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector(new List<String>{'cuco__PackageHelper'});

        // Step 0. Utils to do logic
        final String sObjectName = Utils.getObjectAPIName(contextRecordId); // Get sObjectName from recordId
        final List<String> lstEqPkgType = getEquivalencePkgType(packageTypes); // Get equivalence api name from pkg param
        final Map<Id, Id> mapAccIdWithParticipantId = getCurrentProfParticipants(contextRecordId, sObjectName); // Each account id associated to prof participant

        // Step 1. Client package records with status 'Valid' related with each Participant related with context Record Id
        final List<client_package__c> lstCPStep1 = cpSelector.selectPkgByStatusAndAccIdAndPkgType(new List<String>{'Valid'}, mapAccIdWithParticipantId.keySet(), lstEqPkgType);
        lstCP.addAll(lstCPStep1);

        // Step aux to avoid included on step 1 accs from client packages related to pkg req without participant
        // Step 1.5. Need to add prof analysis pkg req with empty prof analysis participant related to one valid client package (And add his accs ids to mapAccDetails)
        if (sObjectName == 'cuco__profitability_analysis__c') {
            final Set<Id> setIdClientPkg = new Set<Id>();
            final List<profitability_analysis_pkg_request__c> lstPAPRWithoutParticipant = pkgReqSelector.selectPkgReqByAnWithoutParticipant(new Set<Id>{contextRecordId});
            for(profitability_analysis_pkg_request__c paprAcc : lstPAPRWithoutParticipant) {
                setIdClientPkg.add(paprAcc.cuco__gf_cust_package_id__c);
            }

            // Add too Extension remove request from cancelled pkg
            final List<profitability_analysis_pkg_request__c> lstPAPRFromRemoveExt = pkgReqSelector.selectPkgReqByReqExt(new Set<Id>{contextRecordId}, lstEqPkgType, new List<String>{'Extension'}, new List<String>{'Remove'}, new List<String>{'Cancelled'});

            for(profitability_analysis_pkg_request__c paprExt : lstPAPRFromRemoveExt) {
                setIdClientPkg.add(paprExt.cuco__gf_cust_package_id__c);
            }

            // Second, get client packages related to this prof analysis pkg req to know participant id (Acc id)
            final List<client_package__c> lstCP0 = cpSelector.selectById(setIdClientPkg);
            for (client_package__c cp0 : lstCP0) {
                mapAccIdWithParticipantId.put(cp0.participant_id__c, null);
                lstCP.add(cp0);
            }

        }

        final Map<Id, Participant_Wrapper> mapAccDetails = getWrapperWithAccountDetails(mapAccIdWithParticipantId.keySet()); // Get all details of accs in map

        // Step 2. For each extended package from the param method, client package records with status 'Valid', or if dont exist, with status 'Cancelled'
        // with earlier Effective Date
        final Map<String, String> mapAccIdentifierWithId = new Map<String, String>();
        for (Id accId : mapAccDetails.keySet()) {
            String accIdentifier = mapAccDetails.get(accId).participantCode;
            mapAccIdentifierWithId.put(accIdentifier, accId);
        }
        final List<client_package__c> lstCPStep2 = obtainCPOfExtendedPkg(extendedPkgs, mapAccIdentifierWithId, lstCP);
        lstCP.addAll(lstCPStep2);

        Map<Id, List<profitability_analysis_pkg_request__c>> mapCP2PAPR = new Map<Id, List<profitability_analysis_pkg_request__c>>(); // To step 4, fill in step 3

        // Step 3. (Only for Profitability Analysis) Profitability Analysis Pkg Request records without client package related or with extension req type and remove extension request type
        if (sObjectName == 'cuco__profitability_analysis__c') {
            final List<profitability_analysis_pkg_request__c> lstPAPRWithoutCP = pkgReqSelector.selectPkgReqWithoutCP(new Set<Id>{contextRecordId}, lstEqPkgType);
            lstPAPR.addAll(lstPAPRWithoutCP);

            mapCP2PAPR = getRelatedPkgRequestFromClientPkg(lstCP, contextRecordId);
        }

        // Step 4. Extract related profitability analysis pkg request to each client package, if exist. (To fill participant and other stuff)
        final List<ClientPkgWrapper> lstClientPkgWrapp = new List<ClientPkgWrapper>();
        for (client_package__c cp : lstCP) {
            if (mapCP2PAPR.containsKey(cp.Id)) {
                final ClientPkgWrapper cpw = new ClientPkgWrapper(cp, mapCP2PAPR.get(cp.Id));
                lstClientPkgWrapp.add(cpw);
            } else {
                final ClientPkgWrapper cpw = new ClientPkgWrapper(cp, null);
                lstClientPkgWrapp.add(cpw);
            }
        }

        // Step 6. Fill the return map in function of profitability_analysis_pkg_request__c and client_package__c objects
        final Map<String, Object> mapParam2Wrapper = new Map<String, Object>();
        mapParam2Wrapper.put('mapAccDetails', mapAccDetails);
        mapParam2Wrapper.put('lstPAPR', lstPAPR);
        mapParam2Wrapper.put('lstCPW', lstClientPkgWrapp);
        mapParam2Wrapper.put('extendedPkgs', extendedPkgs);
        mapParam2Wrapper.put('mapAccIdWithParticipantId', mapAccIdWithParticipantId);
        retMap = fillWithCurrentStepValues(mapParam2Wrapper);
        return retMap;
    }

    /**
    * @description Helper method to obtain equivalence of param package to ps catalog package
    * @param packageTypes : List of the package types to filter
    * @return List<String>, with the equivalence of the package types to ps catalog package obj
    */
    private static List<String> getEquivalencePkgType(Set<String> packageTypes) {
        final List<String> cpType = new List<String>();
        for (String pkgType : packageTypes) {
            switch on pkgType {
                when 'COMMERCIAL_PACKAGE' {
                    cpType.add('C');
                }
                when 'GIP_PACKAGE' {
                    cpType.add('G');
                }
                when 'FORFAIT' {
                    cpType.add('F');
                }
            }
        }
        return cpType;
    }

    /**
    * @description Helper method to obtain related packages to a Profitability Sheet / Profitability Analysis
    * @param recordId : Id of the related Profitability Sheet / Profitability Analysis
    * @param sObjectName : sObjectName of the related recordId
    * @return Map<Id, Id>, with account id as key, and profitability participant id as value
    */
    private static Map<Id, Id> getCurrentProfParticipants(Id recordId, String sObjectName) {
        final Map<Id, Id> participantMap = new Map<Id, Id>();
        if (sObjectName == 'cuco__profitability_sheet__c') {
            final ProfitabilitySheetParticipant_Selector pspSelector = new ProfitabilitySheetParticipant_Selector(true);
            final List<profitability_sheet_participant__c> lstPSP = pspSelector.selectByProfSheet(new Set<Id>{recordId});
            for (profitability_sheet_participant__c psp : lstPSP) {
                participantMap.put(psp.participant_id__c, psp.Id);
            }
        } else if (sObjectName == 'cuco__profitability_analysis__c') {
            final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
            final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{recordId});
            for (profitability_analysis_participant__c pap : lstPAP) {
                participantMap.put(pap.participant_id__c, pap.Id);
            }
        }
        return participantMap;
    }

    /**
    * @description Helper method to obtain for each extended package from the param method, client package records with status 'Valid',
    *              or if dont exist, with status 'Cancelled' with earlier Effective Date
    * @param extendedPkgs : Map with account identifier as key, and Set of current extended packages codes related with the key account
    * @param mapAccDetails : Map with details of each profitability participant of current sheet/analysis
    * @param lstCP : List of current client_package__c from first step to know if there is a current valid added
    * @return List<client_package__c>, with the list of client_packages records filter with method logic
    */
    private static List<client_package__c> obtainCPOfExtendedPkg(Map<String, Set<String>> extendedPkgs, Map<String, String> mapAccIdentifierWithId, List<client_package__c> lstCPOld) {
        final Set<String> setPkgCodes2Check = new Set<String>();
        final Set<Id> setAccIdToCheck = new Set<Id>();
        List<client_package__c> lstCP = new List<client_package__c>();

        // Check if already exist a client package with valid status for this account and package in the records of first step soql query
        for (String accIdentifier : extendedPkgs.keySet()) {
            final String accId = mapAccIdentifierWithId.get(accIdentifier);
            final Set<String> extPkgSet = extendedPkgs.get(accIdentifier);
            for (String extPkg : extPkgSet) {
                Boolean hasFoundCP = false;
                for (client_package__c cp : lstCPOld) {
                    if (cp.cuco__participant_id__c == accId && cp.cuco__gf_psc_package_code_id__r.cuco__gf_psc_package_id__c == extPkg) {
                        hasFoundCP = true;
                    }
                }
                if (!hasFoundCP) {
                    setPkgCodes2Check.add(extPkg);
                    setAccIdToCheck.add(accId);
                }
            }
        }

        // If any ext pkg for an accont dont have a related client_package in Valid status, check if exist with Cancelled status
        if (!setAccIdToCheck.isEmpty()) {
            lstCP = getCancelPkgFromExtPkg(setPkgCodes2Check, setAccIdToCheck);
        }
        return lstCP;
    }

    /**
    * @description Helper method to obtain Cancelled client_package related to extended code pkgs as param
    * @param setPkgCodes2Check : Set ok pkgs codes to check if exist any client package to related acc
    * @param setAccIdToCheck : Set ok acocunt id relateds to pkg codes to check if exist any client package
    * @return List<client_package__c>, with the list of client_packages records to add to wrapper
    */
    private static List<client_package__c> getCancelPkgFromExtPkg(Set<String> setPkgCodes2Check, Set<Id> setAccIdToCheck) {
        final List<client_package__c> lstCP = new List<client_package__c>();
        final ClientPackage_Selector cpSelector = new ClientPackage_Selector(new List<String>{'cuco__PackageHelper'});
        final List<client_package__c> lstCancelledCP = cpSelector.selectPkgByStatusAndPkgIdAndPkgType(new List<String>{'Cancelled'}, setPkgCodes2Check, setAccIdToCheck);
        if (!lstCancelledCP.isEmpty()) {
            lstCP.addAll(lstCancelledCP);
        }
        return lstCP;
    }

    /**
    * @description Helper method to obtain related prof analysis pkg req of each client_package
    * @param lstCP : List of client_package__c to get related prof analysis pkg req
    * @return Map<Id, profitability_analysis_pkg_request__c>, with client_package related to each prof analysis pkg req
    */
    private static Map<Id, List<profitability_analysis_pkg_request__c>> getRelatedPkgRequestFromClientPkg(List<client_package__c> lstCP, Id profAnalysisId) {
        final Map<Id, List<profitability_analysis_pkg_request__c>> retMap = new Map<Id, List<profitability_analysis_pkg_request__c>>();
        final Set<Id> setCP = new Set<Id>();
        for (client_package__c cp : lstCP) {
            setCP.add(cp.Id);
        }
        final PAPackageRequest_Selector pkgReqSelector = new PAPackageRequest_Selector(new List<String>{'cuco__PackageHelper'});
        final List<profitability_analysis_pkg_request__c> lstPAPR = pkgReqSelector.selectPkgReqByClientPackageId(setCP, new Set<Id>{profAnalysisId});
        for (profitability_analysis_pkg_request__c papr : lstPAPR) {
            if (retMap.get(papr.gf_cust_package_id__c) == null) {
                retMap.put(papr.gf_cust_package_id__c, new List<profitability_analysis_pkg_request__c>{papr});
            } else {
                final List<profitability_analysis_pkg_request__c> lstPAPRAux = retMap.get(papr.gf_cust_package_id__c);
                lstPAPRAux.add(papr);
                retMap.put(papr.gf_cust_package_id__c, lstPAPRAux);
            }
        }
        return retMap;
    }

    /**
    * @description Helper method to obtain account details to fill wrapper attributes of main method
    * @param setAccsId : Set of account id to filter search
    * @return Map<Id, Participant_Wrapper>, with account id as key and participant wrapper as value
    */
    private static Map<Id, Participant_Wrapper> getWrapperWithAccountDetails(Set<Id> setAccsId) {
        final Map<Id, Participant_Wrapper> mapAcc = new Map<Id, Participant_Wrapper>();
        if (!setAccsId.isEmpty()) {
            // Obtain the current active version of general config mtd
            final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

            // Get participants details
            final List<Participant_Wrapper> lstWrp = Participants_Helper.getParticipantDetails(genConfig, setAccsId);

            for (Participant_Wrapper pw : lstWrp) {
                mapAcc.put(pw.participantId, pw);
            }
        }

        return mapAcc;
    }

    /**
    * @description Helper method to fill the original ret map with current values of the current step flow
    * @param recordId : Id of the related Profitability Sheet / Profitability Analysis to fill wrapper attributes
    * @param mapAccDetails : Map with account id as key, and detail acc wrapper as value
    * @param lstPAPR : List of profitability_analysis_pkg_request__c values to fill wrapper attributes
    * @param lstCPW : List of client_package__c wrapper with pkg request if exist
    * @param extendedPkgs : Map with account identifier as key, with set of extended packages codes
    * @param mapAccIdWithParticipantId : Map with account id as key, and profitability participant id as value (participant in wrapper)
    * @return Map<String, List<Package_Wrapper>>, with the currentValueMap param filled with new Participant Wrapper values
    */
    private static Map<String, List<Package_Wrapper>> fillWithCurrentStepValues(Map<String, Object> mapParams2FillWrapper) {

        Map<String, List<Package_Wrapper>> retMap = new Map<String, List<Package_Wrapper>>();
        final List<Package_Wrapper> lstCommercial = new List<Package_Wrapper>();
        final List<Package_Wrapper> lstGIP = new List<Package_Wrapper>();
        final List<Package_Wrapper> lstForfait = new List<Package_Wrapper>();

        // Need to pass param as Map<String, Object> to avoid pmd long parameter list
        final Map<Id, Participant_Wrapper> mapAccDetails = (Map<Id, Participant_Wrapper>) mapParams2FillWrapper.get('mapAccDetails');
        final List<profitability_analysis_pkg_request__c> lstPAPR = (List<profitability_analysis_pkg_request__c>) mapParams2FillWrapper.get('lstPAPR');
        final List<ClientPkgWrapper> lstCPW = (List<ClientPkgWrapper>) mapParams2FillWrapper.get('lstCPW');
        final Map<String, Set<String>> extendedPkgs = (Map<String, Set<String>>) mapParams2FillWrapper.get('extendedPkgs');
        final Map<Id, Id> mapAccIdWithParticipantId = (Map<Id, Id>) mapParams2FillWrapper.get('mapAccIdWithParticipantId');

        // Build Package_Wrapper for each Profitability Analysis Pkg Req
        for (profitability_analysis_pkg_request__c papr : lstPAPR) {
            Package_Wrapper pkgWrapper      =       new Package_Wrapper();
            pkgWrapper.type                 =       papr.gf_psc_package_id__r.gf_psc_package_type_name__c;
            pkgWrapper.catalogId            =       papr.gf_psc_package_id__r.Id;
            pkgWrapper.code                 =       papr.gf_psc_package_id__r.gf_psc_package_code_id__c;
            pkgWrapper.scope                =       new Package_Wrapper.Scope(papr.gf_psc_package_id__r.gf_psc_pkg_geo_scope_type_name__c, Utils.getPicklistLabel('cuco__ps_catalog_package__c', 'cuco__gf_psc_pkg_geo_scope_type_name__c', papr.gf_psc_package_id__r.gf_psc_pkg_geo_scope_type_name__c));
            pkgWrapper.operationType        =       papr.gf_psc_package_id__r.gf_psc_package_ope_type_desc__c;
            pkgWrapper.operationalLimit     =       papr.gf_psc_package_id__r.gf_psc_package_opern_lm_desc__c;
            pkgWrapper.isExtended           =       checkIfPkgIsExtended(papr.gf_psc_package_id__r.gf_psc_package_id__c, mapAccDetails.get(papr.participant_id__r.participant_id__c), extendedPkgs);
            pkgWrapper.participant          =       fillParticipantInfo(papr.participant_id__c, mapAccDetails.get(papr.participant_id__r.participant_id__c));
            pkgWrapper.isVisible            =       true;
            pkgWrapper                      =       fillSomeValuesFromPkgReqType(pkgWrapper, new List<profitability_analysis_pkg_request__c>{papr}, null); // Fill values in function of papr req type

            // Set on the package type lst and related attbs depends on pkg type
            switch on papr.gf_psc_package_id__r.cuco__gf_psc_package_type_name__c {
                when 'C' {
                    pkgWrapper.description = papr.gf_psc_package_id__r.cuco__gf_psc_package_name__c;
                    lstCommercial.add(pkgWrapper);
                }
                when 'G' {
                    pkgWrapper.description = papr.cuco__gf_pa_package_desc__c;
                    lstGIP.add(pkgWrapper);
                }
                when 'F' {
                    pkgWrapper.description = papr.gf_psc_package_id__r.cuco__gf_psc_package_name__c;
                    lstForfait.add(pkgWrapper);
                }
            }
        }

        // Build Package_Wrapper for each Client Package
        for (ClientPkgWrapper cpw : lstCPW) {
            client_package__c clientPkg             =       cpw.clientPackage;
            Package_Wrapper pkgWrapper              =       new Package_Wrapper();
            pkgWrapper.type                         =       clientPkg.gf_psc_package_code_id__r.gf_psc_package_type_name__c;
            pkgWrapper.clientPackageId              =       clientPkg.Id;
            pkgWrapper.catalogId                    =       clientPkg.gf_psc_package_code_id__r.Id;
            pkgWrapper.code                         =       clientPkg.gf_psc_package_code_id__r.gf_psc_package_code_id__c;
            pkgWrapper.scope                        =       new Package_Wrapper.Scope(clientPkg.gf_psc_package_code_id__r.gf_psc_pkg_geo_scope_type_name__c, Utils.getPicklistLabel('cuco__ps_catalog_package__c', 'cuco__gf_psc_pkg_geo_scope_type_name__c', clientPkg.gf_psc_package_code_id__r.gf_psc_pkg_geo_scope_type_name__c));
            pkgWrapper.operationType                =       clientPkg.gf_psc_package_code_id__r.gf_psc_package_ope_type_desc__c;
            pkgWrapper.operationalLimit             =       clientPkg.gf_psc_package_code_id__r.gf_psc_package_opern_lm_desc__c;
            pkgWrapper.startDate                    =       clientPkg.gf_cust_pkg_ct_effective_date__c;
            pkgWrapper.endDate                      =       clientPkg.gf_cust_pkg_ct_expiry_date__c;
            pkgWrapper.status                       =       new Package_Wrapper.Status(clientPkg.cuco__gf_cst_pkg_ct_status_type__c, clientPkg.cuco__gf_cst_pkg_ct_status_type__c == 'Valid' ? Label.pkg_status_valid : Label.pkg_status_cancelled);
            pkgWrapper.isExtended                   =       checkIfPkgIsExtended(clientPkg.gf_psc_package_code_id__r.gf_psc_package_id__c, mapAccDetails.get(clientPkg.participant_id__c), extendedPkgs);
            pkgWrapper.participant                  =       fillParticipantInfo(mapAccIdWithParticipantId.get(clientPkg.participant_id__c), mapAccDetails.get(clientPkg.participant_id__c));
            pkgWrapper.isVisible                    =       true;

            // If client package have a related pkg request, call a helper method to fill attributes in function of logic.
            // Otherwise, fill with needed value from client package.
            if (cpw.hasPkgReq) {
                pkgWrapper = fillSomeValuesFromPkgReqType(pkgWrapper, cpw.lstPAPR, clientPkg);
            } else {
                pkgWrapper.chargeAmount             =       clientPkg.gf_ps_pkg_contract_chrg_amount__c;
                pkgWrapper.chargePeriodicity        =       new Package_Wrapper.ChargePeriodicity(String.valueOf(clientPkg.cuco__gf_cust_pkg_pdicy_charge_type__c), Utils.getPicklistLabel('cuco__client_package__c', 'cuco__gf_cust_pkg_pdicy_charge_type__c', clientPkg.cuco__gf_cust_pkg_pdicy_charge_type__c));
                pkgWrapper.clientRepName            =       clientPkg.gf_ps_pkg_cust_legal_rep_name__c;
                pkgWrapper.clientRepDocNumber       =       clientPkg.gf_ps_pkg_cust_lglr_doc_id__c;
            }

            // Set on the package type lst and related attbs depends on pkg type
            switch on clientPkg.gf_psc_package_code_id__r.cuco__gf_psc_package_type_name__c {
                when 'C' {
                    pkgWrapper.description          =       clientPkg.gf_psc_package_code_id__r.cuco__gf_psc_package_name__c;
                    lstCommercial.add(pkgWrapper);
                }
                when 'G' {
                    pkgWrapper.description          =       clientPkg.cuco__gf_cust_package_desc__c;
                    lstGIP.add(pkgWrapper);
                }
                when 'F' {
                    pkgWrapper.description          =       clientPkg.gf_psc_package_code_id__r.cuco__gf_psc_package_name__c;
                    lstForfait.add(pkgWrapper);
                }
            }
        }

        // Set values to retMap
        retMap = fillMainMap(lstCommercial, lstGIP, lstForfait);
        return retMap;
    }

    /**
    * @description Helper method to fill some wrapper values related to prof analysis pkg req type
    * @param currentPW : Current Package Wrapper to fill some attributes
    * @param profAnalysisPkgReq : Profitability Analysis Pkg Request object to get info
    * @param clientPackage : Client Package object to get info (If exist a related client package from prof analysis pkg request in first param)
    * @return Package_Wrapper, same as param with fill some attributes
    */
    private static Package_Wrapper fillSomeValuesFromPkgReqType(Package_Wrapper currentPW, List<profitability_analysis_pkg_request__c> lstPAPR, client_package__c clientPackage) {
        Boolean isNewOrModification = false;
        for (profitability_analysis_pkg_request__c profAnalysisPkgReq : lstPAPR) {
            // Only to set isVisible false in case of papr without participant_id filled
            currentPW.isVisible = profAnalysisPkgReq.cuco__participant_id__c == null || (profAnalysisPkgReq.cuco__gf_pa_pkg_request_type_name__c == 'Extension' && profAnalysisPkgReq.cuco__gf_pa_pkg_ext_req_st_type_name__c == 'Remove' && profAnalysisPkgReq.cuco__gf_cust_package_id__r.cuco__gf_cst_pkg_ct_status_type__c == 'Cancelled') ? false : true;

            switch on profAnalysisPkgReq.gf_pa_pkg_request_type_name__c {
                when 'New' {
                    isNewOrModification                 =       true;
                    currentPW.chargeAccount             =       profAnalysisPkgReq.gf_pa_pkg_charge_account_desc__c;
                    currentPW.chargeAmount              =       profAnalysisPkgReq.gf_pa_pkg_fee_amount__c;
                    currentPW.chargePeriodicity         =       new Package_Wrapper.ChargePeriodicity(profAnalysisPkgReq.gf_pa_pkg_charge_pdicy_type__c, Utils.getPicklistLabel('cuco__profitability_analysis_pkg_request__c', 'cuco__gf_pa_pkg_charge_pdicy_type__c', profAnalysisPkgReq.gf_pa_pkg_charge_pdicy_type__c));
                    currentPW.clientRepName             =       profAnalysisPkgReq.gf_pa_pkg_cust_legal_rep_name__c;
                    currentPW.clientRepDocNumber        =       profAnalysisPkgReq.gf_pa_pkg_cust_lglr_doc_id__c;
                    currentPW.bankRepName               =       profAnalysisPkgReq.gf_pa_pkg_ent_legal_rep_name__c;
                    currentPW.bankRepDocNumber          =       profAnalysisPkgReq.gf_pa_pkg_ent_lglr_doc_id__c;
                    currentPW.signingLocation           =       profAnalysisPkgReq.gf_pa_pkg_cont_sign_loc_desc__c;
                    currentPW.comments                  =       profAnalysisPkgReq.gf_pa_pkg_req_comments_desc__c;
                    currentPW.newRequestId              =       profAnalysisPkgReq.Id;
                    currentPW.requestStatus             =       new Package_Wrapper.RequestStatus('New', Label.pkg_status_new);
                }
                when 'Modification' {
                    isNewOrModification                 =       true;
                    currentPW.chargeAmount              =       profAnalysisPkgReq.gf_pa_pkg_fee_amount__c;
                    currentPW.chargePeriodicity         =       new Package_Wrapper.ChargePeriodicity(profAnalysisPkgReq.gf_pa_pkg_charge_pdicy_type__c, Utils.getPicklistLabel('cuco__profitability_analysis_pkg_request__c', 'cuco__gf_pa_pkg_charge_pdicy_type__c', profAnalysisPkgReq.gf_pa_pkg_charge_pdicy_type__c));
                    currentPW.clientRepName             =       profAnalysisPkgReq.gf_pa_pkg_cust_legal_rep_name__c;
                    currentPW.clientRepDocNumber        =       profAnalysisPkgReq.gf_pa_pkg_cust_lglr_doc_id__c;
                    currentPW.editRequestId             =       profAnalysisPkgReq.Id;
                    currentPW.requestStatus             =       new Package_Wrapper.RequestStatus('Modification', Label.pkg_status_modification);
                }
                when 'Extension' {
                    currentPW.extensionRequestId        =       profAnalysisPkgReq.Id;
                    if (currentPW.requestStatus == null) {
                        switch on profAnalysisPkgReq.gf_pa_pkg_ext_req_st_type_name__c {
                            when 'Add' {
                                currentPW.requestStatus     =       new Package_Wrapper.RequestStatus('Add_Extension', Label.pkg_status_add_extension);
                            }
                            when 'Remove' {
                                currentPW.requestStatus     =       new Package_Wrapper.RequestStatus('Remove_Extension', Label.pkg_status_remove_extension);
                            }
                        }
                    }
                }
                when 'Cancellation' {
                    currentPW.cancellationRequestId     =       profAnalysisPkgReq.Id;
                    currentPW.requestStatus             =       new Package_Wrapper.RequestStatus('Cancellation', Label.pkg_status_cancellation);
                }
                when else {
                    currentPW.requestStatus             =       new Package_Wrapper.RequestStatus(currentPW.status.id, currentPW.status.value);
                }
            }
        }

        // If this prof analysis pkg req is related to a client package (param not null), then evaluate request type to fill attributes if req type is not new or modification
        if (!isNewOrModification && clientPackage != null) {
            currentPW.chargeAmount                  =       clientPackage.cuco__gf_ps_pkg_contract_chrg_amount__c;
            currentPW.chargePeriodicity             =       new Package_Wrapper.ChargePeriodicity(String.valueOf(clientPackage.cuco__gf_cust_pkg_pdicy_charge_type__c), Utils.getPicklistLabel('cuco__client_package__c', 'cuco__gf_cust_pkg_pdicy_charge_type__c', clientPackage.cuco__gf_cust_pkg_pdicy_charge_type__c));
            currentPW.clientRepName                 =       clientPackage.cuco__gf_ps_pkg_cust_legal_rep_name__c;
            currentPW.clientRepDocNumber            =       clientPackage.cuco__gf_ps_pkg_cust_lglr_doc_id__c;
        }

        return currentPW;
    }

    /**
    * @description Helper method to check if pkg param id is extended
    * @param pkgId : PS Catalog Package
    * @param accountId : Id of the related account
    * @param mapAccDetails : Map with account id as key, and detail acc wrapper as value
    * @param extendedPkgs : Map with account identifier as key, with set of extended packages codes
    * @return Boolean, with result if extended pkg exist
    */
    private static Boolean checkIfPkgIsExtended(String pkgId, Participant_Wrapper partWrapper, Map<String, Set<String>> extendedPkgs) {
        Boolean hasExtPkg = false;
        if (partWrapper != null && extendedPkgs.containsKey(partWrapper.participantCode)) {
            final Set<String> setPkgCodes = extendedPkgs.get(partWrapper.participantCode);
            if (setPkgCodes.contains(pkgId)) {
                hasExtPkg = true;
            }
        }
        return hasExtPkg;
    }

    /**
    * @description Helper method to fill Participant info at Package wrapper
    * @param profParticipantId : Profitability Sheet / Analysis Participant Id
    * @param partWrapper : Participant_Wrapper record to fill attbs
    * @return Package_Wrapper.Participant, with the object fill
    */
    private static Package_Wrapper.Participant fillParticipantInfo(String profParticipantId, Participant_Wrapper partWrapper) {
        final Package_Wrapper.Participant participant = new Package_Wrapper.Participant();
        if (profParticipantId != null) {
            participant.id = profParticipantId;
        }
        participant.accountCode = partWrapper.participantCode;
        participant.accountId = partWrapper.participantId;
        participant.name = partWrapper.participantName;
        participant.documentNumber = partWrapper.documentNumber;
        return participant;
    }

    /**
    * @description Helper method to fill return map to main method due to cognitive complexity
    * @param lstCommercial : List of Package_Wrapper of COMMERCIAL_PACKAGE pkg type
    * @param lstGIP : List of Package_Wrapper of GIP_PACKAGE pkg type
    * @param lstForfait : List of Package_Wrapper of FORFAIT pkg type
    * @return Map<String, List<Package_Wrapper>>, with the currentValueMap param filled with new Participant Wrapper values
    */
    private static Map<String, List<Package_Wrapper>> fillMainMap(List<Package_Wrapper> lstCommercial, List<Package_Wrapper> lstGIP, List<Package_Wrapper> lstForfait) {
        final Map<String, List<Package_Wrapper>> retMap = new Map<String, List<Package_Wrapper>>();
        if (!lstCommercial.isEmpty()) {
            retMap.put('COMMERCIAL_PACKAGE', lstCommercial);
        }
        if (!lstGIP.isEmpty()) {
            retMap.put('GIP_PACKAGE', lstGIP);
        }
        if (!lstForfait.isEmpty()) {
            retMap.put('FORFAIT', lstForfait);
        }
        return retMap;
    }

    /**
    * @description Method to do some checks to the participant selected
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @param formParams: Map with filled form info
    * @return Map<String, Object>, with the result of the method
    */
    public static Map<String, Object> checksSelectedParticipants(Id profAnalysisId, Map<String, Object> formParams) {
        final Map<String, Object> retMap = new Map<String, Object>();
        Boolean validParticipantChecks = true;

        // First, check if related participant dont have client package record with Valid status and GIP or FORFAIT type
        final ClientPackage_Selector cpSelector = new ClientPackage_Selector();
        final List<client_package__c> lstCP = cpSelector.selectPkgByAccIdAndStatusAndPkgType(new Set<Id>{(Id) formParams.get('accSelection')}, new List<String>{'Valid'}, new List<String>{'F','G'});
        if (lstCP.isEmpty()) {
            // Second, check if related participant dont have other prof analysis pkg req with request status New

            // Get papr id
            final PAParticipant_Selector papSelector = new PAParticipant_Selector();
            final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysisAndAcc(new Set<Id>{profAnalysisId}, new Set<Id>{(Id) formParams.get('accSelection')});

            final PAPackageRequest_Selector paprSelector = new PAPackageRequest_Selector();
            final List<profitability_analysis_pkg_request__c> lstPAPR = paprSelector.selectPkgReqByPAPAndReqType(new Set<Id>{lstPAP[0].Id}, new Set<String>{'New'});
            if (!lstPAPR.isEmpty()) {
                validParticipantChecks = false;
            }
        } else {
            validParticipantChecks = false;
        }

        if (validParticipantChecks) {
            retMap.put('isSuccess', true);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', Label.pkg_not_valid_participant);
        }

        return retMap;
    }

    /**
    * @description Do post actions from confirm cancelation of forfait/gip pkg
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param pkgWrapper : Package wrapper to cancel
    * @return Map<String, Object>, with the result of the actions
    */
    public static Map<String, Object> doPkgCancelActions(Id profAnalysisId, Package_Wrapper packageWrapper) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Savepoint savePoint = Database.setSavepoint();
        final Id papr2RemoveId;
        final List<String> lstErrMessages = new List<String>();

        if (packageWrapper.editRequestId != null) {
            papr2RemoveId = packageWrapper.editRequestId;
        }
        if (packageWrapper.newRequestId != null) {
            papr2RemoveId = packageWrapper.newRequestId;
        }
        if (packageWrapper.cancellationRequestId != null) {
            papr2RemoveId = packageWrapper.cancellationRequestId;
        }

        if (packageWrapper.newRequestId == null && packageWrapper.cancellationRequestId == null) {
            // Create a new Cancellation request
            final profitability_analysis_pkg_request__c newForfaitPAPR = new profitability_analysis_pkg_request__c();
            newForfaitPAPR.gf_profitablity_analysis_id__c = profAnalysisId;
            newForfaitPAPR.gf_cust_package_id__c = packageWrapper.clientPackageId;
            newForfaitPAPR.gf_psc_package_id__c = packageWrapper.catalogId;
            newForfaitPAPR.participant_id__c = packageWrapper.participant.id;
            newForfaitPAPR.gf_pa_pkg_request_type_name__c = 'Cancellation';
            newForfaitPAPR.gf_pa_pkg_req_comments_desc__c = Label.remove_pkg_manual_cancel_comments;

            final Utils.DML_Wrapper retDMLInsertPAPR = PAPackage_Service.insertPAPR(new List<profitability_analysis_pkg_request__c>{newForfaitPAPR});
            lstErrMessages.addAll(retDMLInsertPAPR.lstErrMessage);
        }

        if (papr2RemoveId != null) {
            // Remove the current prof analysis pkg req
            final profitability_analysis_pkg_request__c papr2Remove = new profitability_analysis_pkg_request__c(Id = papr2RemoveId);
            final Utils.DML_Wrapper retDMLDeletePAPR = PAPackage_Service.deletePAPR(new List<profitability_analysis_pkg_request__c>{papr2Remove});
            lstErrMessages.addAll(retDMLDeletePAPR.lstErrMessage);
        }

        if (lstErrMessages.isEmpty()) {
            retMap.put('isSuccess', true);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', lstErrMessages.toString());
            Database.rollback(savePoint);
        }
        return retMap;
    }

    /**
    * @Description: Wrapper for ClientPkg Info
    */
    public class ClientPkgWrapper {

        /**
        * @Description: Boolean with hasPkgReq related
        */
        public Boolean hasPkgReq {get; set;}

        /**
        * @Description: profitability_analysis_pkg_request__c with related obj
        */
        public List<profitability_analysis_pkg_request__c> lstPAPR {get; set;}

        /**
        * @Description: client_package__c with related obj
        */
        public client_package__c clientPackage {get; set;}

        /**
        * @Description: Constructor for ClientPkgWrapper class
        */
        public clientPkgWrapper(client_package__c clientPackage, List<profitability_analysis_pkg_request__c> lstPAPR) {
            this.clientPackage = clientPackage;
            this.lstPAPR = lstPAPR;
            if (lstPAPR == null) {
                this.hasPkgReq = false;
            } else {
                this.hasPkgReq = true;
            }
        }
    }
  }