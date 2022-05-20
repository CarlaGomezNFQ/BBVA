/** ********************************************************************************
* @author       JSS
* @date         24/04/2020
* @description  Clase para testear el controlador PrcPriceMatrixBrowser_Ctrl
* @Revision
********************************************************************************* */
@isTest
public class PrcPriceMatrixBrowser_Ctrl_TEST {
    
    
     public static testmethod void callWsRegisterAmiweb_test() {       
         //INSERT DATA NEEDED
         PRC_TestUtils utils = new PRC_TestUtils();
         //START TEST
         Test.startTest();
        	String resp = PrcPriceMatrixBrowser_Ctrl.callWsRegisterAmiweb((String) utils.opp.Id, utils.priceFullResponse, utils.selectedPrice);
         Test.stopTest();

         //ASSERTS -- se podrían añadir más asserts de OppLineItem
         Opportunity opp = [Select gf_amiweb_opportunity_id__c, gf_proposal_id__c From Opportunity Where id = :utils.opp.Id LIMIT 1];
         System.assertNotEquals(null, opp.gf_amiweb_opportunity_id__c);
         System.assertNotEquals(null, opp.gf_proposal_id__c);
     }
    
    
     public static testmethod void callWsRegisterWorkflow_test() {
         //INSERT DATA NEEDED
         PRC_TestUtils utils = new PRC_TestUtils();
         
         //START TEST
         Test.startTest();
        	String resp = PrcPriceMatrixBrowser_Ctrl.callWsRegisterWorkflow((String) utils.opp.Id);
         Test.stopTest();

         //ASSERTS
         Opportunity opp = [Select gf_workflow_opportunity_id__c, gf_workflow_oppy_status_type__c From Opportunity Where id = :utils.opp.Id LIMIT 1];
         System.assertNotEquals(null, opp.gf_workflow_opportunity_id__c);
         System.assertNotEquals(null, opp.gf_workflow_oppy_status_type__c);
     }
    
    
    public static testmethod void getStatusWorkflow_test() {
         //INSERT DATA NEEDED
         PRC_TestUtils utils = new PRC_TestUtils();
         utils.opp.gf_workflow_opportunity_id__c = '275130';
         update utils.opp;
         
         //START TEST
         Test.startTest();
        	String resp = PrcPriceMatrixBrowser_Ctrl.getStatusWorkflow((String) utils.opp.Id);
         Test.stopTest();

         //ASSERTS
         Opportunity opp = [Select gf_workflow_opportunity_id__c, gf_workflow_oppy_status_type__c From Opportunity Where id = :utils.opp.Id LIMIT 1];
         System.assertEquals('UPDATED', opp.gf_workflow_oppy_status_type__c);
     }

}