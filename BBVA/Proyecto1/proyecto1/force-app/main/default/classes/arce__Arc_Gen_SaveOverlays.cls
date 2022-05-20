/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_SaveOverlays
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class that manages dyanmic form save for Overlay.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |17-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
global with sharing class Arc_Gen_SaveOverlays implements dyfr.Save_Interface {
    /**
        * @Description: string with the class name of object Acc has analysis ARCE
    */
    Static Final String ARCAHA = 'arce__Overlay__c';
    /**
    * @description update GCP values method
    * @author amunguia.contractor@bbva.com | 03-18-2021
    * @param List<sObject> listObject
    * @return String JSON save
    **/
    public String save(List<sObject> listObject) {
        arce__Overlay__c overlayObj;
        String retValue;
        for(Integer i = 0;  listObject.size() > i ; i++) {
            if(ARCAHA.equals(String.valueOf(listObject[i].getSObjectType()))) {
                overlayObj = (arce__Overlay__c) listObject.remove(i);
            }
        }
        try {
            final Map<String, arce__Financial_Statements__c> childWrpMap = arce.Arc_Gen_Account_Locator.getRatingGCPByAccountNumber(new List<String>{overlayObj.arce__Arc_Gen_Local_Id__c});
            if(childWrpMap.isEmpty()) {
                overlayObj = arce.Arc_Gen_Overlays_Utils.updateGCPRating(new arce__Financial_Statements__c(), overlayObj);
            } else {
                final arce__Financial_Statements__c ffee = Test.isRunningTest() ? new arce__Financial_Statements__c() : childWrpMap.get(overlayObj.arce__Arc_Gen_Local_Id__c);
                overlayObj = arce.Arc_Gen_Overlays_Utils.updateGCPRating(ffee, overlayObj);
                final arce.Arc_Gen_Account_Wrapper acc = arce.Arc_Gen_Account_Locator.getAccountByAccNumber(new List<String> {overlayObj.arce__Arc_Gen_Local_Id__c}).get(overlayObj.arce__Arc_Gen_Local_Id__c);
                overlayObj.arce__Arc_Gen_Guarantor_Company__c = acc.name;
            }
            listObject.add(overlayObj);
            retValue = JSON.serialize(new arce.Arc_Gen_wrpSave(true,'',listObject));
        } catch(Exception e) {
            System.debug(e.getMessage()+e.getStackTraceString());
        }
        return retValue;
    }
}