/**
* ────────────────────────────────────────────────────────────────────
* Alert_Ctrl
* Controller class for alert_cmp Lightning Component
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-02-04
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
public with sharing class Alert_Ctrl {

    // Private constructor to avoid sonar err
    @TestVisible
    private Alert_Ctrl() {}

    /**
    * @description Returns banner info to show on the current Profitability Sheet
    * @param profSheetId : Id of the Profitability Sheet
    * @return Alert_Wrapper, wrapper with the response info
    */
    @AuraEnabled
    public static Alert_Ctrl.Alert_Wrapper checkAnalysisInProgress(Id profSheetId) {
        try {
            final Alert_Ctrl.Alert_Wrapper retWrapper = new Alert_Ctrl.Alert_Wrapper();
            final ProfitabilitySheet_Selector profSheetSelector = new ProfitabilitySheet_Selector(false);
            final List<profitability_sheet__c> lstPS = profSheetSelector.selectById(new Set<Id>{profSheetId});

            if (lstPS.isEmpty()) {
              retWrapper.showBanner = false;
            } else {
                final ProfitabilityAnalysis_Selector profAnSelector = new ProfitabilityAnalysis_Selector(false);
                final List<profitability_analysis__c> lstPA = profAnSelector.selectByProfSheetNoClosedPA(new Set<Id>{profSheetId}, new Set<String>{lstPS[0].gf_profitability_sheet_id__c});
                if (lstPA.isEmpty()) {
                    retWrapper.showBanner = false;
                } else {
                    retWrapper.showBanner = true;
                    retWrapper.recordIdToNavigate = lstPA[0].Id;
                    switch on lstPA[0].gf_pa_management_type_name__c {
                        when 'Renewal' {
                            retWrapper.textToShow = Label.renewal_alert_msg;
                        }
                        when 'Novation' {
                            retWrapper.textToShow = Label.novation_alert_msg;
                        }
                        when 'Cancellation' {
                            retWrapper.textToShow = Label.cancellation_alert_msg;
                        }
                        when 'New' {
                            retWrapper.textToShow = Label.new_alert_msg;
                        }
                        when else {
                            retWrapper.textToShow = Label.default_alert_msg;
                        }
                    }
                }
            }
            return retWrapper;
        } catch (Exception e) { // NOSONAR
            throw new AuraHandledException(Label.generic_error + ' ' + e.getMessage()); // NOSONAR
        }
    }

    /**
    * @description Wrapper use to return info to the lightning component
    */
    public class Alert_Wrapper {

        /**
          * @description Boolean variable to set banner visibility
          */
        @AuraEnabled
        public Boolean showBanner {get; set;}

        /**
          * @description String variable to set text to show on banner
          */
        @AuraEnabled
        public String textToShow {get; set;}

        /**
          * @description String variable with the recordId to navigate onclick evt
          */
        @AuraEnabled
        public String recordIdToNavigate {get; set;}

        /**
          * @description Constructor of Alert_Wrapper class
          */
        public Alert_Wrapper() {
            this.showBanner = false;
        }
    }
}