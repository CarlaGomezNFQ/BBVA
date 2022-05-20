/**
* ────────────────────────────────────────────────────────────────────
* ValidationsCond_Helper_test
* Test class for ValidationsCond_Helper class
* ────────────────────────────────────────────────────────────────────
* @author
* @modifiedBy
* @version     1.0
* @created
* @modified
* @systemLayer Presentation
* ────────────────────────────────────────────────────────────────────
* @changes
*
* ────────────────────────────────────────────────────────────────────
*/
@SuppressWarnings('PMD.TooManyFields')
@IsTest
public with sharing class ValidationsCond_Helper_test {

    static String inputBoolean= '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"debit.sepa.postal.ind","proposed":"#VALUE_ID#"}]}]}';

    static String mandatoryPCFixedKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type"},{"id":"np.nat.transfer.EEE.ob.branch.min"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"15"},{"id":"np.nat.transfer.EEE.ob.branch.amount","proposed":"10"}]}]}';

    static String mandatoryPCFixedOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type"},{"id":"np.nat.transfer.EEE.ob.branch.min"},{"id":"np.nat.transfer.EEE.ob.branch.max"},{"id":"np.nat.transfer.EEE.ob.branch.amount","proposed":"12"}]}]}';

    static String mandatoryPCVariableKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"1"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"5"},{"id":"np.nat.transfer.EEE.ob.branch.max"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String mandatoryPCVariableOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"1"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"5"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"10"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String mandatoryPCFixedStockKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"stock.domestic.equity.sharesale.type","proposed":"1"},{"id":"stock.domestic.equity.sharesale.min","proposed":""},{"id":"stock.domestic.equity.sharesale.amount","proposed":"10"}]}]}';

    static String mandatoryPCFixedStockOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"stock.domestic.equity.sharesale.type"},{"id":"stock.domestic.equity.sharesale.min"},{"id":"stock.domestic.equity.sharesale.amount","proposed":"10"}]}]}';

    static String mandatoryPCVariableStockKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"stock.domestic.equity.sharesale.type"},{"id":"stock.domestic.equity.sharesale.min","proposed":"2"},{"id":"stock.domestic.equity.sharesale.amount"}]}]}';

    static String mandatoryPCVariableStockOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"stock.domestic.equity.sharesale.type","proposed":"1"},{"id":"stock.domestic.equity.sharesale.min","proposed":"5"},{"id":"stock.domestic.equity.sharesale.amount"}]}]}';

    static String mandatoryOtherKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"card.bbva.others.gift.fee"}]}]}';

    static String mandatoryOtherOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"card.bbva.others.gift.fee","proposed":"45.7"}]}]}';

    static String maxBiggerMinKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"1"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"5.68"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"5.67"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String maxBiggerMinOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"1"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"5.67"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"5.68"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';


    static String withExpZeroTypeKOInput = '{"conditions":[{"id":"#CONDITION_ID_1#","attributes":[{"id":"np.transfer.mail.expenses.amount","proposed":"1"}]},{"id":"#CONDITION_ID_2#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"0"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"4.34"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"4.35"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String withExpZeroTypeOKInput = '{"conditions":[{"id":"#CONDITION_ID_1#","attributes":[{"id":"np.transfer.mail.expenses.amount","proposed":"1"}]},{"id":"#CONDITION_ID_2#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"0"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"4.35"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"4.35"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String withExpNonZeroTypeKOInput = '{"conditions":[{"id":"#CONDITION_ID_1#","attributes":[{"id":"np.transfer.mail.expenses.amount","proposed":"1"}]},{"id":"#CONDITION_ID_2#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"2"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"4.35"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"4.35"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String withExpNonZeroTypeOKInput = '{"conditions":[{"id":"#CONDITION_ID_1#","attributes":[{"id":"np.transfer.mail.expenses.amount","proposed":"1"}]},{"id":"#CONDITION_ID_2#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"2"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"4.33"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"4.35"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String withoutExpInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.nat.transfer.EEE.ob.branch.type","proposed":"1"},{"id":"np.nat.transfer.EEE.ob.branch.min","proposed":"5"},{"id":"np.nat.transfer.EEE.ob.branch.max","proposed":"5"},{"id":"np.nat.transfer.EEE.ob.branch.amount"}]}]}';

    static String checkZeroTypeKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.t.check.letter.type","proposed":"0"},{"id":"np.t.check.letter.min","proposed":"1"},{"id":"np.t.check.letter.max","proposed":"2"},{"id":"np.t.check.letter.amount"}]}]}';

    static String checkZeroTypeOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.t.check.letter.type","proposed":"0"},{"id":"np.t.check.letter.min","proposed":"1"},{"id":"np.t.check.letter.max","proposed":"1"},{"id":"np.t.check.letter.amount"}]}]}';

    static String checkNonZeroTypeKOInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.t.check.letter.type","proposed":"1"},{"id":"np.t.check.letter.min","proposed":"1"},{"id":"np.t.check.letter.max","proposed":"1"},{"id":"np.t.check.letter.amount"}]}]}';

    static String checkNonZeroTypeOKInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"np.t.check.letter.type","proposed":"1"},{"id":"np.t.check.letter.min","proposed":"1"},{"id":"np.t.check.letter.max","proposed":"2"},{"id":"np.t.check.letter.amount"}]}]}';

    static String cardBusinessInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"card.bbva.business.fee","proposed":"#VALUE_ID#"}]}]}';

    static String cardCorpInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"card.bbva.corporate.fee","proposed":"#VALUE_ID#"}]}]}';

    static String cardExpInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"card.bbva.others.express.fee","proposed":"#VALUE_ID#"}]}]}';

    static String cardGiftInput = '{"conditions":[{"id":"#CONDITION_ID#","attributes":[{"id":"card.bbva.others.gift.fee","proposed":"#VALUE_ID#"}]}]}';

    @TestSetup
    static void setupTestData() {

        // Create catalog attributes
        final List<ps_catalog_attribute__c> psCatAttBoolean = new List<ps_catalog_attribute__c>();
        final List<ps_catalog_attribute__c> psCatAttPriceClass = new List<ps_catalog_attribute__c>();
        final List<ps_catalog_attribute__c> psCatAttCards = new List<ps_catalog_attribute__c>();
        final List<ps_catalog_attribute__c> psCatAttMailAmount = new List<ps_catalog_attribute__c>();

        final List<ps_catalog_attribute__c> psCatAtt =  Test_Utils.createPSCatalogAttributes(7);
        psCatAtt[0].Name = 'Exento';
        psCatAtt[0].gf_attribute_value_type_name__c = 'Checkbox';
        psCatAtt[0].gf_psc_attribute_id__c = 'exen.ind';


        psCatAtt[1].Name = 'Max';
        psCatAtt[1].gf_attribute_value_type_name__c = 'Currency';
        psCatAtt[1].gf_psc_attribute_id__c = 'max';

        psCatAtt[2].Name = 'Min';
        psCatAtt[2].gf_attribute_value_type_name__c = 'Currency';
        psCatAtt[2].gf_psc_attribute_id__c = 'min';

        psCatAtt[3].Name = 'Fijo';
        psCatAtt[3].gf_attribute_value_type_name__c = 'Currency';
        psCatAtt[3].gf_psc_attribute_id__c = 'amount';

        psCatAtt[4].Name = '‰';
        psCatAtt[4].gf_attribute_value_type_name__c = 'Permillage';
        psCatAtt[4].gf_psc_attribute_id__c = 'type';

        psCatAtt[5].Name = 'Cuota';
        psCatAtt[5].gf_attribute_value_type_name__c = 'Currency';
        psCatAtt[5].gf_psc_attribute_id__c = 'fee';

        psCatAtt[6].Name = 'Gastos de Correo';
        psCatAtt[6].gf_attribute_value_type_name__c = 'Currency';
        psCatAtt[6].gf_psc_attribute_id__c = 'mail.amount';

        insert psCatAtt;

        psCatAttBoolean.add(psCatAtt[0]);

        psCatAttPriceClass.add(psCatAtt[1]);
        psCatAttPriceClass.add(psCatAtt[2]);
        psCatAttPriceClass.add(psCatAtt[3]);
        psCatAttPriceClass.add(psCatAtt[4]);

        psCatAttCards.add(psCatAtt[5]);

        psCatAttMailAmount.add(psCatAtt[6]);

        // Create catalog families
        final List<ps_catalog_family__c> psCatFam = Test_Utils.createPSCatalogFamilies(6);

        psCatFam[0].gf_psc_family_id__c = 'np.nat.transfer';

        psCatFam[1].gf_psc_family_id__c = 'debit.sepa';

        psCatFam[2].gf_psc_family_id__c = 'stock.domestic';

        psCatFam[3].gf_psc_family_id__c = 'card.bbva.business';

        psCatFam[4].gf_psc_family_id__c = 'card.bbva.others';

        psCatFam[5].gf_psc_family_id__c = 'np.check';

        insert psCatFam;

        // Create conditions
        final List<ps_catalog_condition__c> catCond = new List<ps_catalog_condition__c>();

        final List<ps_catalog_condition__c> catCondNP = Test_Utils.createPSCatalogConditons(1, psCatFam[0]);
        catCondNP[0].gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch';
        catCondNP[0].gf_psc_cond_prc_class_ind_type__c = true;
        catCond.add(catCondNP[0]);

        final List<ps_catalog_condition__c> catCondSEPA = Test_Utils.createPSCatalogConditons(1, psCatFam[1]);
        catCondSEPA[0].gf_psc_condition_id__c = 'debit.sepa.postal';
        catCond.add(catCondSEPA[0]);

        final List<ps_catalog_condition__c> catCondStock = Test_Utils.createPSCatalogConditons(1, psCatFam[2]);
        catCondStock[0].gf_psc_condition_id__c = 'stock.domestic.equity.sharesale';
        catCondStock[0].gf_psc_cond_prc_class_ind_type__c = true;
        catCond.add(catCondStock[0]);

        final List<ps_catalog_condition__c> catCondBusinessCards = Test_Utils.createPSCatalogConditons(2, psCatFam[3]);
        catCondBusinessCards[0].gf_psc_condition_id__c = 'card.bbva.business';
        catCond.add(catCondBusinessCards[0]);
        catCondBusinessCards[1].gf_psc_condition_id__c = 'card.bbva.corporate';
        catCond.add(catCondBusinessCards[1]);

        final List<ps_catalog_condition__c> catCondOtherCards = Test_Utils.createPSCatalogConditons(2, psCatFam[4]);
        catCondOtherCards[0].gf_psc_condition_id__c = 'card.bbva.others.express';
        catCond.add(catCondOtherCards[0]);
        catCondOtherCards[1].gf_psc_condition_id__c = 'card.bbva.others.gift';
        catCond.add(catCondOtherCards[1]);

        final List<ps_catalog_condition__c> catCondMailNP = Test_Utils.createPSCatalogConditons(1, psCatFam[0]);
        catCondMailNP[0].gf_psc_condition_id__c = 'np.transfer.mail.expenses';
        catCond.add(catCondMailNP[0]);

        final List<ps_catalog_condition__c> catCondCheck = Test_Utils.createPSCatalogConditons(1, psCatFam[5]);
        catCondCheck[0].gf_psc_condition_id__c = 'np.t.check.letter';
        catCondCheck[0].gf_psc_cond_prc_class_ind_type__c = true;
        catCond.add(catCondCheck[0]);

        insert catCond;

        // Create condition attributes
        final List<ps_catalog_condition_attribute__c> catCondAt = new List<ps_catalog_condition_attribute__c>();

        final List<ps_catalog_condition_attribute__c> catCondAttSEPA = Test_Utils.createPSCatalogConditonAttributes(1, catCond[1], psCatAttBoolean);
        catCondAttSEPA[0].gf_psc_condition_attribute_id__c = 'debit.sepa.postal.ind';
        catCondAt.add(catCondAttSEPA[0]);

        final List<ps_catalog_condition_attribute__c> catCondAttNP = Test_Utils.createPSCatalogConditonAttributes(4, catCond[0], psCatAttPriceClass);
        catCondAttNP[0].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.max';
        catCondAt.add(catCondAttNP[0]);
        catCondAttNP[1].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.min';
        catCondAt.add(catCondAttNP[1]);
        catCondAttNP[2].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.amount';
        catCondAt.add(catCondAttNP[2]);
        catCondAttNP[3].gf_psc_condition_attribute_id__c = 'np.nat.transfer.EEE.ob.branch.type';
        catCondAt.add(catCondAttNP[3]);

        final List<ps_catalog_condition_attribute__c> catCondAttStock = Test_Utils.createPSCatalogConditonAttributes(4, catCond[2], psCatAttPriceClass);

        catCondAttStock[1].gf_psc_condition_attribute_id__c = 'stock.domestic.equity.sharesale.min';
        catCondAt.add(catCondAttStock[1]);
        catCondAttStock[2].gf_psc_condition_attribute_id__c = 'stock.domestic.equity.sharesale.amount';
        catCondAt.add(catCondAttStock[2]);
        catCondAttStock[3].gf_psc_condition_attribute_id__c = 'stock.domestic.equity.sharesale.type';
        catCondAt.add(catCondAttStock[3]);

        final List<ps_catalog_condition_attribute__c> catCondAttCardBus = Test_Utils.createPSCatalogConditonAttributes(1, catCond[3], psCatAttCards);
        catCondAttCardBus[0].gf_psc_condition_attribute_id__c = 'card.bbva.business.fee';
        catCondAt.add(catCondAttCardBus[0]);

        final List<ps_catalog_condition_attribute__c> catCondAttCardCor = Test_Utils.createPSCatalogConditonAttributes(1, catCond[4], psCatAttCards);
        catCondAttCardCor[0].gf_psc_condition_attribute_id__c = 'card.bbva.corporate.fee';
        catCondAt.add(catCondAttCardCor[0]);

        final List<ps_catalog_condition_attribute__c> catCondAttCardExp = Test_Utils.createPSCatalogConditonAttributes(1, catCond[5], psCatAttCards);
        catCondAttCardExp[0].gf_psc_condition_attribute_id__c = 'card.bbva.others.express.fee';
        catCondAt.add(catCondAttCardExp[0]);

        final List<ps_catalog_condition_attribute__c> catCondAttCardGift = Test_Utils.createPSCatalogConditonAttributes(1, catCond[6], psCatAttCards);
        catCondAttCardGift[0].gf_psc_condition_attribute_id__c = 'card.bbva.others.gift.fee';
        catCondAt.add(catCondAttCardGift[0]);

        final List<ps_catalog_condition_attribute__c> catCondAttMailNP = Test_Utils.createPSCatalogConditonAttributes(1, catCond[7], psCatAttMailAmount);
        catCondAttMailNP[0].gf_psc_condition_attribute_id__c = 'np.transfer.mail.expenses.amount';
        catCondAt.add(catCondAttMailNP[0]);

        final List<ps_catalog_condition_attribute__c> catCondAttCheck = Test_Utils.createPSCatalogConditonAttributes(4, catCond[8], psCatAttPriceClass);
        catCondAttCheck[0].gf_psc_condition_attribute_id__c = 'np.t.check.letter.max';
        catCondAt.add(catCondAttCheck[0]);
        catCondAttCheck[1].gf_psc_condition_attribute_id__c = 'np.t.check.letter.min';
        catCondAt.add(catCondAttCheck[1]);
        catCondAttCheck[2].gf_psc_condition_attribute_id__c = 'np.t.check.letter.amount';
        catCondAt.add(catCondAttCheck[2]);
        catCondAttCheck[3].gf_psc_condition_attribute_id__c = 'np.t.check.letter.type';
        catCondAt.add(catCondAttCheck[3]);

        insert catCondAt;

        //Create standard values
        final List<ps_catalog_condition_standard__c> catStandVal = Test_Utils.createPSCatalogConditonsStandard(4);

        catStandVal[0].gf_psc_condition_attribute_id__c = catCondAt[8].Id;
        catStandVal[0].gf_cond_atrb_max_val_name__c = '10';
        catStandVal[0].gf_cond_atrb_min_val_name__c = '0';

        catStandVal[1].gf_psc_condition_attribute_id__c = catCondAt[9].Id;
        catStandVal[1].gf_cond_atrb_max_val_name__c = '10';
        catStandVal[1].gf_cond_atrb_min_val_name__c = null;

        catStandVal[2].gf_psc_condition_attribute_id__c = catCondAt[10].Id;
        catStandVal[2].gf_cond_atrb_max_val_name__c =  null;
        catStandVal[2].gf_cond_atrb_min_val_name__c = '1';

        catStandVal[3].gf_psc_condition_attribute_id__c = catCondAt[11].Id;
        catStandVal[3].gf_cond_atrb_max_val_name__c =  null;
        catStandVal[3].gf_cond_atrb_min_val_name__c = null;

        insert catStandVal;

    }

    //Test Check Boolean OK
    @IsTest
    static void checkBooleanOKTest() {

        final List<ps_catalog_condition__c> catCondSEPA = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'debit.sepa.postal'];

        String inputBooleanOK = inputBoolean;
        inputBooleanOK = inputBooleanOK.replace('#CONDITION_ID#',catCondSEPA[0].Id);
        inputBooleanOK = inputBooleanOK.replace('#VALUE_ID#','true');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(inputBooleanOK, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final Map<String,cuco__ps_catalog_attribute__c> attDetailsMap =  ValidationsCond_Helper.getAttDetails();

        final List<String> errorList =  ValidationsCond_Helper.checkBooleanAtts(valuePerAttMap.get('debit.sepa.postal'), attDetailsMap);

        System.assertEquals(true, errorList.isEmpty(), 'checkBooleanOKTest - with errors');
    }

    //Test Check Boolean KO
    @IsTest
    static void checkBooleanKOTest() {

        final List<ps_catalog_condition__c> catCondSEPA = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'debit.sepa.postal'];

        String inputBooleanOK = inputBoolean;
        inputBooleanOK = inputBooleanOK.replace('#CONDITION_ID#',catCondSEPA[0].Id);
        inputBooleanOK = inputBooleanOK.replace('#VALUE_ID#','false');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(inputBooleanOK, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final Map<String,cuco__ps_catalog_attribute__c> attDetailsMap =  ValidationsCond_Helper.getAttDetails();

        final List<String> errorList =  ValidationsCond_Helper.checkBooleanAtts(valuePerAttMap.get('debit.sepa.postal'), attDetailsMap);

        System.assertEquals(Label.cuco.cond_false_checkbox_error, errorList[0], 'checkBooleanKOTest - error does not match');
    }

    // Test Check Mandatory Fixed Price Class Fields KO
    @IsTest
    static void checkMandFixedPCKOTest() {
        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch'];

        String pcFixedKOInput = mandatoryPCFixedKOInput;
        pcFixedKOInput = pcFixedKOInput.replace('#CONDITION_ID#',catCondNP[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcFixedKOInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id));

        System.assertEquals(Label.cuco.cond_variable_extra_fields, errorList[0], 'checkMandFixedPCKOTest - error does not match');

    }

    // Test Check Mandatory Fixed Price Class Fields OK
    @IsTest
    static void checkMandFixedPCOKTest() {
        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch'];

        String pcFixedOKInput = mandatoryPCFixedOKInput;
        pcFixedOKInput = pcFixedOKInput.replace('#CONDITION_ID#',catCondNP[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcFixedOKInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'checkMandFixedPCOKTest - error list not empty');

    }

    // Test Check Mandatory Variable Price Class Fields KO
    @IsTest
    static void checkMandVariablePCKOTest() {
        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch'];

        String pcVariableKOInput = mandatoryPCVariableKOInput;
        pcVariableKOInput = pcVariableKOInput.replace('#CONDITION_ID#',catCondNP[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcVariableKOInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id));

        System.assertEquals(Label.cuco.cond_variable_missing_fields, errorList[0], 'checkMandVariablePCKOTest - error does not match');

    }

    // Test Check Mandatory Variable Price Class Fields OK
    @IsTest
    static void checkMandVariablePCOKTest() {
        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch'];

        String pcVariableOKInput = mandatoryPCVariableOKInput;
        pcVariableOKInput = pcVariableOKInput.replace('#CONDITION_ID#',catCondNP[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcVariableOKInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'checkMandVariablePCOKTest - error list not empty');

    }

    // Test Check Mandatory Stock Fixed Price Class Fields KO
    @IsTest
    static void checkMandStockFixedPCKOTest() {
        final List<ps_catalog_condition__c> catCondStock = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'stock.domestic.equity.sharesale'];

        String pcFixedStokckKOInput = mandatoryPCFixedStockKOInput;
        pcFixedStokckKOInput = pcFixedStokckKOInput.replace('#CONDITION_ID#',catCondStock[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcFixedStokckKOInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('stock.domestic.equity.sharesale'), condDetailsMap.get(catCondStock[0].Id));

        System.assertEquals(Label.cuco.cond_stoke_variable_extra_fields, errorList[0], 'checkMandStockFixedPCKOTest - error does not match');

    }

    // Test Check Mandatory Stock Fixed Price Class Fields OK
    @IsTest
    static void checkMandStockFixedPCOKTest() {
        final List<ps_catalog_condition__c> catCondStock = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'stock.domestic.equity.sharesale'];

        String pcFixedStokckOKInput = mandatoryPCFixedStockOKInput;
        pcFixedStokckOKInput = pcFixedStokckOKInput.replace('#CONDITION_ID#',catCondStock[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcFixedStokckOKInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('stock.domestic.equity.sharesale'), condDetailsMap.get(catCondStock[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'checkMandStockFixedPCOKTest - error list not empty');

    }

    // Test Check Mandatory Stock Variable Price Class Fields KO
    @IsTest
    static void checkMandStockVariablePCKOTest() {
        final List<ps_catalog_condition__c> catCondStock = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'stock.domestic.equity.sharesale'];

        String pcVariableStokckKOInput = mandatoryPCVariableStockKOInput;
        pcVariableStokckKOInput = pcVariableStokckKOInput.replace('#CONDITION_ID#',catCondStock[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcVariableStokckKOInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('stock.domestic.equity.sharesale'), condDetailsMap.get(catCondStock[0].Id));

        System.assertEquals(Label.cuco.cond_stoke_variable_missing_fields, errorList[0], 'checkMandStockVariablePCKOTest - error does not match');

    }

    // Test Check Mandatory Stock Variable Price Class Fields KO
    @IsTest
    static void checkMandStockVariablePCOKTest() {
        final List<ps_catalog_condition__c> catCondStock = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'stock.domestic.equity.sharesale'];

        String pcVariableStokckOKInput = mandatoryPCVariableStockOKInput;
        pcVariableStokckOKInput = pcVariableStokckOKInput.replace('#CONDITION_ID#',catCondStock[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcVariableStokckOKInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('stock.domestic.equity.sharesale'), condDetailsMap.get(catCondStock[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'checkMandStockVariablePCOKTest - error list not empty');

    }

    // Test Check Mandatory Other Fields KO
    @IsTest
    static void checkMandOtherPCKOTest() {
        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.gift'];

        String pcOtherKOInput = mandatoryOtherKOInput;
        pcOtherKOInput = pcOtherKOInput.replace('#CONDITION_ID#',catCondCard[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcOtherKOInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('card.bbva.others.gift'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(Label.cuco.cond_missing_fields_error, errorList[0], 'checkMandOtherPCKOTest - error does not match');

    }

    // Test Check Mandatory Other Fields OK
    @IsTest
    static void checkMandOtherPCOKTest() {
        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.gift'];

        String pcOtherOKInput = mandatoryOtherOKInput;
        pcOtherOKInput = pcOtherOKInput.replace('#CONDITION_ID#',catCondCard[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcOtherOKInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMandatoryAtts(valuePerAttMap.get('card.bbva.others.gift'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'checkMandOtherPCOKTest - error list not empty');

    }

    // Test Check Max vs Min - Max bigger than Min KO
    @IsTest
    static void checkMaxBiggerMinKOTest() {

        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch'];

        String pcMaxMinKOInput = maxBiggerMinKOInput;
        pcMaxMinKOInput = pcMaxMinKOInput.replace('#CONDITION_ID#',catCondNP[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcMaxMinKOInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMinVSMax(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'));

        System.assertEquals(Label.cuco.cond_min_greater_max_error, errorList[0], 'checkMaxBiggerMinKOTest - error does not match');
    }

    // Test Check Max vs Min - Max bigger than Min OK
    @IsTest
    static void checkMaxBiggerMinOKTest() {

        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch'];

        String pcMaxMinOKInput = maxBiggerMinOKInput;
        pcMaxMinOKInput = pcMaxMinOKInput.replace('#CONDITION_ID#',catCondNP[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(pcMaxMinOKInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMinVSMax(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'));

        System.assertEquals(true, errorList.isEmpty(), 'checkMaxBiggerMinOKTest - error list not empty');
    }

    // Test Check Max vs Min - No Max or Min OK
    @IsTest
    static void checkNoMaxMinOKTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.gift'];

        String noMaxMinOKInput = mandatoryOtherOKInput;
        noMaxMinOKInput = noMaxMinOKInput.replace('#CONDITION_ID#',catCondCard[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(noMaxMinOKInput, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkMinVSMax(valuePerAttMap.get('card.bbva.others.gift'));

        System.assertEquals(true, errorList.isEmpty(), 'checkNoMaxMinOKTest - error list not empty');
    }

    // Test Check Transfer - With Expense Zero Type OK
    @IsTest
    static void checkExpZeroTypeKOTest() {

        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c IN ('np.nat.transfer.EEE.ob.branch','np.transfer.mail.expenses') ORDER BY gf_psc_condition_id__c ASC];

        String expWithExpZeroTypeKO = withExpZeroTypeKOInput;
        expWithExpZeroTypeKO = expWithExpZeroTypeKO.replace('#CONDITION_ID_2#',catCondNP[0].Id);
        expWithExpZeroTypeKO = expWithExpZeroTypeKO.replace('#CONDITION_ID_1#',catCondNP[1].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(expWithExpZeroTypeKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkTransferAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id), valuePerAttMap);

        System.assertEquals(Label.cuco.cond_transfer_min_max_not_equal_error, errorList[0], 'checkExpZeroTypeKOTest - error does not match');
    }

    // Test Check Transfer - With Expense Zero Type OK
    @IsTest
    static void checkExpZeroTypeOKTest() {

        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c IN ('np.nat.transfer.EEE.ob.branch','np.transfer.mail.expenses') ORDER BY gf_psc_condition_id__c ASC];

        String expWithExpZeroTypeOK = withExpZeroTypeOKInput;
        expWithExpZeroTypeOK = expWithExpZeroTypeOK.replace('#CONDITION_ID_2#',catCondNP[0].Id);
        expWithExpZeroTypeOK = expWithExpZeroTypeOK.replace('#CONDITION_ID_1#',catCondNP[1].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(expWithExpZeroTypeOK, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkTransferAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id), valuePerAttMap);

        System.assertEquals(true, errorList.isEmpty(), 'checkExpZeroTypeOKTest - error list not empty');
    }

    // Test Check Transfer - With Expense Non Zero Type KO
    @IsTest
    static void checkExpNonZeroTypeKOTest() {

        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c IN ('np.nat.transfer.EEE.ob.branch','np.transfer.mail.expenses') ORDER BY gf_psc_condition_id__c ASC];

        String expWithExpNonZeroTypeKO = withExpNonZeroTypeKOInput;
        expWithExpNonZeroTypeKO = expWithExpNonZeroTypeKO.replace('#CONDITION_ID_2#',catCondNP[0].Id);
        expWithExpNonZeroTypeKO = expWithExpNonZeroTypeKO.replace('#CONDITION_ID_1#',catCondNP[1].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(expWithExpNonZeroTypeKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkTransferAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id), valuePerAttMap);

        System.assertEquals(Label.cuco.cond_transfer_min_max_equal_error, errorList[0], 'checkExpNonZeroTypeKOTest - error does not match');
    }

    // Test Check Transfer - With Expense Non Zero Type OK
    @IsTest
    static void checkExpNonZeroTypeOKTest() {

        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c IN ('np.nat.transfer.EEE.ob.branch','np.transfer.mail.expenses') ORDER BY gf_psc_condition_id__c ASC];

        String expWithExpNonZeroTypeOK = withExpNonZeroTypeOKInput;
        expWithExpNonZeroTypeOK = expWithExpNonZeroTypeOK.replace('#CONDITION_ID_2#',catCondNP[0].Id);
        expWithExpNonZeroTypeOK = expWithExpNonZeroTypeOK.replace('#CONDITION_ID_1#',catCondNP[1].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(expWithExpNonZeroTypeOK, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkTransferAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id), valuePerAttMap);

        System.assertEquals(true, errorList.isEmpty(), 'checkExpNonZeroTypeOKTest - error list not empty');
    }

    // Test Check Transfer - Without Expense
    @IsTest
    static void checkWithoutExpTest() {

        final List<ps_catalog_condition__c> catCondNP = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'np.nat.transfer.EEE.ob.branch'];

        String withoutExp = withoutExpInput;
        withoutExp = withoutExp.replace('#CONDITION_ID#',catCondNP[0].Id);

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(withoutExp, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkTransferAtts(valuePerAttMap.get('np.nat.transfer.EEE.ob.branch'), condDetailsMap.get(catCondNP[0].Id), valuePerAttMap);

        System.assertEquals(true, errorList.isEmpty(), 'checkWithoutExpTest - error list not empty');
    }

    // Test Card Business KO
    @IsTest
    static void cardBusKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.business'];

        String cardBusKO = cardBusinessInput;
        cardBusKO = cardBusKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardBusKO = cardBusKO.replace('#VALUE_ID#','5');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardBusKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.business'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(Label.cuco.cond_card_business_value_error, errorList[0], 'cardBusKOTest - error does not match');
    }

    // Test Card Business OK
    @IsTest
    static void cardBusOKTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.business'];

        String cardBusKO = cardBusinessInput;
        cardBusKO = cardBusKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardBusKO = cardBusKO.replace('#VALUE_ID#','10');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardBusKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.business'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'cardBusOKTest - error list not empty');
    }

    // Test Card Corporate KO
    @IsTest
    static void cardCorpKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.corporate'];

        String cardCorpKO = cardCorpInput;
        cardCorpKO = cardCorpKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardCorpKO = cardCorpKO.replace('#VALUE_ID#','5');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardCorpKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.corporate'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(Label.cuco.cond_card_corporate_value_error, errorList[0], 'cardCorpKOTest - error does not match');
    }

    // Test Card Corporate OK
    @IsTest
    static void cardCorpOKTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.corporate'];

        String cardCorpKO = cardCorpInput;
        cardCorpKO = cardCorpKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardCorpKO = cardCorpKO.replace('#VALUE_ID#','20');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardCorpKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.corporate'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'cardCorpOKTest - error list not empty');
    }

    // Test Card Express KO
    @IsTest
    static void cardExpKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.express'];

        String cardExpKO = cardExpInput;
        cardExpKO = cardExpKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardExpKO = cardExpKO.replace('#VALUE_ID#','5');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardExpKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.others.express'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(Label.cuco.cond_card_express_value_error, errorList[0], 'cardExpKOTest - error does not match');
    }

    // Test Card Express OK
    @IsTest
    static void cardExpOKTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.express'];

        String cardExpKO = cardExpInput;
        cardExpKO = cardExpKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardExpKO = cardExpKO.replace('#VALUE_ID#','3');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardExpKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.others.express'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'cardExpOKTest - error list not empty');
    }

    // Test Card Gift KO
    @IsTest
    static void cardGiftKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.gift'];

        String cardGiftKO = cardGiftInput;
        cardGiftKO = cardGiftKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardGiftKO = cardGiftKO.replace('#VALUE_ID#','8');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardGiftKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.others.gift'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(Label.cuco.cond_card_gift_value_error, errorList[0], 'cardGiftKOTest - error does not match');
    }

    // Test Card Gift OK
    @IsTest
    static void cardGiftOKTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.gift'];

        String cardGiftKO = cardGiftInput;
        cardGiftKO = cardGiftKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardGiftKO = cardGiftKO.replace('#VALUE_ID#','0.5');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardGiftKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkCardsAtts(valuePerAttMap.get('card.bbva.others.gift'), condDetailsMap.get(catCondCard[0].Id));

        System.assertEquals(true, errorList.isEmpty(), 'cardGiftOKTest - error list not empty');
    }

    // Test Full Range KO
    @IsTest
    static void fullRangeKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.business'];

        String cardBusKO = cardBusinessInput;
        cardBusKO = cardBusKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardBusKO = cardBusKO.replace('#VALUE_ID#','25');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardBusKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final Map<String,cuco__ps_catalog_attribute__c> attDetailsMap =  ValidationsCond_Helper.getAttDetails();

        final Map<String,Map<String,cuco__ps_catalog_condition_standard__c>> standardValuesMap = ValidationsCond_Helper.getStandardValues(condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkAttRange(valuePerAttMap.get('card.bbva.business'), standardValuesMap.get('card.bbva.business'), attDetailsMap);

        System.assertEquals(1, errorList.size(), 'fullRangeKOTest - error list size');
    }

    // Test Max Range KO
    @IsTest
    static void maxRangeKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.corporate'];

        String cardKO = cardCorpInput;
        cardKO = cardKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardKO = cardKO.replace('#VALUE_ID#','25');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final Map<String,cuco__ps_catalog_attribute__c> attDetailsMap =  ValidationsCond_Helper.getAttDetails();

        final Map<String,Map<String,cuco__ps_catalog_condition_standard__c>> standardValuesMap = ValidationsCond_Helper.getStandardValues(condAttMap);

        final List<String> errorList =  ValidationsCond_Helper.checkAttRange(valuePerAttMap.get('card.bbva.corporate'), standardValuesMap.get('card.bbva.corporate'), attDetailsMap);

        System.assertEquals(1, errorList.size(), 'maxRangeKOTest - error list size');
    }

    // Test Min Range KO
    @IsTest
    static void minRangeKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.express'];

        String cardKO = cardExpInput;
        cardKO = cardKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardKO = cardKO.replace('#VALUE_ID#','0');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final Map<String,cuco__ps_catalog_attribute__c> attDetailsMap =  ValidationsCond_Helper.getAttDetails();

        final Map<String,Map<String,cuco__ps_catalog_condition_standard__c>> standardValuesMap = ValidationsCond_Helper.getStandardValues(condAttMap);

        List<String> errorList =  ValidationsCond_Helper.checkAttRange(valuePerAttMap.get('card.bbva.others.express'), standardValuesMap.get('card.bbva.others.express'), attDetailsMap);

        System.assertEquals(1, errorList.size(), 'minRangeKOTest - error list size');
    }

    // Test No Range KO
    @IsTest
    static void noRangeKOTest() {

        final List<ps_catalog_condition__c> catCondCard = [SELECT Id FROM ps_catalog_condition__c WHERE gf_psc_condition_id__c = 'card.bbva.others.gift'];

        String cardKO = cardGiftInput;
        cardKO = cardKO.replace('#CONDITION_ID#',catCondCard[0].Id);
        cardKO = cardKO.replace('#VALUE_ID#','100');

        final ConditionsValidationInput_Wrapper inputCondList = (ConditionsValidationInput_Wrapper)System.JSON.deserialize(cardKO, ConditionsValidationInput_Wrapper.class);

        final Map<Id,cuco__ps_catalog_condition__c> condDetailsMap = ValidationsCond_Helper.getCondDetails(inputCondList);

        final Map<String,cuco__ps_catalog_condition_attribute__c> condAttMap = ValidationsCond_Helper.getCatCondAtt(condDetailsMap.keySet());

        final Map<String,Map<String,String>> valuePerAttMap =  ValidationsCond_Helper.getAttributesByCondition(inputCondList, condDetailsMap, condAttMap);

        final Map<String,cuco__ps_catalog_attribute__c> attDetailsMap =  ValidationsCond_Helper.getAttDetails();

        final Map<String,Map<String,cuco__ps_catalog_condition_standard__c>> standardValuesMap = ValidationsCond_Helper.getStandardValues(condAttMap);

        List<String> errorList =  ValidationsCond_Helper.checkAttRange(valuePerAttMap.get('card.bbva.others.gift'), standardValuesMap.get('card.bbva.others.gift'), attDetailsMap);

        System.assertEquals(0, errorList.size(), 'noRangeKOTest - error list size');
    }
}