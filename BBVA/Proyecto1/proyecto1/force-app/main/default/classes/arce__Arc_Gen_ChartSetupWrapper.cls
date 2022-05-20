/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_ChartSetupWrapper class
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
@SuppressWarnings('PMD.ExcessivePublicCount,PMD.ExcessiveParameterList')
public with sharing class Arc_Gen_ChartSetupWrapper {
  @AuraEnabled public Boolean enableButton{
    get;
    set;
  }
  @AuraEnabled public Integer maxLabelLength{
    get;
    set;
  }
  @AuraEnabled public Configuration config{
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
  public Arc_Gen_ChartSetupWrapper(Boolean enableButon, Integer maxLabelLength,String type,Boolean legend, String title, Boolean maintainAspectRatio, Boolean responsive,List<Boolean> axes){
    this.enableButton = enableButton;
    this.maxLabelLength = maxLabelLength;
    config = new Configuration(type,legend,title, maintainAspectRatio,responsive,  axes);
  }

  /**
  * ------------------------------------------------------------------------------------------------
  * @Name     Configuration class
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
  public class Configuration{
    @AuraEnabled public String type{
      get;
      set;
    }
    @AuraEnabled public ConfigOptions options{
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
    public Configuration(String type,Boolean legend, String title, Boolean maintainAspectRatio, Boolean responsive, List<Boolean> axes){
      this.type = type;
      options = new ConfigOptions(legend, title, maintainAspectRatio, responsive, axes);
    }
  }

  /**
  * ------------------------------------------------------------------------------------------------
  * @Name     ConfigOptions class
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
  public class ConfigOptions{
    @AuraEnabled public Legend legend {
      get;
      set;
    }
    @AuraEnabled public Title title {
      get;
      set;
    }
    @AuraEnabled public Boolean maintainAspectRatio {
      get;
      set;
    }
    @AuraEnabled public Boolean responsive {
      get;
      set;
    }
    @AuraEnabled public Scale scales {
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
    public ConfigOptions(Boolean legend, String title, Boolean maintainAspectRatio, Boolean responsive,List<Boolean> axes) {
      this.legend = new Legend(legend);
      this.title = new Title(title);
      this.maintainAspectRatio = maintainAspectRatio;
      this.responsive = responsive;
      scales = new Scale(axes);
    }
  }

  /**
  * ------------------------------------------------------------------------------------------------
  * @Name     Legend class
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
  public class Legend{
    @AuraEnabled public Boolean display{
      get;
      set;
    }
    @AuraEnabled public String position {
      get;
      set;
    }
    @AuraEnabled public Labels labels {
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
    public Legend(Boolean legend){
      position = 'right';
      display = legend;
      labels = new Labels(3);
    }
  }

    public class Labels{
        @AuraEnabled public Integer padding{
          get;
          set;
        }

        public Labels(Integer paddingLabel){
          padding = paddingLabel;
        }
    }

  /**
  * ------------------------------------------------------------------------------------------------
  * @Name     Title class
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
  public class Title{
    @AuraEnabled public Boolean display {
      get;
      set;
    }
    @AuraEnabled public Integer fontSize {
      get;
      set;
    }
      @AuraEnabled public String text {
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
    public Title(String title){
      display = false;
      fontSize = 12;
        if(String.isNotBlank(title)){
          display = true;
          text = title;
        }
    }
  }

  /**
  * ------------------------------------------------------------------------------------------------
  * @Name     Scale class
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
  public class Scale{
    @AuraEnabled public List<Axe> yAxes{
      get;
      set;
    }
    @AuraEnabled public List<Axe> xAxes{
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
    public Scale(List<Boolean> axes){
      yAxes = new List<Axe>();
      xAxes = new List<Axe>();
      for(Boolean display : axes){
        yAxes.add(new Axe(display));
        xAxes.add(new Axe(display));
      }
    }
  }

  public class Axe{
    @AuraEnabled public Boolean display{
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
    public Axe(Boolean display){
      this.display = display;
    }
  }
}