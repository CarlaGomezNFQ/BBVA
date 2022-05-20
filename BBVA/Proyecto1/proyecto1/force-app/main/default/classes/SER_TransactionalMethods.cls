/*Class to manage dialy loaded transactional records */
public with sharing class SER_TransactionalMethods {
  /*constructor, private to avoid singleton warning on sonar*/
  private SER_TransactionalMethods() {
  }
  /* Author:        Juan Carlos Terrón
    Company:       Accenture
    Description:   Brief Description

    IN:            IN
    OUT:           OUT

    History:
    <Date>                  <Author>                <Change Description>
    16/11/2017				Juan Carlos Terrón		Initial version */
  public static void correctProduct(List<SER_Transactional__c> news) {
    final Map<String,String> mapCross = new Map<String,String> {'NET CASH AUXILIAR'=>'BBVA NET CASH PORTUGAL AUXILIAR', 'NET CASH PRINCIPAL'=>'BBVA NET CASH PORTUGAL'};
    for(SER_Transactional__c transactional : news) {
      final String strProductText = mapCross.get(transactional.SER_Product_Text__c);
      if(String.isNotBlank(strProductText)) {
        transactional.SER_Product_Text__c = strProductText;
      }
    }
  }
}