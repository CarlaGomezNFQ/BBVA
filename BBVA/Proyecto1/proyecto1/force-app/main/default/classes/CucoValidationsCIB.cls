/**
* ────────────────────────────────────────────────────────────────────
* PA_Validations_Controller_Sample
* Sample implementation of profitability analysis validations controller
* ────────────────────────────────────────────────────────────────────
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-06-10
* @modified
* @systemLayer Service
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class CucoValidationsCIB implements dwp_dbpn.DynamicFlowValidationInterface {

    /**
    * @description interfaz method implementation
    */
    global List<String> getErrorMessagesList(String recordId, String sObjectName, String source) {
        return checkButtonValidations(recordId, source);
    }

    /**
    * @description validate buttons
    */
    global static List<String> checkButtonValidations(String recordId, String sourceButtonId) {
        final List<String> retList = new List<String>();
        final cuco__pa_general_configuration__mdt genConfig = cuco.Utils.getGeneralConfiguration();
        final cuco.ProfitabilityAnalysis_Wrapper paWrapper = cuco.ProfitabilityAnalysis_Helper.getProfAnalysis(recordId);
        switch on sourceButtonId {
            when 'PA_Formalization_Sample' {
                retList.addAll(checkPAFormalization(paWrapper, genConfig));
            }
        }
        return retList;
    }

    /**
    * @description return check of prof analysis formalization sample
    */
    private static List<String> checkPAFormalization(cuco.ProfitabilityAnalysis_Wrapper paWrapper, cuco__pa_general_configuration__mdt genConfig) {
        final List<String> retList = new List<String>();
        retList.addAll(cuco.ValidationsProfAnalysis_Helper.checkBranch(paWrapper));
        retList.addAll(cuco.ValidationsProfAnalysis_Helper.checkMainParticipant(paWrapper));
        retList.addAll(cuco.ValidationsProfAnalysis_Helper.checkSegment(paWrapper, genConfig));
        retList.addAll(cuco.ValidationsProfAnalysis_Helper.checkParticipant(paWrapper, genConfig));
        if (retList.size() == 0) {
            final Map<String,Map<String,Map<String,String>>> condPerFamily = cuco.ValidationsCondGeneral_Helper.getConditionsPerFamily(paWrapper);
            retList.addAll(cuco.ValidationsProfAnalysis_Helper.checkRenewalMargin(paWrapper, genConfig));
            retList.addAll(cuco.ValidationsProfAnalysis_Helper.checkBackendLastDate(paWrapper));
            retList.addAll(cuco.ValidationsPrice_Helper.checkNegValidity(paWrapper, genConfig));
            retList.addAll(cuco.ValidationsPackages_Helper.checkNumExtendedPkgs(paWrapper));
            retList.addAll(cuco.ValidationsPackages_Helper.checkNumParticipants(paWrapper));
            retList.addAll(cuco.ValidationsPackages_Helper.checkExtendedPkgsStatus(paWrapper));
            retList.addAll(cuco.ValidationsFlat_Helper.checkMandatoryInfo(paWrapper));
            retList.addAll(cuco.ValidationsCondGeneral_Helper.checkValuesRange(paWrapper));
            retList.addAll(cuco.ValidationsCondGeneral_Helper.checkMailExpenses(paWrapper));
            retList.addAll(cuco.ValidationsCondGeneral_Helper.checkNPTransCond(condPerFamily));
            //retList.addAll(cuco.ValidationsCondGeneral_Helper.checkNPCheckCond(condPerFamily));
            retList.addAll(cuco.ValidationsCondGeneral_Helper.checkSEPAPriceClass(condPerFamily));
            retList.addAll(cuco.ValidationsCondGeneral_Helper.checkRate55Cond(condPerFamily));
            retList.addAll(cuco.ValidationsCondGeneral_Helper.checkRate(condPerFamily));
        }
        return retList;
    }

}