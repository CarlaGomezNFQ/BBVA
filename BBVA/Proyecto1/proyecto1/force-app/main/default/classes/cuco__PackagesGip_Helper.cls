/**
* ────────────────────────────────────────────────────────────────────
* PackagesGip_Helper
* Helper class for Packages_Service apex class to gip packages
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-01
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class PackagesGip_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PackagesGip_Helper() {}

    /**
    * @description Method to do the upsert of the prof analysis pkg req (gip type)
    * @param profAnalysisId : Id of the related Profitability Analysis
    * @param formParams: Map with filled form info
    * @return Map<String, Object>, with the result of the method
    */
    public static Map<String, Object> upsertProfAnalysisPkgReq(Id profAnalysisId, Map<String, Object> formParams, String mode) {
        final Map<String, Object> retMap = new Map<String, Object>();

        // Get papr id
        final PAParticipant_Selector papSelector = new PAParticipant_Selector();
        final List<profitability_analysis_participant__c> lstPAP = papSelector.selectByProfAnalysisAndAcc(new Set<Id>{profAnalysisId}, new Set<Id>{(Id) formParams.get('accSelection')});

        // Get ps catalog gip pkg id
        final PsCatalogPackage_Selector psCatalogPkgSel = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg = psCatalogPkgSel.selectByPkgTypeName(new Set<String>{'G'});

        profitability_analysis_pkg_request__c newGipPAPR = new profitability_analysis_pkg_request__c();
        if (mode == 'edit') {
            final PAPackageRequest_Selector paprSelector = new PAPackageRequest_Selector(true);
            final List<profitability_analysis_pkg_request__c> lstPAPR = paprSelector.selectPkgReqByPAPAndPkgAndReqType(new Set<Id>{lstPAP[0].Id}, new Set<Id>{(Id) formParams.get('pkgSelection')}, new Set<String>{'New'});
            newGipPAPR = lstPAPR[0];
        } else if (mode == 'add') {
            // Fields not writeables on upsert here
            newGipPAPR.gf_profitablity_analysis_id__c = profAnalysisId;
        }
        newGipPAPR.gf_pa_pkg_request_type_name__c = 'New';
        newGipPAPR.gf_psc_package_id__c = lstPsCatPkg[0].Id;
        newGipPAPR.participant_id__c = lstPAP[0].Id;
        newGipPAPR.gf_pa_package_desc__c = (String) formParams.get('pkgDescription');
        newGipPAPR.gf_pa_pkg_cust_legal_rep_name__c = (String) formParams.get('clientRepName');
        newGipPAPR.gf_pa_pkg_cust_lglr_doc_id__c = (String) formParams.get('clientRepDoc');
        newGipPAPR.gf_pa_pkg_ent_legal_rep_name__c = (String) formParams.get('bankRepName');
        newGipPAPR.gf_pa_pkg_ent_lglr_doc_id__c = (String) formParams.get('bankRepDoc');
        newGipPAPR.gf_pa_pkg_cont_sign_loc_desc__c = (String) formParams.get('signingLocation');
        newGipPAPR.gf_pa_pkg_req_comments_desc__c = (String) formParams.get('comments');

        final Utils.DML_Wrapper retDMLUpsertGipPAPR = PAPackage_Service.upsertPAPR(new List<profitability_analysis_pkg_request__c>{newGipPAPR});
        retMap.put('isSuccess', retDMLUpsertGipPAPR.isSuccess);
        retMap.put('errMessage', retDMLUpsertGipPAPR.lstErrMessage);
        if (!retDMLUpsertGipPAPR.isSuccess) {
            retMap.put('toastType', 'error');
        }

        return retMap;
    }

    /**
    * @description Do update with new values of edit record
    * @param packageWrapper : Package wrapper with the related package info
    * @param profAnalysisId : Id of the context profitability analysis record
    * @param formParams: Map with form values
    * @return Map<String, Object>, with the result of the checks
    */
    public static Map<String, Object> updateGipEditRecord(Package_Wrapper packageWrapper, Id profAnalysisId, Map<String, Object> formParams) {
        final Map<String, Object> retMap = new Map<String, Object>();
        final Savepoint savePoint = Database.setSavepoint();
        final Id paprId = packageWrapper.editRequestId;

        // Get ps catalog gip pkg id
        final PsCatalogPackage_Selector psCatalogPkgSel = new PsCatalogPackage_Selector();
        final List<ps_catalog_package__c> lstPsCatPkg = psCatalogPkgSel.selectByPkgTypeName(new Set<String>{'G'});

        final profitability_analysis_pkg_request__c currentGipPAPR = new profitability_analysis_pkg_request__c();
        if (paprId == null) {
            currentGipPAPR.gf_profitablity_analysis_id__c = profAnalysisId;
            currentGipPAPR.gf_pa_pkg_request_type_name__c = 'Modification';
            currentGipPAPR.gf_cust_package_id__c = packageWrapper.clientPackageId;
            currentGipPAPR.gf_psc_package_id__c = lstPsCatPkg[0].Id;
            currentGipPAPR.participant_id__c = packageWrapper.participant.id;
            currentGipPAPR.gf_pa_package_desc__c = (String) formParams.get('pkgDescription');
        } else {
            currentGipPAPR.Id = paprId;
        }
        currentGipPAPR.gf_pa_pkg_cust_legal_rep_name__c = (String) formParams.get('clientRepName');
        currentGipPAPR.gf_pa_pkg_cust_lglr_doc_id__c = (String) formParams.get('clientRepDoc');
        currentGipPAPR.gf_pa_pkg_req_comments_desc__c = (String) formParams.get('comments');

        final Utils.DML_Wrapper retDMLUpsertGipPAPR = PAPackage_Service.upsertPAPR(new List<profitability_analysis_pkg_request__c>{currentGipPAPR});
        if (retDMLUpsertGipPAPR.isSuccess) {
            retMap.put('isSuccess', true);
        } else {
            retMap.put('isSuccess', false);
            retMap.put('errMessage', Label.gip_pkg_edit_error + ': ' + retDMLUpsertGipPAPR.lstErrMessage);
            retMap.put('toastType', 'error');
            Database.rollback(savePoint);
        }
        return retMap;
    }
}