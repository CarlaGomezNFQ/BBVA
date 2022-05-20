/*
* @author Global Desktop
* @description  Clase Helper para el trigger de User
*/
public with sharing class User_Helper {

  /*
  * Private constructor
  */
  private User_Helper() {
  }

  /*
  * Singleton pattern
  */
  private static User_Helper instance;

  /*
  * MAP AMBIT METADATA
  */
  public final static Map<String, Arce_ambit_hierarchy__mdt> MAPAMBIT = gtAmbitMetadata();

  /*
  * Public constructor
  */
  public static User_Helper gtInstance() {
      if (instance == null) {
        instance = new User_Helper();
      }
      return instance;
  }

  /*
	* @author Global Desktop
	*/
  public void ambitPermissionCall(List<User> newList, Map<Id,User> mapOld, Boolean isInsert) {
    if(isInsert) {
      ambitAssignPermission(JSON.serialize(newList),null, JSON.serialize(MAPAMBIT));
    } else {
      ambitAssignPermission(JSON.serialize(newList),JSON.serialize(mapOld), JSON.serialize(MAPAMBIT));
    }
  }

  public void completeLogicValidate(List<User> newList) {
    for(User usr : newList) {
      usr.DES_ARCE_Can_Propose__c = MAPAMBIT.get(usr.gf_user_operation_ambit_name__c) == null ? false : MAPAMBIT.get(usr.gf_user_operation_ambit_name__c).canPropose__c;
      usr.DES_ARCE_Can_Validate__c = MAPAMBIT.get(usr.gf_user_operation_ambit_name__c) == null ? false : MAPAMBIT.get(usr.gf_user_operation_ambit_name__c).canValidate__c;
      usr.DES_ARCE_Can_Edit__c = MAPAMBIT.get(usr.gf_user_operation_ambit_name__c) == null ? false : MAPAMBIT.get(usr.gf_user_operation_ambit_name__c).canEdit__c;
    }
  }

  /*
	* @author Global Desktop
	*/
  @future
  public static void ambitAssignPermission(String newListText, String mapOldText, String mapAmbitMetadataText) {
    List<User> newList = (List<User>) JSON.deserialize(newListText, List<User>.class);
    Map<String, Arce_ambit_hierarchy__mdt> mapAmbitMetadata = (Map<String, Arce_ambit_hierarchy__mdt>) JSON.deserialize(mapAmbitMetadataText, Map<String, Arce_ambit_hierarchy__mdt>.class);

    final List <PermissionSet> psList = new List<PermissionSet>([
      SELECT Id, Name
      FROM PermissionSet
      WHERE name like '%Arc_Gen_Creation%' or name = 'Arce_Corporate_Admin' order by name
    ]);
    system.debug('*** mapAmbitMetadata -> ' + JSON.serialize(mapAmbitMetadata));
    system.debug('*** mapAmbitMetadata size -> ' + mapAmbitMetadata.size());

    final String idMod = psList.get(0).Name.contains('Modification') ? psList.get(0).Id : psList.get(1).Id;
    final String idRead = psList.get(0).Name.contains('Modification') ? psList.get(1).Id : psList.get(0).Id;
    final String idCorpo = psList.get(2).Id;
    final List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
    final List<PermissionSetAssignment> listToDelete = new List<PermissionSetAssignment>();

    //Insert
    if(mapOldText == null) {
      system.debug('*** Insertttttt -> ');
      for(User usr : newList) {
        if(mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) != null && mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c).canRead__c) {
          permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idRead, AssigneeId = usr.Id));
          //permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idCorpo, AssigneeId = usr.Id));
        }
        if(mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) != null && mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c).canEdit__c) {
          permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idMod, AssigneeId = usr.Id));
          //permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idCorpo, AssigneeId = usr.Id));
        }
        permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idCorpo, AssigneeId = usr.Id));
      }
    } else {
      system.debug('*** Updateee -> ');
      Map<Id,User> mapOld = (Map<Id,User>) JSON.deserialize(mapOldText, Map<Id,User>.class);
      final Map<String, PermissionSetAssignment> mapPSet = gtCurrentAssignment(idMod, idRead, idCorpo, mapOld);
      system.debug('*** mapPSet -> ' + JSON.serialize(mapPSet));
      for(User usr : newList) {
        if(usr.IsActive && usr.gf_user_operation_ambit_name__c == 'NA') {
          listToDelete.add(mapPSet.get(usr.Id + '-' + idRead));
          listToDelete.add(mapPSet.get(usr.Id + '-' + idMod));
          listToDelete.add(mapPSet.get(usr.Id + '-' + idCorpo));
        } else {
          if(usr.IsActive && mapPSet.get(usr.Id + '-' + idRead) == null && mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) != null && mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c).canRead__c) {
            system.debug('*** lectura -> ');
            permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idRead, AssigneeId = usr.Id));
          } else if(mapPSet.get(usr.Id + '-' + idRead) != null && (mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) == null || (mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) != null && !mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c).canRead__c))) {
            listToDelete.add(mapPSet.get(usr.Id + '-' + idRead));
          }
          if(usr.IsActive && mapPSet.get(usr.Id + '-' + idMod) == null && mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) != null && mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c).canEdit__c) {
            system.debug('*** modif -> ');
            permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idMod, AssigneeId = usr.Id));
          } else if(mapPSet.get(usr.Id + '-' + idMod) != null && (mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) == null || (mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) != null && !mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c).canEdit__c))) {
            listToDelete.add(mapPSet.get(usr.Id + '-' + idMod));
          }
          if(usr.IsActive && mapPSet.get(usr.Id + '-' + idCorpo) == null && mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) != null) {
            system.debug('*** modif -> ');
            permissionSetList.add(new PermissionSetAssignment(PermissionSetId = idCorpo, AssigneeId = usr.Id));
          } else if(mapPSet.get(usr.Id + '-' + idCorpo) != null && (mapAmbitMetadata.get(usr.gf_user_operation_ambit_name__c) == null )) {
            listToDelete.add(mapPSet.get(usr.Id + '-' + idCorpo));
          }
        }
      }
    }

    system.debug('*** listToDelete -> ' + JSON.serialize(listToDelete));
    if(!listToDelete.isEmpty()) {
      delete listToDelete;
    }

    system.debug('*** permissionSetList -> ' + JSON.serialize(permissionSetList));
    if(!permissionSetList.isEmpty()) {
      insert permissionSetList;
    }
  }


  /*
	* @author Global Desktop
	*/
  public void pricewisePermissionCall(List<User> newList, Map<Id,User> mapOld, Boolean isInsert) {
    if(isInsert) {
      pricewisePermission(JSON.serialize(newList),null);
    } else {
      pricewisePermission(JSON.serialize(newList),JSON.serialize(mapOld));
    }
  }

  /*
	* @author Global Desktop
	*/
  @future
  public static void pricewisePermission(String newListText, String mapOldText) {
    final List<User> newList = (List<User>) JSON.deserialize(newListText, List<User>.class);
    final List <PermissionSet> psList = new List<PermissionSet>([
      SELECT Id, Name
      FROM PermissionSet
      WHERE name = 'Pricewise_Available'
    ]);
    system.debug('*** psList -> ' + psList);

    final List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
    final List<PermissionSetAssignment> listToDelete = new List<PermissionSetAssignment>();

    if(mapOldText == null) {
      system.debug('*** Insert Pricewise -> ');
      for(User usr : newList) {
        if(usr.gf_pricing_gtb_type__c == true) {
          permissionSetList.add(new PermissionSetAssignment(PermissionSetId = psList.get(0).Id, AssigneeId = usr.Id));
        }
      }
    } else {
      system.debug('*** Update Pricewise -> ');
      final Map<String, PermissionSetAssignment> usersAssigned = gtAssignment(psList.get(0).Id, newList);
      for(User usr : newList) {
        if(usr.gf_pricing_gtb_type__c == true && !usersAssigned.keySet().contains(usr.Id)) {
          permissionSetList.add(new PermissionSetAssignment(PermissionSetId = psList.get(0).Id, AssigneeId = usr.Id));
        } else if(usr.gf_pricing_gtb_type__c == false && usersAssigned.keySet().contains(usr.Id)) {
          listToDelete.add(usersAssigned.get(usr.Id));
        }
      }
    }

    system.debug('*** listToDelete Pricewise -> ' + JSON.serialize(listToDelete));
    checkInsertDelete(listToDelete, false);

    system.debug('*** permissionSetList Pricewise -> ' + JSON.serialize(permissionSetList));
    checkInsertDelete(permissionSetList, true);

  }

  /*
	* @author Global Desktop
	*/
  private static Map<String, Arce_ambit_hierarchy__mdt> gtAmbitMetadata() {
    final List<Arce_ambit_hierarchy__mdt> ambitMetadatas = new List<Arce_ambit_hierarchy__mdt>([
      SELECT Id, DeveloperName, Action__c, Ambit__c, Description__c, Level__c, Region__c, Selectables__c, canRead__c, canEdit__c, canPropose__c, canValidate__c
      FROM Arce_ambit_hierarchy__mdt
    ]);
    final Map<String, Arce_ambit_hierarchy__mdt> mapAmbitMetadata = new Map<String, Arce_ambit_hierarchy__mdt>();
    for(Arce_ambit_hierarchy__mdt ambit : ambitMetadatas) {
      final String key = ambit.Region__c + ' - ' + ambit.Level__c + (ambit.Description__c == null || ambit.Description__c == '' ? ' -' : ' - ' + ambit.Description__c);
      if(!mapAmbitMetadata.containsKey(key)) {
        mapAmbitMetadata.put(key, ambit);
      }
    }
    return mapAmbitMetadata;
  }

  /*
	* @author Global Desktop
	*/
  private static Map<String, PermissionSetAssignment> gtCurrentAssignment(String idMod, String idRead, String idCorpo, Map<Id, User> mapOld) {
    final List<PermissionSetAssignment> currentAssignments = new List <PermissionSetAssignment>([
      SELECT Id, PermissionSetId, AssigneeId
      FROM PermissionSetAssignment
      WHERE (PermissionSetId = :idMod OR PermissionSetId = :idRead OR PermissionSetId = :idCorpo) AND AssigneeId IN :mapOld.keySet()
    ]);
    final Map<String, PermissionSetAssignment> mapPSet = new Map<String, PermissionSetAssignment>();
    for(PermissionSetAssignment current : currentAssignments) {
      if(current.PermissionSetId == idMod && !mapPSet.containsKey(current.AssigneeId + '-' + idMod)) {
        mapPSet.put(current.AssigneeId + '-' + idMod, current);
      } else if(current.PermissionSetId == idRead && !mapPSet.containsKey(current.AssigneeId + '-' + idRead)) {
        mapPSet.put(current.AssigneeId + '-' + idRead, current);
      } else if(current.PermissionSetId == idCorpo && !mapPSet.containsKey(current.AssigneeId + '-' + idCorpo)) {
        mapPSet.put(current.AssigneeId + '-' + idCorpo, current);
      }
    }
    return mapPSet;
  }

  /*
  * @author Global Hub
  * @Description Method to add or delete elements
  */
  private static void checkInsertDelete(List<PermissionSetAssignment> psAssignment, Boolean isInsert) {
    if(!psAssignment.isEmpty() && isInsert == true) {
      insert psAssignment;
    } else if(!psAssignment.isEmpty() && isInsert == false) {
      delete psAssignment;
    }
  }

  /*
  * @author Global Hub
  * @Description Method to get Map with curren assignment
  */
  private static Map<String, PermissionSetAssignment> gtAssignment(String psSetId, List<User> newList) {
    final List<PermissionSetAssignment> currentAssign = new List <PermissionSetAssignment>([
      SELECT Id, PermissionSetId, AssigneeId
      FROM PermissionSetAssignment
      WHERE PermissionSetId = :psSetId AND AssigneeId IN :newList
    ]);
    final Map<String, PermissionSetAssignment> usersAssigned = new Map<String, PermissionSetAssignment>();
    for(PermissionSetAssignment current : currentAssign) {
      usersAssigned.put(current.AssigneeId, current);
    }
    return usersAssigned;
  }
}