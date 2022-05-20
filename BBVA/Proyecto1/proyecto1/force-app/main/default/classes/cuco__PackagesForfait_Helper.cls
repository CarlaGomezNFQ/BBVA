/**
* ────────────────────────────────────────────────────────────────────
* PackagesForfait_Helper
* Helper class for Packages_Service apex class to forfait packages
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-19
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class PackagesForfait_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PackagesForfait_Helper() {}

    /**
    * @description Helper method to get related detailed participants of param analysis Id
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @return List<Participant_Wrapper>, with the detailed participants
    */
    public static List<Participant_Wrapper> getRelatedParticipantsOfAnalysis(Id profAnalysisId) {
        final pa_general_configuration__mdt genConfig = Utils.getGeneralConfiguration();

        final PAParticipant_Selector papSelector = new PAParticipant_Selector(true);
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});

        final Set<Id> setPAPId = new Set<Id>();
        for (profitability_analysis_participant__c pap : lstPAP) {
            setPAPId.add(pap.participant_id__c);
        }

        final List<Participant_Wrapper> lstPW = Participants_Helper.getParticipantDetails(genConfig, setPAPId);
        return lstPW;
    }

    /**
    * @description Method to do the upsert of the prof analysis pkg req
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @param formParams: Map with filled form info
    * @return Map<String, Object>, with the result of the method
    */
    public static Map<String, Object> upsertProfAnalysisPkgReq(Id profAnalysisId, Map<String, Object> formParams, String mode) {
        Map<String, Object> retMap = new Map<String, Object>();

        // Get papr id
        PAParticipant_Selector papSelector = new PAParticipant_Selector();
        List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysisAndAcc(new Set<Id>{profAnalysisId}, new Set<Id>{(Id) formParams.get('accSelection')});

        profitability_analysis_pkg_request__c newForfaitPAPR = new profitability_analysis_pkg_request__c();
        if (mode == 'edit') {
            PAPackageRequest_Selector paprSelector = new PAPackageRequest_Selector(true);
            List<profitability_analysis_pkg_request__c> lstPAPR = paprSelector.selectPkgReqByPAPAndPkgAndReqType(new Set<Id>{lstPAP[0].Id}, new Set<Id>{(Id) formParams.get('pkgSelection')}, new Set<String>{'New'});
            newForfaitPAPR = lstPAPR[0];
        } else if (mode == 'add') {
            // Fields not writeables on upsert here
            newForfaitPAPR.gf_profitablity_analysis_id__c = profAnalysisId;
        }
        newForfaitPAPR.gf_pa_pkg_request_type_name__c = 'New';
        newForfaitPAPR.gf_psc_package_id__c = (Id) formParams.get('pkgSelection');
        newForfaitPAPR.participant_id__c = lstPAP[0].Id;
        newForfaitPAPR.gf_pa_pkg_charge_account_desc__c = (String) formParams.get('chargeAccount');
        newForfaitPAPR.gf_pa_pkg_fee_amount__c = Decimal.valueOf((String)formParams.get('chargeAmount'));
        newForfaitPAPR.gf_pa_pkg_charge_pdicy_type__c = (String) formParams.get('chargePeriodicity');
        newForfaitPAPR.gf_pa_pkg_cust_legal_rep_name__c = (String) formParams.get('clientRepName');
        newForfaitPAPR.gf_pa_pkg_cust_lglr_doc_id__c = (String) formParams.get('clientRepDoc');
        newForfaitPAPR.gf_pa_pkg_ent_legal_rep_name__c = (String) formParams.get('bankRepName');
        newForfaitPAPR.gf_pa_pkg_ent_lglr_doc_id__c = (String) formParams.get('bankRepDoc');
        newForfaitPAPR.gf_pa_pkg_cont_sign_loc_desc__c = (String) formParams.get('signingLocation');
        newForfaitPAPR.gf_pa_pkg_req_comments_desc__c = (String) formParams.get('comments');

        final Utils.DML_Wrapper retDMLUpsertForfaitPAPR = PAPackage_Service.upsertPAPR(new List<profitability_analysis_pkg_request__c>{newForfaitPAPR});
        retMap.put('isSuccess', retDMLUpsertForfaitPAPR.isSuccess);
        retMap.put('errMessage', retDMLUpsertForfaitPAPR.lstErrMessage);
        if (!retDMLUpsertForfaitPAPR.isSuccess) {
            retMap.put('toastType', 'error');
        }

        return retMap;
    }

    /**
    * @description Do checks to know if can show extended section on forfait edit form
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param pkgCatalogId : Id of the catalog pkg of the current forfait pkg
    * @return Boolean, with the result
    */
    public static Boolean doPreviousChecksExtendedPkg(Id profAnalysisId, Id pkgCatalogId) {
        Boolean showExtendedSection = false;

        // Get if pkg param is marked as extensible at catalog pkg
        final PsCatalogPackage_Selector psCatPkgSelector = new PsCatalogPackage_Selector(true);
        final List<ps_catalog_package__c> lstCatPkg = psCatPkgSelector.selectById(new Set<Id>{pkgCatalogId});

        // Get profitability analysis participants related to param prof analysis
        final PAParticipant_Selector papSelector = new PAParticipant_Selector();
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysis(new Set<Id>{profAnalysisId});
        // Get extended pkg of param prof analysis
        final Map<String, Set<String>> extendedPkgs = ProfitabilityAnalysis_Helper.getExtendedPkgOfProfAnalysis(profAnalysisId);

        // Checks
        if (lstCatPkg[0].gf_psc_extended_pkg_ind_type__c && lstPAP.size() > 1 && extendedPkgs.isEmpty()) {
            showExtendedSection = true;
        }
        return showExtendedSection;
    }

    /**
    * @description Do update with new values of edit record
    * @param packageWrapper : Package wrapper with the related package info
    * @param params: Map with rest of params to do logic
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> updateForfaitEditRecord(Package_Wrapper packageWrapper, Map<String, Object> params, Map<String, Object> formParams) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Id paprId = packageWrapper.editRequestId;

        final profitability_analysis_pkg_request__c currentPAPR = new profitability_analysis_pkg_request__c();
        if (paprId == null) {
            currentPAPR.gf_pa_pkg_request_type_name__c = 'Modification';
            currentPAPR.gf_psc_package_id__c = packageWrapper.catalogId;
            currentPAPR.gf_profitablity_analysis_id__c = (Id) params.get('profAnalysisId');
            currentPAPR.gf_cust_package_id__c = packageWrapper.clientPackageId;
            currentPAPR.participant_id__c = packageWrapper.participant.id;
        } else {
            currentPAPR.Id = paprId;
        }
        currentPAPR.gf_pa_pkg_fee_amount__c = Decimal.valueOf((String)formParams.get('chargeAmount'));
        currentPAPR.gf_pa_pkg_charge_pdicy_type__c = (String) formParams.get('chargePeriodicity');
        currentPAPR.gf_pa_pkg_cust_legal_rep_name__c = (String) formParams.get('clientRepName');
        currentPAPR.gf_pa_pkg_cust_lglr_doc_id__c = (String) formParams.get('clientRepDoc');
        currentPAPR.gf_pa_pkg_req_comments_desc__c = (String) formParams.get('comments');

        final Utils.DML_Wrapper retDMLUpsertPAPR = PAPackage_Service.upsertPAPR(new List<profitability_analysis_pkg_request__c>{currentPAPR});
        retMap.put('isSuccess', retDMLUpsertPAPR.isSuccess);
        retMap.put('errMessage', retDMLUpsertPAPR.lstErrMessage);
        return retMap;
    }
}