@isTest
public class MM_GBL_Integration_Test {




	static testMethod void restTestServiceOKResponse() {
		
		String serviceName = 'Test';
		String request = '{"segmentCode": "02", "pageSize": "10"}';
		insert new MM_GBL_Rest_Services_Url__c(Name = 'Test', Url__c = 'https://service/ok');
		insert new MM_GBL_Rest_Services_Url__c(Name = 'GrantingTickets', Url__c = 'https://validation/ok');


		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MM_GBL_Integration_MockGenerator());
		MM_GBL_Integration_GenericService.resetToken(serviceName);
		String responseStr = MM_GBL_Integration_GenericService.invoke(serviceName, request).getBody();
		Test.stopTest();
		System.assert((responseStr.indexOf('foo') != -1), 'error response');


	}

	static testMethod void restTestServiceKOResponse() {

		String serviceName = 'Test';
		String request = '{"segmentCode": "02", "pageSize": "10"}';
		insert new MM_GBL_Rest_Services_Url__c(Name = 'Test', Url__c = 'https://service/ko');
		insert new MM_GBL_Rest_Services_Url__c(Name = 'GrantingTickets', Url__c = 'https://validation/ok');

		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MM_GBL_Integration_MockGenerator());
		MM_GBL_Integration_GenericService.resetToken(serviceName);
		String responseStr = MM_GBL_Integration_GenericService.invoke(serviceName, request).getBody();
		Test.stopTest();
		System.assert((responseStr.indexOf('403') != -1), 'error response');


	}


	static testMethod void restTestServiceMockResponse() {

		String serviceName = 'TestMock';
		String request = '{"segmentCode": "02", "pageSize": "10"}';
		insert new MM_GBL_Rest_Services_Url__c(Name = 'TestMock', Url__c = 'https://servicemock/ok');
		insert new MM_GBL_Rest_Services_Url__c(Name = 'GrantingTickets', Url__c = 'https://validation/ok');


		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MM_GBL_Integration_MockGenerator());
		String responseStr = MM_GBL_Integration_GenericService.invoke('TestMock', request).getBody();
		Test.stopTest();
		System.assert((responseStr.indexOf('foo') != -1), 'error response');

	}
}