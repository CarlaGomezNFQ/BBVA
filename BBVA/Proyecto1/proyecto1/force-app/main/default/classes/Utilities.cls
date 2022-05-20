/**
 * Using without sharing as need to run query on Organization table
 */
public without sharing class Utilities {

    //Get instance from INSTANCE.visual.force.com page so we can build
    public Static String getInstance(){
        String instance = '';
        Organization o = [SELECT OrganizationType, InstanceName FROM Organization limit 1];
        String orgType = o.OrganizationType;
        String insName = o.InstanceName;
        if(orgType == 'Developer Edition' || insName.startsWithIgnoreCase('cs')){
            List<String> parts = ApexPages.currentPage().getHeaders().get('Host').split('\\.');
            instance = parts[parts.size() - 4] + '.';
        }
        return instance;
    }
    //Needed in cases if current org is sandbox
    public static String getSubdomainPrefix(){
        Organization o = [SELECT OrganizationType, InstanceName FROM Organization limit 1];
        String orgType = o.OrganizationType;
        String insName = o.InstanceName;
        if(insName.startsWithIgnoreCase('cs')){
            return UserInfo.getUserName().substringAfterLast('.')+ '-';
        }
        return '';
    }

    /*-------------------------------------------------------------------------------------------------------------------------------------------------------
            Author:        Brian Capilla
            Company:       Accenture Cloud First
            Description:   metodo para obtener el prefijo del ID de un objeto por su nombre API
            
            History: 
            
            <Date>                <Author>                <Change Description>
             29/09/2017            Brian Capilla            Initial Version
            --------------------------------------------------------------------------------------------------------------------------------------------------------*/
    public static String getObjectPrefix(String objectName) {

        if(objectName != null && objectName != '' ){
            try{
                String keyPrefix = Schema.getGlobalDescribe().get(objectName).getDescribe().getKeyPrefix();
                return keyPrefix;
            }catch(Exception exc){
                System.debug('Exception getKeyPrefix'+ exc);
            }
        }
        return null;

    }
}