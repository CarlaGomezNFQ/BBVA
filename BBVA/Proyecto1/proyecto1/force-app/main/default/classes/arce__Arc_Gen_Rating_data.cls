/**
* @File Name          : global class Arc_Gen_Rating_Data.cls
* @Description        : Class that obtains the data of the object Rating
* @Author             : eduardoefrain.hernandez.contractor@bbva.com
* @Group              : ARCE Team
* @Last Modified By   : eduardoefrain.hernandez.contractor@bbva.com
* @Last Modified On   : 16/07/2019 12:17:00
* @Changes  :
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    16/07/2019 12:17:00   eduardoefrain.hernandez.contractor@bbva.com     Initial version
* 1.1    22/07/2021 18:00:00   eduardoefrain.hernandez.contractor@bbva.com     Add STATUS_CALCULATED, STATUS_VALIDATE constants
* 1.2    06/05/2021            saimassimilianno.jordana.contractor@bbva.com    include arce__rar_rating_tool_id__c field in generalRatingData meth0d.
**/
global with sharing class Arc_Gen_Rating_data {
    /**
    * @Description: arce__status_type__c Calculated
    */
    public static final String STATUS_CALCULATED = '2';
    /**
    * @Description: arce__status_type__c Validated
    */
    public static final String STATUS_VALIDATE = '3';
    /**
    *-------------------------------------------------------------------------------
    * @description  Empty constructor
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 07/16/2019 14:50:32
    * @example private Arc_Gen_Rating_data()
    **/
        @TestVisible
        global Arc_Gen_Rating_data() {
        }
    /**
    *-------------------------------------------------------------------------------
    * @description  get basic fields of rating
    --------------------------------------------------------------------------------
    * @author eduardoefrain.hernandez.contractor@bbva.com
    * @date 07/16/2019 14:50:32
    * @param condition - String with the rating id
    * @return List < ratingId >
    * @example global static arce__rating__c generalRatingData(String ratingId)
    **/
        global static List<arce__rating__c> generalRatingData(List<String> ratingIds) {
            return [SELECT Id,arce__rating_id__c,arce__status_type__c,arce__rating_long_value_type__c,
                    arce__rating_short_value_type__c,arce__long_rating_value_type__c,arce__short_rating_value_type__c,
                    arce__total_rating_score_number__c,arce__pd_per__c,arce__rating_user_id__c, arce__rar_rating_tool_id__c,
                    arce__Diversification_Adjustment__c
                    FROM arce__rating__c
                    WHERE Id IN: ratingIds ];
        }
    }