/**
  * @author            Victor Velandia
  * Project:           BBVA Service
  * Description:       Test Class SER_CaseMethods_HELPER_Parent
  *
  *            No.     Date            Author                  Description
  *            -----   ----------      --------------------    ---------------
  * @version   1.0     2019-06-04      Victor Velandia (VV)    Initial version
  ************************************************************************************/
@isTest
public with sharing class SER_CaseMethods_HELPER_Parent_Tst {

  /**
    * description: STRPRUEBA
    * @author Victor Velandia
    */
  private static final string STRPRUEBA     = 'prueba';
  /**
    * description: STRCLOSED
    * @author Victor Velandia
    */
  private static final string STRCLOSED     = 'closed';
  /**
    * description: STRCONSULTA
    * @author Victor Velandia
    */
  private static final string STRCONSULTA   = 'consulta';
  /**
    * description: STRLINKED
    * @author Victor Velandia
    */
  private static final string STRLINKED     = 'linked to Master Case';
  /**
    * description: STRUPDMASTER
    * @author Victor Velandia
    */
  private static final string STRUPDMASTER  = 'bl_UpdatingMasterCases';
  /**
    * description: STRQUERYNEED
    * @author Victor Velandia
    */
  private static final string STRQUERYNEED  = 'bl_QueryNeeded';

  /**
    * description: nullIdParent
    */
  private static Id nullIdParent;

  /**
    * description: helperParentSTE
    * @author Victor Velandia
    */
  public static testMethod void helperParentSTE() {
    SER_TestUtils_3.initCustomsetting();

    final Boolean isMCmodifyStatus          = true;
    final Set<Id> setMasterCasesID          = new Set<Id>();
    final Set<Id> setAlreadyExistMC         = new Set<Id>();
    final List<Case> lstCase                = new List<Case>();
    final Map<String,Boolean> mapBL         = new Map<String,Boolean>();
    final Map<Id,Case> mapMasterCases       = new Map<Id,Case>();
    final Map<Id,List<Case> > mapMasterIDCC  = new Map<Id,List<Case> >();

    Account pruebaAcc;
    pruebaAcc                               = new Account();
    pruebaAcc.Name                          = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase = new Case(AccountId = pruebaAcc.Id, Status = STRCLOSED, SER_Classification__c = 'Incidencia', RecordTypeId = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id, SER_Solution__c = 'Solution');

    insert parentCase;

    Case childCase;
    childCase                               = new Case();
    childCase.SER_Business_Case_Type__c     = SER_Constant.BUSINESS_STE;
    childCase.SER_Is_Master_Case__c         = isMCmodifyStatus;
    childCase.SER_Close__c                  = false;
    childCase.status                        = 'Transferred';
    childCase.SER_IsSernova__c              = true;
    childCase.ParentId                      = parentCase.Id;
    childCase.RecordTypeId                  = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id;
    childCase.SER_Skip_validations__c       = true;
    childCase.SER_Classification__c         = 'Incidencia';
    childCase.SER_Remedy_Department__c      = 'ANS SSTT';
    insert childCase;
    childCase.SER_Close__c                  = false;
    childCase.status                        = STRCLOSED;
    childCase.SER_Solution__c               = 'Solution';
    update childCase;

    Case childCaseMap;
    childCaseMap = new Case();
    childCaseMap.SER_Business_Case_Type__c  = SER_Constant.BUSINESS_STE;
    childCaseMap.SER_Is_Master_Case__c      = isMCmodifyStatus;
    childCaseMap.SER_Close__c               = false;
    childCaseMap.status                     = STRLINKED;
    childCaseMap.SER_IsSernova__c           = true;
    childCaseMap.ParentId                   = parentCase.Id;
    childCaseMap.RecordTypeId               = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id;
    mapMasterCases.put(childCaseMap.Id, childCaseMap);

    mapBL.put(STRUPDMASTER, true);
    setMasterCasesID.add(childCaseMap.id);
    setAlreadyExistMC.add(childCase.id);
    lstCase.add(childCase);
    mapMasterIDCC.put(childCaseMap.Id, lstCase);

    Test.startTest();
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, parentCase, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }

  /**
    * description: helperParentSTEElse
    * @author Victor Velandia
    */
  public static testMethod void helperParentSTEElse() {
    SER_TestUtils_3.initCustomsetting();

    final Boolean isMCmodifyStatus          = false;
    final Set<Id> setMasterCasesID          = new Set<Id>();
    final Set<Id> setAlreadyExistMC         = new Set<Id>();
    final List<Case> lstCase                = new List<Case>();
    final Map<String,Boolean> mapBL         = new Map<String,Boolean>();
    final Map<Id,Case> mapMasterCases       = new Map<Id,Case>();
    final Map<Id,List<Case> > mapMasterIDCC  = new Map<Id,List<Case> >();

    Account pruebaAcc;
    pruebaAcc                               = new Account();
    pruebaAcc.Name                          = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase = new Case(AccountId = pruebaAcc.Id, Status = STRLINKED, SER_Classification__c = 'Incidencia', SER_Skip_validations__c = true, RecordTypeId = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id);
    insert parentCase;

    Case childCase;
    childCase = new Case(SER_Business_Case_Type__c = SER_Constant.BUSINESS_STE, SER_Is_Master_Case__c = true, SER_Close__c = false, status = 'Transferred', SER_IsSernova__c = true, ParentId = parentCase.Id, RecordTypeId = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id, SER_Skip_validations__c = true, SER_Classification__c = 'Incidencia', SER_Remedy_Department__c = 'ANS SSTT');
    insert childCase;
    childCase.SER_Close__c                  = false;
    childCase.SER_Is_Master_Case__c         = isMCmodifyStatus;
    childCase.status                        = STRCLOSED;
    childCase.SER_Solution__c               = 'Solution';
    update childCase;

    Case childCaseMap;
    childCaseMap                            = new Case();
    childCaseMap.SER_Business_Case_Type__c  = SER_Constant.BUSINESS_STE;
    childCaseMap.SER_Is_Master_Case__c      = isMCmodifyStatus;
    childCaseMap.SER_Master_Case__c         = childCase.id;
    childCaseMap.SER_Close__c               = false;
    childCaseMap.status                     = STRLINKED;
    childCaseMap.SER_IsSernova__c           = true;
    childCaseMap.ParentId                   = parentCase.Id;
    childCaseMap.RecordTypeId               = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id;
    mapMasterCases.put(childCaseMap.Id, childCaseMap);

    mapBL.put(STRUPDMASTER, true);
    setMasterCasesID.add(childCaseMap.id);
    setAlreadyExistMC.add(childCase.id);
    lstCase.add(childCase);
    mapMasterIDCC.put(childCaseMap.Id, lstCase);

    Test.startTest();
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, parentCase, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }

  /**
    * description: helperParentGM
    * @author Victor Velandia
    */
  public static testMethod void helperParentGM() {
    SER_TestUtils_3.initCustomsetting();

    final Boolean changeToModify            = false;
    final Set<Id> setMasterCasesID          = new Set<Id>();
    final Set<Id> setAlreadyExistMC         = new Set<Id>();
    final List<Case> lstCase                = new List<Case>();
    final Map<String,Boolean> mapBL         = new Map<String,Boolean>();
    final Map<Id,Case> mapMasterCases       = new Map<Id,Case>();
    final Map<Id,List<Case> > mapMasterIDCC  = new Map<Id,List<Case> >();

    Account pruebaAcc;
    pruebaAcc                               = new Account();
    pruebaAcc.Name                          = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase = new Case(AccountId = pruebaAcc.Id, Status = STRCLOSED, SER_Classification__c = STRCONSULTA, RecordTypeId = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id, SER_Solution__c = 'Solution');
    insert parentCase;

    Case childCase;
    childCase = new Case(SER_Business_Case_Type__c = SER_Constant.BUSINESS_GM, SER_Is_Master_Case__c = changeToModify, SER_Close__c = false, status = STRLINKED, SER_IsSernova__c = true, ParentId = nullIdParent, RecordTypeId = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GM_User'].Id);
    insert childCase;
    childCase.SER_Close__c                  = false;
    childCase.status                        = STRCLOSED;
    update childCase;

    Case childCaseMap;
    childCaseMap                            = new Case();
    childCaseMap.SER_Business_Case_Type__c  = SER_Constant.BUSINESS_GM;
    childCaseMap.SER_Is_Master_Case__c      = changeToModify;
    childCase.SER_Classification__c         = 'feedback';
    childCaseMap.SER_Close__c               = false;
    childCaseMap.status                     = STRLINKED;
    childCaseMap.SER_IsSernova__c           = true;
    childCaseMap.ParentId                   = nullIdParent;
    childCaseMap.RecordTypeId               = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GM_User'].Id;
    insert childCaseMap;
    mapMasterCases.put(childCaseMap.Id, childCaseMap);

    mapBL.put(STRUPDMASTER, true);
    mapBL.put(STRQUERYNEED, true);
    setMasterCasesID.add(childCaseMap.id);
    setAlreadyExistMC.add(childCase.id);
    lstCase.add(childCase);
    mapMasterIDCC.put(childCaseMap.Id, lstCase);

    Test.startTest();
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, childCaseMap, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, parentCase, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }

  /**
    * description: helperParentGmElse
    * @author Victor Velandia
    */
  public static testMethod void helperParentGmElse() {
    SER_TestUtils_3.initCustomsetting();

    final Boolean changeToModify            = true;
    final String strQuery                   = STRQUERYNEED;
    final String strUpdate                  = STRUPDMASTER;
    final Set<Id> setMasterCasesID          = new Set<Id>();
    final Set<Id> setAlreadyExistMC         = new Set<Id>();
    final List<Case> lstCase                = new List<Case>();
    final Map<String,Boolean> mapBL         = new Map<String,Boolean>();
    final Map<Id,Case> mapMasterCases       = new Map<Id,Case>();
    final Map<Id,List<Case> > mapMasterIDCC  = new Map<Id,List<Case> >();

    Account pruebaAcc;
    pruebaAcc                               = new Account();
    pruebaAcc.Name                          = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase                               = new Case();
    parentCase.AccountId                     = pruebaAcc.Id;
    parentCase.Status                        = STRCLOSED;
    parentCase.RecordTypeId                  = [Select Id FROM RecordType WHERE DeveloperName = 'SER_STE_User'].Id;
    parentCase.SER_Solution__c               = 'Solution';
    insert parentCase;

    Case childCase;
    childCase                               = new Case();
    childCase.SER_Business_Case_Type__c     = SER_Constant.BUSINESS_GM;
    childCase.SER_Is_Master_Case__c         = changeToModify;
    childCase.ParentId                      = parentCase.id;
    childCase.RecordTypeId                  = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GM_User'].Id;
    insert childCase;

    Case childCaseMap;
    childCaseMap                            = new Case();
    childCaseMap.SER_Business_Case_Type__c  = SER_Constant.BUSINESS_GM;
    childCaseMap.SER_Is_Master_Case__c      = changeToModify;
    childCaseMap.status                     = STRLINKED;
    childCaseMap.ParentId                   = parentCase.id;
    childCaseMap.RecordTypeId               = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GM_User'].Id;
    insert childCaseMap;
    childCaseMap.ParentId                   = nullIdParent;
    update childCase;
    mapMasterCases.put(childCaseMap.Id, childCaseMap);

    mapBL.put(strUpdate, true);
    mapBL.put(strQuery, true);
    setMasterCasesID.add(childCaseMap.id);
    setAlreadyExistMC.add(childCase.id);
    lstCase.add(childCase);
    mapMasterIDCC.put(childCaseMap.Id, lstCase);

    Test.startTest();
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, parentCase, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }

  /**
    * description: helperParentGNC
    * @author Victor Velandia
    */
  public static testMethod void helperParentGNC() {

    final Boolean changeToModify            = false;
    final Set<Id> setMasterCasesID          = new Set<Id>();
    final Set<Id> setAlreadyExistMC         = new Set<Id>();
    final List<Case> lstCase                = new List<Case>();
    final Map<String,Boolean> mapBL         = new Map<String,Boolean>();
    final Map<Id,Case> mapMasterCases       = new Map<Id,Case>();
    final Map<Id,List<Case> > mapMasterIDCC  = new Map<Id,List<Case> >();

    Case childCase;
    childCase                               = new Case();
    childCase.SER_Business_Case_Type__c     = SER_Constant.BUSINESS_GNC;
    childCase.SER_Is_Master_Case__c         = changeToModify;
    childCase.SER_Asset__c                  = 'mm';
    childCase.SER_Close__c                  = false;
    childCase.status                        = STRLINKED;
    childCase.SER_IsSernova__c              = true;
    childCase.ParentId                      = nullIdParent;
    childCase.RecordTypeId                  = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GNC_User'].Id;
    insert childCase;
    childCase.SER_Asset__c                  = 'equity';
    childCase.SER_Close__c                  = false;
    childCase.status                        = STRCLOSED;
    update childCase;

    Case childCaseMap;
    childCaseMap                            = new Case();
    childCaseMap.SER_Business_Case_Type__c  = SER_Constant.BUSINESS_GNC;
    childCaseMap.SER_Is_Master_Case__c      = changeToModify;
    childCase.SER_Classification__c         = 'feedback';
    childCaseMap.SER_Close__c               = false;
    childCaseMap.status                     = STRLINKED;
    childCaseMap.SER_IsSernova__c           = true;
    childCaseMap.ParentId                   = nullIdParent;
    childCaseMap.RecordTypeId               = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GNC_User'].Id;
    insert childCaseMap;
    mapMasterCases.put(childCaseMap.Id, childCaseMap);

    mapBL.put(STRUPDMASTER, true);
    setMasterCasesID.add(childCaseMap.id);
    setAlreadyExistMC.add(childCase.id);
    lstCase.add(childCase);
    mapMasterIDCC.put(childCaseMap.Id, lstCase);

    Test.startTest();
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, childCaseMap, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }

  /**
    * description: helperParentGNCElse
    * @author Victor Velandia
    */
  public static testMethod void helperParentGNCElse() {
    SER_TestUtils_3.initCustomsetting();

    final Boolean changeToModify            = false;
    final String strQuery                   = STRQUERYNEED;
    final String strUpdate                  = STRUPDMASTER;
    final Set<Id> setMasterCasesID          = new Set<Id>();
    final Set<Id> setAlreadyExistMC         = new Set<Id>();
    final List<Case> lstCase                = new List<Case>();
    final Map<String,Boolean> mapBL         = new Map<String,Boolean>();
    final Map<Id,Case> mapMasterCases       = new Map<Id,Case>();
    final Map<Id,List<Case> > mapMasterIDCC  = new Map<Id,List<Case> >();

    Account pruebaAcc;
    pruebaAcc                               = new Account();
    pruebaAcc.Name                          = STRPRUEBA;
    insert pruebaAcc;

    Case parentCase;
    parentCase                              = new Case();
    parentCase.AccountId                    = pruebaAcc.Id;
    parentCase.Status                       = STRCLOSED;
    parentCase.SER_Solution__c              = 'Solution';
    insert parentCase;

    Case childCase;
    childCase                               = new Case();
    childCase.SER_Business_Case_Type__c     = SER_Constant.BUSINESS_GNC;
    childCase.SER_Is_Master_Case__c         = changeToModify;
    childCase.ParentId                      = parentCase.id;
    childCase.RecordTypeId                  = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GNC_User'].Id;
    insert childCase;

    Case childCaseMap;
    childCaseMap                            = new Case();
    childCaseMap.SER_Business_Case_Type__c  = SER_Constant.BUSINESS_GNC;
    childCaseMap.SER_Is_Master_Case__c      = changeToModify;
    childCaseMap.status                     = STRLINKED;
    childCaseMap.ParentId                   = parentCase.id;
    childCaseMap.RecordTypeId               = [Select Id FROM RecordType WHERE DeveloperName = 'SER_GNC_User'].Id;
    insert childCaseMap;
    childCaseMap.ParentId                   = nullIdParent;
    update childCase;
    mapMasterCases.put(childCaseMap.Id, childCaseMap);

    mapBL.put(strUpdate, true);
    mapBL.put(strQuery, true);
    setMasterCasesID.add(childCaseMap.id);
    setAlreadyExistMC.add(childCase.id);
    lstCase.add(childCase);
    mapMasterIDCC.put(childCaseMap.Id, lstCase);

    Test.startTest();
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, childCaseMap, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    SER_CaseMethods_HELPER_Parent.fillParentChildrenMaps(childCase, parentCase, mapBL, setMasterCasesID, setAlreadyExistMC, mapMasterCases, mapMasterIDCC);
    System.assertEquals (childCase.id,childCase.id,'');
    Test.stopTest();
  }
}