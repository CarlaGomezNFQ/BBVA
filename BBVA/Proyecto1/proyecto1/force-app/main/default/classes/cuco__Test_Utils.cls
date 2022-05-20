/**
* ────────────────────────────────────────────────────────────────────
* Test_Utils
* Util class for test factory
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-08
* @modified
* @systemLayer Any
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('sf:DMLWithoutSharingEnabled, PMD.ExcessivePublicCount, PMD.AvoidGlobalModifier')
global class Test_Utils {

    // Private constructor to avoid sonar err
    @TestVisible
    private Test_Utils() {}

    /**
    * @description Method to create Account records for test purposes
    * @param num : Integer with number of new Account records to create
    * @return List<Account>: Records of Account ready to insert
    */
    global static List<Account> createAccounts(Integer num) {
        final List<Account> lstAccs = new List<Account>();
        for (Integer i = 0; i < num; i++) {
            final Account acc = new Account(
                Name = 'Account Test ' + i,
                AccountNumber = 'B' + String.valueOf(i).leftPad(8, '0')
            );
            lstAccs.add(acc);
        }
        return lstAccs;
    }

    /**
    * @description Method to create one Profitability Sheet record for test purposes
    * @param num : Integer with number of new Profitability Sheet records to create
    * @param accId: Id of the related account
    * @return List<profitability_sheet__c>: Records of Profitability Sheet ready to insert
    */
    global static List<profitability_sheet__c> createProfSheet(Account acc) {
        final List<profitability_sheet__c> lstPS = new List<profitability_sheet__c>();
        final profitability_sheet__c profSheet = new profitability_sheet__c(
            Name = 'Prof Sheet Test 0',
            gf_profitability_sheet_id__c = '00000',
            participant_id__c = acc.Id
        );
        lstPS.add(profSheet);
      return lstPS;
    }

    /**
    * @description Method to create one Profitability Analysis record for test purposes
    * @param num : Integer with number of new Profitability Sheet records to create
    * @param accId: Id of the related account
    * @return List<profitability_sheet__c>: Records of Profitability Sheet ready to insert
    */
    global static List<profitability_analysis__c> createProfAnalysis(Account acc) {
        final List<profitability_analysis__c> lstPA = new List<profitability_analysis__c>();
        final profitability_analysis__c profAnalysis = new profitability_analysis__c(
            Name = 'Prof Analysis Test 0',
            participant_id__c = acc.Id
        );
        lstPA.add(profAnalysis);
        return lstPA;
    }

    /**
    * @description Method to create Profitability Sheet records associated to one acc for test purposes
    * @param num : Integer with number of new Profitability Sheet records to create
    * @param accId: Id of the related account
    * @return List<profitability_sheet__c>: Records of Profitability Sheet ready to insert
    */
    global static List<profitability_sheet__c> createProfSheet(Integer num, Account acc) {
      final List<profitability_sheet__c> lstPS = new List<profitability_sheet__c>();
      for (Integer i = 0; i < num; i++) {
          final profitability_sheet__c profSheet = new profitability_sheet__c(
              Name = 'Prof Sheet Test ' + i,
              gf_profitability_sheet_id__c = String.valueOf(i).leftPad(5, '0'),
              participant_id__c = acc.Id
          );
          lstPS.add(profSheet);
      }
      return lstPS;
    }

    /**
    * @description Method to create Profitability Analysis records associated to one acc for test purposes
    * @param num : Integer with number of new Profitability Sheet records to create
    * @param accId: Id of the related account
    * @return List<profitability_sheet__c>: Records of Profitability Sheet ready to insert
    */
    global static List<profitability_analysis__c> createProfAnalysis(Integer num, Account acc) {
        final List<profitability_analysis__c> lstPA = new List<profitability_analysis__c>();
        for (Integer i = 0; i < num; i++) {
            final profitability_analysis__c profAnalysis = new profitability_analysis__c(
                Name = 'Prof Analysis Test ' + i,
                participant_id__c = acc.Id
            );
            lstPA.add(profAnalysis);
        }
        return lstPA;
    }

    /**
    * @description Method to create Profitability Sheet records for test purposes
    * @param num : Integer with number of new Profitability Sheet records to create
    * @param accId: Id of the related account
    * @return List<profitability_sheet__c>: Records of Profitability Sheet ready to insert
    */
    global static List<profitability_sheet__c> createProfSheet(Integer num, List<Account> lstAcc) {
        final List<profitability_sheet__c> lstPS = new List<profitability_sheet__c>();
        for (Integer i = 0; i < num; i++) {
            final profitability_sheet__c profSheet = new profitability_sheet__c(
                Name = 'Prof Sheet Test ' + i,
                gf_profitability_sheet_id__c = String.valueOf(i).leftPad(5, '0'),
                participant_id__c = lstAcc[i].Id
            );
            lstPS.add(profSheet);
        }
        return lstPS;
    }

    /**
    * @description Method to create Profitability Analysis records for test purposes
    * @param num : Integer with number of new Profitability Sheet records to create
    * @param accId: Id of the related account
    * @return List<profitability_sheet__c>: Records of Profitability Sheet ready to insert
    */
    global static List<profitability_analysis__c> createProfAnalysis(Integer num, List<Account> lstAcc) {
        final List<profitability_analysis__c> lstPA = new List<profitability_analysis__c>();
        for (Integer i = 0; i < num; i++) {
            final profitability_analysis__c profAnalysis = new profitability_analysis__c(
                Name = 'Prof Analysis Test ' + i,
                participant_id__c = lstAcc[i].Id
            );
            lstPA.add(profAnalysis);
        }
        return lstPA;
    }

    /**
    * @description Method to create Profitability Sheet Participants records for test purposes
    * @param num : Integer with number of new Profitability Sheet Participants records to create
    * @param profSheetId: Id of the related profitability sheet
    * @param List<Id>: List of related accs Ids to related to each prof sheet participant
    * @return List<profitability_sheet_participant__c>: Records of Profitability Sheet Participants ready to insert
    */
    global static List<profitability_sheet_participant__c> createProfSheetParticipant(Integer num, Id profSheetId, List<Id> lstAccIds) {
      final List<profitability_sheet_participant__c> lstPSP = new List<profitability_sheet_participant__c>();
      for (Integer i = 0; i < num; i++) {
          final profitability_sheet_participant__c profSheetParticipant = new profitability_sheet_participant__c(
              gf_profitability_sheet_id__c = profSheetId,
              participant_id__c = lstAccIds[i]
          );
          lstPSP.add(profSheetParticipant);
      }
      return lstPSP;
    }

    /**
    * @description Method to create Profitability Analysis Participants records for test purposes
    * @param num : Integer with number of new Profitability Sheet Participants records to create
    * @param profAnalysisId: Id of the related profitability analysis
    * @param List<Id>: List of related accs Ids to related to each prof sheet participant
    * @return List<profitability_analysis_participant__c>: Records of Profitability Analysis Participants ready to insert
    */
    global static List<profitability_analysis_participant__c> createProfAnalysisParticipant(Integer num, Id profAnalysisId, List<Id> lstAccIds) {
      final List<profitability_analysis_participant__c> lstPAP = new List<profitability_analysis_participant__c>();
      for (Integer i = 0; i < num; i++) {
        final profitability_analysis_participant__c profAnalysisParticipant = new profitability_analysis_participant__c(
              gf_profitablity_analysis_id__c = profAnalysisId,
              participant_id__c = lstAccIds[i]
          );
          lstPAP.add(profAnalysisParticipant);
      }
      return lstPAP;
    }

    /**
    * @description Method to create PS Catalog Package records for test purposes
    * @param num : Integer with number of new PS Catalog Package records to create
    * @param type: Type of the new PS Catalog Package
    * @return List<ps_catalog_package__c>: Records of PS Catalog Package ready to insert
    */
    global static List<ps_catalog_package__c> createPSCatalogPackage(Integer num, String type) {
        final List<ps_catalog_package__c> lstPsCatPkg = new List<ps_catalog_package__c>();
        for (Integer i = 0; i < num; i++) {
            final ps_catalog_package__c psCatPkg = new ps_catalog_package__c(
                gf_psc_package_active_ind_type__c = true,
                gf_psc_extended_pkg_ind_type__c = true,
                gf_psc_package_type_name__c = type,
                gf_psc_package_id__c = type + String.valueOf(i).leftPad(4, '0'),
                gf_psc_package_code_id__c = String.valueOf(i).leftPad(4, '0'),
                gf_psc_package_name__c = 'Pkg Name ' + i
            );
            lstPsCatPkg.add(psCatPkg);
        }
        return lstPsCatPkg;
    }

    /**
    * @description Method to create PS Catalog Pkg Condition record for test purposes
    * @param psCatPackage: ps_catalog_package__c record to fill PS Catalog Pkg Condition attributes
    * @param psCatCondition: ps_catalog_condition__c record to fill PS Catalog Pkg Condition attributes
    * @param isActive: Indicate if the new record is active or not
    * @return ps_catalog_pkg_condition__c: Record of PS Catalog Pkg Condition ready to insert
    */
    global static List<ps_catalog_pkg_condition__c> createPSCatalogPkgCondition(Integer num, ps_catalog_package__c psCatPackage, List<ps_catalog_condition__c> lstPSCatCondition) {
        final List<ps_catalog_pkg_condition__c> lstPSCatPkgCond = new List<ps_catalog_pkg_condition__c>();
        for (Integer i = 0; i < num; i++) {
            final ps_catalog_pkg_condition__c psCatPkgCond = new ps_catalog_pkg_condition__c(
                gf_psc_package_id__c = psCatPackage.Id,
                gf_psc_condition_id__c = lstPSCatCondition[i].Id,
                gf_psc_cond_pkg_act_ind_type__c = true,
                gf_psc_cond_pkg_id__c = psCatPackage.gf_psc_package_id__c + lstPSCatCondition[i].gf_psc_condition_id__c
            );
            lstPSCatPkgCond.add(psCatPkgCond);
        }
        return lstPSCatPkgCond;
    }

    /**
    * @description Method to create Client Package records for test purposes
    * @param num : Integer with number of new Client Package records to create
    * @param lstAcc: List of Accs related to each client pacakge
    * @param lstPkg: List of PS Catalog Package related to each client pacakge
    * @return List<ps_catalog_package__c>: Records of Client Package ready to insert
    */
    global static List<client_package__c> createClientPackage(Integer num, List<Account> lstAcc, List<ps_catalog_package__c> lstPkg) {
        final List<client_package__c> lstCP = new List<client_package__c>();
        for (Integer i = 0; i < num; i++) {
            final client_package__c cPkg = new client_package__c(
                participant_id__c = lstAcc[i].Id,
                gf_psc_package_code_id__c = lstPkg[i].Id,
                gf_cst_pkg_ct_srce_sys_st_type__c = 'V'
            );
            lstCP.add(cPkg);
        }
        return lstCP;
    }

    /**
    * @description Method to create Profitability Analysis Pkg Request records for test purposes
    * @param num : Integer with number of new Profitability Analysis Pkg Request records to create
    * @param profAnalysisId: Related profitability analysis id
    * @param requestType: Request type of prof analysis pkg req
    * @return List<profitability_analysis_pkg_request__c>: Records of Profitability Analysis Pkg Request ready to insert
    */
    global static List<profitability_analysis_pkg_request__c> createProfAnPkgReq(Integer num, Id profAnalysisId, String requestType) {
        final List<profitability_analysis_pkg_request__c> lstPAPkgReq = new List<profitability_analysis_pkg_request__c>();
        for (Integer i = 0; i < num; i++) {
            final profitability_analysis_pkg_request__c paPkgReq = new profitability_analysis_pkg_request__c(
                gf_profitablity_analysis_id__c = profAnalysisId,
                gf_pa_pkg_request_type_name__c = requestType,
                gf_pa_package_desc__c = 'DESCRIPTION PKG REQ ' + i
            );
            lstPAPkgReq.add(paPkgReq);
        }
        return lstPAPkgReq;
    }

    /**
    * @description Method to create User
    * @return usuario User created
    */
    global static User createUser() {
        final Profile profi = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        final User usuario = new User(
            FederationIdentifier = '1234',
            Username = 'testProfi@example.com',
            FirstName = 'firstName',
            LastName = 'profi',
            Email = 'testProfi@test.com',
            Alias = 'profi',
            TimeZoneSidKey='America/Los_Angeles',
            LocaleSidKey='en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = profi.Id,
            LanguageLocaleKey='en_US'
        );
        return usuario;
    }

    /**
    * @description Method to create Profitability Sheet Catalog Family
    * @param num : Integer, number of records to create
    * @return List<ps_catalog_family__c> : Records of PS Catalog Families
    */
    global static List<ps_catalog_family__c> createPSCatalogFamilies(Integer num) {
        final List<ps_catalog_family__c> families = new List<ps_catalog_family__c>();
        for (Integer i = 0; i < num; i++) {
            ps_catalog_family__c family = new ps_catalog_family__c (
                Name = 'Family ' + i,
                gf_psc_family_id__c = 'FAM' + i,
                gf_psc_family_product_name__c = 'Test Product',
                gf_psc_fmly_visual_ord_number__c = i,
                gf_psc_fmly_flat_sel_ind_type__c = true,
                gf_psc_family_avail_ind_type__c = true
            );
            families.add(family);
        }
        return families;
    }

    /*
    * @description Method to create Catalog Attributes. Creates one of each type.
    * @param num : Integer, number of records to create
    * @return List<ps_catalog_attribute__c>: Records of PS Catalog Attributes
    */
    global static List<ps_catalog_attribute__c> createPSCatalogAttributes(Integer num) {

        List<String> propsField = new List<String>{'gf_pa_cond_prps_pmg_number__c', 'gf_pa_cond_prps_bonus_per__c', 'gf_pa_cond_prps_prc_type_name__c', 'gf_pa_cond_prps_rate_code_type__c', 'gf_prps_pmail_exe_ind_type__c', 'gf_pa_cond_prps_rate_per__c', 'gf_pa_cond_prps_d_term_number__c', 'cuco__gf_pa_cond_prps_dff_pmg_number__c', 'gf_pa_cond_prp_ch_ex_ind_type__c', 'gf_pa_cond_prps_fix_amount__c', 'gf_prps_pmail_comp_exp_amount__c', 'gf_prps_pmail_rturn_exp_amount__c', 'gf_prps_pmail_comp_exp_amount__c', 'gf_pa_cond_prps_max_amount__c', 'gf_pa_cond_prps_min_amount__c'};
        List<String> finalField = new List<String>{'gf_pscd_vld_pmg_number__c', 'gf_pscd_vld_bonus_per__c', 'gf_pscd_vld_price_type_name__c', 'gf_pscd_vld_rate_code_type__c', 'gf_pscd_pmail_exp_exe_ind_type__c', 'gf_pscd_valid_rate_per__c', 'gf_pscd_vld_days_term_number__c', 'gf_pscd_vld_diftl_pmg_number__c', 'gf_pscd_vld_chrg_exmp_ind_type__c', 'gf_pscd_vld_fix_amount__c', 'gf_pscd_pmail_exp_amount__c', 'gf_pscd_pmail_rturn_exp_amount__c', 'gf_pscd_pmail_comp_exp_amount__c', 'gf_pscd_vld_max_amount__c', 'gf_pscd_vld_min_amount__c'};
        List<String> typeName   = new List<String>{'Permillage', 'Percent', 'List', 'List', 'Checkbox', 'Percent', 'Number', 'Permillage', 'Checkbox', 'Currency', 'Currency', 'Currency', 'Currency', 'Currency', 'Currency'};

        final List<ps_catalog_attribute__c> attributes = new List<ps_catalog_attribute__c>();

        for (Integer i = 0; i < propsField.size(); i++) {
            ps_catalog_attribute__c attribute = new ps_catalog_attribute__c (
                Name = 'Attribute' + i,
                gf_psc_attribute_id__c = 'ATT' + i,
                gf_stored_prps_atrb_field_name__c = propsField[i],
                gf_stored_fnl_atrb_field_name__c = finalField[i],
                gf_attribute_value_type_name__c = typeName[i],
                gf_psc_atrb_vslztn_ord_number__c = i,
                gf_psc_atrb_flat_rate_ind_type__c = false,
                gf_psc_atrb_visible_ind_type__c = true
            );
            attributes.add(attribute);
        }
        return attributes;
    }

    /*
    * @description Method to create Catalog Attributes for flats
    * @param num : Integer, number of records to create
    * @return List<ps_catalog_attribute__c>: Records of PS Catalog Attributes
    */
    global static List<ps_catalog_attribute__c> createPSCatAtFlat(Integer num) {
        final List<ps_catalog_attribute__c> attributes = new List<ps_catalog_attribute__c>();

        for (Integer i = 0; i < num; i++) {
            final ps_catalog_attribute__c attribute = new ps_catalog_attribute__c (
                Name = 'Flat_Attribute' + i,
                gf_psc_attribute_id__c = 'Flat_ATT_' + i,
                gf_attribute_value_type_name__c = 'Permillage',
                gf_stored_fnl_atrb_field_name__c = 'cuco__gf_ps_fr_dp_annual_prc_amount__c',
                gf_stored_prps_atrb_field_name__c = 'cuco__gf_pa_fr_dp_annual_prc_amount__c',
                gf_psc_atrb_vslztn_ord_number__c = i,
                gf_psc_atrb_flat_rate_ind_type__c = false,
                gf_psc_atrb_visible_ind_type__c = true
            );
            attributes.add(attribute);
        }
        return attributes;
    }

    /*
    * @description Method to create Catalog Conditions.
    * @param num : Integer, number of records to create
    * @param family : ps_catalog_family__c, family of the conditions
    * @return List<ps_catalog_condition__c>: Records of PS Catalog Condition
    */
    global static List<ps_catalog_condition__c> createPSCatalogConditons(Integer num, ps_catalog_family__c family) {
        final List<ps_catalog_condition__c> conditions = new List<ps_catalog_condition__c>();
        for (Integer i = 0; i < num; i++) {
            ps_catalog_condition__c condition = new ps_catalog_condition__c (
                Name = 'Condition ' + i,
                gf_psc_condition_id__c = 'CON' + i,
                gf_psc_family_id__c = family.Id,
                gf_psc_cond_visual_ord_number__c = i,
                gf_psc_cond_avail_ind_type__c = true
            );
            conditions.add(condition);
        }
        return conditions;
    }

    /*
    * @description Method to create Catalog Flat Conditions.
    * @param num : Integer, number of records to create
    * @param family : ps_catalog_family__c, family of the conditions
    * @return List<ps_catalog_condition__c>: Records of PS Catalog Condition
    */
    global static List<ps_catalog_condition__c> createPSCatalogFlatConditons(Integer num, ps_catalog_family__c family) {
        final List<ps_catalog_condition__c> conditions = new List<ps_catalog_condition__c>();
        for (Integer i = 0; i < num; i++) {
            ps_catalog_condition__c condition = new ps_catalog_condition__c (
                Name = 'Condition ' + i,
                gf_psc_condition_id__c = 'CNF' + i,
                gf_psc_family_id__c = family.Id,
                gf_psc_cond_visual_ord_number__c = i,
                gf_psc_cond_avail_ind_type__c = true,
                gf_psc_cond_flat_rate_ind_type__c = true
            );
            conditions.add(condition);
        }
        return conditions;
    }

    /*
    * @description Method to create Catalog Condition Standard. Attribute and attr_Id have to be set afterwards
    * @param num : Integer, number of records to create
    * @return List<ps_catalog_condition_standard__c>: Records of PS Catalog Condition
    */
    global static List<ps_catalog_condition_standard__c> createPSCatalogConditonsStandard(Integer num) {
        final List<ps_catalog_condition_standard__c> stdConditions = new List<ps_catalog_condition_standard__c>();
        for (Integer i = 0; i < num; i++) {
            ps_catalog_condition_standard__c condition = new ps_catalog_condition_standard__c (
                gf_cond_atrb_max_val_name__c = '1000',
                gf_cond_atrb_min_val_name__c = '1',
                gf_cond_atrb_standard_val_name__c = '100'
            );
            stdConditions.add(condition);
        }
        return stdConditions;
    }

    /*
    * @description Method to create Profitability Analysis Conditions with all values filled for testing purposes
    * @param num : Integer, number of records to create
    * @param profAnalysis : profitability_analysis__c, profitability Analysis which will have the created conditions
    * @param condition : ps_catalog_condition__c catalog condition
    * @return List<profitability_analysis_condition__c>: Records of Profitability Analysis Condition
    */
    global static List<profitability_analysis_condition__c> createProfAnalysisConditons(Integer num, profitability_analysis__c profAnalysis, ps_catalog_condition__c condition) {

        final List<profitability_analysis_condition__c> paConditions = new List<profitability_analysis_condition__c>();
        for (Integer i = 0; i < num; i++) {
            profitability_analysis_condition__c paCondition = new profitability_analysis_condition__c (
                gf_profitablity_analysis_id__c  = profAnalysis.Id,
                gf_psc_condition_id__c = condition.Id,
                gf_pa_cond_prps_dff_pmg_number__c = 1.01,
                gf_pa_cond_prps_bonus_per__c  = 1.01,
                gf_pa_cond_prps_d_term_number__c  = 1,
                gf_pa_cond_prp_ch_ex_ind_type__c  = true,
                gf_pa_cond_prps_rate_per__c = 1.01,
                gf_pa_cond_prps_fix_amount__c = 1.01,
                gf_prps_pmail_comp_exp_amount__c  = 1.01,
                gf_prps_pmail_exe_ind_type__c = false,
                gf_prps_pmail_rturn_exp_amount__c = 1.01,
                gf_pa_cond_prps_max_amount__c = 1.01,
                gf_pa_cond_prps_min_amount__c = 1.01,
                gf_pa_cond_prps_pmg_number__c = 1.01,
                gf_pa_cond_prps_prc_type_name__c  = 'EF',
                gf_pa_cond_prps_rate_code_type__c = '01'
            );
            paConditions.add(paCondition);
        }
        return paConditions;
    }

    /*
    * @description Method to create Profitability Sheet Conditions with all values filled for testing purposes
    * @param num : Integer, number of records to create
    * @param profSheet : profitability_analysis__c, profitability Sheet which will have the created conditions
    * @param condition : ps_catalog_condition__c catalog condition
    * @return List<profitability_sheet_condition__c>: Records of Profitability Sheet Condition
    */
    global static List<profitability_sheet_condition__c> createProfSheetConditons(Integer num, profitability_sheet__c profSheet, ps_catalog_condition__c condition) {

        final List<profitability_sheet_condition__c> psConditions = new List<profitability_sheet_condition__c>();
        for (Integer i = 0; i < num; i++) {
            profitability_sheet_condition__c psCondition = new profitability_sheet_condition__c (
                gf_profitability_sheet_id__c  = profSheet.Id,
                gf_psc_condition_id__c = condition.Id,
                gf_pscd_vld_diftl_pmg_number__c = 1.01,
                gf_pscd_vld_bonus_per__c = 1.01,
                gf_pscd_vld_days_term_number__c = 1,
                gf_pscd_vld_chrg_exmp_ind_type__c = true,
                gf_pscd_valid_rate_per__c = 1.01,
                gf_pscd_vld_fix_amount__c = 1.01,
                gf_pscd_pmail_comp_exp_amount__c = 1.01,
                gf_pscd_pmail_exp_exe_ind_type__c = false,
                gf_pscd_pmail_exp_amount__c = 1.01,
                gf_pscd_pmail_rturn_exp_amount__c = 1.01,
                gf_pscd_vld_max_amount__c = 1.01,
                gf_pscd_vld_min_amount__c = 1.01,
                gf_pscd_vld_pmg_number__c = 1.01,
                gf_pscd_vld_price_type_name__c = 'EF',
                gf_pscd_vld_rate_code_type__c = '01'
            );
            psConditions.add(psCondition);
        }

        return psConditions;
    }

    /*
    * @description Method to create PS Catalog Conditon Attributes
    * @param num : Integer, number of records to create
    * @param condition : List of ps_catalog_condition__c catalog condition
    * @param attributes : List of ps_catalog_attribute__c catalog attribute
    * @return List<ps_catalog_condition_attribute__c>: PS Catalog Conditon Attribute
    */
    global static List<ps_catalog_condition_attribute__c> createPSCatalogConditonAttributes(Integer num, ps_catalog_condition__c condition, List<ps_catalog_attribute__c> attributes) {
        final List<ps_catalog_condition_attribute__c> conditionAttributes = new List<ps_catalog_condition_attribute__c>();
        for (Integer i = 0; i < num; i++) {
            ps_catalog_condition_attribute__c conditionAttribute = new ps_catalog_condition_attribute__c (
                gf_psc_condition_attribute_id__c = 'canonical.id.' + i,
                gf_psc_condition_id__c = condition.Id,
                gf_psc_atribute_id__c = attributes[i].Id,
                gf_psc_ca_vslztn_ord_number__c = i,
                gf_psc_cond_atrb_act_ind_type__c = true,
                gf_psc_fa_prc_aprvl_ind_type__c = true
            );
            conditionAttributes.add(conditionAttribute);
        }
        return conditionAttributes;
    }

    /*
    * @description Method to create Profitability Analysis Flat Rate
    * @param proAnalysisId : Id Profitability analysis List
    * @param requestType : requestType String
    * @return List<ps_catalog_condition_attribute__c> : Profitability Analysis Flat Rate
    */
    global static List<profitability_analysis_flat_rates__c> createPaFlatRate(List<Id> proAnalysisId, String requestType) {

        List<profitability_analysis_flat_rates__c> profAnalFlatRate = new List<profitability_analysis_flat_rates__c>();
        for (Id item : proAnalysisId) {
            profitability_analysis_flat_rates__c flatRate = new profitability_analysis_flat_rates__c();
            flatRate.gf_profitablity_analysis_id__c = item;
            flatRate.gf_pa_fr_request_type__c = requestType;
            profAnalFlatRate.add(flatRate);
        }
        return profAnalFlatRate;
    }

    /*
    * @description Method to create data to packages ctrl test
    */
    global static void doPackagesTestSetup() {

        // Create parent acc
        final List<Account> lstCommPkgAcc = createAccounts(1);
        lstCommPkgAcc[0].AccountNumber = 'B99999999';
        insert lstCommPkgAcc;

        // Create child accs
        final List<Account> lstCommPkgChildAcc = createAccounts(32);
        for (Account acc : lstCommPkgChildAcc) {
            acc.ParentId = lstCommPkgAcc[0].Id;
        }
        insert lstCommPkgChildAcc;

        // Split child accs for sheet and analysis participant records
        final List<Id> lstCommPkgChildIdPSP = new List<Id>();
        final List<Account> lstCommPkgChildAccPSP = new List<Account>();
        final List<Id> lstCommPkgChildIdPAP = new List<Id>();
        final List<Account> lstCommPkgChildAccPAP = new List<Account>();

        // First 12 records to psp, rest (20) to pap
        for (Integer i = 0; i < 32; i++) {
            if (i < 12) {
                lstCommPkgChildIdPSP.add(lstCommPkgChildAcc[i].Id);
                lstCommPkgChildAccPSP.add(lstCommPkgChildAcc[i]);
            } else {
                lstCommPkgChildIdPAP.add(lstCommPkgChildAcc[i].Id);
                lstCommPkgChildAccPAP.add(lstCommPkgChildAcc[i]);
            }
        }

        // Create ps catalog package
        final List<ps_catalog_package__c> lstPSCatPkgCommPkg = new List<ps_catalog_package__c>();
        lstPSCatPkgCommPkg.addAll(Test_Utils.createPSCatalogPackage(11, 'F'));
        lstPSCatPkgCommPkg.addAll(Test_Utils.createPSCatalogPackage(12, 'C'));
        lstPSCatPkgCommPkg.addAll(Test_Utils.createPSCatalogPackage(8, 'G'));
        insert lstPSCatPkgCommPkg;

        // Create ps catalog family
        final List<ps_catalog_family__c> lstPSCF = createPSCatalogFamilies(1);
        insert lstPSCF;

        // Create ps catalog condition
        final List<ps_catalog_condition__c> lstPSCC = createPSCatalogConditons(2, lstPSCF[0]);
        insert lstPSCC;

        // Create profitability sheet
        final List<profitability_sheet__c> lstPSCommPkg = createProfSheet(2, lstCommPkgAcc[0]);
        insert lstPSCommPkg;

        // Create profitability sheet participant
        final List<profitability_sheet_participant__c> lstPSPCommPkg = createProfSheetParticipant(12, lstPSCommPkg[0].Id, lstCommPkgChildIdPSP);
        insert lstPSPCommPkg;

        // Create profitability sheet condition
        final List<profitability_sheet_condition__c> lstPSCCommPkg = createProfSheetConditons(3, lstPSCommPkg[0], lstPSCC[0]);
        lstPSCCommPkg[0].gf_ps_cond_atrb_srce_type_name__c = 'FORFAIT';
        lstPSCCommPkg[0].gf_ps_source_cust_package_id__c = 'B00000009F0004';
        lstPSCCommPkg[1].gf_ps_cond_atrb_srce_type_name__c = 'FORFAIT';
        lstPSCCommPkg[1].gf_ps_source_cust_package_id__c = 'B00000010F0005';
        lstPSCCommPkg[2].gf_ps_cond_atrb_srce_type_name__c = 'COMMERCIAL_PACKAGE';
        lstPSCCommPkg[2].gf_ps_source_cust_package_id__c = 'B00000011C0003';
        insert lstPSCCommPkg;

        // Create profitability analysis
        final List<profitability_analysis__c> lstPACommPkg = createProfAnalysis(2, lstCommPkgAcc[0]);
        lstPACommPkg[0].gf_pa_management_type_name__c = 'New';
        lstPACommPkg[0].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPACommPkg[0].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPACommPkg[0].gf_profitability_sheet_id__c = lstPSCommPkg[0].Id;
        lstPACommPkg[1].gf_pa_management_type_name__c = 'Cancellation';
        lstPACommPkg[1].gf_pa_mgmt_stage_type_name__c = 'Analysis';
        lstPACommPkg[1].gf_pa_mgmt_status_type_name__c = 'Analysis';
        lstPACommPkg[1].gf_profitability_sheet_id__c = lstPSCommPkg[1].Id;
        insert lstPACommPkg;

        // Create profitability analysis participant
        final List<profitability_analysis_participant__c> lstPAPCommPkg = createProfAnalysisParticipant(20, lstPACommPkg[0].Id, lstCommPkgChildIdPAP);
        insert lstPAPCommPkg;

        // Create profitability analysis condition
        final List<profitability_analysis_condition__c> lstPACCommPkg = createProfAnalysisConditons(5, lstPACommPkg[0], lstPSCC[1]);
        lstPACCommPkg[2].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPACCommPkg[2].gf_pa_source_cust_package_id__c = 'B00000021F0006';
        lstPACCommPkg[2].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPACCommPkg[2].gf_pa_source_cust_package_id__c = 'B00000022F0010';
        lstPACCommPkg[2].gf_pa_cond_atrb_source_type__c = 'FORFAIT';
        lstPACCommPkg[2].gf_pa_source_cust_package_id__c = 'B00000023F0011';
        lstPACCommPkg[2].gf_pa_cond_atrb_source_type__c = 'COMMERCIAL_PACKAGE';
        lstPACCommPkg[2].gf_pa_source_cust_package_id__c = 'B00000024C0008';
        lstPACCommPkg[2].gf_pa_cond_atrb_source_type__c = 'COMMERCIAL_PACKAGE';
        lstPACCommPkg[2].gf_pa_source_cust_package_id__c = 'B00000025C0009';
        insert lstPACCommPkg;

        // Create client packages
        final List<client_package__c> lstCP = new List<client_package__c>();
        final List<Account> lstAccPA2CP = new List<Account>{lstCommPkgChildAccPAP[0], lstCommPkgChildAccPAP[1], lstCommPkgChildAccPAP[2], lstCommPkgChildAccPAP[3], lstCommPkgChildAccPAP[4],
                                                            lstCommPkgChildAccPAP[5], lstCommPkgChildAccPAP[6], lstCommPkgChildAccPAP[7], lstCommPkgChildAccPAP[8], lstCommPkgChildAccPAP[9],
                                                            lstCommPkgChildAccPAP[10], lstCommPkgChildAccPAP[11], lstCommPkgChildAccPAP[12], lstCommPkgChildAccPAP[13]};
        final List<ps_catalog_package__c> lstPSCatPA2CP = new List<ps_catalog_package__c>{lstPSCatPkgCommPkg[6], lstPSCatPkgCommPkg[7], lstPSCatPkgCommPkg[8], lstPSCatPkgCommPkg[9], lstPSCatPkgCommPkg[10],
                                                                                        lstPSCatPkgCommPkg[25], lstPSCatPkgCommPkg[26], lstPSCatPkgCommPkg[27], lstPSCatPkgCommPkg[15], lstPSCatPkgCommPkg[16],
                                                                                        lstPSCatPkgCommPkg[17], lstPSCatPkgCommPkg[18], lstPSCatPkgCommPkg[19], lstPSCatPkgCommPkg[20]};
        final List<client_package__c> lstCPFromPA = createClientPackage(14, lstAccPA2CP, lstPSCatPA2CP);
        lstCPFromPA[12].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';
        lstCPFromPA[13].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';

        lstCP.addAll(lstCPFromPA);

        final List<ps_catalog_package__c> lstPSCatPS2CP = new List<ps_catalog_package__c>{lstPSCatPkgCommPkg[0], lstPSCatPkgCommPkg[1], lstPSCatPkgCommPkg[2], lstPSCatPkgCommPkg[3], lstPSCatPkgCommPkg[4],
                                                                                        lstPSCatPkgCommPkg[5], lstPSCatPkgCommPkg[11], lstPSCatPkgCommPkg[12], lstPSCatPkgCommPkg[13], lstPSCatPkgCommPkg[14],
                                                                                        lstPSCatPkgCommPkg[23], lstPSCatPkgCommPkg[24]};
        final List<client_package__c> lstCPFromPS = createClientPackage(12, lstCommPkgChildAccPSP, lstPSCatPS2CP);
        lstCPFromPS[4].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';
        lstCPFromPS[5].gf_cst_pkg_ct_srce_sys_st_type__c = 'A';
        lstCP.addAll(lstCPFromPS);
        insert lstCP;

        // Create profitability analysis pkg request
        final List<profitability_analysis_pkg_request__c> lstPAPkgReqCommPkg = createProfAnPkgReq(6, lstPACommPkg[0].Id, 'New');
        lstPAPkgReqCommPkg[0].participant_id__c = lstPAPCommPkg[14].Id;
        lstPAPkgReqCommPkg[0].gf_psc_package_id__c = lstPSCatPkgCommPkg[9].Id; //F0010
        lstPAPkgReqCommPkg[0].gf_pa_pkg_charge_pdicy_type__c = 'D';
        lstPAPkgReqCommPkg[0].gf_pa_pkg_request_type_name__c = 'New';
        lstPAPkgReqCommPkg[1].participant_id__c = lstPAPCommPkg[15].Id;
        lstPAPkgReqCommPkg[1].gf_psc_package_id__c = lstPSCatPkgCommPkg[21].Id; //C0010
        lstPAPkgReqCommPkg[1].gf_pa_pkg_charge_pdicy_type__c = 'S';
        lstPAPkgReqCommPkg[1].gf_pa_pkg_request_type_name__c = 'Modification';
        lstPAPkgReqCommPkg[2].participant_id__c = lstPAPCommPkg[16].Id;
        lstPAPkgReqCommPkg[2].gf_psc_package_id__c = lstPSCatPkgCommPkg[22].Id; //C0011
        lstPAPkgReqCommPkg[2].gf_pa_pkg_charge_pdicy_type__c = 'Q';
        lstPAPkgReqCommPkg[2].gf_pa_pkg_request_type_name__c = 'Extension';
        lstPAPkgReqCommPkg[2].gf_pa_pkg_ext_req_st_type_name__c = 'Add';
        lstPAPkgReqCommPkg[3].participant_id__c = lstPAPCommPkg[17].Id;
        lstPAPkgReqCommPkg[3].gf_psc_package_id__c = lstPSCatPkgCommPkg[27].Id; //G0005
        lstPAPkgReqCommPkg[3].gf_pa_pkg_charge_pdicy_type__c = 'M';
        lstPAPkgReqCommPkg[3].gf_pa_pkg_request_type_name__c = 'Extension';
        lstPAPkgReqCommPkg[3].gf_pa_pkg_ext_req_st_type_name__c = 'Remove';
        lstPAPkgReqCommPkg[4].participant_id__c = lstPAPCommPkg[18].Id;
        lstPAPkgReqCommPkg[4].gf_psc_package_id__c = lstPSCatPkgCommPkg[28].Id; //G0006
        lstPAPkgReqCommPkg[4].gf_pa_pkg_charge_pdicy_type__c = 'T';
        lstPAPkgReqCommPkg[4].gf_pa_pkg_request_type_name__c = 'Cancellation';
        lstPAPkgReqCommPkg[5].participant_id__c = lstPAPCommPkg[19].Id;
        lstPAPkgReqCommPkg[5].gf_psc_package_id__c = lstPSCatPkgCommPkg[29].Id; //G0007
        insert lstPAPkgReqCommPkg;
    }

    /*
    * @description Method to create PS Catalog Flat Rates Account. Creates one of each type.
    * @return List<ps_catalog_flat_rates_account__c>: Records of PS Catalog Flat Rates Account
    */
    global static List<ps_catalog_flat_rates_account__c> createPSCatFlatRatesAcc() {
        final List<String> acDesc = new List<String>{'Adeudos (IVA incluido), recibos no domiciliados', 'Órdenes de pago recibidas, dentro EEE y fuera, emisión cheques', 'Órdenes de pago emitidas, dentro EEE y fuera, recepción cheques', 'Transf. EEE, Nóminas, transf. urgentes, correo, swift canal oficina y telemático', 'Transferencias nacionales', 'Cuenta genérica con IVA para conceptos no contemplados en esta selección', 'Servicios telemáticos, net cash'};
        final List<String> acId = new List<String>{'57-02989-81', '57-02955-81', '57-02959-81', '57-17264-81', '57-02932-81', '57-01251-81', '57-02800-81'};
        final List<String> acSvcId = new List<String>{'comflat.debts.pyg.accounts.type', 'comflat.opr.pyg.accounts.type', 'comflat.ope.pyg.accounts.type', 'comflat.sepa.pyg.accounts.type', 'comflat.transfer.pyg.accounts.type', 'comflat.services.pyg.accounts.type', 'comflat.telematics.pyg.accounts.type'};

        final List<ps_catalog_flat_rates_account__c> lstPsCatFlatRatesAcc = new List<ps_catalog_flat_rates_account__c>();

        for (Integer i = 0; i < acDesc.size(); i++) {
            ps_catalog_flat_rates_account__c psCatFlatRatesAcc = new ps_catalog_flat_rates_account__c (
                gf_psc_flat_rate_ac_desc__c = acDesc[i],
                gf_psc_flat_rate_ac_id__c = acId[i],
                gf_psc_flat_rate_ac_svc_id__c = acSvcId[i],
                gf_psc_pkg_act_fr_ac_ind_type__c = true
            );
            lstPsCatFlatRatesAcc.add(psCatFlatRatesAcc);
        }
        return lstPsCatFlatRatesAcc;
    }

    /*
    * @description Method to create PS Catalog Attributes to flat test. Creates one of each type.
    * @return List<ps_catalog_attribute__c>: Records of PS Catalog Attributes
    */
    global static List<ps_catalog_attribute__c> createPSCatalogAttributesFlat() {

        List<String> nameLst = new List<String>{'Tipo de importe', 'Importe total anual', 'Modalidad de cargo', 'Periodicidad de cobro', 'Divisa', 'Día de cobro', 'Procedimiento día de cobro inhábil', 'Procedimiento cuenta sin disponible', 'Comentarios PyG', 'Comentarios facturación', 'Especificación importe variable'};
        List<String> unitTypeLst = new List<String>{'TEXT', 'AMOUNT', 'TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT'};
        List<String> storedAttbFieldNameLst = new List<String>{'gf_pa_fr_price_type__c', 'gf_pa_fr_fixed_annual_amount__c', 'gf_pa_fr_charge_type__c', 'gf_pa_fr_charge_pdicy_type__c', 'gf_pa_fr_currency_type__c', 'gf_pa_fr_charge_date_type__c', 'gf_pa_fr_pv_wrkdy_ch_meth_type__c', 'gf_pa_fr_ac_no_bal_method_type__c', 'gf_pa_fr_ac_comments_desc__c', 'gf_pa_fr_invoice_comments_desc__c', 'gf_pa_fr_variable_amount_desc__c'};
        List<String> valueTypeNameLst   = new List<String>{'List', 'Currency', 'List', 'List', 'List', 'List', 'List', 'List', 'Text', 'Text', 'Text'};

        final List<ps_catalog_attribute__c> lstPsCatAttb = new List<ps_catalog_attribute__c>();

        for (Integer i = 0; i < nameLst.size(); i++) {
            ps_catalog_attribute__c psCatAttb = new ps_catalog_attribute__c (
                Name = nameLst[i],
                gf_psc_bknd_svc_fmt_unit_type__c = unitTypeLst[i],
                gf_psc_bknd_svc_format_type__c = unitTypeLst[i],
                gf_stored_prps_atrb_field_name__c = storedAttbFieldNameLst[i],
                gf_attribute_value_type_name__c = valueTypeNameLst[i],
                gf_psc_attribute_id__c = 'ATT_F_' + i
            );
            lstPsCatAttb.add(psCatAttb);
        }
        return lstPsCatAttb;
    }

    /*
    * @description Method to create PS Catalog Flat Rates Attributes to flat test. Creates one of each type.
    * @param : List of ps_catalog_attribute__c to relate to each one
    * @return List<ps_catalog_flat_rates_attribute__c>: Records of PS Catalog Flat Rates Attributes
    */
    global static List<ps_catalog_flat_rates_attribute__c> createPSCatalogFlatRatesAttributes(List<ps_catalog_attribute__c> lstPsCatAttb) {

        List<String> flatAttbName = new List<String>{'comflat.amount.type', 'comflat.fixed.amount', 'comflat.payment.type', 'comflat.charge.periodicity', 'comflat.currency', 'comflat.payment.date', 'comflat.nonbusiness.payday.procedure', 'comflat.account.unavailable.procedure', 'comflat.pygcomments', 'comflat.comments', 'comflat.variable.amount'};

        final List<ps_catalog_flat_rates_attribute__c> lstPsCatFlatRatesAttb = new List<ps_catalog_flat_rates_attribute__c>();

        for (Integer i = 0; i < lstPsCatAttb.size(); i++) {
            ps_catalog_flat_rates_attribute__c psCatFlatRatesAttb = new ps_catalog_flat_rates_attribute__c (
                gf_psc_attribute_id__c = lstPsCatAttb[i].Id,
                gf_psc_atrb_active_fr_ind_type__c = true,
                gf_psc_flat_attribute_id__c = flatAttbName[i]
            );
            lstPsCatFlatRatesAttb.add(psCatFlatRatesAttb);
        }
        return lstPsCatFlatRatesAttb;
    }

    /*
    * @description Method to create Profitability Analysis FlatRates Account records.
    * @param lstPAFlatRate : List of profitability_analysis_flat_rates__c to add to new record
    * @param lstPsCatFlatRateAcc : List of ps_catalog_flat_rates_account__c to add to new record
    * @param lstUsePercent : List of gf_pa_fr_ac_use_per__c values to add to new record
    * @return List<profitability_analysis_flatrates_account__c>: New records created
    */
    global static List<profitability_analysis_flatrates_account__c> createPAFlatRatesAccounts(List<profitability_analysis_flat_rates__c> lstPAFlatRate, List<ps_catalog_flat_rates_account__c> lstPsCatFlatRateAcc, List<Decimal> lstUsePercent) {
        final List<profitability_analysis_flatrates_account__c> lstPAFlatRatesAccs = new List<profitability_analysis_flatrates_account__c>();
        for (Integer i = 0; i < lstPAFlatRate.size(); i++) {
            profitability_analysis_flatrates_account__c paFlatRateAcc = new profitability_analysis_flatrates_account__c (
                gf_pa_flat_rate_id__c = lstPAFlatRate[i].Id,
                gf_pa_flat_rate_account_id__c = lstPsCatFlatRateAcc[i].Id,
                gf_pa_fr_ac_use_per__c = lstUsePercent[i]
            );
            lstPAFlatRatesAccs.add(paFlatRateAcc);
        }
        return lstPAFlatRatesAccs;
    }

    /*
    * @description Method to create Profitability Sheet FlatRates Account records.
    * @param lstPSFlatRate : List of profitability_sheet_flat_rates__c to add to new record
    * @param lstPsCatFlatRateAcc : List of ps_catalog_flat_rates_account__c to add to new record
    * @param lstUsePercent : List of gf_ps_fr_ac_use_per__c values to add to new record
    * @return List<profitability_sheet_flat_rates_accounts__c>: New records created
    */
    global static List<profitability_sheet_flat_rates_accounts__c> createPSFlatRatesAccounts(List<profitability_sheet_flat_rates__c> lstPSFlatRate, List<ps_catalog_flat_rates_account__c> lstPsCatFlatRateAcc, List<Decimal> lstUsePercent) {
        final List<profitability_sheet_flat_rates_accounts__c> lstPSFlatRatesAccs = new List<profitability_sheet_flat_rates_accounts__c>();
        for (Integer i = 0; i < lstPSFlatRate.size(); i++) {
            profitability_sheet_flat_rates_accounts__c psFlatRateAcc = new profitability_sheet_flat_rates_accounts__c (
                gf_ps_flat_rate_id__c = lstPSFlatRate[i].Id,
                gf_ps_flat_rate_account_id__c = lstPsCatFlatRateAcc[i].Id,
                gf_ps_fr_ac_use_per__c = lstUsePercent[i]
            );
            lstPSFlatRatesAccs.add(psFlatRateAcc);
        }
        return lstPSFlatRatesAccs;
    }

    /*
    * @description Method to create Profitability Analysis External Documents with all values filled for testing purposes
    * @param num : Integer, number of records to create
    * @param profAnalysisId : id of profitability Analysis which are related
    * @return List<profitability_analysis_external_document__c>: Records of Profitability Analysis External Documents
    */
    global static List<profitability_analysis_external_document__c> createPAExternalDoc(Integer num, Id profAnalysisId) {
        Date today = date.today();
        final List<String> extensionList = new List<String>{'pdf','jpg','doc','xml'};
        final List<profitability_analysis_external_document__c> paExtDocList = new List<profitability_analysis_external_document__c>();
        for (Integer i = 0; i < num; i++) {
            profitability_analysis_external_document__c paExtDoc = new profitability_analysis_external_document__c ();
            paExtDoc.cuco__gf_document_update_date__c = today - i;
            paExtDoc.cuco__gf_document_format_type__c = extensionList[i];
            paExtDoc.cuco__gf_document_id__c = 'id000'+ i;
            paExtDoc.cuco__gf_document_name__c = 'doc00' + i;
            paExtDoc.cuco__gf_external_operation_id__c = 'exOp000' + i;
            paExtDoc.cuco__gf_profitablity_analysis_id__c = profAnalysisId;
            paExtDocList.add(paExtDoc);
        }
        return paExtDocList;
    }
}