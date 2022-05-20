/**
  * ────────────────────────────────────────────────────────────────────
  * Dynamic_Pricing_Service
  * Service class for Dynamic_Pricing_Ctrl
  * ────────────────────────────────────────────────────────────────────
  * @author     Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-04-28
  * @modified
  * @systemLayer Presentation
  * ────────────────────────────────────────────────────────────────────
  * @changes
  *
  * ────────────────────────────────────────────────────────────────────
  */
public with sharing class Dynamic_Pricing_Service {
    // Private constructor to avoid sonar err
    @TestVisible
    private Dynamic_Pricing_Service() {}

    /**
      * @description Call helper to get the data for the component
      * @return List<ps_catalog_flat_rates_dp_attribute__c>
      */
    public static List<ps_catalog_flat_rates_dp_attribute__c> getData() {
        PSCatalogAttributesFlatRatesDpSelector cataAtrSelector = new PSCatalogAttributesFlatRatesDpSelector(true);
        return cataAtrSelector.selectDP();
    }
    /**
      * @description Call helper to fill the DP Wrapper
      * @param List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList : List of Flat Rates DP
      * @param Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt : Map with catalog flat rates dp attributes
      * @return List<ps_catalog_flat_rates_dp_attribute__c>
      */
    public static DP_Clasification_Wrapper fillWrapper(List<FlatRates_Wrapper.FlatRatesDP> flatRatesDPList, Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt) {
        return Dynamic_Pricing_Helper.fillWrapper(flatRatesDPList, mapDPAtt);
    }
}