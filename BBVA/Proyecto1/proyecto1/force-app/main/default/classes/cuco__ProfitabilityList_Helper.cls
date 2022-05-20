/**
* ──────────────────────────────────────────────────────────────────────────────────────────
* ProfitabilityList_Helper
* Helper class for ProfitabilityList_Service apex class
* ──────────────────────────────────────────────────────────────────────────────────────────
* @author      Giancarlo Mastrogiorgio <giancarlo.mastrogiorgio.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-11
* @modified
* @systemLayer Any
* ──────────────────────────────────────────────────────────────────────────────────────────
* @changes
*
* ──────────────────────────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.TooManyMethods,PMD.ExcessiveParameterList')
public class ProfitabilityList_Helper {
  /**
  * @description Private constructor to avoid sonar err
  */
  @TestVisible
  private ProfitabilityList_Helper() {}

  /**
  * @description Returns the related hierarchy of the related accountId context record
  * @param genConfig : Metadata record with the general configuration of classes
  * @param accountId : Id of the related account record of the context record
  * @return ParticipantHierarchy_Wrapper, with the participant hierarchy info
  */
  public static ParticipantHierarchy_Wrapper getParticipantHierarchy(pa_general_configuration__mdt genConfig, Id accountId) {
      final Type participantClass = Type.forName(genConfig.participants_itf_name__c);
      final Participant_itf participantItf = (Participant_itf) participantClass.newInstance();
      return participantItf.getParticipantHierarchy(accountId);
  }

  /**
  * @description Helper method to obtain if context user can do create action
  * @param genConfig : Metadata record with the general configuration of classes
  * @param recordId : Id of context record
  * @return Map<String, Object>, with the current info
  */
  public static Map<String, Object> checkCreatePermissions(pa_general_configuration__mdt genConfig, Id recordId) {
      final Type permissionsClass = Type.forName(genConfig.permissions_itf_name__c);
      final Permissions_itf permissionsItf = (Permissions_itf) permissionsClass.newInstance();
      return permissionsItf.canCreateNewPA(recordId, UserInfo.getUserId());
  }

  /**
  * @description Method that obtains the current Profitability Sheet
  * @return Map<String, Object>, with the current info
  */
  public static  Map<String, Object> getcurrentPS(Id participantId) {

      Map<String, Object> retMap = new Map<String, Object>();
      Set<Id> ids = new Set<Id>{participantId};
      final ProfitabilitySheetParticipant_Selector currentpsp = new ProfitabilitySheetParticipant_Selector(true);
      final List<profitability_sheet_participant__c> currentpspt = currentpsp.selectByParticipantid(ids);
      final Set<Id> idpsp = new Set<Id>();
      for(profitability_sheet_participant__c psplts : currentpspt) {
          idpsp.add(psplts.gf_profitability_sheet_id__c);
      }
      final ProfitabilitySheet_Selector currentselectors = new ProfitabilitySheet_Selector(true);
      final List<profitability_sheet__c> psvalid = currentselectors.selectValid(idpsp);
      if(!psvalid.isEmpty()) {
          retMap.put('currentId', psvalid[0].Id);
          retMap.put('currentps', psvalid[0].Name);
      }
      return retMap;
  }

  /**
  * @description Returns record to for treegrid
  * @param genConfig : Metadata record with the general configuration of classes
  * @param participantId : Id of the related account record of the context record
  * @return treegrid, with the list of date for treegridData
  */
  public static Map<String, Object> getTreeGridData(Set<Id> participantId, ParticipantHierarchy_Wrapper partHierWrapp, pa_general_configuration__mdt genConfig) {
      final Map<String, Object> retMap = new Map<String, Object>();

      //Seach Profitability Sheet Participant
      final ProfitabilitySheetParticipant_Selector selectorpsp = new ProfitabilitySheetParticipant_Selector(true);
      final List<profitability_sheet_participant__c> psp = selectorpsp.selectByParticipantid(participantId);
      final Set<Id> pspok = getpsp(psp);

      //Seach Profitability Analisis Participant
      final PAParticipant_Selector selectorpap = new PAParticipant_Selector(true);
      final List<profitability_analysis_participant__c> pap = selectorpap.selectByPrticipant(participantId);
      Set<Id> paIdFromPAP = getpap(pap);

      final ProfitabilityAnalysis_Selector selectorpa = new ProfitabilityAnalysis_Selector(true);
      final List<profitability_analysis__c> lstPANotClosed = selectorpa.selectGestion(paIdFromPAP);
      final List<profitability_analysis__c> pagestion = new List<profitability_analysis__c>();
      final List<profitability_analysis__c> lstpa = new List<profitability_analysis__c>();
      final Set<String> psCodesSet = new Set<String>();
      for (profitability_analysis__c paNotClosed : lstPANotClosed) {
        if (paNotClosed.gf_pa_management_type_name__c == 'New' && paNotClosed.gf_profitability_sheet_id__c == null && paNotClosed.gf_auto_formalization_req_id__c == null) {
          pagestion.add(paNotClosed);
        } else {
          lstpa.add(paNotClosed);
          psCodesSet.add(getPsCode(paNotClosed));
        }
      }

      final decimal maxday = genConfig.renewals_max_due_term__c;
      final ProfitabilitySheet_Selector selectorps = new ProfitabilitySheet_Selector(true);
      final List<profitability_sheet__c> lstps = selectorps.selectPSToProfList(pspok, Integer.valueOf(maxday), psCodesSet);

      final List<profitability_analysis__c> lstPA2Subtitle = new List<profitability_analysis__c>();
      List<TreeGridWrapper> treegrid = new List<TreeGridWrapper>();
      treegrid = getGestion(pagestion, lstPA2Subtitle);

      for(profitability_sheet__c ps : lstps) {
          TreeGridWrapper psWraper = new TreeGridWrapper() ;
          psWraper.id = '/'+ ps.id;
          psWraper.name = ps.Name;
          psWraper.filiales = countspsp(ps.id);
          psWraper.status = getSheetStatusValue(ps.gf_prftbly_sheet_stt_desc__c);
          psWraper.lastdate = ps.gf_prftbly_sheet_end_date__c;

          List<Items> paItems = new List<Items>();
          if(!lstpa.isEmpty()) {
              paItems = getpwrapp(ps.id, ps.gf_profitability_sheet_id__c,lstpa, paItems, lstPA2Subtitle);
          }
          if(paItems.size() == 0) {
              Items conWrapp = new Items();
              conWrapp.id= Label.without_inProgress_pa;
              conWrapp.name = Label.without_inProgress_pa;
              paItems.add(conWrapp);
          }
          psWraper.items = paItems;
          treegrid.add(psWraper);
      }
      final Object noGridData = null;
      retMap.put('treeGridData', treegrid.isEmpty() ? noGridData : JSON.serializePretty(treegrid));
      //retMap.put('subtitleData', new Map<String, Object>{'ps' => lstps.size(), 'pa' => lstPA2Subtitle});
      return retMap;
  }

/**
  * @description Helper method to get ps code related to prof analysis param
  * @param paNotClosed : Current prof analysis to get ps code
  * @return String, with the prof sheet code
  */
  private static String getPsCode(profitability_analysis__c paNotClosed) {
    String psCode;
    if (paNotClosed.gf_profitability_sheet_id__c == null) {
        psCode = paNotClosed.gf_auto_formalization_req_id__c;
    } else {
        psCode = paNotClosed.gf_profitability_sheet_id__r.gf_profitability_sheet_id__c;
    }
    return psCode;
  }

  /**
  * @description Returns record Gestion
  * @param lstps: List of profitability analysis
  * @return List of profitability analysis
  */
  public static List<Items> getpwrapp (id psid, String pscode, List<profitability_analysis__c> lstpa, List<Items> paItems, List<profitability_analysis__c> lstPA2Subtitle) {
      for(profitability_analysis__c pa : lstpa) {
          if(psid == pa.gf_profitability_sheet_id__c || pscode == pa.gf_auto_formalization_req_id__c) {
              Items paWrapp = new Items();
              paWrapp.id= '/'+ pa.id ;
              paWrapp.name = pa.Name ;
              paWrapp.filiales = countspap(pa.id);
              paWrapp.status = Utils.getPicklistLabel('cuco__profitability_analysis__c', 'cuco__gf_pa_mgmt_status_type_name__c', pa.gf_pa_mgmt_status_type_name__c);
              paItems.add(paWrapp);
              lstPA2Subtitle.add(pa);
          }
      }
      return paItems;
  }

  /**
  * @description Returns record Gestion
  * @param lstps: List of profitability analysis
  * @return List of profitability analysis
  */
  public static List<TreeGridWrapper> getGestion (List<profitability_analysis__c> lstps, List<profitability_analysis__c> lstPA2Subtitle) {
      List<TreeGridWrapper> treeGridW = new List<TreeGridWrapper>();
      for(profitability_analysis__c pa : lstps) {
          TreeGridWrapper psWraper = new TreeGridWrapper() ;
          psWraper.id = '/'+ pa.id;
          psWraper.name = pa.Name;
          psWraper.status = Utils.getPicklistLabel('cuco__profitability_analysis__c', 'cuco__gf_pa_mgmt_status_type_name__c', pa.gf_pa_mgmt_status_type_name__c);
          psWraper.filiales = countspap(pa.id);
          treeGridW.Add(psWraper);
          List<Items> paItems = new List<Items>();
          psWraper.items = paItems;
          lstPA2Subtitle.add(pa);
      }
      return treeGridW;
  }

  /**
  * @description Returns record to for treegrid
  * @param psplist : List of profitability sheets participant
  * @return idpsp, with the ids of profitability sheets
  */
  public static set<Id> getpsp (List<profitability_sheet_participant__c> psplist){
      Set<Id> idpsp = new Set<Id>();
      for(profitability_sheet_participant__c psps : psplist) {
          idpsp.add(psps.gf_profitability_sheet_id__c);
      }
      return idpsp;
  }

  /**
  * @description Returns record to for treegrid
  * @param paplist : List of profitability Analysis Participant
  * @return idpspap, with the ids of profitability Analysis
  */
  public static set<Id> getpap (List<profitability_analysis_participant__c> paplist) {
      final Set<Id> idpspap = new Set<Id>();
      for(profitability_analysis_participant__c paps : paplist) {
          idpspap.add(paps.gf_profitablity_analysis_id__c);
      }
      return idpspap;
  }

  /**
  * @description Returns count of participant for profitability sheets
  * @param psplist : Id of profitability analysis
  * @param countpaps : number initial for count
  * @return countpaps, with the numbers of participant
  */
  public static integer countspap (Id psplist) {
      final Set<Id> ids = new Set<Id>{psplist};
      integer countpaps = 0;
      final PAParticipant_Selector countpap = new PAParticipant_Selector(true);
      final List<profitability_analysis_participant__c> cpap = countpap.selectByProfAnalysis(ids);
      if(!cpap.isEmpty()) {
        countpaps = cpap.size();
      }
      return countpaps;
  }
  /**
  * @description Returns record to for treegrid
  * @param psplist : Id of profitability Sheets
  * @param countpsps : number initial for count
  * @return countpsps, with the numbers of participant
  */
  public static integer countspsp (Id psplist) {
      final Set<Id> ids = new Set<Id>{psplist};
      integer countpsps= 0;
      final ProfitabilitySheetParticipant_Selector countpsp = new ProfitabilitySheetParticipant_Selector(true);
      final List<profitability_sheet_participant__c> cpsp = countpsp.selectByProfSheet(ids);
      if(!cpsp.isEmpty()) {
        countpsps = cpsp.size();
      }
      return countpsps;
  }

  /**
  * @description Returns string label to show from ps
  * @param currentStatus : String with current status value
  * @return string, with the associated label
  */
  public static String getSheetStatusValue(String currentStatus) {
      String statusLabel;
      switch on currentStatus {
          when  'Valid' {
              statusLabel = Label.ps_valid_status;
          }
          when 'Expired' {
              statusLabel = Label.ps_expired_status;
          }
          when 'Cancelled' {
              statusLabel = Label.ps_cancelled_status;
          }
          when else {
              statusLabel = '';
          }
      }
      return statusLabel;
  }

  /**
  * @description Returns string label to subtitle. Commented for rollback in future, if needed
  * @param mapData : Map with needed values
  * @return string, with the subtitle
  */
  /*public static String getSubtableTitle(Map<String, Object> mapData) {
      List<profitability_analysis__c> lstPA2Subtitle = (List<profitability_analysis__c>) mapData.get('pa');
      Integer totalNumberOfPA = Integer.valueOf(mapData.get('ps'));
      Integer totalNumberOfNewPA = 0;
      Integer totalNumberOfRenewalPA = 0;
      Integer totalNumberOfNovationPA = 0;
      Integer totalNumberOfCancellationPA = 0;
      for (profitability_analysis__c currentPA : lstPA2Subtitle) {
          switch on currentPA.gf_pa_management_type_name__c {
              when 'New' {
                totalNumberOfNewPA++;
              }
              when 'Novation' {
                totalNumberOfNovationPA++;
              }
              when 'Renewal' {
                totalNumberOfRenewalPA++;
              }
              when 'Cancellation' {
                totalNumberOfCancellationPA++;
              }
          }
      }
      String returnStr = Label.formalized_ps + ': ' + totalNumberOfPA + '. ';
      returnStr = returnStr + Label.inProgress_pa + ': ' + totalNumberOfNewPA + ' ' + Label.new + ' · ';
      returnStr = returnStr + totalNumberOfRenewalPA + ' ' + Label.renewal + ' · ';
      returnStr = returnStr + totalNumberOfNovationPA + ' ' + Label.novation + ' · ';
      returnStr = returnStr + totalNumberOfCancellationPA + ' ' + Label.cancellation;
      return returnStr;
  }*/

  /**
  * @description Returns record to for treegrid
  */
  public Class TreeGridWrapper {
      String id {get;set;}
      String name {get;set;}
      Integer filiales {get;set;}
      String status {get;set;}
      date lastdate {get;set;}
      List<Items> items {get;set;}
  }

  /**
  * @description Returns record to for treegrid
  */
  public Class Items {
      String id {get;set;}
      String name {get;set;}
      Integer filiales {get;set;}
      String status {get;set;}
  }
}