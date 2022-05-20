/**
* ____________________________________________________________________________
* Back End Integration Helper
* Name class: BackendIntegration_Helper
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-08
* @modified
* @systemLayer Service
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('PMD.TooManyMethods')
public class BackendIntegration_Helper {

  /**
  * @description query limit
  */
  final static Integer QUERYLIMIT = 2000;

  /**
  * @description private constructor.
  */
  @TestVisible
  private BackendIntegration_Helper() {}

  /**
  * @description return whether origin is valid
  * @param origin : string
  * @return Boolean
  */
  private static Boolean isOriginValid(String origin) {
    return origin == 'COMMISSIONS_FLAT' || origin == 'GIP_PACKAGE' || origin == 'FORFAIT' || origin == 'COMMERCIAL_PACKAGE';
  }

  /**
  * @description return whether origin is valid
  * @param origin : Map<String, Object> as returned from second service
  * @return Boolean
  */
  private static Boolean isOriginValid(Map<String, Object> record) {
    Boolean validOrigin = false;
    if(record.containsKey('origin')) {
      final Map<String, Object> origin = (Map<String, Object>)record.get('origin');
      validOrigin = String.isEmpty((String)origin.get('id')) || isOriginValid((String)origin.get('id'));
    } else {
      validOrigin = true;
    }
    return validOrigin;
  }

  /**
  * @description return whether source is extended package
  * @param origin : Map<String, Object> as returned from second service
  * @return Boolean
  */
  private static String getoriginId (Map<String, Object> record) {
    String originId;
    if(record.containsKey('origin')) {
      final Map<String, Object> origin = (Map<String, Object>)record.get('origin');
      originId = (String)origin.get('id');
    }
    return originId;
  }

  /**
  * @description return whether source is extended package
  * @param source : String with condition source
  * @return Boolean
  */
  private static Boolean getExtendedPackageType(String source) {
    Boolean ispackageSource = false;
    if(source == 'GIP_PACKAGE' || source == 'FORFAIT' || source == 'COMMERCIAL_PACKAGE') {
      ispackageSource = true;
    }
    return ispackageSource;
  }

  /**
  * @description extract and return attribute value, dependeing on the value type
  * @param formats : Map<String, Object> as returned from second service
  * @param type : tupe of attribute.
  * @return String
  */
  private static String getAttributeValue(List<Object> formats, String type) {

    final Map<String, Object> formatMap = (Map<String, Object>)formats.get(0);
    final Map<String, Object> format = (Map<String, Object>)formatMap.get('format');
    String result = '';

    switch on type {
      when 'RATE' {
        final Map<String, Object> mapRate = (Map<String, Object>) formatMap.get('format');
        result = String.valueof((Decimal) mapRate.get('value'));
      }
      when 'AMOUNT' {
        final Map<String, Object> mapAmount = (Map<String, Object>) format.get('amount');
        result = String.valueof((Decimal) mapAmount.get('amount'));
      }
      when 'TEXT' {
        final Map<String, Object> mapText = (Map<String, Object>) formatMap.get('format');
        result = (String) mapText.get('text');
      }
      when 'TERM' {
        final Map<String, Object> mapTerm = (Map<String, Object>) formatMap.get('format');
        result = String.valueof((Integer) mapTerm.get('termValue'));
      }
      when 'DATE' {
        final Map<String, Object> mapDate = (Map<String, Object>) formatMap.get('date');
        result = (String) mapDate.get('date');
      }
      when else {
        result = '';
      }
    }
    return result;
  }

  /**
  * @description return all condition attributes in the catalag with a maximum limit of QUERYLIMIT
  * @return Map<String, ps_catalog_condition_attribute__c> map with all condition attributes.
  */
  private static Map<String, ps_catalog_condition_attribute__c> getConditionAttributes() {
    final PsCatalogConditionAttribute_Selector pscConditionAttrSelector = new PsCatalogConditionAttribute_Selector(new List<String>{'cuco__BackendIntegration'});
    final List<ps_catalog_condition_attribute__c> pscConditionAttributes = pscConditionAttrSelector.getCatalogConditionsAttribute(QUERYLIMIT);
    final Map<String, ps_catalog_condition_attribute__c> mapConditionAttributes = new Map<String, ps_catalog_condition_attribute__c>();

    for (ps_catalog_condition_attribute__c pscConditionAttribute : pscConditionAttributes) {
      mapConditionAttributes.put(pscConditionAttribute.gf_psc_condition_attribute_id__c, pscConditionAttribute);
    }
    return mapConditionAttributes;
  }

  /**
  * @description return all falte rate attributes in the catalag
  * @return Map<String, ps_catalog_flat_rates_attribute__c> map with all falte rate attributes.
  */
  public static Map<String, ps_catalog_flat_rates_attribute__c> getPSflatRateAttr() {

    final PsCatalogFlatRatesAttribute_Selector psCFlatRtAttSelec = new PsCatalogFlatRatesAttribute_Selector(true);
    final List<ps_catalog_flat_rates_attribute__c> lPsCtlatRtAtt = psCFlatRtAttSelec.selectAll(100);
    final Map<String, ps_catalog_flat_rates_attribute__c> mapPsCtFltRtAtt = new Map<String, ps_catalog_flat_rates_attribute__c>();

    for (ps_catalog_flat_rates_attribute__c pscFRattribute : lPsCtlatRtAtt) {
      mapPsCtFltRtAtt.put(pscFRattribute.gf_psc_flat_attribute_id__c, pscFRattribute);
    }
    return mapPsCtFltRtAtt;
  }

  /**
  * @description return all falte rate account
  * @return Map<String, ps_catalog_flat_rates_attribute__c> map with all falte rate attributes.
  */
  public static Map<String, ps_catalog_flat_rates_account__c> getPSCatFlatRateAcct() {

    final PSCatalogFlatRatesAccount_Selector seleclatRateAcct = new PSCatalogFlatRatesAccount_Selector(true);
    final List<ps_catalog_flat_rates_account__c> psFlRtAccList = seleclatRateAcct.selectAll(100);
    final Map<String, ps_catalog_flat_rates_account__c> mappsFlRtAcc = new Map<String, ps_catalog_flat_rates_account__c>();

    for (ps_catalog_flat_rates_account__c pspsFlRtAccList : psFlRtAccList) {
      mappsFlRtAcc.put(pspsFlRtAccList.cuco__gf_psc_flat_rate_ac_svc_id__c, pspsFlRtAccList);
    }
    return mappsFlRtAcc;
  }

  /**
  * @description return all falte rate DP
  * @return Map<String, ps_catalog_flat_rates_attribute__c> map with all falte rate attributes.
  */
  public static Map<String, ps_catalog_flat_rates_dp__c> getPScatFlatRatesDP() {

    final PSCatalogFlatRatesDpSelector psctFalRtDpSelec = new PSCatalogFlatRatesDpSelector(true);
    final List<ps_catalog_flat_rates_dp__c> lstPscatFlatDp = psctFalRtDpSelec.selectAll();
    final Map<String, ps_catalog_flat_rates_dp__c> mapPscatFlatDp = new Map<String, ps_catalog_flat_rates_dp__c>();

    for (ps_catalog_flat_rates_dp__c psCatFlatDp : lstPscatFlatDp) {
      mapPscatFlatDp.put(psCatFlatDp.cuco__gf_dynamic_pricing_item_id__c, psCatFlatDp);
    }
    return mapPscatFlatDp;
  }

  /**
  * @description return all falte rate DP
  * @return Map<String, ps_catalog_flat_rates_attribute__c> map with all falte rate attributes.
  */
  public static Map<String, ps_catalog_flat_rates_dp_attribute__c> getPScatFlatRatesDPattr() {

    final PSCatalogAttributesFlatRatesDpSelector pscFRDpAttrSelec = new PSCatalogAttributesFlatRatesDpSelector(true);
    final List<ps_catalog_flat_rates_dp_attribute__c> ltPsctFlatDpAtrr = pscFRDpAttrSelec.selectAllfields();
    final Map<String, ps_catalog_flat_rates_dp_attribute__c> mapPscFlatDpattr = new Map<String, ps_catalog_flat_rates_dp_attribute__c>();

    for (ps_catalog_flat_rates_dp_attribute__c psCatFlatDpAttr : ltPsctFlatDpAtrr) {
      mapPscFlatDpattr.put(psCatFlatDpAttr.cuco__gf_psc_dynamic_pricing_atrb_id__c, psCatFlatDpAttr);
    }
    return mapPscFlatDpattr;
  }

  /**
  * @description return Profitability Sheet Participants
  * @param participants : returned participants node from first service call
  * @return List<ProfitabilitySheet_Wrapper.Participant> list of PS participants wrapper.
  */
  private static List<ProfitabilitySheet_Wrapper.Participant> getParticipants(List<Object> participants) {

    final List<ProfitabilitySheet_Wrapper.Participant> participantsList = new List<ProfitabilitySheet_Wrapper.Participant>();
    Map<String,Id> validParticipants = new Map<String,Id>();

    final pa_general_configuration__mdt config = Utils.getGeneralConfiguration();
    final Type participantClass = Type.forName(config.participants_itf_name__c);
    final Participant_itf participantItf = (Participant_itf) participantClass.newInstance();
    final Set<String> participantIds = new Set<String>();

    for (Object objParticipant : participants) {
      final Map<String, Object> participant = (Map<String, Object>)objParticipant;
      if(!String.isEmpty((String)participant.get('interventionStartDate')) &&  Date.valueOf((String)participant.get('interventionStartDate')) <= date.today() && (String.isEmpty((String)participant.get('interventionEndDate')) || Date.valueOf((String)participant.get('interventionEndDate')) >= date.today())) {
        participantIds.add(participant.get('id') + 'C');
      }
    }

    validParticipants = participantItf.getParticipantsIds(participantIds);

    for(Id participantId : validParticipants.values()) {
      final ProfitabilitySheet_Wrapper.Participant wrapperParticipant = new ProfitabilitySheet_Wrapper.Participant();
      wrapperParticipant.id = participantId;
      participantsList.add(wrapperParticipant);
    }
    return participantsList;
  }

  /**
  * @description returns wrapper with Profitability Sheet info. this is a second service call called from getProfSheetFullDetails
  * @param profSheetId : profitability sheet Id
  * @param psDate : Date from first service call
  * @param responseMap : Map<String, Object> response data from first service call
  * @param psStatus : String Status response from first service call
  * @return Map<String,Object>, wrapper with Profitability Sheet info
  */
  private static Map<String,Object> callListProposalNotebookConditions(profitability_sheet__c profSheet, Date psDate, Map<String, Object> responseMap, String psStatus) {


    final Map<String,Object> returnMap = new Map<String,Object>();
    final ListProposalNotebookConditions_Helper service = new ListProposalNotebookConditions_Helper(profSheet.gf_profitability_sheet_id__c, psDate);
    final HttpResponse response = service.callWs();

    switch on response.getStatusCode() {
      when 204 {
        returnMap.put('success', false);
        returnMap.put('errorMessage', Label.no_ps_conditions_details);
      }
      when 200 {

        final ProfitabilitySheet_Wrapper wrapper = new ProfitabilitySheet_Wrapper();
        List<ProfitabilitySheet_Wrapper.Participant> participantsList = new List<ProfitabilitySheet_Wrapper.Participant>();
        final Map<String, Object> mapData = (Map<String, Object>) responseMap.get('data');
        final Map<String, Object> branchCode = (Map<String, Object>)mapData.get('branch');
        final Map<String, Object> segmentType = (Map<String, Object>)mapData.get('segmentType');
        final Map<String, Object> businessAgent = (Map<String, Object>)mapData.get('businessAgent');

        wrapper.id = profSheet.id;
        wrapper.code = profSheet.gf_profitability_sheet_id__c;
        wrapper.groupId = profSheet.participant_id__c;
        wrapper.status = psStatus;
        wrapper.branchCode = mapData.containsKey('branch') ? (String) branchCode.get('id') : '' ;
        wrapper.segment = mapData.containsKey('segmentType') ?  (String) segmentType.get('id') : '' ;
        wrapper.ownerCode = mapData.containsKey('businessAgent') ? (String) businessAgent.get('id') : '' ;
        wrapper.isSpecificContractsScope = mapData.containsKey('isSpecificContractsScope') ? (Boolean) mapData.get('isSpecificContractsScope') : false ;
        wrapper.isForcedManualManagement = false;
        wrapper.name = mapData.containsKey('name') ? (String) mapData.get('name') : '';

        if (mapData.containsKey('conditionsStartDate')) {
          wrapper.startDate = Date.valueOf((String)mapData.get('conditionsStartDate'));
        }

        if (mapData.containsKey('endDate')) {
          wrapper.endDate = Date.valueOf((String)mapData.get('endDate'));
        }

        if (mapData.containsKey('participants')) {
          participantsList = getParticipants((List<Object>)mapData.get('participants'));
        }

        wrapper.participantsList = participantsList;
        wrapper.conditionsList = new List<ProfitabilitySheet_Wrapper.Condition>();

        final Map<String, Object> response2Map = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        if(response2Map.containsKey('data')) {

          final Map<String, ps_catalog_condition_attribute__c> mapConditionAttributes = getConditionAttributes();
          final Map<String, ps_catalog_flat_rates_attribute__c> mapfrAttributes = getPSflatRateAttr();
          final Map<String, ps_catalog_flat_rates_account__c> mappscfrAccount = getPSCatFlatRateAcct();
          final Map<String, ps_catalog_flat_rates_dp_attribute__c> mappsFlatRatDPattr = getPScatFlatRatesDPattr();
          final Map<String, ps_catalog_flat_rates_dp__c> mappsFlatRatDP = getPScatFlatRatesDP();

          final Map<String, ProfitabilitySheet_Wrapper.Condition> conditions = new Map<String, ProfitabilitySheet_Wrapper.Condition>();
          final FlatRates_Wrapper FlatRateWrapper = new FlatRates_Wrapper();
          final List<FlatRates_Wrapper.FlatRatesAccount> flatRatesAccount = new List<FlatRates_Wrapper.FlatRatesAccount>();
          final List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList = new List<FlatRates_Wrapper.FlatRatesDP>();

          Integer fatrate = 0;
          Integer fatrateaccount = 0;
          Integer fatratedp = 0;
          String extendedPackage = null;

          for(Object objRecord : (List<Object>)response2Map.get('data')) {

            final Map<String, Object> recordMap = (Map<String, Object>)objRecord;
            if((String)recordMap.get('id') == 'extended.package') {
              extendedPackage = getAttributeValue((List<Object>)recordMap.get('formats'), 'TEXT');
              continue;
            }

            if (recordMap.get('conditionType') == 'SIMPLE' && isOriginValid(recordMap) && mapConditionAttributes.containsKey((String)recordMap.get('id'))) {

              ProfitabilitySheet_Wrapper.Condition condition = new ProfitabilitySheet_Wrapper.Condition();
              final ps_catalog_condition_attribute__c conditionAttribute = mapConditionAttributes.get((String)recordMap.get('id'));

              if (conditions.containsKey(conditionAttribute.gf_psc_condition_id__c)) {
                condition = (ProfitabilitySheet_Wrapper.Condition)conditions.get(conditionAttribute.gf_psc_condition_id__c);
              } else {
                condition.id = conditionAttribute.gf_psc_condition_id__c;
                condition.familyId = conditionAttribute.gf_psc_condition_id__r.gf_psc_family_id__c;
                condition.attributesList = new List<ProfitabilitySheet_Wrapper.Attribute>();
              }

              final List<ProfitabilitySheet_Wrapper.Attribute> attributesList = (List<ProfitabilitySheet_Wrapper.Attribute>)condition.attributesList;
              final ProfitabilitySheet_Wrapper.Attribute attribute = new ProfitabilitySheet_Wrapper.Attribute();

              attribute.id = conditionAttribute.gf_psc_atribute_id__c;
              attribute.condAttrId = conditionAttribute.Id;
              attribute.canonicalId = conditionAttribute.gf_psc_condition_attribute_id__c;
              attribute.value = getAttributeValue((List<Object>)recordMap.get('formats'), conditionAttribute.gf_psc_atribute_id__r.gf_psc_bknd_svc_format_type__c);

              final Map<String, Object> origin = (Map<String, Object>)recordMap.get('origin');
              final string originId = (String)origin.get('id');
              condition.source =  originId;
              attributesList.add(attribute);

              if(!conditions.containsKey(conditionAttribute.gf_psc_condition_id__c)) {
                conditions.put(conditionAttribute.gf_psc_condition_id__c, condition);
              }
            }

            if (recordMap.get('conditionType') == 'SIMPLE' && getoriginId(recordMap) == 'FLAT_INFORMATION' && mapfrAttributes.containsKey((String)recordMap.get('id'))) {
              fatrate= fatrate + 1;
              setFlatInfoWrapper( recordMap, FlatRateWrapper, mapfrAttributes);
            }
            if (recordMap.get('conditionType') == 'SIMPLE' && getoriginId(recordMap) == 'PROFIT_LOSS_ACCOUNT' && mappscfrAccount.containsKey((String)recordMap.get('id'))) {

              final FlatRates_Wrapper.FlatRatesAccount frateacc = new FlatRates_Wrapper.FlatRatesAccount();
              final ps_catalog_flat_rates_account__c flatRateAccAtt = mappscfrAccount.get((String)recordMap.get('id'));

              if (mappscfrAccount.containsKey(flatRateAccAtt.gf_psc_flat_rate_ac_svc_id__c)) {
                fatrateaccount = fatrateaccount + 1;
                frateacc.id = flatRateAccAtt.id;
                frateacc.usePercent =  decimal.valueof(getAttributeValue((List<Object>)recordMap.get('formats'), 'RATE'));
                flatRatesAccount.add(frateacc);
              }
            }

            if (getoriginId(recordMap) == 'DYNAMIC_PRICING' && mappsFlatRatDPattr.containsKey((String)recordMap.get('id')) ) {
              fatratedp = fatratedp + 1;
              //PS Catalog Flat Rates DP
              final ps_catalog_flat_rates_dp_attribute__c mpatRatesDP = mappsFlatRatDPattr.get((String)recordMap.get('id'));

              final FlatRates_Wrapper.FlatRatesDP flatRatesDP = new FlatRates_Wrapper.FlatRatesDP();
              Boolean exFrdp = false;
              Integer position;
              for (Integer i = 0; i<flatRatesDPList.size(); i++) {
                if (flatRatesDPList.get(i).id == mpatRatesDP.gf_psc_fr_dynamic_pricing_id__c ) {
                  position = i;
                  exFrdp = true;
                  break;
                }
              }
              if (exFrdp) {
                  final FlatRates_Wrapper.DPAttribute  dPAttribute = new FlatRates_Wrapper.DPAttribute();
                  final ps_catalog_flat_rates_dp_attribute__c psfatRadpAttr = mappsFlatRatDPattr.get((String)recordMap.get('id'));

                  dPAttribute.id = psfatRadpAttr.gf_psc_atribute_id__c;
                  dPAttribute.canonicalId = psfatRadpAttr.gf_psc_dynamic_pricing_atrb_id__c;
                  dPAttribute.value = getAttributeValue((List<Object>)recordMap.get('formats'), psfatRadpAttr.cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_format_type__c);
                  final List<String> decimalLstFlatDP = new List<String>{'Number', 'Currency', 'Percent'};
                  if (psfatRadpAttr.gf_psc_atribute_id__r.gf_stored_fnl_atrb_field_name__c != null){
                      if (decimalLstFlatDP.contains(psfatRadpAttr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c)) {
                          final Integer lengthValueDP = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + psfatRadpAttr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c).getDescribe().getPrecision();
                          final Integer decimalValueDP = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + psfatRadpAttr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c).getDescribe().getScale();
                          dPAttribute.lengthValue = String.valueOf(lengthValueDP);
                          dPAttribute.decimalValue = String.valueOf(decimalValueDP);
                          dPAttribute.isDecimal = true;
                      } else {
                        dPAttribute.isDecimal = false;
                      }
                  }
                  flatRatesDPList.get(position).dpAttributeList.add(dPAttribute);

                } else {

                  flatRatesDP.id = mpatRatesDP.gf_psc_fr_dynamic_pricing_id__c;
                  final ps_catalog_flat_rates_dp__c psfatRadp = mappsFlatRatDP.get((String)recordMap.get(mpatRatesDP.gf_psc_fr_dynamic_pricing_id__c));
                  flatRatesDP.visualizOrder = mpatRatesDP.cuco__gf_psc_fr_dynamic_pricing_id__r.cuco__gf_psc_fr_dp_visual_ord_number__c;
                  //PS Catalog Attribute
                  final List<FlatRates_Wrapper.DPAttribute> dPAttributeList = new List<FlatRates_Wrapper.DPAttribute>();
                  final FlatRates_Wrapper.DPAttribute  dPAttribute = new FlatRates_Wrapper.DPAttribute();
                  final ps_catalog_flat_rates_dp_attribute__c psfatRadpAttr = mappsFlatRatDPattr.get((String)recordMap.get('id'));

                  dPAttribute.id = psfatRadpAttr.gf_psc_atribute_id__c;
                  dPAttribute.canonicalId = psfatRadpAttr.gf_psc_dynamic_pricing_atrb_id__c;
                  dPAttribute.value = getAttributeValue((List<Object>)recordMap.get('formats'), psfatRadpAttr.cuco__gf_psc_atribute_id__r.cuco__gf_psc_bknd_svc_format_type__c);
                  dPAttribute.visualizOrder = psfatRadpAttr.gf_dp_atrb_vslztn_ord_number__c;
                  dPAttribute.destinyApiName = psfatRadpAttr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c;
                  dPAttribute.valueTypeName = psfatRadpAttr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c;
                  final List<String> decimalLstValuesFlat = new List<String>{'Number', 'Currency', 'Percent'};
                  if (psfatRadpAttr.gf_psc_atribute_id__r.gf_stored_fnl_atrb_field_name__c != null){
                      if (decimalLstValuesFlat.contains(psfatRadpAttr.gf_psc_atribute_id__r.gf_attribute_value_type_name__c)) {
                          final Integer lengthValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + psfatRadpAttr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c).getDescribe().getPrecision();
                          final Integer decimalValue = Schema.getGlobalDescribe().get('cuco__profitability_analysis_flat_rates_dp__c').getDescribe().fields.getMap().get('cuco__' + psfatRadpAttr.gf_psc_atribute_id__r.gf_stored_prps_atrb_field_name__c).getDescribe().getScale();
                          dPAttribute.lengthValue = String.valueOf(lengthValue);
                          dPAttribute.decimalValue = String.valueOf(decimalValue);
                          dPAttribute.isDecimal = true;
                      } else {
                        dPAttribute.isDecimal = false;
                      }
                  }
                  dPAttributeList.add(dPAttribute);
                  flatRatesDP.dpAttributeList = dPAttributeList;
                  flatRatesDPList.add(flatRatesDP);
                }
            }

          }

          checkFlatPriceValues(FlatRateWrapper);

          if(fatrate > 0) {
              if(fatrateaccount > 0) {
                FlatRateWrapper.flatRatesAccountList = flatRatesAccount;
              }
              if(fatratedp > 0) {
                FlatRateWrapper.flatRatesDPList = flatRatesDPList ;
              }
              wrapper.flatRates = FlatRateWrapper;
          }
          for (String key : conditions.keySet()) {
            final ProfitabilitySheet_Wrapper.Condition condition = (ProfitabilitySheet_Wrapper.Condition)conditions.get(key);
            if(!String.isEmpty(extendedPackage) && getExtendedPackageType(condition.source) && extendedPackage != 'DEFAULT_INTERNAL') {
              condition.sourceCode = extendedPackage;
            }
            wrapper.conditionsList.add(condition);
          }
        }

        // Insert package list information
        final List<Package_Wrapper> lstPackages = ProfitabilitySheet_Helper.includePackages(wrapper);
        if(!lstPackages.isEmpty()) {
          wrapper.packagesList = lstPackages;
        }

        returnMap.put('success', true);
        returnMap.put('profSheetDetails', wrapper);
      }
      when else {
        String error = null;
        Map<String,Object> errorMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        if (errorMap.containsKey('messages')) {
          List<Object> messageMapList = (List <Object>) errorMap.get('messages');
          Map<String,Object> messageMap = (Map<String,Object>) messageMapList[0];
          if (messageMap.containsKey('message')) {
            error = (String) messageMap.get('message');
          }
        }
        returnMap.put('success', false);
        returnMap.put('errorMessage', Label.error_ps_conditions_details + ' ' + error);
      }
    }
    return returnMap;
  }

  /**
  * @description returns wrapper with Profitability Sheet info from ASO servcie
  * @param profSheetId : profitability sheet Id
  * @return Map<String,Object>, wrapper with Profitability Sheet info
  */
  public static Map<String,Object> getProfSheetFullDetails(String profSheetId) {
    final ProfitabilitySheet_Selector selectorProfSheet = new ProfitabilitySheet_Selector(true);
    final List<profitability_sheet__c> profSheets = selectorProfSheet.selectById(new Set<Id>{profSheetId});

    Map<String,Object> returnMap = new Map<String,Object>();
    final GetProposalConditionsNotebook_Helper service = new GetProposalConditionsNotebook_Helper((String)profSheets[0].gf_profitability_sheet_id__c);

    final HttpResponse response = service.callWs();

    switch on response.getStatusCode() {
      when 204 {
        returnMap.put('success', false);
        returnMap.put('errorMessage', Label.no_ps_details);
      }
      when 200 {
        final Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        Date psDate;
        String psStatus = '';

        if (responseMap.containsKey('data')) {

          final Map<String, Object> mapData = (Map<String, Object>) responseMap.get('data');
          if (mapData.containsKey('status')) {
            final Map<String, Object> mapStatus = (Map<String, Object>) mapData.get('status');
            final String val = (String)mapStatus.get('id');
            switch on val {
              when 'ACTIVE', 'PENDING' {
                psDate = Date.today();
                psStatus = (val == 'ACTIVE') ? 'Valid' : 'Pending Request';
              }
              when 'EXPIRED' {
                psDate = Date.valueOf((String)mapData.get('endDate'));
                psStatus = 'Expired';
              }
              when 'CANCELED' {
                psDate = Date.valueOf((String)mapData.get('conditionsStartDate'));
                psStatus = 'Canceled';
              }
            }
          }
          returnMap = callListProposalNotebookConditions(profSheets[0], psDate, responseMap, psStatus);
        } else {
          returnMap.put('success', false);
          returnMap.put('errorMessage', Label.error_ps_details + ' ' + response.getBody());
        }
      }
      when else {
        String error = null;
        Map<String,Object> errorMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        if (errorMap.containsKey('messages')) {
          List<Object> messageMapList = (List <Object>) errorMap.get('messages');
          Map<String,Object> messageMap = (Map<String,Object>) messageMapList[0];
          if (messageMap.containsKey('message')) {
            error = (String) messageMap.get('message');
          }
        }
        returnMap.put('success', false);
        returnMap.put('errorMessage', Label.error_ps_details + ' ' + error);
      }
    }
    return returnMap;
  }

  /**
  * @description returns wrapper
  * @param recordMap : current record
  * @param flatRateWrapper : flate rate Wapper
  * @param mapfrAttributes : map of flate rate attributes
  * @return FlatRates_Wrapper, wrapper
  */
  public static FlatRates_Wrapper setFlatInfoWrapper(Map<String, Object> recordMap, FlatRates_Wrapper flatRateWrapper, Map<String, ps_catalog_flat_rates_attribute__c> mapfrAttributes) {
      final ps_catalog_flat_rates_attribute__c frAttribute = mapfrAttributes.get((String)recordMap.get('id'));
      switch on (String)recordMap.get('id') {
          when 'comflat.amount.type' {
            flatRateWrapper.priceType = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
          when 'comflat.fixed.amount' {
            flatRateWrapper.fixedAmount = Decimal.valueof(getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c));
          }
          when 'comflat.variable.amount' {
            flatRateWrapper.variableAmountDesc = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
          when 'comflat.payment.type' {
            flatRateWrapper.chargeType = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
          when 'comflat.charge.periodicity' {
            flatRateWrapper.periodicityChageType = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
          when 'comflat.currency' {
            flatRateWrapper.currencyType = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
          when 'comflat.payment.date' {
            flatRateWrapper.chargeDay = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
          when 'comflat.nonbusiness.payday.procedure' {
            flatRateWrapper.nonWorkingDayChargeMethod = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
          when 'comflat.account.unavailable.procedure' {
            flatRateWrapper.accWithoutBalanceMethod = getAttributeValue((List<Object>)recordMap.get('formats'), frAttribute.gf_psc_attribute_id__r.gf_psc_bknd_svc_format_type__c);
          }
      }
      return flatRateWrapper;
  }

  /**
  * @description Helper method to check flat price default values
  * @param flatRateWrapper : Flat Rate Wrapper to check values
  * @return FlatRates_Wrapper, flat rate wrapper with update values
  */
  private static FlatRates_Wrapper checkFlatPriceValues(FlatRates_Wrapper flatRateWrapper) {
    if (flatRateWrapper.priceType == null || String.isEmpty(flatRateWrapper.priceType)) {
      if (flatRateWrapper.fixedAmount == null) {
        flatRateWrapper.priceType = 'EF';
      } else {
        flatRateWrapper.priceType = 'IF';
      }
    }
    return flatRateWrapper;
  }
}