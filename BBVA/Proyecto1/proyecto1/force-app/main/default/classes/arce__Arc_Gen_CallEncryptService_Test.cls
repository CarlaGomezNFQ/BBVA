/*------------------------------------------------------------------
*Author:        bbva.com developers
*Project:      	ARCE - BBVA Bancomer
*Description:   Test class for Arc_Gen_CallEncryptService
*_______________________________________________________________________________________
*Versión    Date           	Author                              Description
*1.0        14/09/2020      ARCE's TEAM                         Created.
*2.0        04/11/2020      ARCE's TEAM                         Moved to dependencies package
*3.0        21/07/2021      juanignacio.hita.contractor@bbva.com Increases code coverage test
-----------------------------------------------------------------------------------------*/
@isTest
global with sharing class Arc_Gen_CallEncryptService_Test {
    /**
    *-------------------------------------------------------------------------------
    * @Description Test Setup
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @TestSetup
    static void testSetup() {
        final Account acc = Arc_UtilitiesToTest_tst.crearCuenta('TestAcc', null, null, 'CAONlXcCA_uxyJ402AA_xw');
        insert acc;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_CallEncryptService.getDecryptedData
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getDecryptedDataTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final String encrypted = Arc_Gen_CallEncryptService.getEncryptedClient(acc.id);
        System.assertNotEquals('Error', encrypted, 'Service getEncryptedClient OK');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_CallEncryptService.getEncryptedClient
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getEncryptedClientTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final String encrypted = Arc_Gen_CallEncryptService.getEncryptedClient(acc.id);
        System.assertEquals('9AQmTK53a4YWj5psDizWuA', encrypted, 'Error Arc_Gen_CallEncryptService_Test');
        Test.stopTest();
    }
/**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_CallEncryptService.getDecryptedGroup
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getDecryptedGroupTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final String encrypted = Arc_Gen_CallEncryptService.getEncryptedClient(acc.id);
        final List<String> lstEncrypt = new List<String>();
        lstEncrypt.add(encrypted);
        final List<String> decrypted = Arc_Gen_CallEncryptService.getDecryptedGroup(lstEncrypt);
        System.assertEquals('G000001', decrypted[0], 'Error getDecryptedGroup');
        Test.stopTest();
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Testing Arc_Gen_CallEncryptService.getEncryptedClient
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contactor@bbva.com
    * @ Date 2020-09-14
    *--------------------------------------------------------------------------------
    **/
    @isTest
    global static void getDecryptedClientsTest() {
        Test.startTest();
        final Account acc = [Select id from Account LIMIT 1];
        final String encrypted = Arc_Gen_CallEncryptService.getEncryptedClient(acc.id);
        final List<String> lstEncrypt = new List<String>();
        lstEncrypt.add(encrypted);
        final List<String> decryptedClient = Arc_Gen_CallEncryptService.getDecryptedClients(lstEncrypt);
        System.assertEquals('01085387', decryptedClient[0], 'Error decryptedClient');
        Test.stopTest();
    }
}