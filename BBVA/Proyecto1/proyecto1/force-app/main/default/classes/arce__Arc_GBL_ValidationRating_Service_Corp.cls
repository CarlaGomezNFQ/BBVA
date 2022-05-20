/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Delegation
* @Author   Juan Ignacio Hita Manso juanignacio.hita.contractor@bbva.com
* @Date     Created: 2020-04-20
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Implements of local class workflow that implements Arc_Gen_ValidationRating_Interface
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-04-20 juanignacio.hita.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.UseSingleton')
public class Arc_GBL_ValidationRating_Service_Corp implements Arc_Gen_ValidationsRating_Interface_Corp {
    /**
    * @Description: CompletionResult wrapper class
    */
    public class CompletionResult {
        /**
        * @Description: Map of result completion dynForm
        */
        final private Map<String, TabCompletionInfo> resultCompletion {get;set;}
        /**
        * @Description: Constructor tabCompletionInfo
        */
        public CompletionResult() {
            this.resultCompletion = new Map<String, TabCompletionInfo>();
        }

        public Map<String, TabCompletionInfo> getResultCompletion(){
            return resultCompletion;
        }
    }
    /**
        * @Description: TabCompletionInfo Wrapper Class
    */
    public class TabCompletionInfo {
        /**
        * @Description: List of empty fields
        */
        final private List<String> lstFieldsEmpty {get;set;}
        /**
        * @Description: Tab Name
        */
        final public String nameTab {get;set;}
        /**
        * @Description: Percentage completed
        */
        final public Decimal percentComplete {get;set;}
        /**
        * @Description: Fields visibles
        */
        final public Decimal fieldsVisible {get;set;}
        /**
        * @Description: Completed fields
        */
        final public Decimal fieldsComplete {get;set;}
        /**
        * @Description: Constructor tabCompletionInfo
        */
        public TabCompletionInfo() {
            this.lstFieldsEmpty = new List<String>();
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @description  validateQuestionQualitative : method that validate the qualitative questions of analysis
    --------------------------------------------------------------------------------
    * @author juanignacio.hita.contractor@bbva.com
    * @date   20/04/2020
    * @param  accHasId : Acc Has Analysis Id
    * @param  templateDevname : Developer name of the template to validate
    * @return List<String> : Return a map with the tabId and a empty fields list
    * @example  List<String> ret = Arc_GBL_ValidationRating_Service_Corp.validateQualitativeQuestion(accHasId, templateDevName);
    **/
    public static List<String> validateQualitativeQuestion(String accHasId, String templateDevName) {
        final System.Type objType = Type.forName('dyfr.Dynamic_Form_Completion');
        final dyfr.Form_Completion_Interface formClass = (dyfr.Form_Completion_Interface) objType.newInstance();
        final String retJSON = formClass.getInfoCompletion(accHasId, 'Arc_Gen_QualitativeQuestions__c', templateDevName, null, null);
        List<String> allEmptyFields = new List<String>();
        if (retJSON != null) {
            CompletionResult completionInfo = (CompletionResult) JSON.deserialize(retJSON, CompletionResult.class);
            for (String keyMap: completionInfo.resultCompletion.keySet()) {
                allEmptyFields.addAll(completionInfo.resultCompletion.get(keyMap).lstFieldsEmpty);
            }
        }
        return allEmptyFields;
    }
    /**
    *
    * @Description : Validation to validate that the user who validates that the user who validates the analysis
    * must be different from the user who proposed it.
    * @param : proposeUserId : record id of the proposing user
    * @return : Boolean
    */
    public static String userValidate(String proposeUserId) {
        String statusVal = 'OK';
        return statusVal;
    }

}