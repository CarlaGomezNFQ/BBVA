@IsTest
public class MM_GBL_Logger_Service_TEST {

    @IsTest
    static void test_flushLogList(){
        
        /* ESPECIFICO DE CIB
         * Hacerlo genérico para el exportable
         */
        User user = UnitTestUtils.GetFISalesUser();
        insert user;            

        List<MM_GBL_Application_Log__c> als = new List<MM_GBL_Application_Log__c>();
        MM_GBL_Application_Log__c al = new MM_GBL_Application_Log__c();

        al.End_Time__c = Datetime.now();
        al.Start_Time__c = Datetime.now();
        al.Message__c = 'Test Message';
        al.Transaction_id__c = 'xxx';
        al.type__c = 'Integration';
        al.user__c = user.Id;

        als.add(al);

        al = new MM_GBL_Application_Log__c();
        al.End_Time__c = Datetime.now();
        al.Start_Time__c = Datetime.now();
        al.Message__c = 'Test Message2';
        al.Transaction_id__c = 'xxx2';
        al.type__c = 'Integration';
        al.user__c = user.Id;

        als.add(al);

        Test.startTest();
        MM_GBL_Logger_Service.flushLogList(als);
        Test.stopTest();
    }

}