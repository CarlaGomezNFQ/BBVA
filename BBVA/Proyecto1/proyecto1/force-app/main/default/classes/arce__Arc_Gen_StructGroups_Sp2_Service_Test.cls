/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_StructGroups_Sp2_Service_Test
* @Author   amunguia.contractor@bbva.com
* @Date     Created: 18/03/2021
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class method for Arc_Gen_StructureGroups_Sp2_Service
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |18-03-2021 amunguia.contractor@bbva.com
*             Class creation.
* -----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class Arc_Gen_StructGroups_Sp2_Service_Test {
    /** @Description: String with cclient */
    private static String cclient = 'ES0182000013105';
    /** @Description: String with economicGroup */
    private static String economicGroup = 'G00000000000002';
    /**
    * @description test method
    * @author amunguia.contractor@bbva.com | 03-18-2021
    **/
    @isTest
    public static void callEconomicParticipationsTest() {
        Test.startTest();
        final Arc_Gen_EconomicPart_Sp2_RP classwrp = Arc_Gen_StructureGroups_SP2_Service.callEconomicParticipations(cclient);
        Test.stopTest();
        System.assertEquals(economicGroup, classwrp.calculateParent(), 'Error callEconomicParticipations');
    }
    /**
    * @description test method
    * @author amunguia.contractor@bbva.com | 03-18-2021
    **/
    @isTest
    public static void callParentGroupsTest() {
        Test.startTest();
        final Arc_Gen_ParentGroups_SP2_RP parentGroupRP = Arc_Gen_StructureGroups_SP2_Service.callParentGroups(cclient, economicGroup);
        final Map<String,List<String>> result = parentGroupRP.calculateChildrens();
        Test.stopTest();
        System.assert(result.containsKey('ES0009000000112'),  'Error callParentGroups');
    }
}