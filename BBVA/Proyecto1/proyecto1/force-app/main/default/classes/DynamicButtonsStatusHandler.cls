@SuppressWarnings('sf:AvoidDeeplyNestedIfStmts')
/**
*
* @author: Global Desktop
*/
global with sharing class DynamicButtonsStatusHandler implements dwp_dbpn.DynamicButtonsStatusInterface {
    global Set<String> getDynamicButtonStatus(String recordId, String sObjectName) {
        Set<String> buttonsStatusSet = new Set<String>();

        if(sObjectName == 'Opportunity') {
            System.debug('ES OPP');
            buttonsStatusSet = opportunityButtons(recordId);
            buttonsStatusSet = wonButton(recordId, buttonsStatusSet);
            buttonsStatusSet = closeLostButton(recordId, buttonsStatusSet);
            buttonsStatusSet = reactivateButton(recordId, buttonsStatusSet);
        }
        return buttonsStatusSet;
    }

    private List<Opportunity> getOpportunity(String recordId) {
        return [SELECT Id, StageName, opportunity_correct_ind_type__c, gf_amiweb_opportunity_id__c, gf_workflow_opportunity_id__c FROM Opportunity WHERE Id = :recordId LIMIT 1];
    }

    private Set<String> opportunityButtons(String recordId) {
        final Set<String> buttonsStatusSet = new Set<String>();
        final List<Opportunity> opps = getOpportunity(recordId);
        final PRCPricingUtils pricingLogic = PRCPricingUtils.getInstance(); // Lógica funcionalidad Pricing

        if(!opps.isEmpty()) {
            final Opportunity opportunity = opps.get(0);

            //Add_sold_order_button
            final Set<String> validStages = new Set<String> {Label.DES_Approvals, Label.DES_Ready_to_close}; //StageNames válidos para ASO.
            final Boolean isSindication = [SELECT Count() FROM user WHERE Id = :UserInfo.getUserId() AND gf_user_syndicated_ind_type__c = true]>0;

            final Boolean showASOButton = validStages.contains(opportunity.StageName) && isSindication;
            //--Add_sold_order_button

            final UserRecordAccess canEdit = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId = :UserInfo.getUserId() AND RecordId = :recordId LIMIT 1];

            system.debug('>>>>> opportunity.StageName : ' + opportunity.StageName);
            System.debug('canEdit -> ' + canEdit.HasEditAccess);


            if(canEdit.HasEditAccess) {
                final set<String> oppStages = new set<String> { Label.DES_Proposal, Label.DES_Approvals, Label.DES_Ready_to_close };
                    final set<String> pdtoFamilies = new set<String> { 'GTB', 'IBF' };
                        final Map<Id, OpportunityLineItem> mapProducts = new Map<Id, OpportunityLineItem>([SELECT Id, product_scope_type__c, syndicated_loan_drawn_amount__c, Converted_Currency__c,
                                                                                                           opportunity_stage_type__c, DES_Product_Family__c, solution_classification_desc__c,
                                                                                                           subproduct_name__c, OpportunityId, bbva_prtcp_tranche_amount__c, Name, ProductCode,
                                                                                                           Opportunity.DES_Booking_Geography__c, solution_name_path_desc__c
                                                                                                           FROM OpportunityLineItem
                                                                                                           WHERE OpportunityId = :recordId
                                                                                                           AND DES_Product_Family__c IN :pdtoFamilies
                                                                                                           AND opportunity_stage_type__c IN :oppStages]);

                if(!mapProducts.isEmpty()) {
                    buttonsStatusSet.add('Amiweb');
                    final Boolean hasTemplate = [SELECT Count() from DES_Template__c WHERE opportunity_id__c = :recordId] > 0;
                    if(!hasTemplate) {
                        System.debug('has template? -> '+ hasTemplate);
                        buttonsStatusSet.addAll(validateNBC(mapProducts));
                    }
                }


                ////////// PRICING BUTTONS ///////////// -> aquí porque necesita la info de mapProducts
                //// Pricing Details button  ////
                if(opportunity.StageName != Label.DES_Draft && pricingLogic.displayAmiwebButton(opportunity, mapProducts.values()) ) {
                    buttonsStatusSet.add('Pricing_details');
                    system.debug('>>>>> Añadido botón de Pricing Details -> opportunity.StageName: ' + opportunity.StageName + ' ---- Product: ' + mapProducts.values().get(0).solution_classification_desc__c);
                }

                //// Pricing - Send to Workflow button  ////
                if(opportunity.StageName != Label.DES_Draft && pricingLogic.displayWorkflowButton(opportunity, mapProducts.values()) ) {
                    buttonsStatusSet.add('Send_to_Workflow');
                    system.debug('>>>>> Añadido botón de Pricing Sent to Workflow -> opportunity.StageName: ' + opportunity.StageName + ' ---- Product: ' + mapProducts.values().get(0).solution_classification_desc__c);
                }
                ///////////////////////////////////////

                //// Pricing - Download button  ////
                if(opportunity.StageName != Label.DES_Draft && pricingLogic.displayPricingSection(opportunity, mapProducts.values()) ) {
                    buttonsStatusSet.add('Download_Pricing');
                    system.debug('>>>>> Añadido botón de Download PDF Pricing -> opportunity.StageName: ' + opportunity.StageName + ' ---- Product: ' + mapProducts.values().get(0).solution_classification_desc__c);
                }
                ///////////////////////////////////////
            }

            ///////////////////////////////////////
            //// Confirm Opportunity Button    ////
            if ( opportunity.StageName == Label.DES_Ready_to_close && !opportunity.opportunity_correct_ind_type__c ) {
                buttonsStatusSet.add('Confirm_Opportunity');
            }

            if(showASOButton && addASOButton(recordId)) { //Si todas las validaciones y el product code son válidos se añade el botón de "Add sold order".
                buttonsStatusSet.add('Add_sold_order');
            }
            ///////////////////////////////////

            // INICIO MUESTRO BOTÓN DE MANDATE
            //if(opportunity.StageName != Label.DES_Draft
            //&& opportunity.oppy_substage_mandate_ind_type__c != Label.DES_YES) {
            // system.debug('>>>>> DENTRO');
            // buttonsStatusSet.add('Mandate');
            //}
            // FIN MUESTRO BOTÓN DE MANDATE
        }
        return buttonsStatusSet;
    }

    private Boolean addASOButton (String recordId) {
        final Set<String> validProductCode = new Set<String> {'codeCL', 'codeLBOs', 'codePFL'}; //NOSONAR //lista de productos para los que se muestra el botón.
            return [SELECT Count() FROM OpportunityLineItem WHERE OpportunityId = :recordId AND underwriting_agreement_type__c = 'Yes' AND ProductCode IN :validProductCode] > 0;
    }

    private Set<String> validateNBC(Map<Id, OpportunityLineItem> mapProducts) {
        final Set<String> buttonsStatusSet = new Set<String>();
        final Set<String> solClassDesc = new Set<String> { Label.DES_Project_Finance_Lending, Label.DES_Transaction_Trade_Finance, Label.DES_Structure_Trade_Finance, Label.DES_Corporate_Loans, Label.DES_Leverage_Buyout_LBOs, Label.DES_Working_Capital};

            ComponentNBC_Controller.SetMapCountryRegion();
        ComponentNBC_Controller.getTemplateConfigurationsList();
        System.debug('MAPREGION-> ' + ComponentNBC_Controller.mapCountryRegion);
        System.debug('LISTCONFIG-> ' + ComponentNBC_Controller.listTemConfigs);

        for(OpportunityLineItem oppl : mapProducts.values()) {
            if (solClassDesc.contains( oppl.solution_classification_desc__c )
                &&
                ComponentNBC_Controller.getTemplateId(oppl.solution_classification_desc__c, ComponentNBC_Controller.mapCountryRegion.get(oppl.Opportunity.DES_Booking_Geography__c), oppl.Converted_Currency__c, oppl.product_scope_type__c) != null
               ) {
                   buttonsStatusSet.add('Create_NBC');
                   break;
               }

        }
        return buttonsStatusSet;
    }

    /*
    * @author GlobalDesktop
    * @description wonButton
    */
    private Set<String> wonButton(String recordId, Set<String> buttonsStatusSet) {
      final Set<String> buttonsDefined = buttonsStatusSet;
      final Set<Id> usersOpp = new Set<Id>();
      String stage = '';

      final List<Opportunity> iOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :recordId];
      if(!iOpportunity.isEmpty()) {
        usersOpp.add(iOpportunity[0].OwnerId);
      }

      for(DES_Opportunity_Management_member__c member : [SELECT Id, DES_User__c, DES_User__r.Name, DES_Opportunity__r.owner.Name, DES_Opportunity__r.OwnerId, DES_Opportunity__r.StageName
      FROM DES_Opportunity_Management_member__c
      WHERE DES_Opportunity__c = :recordId]) {
        usersOpp.add(member.DES_User__c);
        if(stage == '') {
          stage = member.DES_Opportunity__r.StageName;
          usersOpp.add(member.DES_Opportunity__r.OwnerId);
        }
      }
      if(usersOpp.contains(UserInfo.getUserId()) && stage == Label.DES_Ready_to_close) {
        buttonsDefined.add('Won_Opportunity');
      }
      return buttonsDefined;
    }

    /*
    * @author GlobalDesktop
    * @description closeLostButton
    */
    private Set<String> closeLostButton(String recordId, Set<String> buttonsStatusSet) {
      final Set<String> buttonsDefined = buttonsStatusSet;
      final Set<Id> setUserId = new Set<Id>();
      String iStageName = '';

      final List<Opportunity> iOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :recordId];
      if(!iOpportunity.isEmpty()) {
        setUserId.add(iOpportunity[0].OwnerId);
      }

      for(DES_Opportunity_Management_member__c iOppMember : [SELECT Id,
                                                              DES_User__c,
                                                              DES_User__r.Name,
                                                              DES_Opportunity__r.owner.Name,
                                                              DES_Opportunity__r.OwnerId,
                                                              DES_Opportunity__r.StageName
                                                            FROM DES_Opportunity_Management_member__c
                                                            WHERE DES_Opportunity__c = :recordId]) {
        iStageName = iOppMember.DES_Opportunity__r.StageName;
        setUserId.add(iOppMember.DES_User__c);
        setUserId.add(iOppMember.DES_Opportunity__r.OwnerId);
      }

      if(setUserId.contains(UserInfo.getUserId()) && iStageName != Label.DES_Closed_Lose && iStageName != Label.DES_Closed_Won) {
        buttonsDefined.add('Close_Lost');
      }

      return buttonsDefined;
    }

    /*
    * @author GlobalDesktop
    * @description reactivateButton
    */
    private Set<String> reactivateButton(String recordId, Set<String> buttonsStatusSet) {
      final Set<String> buttonsDefined = buttonsStatusSet;
      final Set<Id> setUserId = new Set<Id>();
      String iStageName = '';
      String iReason = '';
      final List<Profile> lstProfileAdmBusn=[select id from profile where id=:UserInfo.getProfileId() and name =:system.Label.AdmBussinesProfile];

      final List<Opportunity> iOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE Id = :recordId];
      if(!iOpportunity.isEmpty()) {
        setUserId.add(iOpportunity[0].OwnerId);
      }

      for(DES_Opportunity_Management_member__c iOppMember : [SELECT Id,
                                                              DES_User__c,
                                                              DES_User__r.Name,
                                                              DES_Opportunity__r.owner.Name,
                                                              DES_Opportunity__r.OwnerId,
                                                              DES_Opportunity__r.StageName,
                                                              DES_Opportunity__r.DES_Reasons_Lost__c
                                                            FROM DES_Opportunity_Management_member__c
                                                            WHERE DES_Opportunity__c = :recordId]) {
        iStageName = iOppMember.DES_Opportunity__r.StageName;
        iReason = iOppMember.DES_Opportunity__r.DES_Reasons_Lost__c;
        setUserId.add(iOppMember.DES_User__c);
        setUserId.add(iOppMember.DES_Opportunity__r.OwnerId);
      }

      if(setUserId.contains(UserInfo.getUserId()) && iStageName == Label.DES_Closed_Lose && iReason == Label.Opportunity_expired) {
        buttonsDefined.add('Reactivate');
      }

     if( (iStageName == Label.DES_Closed_Lose ||iStageName == Label.DES_Closed_Won )&&  lstProfileAdmBusn.size()>0) {
        buttonsDefined.add('Reactivate');
      }

      return buttonsDefined;
    }
  }