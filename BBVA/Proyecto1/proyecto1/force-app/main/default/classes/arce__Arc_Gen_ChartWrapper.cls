/**
  * ------------------------------------------------------------------------------------------------
  * @Name     Arc_Gen_NewAnalysis_Controller
  * @Author   ivan.cons.contractor@bbva.com
  * @Date     Created: 2020/06/20
  * @Group    ARCE
  * ------------------------------------------------------------------------------------------------
  * @Description Controller of the new analysis clients generator
  * ------------------------------------------------------------------------------------------------
  * @Changes
  *
  * -----------------------------------------------------------------------------------------------
  */
@SuppressWarnings('PMD.VariableNamingConventions')
public with sharing class Arc_Gen_ChartWrapper {
    @AuraEnabled public Arc_Gen_ChartSetupWrapper JSON_Setup{
        get;
        set;
      }
    @AuraEnabled public Arc_Gen_ChartDataWrapper JSON_Data{
        get;
        set;
      }
}