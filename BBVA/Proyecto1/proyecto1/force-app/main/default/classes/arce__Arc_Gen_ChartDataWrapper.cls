/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ChartDataWrapper class
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
public with sharing class Arc_Gen_ChartDataWrapper {
  @AuraEnabled public List<Dataset> datasets {
    get;
    set;
  }
  @AuraEnabled public List<String> labels {
    get;
    set;
  }

  /**
  *-------------------------------------------------------------------------------
  * @Description Constructor
  *--------------------------------------------------------------------------------
  * @ Author ivan.cons.contractor@bbva.com
  * @ Date 2020/05/27
  *
  *--------------------------------------------------------------------------------
  **/
  public Arc_Gen_ChartDataWrapper(List<List<String>> dataList, List<String> backgroundColor,List<String> labels) {
      datasets = new List<Dataset>();
      for(List<String> data : dataList){
        datasets.add(new Dataset(data, backgroundColor));
      }
      this.labels = labels;
  }

  /**
  * ------------------------------------------------------------------------------------------------
  * @Name     Dataset class
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
  public class Dataset{
    @AuraEnabled public List<String> data {
      get;
      set;
    }
    @AuraEnabled public List<String> backgroundColor {
      get;
      set;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Constructor
    *--------------------------------------------------------------------------------
    * @ Author ivan.cons.contractor@bbva.com
    * @ Date 2020/05/27
    *
    *--------------------------------------------------------------------------------
    **/
    public Dataset(List<String> data, List<String> backgroundColor) {
      this.data = data;
      this.backgroundColor = backgroundColor;
    }
  }
}