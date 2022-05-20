/**
* ------------------------------------------------------------------------------------------------
* @Name     DES_Arc_GBL_Workflow_Helper
* -----------------------------------------------------------------------------------------------
* @Description Class "DES_Arc_GBL_Workflow_Helper"
* -----------------------------------------------------------------------------------------------
*/
@SuppressWarnings('sf:AvoidDuplicateLiterals')
public with sharing class DES_Arc_GBL_Workflow_Helper {

  /**
  * @Description : Service message class
  */
  static final arce.Arc_Gen_CustomServiceMessages SERVICE_MESSAGES = new arce.Arc_Gen_CustomServiceMessages();
  /**
  * ----------------------------------------------------------------------------------------------------
  * @Description Void Constructor to avoid warning in sonar qube
  * ----------------------------------------------------------------------------------------------------
  * @date		11/03/2021
  * @author	Global Desktop
  * @param void
  * @return void
  * @example Arc_GBL_Workflow_Helper data = new Arc_GBL_Workflow_Helper()
  * ----------------------------------------------------------------------------------------------------
  **/
  @TestVisible
  private DES_Arc_GBL_Workflow_Helper() {
  }

  /**
  *-------------------------------------------------------------------------------
  * @description proposeRAIPAction : Propose RAIP Action
  *--------------------------------------------------------------------------------
  * @date		11/03/2021
  * @author	Global Desktop
  * @param    Arc_Gen_Delegation_Wrapper : wrapper
  * @return   Arc_Gen_Delegation_Wrapper
  * @example	Arc_Gen_Workflow_Helper.proposeAction(Arc_Gen_Delegation_Wrapper wrapper);
  */
  public static Arc_Gen_Delegation_Wrapper proposeRAIPAction(Arc_Gen_Delegation_Wrapper wrapper) {
    try {
      wrapper.lstAmbits = formatAmbit(wrapper.ambit, false);
      wrapper.codStatus = SERVICE_MESSAGES.CODE_200;
    } catch (Exception e) {
      wrapper.codStatus = SERVICE_MESSAGES.CODE_500;
      wrapper.msgInfo = 'Error Propose RAIP Action : ' + e.getMessage();
    }
    return wrapper;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description proposeAction : Propose action method
  *--------------------------------------------------------------------------------
  * @date		  16/03/2021
  * @author	  Global Desktop
  * @param    Arc_Gen_Delegation_Wrapper : wrapper
  * @return   Arc_Gen_Delegation_Wrapper
  * @example	Arc_Gen_Workflow_Helper.proposeAction(Arc_Gen_Delegation_Wrapper wrapper);
  */
  public static Arc_Gen_Delegation_Wrapper returnAction(Arc_Gen_Delegation_Wrapper wrapper) {
    try {
      wrapper.lstAmbits = formatAmbit(wrapper.ambit, true);
      wrapper.codStatus = SERVICE_MESSAGES.CODE_200;
    } catch (Exception e) {
      wrapper.codStatus = SERVICE_MESSAGES.CODE_500;
      wrapper.msgInfo = 'Error Return Action : ' + e.getMessage();
    }
    return wrapper;
  }

  /**
  *-------------------------------------------------------------------------------
  * @description proposeRAIPAction : Propose RAIP Action
  *--------------------------------------------------------------------------------
  * @date		11/03/2021
  * @author	Global Desktop
  * @param    Arc_Gen_Delegation_Wrapper : wrapper
  * @return   Arc_Gen_Delegation_Wrapper
  * @example	Arc_Gen_Workflow_Helper.proposeAction(Arc_Gen_Delegation_Wrapper wrapper);
  */
  public static Arc_Gen_Delegation_Wrapper fetchUsersProposeRaip(String selectedAmbit) {
    final Arc_Gen_Delegation_Wrapper wrapper = new Arc_Gen_Delegation_Wrapper();
    try{
      wrapper.lstUsers = gtUsersAmbit(selectedAmbit);
      wrapper.codStatus = SERVICE_MESSAGES.CODE_200;
    } catch (Exception e) {
      wrapper.codStatus = SERVICE_MESSAGES.CODE_500;
      wrapper.msgInfo = 'Error Propose RAIP Action : ' + e.getMessage();
    }
    return wrapper;
  }

  /*
	* @author Global Desktop
	*/
  private static List<Map<String, String>> formatAmbit(String ambitUser, boolean fromUser) {
    final List<Arce_ambit_hierarchy__mdt> ambitMetadatas = new List<Arce_ambit_hierarchy__mdt>([
      SELECT Id, DeveloperName, Action__c, Ambit__c, Description__c, Level__c, Region__c, Selectables__c, canRead__c, canEdit__c, canPropose__c, canValidate__c
      FROM Arce_ambit_hierarchy__mdt
      ORDER BY Description__c ASC
    ]);

    final Arce_ambit_hierarchy__mdt ambit = gtAmbitFromLiteral(ambitUser, ambitMetadatas);

    final List<Map<String, String>> listAmbitKey = new List<Map<String, String>>();
    if(fromUser) {
      listAmbitKey.add(new map<String,String>{'label' => ambitUser , 'value' => ambit.Ambit__c});
    } else {
      final List<String> ambitSelectables = ambit.Selectables__c.split(';');
      for(Arce_ambit_hierarchy__mdt ambitAux : ambitMetadatas) {
        if(ambitSelectables.contains(ambitAux.Ambit__c) && ambitAux.Description__c != null && ambitAux.Description__c != '') {
          listAmbitKey.add(new map<String,String>{'label' => ambitAux.Description__c , 'value' => ambitAux.Ambit__c});
        }
      }
    }

    return listAmbitKey;
  }

  /*
	* @author Global Desktop
	*/
  private static List<Map<String, String>> gtUsersAmbit(String selectedAmbit) {
    final String ambitString = gtStringAmbit(selectedAmbit);

    final List<User> lstUsers = new List<User>([
      SELECT Id, Name
      FROM User
      WHERE gf_user_operation_ambit_name__c = :ambitString
      AND IsActive = true
      ORDER BY Name ASC
    ]);

    final List<Map<String, String>> listAmbitUser = new List<Map<String, String>>();
    for(User usr : lstUsers) {
      listAmbitUser.add(new map<String,String>{'label' => usr.Name , 'value' => usr.Id});
    }
    return listAmbitUser;
  }

  /*
	* @author Global Desktop
	*/
  public static String gtStringAmbit(String selectedAmbit) {
    final List<Arce_ambit_hierarchy__mdt> ambitMetadatas = new List<Arce_ambit_hierarchy__mdt>([
      SELECT Id, DeveloperName, Action__c, Ambit__c, Description__c, Level__c, Region__c, Selectables__c, canRead__c, canEdit__c, canPropose__c, canValidate__c
      FROM Arce_ambit_hierarchy__mdt
      WHERE Ambit__c = :selectedAmbit
      LIMIT 40000
    ]);

    String ambitString = '';
    if(!ambitMetadatas.isEmpty()) {
      ambitString = ambitMetadatas.get(0).Region__c + ' - ' + ambitMetadatas.get(0).Level__c + (ambitMetadatas.get(0).Description__c == null || ambitMetadatas.get(0).Description__c == '' ? ' -' : ' - ' + ambitMetadatas.get(0).Description__c);
    }
    return ambitString;
  }

  /*
	* @author Global Desktop
	*/
  public static String gtDescriptionAmbit(String selectedAmbit) {
    final List<Arce_ambit_hierarchy__mdt> ambitMetadatas = new List<Arce_ambit_hierarchy__mdt>([
      SELECT Id, DeveloperName, Action__c, Ambit__c, Description__c, Level__c, Region__c, Selectables__c, canRead__c, canEdit__c, canPropose__c, canValidate__c
      FROM Arce_ambit_hierarchy__mdt
      WHERE Ambit__c = :selectedAmbit
      LIMIT 40000
    ]);

    String ambitString = '';
    if(!ambitMetadatas.isEmpty() && ambitMetadatas.get(0).Description__c != null && ambitMetadatas.get(0).Description__c != '') {
      ambitString = ambitMetadatas.get(0).Description__c;
    }
    return ambitString;
  }

  /*
	* @author Global Desktop
	*/
  public static Arce_ambit_hierarchy__mdt gtAmbitFromLiteral(String ambitUser, List<Arce_ambit_hierarchy__mdt> ambitMetadatas) {
    List<String> ambitFormatted = ambitUser.split('-');
    final String levelQuery = ambitFormatted.get(1).trim();
    final String regionQuery = ambitFormatted.get(0).trim();
    final String descriptionQuery = ambitFormatted.get(2).trim();

    Iterator<Arce_ambit_hierarchy__mdt> iter = ambitMetadatas.iterator();
    Arce_ambit_hierarchy__mdt ambit = new Arce_ambit_hierarchy__mdt();
    Boolean bool = true;
    while(iter.hasNext() && bool) {
      ambit = iter.next();
      if(ambit.Level__c == levelQuery && ambit.Region__c == regionQuery && ambit.Description__c == descriptionQuery) {
        bool = false;
      }
    }

    return ambit;
  }
}