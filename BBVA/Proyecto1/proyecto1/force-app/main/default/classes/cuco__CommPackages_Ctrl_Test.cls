/**
* ────────────────────────────────────────────────────────────────────
* CommPackages_Ctrl_Test
* Test class for CommPackages_Ctrl apex class
* ────────────────────────────────────────────────────────────────────
* @author      Diego Arias <diego.arias.fernandez.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-03-26
* @modified
* @systemLayer
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@IsTest
public class CommPackages_Ctrl_Test {

    @TestSetup
    static void makeDataCommPkg() {
        // Test setup common for pkgs ctrl class to do test
        Test_Utils.doPackagesTestSetup();
    }

    // Check fill profitability analysis with manage permissions
    @IsTest
    static void commPackagesTest1() {

        final ProfitabilityAnalysis_Selector profAnSelector1 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA1 = new Set<String>{'Prof Analysis Test 0'};
        final List<profitability_analysis__c> lstPA1 = profAnSelector1.selectByName(setNamesPA1);

        Test.startTest();
            final Map<String, Object> retCMap1 = CommPackages_Ctrl.getCommPackages(lstPA1[0].Id);
            final Map<String, Object> pkgPermissions1 = (Map<String, Object>) retCMap1.get('pkgPermissions');

            final Map<String, Object> actualCMap1 = new Map<String, Object>();
            actualCMap1.put('lstPW1Size', ((List<Package_Wrapper>) retCMap1.get('lstPW')).size());
            actualCMap1.put('editPermissions', (Boolean) pkgPermissions1.get('edit'));

            final Map<String, Object> expectedCMap1 = new Map<String, Object>();
            expectedCMap1.put('lstPW1Size', 7);
            expectedCMap1.put('editPermissions', true);

            System.assertEquals(expectedCMap1, actualCMap1, 'Err at CommPackages_Ctrl_Test - commPackagesTest1');
        Test.stopTest();
    }

    // Check empty profitability analysis without manage permisisons
    @IsTest
    static void commPackagesTest2() {

        final ProfitabilityAnalysis_Selector profAnSelector2 = new ProfitabilityAnalysis_Selector(true);
        final Set<String> setNamesPA2 = new Set<String>{'Prof Analysis Test 1'};
        final List<profitability_analysis__c> lstPA2 = profAnSelector2.selectByName(setNamesPA2);

        Test.startTest();
            final Map<String, Object> retCMap2 = CommPackages_Ctrl.getCommPackages(lstPA2[0].Id);
            final Map<String, Object> pkgPermissions2 = (Map<String, Object>) retCMap2.get('pkgPermissions');

            final Map<String, Object> actualCMap2 = new Map<String, Object>();
            actualCMap2.put('lstPW2Size', ((List<Package_Wrapper>) retCMap2.get('lstPW')).size());
            actualCMap2.put('editPermissions', (Boolean) pkgPermissions2.get('edit'));

            final Map<String, Object> expectedCMap2 = new Map<String, Object>();
            expectedCMap2.put('lstPW2Size', 0);
            expectedCMap2.put('editPermissions', false);

            System.assertEquals(expectedCMap2, actualCMap2, 'Err at CommPackages_Ctrl_Test - commPackagesTest2');
        Test.stopTest();
    }

    // Check fill profitability sheet
    @IsTest
    static void commPackagesTest3() {

        final ProfitabilitySheet_Selector profShSelector3 = new ProfitabilitySheet_Selector(true);
        final Set<String> setNamesPS3 = new Set<String>{'Prof Sheet Test 0'};
        final List<profitability_sheet__c> lstPS3 = profShSelector3.selectByName(setNamesPS3);

        Test.startTest();
            final Map<String, Object> retCMap3 = CommPackages_Ctrl.getCommPackages(lstPS3[0].Id);

            final Map<String, Object> actualCMap3 = new Map<String, Object>();
            actualCMap3.put('lstPW3Size', ((List<Package_Wrapper>) retCMap3.get('lstPW')).size());

            final Map<String, Object> expectedCMap3 = new Map<String, Object>();
            expectedCMap3.put('lstPW3Size', 4);

            System.assertEquals(expectedCMap3, actualCMap3, 'Err at CommPackages_Ctrl_Test - commPackagesTest3');
        Test.stopTest();
    }

    // Check empty profitability sheet
    @IsTest
    static void commPackagesTest4() {

        final ProfitabilitySheet_Selector profShSelector4 = new ProfitabilitySheet_Selector(true);
        final Set<String> setNamesPS4 = new Set<String>{'Prof Sheet Test 1'};
        final List<profitability_sheet__c> lstPS4 = profShSelector4.selectByName(setNamesPS4);

        Test.startTest();
            final Map<String, Object> retCMap4 = CommPackages_Ctrl.getCommPackages(lstPS4[0].Id);

            final Map<String, Object> actualCMap4 = new Map<String, Object>();
            actualCMap4.put('lstPW4Size', ((List<Package_Wrapper>) retCMap4.get('lstPW')).size());

            final Map<String, Object> expectedCMap4 = new Map<String, Object>();
            expectedCMap4.put('lstPW4Size', 0);

            System.assertEquals(expectedCMap4, actualCMap4, 'Err at CommPackages_Ctrl_Test - commPackagesTest4');
        Test.stopTest();
    }

    // commPackages err
    @IsTest
    static void commPackagesTest5() {
        Test.startTest();
            try {
                CommPackages_Ctrl.getCommPackages('000000000000000000');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(), 'Err at CommPackages_Ctrl_Test - commPackagesTest5');
            }
        Test.stopTest();
    }

    // Private constructor test
    @IsTest
    static void commPackagesCtrlConstructorTest() {
        Test.startTest();
            final CommPackages_Ctrl constructorTest = new CommPackages_Ctrl();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackages_Ctrl - commPackagesCtrlConstructorTest');
        Test.stopTest();
    }

    // Private constructor test (Packages_Service)
    @IsTest
    static void commPackagesServiceConstructorTest() {
        Test.startTest();
            final Packages_Service constructorTest = new Packages_Service();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackages_Ctrl - commPackagesServiceConstructorTest');
        Test.stopTest();
    }

    // Private constructor test (Packages_Helper)
    @IsTest
    static void commPackagesHelperConstructorTest() {
        Test.startTest();
            final Packages_Helper constructorTest = new Packages_Helper();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackages_Ctrl - commPackagesHelperConstructorTest');
        Test.stopTest();
    }

    // Private constructor test (Test_Utils)
    @IsTest
    static void testUtilsConstructorTest() {
        Test.startTest();
            final Test_Utils constructorTest = new Test_Utils();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackages_Ctrl - testUtilsConstructorTest');
        Test.stopTest();
    }

    // Private constructor test (Utils)
    @IsTest
    static void utilsConstructorTest() {
        Test.startTest();
            final Utils constructorTest = new Utils();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackages_Ctrl - utilsConstructorTest');
        Test.stopTest();
    }

    // Private constructor test (PackagesComm_Service)
    @IsTest
    static void packageCommServiceConstructorTest() {
        Test.startTest();
            final PackagesComm_Service constructorTest = new PackagesComm_Service();
            System.assertEquals(constructorTest, constructorTest, 'Err at CommPackages_Ctrl - packageCommServiceConstructorTest');
        Test.stopTest();
    }
}