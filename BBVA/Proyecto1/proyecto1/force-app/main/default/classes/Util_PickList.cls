/*
 *
 *	VASS - DSL
 *
 *	18/09/2018	-	Creación de la clase y creación de 2 métodos, 1 devuelve el nombre api correspondiente al valor de la picklist pasada
 *					como parámetro y la otra devuelve la label a partir de la label
 *
 *
**/
public with sharing class Util_PickList {
	// ESTE MAPA TENDRÁ LA LABEL COMO KEY Y EL API NAME COMO VALUE
	private static Map<String, Map<String, String>> mapaApiLabel;
	// ESTE MAPA TENDRÁ EL API NAME COMO KEY Y LA LABEL COMO VALUE
	private static Map<String, Map<String, String>> mapaLabelApi;

	/**
	 * Recoge la etiqueta de un valor de lista de seleccion a partir de su valor API
	 *
	 * @param objeto Objeto en el que se realiza la búsqueda
	 * @param campoDelObjeto Key con la que se realiza la búsqueda
	 * @return mapa que relaciona las etiquetas de valores de la lista con su valor API
	 */
	public static Map<String, String> getLabelFromAPI(String objeto, String campoDelObjeto){
		Map<String, String> mapaLabel = new Map<String, String>();
		if(objeto != null
		 && campoDelObjeto != null){
			if(mapaLabelApi == null){
				mapaLabelApi = new Map<String, Map<String, String>>();
			}
			if(!mapaLabelApi.containsKey(campoDelObjeto)){
				DescribeSObjectResult obj = Schema.getGlobalDescribe().get(objeto).getDescribe();
				DescribeFieldResult campo = obj.fields.getMap().get(campoDelObjeto).getDescribe();
				for(Schema.PicklistEntry valorCampo : campo.getPicklistValues()){
					mapaLabel.put(valorCampo.getValue(), valorCampo.getLabel());
				}
				mapaLabelApi.put(campoDelObjeto, mapaLabel);
			}
			mapaLabel = mapaLabelApi.get(campoDelObjeto);
		}
		//system.debug('>>>>Mapa Label - API ' + mapaLabel);
		return mapaLabel;
	}//FIN getLabelDesdeAPI

	/**
	* Recoge el valor API de un valor de lista de seleccion a partir de su etiqueta
	*
	* @param objeto Objeto en el que se realiza la búsqueda
	* @param campoDelObjeto Key para el que se realiza la búsqueda
	* @param valor Valor a buscar
	* @return valor API buscado a partir de la etiqueta
	*/
	public static String getAPIFromLabel(String objeto, String campoDelObjeto, String valor){
		String valorApi;
		if(objeto != null
		 && campoDelObjeto != null
		 && valor != null){
			if(mapaApiLabel == null){
				mapaApiLabel = new Map<String, Map<String, String>>();
			}
			if(!mapaApiLabel.containsKey(campoDelObjeto)){
				Map<String, String> mapaLabelApi = new Map<String, String>();
				DescribeSObjectResult obj = Schema.getGlobalDescribe().get(objeto).getDescribe();
				DescribeFieldResult campo = obj.fields.getMap().get(campoDelObjeto).getDescribe();
				for(Schema.PicklistEntry valorCampo : campo.getPicklistValues()){
					mapaLabelApi.put(valorCampo.getLabel(), valorCampo.getValue());
				}
				//system.debug('>>>>Mapa API - Label ' + mapaLabelApi);
				mapaApiLabel.put(campoDelObjeto, mapaLabelApi);
			}
			valorApi = mapaApiLabel.get(campoDelObjeto).get(valor);
		}
		//System.debug('>>>>valorApi: ' + valorApi);
		return valorApi;
	}//FIN getValorAPIDesdeLabel



	@AuraEnabled
	public static Map <String, String> getselectOptions(sObject objObject, String fld, String lookupObject) {
		system.debug('>>>>> objObject --->' + objObject);
		system.debug('>>>>> fld --->' + fld);
		system.debug('>>>>> lookupObject --->' + lookupObject);
        String segmentation = '';
        List<Account> lAcc = [SELECT id, DES_BBVA_Segmentation__c FROM Account WHERE id = :lookupObject];
       	if(lAcc != null && !lAcc.isEmpty()) {
            segmentation = lAcc.get(0).DES_BBVA_Segmentation__c;
        }
		Map <String, String> allOpts = new Map <String, String> ();
		// Get the object type of the SObject.
		Schema.sObjectType objType = objObject.getSObjectType();

		// Describe the SObject using its object type.
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

		// Get a map of fields for the SObject
		Map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();

		// Get the list of picklist values for this field.
		List < Schema.PicklistEntry > values =
		 fieldMap.get(fld).getDescribe().getPickListValues();

		// Add these values to the selectoption list.
		for (Schema.PicklistEntry a: values) {
			if(segmentation != null && segmentation != '' && segmentation == Label.DES_Segmentation_CIB){
				if(a.getLabel() == Label.DES_ROLE_SECONDARY_GB) {	
					allOpts.put(a.getLabel(), a.getValue());
				}
            } else {
                if(a.getLabel() == Label.DES_SCOPE_GLOBAL){
					allOpts.put(a.getLabel(), a.getValue());
				}
            }
		// allOpts.put(a.getLabel(), a.getValue());
		}
		system.debug('>>>>> allOpts ---->' + allOpts);
		return allOpts;
	}
}//FIN Util_Listas_Seleccion