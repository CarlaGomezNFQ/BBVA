public interface MM_GBL_Integration_Authentication {
	HttpRequest applySecurity(HttpRequest request, MM_GBL_Authentication_Service__mdt authenticationConfig);
	MM_GBL_Application_Log__c resetToken(MM_GBL_Authentication_Service__mdt authenticationConfig);
	Boolean isAuthenticated(MM_GBL_Authentication_Service__mdt authenticationConfig);
}