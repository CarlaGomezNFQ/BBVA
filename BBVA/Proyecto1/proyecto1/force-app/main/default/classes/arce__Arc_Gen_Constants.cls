/**
* @File Name          : Arc_Gen_Constants.cls
* @Description        : Define all constantes used in ARCE
* @Group              : ARCE
* @Last Modified By   : eduardoefrain.hernandez.contractor@bbva.com
* @Last Modified On   : 10-13-2020
* @Changes
*==========================================================================================================================
* Ver         Date                     Author      		                       Modification
*==========================================================================================================================
* 1.0    27/04/2020 - 09:00     juanignacio.hita.contractor@bbva.com           Initial Version
* 1.1    26/05/2020 - 11:15     cesaroctavio.villanueva.cebal@bbva.com         Added short and long scale rating
* 1.2    23/06/2020 - 12:00     joseluis.garcia4.contractor@bbva.com           Add CUSTOMER_RELATION_ORPHAN constant.
* 1.3    07/07/2020 - 13:00     juanignacio.hita.contractor@bbva.com           Added group, client, orphan
* 1.3    16/07/2020 - 10:00     joseluis.garcia4.contractor@bbva.com           Add GROUP_ASSET_HEADER_TYPE_HEADER constant.
* 1.4    12/16/2020 - 17:00     mariohumberto.ramirez.contractor@bbva.com      Add RENOVATION_CODE constant
* 1.5    05/10/2020 - 10:00     joseluis.garcia4.contractor@bbva.com           Add TDBU_BOTTOM_UP and TDBU_TOP_DOWN constants.
* 1.6    13/10/2020 - 10:00     eduardoefrain.hernandez.contractor@bbva.com    Add MAXIMUM_FFSS_AGE constant.
* 1.7    04/01/2021 - 12:00     joseluis.garcia4.contractor@bbva.com           Add CUSTOMER_RELATION_NON_ORPHAN constant.
* 1.8    23/02/2021 - 14:00     juanignacio.hita.contractor@bbva.com           Add FAMILY_CONSGROUP, FAMILY_NOT_CONSGROUP,
*                                                                              FAMILY_ORPHAN and FAMILY_IRP constants.
**/
@SuppressWarnings('PMD.ExcessivePublicCount, PMD.LongVariable')
global class Arc_Gen_Constants {
    /**
        * @Description: Value of the arce__group_asset_header_type__c field for
        * header participant analysis.
    */
    global static final String GROUP_ASSET_HEADER_TYPE_HEADER = '1';
    /**
        * @Description: Value of the arce__analysis_customer_relation_type__c field for
        * non-orphan customers.
    */
    global static final String CUSTOMER_RELATION_NON_ORPHAN = '01';
    /**
        * @Description: Value of the arce__analysis_customer_relation_type__c field for
        * orphan customers.
    */
    global static final String CUSTOMER_RELATION_ORPHAN = '02';
    /**
        * @Description: Value of the arce__anlys_wkfl_cnsld_ffss_type__c field for
        * bottom-up AHAs.
    */
    global static final String TDBU_BOTTOM_UP = '1';
    /**
        * @Description: Value of the arce__anlys_wkfl_cnsld_ffss_type__c field for
        * top-down AHAs.
    */
    global static final String TDBU_TOP_DOWN = '2';
    /**
        * @Description: Value of Subprocess Renovation
    */
    global static final String SUBPROCESS_RENOVATION = '1';
    /**
        * @Description: Value of Subprocess New
    */
    global static final String SUBPROCESS_NEW = '2';
    /**
        * @Description: Value of Subprocess Modification
    */
    global static final String SUBPROCESS_MODIFICATION = '3';
    /**
        * @Description: Value of Subprocess Rating
    */
    global static final String SUBPROCESS_RATING = '4';
    /**
        * @Description: Constant Rating Type
    */
    global static final String RATING_TYPE = 'Rating';
    /**
        * @Description: Constant Preating Type
    */
    global static final String PRERATING_TYPE = 'Prerating';
    /**
        * @Description: Value of Stage "In Preparation"
    */
    global static final String STAGE_IN_PREPARATION = '1';
    /**
        * @Description: Value of Stage "In Sanction"
    */
    global static final String STAGE_IN_SANCTION = '2';
    /**
        * @Description: Value of Stage "Finalized"
    */
    global static final String STAGE_FINALIZED = '3';
    /**
        * @Description: Value of Status_Stage "Validating general checklist" in ARCE process
    */
    global static final String STATUS_VALIDATINGCHECKLIST = '01';
    /**
        * @Description: Value of Status_Stage "Preparing Analysis" in ARCE process
    */
    global static final String STATUS_PREPARING_ANALYSIS = '02';
    /**
        * @Description: Value of Status_Stage "ARCE Prepared" in ARCE process
    */
    global static final String STATUS_ARCE_PREPARED = '03';
    /**
        * @Description: Value of Status_Stage "Contrasting analysis" in ARCE process
    */
    global static final String STATUS_CONTRASTING_ANALYSIS = '04';
    /**
        * @Description: Value of Status_Stage "Pending Schedule Committee without Delegation" in ARCE process
    */
    global static final String STATUS_SCHEDULECOMMITTEEWDELEGATION = '05';
    /**
        * @Description: Value of Status_Stage "Pending Deciding Committee without Delegation" in ARCE process
    */
    global static final String STATUS_DECIDINGCOMMITTEEWDELEGATION = '06';
    /**
        * @Description: Value of Status_Stage "Pending Schedule in Committee" in ARCE process
    */
    global static final String STATUS_SCHEDULECOMMITTEE = '07';
    /**
        * @Description: Value of Status_Stage "Pending Sanction in Committee" in ARCE process
    */
    global static final String STATUS_SANCTIONCOMMITTEE = '08';
    /**
        * @Description: Value of Status_Stage "Preparing Analysis by Analyst" in ARCE process
    */
    global static final String STATUS_PREPARINGANALYSIS = '09';
    /**
        * @Description: Value of Status_Stage "Finalized Analysis" in ARCE process
    */
    global static final String STATUS_FINALIZEDANALYSIS = '10';
    /**
        * @Description: Constant Rating Status "Preparing Rating"
    */
    global static final String RAIP_STATUS_PREPARING = '11';
    /**
        * @Description: Value of Status_Stage "Contrasting Rating" in RAIP
    */
    global static final String RAIP_STATUS_CONTRASTING = '12';
    /**
        * @Description: Value of Status_Stage "Finalized Rating" in RAIP
    */
    global static final String RAIP_STATUS_FINALIZED = '13';
    /**
        * @Description: Short scale Rating
    */
    global static final String SHORT_SCALE_RATING = '1';
    /**
        * @Description: Long scale Rating
    */
    global static final String LONG_SCALE_RATING = '2';
    /**
        * @Description: String with value "Group"
    */
    global static final string S_GROUP = 'Group';
    /**
        * @Description: String with value "Client"
    */
    global static final string CLIENT = 'Client';
    /**
        * @Description: String with value "Orphan"
    */
    global static final string ORPHAN = 'Orphan';
    /**
        * @Description: String with value "Orphan"
    */
    global static final string SUBSID_S = 'subsidiary';
    /**
        * @Description: String with value "ren"
    */
    global static final string RENOVATION_CODE = 'ren';
    /**
        * @Description: String with value "1"
    */
    global static final string ONE_S = '1';
    /**
        * @Description: String with value "2"
    */
    global static final string TWO_S = '2';
    /**
        * @Description: String with value "3"
    */
    global static final string THREE_S = '3';
    /**
        * @Description: String with value "OK"
    */
    global static final string OK_S = 'OK';
    /**
        * @Description: String with value "GROUP"
    */
    global static final string GROUP_S = 'GROUP';
    /**
        * @Description: String with value "SUBSIDIARY"
    */
    global static final string SUBS_S = 'SUBSIDIARY';
    /**
        * @Description: Maximum number of months that makes a valid financial statement
    */
    global static final Integer MAXIMUM_FFSS_AGE = 18;
    /**
        * @Description: String with value " - "
    */
    global static final string HYPHEN = ' - ';
    /**
    * @Description: Consolidated group code for analysis_type field of analysis object
    */
    global static final String FAMILY_CONSGROUP = '1';
    /**
    * @Description: Not consolidated group code for analysis_type field of analysis object
    */
    global static final String FAMILY_NOT_CONSGROUP = '2';
    /**
    * @Description: Orphan code for analysis_type field of analysis object
    */
    global static final String FAMILY_ORPHAN = '3';
    /**
    * @Description: IRP Code for analysis_type field of analysis object
    */
    global static final String FAMILY_IRP = '4';
    /**
    * @Description: Sub workflow ARP type of RAIP creation
    */
    global static final String ADJ_WKF_PROCESS = 'ADJUSTED_RATING_PROCESS';
    /**
    * @Description: Sub workflow CRP type of RAIP creation
    */
    global static final String OVER_WFK_PROCESS = 'COMMITTEE_RATING_PROCESS';
    /**
    * @Description: Sub workflow IRP type of RAIP creation
    */
    global static final String INDEP_WFK_PROCESS = 'INDEPENDENT_RATING_PROCESS';



}