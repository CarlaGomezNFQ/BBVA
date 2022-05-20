/*-----------------------------------------------------------------------------
Author:         Alexander Munguía
Company:        BBVA
Description:    Clase Util para tratamiento de Queries del DynForm
Test Class:     Arc_Gen_DynForm_Utils_Test
History
<Date>          <Author>                <Change Description>
27-Oct-2020     Alexander Munguía           Versión inicial
-----------------------------------------------------------------------------*/
public with sharing class Arc_Gen_DynForm_Utils {
    /**
    * @description Constructor
    **/
    @TestVisible
    private Arc_Gen_DynForm_Utils() {}
    /**
    * --------------------------------------------------------------------------------------
    * @description Get tab maps.
    * @param templateNames Set with the templates Names.
    * @param tabName List with the tabs name.
    * @return Returns the tab map.
    **/
    public static Map<String, dyfr__Tab__c> getTabsByTemplate(Set<String> templateNames, List<String> tabsName) {
        final Map<String, dyfr__Tab__c> result = new Map<String, dyfr__Tab__c>();
        if (Schema.sObjectType.dyfr__Tab__c.isAccessible()) {
            String query = 'SELECT ' + Arc_Gen_Corporate_Utils.getAllFields('dyfr__Tab__c');
            query += ' FROM dyfr__Tab__c ';
            final List<String> andConditions = new List<String>{};
            if (templateNames != null && !templateNames.isEmpty()) {
                andConditions.add('dyfr__Template__r.Name IN : templateNames');
            }
            if (tabsName != null && !tabsName.isEmpty()) {
                andConditions.add('Name IN : tabsName');
            }
            if (!andConditions.isEmpty()) {
                query += ' WHERE ' + String.join(andConditions, ' AND ');
            }
            for(dyfr__Tab__c tab : Database.query(String.escapeSingleQuotes(query))) {
                result.put(tab.Id, tab);
            }
        }
        return result;
    }
}