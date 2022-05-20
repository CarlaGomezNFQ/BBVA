@RestResource(urlMapping='/deleteAccPayroll')
global with sharing class DES_WS_Delete_Account_Payroll {
 
    @HttpGet
    global static Id runBookingBatch(){
        Id batchInstanceId = Database.executeBatch(new DES_Batch_Delete_Account_Payroll(), 10000);
        system.debug('>>>>> id BATCH JO: ' + batchInstanceId);
        return batchInstanceId;
    }

}