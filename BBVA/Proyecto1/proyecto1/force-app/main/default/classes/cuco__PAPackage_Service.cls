/**
* ────────────────────────────────────────────────────────────────────
* PAPackage_Service
* Service class for Profitability Analysis Package functionality
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-10
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class PAPackage_Service {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PAPackage_Service() {}

    /**
    * @description Upsert the Profitability Analysis Condition records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Condition records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertExtendedPkg(List<profitability_analysis_condition__c> lstPAC) {
        return PAPackage_Helper.upsertExtendedPkg(lstPAC);
    }

    /**
    * @description Delete the Profitability Analysis Condition records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Condition records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deleteExtendedPkg(List<profitability_analysis_condition__c> lstPAC) {
        return PAPackage_Helper.deleteExtendedPkg(lstPAC);
    }

    /**
    * @description Insert the profitability analysis participants passed as parameters
    * @param lstPAP: List of profitability analysis participants ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAP(List<profitability_analysis_participant__c> lstPAP) {
        return PAPackage_Helper.insertPAP(lstPAP);
    }

    /**
    * @description Delete the Profitability Analysis Participant records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Participant records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAP(List<profitability_analysis_participant__c> lstPAP) {
        return PAPackage_Helper.deletePAP(lstPAP);
    }

    /**
    * @description Insert the Profitability Analysis Package Request records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Package Request records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAPR(List<profitability_analysis_pkg_request__c> lstPAPR) {
        return PAPackage_Helper.insertPAPR(lstPAPR);
    }

    /**
    * @description Delete the Profitability Analysis Package Request records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Package Request records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAPR(List<profitability_analysis_pkg_request__c> lstPAPR) {
        return PAPackage_Helper.deletePAPR(lstPAPR);
    }

    /**
    * @description Upsert the Profitability Analysis records passed as parameters
    * @param lstPA: List of Profitability Analysis records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPA(List<profitability_analysis__c> lstPA) {
        return PAPackage_Helper.insertPA(lstPA);
    }

    /**
    * @description Upsert the Profitability Analysis Condition records passed as parameters
    * @param lstPA: List of Profitability Analysis condition records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAC(List<profitability_analysis_condition__c> lstPAC) {
        return PAPackage_Helper.insertPAC(lstPAC);
    }

    /**
    * @description Upsert the Profitability Analysis Package Request records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Package Request records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAPR(List<profitability_analysis_pkg_request__c> lstPAPR) {
        return PAPackage_Helper.upsertPAPR(lstPAPR);
    }

    /**
    * @description Insert the profitability analysis flat rates records passed as parameters
    * @param lstPAFlat: List of profitability analysis flat rates records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAFlatRates(List<profitability_analysis_flat_rates__c> lstPAFlat) {
        return PAPackage_Helper.insertPAFlatRates(lstPAFlat);
    }

    /**
    * @description Upsert the profitability analysis flat rates records passed as parameters
    * @param lstPAFlat: List of profitability analysis flat rates records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAFlatRates(List<profitability_analysis_flat_rates__c> lstPAFlat) {
        return PAPackage_Helper.upsertPAFlatRates(lstPAFlat);
    }

    /**
    * @description Insert the profitability analysis flat rates account records passed as parameters
    * @param lstPAFlatAcc: List of profitability analysis flat rates account records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAFlatAcc(List<profitability_analysis_flatrates_account__c> lstPAFlatAcc) {
        return PAPackage_Helper.insertPAFlatAcc(lstPAFlatAcc);
    }

    /**
    * @description Upsert the profitability analysis flat rates account records passed as parameters
    * @param lstPAFlatAcc: List of profitability analysis flat rates account records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAFlatAcc(List<profitability_analysis_flatrates_account__c> lstPAFlatAcc) {
        return PAPackage_Helper.upsertPAFlatAcc(lstPAFlatAcc);
    }

    /**
    * @description Delete the profitability analysis flat rates account records passed as parameters
    * @param lstPAFlatAcc: List of profitability analysis flat rates account records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAFlatAcc(List<profitability_analysis_flatrates_account__c> lstPAFlatAcc) {
        return PAPackage_Helper.deletePAFlatAcc(lstPAFlatAcc);
    }

    /**
    * @description Insert the profitability analysis flat rates DP records passed as parameters
    * @param lstPAFlatDP: List of profitability analysis flat rates DP records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAFlatDP(List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP) {
        return PAPackage_Helper.insertPAFlatDP(lstPAFlatDP);
    }

    /**
    * @description Upsert the profitability analysis flat rates DP records passed as parameters
    * @param lstPAFlatDP: List of profitability analysis flat rates DP records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAFlatDP(List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP) {
        return PAPackage_Helper.upsertPAFlatDP(lstPAFlatDP);
    }

    /**
    * @description Delete the profitability analysis flat rates DP records passed as parameters
    * @param lstPAFlatDP: List of profitability analysis flat rates DP records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAFlatDP(List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP) {
        return PAPackage_Helper.deletePAFlatDP(lstPAFlatDP);
    }
}