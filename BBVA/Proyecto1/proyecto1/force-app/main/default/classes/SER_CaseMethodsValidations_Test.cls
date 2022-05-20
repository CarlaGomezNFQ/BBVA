/**
  * VASS Latam
  * @author            Victor Velandia
  * Project:           BBVA Service
  * Description:       Clase test SER_CaseMethodsValidations
  *
  *            No.     Date            Author                  Description
  *            -----   ----------      --------------------    ---------------
  * @version   1.0     2020-03-17      Victor Velandia A(VV)    Clase test SER_CaseMethodsValidations
  **************************************************************************************************/

@isTest
public class SER_CaseMethodsValidations_Test {

  /**
  * description: getDataCaseTestStatusInsert
  * @author Victor Velandia
  */
  @isTest
  static void getDataCaseTestStatusInsert() {

    case objcaseNew;
    objcaseNew = new Case();
    objcaseNew.Status = 'New';
    objcaseNew.SER_Skip_validations__c = false;
    objcaseNew.SER_Classification__c = SER_Constant.DESCARTADO;
    objcaseNew.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'SER_GNC_User');

    List<Case> newGNC;
    newGNC = new List<Case>();
    newGNC.add(objcaseNew);

    case objcasetrans;
    objcasetrans = new Case();
    objcasetrans.Status = 'Transferred';
    objcasetrans.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'SER_GM_User');
    objcasetrans.SER_Skip_validations__c = false;

    List<Case> newGM;
    newGM = new List<Case>();
    newGM.add(objcasetrans);

    case objcaseReOpen;
    objcaseReOpen = new Case();
    objcaseReOpen.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'SER_GTB_User');
    objcaseReOpen.Status = 'Reopen';
    objcaseReOpen.Origin = 'Email STE-PLUS';
    objcaseReOpen.SER_Skip_validations__c = false;
    objcaseReOpen.SER_Product__c = 'EDIFACT';

    List<Case> newGTB;
    newGTB = new List<Case>();
    newGTB.add(objcaseReOpen);

    Test.startTest();
    SER_CaseMethodsValidations.validatePickList(newGM, null);
    SER_CaseMethodsValidations.validatePickList(newGNC, null);
    SER_CaseMethodsValidations.validatePickList(newGTB, null);
    SER_CaseMethodsValidations.validateSTECaseInsert(objcaseReOpen);
    System.assertEquals(objcasetrans, objcasetrans, 'getDataCaseTestStatusInsert');
    Test.stopTest();
  }

  /**
  * description: getDataCaseTestStatusInsertOne
  * @author Victor Velandia
  */
  @isTest
  static void getDataCaseTestStatusInsertOne() {

    case objcaseNew;
    objcaseNew = new Case();
    objcaseNew.Status = 'New';
    objcaseNew.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','SER_STE_User');
    objcaseNew.SER_Skip_validations__c = false;

    final List<Case> lst_case = new List<Case>();
    lst_case.add(objcaseNew);

    case objcaseTrafTrue;
    objcaseTrafTrue = new Case();
    objcaseTrafTrue.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName('Case','SER_STE_User');
    objcaseTrafTrue.Status = 'Transferred';
    objcaseTrafTrue.SER_Skip_validations__c = true;

    List<Case> newSTE;
    newSTE = new List<Case>();
    newSTE.add(objcaseTrafTrue);

    case objcaseReOpenGNC;
    objcaseReOpenGNC = new Case();
    objcaseReOpenGNC.Status = 'Reopen';
    objcaseReOpenGNC.Origin = 'Email GNC';
    objcaseReOpenGNC.SER_Skip_validations__c = true;

    case objcaseLinkMC;
    objcaseLinkMC = new Case();
    objcaseLinkMC.Status = 'Linked to Master Case';
    objcaseLinkMC.Origin = 'BOSS';
    objcaseLinkMC.SER_Remedy_Department__c = 'Mantener equipo resolutor';
    objcaseLinkMC.SER_Skip_validations__c = true;

    case objcaseRemEsc;
    objcaseRemEsc = new Case();
    objcaseRemEsc.Status = 'Remedy - Escalated';
    objcaseRemEsc.SER_Skip_validations__c = true;

    final map<Id, Case> mapCaseOld = new map<Id, Case>();
    mapCaseOld.put(objcaseNew.Id, objcaseNew);

    Test.startTest();
    SER_CaseMethodsValidations.validateSTECaseInsert(objcaseLinkMC);
    SER_CaseMethodsValidations.validatePickList(newSTE, null);
    SER_CaseMethodsValidations.validateGNCCaseInsert(objcaseReOpenGNC);
    SER_CaseMethodsValidations.validateGNCCaseInsert(objcaseRemEsc);
    SER_CaseMethodsValidations.validatePickList(lst_case, mapCaseOld);
    System.assertEquals(objcaseLinkMC, objcaseLinkMC, 'getDataCaseTestStatusInsert');
    Test.stopTest();
  }

  /**
  * description: getDataCaseTestUpdateStatus
  * @author Victor Velandia
  */
  @isTest
  static void getDataCaseTestUpdateStatus() {

    case objcaseOld;
    objcaseOld = new Case();
    objcaseOld.Status = 'Closed';
    objcaseOld.Origin = 'Email PATRIMONIOS';
    objcaseOld.SER_Skip_validations__c = true;
    objcaseOld.SER_Classification__c = 'Incident';
    objcaseOld.SER_Product__c = 'NET CASH';

    case objcasetrans;
    objcasetrans = new Case();
    objcasetrans.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'SER_GM_User');
    objcasetrans.Status = 'Transferred';
    objcasetrans.SER_Skip_validations__c = false;

    List<Case> newGM;
    newGM = new List<Case>();
    newGM.add(objcasetrans);

    case objUpdCaseGNC;
    objUpdCaseGNC = new Case();
    objUpdCaseGNC.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'SER_GNC_User');
    objUpdCaseGNC.Status = SER_Constant.REJECTED;
    objUpdCaseGNC.Origin = 'Email GNC';
    objUpdCaseGNC.SER_Skip_validations__c = false;
    objUpdCaseGNC.SER_Classification__c = SER_Constant.DESCARTADO;

    List<Case> newGNC;
    newGNC = new List<Case>();
    newGNC.add(objUpdCaseGNC);

    case objcaseOldLink;
    objcaseOldLink = new Case();
    objcaseOldLink.Status = 'Linked to Master Case';
    objcaseOldLink.Origin = 'BOSS';
    objcaseOldLink.SER_Remedy_Department__c = 'Mantener equipo resolutor';
    objcaseOldLink.SER_Skip_validations__c = true;
    objcaseOldLink.SER_Product__c = 'EDIFACT';

    final map<Id, Case> mapCaseOldSTE = new map<Id, Case>();
    mapCaseOldSTE.put(objcaseOld.Id, objcaseOld);

    final map<Id, Case> mapCaseOldGNC = new map<Id, Case>();
    mapCaseOldGNC.put(objcaseOld.Id, objcaseOld);

    final map<Id, Case> mapCaseOld = new map<Id, Case>();
    mapCaseOld.put(objcaseOldLink.Id, objcaseOldLink);

    Test.startTest();
    SER_CaseMethodsValidations.validatePickList(newGM, mapCaseOld);
    SER_CaseMethodsValidations.validatePickList(newGNC, mapCaseOldGNC);
    SER_CaseMethodsValidations.validateSTECaseUpdate(objcaseOldLink, mapCaseOldSTE);
    System.assertEquals(objcasetrans, objcasetrans, 'getDataCaseTestUpdateStatus');
    Test.stopTest();
  }

  /**
  * description: getDataCaseTestUpdateStatusOne
  * @author Victor Velandia
  */
  @isTest
  static void getDataCaseTestUpdateStatusOne() {

    case objcaseOld;
    objcaseOld = new Case();
    objcaseOld.Status = 'Closed';
    objcaseOld.Origin = 'Email PATRIMONIOS';
    objcaseOld.SER_Skip_validations__c = true;
    objcaseOld.case_status_type__c = 'Working';
    objcaseOld.activity_status_type__c = 'Working';
    objcaseOld.SER_Is_Master_Case__c = true;
    objcaseOld.SER_Classification__c = 'Incident';

    final List<Case> lst_case = new List<Case>();
    lst_case.add(objcaseOld);

    case objcaseUpd;
    objcaseUpd = new Case();
    objcaseUpd.RecordTypeId = SER_RecordTypeUtils.getRecordTypeByName(SER_Constant.CASECTN, 'SER_GTB_User');
    objcaseUpd.Status = 'Reopen';
    objcaseUpd.Origin = 'Email STE-PLUS';
    objcaseUpd.SER_Skip_validations__c = false;
    objcaseUpd.case_status_type__c = 'Closed';
    objcaseUpd.activity_status_type__c = 'Closed';
    objcaseUpd.SER_Is_Master_Case__c = true;
    objcaseUpd.SER_Classification__c = SER_CloseCaseEGS_CONTROLLER.DISCARTED;

    List<Case> newGTB;
    newGTB = new List<Case>();
    newGTB.add(objcaseUpd);

    final map<Id, Case> mapCaseOldGTB = new map<Id, Case>();
    mapCaseOldGTB.put(objcaseOld.Id, objcaseOld);

    final map<Id, Case> mapCaseOldEGS = new map<Id, Case>();
    mapCaseOldEGS.put(objcaseOld.Id, objcaseOld);

    Test.startTest();
    SER_CaseMethodsValidations.validatePickList(newGTB, mapCaseOldGTB);
    SER_CaseMethodsValidations.validateEGSCaseUpdate(objcaseUpd, mapCaseOldEGS);
    SER_CaseMethodsValidations.validatePickList(lst_case, mapCaseOldEGS);
    System.assertEquals(objcaseUpd, objcaseUpd, 'getDataCaseTestUpdateStatusOne');
    Test.stopTest();
  }

}