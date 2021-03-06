@isTest

/**
*
*
* @author VASS
*/
private class NBC_MinutaTest {

    private static dwp_kitv__Visit__c createObjects () {
        DES_UtilTestClass utils;
        utils = new DES_UtilTestClass();
        User usr;
        usr = utils.createUser(utils.createProfile());
        insert usr;
        Account acc;
        acc = utils.createGroupClient('Account Name', null, usr.id);
        upsert acc;
        NBC__c nbc;
        nbc = utils.createNBC();
        nbc.Committee_Start_Date__c = Date.today();
        upsert nbc;

        Opportunity opp;
        opp = utils.createOpportunity(acc);
        opp.Template_approved_type__c = true;
        opp.Committee_id__c = nbc.id;
        upsert opp;
        Product2 prod;
        prod = utils.createProduct('Product Name');
        upsert prod;
        PricebookEntry pbookEntry;
        pbookEntry = utils.createPricebookEntry(prod);
        upsert pbookEntry;
        OpportunityLineItem oppLine;
        oppLine = utils.createOppLineItem(opp, prod, pbookEntry);
        oppLine.opportunity_nbc_recm_date__c = Date.today();
        upsert oppLine;

        Test.startTest();
        DES_Template__c templ;
        templ = utils.createTemplate(opp, oppLine);
        templ.curncy_trans_year_one_type__c = 'EUR';
        templ.curncy_trans_year_two_type__c = 'GBP';
        templ.curncy_trans_year_three_type__c = 'AUD';
        templ.curncy_trans_year_four_type__c = 'CAD';
        templ.New_Money_for_BBVA1_desc__c = '12\n45';
        upsert templ;
        dwp_kitv__Visit__c visit;
        visit = utils.createVisit(acc, opp);
        visit.Committee_id__c = nbc.id;
        upsert visit;

        return visit;
    }

    @isTest static void testMethodOne() {
        dwp_kitv__Visit__c visit;
        visit = createObjects();

            PageReference pageRef;
            pageRef = Page.MinuteSelector;
            pageRef.getParameters().put('id',visit.ID);Test.setCurrentPage(pageRef);
            ApexPages.StandardController scr;
            scr = new ApexPages.StandardController(visit);
            MinuteSelector_Controller controller;
            controller = new MinuteSelector_Controller(scr);
            controller.sendMail();
            PageReference pageRef2;
            pageRef2 = Page.NBC_Minute;

            String opportunitysIDs                        =    '';

            final LIst<Opportunity> lstWprOpor=[select id from opportunity limit 100];
            //valida que seleccione almenos una oportundiad
            for(Integer i=0;i< lstWprOpor.size();i++) {
                opportunitysIDs               =    opportunitysIDs+lstWprOpor[i].id;
                if(i<(lstWprOpor.size()-1)) {
                    opportunitysIDs            =    opportunitysIDs+':';

                }

            }


            pageRef2.getParameters().put('id',visit.ID);
            pageRef2.getParameters().put('Opps',opportunitysIDs);
            Test.setCurrentPage(pageRef2);
            NBC_MinutaController controller2;
            controller2 = new NBC_MinutaController(scr);
            MasterMinutasCnt.createMinuteTable(null);
        System.assertNotEquals(controller2, null);
        Test.stopTest();
    }

     private static NBC__c createObjects2 () {
        DES_UtilTestClass utils;
        utils = new DES_UtilTestClass();
        User usr;
        usr = utils.createUser(utils.createProfile());
        insert usr;
        Account acc;
        acc = utils.createGroupClient('Account Name', null, usr.id);
        upsert acc;
        NBC__c nbc;
        nbc = utils.createNBC();
        nbc.Committee_Start_Date__c = Date.today();
        upsert nbc;
        Opportunity opp;
        opp = utils.createOpportunity(acc);
        opp.Template_approved_type__c = true;
        opp.Committee_id__c = nbc.id;
        upsert opp;
         Test.startTest();
        Product2 prod;
        prod = utils.createProduct('Product Name');
        upsert prod;

        
        PricebookEntry pbookEntry;
        pbookEntry = utils.createPricebookEntry(prod);
        upsert pbookEntry;
        OpportunityLineItem oppLine;
        oppLine = utils.createOppLineItem(opp, prod, pbookEntry);
        oppLine.opportunity_nbc_recm_date__c = Date.today();
        upsert oppLine;
        DES_Template__c templ;
        templ = utils.createTemplate(opp, oppLine);
        templ.curncy_trans_year_one_type__c = 'EUR';
        templ.curncy_trans_year_two_type__c = 'GBP';
        templ.curncy_trans_year_three_type__c = 'AUD';
        templ.curncy_trans_year_four_type__c = 'CAD';
        templ.New_Money_for_BBVA1_desc__c = '12\n45';
        upsert templ;
         Test.stopTest();
        dwp_kitv__Visit__c visit;
        visit = utils.createVisit(acc, opp);
        visit.Committee_id__c = nbc.id;
        upsert visit;

        
        return nbc;
    }
    @isTest static void testMethodTwo() {
        NBC__c nbc;
        nbc = createObjects2();
            PageReference pageRef;
            pageRef = Page.MinuteSelector_nbc;
            pageRef.getParameters().put('id',nbc.ID);Test.setCurrentPage(pageRef);
            ApexPages.StandardController scr;
            scr = new ApexPages.StandardController(nbc);
            MinuteSelector_Controller_nbc controller;
            controller = new MinuteSelector_Controller_nbc(scr);
            controller.sendMail();
            PageReference pageRef2;
            pageRef2 = Page.NBC_Minute_NBC;

            String opportunitysIDs                        =    '';
            final LIst<Opportunity> lstWprOpor=[select id from opportunity limit 100];
            //valida que seleccione almenos una oportundiad
            for(Integer i=0;i< lstWprOpor.size();i++) {
                opportunitysIDs               =    opportunitysIDs+lstWprOpor[i].id;
                if(i<(lstWprOpor.size()-1)) {
                    opportunitysIDs            =    opportunitysIDs+':';
                }
            }
            pageRef2.getParameters().put('id',nbc.ID);
            pageRef2.getParameters().put('Opps',opportunitysIDs);
            Test.setCurrentPage(pageRef2);
            NBC_MinutaController_nbc controller2;
            controller2 = new NBC_MinutaController_nbc(scr);
            MasterMinutasCnt.createMinuteTable(null);
        System.assertNotEquals(controller2, null);
    }

}