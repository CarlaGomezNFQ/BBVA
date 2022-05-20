/**
  * ────────────────────────────────────────────────────────────────────
  * FlatRates Wrapper
  * Contains the FlatRates wrapper
  * ────────────────────────────────────────────────────────────────────
  * @author      Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-03-22
  * @modified
  * @systemLayer Domain
  * ────────────────────────────────────────────────────────────────────
  * @changes
  *
  * ────────────────────────────────────────────────────────────────────
  */
global class FlatRates_Wrapper{
    /**
      * @Description: String with price type
      */
    @AuraEnabled
    global String priceType{ get; set; }

    /**
      * @Description: Decimal with fixed amount
      */
    @AuraEnabled
    global Decimal fixedAmount{ get; set; }

    /**
      * @Description: String with variable amount
      */
    @AuraEnabled
    global String variableAmountDesc{ get; set; }

    /**
      * @Description: String with charge type
      */
    @AuraEnabled
    global String chargeType{ get; set; }

    /**
      * @Description: String with periodicity chage type
      */
    @AuraEnabled
    global String periodicityChageType{ get; set; }

    /**
      * @Description: String with currency type
      */
    @AuraEnabled
    global String currencyType{ get; set; }

    /**
      * @Description: String with charge day
      */
    @AuraEnabled
    global String chargeDay{ get; set; }

    /**
      * @Description: String with non working day charge method
      */
    @AuraEnabled
    global String nonWorkingDayChargeMethod{ get; set; }

    /**
      * @Description: String accounts without balance method
      */
    @AuraEnabled
    global String accWithoutBalanceMethod{ get; set; }

    /**
      * @Description: String with invoce comments
      */
    @AuraEnabled
    global String invoceComments{ get; set; }

    /**
      * @Description: String with account comments
      */
    @AuraEnabled
    global String accountComments{ get; set; }

    /**
      * @Description: String with request type
      */
    @AuraEnabled
    global String requestType{ get; set; }

    /**
      * @Description: List with flat rates account
      */
    @AuraEnabled
    global List<FlatRatesAccount> flatRatesAccountList{ get; set; }

    /**
      * @Description: Wrapper for flatRatesAccount object
      */
    global class FlatRatesAccount{
        /**
          * @Description: String with id of the flat rates account
          */
        @AuraEnabled
        global String id{ get; set; }

        /**
          * @Description: Decimal with use percent
          */
        @AuraEnabled
        global Decimal usePercent{ get; set; }
    }

    /**
      * @Description: List with flat rates DP
      */
    @AuraEnabled
    global List<FlatRatesDP> flatRatesDPList{ get; set; }

    /**
      * @Description: Wrapper for flatRatesDP object
      */
    global class FlatRatesDP implements Comparable{
        /**
          * @Description: String with id of the flat rates DP
          */
        @AuraEnabled
        global String id{ get; set; }

        /**
          * @Description: List with dp attribute
          */
        @AuraEnabled
        global List<DPAttribute> dpAttributeList{ get; set; }

        /**
          * @Description: Method to sort
          */
        global Integer compareTo(Object compareTo) {
            FlatRatesDP compareFlatRatesDP = (FlatRatesDP) compareTo;
            if (visualizOrder == compareFlatRatesDP.visualizOrder) {
              return 0;
            }
            if (visualizOrder > compareFlatRatesDP.visualizOrder) {
              return 1;
            }
            return -1;
        }

        /**
          * @Description: Visualization order
          */
        @AuraEnabled
        global Decimal visualizOrder{ get; set; }
    }

    /**
      * @Description: Wrapper for flatRatesDP object
      */
    global class DPAttribute implements Comparable{
        /**
          * @Description: String with id of dp attribute
          */
        @AuraEnabled
        global String id{ get; set; }

        /**
          * @Description: String with id of canonical
          */
        @AuraEnabled
        global String canonicalId{ get; set; }

        /**
          * @Description: String with value
          */
        @AuraEnabled
        global String value{ get; set; }

        /**
          * @Description: Visualization order
          */
        @AuraEnabled
        global Decimal visualizOrder{ get; set; }

        /**
          * @Description: Api name
          */
        @AuraEnabled
        global String destinyApiName{ get; set; }

        /**
          * @Description: Value type name
          */
        @AuraEnabled
        global String valueTypeName{ get; set; }

        /**
          * @Description: String with lengthValue of field
          */
        @AuraEnabled
        global String lengthValue { get; set; }

          /**
            * @Description: String with decimalValue of field
            */
        @AuraEnabled
        global String decimalValue { get; set; }

        /**
          * @Description: Boolean with isDecimal value
          */
        @AuraEnabled
        global Boolean isDecimal { get; set; }

        /**
          * @Description: Method to sort
          */
        global Integer compareTo(Object compareTo) {
            DPAttribute compareDPAttribute = (DPAttribute) compareTo;
            if (visualizOrder == compareDPAttribute.visualizOrder) {
              return 0;
            }
            if (visualizOrder > compareDPAttribute.visualizOrder) {
              return 1;
            }
            return -1;
        }
    }
}