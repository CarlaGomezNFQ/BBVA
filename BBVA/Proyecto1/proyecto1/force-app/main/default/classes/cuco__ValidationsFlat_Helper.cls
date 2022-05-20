/**
* ────────────────────────────────────────────────────────────────────
* ValidationsFlat_Helper
* Helper class for ValidationsFlat_Helper
* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-18
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global class ValidationsFlat_Helper {

    /**
    * @description Private constructor to avoid sonar error
    */
    @TestVisible
    private ValidationsFlat_Helper() {}

    /**
    * @description check validations for flats
    * @param profAnalysis : ProfitabilityAnalysis_Wrapper
    * @return List<String> with info for passing to the next step
    */
    global static List<String> checkMandatoryInfo(ProfitabilityAnalysis_Wrapper paWrapper) {
        final List<String> retMndInfList = new List<String>();
        if (paWrapper.flatRate != null && paWrapper.flatRate.requestType != 'Cancellation') {
            final Set<String> setMandAtt = new Set<String> {
                'comflat.amount.type',
                'comflat.payment.type',
                'comflat.charge.periodicity',
                'comflat.currency',
                'comflat.payment.date',
                'comflat.nonbusiness.payday.procedure',
                'comflat.account.unavailable.procedure',
                'comflat.comments'
            };
            final Set<String> setPaFRAtt = new Set<String>();
            for (ProfitabilityAnalysis_Wrapper.Attribute paAtt : paWrapper.flatRate.flatRatesInfoAttList) {
                setPaFRAtt.add(paAtt.canonicalId);
                checkAmountAtt(paAtt, setMandAtt);
            }
            for (String key : setMandAtt) {
                if (!setPaFRAtt.contains(key)) {
                    retMndInfList.add(Label.error_flat_mandatory_data);
                    break;
                }
            }
            if (retMndInfList.isEmpty()
                && (paWrapper.flatRate.flatRateAccountsList == null || paWrapper.flatRate.flatRateAccountsList.isEmpty())) {
                    retMndInfList.add(Label.error_flat_mandatory_data);
            }
        }
        return retMndInfList;
    }

    /**
    * @description Auxiliar method to add mandatory attributes
    */
    private static void checkAmountAtt(ProfitabilityAnalysis_Wrapper.Attribute paAtt, Set<String> setMandAtt) {
        if (paAtt.canonicalId == 'comflat.amount.type') {
            switch on paAtt.valueId {
                when 'IF' {
                    setMandAtt.add('comflat.fixed.amount');
                }
                when 'EF' {
                    setMandAtt.add('comflat.variable.amount');
                }
            }
        }
    }
}