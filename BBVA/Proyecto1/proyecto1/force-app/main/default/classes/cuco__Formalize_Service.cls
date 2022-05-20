/**
* ────────────────────────────────────────────────────────────────────
* Formalize_Service
* Service class for formalization implementation apex classes
* ────────────────────────────────────────────────────────────────────
* @author      Oscar Gomez <oscar.gomez.arqueros.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-09
* @modified
* @systemLayer Business Logic
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public class Formalize_Service {

  /**
  * @description Private constructor to avoid sonar err
  */
  @TestVisible
  private Formalize_Service() {}

  /**
  * @description Check if user can formalize
  * @param profAnalysis: ProfitabilityAnalysis_Wrapper with profitability analysis info
  * @return Map<String, Object> with the response
  */
  public static Map<String, Object> formalize(String profAnalysisId) {
    final Map<String,Object> returnMap = new Map<String,Object>();

    /* get general configuration */
    final cuco__pa_general_configuration__mdt cmt = Utils.getGeneralConfiguration();

    final Type permissionsClass = Type.forName(cmt.cuco__prof_analysis_itf_name__c);
    final ProfitabilityAnalysis_Itf profAnalysisItf = (ProfitabilityAnalysis_Itf) permissionsClass.newInstance();
    Boolean isActivePrice = false;

    if(cmt.price_approval_type__c == true) {
        isActivePrice = true;
    }

    /* create wrapper of pa and get main info */
    final Date arceDate = profAnalysisItf.getARCEDate(profAnalysisId);
    final ProfitabilityAnalysis_Wrapper profAnalysis = ProfitabilityAnalysis_Helper.getProfAnalysis(profAnalysisId);
    final String formType = Formalization_Helper.getFormType(profAnalysis);
    final DateTime endDate = profAnalysis.endDate;
    final DateTime originStartDate = profAnalysis.originStartDate;
    final DateTime originEndDate = profAnalysis.originEndDate;
    final DateTime startDate = profAnalysis.startDate;

    returnMap.put('isActivePrice', isActivePrice);
    returnMap.put('typology', profAnalysis.typology);
    returnMap.put('formType', formType);
    returnMap.put('originEndDate', originEndDate);
    returnMap.put('originStartDate', originStartDate);
    returnMap.put('endDate', endDate);
    returnMap.put('arceDate', arceDate);
    returnMap.put('profAnalysisStatus', profAnalysis.status);
    returnMap.put('profAnalysisStartDate', startDate);

    return returnMap;
  }
}