/*********************************************************************************************
* @author       JSS - Accenture
* @date			08/05/2017
* @description  Class intermedia para la llamada desde Remedy al caso que se quiere consultar,
*				que almacena los datos de logs de usuario Remedy que realiza la consulta.
* @Revision
*********************************************************************************************/
public with sharing class SER_RemedyUserCaseConsult {
  /*Case Id*/
  public String caseId {get; set;}
  /*Remedy User */
  public String remedyUser {get; set;}
  /*Error message if any*/
  public String errorMsg {get; set;}

  /* Literal for Remedy errors */
  private static final string ERR_NAME = 'Access from Remedy';

  /*ID max length*/
  private static final integer ID_MAX_LENGTH = 18;

  /*Constructor. Initializes default values*/
  public SER_RemedyUserCaseConsult() {
    final List<String> params = apexpages.currentpage().getparameters().get('case').split('__');
    this.caseId = (params.get(0) == null ? '' : params.get(0));
    this.remedyUser = (params.size() == 2 && params.get(1) != null ? params.get(1) : '');
  }

  /*-------------------------------------------------------------------------------
      Author:        JSS
      Company:       Accenture
      Description:   Save Remedy user log and redirect to case

      IN:
      OUT:

      History:
      <Date>                  <Author>                <Change Description>
      08/05/2017              JSS                               Initial Version
  ---------------------------------------------------------------------------------*/
  public pagereference saveRemedyUserLogAndRedirect() {
    PageReference pageRef;

    if(string.isBlank(this.caseId)) {
      this.errorMsg = 'Case Id cannot be null' + this.caseId;
      //Save log
      CIB_LogUtils.create_RemedyErrorLog(ERR_NAME, this.caseId, this.remedyUser, this.errorMsg);
    } else if(this.caseId.length()>ID_MAX_LENGTH) {
      this.errorMsg = 'Case Id is not valid: ' + this.caseId;
      //Save log
      CIB_LogUtils.create_RemedyErrorLog(ERR_NAME, '', this.remedyUser, this.errorMsg);
    } else if(string.isBlank(this.remedyUser)) {
      this.errorMsg = 'Remedy User cannot be null';
      //Save log
      CIB_LogUtils.create_RemedyErrorLog(ERR_NAME, this.caseId, this.remedyUser, this.errorMsg );

    } else {
      //get Salesforce CaseID
      final List<Case> lstCaseIds = [Select Id from Case Where caseNumber = :this.caseId limit 1];
      if (caseId.startsWithIgnoreCase('00T') == false && lstCaseIds.isEmpty()) {
        this.errorMsg = 'Case Id not found: ' + this.caseId;
        //Save log
        CIB_LogUtils.create_RemedyErrorLog(ERR_NAME, '', this.remedyUser, this.errorMsg);
      } else {
        //Save log
        CIB_LogUtils.create_RemedyLog(ERR_NAME, this.caseId, this.remedyUser);

        //Redirect to case
        pageRef = new PageReference('/' + (caseId.startsWithIgnoreCase('00T') ? caseId : lstCaseIds.get(0).Id));
        pageRef.setRedirect(true);
      }
    }

    return pageRef;
  }
}