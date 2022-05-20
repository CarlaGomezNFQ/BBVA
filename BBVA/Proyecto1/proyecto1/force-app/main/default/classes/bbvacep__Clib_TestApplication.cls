@isTest
public class Clib_TestApplication {
	
    @isTest static void coreTest() {
        fflib_Application.UnitOfWorkFactory uow = Clib_Application.UNITOFWORK;
        fflib_Application.ServiceFactory service = Clib_Application.SERVICE;
        fflib_Application.SelectorFactory selector = Clib_Application.SELECTOR;
        System.assert(uow != null);
        System.assert(service != null);
        System.assert(selector != null);
    }
}