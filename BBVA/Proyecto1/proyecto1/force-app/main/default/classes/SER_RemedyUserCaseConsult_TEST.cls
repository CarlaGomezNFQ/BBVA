/**
*	Author:
*	Company:		Accenture
*	Description:	Test Class SER_RemedyUserCaseConsult
*
*	History:
*	<Date>			<Author>					<Description>
*	05/07/2018		                                        Test Class
*/
@isTest
private class SER_RemedyUserCaseConsult_TEST {
  /**
  *	Author:
  *	Company:		Accenture
  *	Description:	Test Class SER_RemedyUserCaseConsult
  *                    test error: Case null
  *	History:
  *	<Date>			<Author>					<Description>
  *	05/07/2018		                                        Test Class
  */
  /* Argumento para redirección*/
  private final static string ARG_CASE='case';
  /*Nombre de usuario Remedy*/
  private final static string USER_REMEDY='userREMEDY';
  /*Subject del log generado*/
  private final static string SUBJECT_REMEDY='Access from Remedy';
  /*label for debug*/
  private final static string LBL_PG_RES='>>>>>>> pageResult: ';

  // test error: Case number null
  @isTest static void test01() {
    //Test
    test.startTest();
    // prepare Visualpage params
    final PageReference caseConsultPage = Page.SER_CaseConsult;
    test.setCurrentPage(caseConsultPage);
    System.currentPageReference().getParameters().put(ARG_CASE, '__userREMEDY');
    final SER_RemedyUserCaseConsult controller = new SER_RemedyUserCaseConsult();
    final PageReference pageResult = controller.saveRemedyUserLogAndRedirect();
    system.debug(Logginglevel.INFO,LBL_PG_RES + pageResult);
    test.stopTest();

    //Verify the expressions are the same
    final list<CIB_Log__c> logInserted = [Select CIB_ErrorMessage__c, Remedy_User__c FROM CIB_Log__c Where CIB_Subject__c = :SUBJECT_REMEDY];
    final boolean assertConditions = logInserted.size()==1 && logInserted.get(0).Remedy_User__c == USER_REMEDY
                                      && logInserted.get(0).CIB_ErrorMessage__c != '';
    System.assert (assertConditions,'test01');
  }

  // test error: Case number error
  @isTest static void test02() {

    //Test
    test.startTest();
    // prepare Visualpage params
    final PageReference caseConsultPage = Page.SER_CaseConsult;
    test.setCurrentPage(caseConsultPage);
    System.currentPageReference().getParameters().put(ARG_CASE, '12345678901234567890__userREMEDY');
    final SER_RemedyUserCaseConsult controller = new SER_RemedyUserCaseConsult();
    final PageReference pageResult = controller.saveRemedyUserLogAndRedirect();
    system.debug(Logginglevel.INFO,LBL_PG_RES + pageResult);
    test.stopTest();

    //Verify the expressions are the same
    final list<CIB_Log__c> logInserted = [Select CIB_ErrorMessage__c, Remedy_User__c FROM CIB_Log__c Where CIB_Subject__c = :SUBJECT_REMEDY];
    final boolean assertConditions = logInserted.size()==1 && logInserted.get(0).Remedy_User__c == USER_REMEDY
                                      && logInserted.get(0).CIB_ErrorMessage__c != '';
    System.assert (assertConditions, 'test_02');
  }

  // test error: remedyUser null
  @isTest static void test03() {
    //Test
    test.startTest();
    // prepare Visualpage params
    final PageReference caseConsultPage = Page.SER_CaseConsult;
    test.setCurrentPage(caseConsultPage);
    System.currentPageReference().getParameters().put(ARG_CASE, '123456789012345678__');
    final SER_RemedyUserCaseConsult controller = new SER_RemedyUserCaseConsult();
    final PageReference pageResult = controller.saveRemedyUserLogAndRedirect();
    system.debug(Logginglevel.INFO,LBL_PG_RES + pageResult);
    test.stopTest();

    //Verify the expressions are the same
    final list<CIB_Log__c> logInserted = [Select CIB_ErrorMessage__c, Remedy_User__c FROM CIB_Log__c Where CIB_Subject__c = :SUBJECT_REMEDY];
    final boolean assertConditions = logInserted.size()==1 && logInserted.get(0).Remedy_User__c == null
                                      && logInserted.get(0).CIB_ErrorMessage__c!= '';
    System.assert (assertConditions,'test03');
  }

  // test error: Case number not found
  @isTest static void test04() {
    //Test
    test.startTest();
    // prepare Visualpage params
    final PageReference caseConsultPage = Page.SER_CaseConsult;
    test.setCurrentPage(caseConsultPage);
    System.currentPageReference().getParameters().put(ARG_CASE, '123456789012345678__userREMEDY');
    final SER_RemedyUserCaseConsult controller = new SER_RemedyUserCaseConsult();
    final PageReference pageResult = controller.saveRemedyUserLogAndRedirect();
    system.debug(Logginglevel.INFO,LBL_PG_RES + pageResult);
    test.stopTest();

    //Verify the expressions are the same
    final list<CIB_Log__c> logInserted = [Select CIB_ErrorMessage__c, Remedy_User__c FROM CIB_Log__c Where CIB_Subject__c = :SUBJECT_REMEDY];
    final boolean assertConditions = logInserted.size()==1 && logInserted.get(0).Remedy_User__c == USER_REMEDY
                                      && logInserted.get(0).CIB_ErrorMessage__c!= '';

    System.assert (assertConditions,'test04');
  }

  // test OK: Case number and userRemedy OK
  @isTest static void test05() {
    //Data needed
    Case newCase = SER_TestUtils.ddCrChildCase();
    newCase.SER_Type_EST__c         = '';
    newCase.SER_Subtype_STE__c      = '';
    newCase.SER_Type_GM__c          = '';
    newCase.SER_Subtype_GM__c       = '';
    newCase.SER_RemedyId__c = 'Remedy_1234';
    newCase.Status = 'New';
    newCase.recordTypeId = (Id) SER_RecordTypeUtils.getRecordTypeByName('Case','SER_STE_User');
    insert newCase;
    newCase = [Select id, casenumber From case where id = : newCase.id];
    system.debug(Logginglevel.INFO,'>>>>>>> newCase: ' + newCase);


    //Test
    test.startTest();
    // prepare Visualpage params
    final PageReference caseConsultPage = Page.SER_CaseConsult;
    test.setCurrentPage(caseConsultPage);
    System.currentPageReference().getParameters().put(ARG_CASE, newCase.caseNumber + '__userREMEDY');
    final SER_RemedyUserCaseConsult controller = new SER_RemedyUserCaseConsult();
    final PageReference pageResult = controller.saveRemedyUserLogAndRedirect();
    system.debug(Logginglevel.INFO,LBL_PG_RES + pageResult);
    test.stopTest();


    //Verify the expressions are the same
    final list<CIB_Log__c> logInserted = [Select CIB_ErrorMessage__c, Remedy_User__c FROM CIB_Log__c Where CIB_Subject__c = :SUBJECT_REMEDY];
    final boolean assertConditions = logInserted.size()==1 && logInserted.get(0).Remedy_User__c == USER_REMEDY
                                      && logInserted.get(0).CIB_ErrorMessage__c== null;
    System.assert (assertConditions,'test05');
  }

}