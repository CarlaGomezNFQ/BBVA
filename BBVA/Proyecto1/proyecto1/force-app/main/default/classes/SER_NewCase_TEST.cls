/**
*	Author:			Victor Velandia
*	Company:		Vass
*	Description:	Test Class SER_NewCase_CONTROLLER
*
*	History:
*	<Date>			<Author>					<Description>
*	05/07/2018		Victor Velandia				Test Class
*/
@isTest
public class SER_NewCase_TEST {
  /**
  * description: initDataOK
  * @author Victor Velandia
  */
  @isTest
  public static void initDataOK() {
    Id userID;
    userID = UserInfo.getUserId();

    Test.startTest();
    SER_NewCase_CONTROLLER.getInstance();
    SER_NewCase_CONTROLLER.initData(userID);
    System.assert (true, true);
    Test.stopTest();
  }

  /**
  * description: saveNewCaseOK
  * @author Victor Velandia
  */
  @isTest
  public static void saveNewCaseOK() {
    Id userID;
    userID = UserInfo.getUserId();

    SER_MailingGroup__c testMG01;
    testMG01 = new SER_MailingGroup__c(SER_MailingGroup__c = 'Default STE',SER_DefaultMailbox__c = 'Email OPINATOR',SER_User__c = userID);
    insert testMG01;

    Test.startTest();
    SER_NewCase_CONTROLLER.saveNewCase(userID, null);
    System.assert (true, true);
    Test.stopTest();
  }

  /**
  * description: getDataAccountTest
  * @author Victor Velandia
  */
  @isTest
  public static void getDataCaseSTE() {
    // Se crea una cuenta
    Account sqlacc;
    sqlacc = new Account();
    sqlacc.Name     = 'TestAccount Max Mistral JLB';
    sqlacc.SER_CClient__c = '987654';
    sqlacc.OwnerId = UserInfo.getUserId();
    insert sqlacc;

    // Se crea un producto SSTT asociado a una cuenta
    SER_Transactional__c producto;
    producto = new SER_Transactional__c();
    producto.Name = '888999';
    producto.SER_Account__c = sqlacc.Id;
    producto.SER_Product_Text__c = 'NET CASH PRUEBA';
    insert producto;

    Test.startTest();
    SER_NewCase_CONTROLLER.getDataTransCaseSTE(producto.id);
    System.assert (true, true);
    Test.stopTest();
  }

  /**
  * description: getDataAccountTest
  * @author Victor Velandia
  */
  @isTest
  public static void getDataCaseGNC() {

    Test.startTest();
    SER_NewCase_CONTROLLER.getDataCaseGNC();
    System.assert (true, true);
    Test.stopTest();
  }
}