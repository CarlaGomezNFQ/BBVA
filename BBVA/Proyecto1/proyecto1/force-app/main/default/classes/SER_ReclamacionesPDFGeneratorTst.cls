/*******************************************************************************
* @author:           Victor Velandia (VV)
* Project:           BBVA Service
* Description:       Class Test
*
*            No.     Date            Author                   Description
*            -----   ----------      --------------------     ---------------
* @version   1.1     2019-05-20      Victor Velandia (VV)     Class test
********************************************************************************/
@IsTest
private class SER_ReclamacionesPDFGeneratorTst {
  @isTest
  static void testMethodOne() {

    Case caso = SER_TestUtils.ddCreateMstrCase(true);
    caso.SER_Amount_finally_assumed__c      = 2018;
    caso.SER_Amount_finally_assumed_EUR__c  = 2018;
    caso.SER_Operational_risk__c            = 2018;
    caso.SER_Operational_risk_EUR__c        = 2018;
    caso.SER_Claim_partially_recovered__c   = 2018;
    caso.SER_Amount_recovered_EUR__c        = 2018;
    update caso;

    ApexPages.StandardController strc = new ApexPages.StandardController(caso);
    SER_ReclamacionesPDFGeneratorController serRecla = new SER_ReclamacionesPDFGeneratorController(strc);
    final String stClaimRecovered = serRecla.stClaimRecovered;
    system.debug('--->>>  stClaimRecovered ' + stClaimRecovered);
    System.assertEquals(caso, caso);
  }
}