/*----------------------------------------------------------------------------------
    Author:        BBVA
    Company:       BBVA
    Description:   Testclass for SER_TransactionalMethods.

    History:
      <Date>          <Author>             <Description>
    10/06/2019    Javier Touchard        Initial version
-----------------------------------------------------------------------------------*/
@isTest
private class SER_TransactionalMethods_TEST {

  /*-----------------------------------------------------------------------
      Description: correctProductTEST.
  ------------------------------------------------------------------------*/
  @isTest
  static void correctProductTEST() {
    SER_Transactional__c serTrs;
    serTrs = new SER_Transactional__c(SER_Product_Text__c  = 'NET CASH AUXILIAR');
    insert serTrs;
    List<SER_Transactional__c> productList;
    productList = new List<SER_Transactional__c>();
    productList.add(serTrs);
    test.startTest();
    SER_TransactionalMethods.correctProduct(productList);
    System.assertEquals('BBVA NET CASH PORTUGAL AUXILIAR',serTrs.SER_Product_Text__c,'Error');
    test.stopTest();
  }
}