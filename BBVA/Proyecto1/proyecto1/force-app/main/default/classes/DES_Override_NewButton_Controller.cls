public class DES_Override_NewButton_Controller {

	@AuraEnabled
	public static String getDomain(){
		system.debug('>>>>> URL.getSalesforceBaseUrl().toExternalForm() : ' + URL.getSalesforceBaseUrl().toExternalForm());
		if(URL.getSalesforceBaseUrl().toExternalForm().contains('.cs')){
			system.debug('>>>>> URL.getSalesforceBaseUrl().toExternalForm().split(.cs)[0] : ' + URL.getSalesforceBaseUrl().toExternalForm().split('.cs')[0]);
			return URL.getSalesforceBaseUrl().toExternalForm().split('.cs')[0];
		}else{
			system.debug('>>>>> URL.getSalesforceBaseUrl().toExternalForm().split(.my)[0] : ' + URL.getSalesforceBaseUrl().toExternalForm().split('.my')[0]);
			return URL.getSalesforceBaseUrl().toExternalForm().split('.my')[0];
		}
		
		//return URL.getSalesforceBaseUrl().getHost().split('.cs83.my.salesforce.com')[0];
	}
	
	@AuraEnabled
	public static Id getOppsListViews() {
		Id listviewId;
		List<ListView> listviews = new List<ListView>([
			SELECT Id, Name FROM ListView WHERE SobjectType = 'Opportunity'
		]);
		listviewId = listviews.get(0).Id;
		// Perform isAccessible() check here
		return listviewId;
	}    
	@AuraEnabled
	public static Id getClientListViews() {
		Id listviewId;
		List<ListView> listviews = new List<ListView>([
			SELECT Id, Name FROM ListView WHERE SobjectType = 'Account'
		]);
		listviewId = listviews.get(0).Id;
		// Perform isAccessible() check here
		return listviewId;
	} 
	
	
}