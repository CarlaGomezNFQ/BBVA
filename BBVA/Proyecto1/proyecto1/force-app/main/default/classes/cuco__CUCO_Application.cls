public with sharing class CUCO_Application {

    // Configure and create the SelectorFactory for this Application
    public static final bbvacep.fflib_Application.SelectorFactory SELECTOR =
        new bbvacep.fflib_Application.SelectorFactory(
            new Map<SObjectType, Type> {
                ps_catalog_family__c.SObjectType => PsCatalogFamily_Selector.class,
                ps_catalog_condition__c.SObjectType => PsCatalogCondition_Selector.class,
                profitability_analysis__c.SObjectType => ProfitabilityAnalysis_Selector.class,
                profitability_sheet__c.SObjectType => ProfitabilitySheet_Selector.class,
                pa_general_configuration__mdt.SObjectType => PaGeneralConfiguration_Selector.class,
                profitability_analysis_participant__c.SObjectType => PAParticipant_Selector.class,
                profitability_sheet_participant__c.SObjectType => ProfitabilitySheetParticipant_Selector.class,
                profitability_analysis_pkg_request__c.SObjectType => PAPackageRequest_Selector.class,
                client_package__c.SObjectType => ClientPackage_Selector.class,
                profitability_analysis_condition__c.SObjectType => ProfitabilityAnalysisCondition_Selector.class,
                profitability_sheet_condition__c.SObjectType => ProfitabilitySheetCondition_Selector.class,
                ps_catalog_condition_attribute__c.SObjectType => PsCatalogConditionAttribute_Selector.class,
                profitability_sheet__c.SObjectType => ProfitabilitySheet_Selector.class,
                ps_catalog_package__c.SObjectType => PsCatalogPackage_Selector.class,
                ps_catalog_condition_standard__c.SObjectType => PsCatalogConditionStandard_Selector.class,
                ps_catalog_pkg_condition__c.SObjectType => PsCatalogPkgCondition_Selector.class,
                profitability_analysis_flat_rates__c.SObjectType => ProfitabilityAnalysisFlatRates_Selector.class,
                ps_catalog_flat_rates_attribute__c.SObjectType => PsCatalogFlatRatesAttribute_Selector.class,
                profitability_analysis_flatrates_account__c.SObjectType => ProfitabilityAnalysFlatRateAcc_Selector.class,
                profitability_analysis_flat_rates_dp__c.SObjectType => ProfitabilityAnalysiFlatRateDp_Selector.class,
                ps_catalog_flat_rates_dp_attribute__c.SObjectType => ProfitabilityAnalFlatRateDpAtt_Selector.class,
                ps_catalog_attribute__c.SObjectType => PsCatalogAttribute_Selector.class,
                ps_catalog_flat_rates_account__c.SObjectType => PSCatalogFlatRatesAccount_Selector.class,
                profitability_analysis_external_document__c.SObjectType => PAExternalDocument_Selector.class,
                external_document_extension_icon__mdt.SObjectType => ExternalDocumentExtensionIcon_Selector.class
            });

    public static final String DEFAULTFIELDSET = 'cuco__Default';
}