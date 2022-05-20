/**
* @File Name          : Arc_Gen_ServiceAndSaveResponse.cls
* @Description        : Use as wraper by ASO services response
* @Author             : eduardoefrain.hernandez.contractor@bbva.com
* @Group              : ARCE
* @Last Modified By   : luisruben.quinto.munoz@bbva.com
* @Last Modified On   : 23/7/2019 19:35:30
* @Modification Log   :
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    30/4/2019  17:55:51   eduardoefrain.hernandez.contractor@bbva.com     Initial Version
* 1.1    17/1/2020  12:55:51   javier.soto.carrascosa@bbva.com                 Add createdRsr
* 1.2    02/04/2020 12:55:51   javier.soto.carrascosa@bbva.com                 Add serviceHeaders
**/
@JsonAccess(serializable='always' deserializable='always')
global class Arc_Gen_ServiceAndSaveResponse {
    @AuraEnabled global String serviceCode {get;set;}
    @AuraEnabled global String serviceMessage {get;set;}
    @AuraEnabled global String serviceResponse {get;set;}
    @AuraEnabled global String saveStatus {get;set;}
    @AuraEnabled global String saveMessage {get;set;}
    global Map<String,Object> updatefields {get;set;}
    /**
    *
    * @Description : Retrieves List of Salesforce Ids with created resources when needed
    */
    global List<Id> createdRsr {get;set;}
    /**
    *
    * @Description : Retrieves serviceHeaders when needed
    */
    global Map<String, String> serviceHeaders {get;set;}
}