/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Buttons_controller_Corp
* @Author   ivan.cons.contractor@bbva.com
* @Date     Created: 2020/05/27
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description this class is the controller for the table.
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-10-15 Add 'validateClass' field to generated JSON
* |2021-07-02 Added switch condition to Activity Split 2012
*
* ------------------------------------------------------------------------------------------------
*/
public with sharing class Arc_Gen_Buttons_controller_Corp {
    /**
    * --------------------------------------------------------------------------------------
    * @description class that contains the config of the table_content_per_analysis.
    * @param collectionType string to configure labels
    * @param recordId of the account
    * @return returns a json formated with the configurations of the buttons.
    * @example getButtonsJsonComponent(String collectionType, String recordId)
    **/
    public static String getButtonsJsonComponent(String collectionType, String recordId, String apiNameObject) {
        String collectionTypeLabel;
        String relatedField, fieldsApiName, modalCss, headerLabels = '';
        String validateClass;
        switch on collectionType {
            when 'Main_clients'{
                collectionTypeLabel = 'Subactivities';
                fieldsApiName = 'arce__sector_id__c,arce__Subsector_id__c,arce__gf_company_economic_actvy_id__c,arce__gf_subactivity_id__c,arce__Template_type__c,arce__gf_activity_split_per_type__c/:arce__gf_subindustry_weight_per__c';
                relatedField = 'arce__Activity_Splits__r';
                modalCss = 'slds-modal_large';
                validateClass = 'arce.Arc_Gen_Validate_ActivitySplits_Corp';
            }
            when 'Main_clients2012'{
                collectionTypeLabel = 'Subactivities 2012';
                fieldsApiName = 'arce__sector_id__c,arce__Subsector_id__c,arce__gf_company_economic_actvy_id__c,arce__gf_subactivity_id__c,arce__Template_type__c,arce__Country__c,arce__gf_activity_split_per_type__c/:arce__gf_subindustry_weight_per__c';
                relatedField = 'arce__Activity_Splits_2012__r';
                modalCss = 'slds-modal_large';
                validateClass = 'arce.Arc_Gen_Validate_ActivitySplits_Corp';
            }
            when 'Geographic_Splits'{
                collectionTypeLabel = 'Geographies';
                fieldsApiName = 'arce__Country__c,arce__gf_geography_split_per_type__c>arce__Account_has_Analysis__c/:arce__gf_geography_weight_per__c';
                relatedField = 'arce__Geographic_Splits__r';
                validateClass = 'arce.Arc_Gen_Validate_GeoSplits_Corp';
            }
        }
        String buttons = '{'+
            '"name": "arce:Arc_Gen_RRTM_Wrapper",'+
            '"inModalFromButton": {'+
                '"labelButton": "Manage ' + collectionTypeLabel + '",'+
                '"editMode": true,'+
                '"variantButton": "neutral",'+
                '"modalCss": "'+modalCss+'",'+
                '"iconButton": "",'+
                '"positionButton": "left",'+
                '"headerModal": "Manage ' + collectionTypeLabel + '",'+
                '"closeButtonModal": true,'+
                '"closeModalActionEvt":{'+
                    '"name":"cmpw:GBL_ComponentWrapperRefresh_Evt",'+
                    '"attributes": {"uniqueNameEvt":"'+collectionType+'"}'+
                '}'+
            '},'+
            '"attributes": {'+
                '"fieldsApiName":"'+fieldsApiName+'",'+
                '"relatedName":"'+relatedField+'",'+
                '"sObjectType":"'+apiNameObject+'",'+
                '"recordTypeName":"",'+
                '"headerLabels":"'+headerLabels+'",'+
                '"hideResetButton":true,'+
                '"readOnly":false,'+
                '"recordId":"'+recordId+'",'+
                '"uniqueNameEvt":"'+collectionType+'",'+
                '"apexClassSave":"'+validateClass+'"'+
            '}'+
        '}';
        return buttons;
    }
}