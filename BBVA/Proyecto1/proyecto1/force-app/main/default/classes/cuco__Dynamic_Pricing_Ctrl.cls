/**
  * ────────────────────────────────────────────────────────────────────
  * Dynamic_Pricing_Ctrl
  * Controller class for dynamic_pricing_cmp Lightning Component
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
  public with sharing class Dynamic_Pricing_Ctrl {
    // Private constructor to avoid sonar err
    @TestVisible
    private Dynamic_Pricing_Ctrl() {
    }

    /**
      * @description Returns a wrapper to show in the component
      * @param FlatRates_Wrapper flatRates : Wrapper received in the component
      * @return DP_Clasification_Wrapper
      */
    @AuraEnabled
    public static DP_Clasification_Wrapper getDP(FlatRates_Wrapper flatRates) {
        try {
            DP_Clasification_Wrapper flatWrapper = new DP_Clasification_Wrapper();
            final Map<String, ps_catalog_flat_rates_dp_attribute__c> mapDPAtt = new Map<String, ps_catalog_flat_rates_dp_attribute__c>();

            final List<ps_catalog_flat_rates_dp_attribute__c> catalogAtr = Dynamic_Pricing_Service.getData();

            for (ps_catalog_flat_rates_dp_attribute__c catalogDp : catalogAtr) {
                mapDPAtt.put(catalogDp.gf_psc_dynamic_pricing_atrb_id__c, catalogDp);
            }
            if (flatRates.flatRatesDPList != null && !flatRates.flatRatesDPList.isEmpty()) {
                flatWrapper = Dynamic_Pricing_Service.fillWrapper(flatRates.flatRatesDPList, mapDPAtt);
            }
            return flatWrapper;
        } catch (Exception e) {//NOSONAR
            throw new AuraHandledException(e.getMessage()); //NOSONAR
        }
    }
}