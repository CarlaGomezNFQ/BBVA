/** ********************************************************************************
* @author       JSS
* @date         30/04/2020
* @description  Clase para testear la clase PRC_PriceAmortizationCSVCreator
* @Revision
********************************************************************************* */
@isTest
public class PRC_PriceAmortizationCSVCreator_TEST {
        public static testmethod void test_savePriceAmortization() {
         //INSERT DATA NEEDED
         PRC_TestUtils utils = new PRC_TestUtils();   
        
         //START TEST
         Test.startTest();
            List<PRC_Price_Amortization_Data__c>  padList = PRC_PriceAmortizationCSVCreator.savePriceAmortizationDataFromCSV((String) utils.amortization_csv_str, (String) utils.opp.Id);
         Test.stopTest();

         //ASSERTS
         System.assertNotEquals(0,padList.size());
     }
    
    
    
    public static testmethod void test_deletePriceAmortization() {
         //INSERT DATA NEEDED
         PRC_TestUtils utils = new PRC_TestUtils();
         List<PRC_Price_Amortization_Data__c>  padList = PRC_PriceAmortizationCSVCreator.savePriceAmortizationDataFromCSV((String) utils.amortization_csv_str, (String) utils.opp.Id);
        
         //START TEST
         Test.startTest();
            PRC_PriceAmortizationCSVCreator.deletePriceAmortizationData((String) utils.opp.Id);
         Test.stopTest();

         //ASSERTS
         List<PRC_Price_Amortization_Data__c>  padListAfter = PRC_PriceAmortizationCSVCreator.getPriceAmortizationData((String) utils.opp.Id);        
         System.assertEquals(0,padListAfter.size());
     }

}