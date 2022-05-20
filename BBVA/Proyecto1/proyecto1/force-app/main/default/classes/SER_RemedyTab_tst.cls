/**
* VASS Latam
* @author            Victor Velandia
* Project:           BBVA Service
* Description:       Clase test SER_RemedyTab_CONTROLLER
*
*            No.     Date            Author                  Description
*            -----   ----------      --------------------    ---------------
* @version   1.0     2019-04-25      Victor Velandia A(VV)    Clase test SER_RemedyTab_CONTROLLER
**************************************************************************************************************************************/
@isTest
private class SER_RemedyTab_tst {
  /**
  * description: getDataRemedy
  * @author Victor Velandia
  */
  @isTest
  static void getDataRemedyOne() {
    SER_RemedyTab_CONTROLLER.currentUser();
    final List<User> lstUser = [SELECT Id, Profile.Name
                                FROM user
                                WHERE Lastname='LastNameTest' AND Alias = 'Alias' AND Email = 'Alias@accenture.com'];
    Test.startTest();
    System.assertEquals(lstUser.size(), 0,'getDataRemedyOne');
    Test.stopTest();
  }
}