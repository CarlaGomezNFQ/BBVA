/*
* Class controller for localClientSelect component
*/
public with sharing class LocalClientSelectCont {

  /**
  * SINGLETON PATTERN
  */
  private static LocalClientSelectCont instance;

  /**
  * Constructor
  */
  private LocalClientSelectCont() {
  }

  /**
  * getInstance
  */
  public static LocalClientSelectCont gtInstance() {
    if(instance == null) {
      instance = new LocalClientSelectCont();
    }
    return instance;
  }

  /*
  * Method to get countries of local clients related to global client. Cacheable porque se llama con wire
  */
  @AuraEnabled(cacheable=true)
  public static String gtLocalCountries(String clientCode) {
    /* Pendiente de modificar el country por el país de residencia cuando nos lo aprovisionen */
    final Set<String> countriesSet = new Set<String>{'ES','MX','CO','PE','AR','PY','CH'};
    final List<AggregateResult> localClients = new List<AggregateResult>([
      SELECT country_id__c FROM Local_Client__c WHERE Cib_Client__r.SER_CClient__c = :clientCode AND country_id__c IN :countriesSet GROUP BY country_id__c
    ]);

    final Schema.DescribeFieldResult fieldResult = Account.DES_Country_Client__c.getDescribe();
    final List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
    final Map<String,String> mapValueLabel = new Map<String,String>();
    for( Schema.PicklistEntry v : values) {
      mapValueLabel.put(v.getValue(),v.getLabel());
    }

    final List<WrapperClass> listWrapper = new List<WrapperClass>();
    for(AggregateResult gsm : localClients) {
      String labelCountry;
      labelCountry = mapValueLabel.get(String.valueOf(gsm.get('country_id__c')));
      listWrapper.add(new WrapperClass(labelCountry, String.valueOf(gsm.get('country_id__c'))));
    }
    return JSON.serialize(listWrapper);
  }



  /*
  * Method to get local clients related to global client
  */
  @AuraEnabled
  public static String gtLocalClients(String clientCode, String countryCode) {
    final List<Local_Client__c> localClients = new List<Local_Client__c>([
      SELECT Id, participant_name__c, unique_id__c FROM Local_Client__c WHERE Cib_Client__r.SER_CClient__c = :clientCode AND country_id__c = :countryCode ORDER BY Name desc
    ]);


    final List<WrapperClass> listWrapper = new List<WrapperClass>();
    for(Local_Client__c lclient : localClients) {
      listWrapper.add(new WrapperClass(lclient.unique_id__c + ' - ' + lclient.participant_name__c, lclient.Id));
    }

    return JSON.serialize(listWrapper);
  }

  /*
  * @author Global Desktop
  * @description construye la lista wrapper que devuelve la informacion al componente lightning
  */
  public class WrapperClass {

    //Nombre de la matrix
    private String localName; //NOSONAR

    //URL de la matriz
    private String localId; //NOSONAR

    /**
    * @author Global Desktop
    * @description Construye la clase wrapper
    */

    public WrapperClass(String nameIn, String idIn) {
      this.localName = nameIn;
      this.localId = idIn;
    }
  }

}