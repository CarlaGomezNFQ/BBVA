/**
* ────────────────────────────────────────────────────────────────────
* ProfitabilityAnalysis_Helper
* Helper class for ProfitabilityAnalysis_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-26
* @modified
* @systemLayer Any
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled, PMD.ExcessivePublicCount, PMD.StdCyclomaticComplexity')
global class ProfitabilityAnalysis_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ProfitabilityAnalysis_Helper() {}

    /**
    * @description Returns a Profitability Analysis record
    * @param profAnalysisId : Id of Prof analysis
    * @return String, with the user Code
    */
    public static List<profitability_analysis__c> getProfitabilityAnalysisInfo(set<Id> profAnalysisIds) {
        ProfitabilityAnalysis_Selector selector = new ProfitabilityAnalysis_Selector();
        return selector.selectById(profAnalysisIds);
    }

    /**
    * @description Returns a String with user Code
    * @param genConfig : Metadata record with the general configuration of classes
    * @param userId : Id user
    * @return String, with the user Code
    */
    public static String getUserCode(pa_general_configuration__mdt genConfig, Id userId) {
        final Type permissionsClass = Type.forName(genConfig.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profitabiItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        return profitabiItf.getUserCode(userId);
    }

    /**
    * @description Returns User Id
    * @param genConfig : Metadata record with the general configuration of classes
    * @param userCode : Federation Id of the user
    * @return Id, with the user Id
    */
    public static Id getUserId(pa_general_configuration__mdt genConfig, String userCode) {
        final Type permissionsClass = Type.forName(genConfig.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profitabiItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        return profitabiItf.getUserId(userCode);
    }

    /*
    * @description Returns a String with Branch code
    * @param genConfig : Metadata record with the general configuration of classes
    * @param contextRecordId : Id of the Profitability Ananlysis or Profitability Sheet
    * @return String with Account.Sic code
    */
    public static String getBranchCode(pa_general_configuration__mdt genConfig, Id contextRecordId) {
        final Type permissionsClass = Type.forName(genConfig.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        final String contextObject = contextRecordId.getSobjectType().getDescribe().getName();
        return profAnalysisItf.getBranchCode(contextRecordId, contextObject);
    }

    /**
    * @description Returns the extended packages of type Commercial or Forfait of each account of a prof analysis
    * @param profAnalysisId : Id of the profitability analysis to filter search
    * @return Map<String, Set<String>>, with acc identifier as key, and set of each extended package id related to the key account
    */
    public static Map<String, Set<String>> getExtendedPkgOfProfAnalysis(Id profAnalysisId) {
        Map<String, Set<String>> retMap = new Map<String, Set<String>>();
        ProfitabilityAnalysisCondition_Selector pacSelector = new ProfitabilityAnalysisCondition_Selector();
        List<profitability_analysis_condition__c> lstPAC = pacSelector.selectByProfitabilityAnalysisIdAndSourceType(new Set<Id>{profAnalysisId}, new List<String>{'COMMERCIAL_PACKAGE', 'FORFAIT'});
        for (profitability_analysis_condition__c pac : lstPAC) {
            String sourceClientPkg = pac.gf_pa_source_cust_package_id__c;
            String accIdentifier = sourceClientPkg.substring(0, sourceClientPkg.length() - 5);
            String pkgId = sourceClientPkg.substring(sourceClientPkg.length() - 5, sourceClientPkg.length());
            if (retMap.containsKey(accIdentifier)) {
                Set<String> setAux = retMap.get(accIdentifier);
                setAux.add(pkgId);
                retMap.put(accIdentifier, setAux);
            } else {
                Set<String> setAux = new Set<String>();
                setAux.add(pkgId);
                retMap.put(accIdentifier, setAux);
            }
        }
        return retMap;
    }

    /**
    * @description Insert the profitability analysis  passed as parameters
    * @param lstPA: List of profitability analysis ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPA (List<profitability_analysis__c> lstPA) {
        final List<String> errLstInsertPA = new List<String>();
        final List<Database.SaveResult> srLstPA = Database.insert(lstPA, true);
        // Iterate through each returned result
        for (Database.SaveResult srPA : srLstPA) {
            if (!srPA.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPA : srPA.getErrors()) {
                    errLstInsertPA.add(errInsPA.getMessage());
                    System.debug('Insert profitability_analysis__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPA.getStatusCode() + ': ' + errInsPA.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsertPA.isEmpty(), errLstInsertPA);
    }

    /**
    * @description Insert the profitability analysis passed as parameters
    * @param profAnalysisId : Id of the profitability analysis to filter search
    * @return ProfitabilityAnalysis_Wrapper, with the response of the context Profitability analysis
    */
    global static ProfitabilityAnalysis_Wrapper getProfAnalysis (Id profAnalysisId) {

        final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(true);
        final List<profitability_analysis__c> profAnList = profAnSelector.selectById(new Set<Id>{profAnalysisId});
        final ProfitabilitySheet_Selector profShSelector = new ProfitabilitySheet_Selector(true);
        final ProfitabilityAnalysis_Wrapper wrapperToReturn = new ProfitabilityAnalysis_Wrapper();
        final List<Profitability_sheet__c> profShList = profShSelector.selectById(new Set<Id>{profAnList[0].cuco__gf_profitability_sheet_id__c});

        wrapperToReturn.id = profAnList[0].Id;
        wrapperToReturn.name = profAnList[0].Name;
        wrapperToReturn.typology = profAnList[0].cuco__gf_pa_management_type_name__c;
        wrapperToReturn.stage = profAnList[0].cuco__gf_pa_mgmt_stage_type_name__c;
        wrapperToReturn.status = profAnList[0].cuco__gf_pa_mgmt_status_type_name__c;

        if (profShList != null && !profShList.isEmpty()) {
            wrapperToReturn.code = profShList[0].cuco__gf_profitability_sheet_id__c;
            if (profAnList[0].cuco__gf_pa_management_type_name__c == 'Novation' || profAnList[0].cuco__gf_pa_management_type_name__c == 'Renewal' || profAnList[0].cuco__gf_pa_management_type_name__c == 'Cancellation') {
                wrapperToReturn.originStartDate = profShList[0].cuco__gf_prftbly_sheet_start_date__c;
                wrapperToReturn.originEndDate = profShList[0].cuco__gf_prftbly_sheet_end_date__c;
                wrapperToReturn.originName = profShList[0].Name;
                wrapperToReturn.originTransOffer = profShList[0].cuco__gf_ps_transactional_offer_name__c;
            }
        }

        // Get participants hierarchy for the param account
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();
        final ParticipantHierarchy_Wrapper resPartHierarchy = Participants_Helper.getParticipantHierarchy(genConfig, profAnList[0].cuco__participant_id__c);

        if (resPartHierarchy != null) {
            final ProfitabilityAnalysis_Wrapper.MainParticipant mainPart = new ProfitabilityAnalysis_Wrapper.MainParticipant();
            mainPart.name = resPartHierarchy.name;
            mainPart.integrationId = resPartHierarchy.integrationId;
            mainPart.type = resPartHierarchy.type;
            mainPart.accountId = profAnList[0].cuco__participant_id__c;
            wrapperToReturn.MainParticipant = mainPart;
        }

        wrapperToReturn.branchCode = ProfitabilityAnalysis_Helper.getBranchCode(genConfig, profAnalysisId);

        wrapperToReturn.delegatedBranchCode = profAnList[0].cuco__gf_pa_aprvl_proc_deleg_br_id__c;
        wrapperToReturn.segment = profAnList[0].cuco__segment_type__c;
        wrapperToReturn.startDate = profAnList[0].cuco__gf_pa_cond_appl_eff_date__c;
        wrapperToReturn.endDate = profAnList[0].cuco__gf_pa_cond_appl_expiry_date__c;
        wrapperToReturn.ownerId = profAnList[0].OwnerId;
        wrapperToReturn.ownerName = ProfitabilityAnalysis_Service.getFirstAndLastName(profAnList[0].OwnerId);
        wrapperToReturn.ownerCode = ProfitabilityAnalysis_Helper.getUserCode(genConfig, profAnList[0].OwnerId);
        wrapperToReturn.isSpecificContractsScope = profAnList[0].cuco__gf_all_ct_apply_cond_ind_type__c;
        wrapperToReturn.contractsScopeDesc = profAnList[0].cuco__gf_pa_all_ct_cond_app_rsn_desc__c;
        wrapperToReturn.isForcedManualManagement = profAnList[0].cuco__gf_pa_forced_mf_mgmt_ind_type__c;
        wrapperToReturn.comments = profAnList[0].cuco__gf_pa_comments_desc__c;
        wrapperToReturn.autoFormRequestId = profAnList[0].cuco__gf_auto_formalization_req_id__c;
        wrapperToReturn.manualFormRequestId = profAnList[0].cuco__gf_manl_formalization_req_id__c;
        wrapperToReturn.priceApprovalId = profAnList[0].cuco__gf_price_aprvl_process_req_id__c;
        wrapperToReturn.priceNegDate = profAnList[0].cuco__gf_pa_price_negotiated_date__c;
        wrapperToReturn.lastAutoFormDate = profAnList[0].cuco__gf_auto_form_sys_lst_cmun_date__c;

        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});

        if (lstPAP != null && !lstPAP.isEmpty()) {
            final Set<Id> setParticipantId = new Set<Id>();
            final Map<Id,profitability_analysis_participant__c> mapIdPap = new Map<Id,profitability_analysis_participant__c>();
            for (profitability_analysis_participant__c paParticipant : lstPAP) {
                setParticipantId.add(paParticipant.cuco__participant_id__c);
                mapIdPap.put(paParticipant.cuco__participant_id__c, paParticipant);
            }

            final List<Participant_Wrapper> lstWrpParticipant = Participants_Helper.getParticipantDetails(genConfig, setParticipantId);

            wrapperToReturn.participantsList = getParticipantsList(lstWrpParticipant, mapIdPap);
        }

        final ProfitabilityAnalysisCondition_Selector profAnalCondSelector = new ProfitabilityAnalysisCondition_Selector(true);
        final List<profitability_analysis_condition__c> lstProfAnalCond = profAnalCondSelector.byProfitabiliyAnalysisId(new Set<Id>{profAnalysisId});
        final PsCatalogConditionAttribute_Selector psCatalogConditionAttSelector = new PsCatalogConditionAttribute_Selector(true);

        final Set<Id> setIdCondition = new Set<Id>();
        for (profitability_analysis_condition__c profAnalcond : lstProfAnalCond) {
            setIdCondition.add(profAnalcond.gf_psc_condition_id__c);
        }

        final List<ps_catalog_condition_attribute__c> psCatalogConditions = psCatalogConditionAttSelector.selectConditionAttributesFromConditionIds(setIdCondition);
        final Map<Id,List<ps_catalog_condition_attribute__c>> mapCatalogCondition = getCatalogConditionAttributesMap(psCatalogConditions);

        wrapperToReturn.conditionsList = getProfitabilityWrapperConditionList(lstProfAnalCond, mapCatalogCondition);

        final ProfitabilityAnalysisFlatRates_Selector profAnalFlatRatesSelector = new ProfitabilityAnalysisFlatRates_Selector(true);
        final List<profitability_analysis_flat_rates__c> lstProfAnalFlatRates = profAnalFlatRatesSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});
        final ProfitabilityAnalysis_Wrapper.FlatRate fr = new ProfitabilityAnalysis_Wrapper.FlatRate();

        if (lstProfAnalFlatRates != null && !lstProfAnalFlatRates.isEmpty()) {

            fr.id = lstProfAnalFlatRates[0].Id;
            fr.requestType = lstProfAnalFlatRates[0].gf_pa_fr_request_type__c;

            final PsCatalogFlatRatesAttribute_Selector psCataFlatRateAttSelector = new PsCatalogFlatRatesAttribute_Selector(true);
            final List<ps_catalog_flat_rates_attribute__c> lstPsCataFlatRateAtt = psCataFlatRateAttSelector.selectAll(100);

            fr.flatRatesInfoAttList = getAttributeList(lstProfAnalFlatRates[0],lstPsCataFlatRateAtt);

            final ProfitabilityAnalysFlatRateAcc_Selector profAnalFlatRatesAccountSelector = new ProfitabilityAnalysFlatRateAcc_Selector(true);
            final List<profitability_analysis_flatrates_account__c> lstProfAnalFlatRateAcc = profAnalFlatRatesAccountSelector.selectByProfAnalFlatRates(new Set<Id>{lstProfAnalFlatRates[0].Id});
            final ProfitabilityAnalysiFlatRateDp_Selector profAnalFlatRatesDpSelector = new ProfitabilityAnalysiFlatRateDp_Selector(true);
            final List<profitability_analysis_flat_rates_dp__c> lstProfAnalFlatRatesDp = profAnalFlatRatesDpSelector.selectByProfAnalysisFlatRate(new Set<Id>{lstProfAnalFlatRates[0].Id});

            if (lstProfAnalFlatRateAcc != null && !lstProfAnalFlatRateAcc.isEmpty()) {
                fr.flatRateAccountsList = getFlatRateAccountList(lstProfAnalFlatRateAcc);
            }

            final Set<Id> setPafrDp = new set<Id>();
            for (profitability_analysis_flat_rates_dp__c profAnalFlatRatesDp : lstProfAnalFlatRatesDp) {
                setPafrDp.add(profAnalFlatRatesDp.cuco__gf_fr_dynamic_pricing_item_id__c);
            }

            final ProfitabilityAnalFlatRateDpAtt_Selector profAnalFlatRatesDpAttSelector = new ProfitabilityAnalFlatRateDpAtt_Selector(true);
            final List<ps_catalog_flat_rates_dp_attribute__c> lstProfAnalFlatRatesDpAttribute = profAnalFlatRatesDpAttSelector.selectByProfAnalFlatRateDp(setPafrDp);
            final Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>> mapFlatRatesDpAttribute = getPsCatalogFlatRatesDpAttributeMap(lstProfAnalFlatRatesDpAttribute);

            fr.dpItemList = getDpItemList(lstProfAnalFlatRatesDp, mapFlatRatesDpAttribute);
            fr.flatConditionsList = getFlatConditionList(lstProfAnalCond);
            wrapperToReturn.FlatRate = fr;
        }

        final ProfitabilityAnalysis_Wrapper.packages packages = new ProfitabilityAnalysis_Wrapper.packages();

        packages.extendedPackages = new List<String>(getExtendLst(ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(profAnalysisId)));
        packages.commPackageList = Packages_Helper.getPackages(profAnalysisId, new Set<String>{'COMMERCIAL_PACKAGE'}, ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(profAnalysisId)).get('COMMERCIAL_PACKAGE');
        packages.forfaitPackageList = Packages_Helper.getPackages(profAnalysisId, new Set<String>{'FORFAIT'}, ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(profAnalysisId)).get('FORFAIT');
        packages.gipPackageList = Packages_Helper.getPackages(profAnalysisId, new Set<String>{'GIP_PACKAGE'}, ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(profAnalysisId)).get('GIP_PACKAGE');
        wrapperToReturn.packages = packages;

        return wrapperToReturn;
    }

    /**
    * @description return a map list of ps_catalog_condition_attribute__c
    * @param psCatalogConditions : List<ps_catalog_condition_attribute__c>
    * @return mapToReturn : Map<Id,List<ps_catalog_condition_attribute__c>>
    */
    public static Map<Id,List<ps_catalog_condition_attribute__c>> getCatalogConditionAttributesMap (List<ps_catalog_condition_attribute__c> psCatalogConditions) {

        final Map<Id,List<ps_catalog_condition_attribute__c>> mapToReturn = new Map<Id,List<ps_catalog_condition_attribute__c>>();
        List<ps_catalog_condition_attribute__c> psCatalogConditionsList;
        for (ps_catalog_condition_attribute__c catalogConditionAttr : psCatalogConditions) {
            if (mapToReturn.containsKey(catalogConditionAttr.gf_psc_condition_id__c)) {
                mapToReturn.get(catalogConditionAttr.gf_psc_condition_id__c).add(catalogConditionAttr);
            } else {
                psCatalogConditionsList = new List<ps_catalog_condition_attribute__c>();
                psCatalogConditionsList.add(catalogConditionAttr);
                mapToReturn.put(catalogConditionAttr.gf_psc_condition_id__c,psCatalogConditionsList);
            }
        }
        return mapToReturn;
    }

    /**
    * @description return a map list of ps_catalog_condition_attribute__c
    * @param lstProfAnalFlatRatesDpAttribute : List<ps_catalog_flat_rates_dp_attribute__c>
    * @return mapToReturn : Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>>
    */
    public static Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>> getPsCatalogFlatRatesDpAttributeMap (List<ps_catalog_flat_rates_dp_attribute__c> lstProfAnalFlatRatesDpAttribute ) {

        final Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>> mapToReturn = new Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>>();
        List<ps_catalog_flat_rates_dp_attribute__c> psCatalogFlatRatesDpAtt;
        for (ps_catalog_flat_rates_dp_attribute__c profAnalFlatRatesDpAtt : lstProfAnalFlatRatesDpAttribute) {
            if (mapToReturn.containsKey(profAnalFlatRatesDpAtt.cuco__gf_psc_fr_dynamic_pricing_id__c)) {
                mapToReturn.get(profAnalFlatRatesDpAtt.cuco__gf_psc_fr_dynamic_pricing_id__c).add(profAnalFlatRatesDpAtt);
            } else {
                psCatalogFlatRatesDpAtt = new List<ps_catalog_flat_rates_dp_attribute__c >();
                psCatalogFlatRatesDpAtt.add(profAnalFlatRatesDpAtt);
                mapToReturn.put(profAnalFlatRatesDpAtt.gf_psc_fr_dynamic_pricing_id__c,psCatalogFlatRatesDpAtt);
            }
        }
        return mapToReturn;
    }

    /**
    * @description return a ProfitabilityAnalysis_Wrapper.Attribute list
    * @param mapFlatRatesDpAttribute : Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>>
    * @param profAnalFlatRatesDp : profitability_analysis_flat_rates_dp__c
    * @return lstDpAtt : List<ProfitabilityAnalysis_Wrapper.Attribute>
    */
    public static List<ProfitabilityAnalysis_Wrapper.Attribute> getDpAttributeList (profitability_analysis_flat_rates_dp__c profAnalFlatRatesDp, Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>> mapFlatRatesDpAttribute) {

        final List<ProfitabilityAnalysis_Wrapper.Attribute> lstDpAtt = new List<ProfitabilityAnalysis_Wrapper.Attribute>();
        for (cuco__ps_catalog_flat_rates_dp_attribute__c catalogFlateRatrDpAtt : mapFlatRatesDpAttribute.get(profAnalFlatRatesDp.gf_fr_dynamic_pricing_item_id__c)) {
            if (profAnalFlatRatesDp.get(catalogFlateRatrDpAtt.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c) != null) {
                final ProfitabilityAnalysis_Wrapper.Attribute dpAttribute = new ProfitabilityAnalysis_Wrapper.Attribute();
                dpAttribute.canonicalId = catalogFlateRatrDpAtt.cuco__gf_psc_dynamic_pricing_atrb_id__c;
                dpAttribute.attCanonicalId = catalogFlateRatrDpAtt.cuco__gf_psc_atribute_id__r.gf_psc_attribute_id__c;
                if (catalogFlateRatrDpAtt.cuco__gf_psc_atribute_id__r.cuco__gf_attribute_value_type_name__c == 'List') {
                    dpAttribute.value = Utils.getPicklistLabel('cuco__profitability_analysis_flat_rates_dp__c', 'cuco__' + catalogFlateRatrDpAtt.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c, String.valueOf(profAnalFlatRatesDp.get(catalogFlateRatrDpAtt.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c)));
                } else {
                    dpAttribute.value = String.valueOf(profAnalFlatRatesDp.get(catalogFlateRatrDpAtt.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c));
                }
                dpAttribute.valueId = String.valueOf(profAnalFlatRatesDp.get(catalogFlateRatrDpAtt.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c));
                dpAttribute.valueType = catalogFlateRatrDpAtt.cuco__gf_psc_atribute_id__r.cuco__gf_attribute_value_type_name__c;
                dpAttribute.name = catalogFlateRatrDpAtt.cuco__gf_psc_atribute_id__r.Name;
                dpAttribute.origin = 'DYNAMIC_PRICING';
                dpAttribute.formType = 'Automatic';
                dpAttribute.isPriceAtt = false;
                dpAttribute.formatType = catalogFlateRatrDpAtt.cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_format_type__c;
                dpAttribute.formatUnitType = catalogFlateRatrDpAtt.cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_fmt_unit_type__c;

                lstDpAtt.add(dpAttribute);
            }
        }
        return lstDpAtt;
    }

    /**
    * @description return a ProfitabilityAnalysis_Wrapper.FlatCondition list
    * @param lstProfAnalCond : List<profitability_analysis_condition__c>
    * @return lstFlatCondition : List<ProfitabilityAnalysis_Wrapper.FlatCondition>
    */
    public static List<ProfitabilityAnalysis_Wrapper.FlatCondition> getFlatConditionList (List<profitability_analysis_condition__c> lstProfAnalCond) {

        final List<ProfitabilityAnalysis_Wrapper.FlatCondition> lstFlatCondition = new List<ProfitabilityAnalysis_Wrapper.FlatCondition>();
        for (profitability_analysis_condition__c profAnalcond : lstProfAnalCond) {
            if (profAnalcond.gf_pa_cond_atrb_source_type__c == 'COMMISSIONS_FLAT') {
                final ProfitabilityAnalysis_Wrapper.FlatCondition flatCondition = new ProfitabilityAnalysis_Wrapper.FlatCondition();
                flatCondition.id = profAnalcond.gf_psc_condition_id__c;
                flatCondition.name = profAnalcond.gf_psc_condition_id__r.Name;
                flatCondition.family = profAnalcond.gf_psc_condition_id__r.gf_psc_family_id__r.Name;
                flatCondition.product = profAnalcond.gf_psc_condition_id__r.gf_psc_family_id__r.gf_psc_family_product_name__c;
                flatCondition.estimatedVolume = Integer.valueOf(profAnalcond.gf_pa_cnd_fr_est_op_vol_amount__c);
                flatCondition.canonicalId = profAnalcond.gf_psc_condition_id__r.gf_psc_condition_id__c;

                lstFlatCondition.add(flatCondition);
            }
        }
        return lstFlatCondition;
    }

    /**
    * @description return a ProfitabilityAnalysis_Wrapper.FlatRteAccount list
    * @param lstProfAnalFlatRateAcc : List<profitability_analysis_flatrates_account__c>
    * @return lstFlatCondition : List<ProfitabilityAnalysis_Wrapper.FlatRteAccount>
    */
    public static List<ProfitabilityAnalysis_Wrapper.FlatRteAccount> getFlatRateAccountList (List<profitability_analysis_flatrates_account__c> lstProfAnalFlatRateAcc) {

        final List<ProfitabilityAnalysis_Wrapper.FlatRteAccount> flatRteAccountList = new List<ProfitabilityAnalysis_Wrapper.FlatRteAccount>();
        for (profitability_analysis_flatrates_account__c profAnalFlatRateAcc : lstProfAnalFlatRateAcc) {
            final ProfitabilityAnalysis_Wrapper.FlatRteAccount flatRateAcc = new ProfitabilityAnalysis_Wrapper.FlatRteAccount();
            flatRateAcc.id = profAnalFlatRateAcc.cuco__gf_pa_flat_rate_account_id__c;
            flatRateAcc.code = profAnalFlatRateAcc.gf_pa_flat_rate_account_id__r.gf_psc_flat_rate_ac_id__c;
            flatRateAcc.name = profAnalFlatRateAcc.cuco__gf_pa_flat_rate_account_id__r.Name;

            final ProfitabilityAnalysis_Wrapper.Attribute accountAttribute = new ProfitabilityAnalysis_Wrapper.Attribute();
            accountAttribute.canonicalId = profAnalFlatRateAcc.gf_pa_flat_rate_account_id__r.gf_psc_flat_rate_ac_svc_id__c;
            accountAttribute.value = String.valueOf(profAnalFlatRateAcc.gf_pa_fr_ac_use_per__c);
            accountAttribute.valueId = String.valueOf(profAnalFlatRateAcc.gf_pa_fr_ac_use_per__c);
            accountAttribute.valueType = 'Percent';
            accountAttribute.name = Label.flat_rates_account_use;
            accountAttribute.origin = 'PROFIT_LOSS_ACCOUNT';
            accountAttribute.formType = 'Automatic';
            accountAttribute.isPriceAtt = false;
            accountAttribute.formatType = 'RATE';
            accountAttribute.formatUnitType = 'PER_CENT';

            flatRateAcc.accountAttribute = accountAttribute;

            flatRteAccountList.add(flatRateAcc);
        }
        return flatRteAccountList;
    }

    /**
    * @description return a ProfitabilityAnalysis_Wrapper.Attribute list
    * @param lstProfAnalFlatRateAcc : List<ps_catalog_flat_rates_attribute__c>
    * @param lstProfAnalFlatRates : profitability_analysis_flat_rates__c
    * @return lstFlatCondition : List<ProfitabilityAnalysis_Wrapper.Attribute>
    */
    public static List<ProfitabilityAnalysis_Wrapper.Attribute> getAttributeList (profitability_analysis_flat_rates__c lstProfAnalFlatRates, List<ps_catalog_flat_rates_attribute__c> lstPsCataFlatRateAtt) {

        final List<ProfitabilityAnalysis_Wrapper.Attribute> attributeList = new List<ProfitabilityAnalysis_Wrapper.Attribute>();
        for (ps_catalog_flat_rates_attribute__c psCataFlatRateAtt : lstPsCataFlatRateAtt) {
            if (lstProfAnalFlatRates.get(psCataFlatRateAtt.cuco__gf_psc_attribute_id__r.cuco__gf_stored_prps_atrb_field_name__c) != null
                && lstProfAnalFlatRates.get(psCataFlatRateAtt.gf_psc_attribute_id__r.gf_stored_prps_atrb_field_name__c) != '') {

                final ProfitabilityAnalysis_Wrapper.Attribute att = new ProfitabilityAnalysis_Wrapper.Attribute();
                att.canonicalId = psCataFlatRateAtt.gf_psc_flat_attribute_id__c;
                att.attCanonicalId = psCataFlatRateAtt.gf_psc_attribute_id__r.gf_psc_attribute_id__c;
                if (psCataFlatRateAtt.gf_psc_attribute_id__r.gf_attribute_value_type_name__c == 'List') {
                    att.value = Utils.getPicklistLabel('cuco__profitability_analysis_flat_rates__c', 'cuco__' + psCataFlatRateAtt.cuco__gf_psc_attribute_id__r.cuco__gf_stored_prps_atrb_field_name__c, String.valueOf(lstProfAnalFlatRates.get(psCataFlatRateAtt.gf_psc_attribute_id__r.gf_stored_prps_atrb_field_name__c)));
                } else {
                    att.value = String.valueOf(lstProfAnalFlatRates.get(psCataFlatRateAtt.gf_psc_attribute_id__r.gf_stored_prps_atrb_field_name__c));
                }
                att.valueId = String.valueOf(lstProfAnalFlatRates.get(psCataFlatRateAtt.gf_psc_attribute_id__r.gf_stored_prps_atrb_field_name__c));
                att.valueType = psCataFlatRateAtt.gf_psc_attribute_id__r.gf_attribute_value_type_name__c;
                att.name = psCataFlatRateAtt.gf_psc_attribute_id__r.Name;
                att.origin = 'FLAT_INFORMATION';
                att.formType = psCataFlatRateAtt.gf_psc_fr_atrb_form_meth_type__c;
                att.isPriceAtt = false;
                att.formatType = psCataFlatRateAtt.gf_psc_attribute_id__r.gf_psc_bknd_svc_fmt_unit_type__c;
                att.formatUnitType = psCataFlatRateAtt.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c;

                attributeList.add(att);
            }
        }
        return attributeList;
    }

    /**
    * @description return a ProfitabilityAnalysis_Wrapper.Attribute list
    * @param mapCatalogCondition : Map<Id,List<ps_catalog_condition_attribute__c>>
    * @param profAnalcond : profitability_analysis_condition__c
    * @return attributesList : List<ProfitabilityAnalysis_Wrapper.Attribute>
    */
    public static List<ProfitabilityAnalysis_Wrapper.Attribute> getConditionAttributeList (profitability_analysis_condition__c profAnalcond, Map<Id,List<ps_catalog_condition_attribute__c>> mapCatalogCondition) {

        final List<ProfitabilityAnalysis_Wrapper.Attribute> attributesList = new List<ProfitabilityAnalysis_Wrapper.Attribute>();
        for (ps_catalog_condition_attribute__c catalogConditionAttr : mapCatalogCondition.get(profAnalcond.cuco__gf_psc_condition_id__c)) {
            if (catalogConditionAttr.cuco__gf_psc_cond_atrb_act_ind_type__c == true && String.valueOf(profAnalcond.get(catalogConditionAttr.gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c)) != null && String.valueOf(profAnalcond.get(catalogConditionAttr.gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c)) != '') {
                final ProfitabilityAnalysis_Wrapper.Attribute attribute = new ProfitabilityAnalysis_Wrapper.Attribute();
                attribute.canonicalId = catalogConditionAttr.gf_psc_condition_attribute_id__c;
                attribute.attCanonicalId = catalogConditionAttr.gf_psc_atribute_id__r.gf_psc_attribute_id__c;
                if (catalogConditionAttr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c == 'List') {
                    attribute.value = Utils.getPicklistLabel('cuco__profitability_analysis_condition__c', 'cuco__' + catalogConditionAttr.gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c, String.valueOf(profAnalcond.get(catalogConditionAttr.gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c)));
                } else {
                    attribute.value = String.valueOf(profAnalcond.get(catalogConditionAttr.gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c));
                }

                attribute.valueId = String.valueOf(profAnalcond.get(catalogConditionAttr.gf_psc_atribute_id__r.cuco__gf_stored_prps_atrb_field_name__c));
                attribute.valueType = catalogConditionAttr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                attribute.name = catalogConditionAttr.gf_psc_atribute_id__r.name;
                attribute.origin = profAnalcond.gf_pa_cond_atrb_source_type__c;
                attribute.formType = catalogConditionAttr.gf_psc_fa_frmlz_proc_type_name__c;
                attribute.isPriceAtt = catalogConditionAttr.gf_psc_fa_prc_aprvl_ind_type__c;
                attribute.formatType = catalogConditionAttr.gf_psc_atribute_id__r.gf_psc_bknd_svc_format_type__c;
                attribute.formatUnitType = catalogConditionAttr.gf_psc_atribute_id__r.gf_psc_bknd_svc_fmt_unit_type__c;

                attributesList.add(attribute);
            }
        }
        return attributesList;
    }

    /**
    * @description return a ProfitabilityAnalysis_Wrapper.Participants list
    * @param lstWrpParticipant : List<Participant_Wrapper>
    * @param mapIdPap : Map<Id,profitability_analysis_participant__c>
    * @return participantsList : List<ProfitabilityAnalysis_Wrapper.Participants>
    */
    public static List<ProfitabilityAnalysis_Wrapper.Participants> getParticipantsList (List<Participant_Wrapper> lstWrpParticipant, Map<Id,profitability_analysis_participant__c> mapIdPap) {

        final List<ProfitabilityAnalysis_Wrapper.Participants> participantsList = new List<ProfitabilityAnalysis_Wrapper.Participants>();
        for (Participant_Wrapper participant : lstWrpParticipant) {
            if (mapIdPap.get(participant.participantId).cuco__participant_id__c == participant.participantId) {

                final ProfitabilityAnalysis_Wrapper.Participants participantWr = new ProfitabilityAnalysis_Wrapper.Participants();
                participantWr.id = mapIdPap.get(participant.participantId).Id;
                participantWr.name = participant.participantName;
                participantWr.integrationId = participant.participantIntegrationId;
                participantWr.documentNum = participant.documentNumber;
                participantWr.documentType = participant.documentType;
                participantWr.documentTypeCode = participant.documentTypeCode;
                participantWr.accountId = mapIdPap.get(participant.participantId).cuco__participant_id__c;
                participantWr.code = participant.participantCode;

                participantsList.add(participantWr);
            }
        }
        return participantsList;
    }

    /**
    * @description return a Map with the catalogue condition attribute type information
    * @param mapCatalogCondition : Map<Id,List<ps_catalog_condition_attribute__c>>
    * @param profAnalcond : profitability_analysis_condition__c
    * @return mapToReturn : Map<String, Boolean>
    */
    public static Map<String, Boolean> getManualConditionType (Map<Id,List<ps_catalog_condition_attribute__c>> mapCatalogCondition, profitability_analysis_condition__c profAnalcond) {

        Boolean hasManual = false;
        Boolean hasInfo = false;
        Boolean hasAuto = false;

        final Map<String, Boolean> mapToReturn = new Map<String, Boolean>();
        for (ps_catalog_condition_attribute__c catalogConditionAttr : mapCatalogCondition.get(profAnalcond.cuco__gf_psc_condition_id__c)) {
            if (catalogConditionAttr.gf_psc_fa_frmlz_proc_type_name__c == 'Manual') {
                hasManual = true;
            } else if (catalogConditionAttr.gf_psc_fa_frmlz_proc_type_name__c == 'Informative') {
                hasInfo = true;
            } else {
                hasAuto = true;
            }
        }
        mapToReturn.put('manual', hasManual);
        mapToReturn.put('info', hasInfo);
        mapToReturn.put('auto', hasAuto);

        return mapToReturn;
    }

    /**
    * @description return a rofitabilityAnalysis_Wrapper.DpItem list
    * @param lstProfAnalFlatRatesDp : List<profitability_analysis_flat_rates_dp__c>
    * @param mapFlatRatesDpAttribute : Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>>
    * @return dpItemList : List<ProfitabilityAnalysis_Wrapper.DpItem>
    */
    public static List<ProfitabilityAnalysis_Wrapper.DpItem> getDpItemList (List<profitability_analysis_flat_rates_dp__c> lstProfAnalFlatRatesDp, Map<Id,List<ps_catalog_flat_rates_dp_attribute__c>> mapFlatRatesDpAttribute) {

        final List<ProfitabilityAnalysis_Wrapper.DpItem> dpItemList = new List<ProfitabilityAnalysis_Wrapper.DpItem>();

        for (profitability_analysis_flat_rates_dp__c profAnalFlatRatesDp : lstProfAnalFlatRatesDp) {

            ProfitabilityAnalysis_Wrapper.DpItem dpItem = new ProfitabilityAnalysis_Wrapper.DpItem();
            dpItem.Id = profAnalFlatRatesDp.cuco__gf_fr_dynamic_pricing_item_id__c;
            dpItem.classification = profAnalFlatRatesDp.gf_fr_dynamic_pricing_item_id__r.gf_dp_item_classification_desc__c;
            dpItem.name = profAnalFlatRatesDp.gf_fr_dynamic_pricing_item_id__r.Name;
            dpItem.dpAttList = getDpAttributeList(profAnalFlatRatesDp, mapFlatRatesDpAttribute);
            dpItem.canonicalId = profAnalFlatRatesDp.gf_fr_dynamic_pricing_item_id__r.gf_dynamic_pricing_item_id__c;
            dpItem.cross = profAnalFlatRatesDp.gf_fr_dynamic_pricing_item_id__r.gf_dp_item_crscls_ind_type__c;
            dpItemList.add(dpItem);
        }
        return dpItemList;
    }

    /**
    * @description return a ProfitabilityAnalysis_Wrapper.DpItem list
    * @param lstProfAnalCond : List<profitability_analysis_condition__c>
    * @param mapCatalogCondition : Map<Id,List<ps_catalog_condition_attribute__c>>
    * @return conditionList : List<ProfitabilityAnalysis_Wrapper.condition>
    */
    public static List<ProfitabilityAnalysis_Wrapper.condition> getProfitabilityWrapperConditionList (List<profitability_analysis_condition__c> lstProfAnalCond, Map<Id,List<ps_catalog_condition_attribute__c>> mapCatalogCondition) {

        List<ProfitabilityAnalysis_Wrapper.condition> conditionList = new List<ProfitabilityAnalysis_Wrapper.condition>();
        for (profitability_analysis_condition__c profAnalcond : lstProfAnalCond) {

            ProfitabilityAnalysis_Wrapper.Condition condition = new ProfitabilityAnalysis_Wrapper.Condition();
            condition.id = profAnalcond.cuco__gf_psc_condition_id__c;
            condition.name = profAnalcond.cuco__gf_psc_condition_id__r.name;
            condition.family = profAnalcond.cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.Name;
            condition.familyCanonicalId = profAnalcond.cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_id__c;
            condition.canonicalId = profAnalcond.cuco__gf_psc_condition_id__r.cuco__gf_psc_condition_id__c;
            condition.product = profAnalcond.cuco__gf_psc_condition_id__r.cuco__gf_psc_family_id__r.cuco__gf_psc_family_product_name__c;
            condition.source = profAnalcond.cuco__gf_pa_cond_atrb_source_type__c;
            condition.sourceCode = profAnalcond.gf_pa_source_cust_package_id__c;
            condition.pkgInternationalScopeReview = profAnalcond.cuco__gf_psc_condition_id__r.cuco__gf_psc_ca_mf_iscp_pkg_ind_type__c;

            Boolean hasManualReview = false;
            if (profAnalcond.gf_psc_condition_id__r.gf_psc_ca_mf_iscp_pkg_ind_type__c == true) {
                hasManualReview = true;
            }

            if (hasManualReview) {
                condition.requiredManualReview = true;
            } else {
                condition.requiredManualReview = false;
            }

            if (getManualConditionType(mapCatalogCondition, profAnalcond).get('manual')) {
                condition.formMethod = 'Manual';
            } else if (getManualConditionType(mapCatalogCondition, profAnalcond).get('info')) {
                condition.formMethod = 'Informative';
            } else {
                condition.formMethod = 'Automatic';
            }

            condition.attributesList = getConditionAttributeList(profAnalcond, mapCatalogCondition);
            conditionList.add(condition);
        }
        return conditionList;
    }

    /**
    * @description return a string set
    * @param mapExtPkg : Map<String, Set<String>>
    * @return setStr : Set<String>
    */
    public static Set<String> getExtendLst (Map<String, Set<String>> mapExtPkg) {

        final Set<String> setStr = new Set<String>();
        for (String extPkgStr : mapExtPkg.keySet()) {
            for (String extPkgStrV : mapExtPkg.get(extPkgStr)) {
                setStr.add(extPkgStr + extPkgStrV);
            }
        }
        return setStr;
    }

    /**
    * @description Update the profitability analysis passed as parameter
    * @param lstPA: List of profitability analysis ready to update
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper updatePA (List<profitability_analysis__c> lstPA) {
        final List<String> errLstUpdatePA = new List<String>();
        final List<Database.SaveResult> srLstPA = Database.Update(lstPA, false);
        // Iterate through each returned result
        for (Database.SaveResult srPA : srLstPA) {
            if (!srPA.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPA : srPA.getErrors()) {
                    errLstUpdatePA.add(errInsPA.getMessage());
                    System.debug('Update profitability_analysis__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPA.getStatusCode() + ': ' + errInsPA.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstUpdatePA.isEmpty(), errLstUpdatePA);
    }

    /**
    * @description Returns User Id
    * @param genConfig : Metadata record with the general configuration of classes
    * @param userCode : Federation Id of the user
    * @return Id, with the user Id
    */
    public static List<PriceDecision_Wrapper> getPriceDecision(pa_general_configuration__mdt genConfig, List<String> decisionsIdsList, String currentStatus) {
        final Type permissionsClass = Type.forName(genConfig.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profitabiItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        return profitabiItf.getPriceDecisions(decisionsIdsList, currentStatus);
    }

    /**
    * @description Returns Arce date
    * @param genConfig : Metadata record with the general configuration of classes
    * @param recordId : Record Id of the user
    * @return Id, with the user Id
    */
    public static Date getARCEDate(pa_general_configuration__mdt genConfig, Id recordId) {
        final Type permissionsClass = Type.forName(genConfig.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profitabiItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        return profitabiItf.getARCEDate(recordId);
    }

    /**
    * @description Returns User Id
    * @param mapParameters : Map<String,Object>
    * @return success fi the price decision is save in bbdd
    */
    public static Map<String,Object> setPriceDecision(Map<String,Object> mapParameters) {
        final pa_general_configuration__mdt genConfig = (pa_general_configuration__mdt) mapParameters.get('genConfig');
        final Type permissionsClass = Type.forName(genConfig.cuco__prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profitabiItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
        return profitabiItf.setPriceDecision((ProfitabilityAnalysis_Wrapper) mapParameters.get('profAnalysis'), (String) mapParameters.get('decisionId'), (String) mapParameters.get('decisionComments'), (String) mapParameters.get('screenShot'));
    }
    /**
    * @description Returns response from setPADismissal method at ProfitabilityAnalysis_Itf
    * @param genConfig : Metadata record with the general configuration of classes
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param dismissalComments : Dismissal comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> setPADismissalProfAnalysis(pa_general_configuration__mdt genConfig, ProfitabilityAnalysis_Wrapper paWrapper, String dismissalComments, String screenShot) {
        final Type profAnalysisClass = Type.forName(genConfig.prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) profAnalysisClass.newInstance();
        return profAnalysisItf.setPADismissal(paWrapper, dismissalComments, screenShot);
    }

    /**
    * @description Returns response from setPARestudy method at ProfitabilityAnalysis_Itf
    * @param genConfig : Metadata record with the general configuration of classes
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param restudyComments : Restudy comments value from the form
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> setPARestudyProfAnalysis(pa_general_configuration__mdt genConfig, ProfitabilityAnalysis_Wrapper paWrapper, String restudyComments, String screenShot) {
        final Type profAnalysisClass = Type.forName(genConfig.prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) profAnalysisClass.newInstance();
        return profAnalysisItf.setPARestudy(paWrapper, restudyComments, screenShot);
    }

    /**
    * @description Returns response from setPADefaultRequestData method at ProfitabilityAnalysis_Itf
    * @param genConfig : Metadata record with the general configuration of classes
    * @param profAnalysis : Register of profitability_analysis__c object
    * @param psBranchCode : String with pa sheet branch code
    * @param psOwnerCode : String with pa sheet owner's code
    * @return profitability_analysis__c, with response
    */
    public static profitability_analysis__c setPADefaultRequestData(pa_general_configuration__mdt genConfig, profitability_analysis__c profAnalysis, String psBranchCode, String psOwnerCode) {
        final Type profAnalysisClass = Type.forName(genConfig.prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) profAnalysisClass.newInstance();
        return profAnalysisItf.setPADefaultRequestData(profAnalysis, psBranchCode, psOwnerCode);
    }

    /**
    * @description Returns response from setPAApprovePrice method at ProfitabilityAnalysis_Itf
    * @param genConfig : Metadata record with the general configuration of classes
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param dismissalComments : String with comments
    * @return Map<String, Object> map with the response
    */
    public static Map<String, Object> setPAApprovePrice(pa_general_configuration__mdt genConfig, ProfitabilityAnalysis_Wrapper paWrapper, String dismissalComments) {
        final Type profAnalysisClass = Type.forName(genConfig.prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) profAnalysisClass.newInstance();
        return profAnalysisItf.setPAApprovePrice(paWrapper, dismissalComments);
    }

    /**
    * @description Returns response from getFirstAndLastName method at ProfitabilityAnalysis_Itf
    * @param genConfig : Metadata record with the general configuration of classes
    * @param ownerId : Id of the User/Group
    * @return String, with FirstName and LastName concatenated
    */
    public static String getFirstAndLastName(pa_general_configuration__mdt genConfig, Id ownerId) {
        final Type profAnalysisClass = Type.forName(genConfig.prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) profAnalysisClass.newInstance();
        return profAnalysisItf.getFirstAndLastName(ownerId);
    }

    /**
    * @description Returns response from setPANotification method at ProfitabilityAnalysis_Itf
    * @param genConfig : Metadata record with the general configuration of classes
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @param notificationComents : String with notification comments value
    * @param screenShot : String with the html screenshot to audit detail records
    * @return Map<String, Object>, with response
    */
    public static Map<String, Object> setPANotificationProfAnalysis(pa_general_configuration__mdt genConfig, ProfitabilityAnalysis_Wrapper paWrapper, String notificationComents, String screenShot) {
        final Type profAnalysisClass = Type.forName(genConfig.prof_analysis_itf_name__c);
        final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) profAnalysisClass.newInstance();
        return profAnalysisItf.setPANotification(paWrapper, notificationComents, screenShot);
    }
}