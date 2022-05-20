/**
  * ────────────────────────────────────────────────────────────────────
  * FlatRates Wrapper
  * Contains the FlatRates wrapper
  * ────────────────────────────────────────────────────────────────────
  * @author      Diego Martinez <diego.martinez.chollet.contractor@bbva.com>
  * @modifiedBy
  * @version     1.0
  * @created     2021-04-23
  * @modified
  * @systemLayer Domain
  * ────────────────────────────────────────────────────────────────────
  * @changes
  *
  * ────────────────────────────────────────────────────────────────────
  */
global class DP_Clasification_Wrapper {
    /**
      * @Description: String with price type
      */
    @AuraEnabled
    global List<CrossDPAtt> crossDPAttList { get; set; }

    /**
      * @Description: String with price type
      */
    global class CrossDPAtt {
        /**
          * @Description: String with price type
          */
        @AuraEnabled
        global String name { get; set; }

        /**
          * @Description: String with price type
          */
        @AuraEnabled
        global String value { get; set; }

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
    }

    /**
      * @Description: String with price type
      */
    @AuraEnabled
    global NonCrossDPTable nonCrossDPTable { get; set; }

    global class NonCrossDPTable{
        /**
          * @Description: String with price type
          */
        @AuraEnabled
        global List<String> headersList { get; set; }

        /**
          * @Description: String with price type
          */
        @AuraEnabled
        global List<Classification> classificationsList { get; set; }
    }

    /**
      * @Description: classification class
      */
    global class Classification {
        /**
          * @Description: name
          */
        @AuraEnabled
        global String name { get; set; }

        /**
          * @Description: String with price type
          */
        @AuraEnabled
        global List<NonCrossDP> nonCrossDPList { get; set; }
    }
    /**
      * @Description: Non Cross DP class
      */
    global class NonCrossDP {
        /**
          * @Description: String with price type
          */
        @AuraEnabled
        global List<NonCrossAttb> attValuesList { get; set; }
    }
    /**
      * @Description: Non Cross Attb obj
      */
    global class NonCrossAttb {
        /**
          * @Description: String with name
        */
        @AuraEnabled
        global String name { get; set; }
        /**
          * @Description: String with value
        */
        @AuraEnabled
        global String value { get; set; }
        /**
          * @Description: String with decimalValue
        */
        @AuraEnabled
        global String decimalValue { get; set; }

        /**
          * @Description: Boolean with isDecimal
        */
        @AuraEnabled
        global Boolean isDecimal { get; set; }
    }
}