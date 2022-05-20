/**
* ────────────────────────────────────────────────────────────────────
* RequestPicassoDocument_Helper_Test
* Test class for RequestPicassoDocument_Helper apex class
* ────────────────────────────────────────────────────────────────────
* @author      Fernando Elizalde <fernando.elizalde.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-05-25
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class RequestPicassoDocument_Helper_Test {

    @TestSetup
    static void setupTestData() {

        // Create a user to run
        final User testUser = Test_Utils.createUser();
        insert testUser;
    }

    @IsTest
    static void requestPicassoDocumentTest() {

        final User adminUser = [SELECT Id FROM User WHERE UserName = 'testProfi@example.com' LIMIT 1];
        final String operationId = 'a80000012345678912';
        final List<String> documentsList = new List<String> {'djq453454', 'fasdfe453'};
        Test.startTest();
            System.runAs(adminUser) {
                final RequestPicassoDocument_Helper rpdHelper = new RequestPicassoDocument_Helper(operationId, documentsList);
                final HttpResponse response = rpdHelper.callWs();
                System.assertEquals(200, response.getStatusCode(), 'Err at RequestPicassoDocument_Helper_Test - RequestPicassoDocumentTest');
            }
        Test.stopTest();
    }
}