/**
* ────────────────────────────────────────────────────────────────────
* PAPackage_Helper
* Helper class for PAPackage_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-10
* @modified
* @systemLayer Any
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled')
public class PAPackage_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private PAPackage_Helper() {}

    /**
    * @description Upsert the Profitability Analysis Condition records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Condition records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertExtendedPkg(List<profitability_analysis_condition__c> lstPAC) {
        final List<String> errLstUpsertPAC = new List<String>();
        final List<Database.UpsertResult> urLstPAC = Database.upsert(lstPAC, false);
        // Iterate through each returned result
        for (Database.UpsertResult urPAC : urLstPAC) {
            if (!urPAC.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errUpsertPAC : urPAC.getErrors()) {
                    errLstUpsertPAC.add(errUpsertPAC.getMessage());
                    System.debug('Upsert profitability_analysis_condition__c ERROR: ' + userInfo.getUserName() + ', ' + errUpsertPAC.getStatusCode() + ': ' + errUpsertPAC.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstUpsertPAC.isEmpty(), errLstUpsertPAC);
    }

    /**
    * @description Delete the Profitability Analysis Condition records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Condition records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deleteExtendedPkg(List<profitability_analysis_condition__c> lstPAC) {
        final List<String> errLstDeletePAC = new List<String>();
        final List<Database.DeleteResult> drLstPAC = Database.delete(lstPAC, false);
        // Iterate through each returned result
        for (Database.DeleteResult drPAC : drLstPAC) {
            if (!drPAC.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errDelPAC : drPAC.getErrors()) {
                    errLstDeletePAC.add(errDelPAC.getMessage());
                    System.debug('Delete profitability_analysis_condition__c ERROR: ' + userInfo.getUserName() + ', ' + errDelPAC.getStatusCode() + ': ' + errDelPAC.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstDeletePAC.isEmpty(), errLstDeletePAC);
    }

    /**
    * @description Insert the profitability analysis participants passed as parameters
    * @param lstPAP: List of profitability analysis participants ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAP(List<profitability_analysis_participant__c> lstPAP) {
        final List<String> errLstInsertPAP = new List<String>();
        final List<Database.SaveResult> srLstPAP = Database.insert(lstPAP, false);
        // Iterate through each returned result
        for (Database.SaveResult srPAP : srLstPAP) {
            if (!srPAP.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPAP : srPAP.getErrors()) {
                    errLstInsertPAP.add(errInsPAP.getMessage());
                    System.debug('Insert profitability_analysis_participant__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPAP.getStatusCode() + ': ' + errInsPAP.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsertPAP.isEmpty(), errLstInsertPAP);
    }

    /**
    * @description Delete the Profitability Analysis Participant records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Participant records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAP(List<profitability_analysis_participant__c> lstPAP) {
        final List<String> errLstDeletePAP = new List<String>();
        final List<Database.DeleteResult> drLstPAP = Database.delete(lstPAP, false);
        // Iterate through each returned result
        for (Database.DeleteResult drPAP : drLstPAP) {
            if (!drPAP.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errDelPAP : drPAP.getErrors()) {
                    errLstDeletePAP.add(errDelPAP.getMessage());
                    System.debug('Delete profitability_analysis_participant__c ERROR: ' + userInfo.getUserName() + ', ' + errDelPAP.getStatusCode() + ': ' + errDelPAP.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstDeletePAP.isEmpty(), errLstDeletePAP);
    }

    /**
    * @description Insert the Profitability Analysis Package Request records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Package Request records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAPR(List<profitability_analysis_pkg_request__c> lstPAPR) {
        final List<String> errLstInsertPAPR = new List<String>();
        final List<Database.SaveResult> srLstPAPR = Database.insert(lstPAPR, false);
        // Iterate through each returned result
        for (Database.SaveResult srPAPR : srLstPAPR) {
            if (!srPAPR.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPAPR : srPAPR.getErrors()) {
                    errLstInsertPAPR.add(errInsPAPR.getMessage());
                    System.debug('Insert profitability_analysis_pkg_request__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPAPR.getStatusCode() + ': ' + errInsPAPR.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsertPAPR.isEmpty(), errLstInsertPAPR);
    }

    /**
    * @description Delete the Profitability Analysis Package Request records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Package Request records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAPR(List<profitability_analysis_pkg_request__c> lstPAPR) {
        final List<String> errLstDeletePAPR = new List<String>();
        final List<Database.DeleteResult> drLstPAPR = Database.delete(lstPAPR, false);
        // Iterate through each returned result
        for (Database.DeleteResult drPAPR : drLstPAPR) {
            if (!drPAPR.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errDelPAPR : drPAPR.getErrors()) {
                    errLstDeletePAPR.add(errDelPAPR.getMessage());
                    System.debug('Delete profitability_analysis_pkg_request__c ERROR: ' + userInfo.getUserName() + ', ' + errDelPAPR.getStatusCode() + ': ' + errDelPAPR.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstDeletePAPR.isEmpty(), errLstDeletePAPR);
    }

    /**
    * @description Insert the Profitability Analysis records passed as parameters
    * @param lstPA: List of Profitability Analysis records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPA(List<profitability_analysis__c> lstPA) {
        final List<String> errLstInsertPA = new List<String>();
        final List<Database.SaveResult> srLstPA = Database.insert(lstPA, false);
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
    * @description Insert the Profitability Analysis Condition records passed as parameters
    * @param lstPA: List of Profitability Analysis Condition records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAC(List<profitability_analysis_condition__c> lstPAC) {
        final List<String> errLstInsertPAC = new List<String>();
        final List<Database.SaveResult> srLstPAC = Database.insert(lstPAC, false);
        // Iterate through each returned result
        for (Database.SaveResult srPAC : srLstPAC) {
            if (!srPAC.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPAC : srPAC.getErrors()) {
                    errLstInsertPAC.add(errInsPAC.getMessage());
                    System.debug('Insert profitability_analysis_condition__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPAC.getStatusCode() + ': ' + errInsPAC.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsertPAC.isEmpty(), errLstInsertPAC);
    }

    /**
    * @description Upsert the Profitability Analysis Package Request records passed as parameters
    * @param lstCatPkg: List of Profitability Analysis Package Request records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAPR(List<profitability_analysis_pkg_request__c> lstPAPR) {
        final List<String> errLstUpsertPAPR = new List<String>();
        final List<Database.UpsertResult> urLstPAPR = Database.upsert(lstPAPR, false);
        // Iterate through each returned result
        for (Database.UpsertResult urPAPR : urLstPAPR) {
            if (!urPAPR.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errUpsPAPR : urPAPR.getErrors()) {
                    errLstUpsertPAPR.add(errUpsPAPR.getMessage());
                    System.debug('Upsert profitability_analysis_pkg_request__c ERROR: ' + userInfo.getUserName() + ', ' + errUpsPAPR.getStatusCode() + ': ' + errUpsPAPR.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstUpsertPAPR.isEmpty(), errLstUpsertPAPR);
    }

    /**
    * @description Insert the profitability analysis flat rates records passed as parameters
    * @param lstPAFlat: List of profitability analysis flat rates records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAFlatRates(List<profitability_analysis_flat_rates__c> lstPAFlat) {
        final List<String> errLstInsPAFlat = new List<String>();
        final List<Database.SaveResult> srLstPAFlat = Database.insert(lstPAFlat, false);
        // Iterate through each returned result
        for (Database.SaveResult srPAFlat : srLstPAFlat) {
            if (!srPAFlat.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPAFlat : srPAFlat.getErrors()) {
                    errLstInsPAFlat.add(errInsPAFlat.getMessage());
                    System.debug('Insert profitability_analysis_flat_rates__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPAFlat.getStatusCode() + ': ' + errInsPAFlat.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsPAFlat.isEmpty(), errLstInsPAFlat);
    }

    /**
    * @description Upsert the profitability analysis flat rates records passed as parameters
    * @param lstPAFlat: List of profitability analysis flat rates records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAFlatRates(List<profitability_analysis_flat_rates__c> lstPAFlat) {
        final List<String> errLstUpsertPAFlat = new List<String>();
        final List<Database.UpsertResult> urLstPAFlat = Database.upsert(lstPAFlat, false);
        // Iterate through each returned result
        for (Database.UpsertResult urPAFlat : urLstPAFlat) {
            if (!urPAFlat.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errUpsPAFlat : urPAFlat.getErrors()) {
                    errLstUpsertPAFlat.add(errUpsPAFlat.getMessage());
                    System.debug('Upsert profitability_analysis_flat_rates__c ERROR: ' + userInfo.getUserName() + ', ' + errUpsPAFlat.getStatusCode() + ': ' + errUpsPAFlat.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstUpsertPAFlat.isEmpty(), errLstUpsertPAFlat);
    }

    /**
    * @description Insert the profitability analysis flat rates account records passed as parameters
    * @param lstPAFlatAcc: List of profitability analysis flat rates account records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAFlatAcc(List<profitability_analysis_flatrates_account__c> lstPAFlatAcc) {
        final List<String> errLstInsPAAcc = new List<String>();
        final List<Database.SaveResult> srLstPAFlatAcc = Database.insert(lstPAFlatAcc, false);
        // Iterate through each returned result
        for (Database.SaveResult srPAFlatAcc : srLstPAFlatAcc) {
            if (!srPAFlatAcc.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPAFlatAcc : srPAFlatAcc.getErrors()) {
                    errLstInsPAAcc.add(errInsPAFlatAcc.getMessage());
                    System.debug('Insert profitability_analysis_flatrates_account__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPAFlatAcc.getStatusCode() + ': ' + errInsPAFlatAcc.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsPAAcc.isEmpty(), errLstInsPAAcc);
    }

    /**
    * @description Upsert the profitability analysis flat rates account records passed as parameters
    * @param lstPAFlatAcc: List of profitability analysis flat rates account records ready to upsert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAFlatAcc(List<profitability_analysis_flatrates_account__c> lstPAFlatAcc) {
        final List<String> errLstUpsertPAFlatAcc = new List<String>();
        final List<Database.UpsertResult> urLstPAFlatAcc = Database.upsert(lstPAFlatAcc, false);
        // Iterate through each returned result
        for (Database.UpsertResult urPAFlatAcc : urLstPAFlatAcc) {
            if (!urPAFlatAcc.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errUpsPAFlatAcc : urPAFlatAcc.getErrors()) {
                    errLstUpsertPAFlatAcc.add(errUpsPAFlatAcc.getMessage());
                    System.debug('Upsert profitability_analysis_flatrates_account__c ERROR: ' + userInfo.getUserName() + ', ' + errUpsPAFlatAcc.getStatusCode() + ': ' + errUpsPAFlatAcc.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstUpsertPAFlatAcc.isEmpty(), errLstUpsertPAFlatAcc);
    }

    /**
    * @description Delete the profitability analysis flat rates account records passed as parameters
    * @param lstPAFlatAcc: List of profitability analysis flat rates account records ready to delete
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAFlatAcc(List<profitability_analysis_flatrates_account__c> lstPAFlatAcc) {
        final List<String> errLstDeletePAFlatAcc = new List<String>();
        final List<Database.DeleteResult> urLstPAFlatAcc = Database.delete(lstPAFlatAcc, false);
        // Iterate through each returned result
        for (Database.DeleteResult delPAFlatAcc : urLstPAFlatAcc) {
            if (!delPAFlatAcc.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errDelPAFlatAcc : delPAFlatAcc.getErrors()) {
                    errLstDeletePAFlatAcc.add(errDelPAFlatAcc.getMessage());
                    System.debug('Delete profitability_analysis_flatrates_account__c ERROR: ' + userInfo.getUserName() + ', ' + errDelPAFlatAcc.getStatusCode() + ': ' + errDelPAFlatAcc.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstDeletePAFlatAcc.isEmpty(), errLstDeletePAFlatAcc);
    }

    /**
    * @description Insert the profitability analysis flat rates DP records passed as parameters
    * @param lstPAFlatDP: List of profitability analysis flat rates DP records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper insertPAFlatDP(List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP) {
        final List<String> errLstInsPADP = new List<String>();
        final List<Database.SaveResult> srLstPAFlatDP = Database.insert(lstPAFlatDP, false);
        // Iterate through each returned result
        for (Database.SaveResult srPAFlatDP : srLstPAFlatDP) {
            if (!srPAFlatDP.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errInsPAFlatDP : srPAFlatDP.getErrors()) {
                    errLstInsPADP.add(errInsPAFlatDP.getMessage());
                    System.debug('Insert profitability_analysis_flat_rates__c ERROR: ' + userInfo.getUserName() + ', ' + errInsPAFlatDP.getStatusCode() + ': ' + errInsPAFlatDP.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstInsPADP.isEmpty(), errLstInsPADP);
    }

    /**
    * @description Upsert the profitability analysis flat rates DP records passed as parameters
    * @param lstPAFlatDP: List of profitability analysis flat rates DP records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper upsertPAFlatDP(List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP) {
        final List<String> errLstUpsPADP = new List<String>();
        final List<Database.UpsertResult> srLstPAFlatDP = Database.upsert(lstPAFlatDP, false);
        // Iterate through each returned result
        for (Database.UpsertResult srPAFlatDP : srLstPAFlatDP) {
            if (!srPAFlatDP.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errUpsPAFlatDP : srPAFlatDP.getErrors()) {
                    errLstUpsPADP.add(errUpsPAFlatDP.getMessage());
                    System.debug('Upsert profitability_analysis_flat_rates__c ERROR: ' + userInfo.getUserName() + ', ' + errUpsPAFlatDP.getStatusCode() + ': ' + errUpsPAFlatDP.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstUpsPADP.isEmpty(), errLstUpsPADP);
    }

    /**
    * @description Upsert the profitability analysis flat rates DP records passed as parameters
    * @param lstPAFlatDP: List of profitability analysis flat rates DP records ready to insert
    * @return Utils.DML_Wrapper, with the response of the DML operation
    */
    public static Utils.DML_Wrapper deletePAFlatDP(List<profitability_analysis_flat_rates_dp__c> lstPAFlatDP) {
        final List<String> errLstDelPADP = new List<String>();
        final List<Database.DeleteResult> srLstPAFlatDP = Database.delete(lstPAFlatDP, false);
        // Iterate through each returned result
        for (Database.DeleteResult srPAFlatDP : srLstPAFlatDP) {
            if (!srPAFlatDP.isSuccess()) {
                // Operation failed, so get all errors
                for (Database.Error errDelPAFlatDP : srPAFlatDP.getErrors()) {
                    errLstDelPADP.add(errDelPAFlatDP.getMessage());
                    System.debug('Upsert profitability_analysis_flat_rates__c ERROR: ' + userInfo.getUserName() + ', ' + errDelPAFlatDP.getStatusCode() + ': ' + errDelPAFlatDP.getMessage());
                }
            }
        }
        return new Utils.DML_Wrapper(errLstDelPADP.isEmpty(), errLstDelPADP);
    }
}