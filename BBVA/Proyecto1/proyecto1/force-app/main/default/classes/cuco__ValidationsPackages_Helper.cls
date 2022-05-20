/**
* ────────────────────────────────────────────────────────────────────
* ValidationsPackages_Helper
* Helper class for PA_Validation_Service apex class
* ────────────────────────────────────────────────────────────────────
* @author      Fco Javier Berenguer <franciscojavier.berenguer.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-17
* @modified
* @systemLayer Service
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ValidationsPackages_Helper {

    /**
    * @description Private constructor to avoid sonar err
    */
    @TestVisible
    private ValidationsPackages_Helper() {}

    /**
    * @description Method to check if number of installed packages is valid
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @return List<String>, with response
    */
    global static List<String> checkNumExtendedPkgs(ProfitabilityAnalysis_Wrapper paWrapper) {
        final List<String> retList = new List<String>();
        if (paWrapper.packages != null && paWrapper.packages.extendedPackages != null
            && paWrapper.packages.extendedPackages.size() > 1) {
            retList.add(Label.error_num_extended_pkgs);
        }
        return retList;
    }

    /**
    * @description Method to check if number of participants is valid
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @return List<String>, with response
    */
    global static List<String> checkNumParticipants(ProfitabilityAnalysis_Wrapper paWrapper) {
        final List<String> retList = new List<String>();
        if (paWrapper.packages != null && paWrapper.packages.extendedPackages != null && paWrapper.participantsList != null && paWrapper.packages.extendedPackages.size() > 0 && paWrapper.participantsList.size() == 1) {
            retList.add(Label.error_num_participants_pkgs);
        }
        return retList;
    }

    /**
    * @description Method to check if extended package status are valid
    * @param paWrapper : ProfitabilityAnalysis_Wrapper with the prof analysis info
    * @return List<String>, with response
    */
    global static List<String> checkExtendedPkgsStatus(ProfitabilityAnalysis_Wrapper paWrapper) {
        final List<String> retList = new List<String>();
        if (paWrapper.packages != null && paWrapper.packages.commPackageList != null) {
            for (Package_Wrapper packWrapper : paWrapper.packages.commPackageList) {
                if (packWrapper.isExtended && packWrapper.status != null && packWrapper.status.id != 'Valid') {
                    retList.add(Label.error_extended_pkg_status + ': ' + packWrapper.type + packWrapper.code);
                }
            }
        }

        if (paWrapper.packages != null && paWrapper.packages.forfaitPackageList != null) {
            for (Package_Wrapper packWrapper : paWrapper.packages.forfaitPackageList) {
                if (packWrapper.isExtended && packWrapper.status != null && packWrapper.status.id != 'Valid') {
                    retList.add(Label.error_extended_pkg_status + ': ' + packWrapper.type + packWrapper.code);
                }
            }
        }
        return retList;
    }
}