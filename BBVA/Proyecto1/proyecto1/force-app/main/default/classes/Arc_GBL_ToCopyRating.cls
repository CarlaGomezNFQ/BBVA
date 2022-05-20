/**
* --------------------------------------------------------------------------------------------------------
* @Name     Arc_GBL_ToCopyRating
* @Author   Antonio Muñoz Pérez  antonio.munoz.perez.contractor@bbva.com
* @Date     Created: 2020-12-16
* @Group    ARCE
* --------------------------------------------------------------------------------------------------------
* @Description  GBL class that implements Arc_Gen_ToCopyRating_Interface
* --------------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-12-16 antonio.munoz.perez.contractor@bbva.com
*             Class creation.
* --------------------------------------------------------------------------------------------------------
*/
public With Sharing class Arc_GBL_ToCopyRating implements Arc_Gen_ToCopyRating_Interface {
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Method that returns the arce__Account_has_Analysis__c you want to update
    * ----------------------------------------------------------------------------------------------------
    * @Author   antonio.munoz.perez.contractor@bbva.com
    * @Date     2020-12-16
    * @param ahaLst - List<Arc_Gen_Account_Has_Analysis_Wrapper> all aha of the analysis
    * @param idRecord - current aha.ID
    * @example getMatrix (ahaLst, idRecord)
    * ----------------------------------------------------------------------------------------------------
    **/
    public arce__Account_has_Analysis__c getMatrix (List<arce.Arc_Gen_Account_Has_Analysis_Wrapper> ahaLst, ID idRecord) {
        arce__Account_has_Analysis__c matrix = new arce__Account_has_Analysis__c();
        for (arce.Arc_Gen_Account_Has_Analysis_Wrapper aha : ahaLst) {
            if (aha.ahaObj.arce__main_subsidiary_ind_type__c
                && aha.ahaObj.Id == idRecord
                && aha.ahaObj.arce__InReview__c == false
                && aha.ahaObj.arce__anlys_wkfl_cnsld_ffss_type__c == '2') {
                    matrix = aha.ahaObj;
                }
        }
        return matrix;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Method that returns the arce__Account_has_Analysis__c which qualitative questions you want to copy
    * ----------------------------------------------------------------------------------------------------
    * @Author   antonio.munoz.perez.contractor@bbva.com
    * @Date     2020-12-16
    * @param ahaLst - List<arce.Arc_Gen_Account_Has_Analysis_Wrapper> all aha of the analysis
    * @param idRecord - current aha.ID
    * @example getHeader (ahaLst, idRecord)
    * ----------------------------------------------------------------------------------------------------
    **/
    public arce__Account_has_Analysis__c getHeader (List<arce.Arc_Gen_Account_Has_Analysis_Wrapper> ahaLst, ID idRecord) {
        arce__Account_has_Analysis__c header = new arce__Account_has_Analysis__c();
        for (arce.Arc_Gen_Account_Has_Analysis_Wrapper aha : ahaLst) {
            if (aha.ahaObj.arce__group_asset_header_type__c == '1') {
                header = aha.ahaObj;
            }
        }
        return header;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Method to validate the analysis data to copy.
    * ----------------------------------------------------------------------------------------------------
    * @Author   antonio.munoz.perez.contractor@bbva.com
    * @Date     2020-12-16
    * @param matrix - Account has analysis object
    * @param header - Account has analysis object
    * @example doCopy(matrix, header)
    * ----------------------------------------------------------------------------------------------------
    **/
    public Boolean doCopy (arce__Account_has_Analysis__c matrix, arce__Account_has_Analysis__c header) {
        Boolean response = false;
        final List<arce__Account_has_Analysis__c> rtData = arce.Arc_Gen_AccHasAnalysis_Data.getRatingStatus(new List<ID>{header.ID});
        if (matrix != null
            && rtData[0] != null
            && (rtData[0].arce__ffss_for_rating_id__r.arce__rating_id__r.arce__status_type__c == '2'
                || rtData[0].arce__ffss_for_rating_id__r.arce__rating_id__r.arce__status_type__c == '3')) {
                    response = true;
                }
        return response;
    }
    /**
    * ----------------------------------------------------------------------------------------------------
    * @Description Method to update de matrix qualitative questions with the values of the header
    * ----------------------------------------------------------------------------------------------------
    * @Author   antonio.munoz.perez.contractor@bbva.com
    * @Date     2020-12-16
    * @param matrix - Account has analysis object
    * @param header - Account has analysis object
    * @example updateRating(matrix, header)
    * ----------------------------------------------------------------------------------------------------
    **/
    public static arce.Arc_Gen_ServiceAndSaveResponse updateRating(arce__Account_has_Analysis__c matrix, arce__Account_has_Analysis__c header) {
        final arce.Arc_Gen_ServiceAndSaveResponse servSaveResp = new arce.Arc_Gen_ServiceAndSaveResponse();
        servSaveResp.updatefields = new Map<String,Object>();
        final Set <String> qualQues = new Set <String> ();
        final Set <String> valToRemov = new Set <String> ();
        for (dyfr__Field_Config__c fCng :[select dyfr__Map_field__c, dyfr__Tab__r.dyfr__Tab_Code__c	 from dyfr__Field_Config__c
                                          where Arc_Gen_QualitativeQuestions__c = true]) {
                qualQues.add(fCng.dyfr__Map_field__c);
        }
        if (!qualQues.isEmpty()) {
            for (String qualQ : qualQues) {
                if (String.isBlank(qualQ) || qualQ.contains('__r.')) {
                    valToRemov.add(qualQ);
                }
            }
            qualQues.removeAll(valToRemov);
            final Map<ID, sObject> groupRTData = new Map<ID, sObject>(new List<arce__Account_has_Analysis__c> {arce.Arc_Gen_AccHasAnalysis_Data.getAccHasAnalysisFields(header.Id, new List<String>(qualQues))});
            for (String qualQ : qualQues) {
                servSaveResp.updatefields.put(qualQ, groupRTData.get(header.ID).get(qualQ));
            }
        }
        return servSaveResp;
    }
}