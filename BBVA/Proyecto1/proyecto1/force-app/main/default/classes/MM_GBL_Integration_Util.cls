public class MM_GBL_Integration_Util {

	public static String getPassword(MM_GBL_Authentication_Service__mdt authServiceConfig) {
		Blob cryptoKey = EncodingUtil.base64Decode(authServiceConfig.CryptoKey__c);
		Blob encryptedPassword = EncodingUtil.base64Decode(authServiceConfig.Password__c);
		Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedPassword);
		// Decode the decrypted data for subsequent use
		return decryptedData.toString();
	}

	public static MM_GBL_Authentication_Service__mdt getAuthenticationConfig(String authServiceName) {
		MM_GBL_Authentication_Service__mdt authServiceConfig = null;
		authServiceConfig = [select Apex_Class__c, Custom_Setting__c, DeveloperName, Cache_Key__c,
		                     Cache_Partition__c, Header_Token__c, CryptoKey__c, Password__c, User__c, Service_Parameters__c from MM_GBL_Authentication_Service__mdt
		                     where DeveloperName = :authServiceName limit 1];
		return authServiceConfig;
	}

	public static MM_GBL_Authentication_Service__mdt getAuthenticationConfigFromService(String serviceName) {
		        MM_GBL_integration_service__mdt serviceConfig = null;

         serviceConfig = [select Http_Headers_LTA__c, Querystring_Input_Template_LTA__c, Http_Method__c, Custom_Setting__c, DeveloperName, Json_Input_Template_LTA__c, Authentication_Service__c from MM_GBL_integration_service__mdt
                         where DeveloperName = :serviceName limit 1];
                         return getAuthenticationConfig(serviceConfig.Authentication_Service__c);
	}


	// Provide the url from the MM_GBL_Rest_Services_Url__c custom settings from the specified input name
	public static String getUrlFromCustomSettings(String customSettingKey) {
		MM_GBL_Rest_Services_Url__c urlObj = null;
		try {
			urlObj = [select name, Url__c from MM_GBL_Rest_Services_Url__c
		          		where name = :customSettingKey limit 1];
			return urlObj.Url__c;
		} catch (Exception e) {
			return '';
		}
	}

	// Provide if logs are enabled from the MM_GBL_Rest_Services_Url__c custom settings from the specified input name
	public static Boolean isLogEnabledFromCustomSettings(String customSettingKey) {
		MM_GBL_Rest_Services_Url__c urlObj = null;
		try {
			urlObj = [select name, Enable_Log__c from MM_GBL_Rest_Services_Url__c
		          		where name = :customSettingKey limit 1];
			return urlObj.Enable_Log__c;
		} catch (Exception e) {
			return false;
		}
	}

	public static String getSimpleParamFromJSON(String jsonInput, String param) {
		// get the pair "key" : "value"
		try {
			Integer initPos = jsonInput.indexOf('"' + param + '"');
			String tmpstr = jsonInput.substring(initPos);
			Integer endPos = tmpstr.indexOf(',');
			if (endPos != -1)
				tmpstr = tmpstr.substring(0, endPos);
			// remove the "key" :
			tmpstr = tmpstr.substring(tmpstr.indexOf(':') + 1);
			// get the "value", string between ""
			tmpstr = tmpstr.substring(tmpstr.indexOf('"') + 1);
			tmpstr = tmpstr.substring(0, tmpstr.indexOf('"'));
			return tmpstr;
		} catch (Exception e) {
			return '';
		}
	}
}