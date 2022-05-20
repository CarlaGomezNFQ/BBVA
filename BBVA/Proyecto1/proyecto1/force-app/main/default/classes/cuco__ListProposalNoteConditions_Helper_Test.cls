/**
* ────────────────────────────────────────────────────────────────────
* ListProposalNoteConditions_Helper_Test
* Test class for ListProposalNotebookConditions_Helper apex class
* ────────────────────────────────────────────────────────────────────
* @author      Sara Torres <sara.torres.bermudez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-01
* @modified
* @systemLayer Domain
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class ListProposalNoteConditions_Helper_Test {
    @TestSetup
    static void testSetup() {
        final User usuario = Test_Utils.createUser();
        insert usuario;
    }
    @isTest
    static void getListProposalNotebookTest1() {
        final User usuario = [SELECT Id FROM User WHERE UserName = 'testProfi@example.com' LIMIT 1];
        Test.startTest();
        System.runAs(usuario){
            final ListProposalNotebookConditions_Helper listProposal_h = new ListProposalNotebookConditions_Helper('ES0182000000591', Date.today());
            HttpResponse response = listProposal_h.callWs();
            System.assertEquals(200, response.getStatusCode(),'error getListProposalNotebookTest1');
        }
        Test.stopTest();
    }
}