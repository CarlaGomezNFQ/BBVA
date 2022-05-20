public class MM_GBL_Logger_Service {

    public static void flushLogList(List<MM_GBL_Application_Log__c> logList) {
        String uuid = getUuid();
        for (Integer i = 0; i < logList.size(); i++) {
            MM_GBL_Application_Log__c tmp = logList.get(i);
            tmp.Elapsed_Time__c = tmp.End_Time__c.getTime() - tmp.Start_Time__c.getTime();
            if (tmp.Message__c.length() > 131000) tmp.Message__c = tmp.Message__c.substring(0, 131000) + ' ... (' + (tmp.Message__c.length() - 131000).format() + ' chars more)'; 
            tmp.Transaction_Id__c = uuid;
            logList.set(i, tmp);
        }
        insert logList;
    }

    private static String getUuid() {
        String s = Datetime.now().getTime().format(); // or some other datetime
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(s));
        String uniqueString = EncodingUtil.convertToHex(hash);
        return uniqueString;
    }
}