/**
* ────────────────────────────────────────────────────────────────────
* GetProposalCondNotebook_Helper_Test
* Test class for GetProposalConditionsNotebook_Helper apex class
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
public class GetProposalCondNotebook_Helper_Test {
    @TestSetup
    static void testSetup() {
        final User usuario = Test_Utils.createUser();
        insert usuario;
    }
    @isTest
    static void getProposalConNotebTest1() {
        final User usuario = [SELECT Id FROM User WHERE UserName = 'testProfi@example.com' LIMIT 1];
        Test.startTest();
        System.runAs(usuario){
            final GetProposalConditionsNotebook_Helper getProposal_h = new GetProposalConditionsNotebook_Helper('ES0182000000591');
            HttpResponse response = getProposal_h.callWs();
            System.assertEquals(200, response.getStatusCode(),'error getProposalConNotebTest1');
        }
        Test.stopTest();
    }
}