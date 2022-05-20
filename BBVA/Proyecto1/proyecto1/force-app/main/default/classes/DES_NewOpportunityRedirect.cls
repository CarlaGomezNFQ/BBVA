public class DES_NewOpportunityRedirect {

    @AuraEnabled
    public static String getDomain(){
        return URL.getSalesforceBaseUrl().toExternalForm().split('.cs')[0];
        //return URL.getSalesforceBaseUrl().getHost().split('.cs83.my.salesforce.com')[0];
    }
    
}