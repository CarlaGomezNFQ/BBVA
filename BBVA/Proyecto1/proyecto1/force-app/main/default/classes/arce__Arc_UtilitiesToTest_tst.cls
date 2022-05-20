/**
  * @File Name          : Arc_Gen_ScheduleInSan_Controller_Test.cls
  * @Description        : Utils test class to create test data
  * @Author             : Diego Miguel Tamarit - diego.miguel.contractor@bbva.com / dmiguelt@minsait.com
  * @Group              : ARCE
  * @Last Modified By   : eduardoefrain.hernandez.contractor@bbva.com
  * @Last Modified On   : 08-31-2020
  * @Modification Log   :
  *_________________________________________________________________________________
  * Version    Date           Author                                       Description
  * 1.0        11/04/2019     diego.miguel.contractor@bbva.com    	        Creation.
  * 1.1        26/04/2019     diego.miguel.contractor@bbva.com             Added getEconomicParticipations // listParticipants custom settings URL
  * 1.2        01/07/2019     ricardo.almanza.contractor@bbva.com          Added crearLimitExposures
  * 1.3        27/08/2019     luisruben.quinto.munoz@bbva.com              Delete reference to arce__id__c
  * 1.4        26/09/2019     javier.soto.carrascosa@bbva.com              Remove unused iaso
  * 1.4.1      02/12/2019     german.sanchez.perez.contractor@bbva.com
  *                          franciscojavier.bueno@bbva.com               Api names modified with the correct name on business glossary
  * 1.5        20/12/2019     mariohumberto.ramirez.contractor@bbva.com    Added new custom setting for Financial Statement Details service
  *                                                                       in crearIasoUrlsCustomSettings method
  * 1.6        07/01/2019     javier.soto.carrascosa@bbva.com              Add getSRAccounts and setupAccounts methods, remove unused methods
  * 1.7        24/01/2020     juanmanuel.perez.ortiz.contractor@bbva.com   Remove logic static parameters to ASO services
  * 1.8        09/03/2020     eduardoefrain.hernandez.contractor@bbva.com  update methods because of Indepentent Rating (RAIP)
  * 1.9        29/03/2020     javier.soto.carrascosa@bbva.com              add support for product load through static resource
  * 2.0        13/05/2020     cesaroctavio.villanueva.cebal@bbva.com       added value for financial sponsor indicator in account
  * 2.1        01/06/2020     joseluis.garcia4.contractor@bbva.com         Add currency value to AHA.
  * 2.2        12/06/2020     joseluis.garcia4.contractor@bbva.com         Add new createStandardPricebookEntries method
  * 2.3        20/07/2020     juanignacio.hita.contractor@bbva.com         Add new setupFFSS method
  * 2.4        03/08/2020     juanignacio.hita.contractor@bbva.com         Add new crearDependentVal method
  * 2.5        11/08/2020     javier.soto.carrascosa@bbva.com              Update sector field
  * 2.6        15/09/2020     javier.soto.carrascosa@bbva.com              Create sector active by default for tests
  * 2.7        18/09/2020     juanignacio.hita.contractor@bbva.com         Changed crearFinStatement method
  * 2.8        23/09/2020     saimassimilianno.jordana.contractor@bbva.com Added arce.
  * 2.9        14/06/2021     juanignacio.hita.contractor@bbva.com         Revert changes pull request 33 and create new version
  * ------------------------------------------------------------------------------------------------
  */
@SuppressWarnings('PMD.CouplingBetweenObjects, PMD.ApexSharingViolations, PMD.CyclomaticComplexity, PMD.ExcessiveglobalCount, PMD.ExcessiveParameterList, sf:TooManyMethods, sf:ExcessiveClassLength')
@isTest
global with sharing class Arc_UtilitiesToTest_tst {
    /** ------------------------------------------------------------------------------------------------
    * @Description PERFILMAPA map for profiles
    * ------------------------------------------------------------------------------------------------
    */
    global static final Map<String, Profile> PERFILMAPA = new Map<String, Profile>();
    /** ------------------------------------------------------------------------------------------------
    * @Description utility map of roles
    * ------------------------------------------------------------------------------------------------
    */
    global static final Map<String, UserRole> ROLMAPA   = new Map<String, UserRole>();
    /** ------------------------------------------------------------------------------------------------
    * @Description utility list of profiles
    * ------------------------------------------------------------------------------------------------
    */
    global static final List<Profile> LSTPROFILE;
    /** ------------------------------------------------------------------------------------------------
    * @Description utility list of user roles
    * ------------------------------------------------------------------------------------------------
    */
    global static final List<UserRole> USERROLE;
    /** ------------------------------------------------------------------------------------------------
    * @Description MAPRTACC
    * ------------------------------------------------------------------------------------------------
    */
    global static final Map<String, RecordType> MAPRTACC = new Map<String, RecordType>();
    /** ------------------------------------------------------------------------------------------------
    * @Description RTYPESCLIENTES
    * ------------------------------------------------------------------------------------------------
    */
    global static final List<RecordType> RTYPESCLIENTES;

    static {
        RTYPESCLIENTES = new List<RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType='Account']);
        for(RecordType rt:RTYPESCLIENTES) { MAPRTACC.put(rt.Name, rt); }
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description create an instance for profiles and roles
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * ------------------------------------------------------------------------------------------------
    */
    static {
        LSTPROFILE = new List<Profile>([SELECT Id, Name FROM Profile WHERE Name != null]); //NOSONAR
        USERROLE = new List<UserRole>([SELECT Id, Name FROM UserRole WHERE Name != null]); //NOSONAR
        for(Profile perfil:LSTPROFILE) {
            PERFILMAPA.put(perfil.Name, perfil);
        }
        for(UserRole ur:USERROLE) {
            ROLMAPA.put(ur.Name, ur);
        }
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Method that assert the max number of querys
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Method:      maxNumQuerys
    * @Date     Created: 2019-05-22
    * @param void
    * @return void
    * @example maxNumQuerys()
    * ------------------------------------------------------------------------------------------------
    */
    @isTest static void maxNumQuerys() {
        final Integer mAXQUERY = Limits.getLimitQueries();
        final Integer nUMQUERY = mAXQUERY - 1;
        System.assert(Limits.getQueries() < nUMQUERY, 'numero de querys dentro del rango  permitido');
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Método que retorna el id del recordtype correspondiente
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Method:      getRecordTypeId
    * @Date     Created: 2019-05-22
    * @param objectName -  name of the object
    * @return developerName -developerName for record type
    * @example getRecordTypeId(name)
    * ------------------------------------------------------------------------------------------------
    */
    global static Id getRecordTypeId(String objectName, String developerName) {
        return [SELECT id FROM recordType WHERE SobjectType =: objectName AND DeveloperName =: developerName LIMIT 1][0].id;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Método que retorna el iaso correspondiente
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Method:      crearIasoUrlsCustomSettings
    * @Date     Created: 2019-05-22
    * @param void
    * @return return custom settings (iaso__GBL_Rest_Services_Url__c)
    * @example crearIasoUrlsCustomSettings(name)
    * ------------------------------------------------------------------------------------------------
    */
    global static List<sObject> crearIasoUrlsCustomSettings() {

        final List<iaso__GBL_Rest_Services_Url__c> iasoCnfList = new List<iaso__GBL_Rest_Services_Url__c>();
        final map<String,String> iasoNameUrlMap = new map<String,String>();
        iasoNameUrlMap.put('GrantingTickets', 'https://maxwebseallo.prev.bancomer.mx/QSRV_A02/TechArchitecture/mx/grantingTicket/V02');
        iasoNameUrlMap.put('GrantingTicketsDev', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/TechArchitecture/mx/grantingTicket/V02');
        iasoNameUrlMap.put('pathEngine', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/risk-business-admissions/v0/risk-assessments/');
        iasoNameUrlMap.put('ratiosEngine', 'https://maxwebseal.bancomer.mx/QSRV_A02/enterpriseRatings/V01/');
        iasoNameUrlMap.put('financialStatements', 'https://maxwebseal.bancomer.mx/QSRV_A02/enterpriseRatings/V01/');
        iasoNameUrlMap.put('validateRatingPersistance', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/risks/v0/businesses-financial-relationships');
        iasoNameUrlMap.put('economicParticipations', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/economic-groups/v1/economic-groups/economic-participations');
        iasoNameUrlMap.put('listParticipants', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/economic-groups/v1/economic-groups/');
        iasoNameUrlMap.put('listCustomers', 'https://maxwebsealdesa.prev.bancomer.mx:6443/SRVS_A02/customers/v1/customers');
        iasoNameUrlMap.put('ratingEngine', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/risk-business-admissions/v0/risk-assessments');
        iasoNameUrlMap.put('triageEngine', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/risk-business-admissions/v0/risk-assessments');
        iasoNameUrlMap.put('encryptClients', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/proxyValueCipher/V01/security');
        iasoNameUrlMap.put('riskassessments', 'https://maxwebsealdesa.prev.bancomer.mx:6443/QSRV_A02/proxyValueCipher/V01/security');
        iasoNameUrlMap.put('financialStatementDetails', 'https://maxwebsealdesa.prev.bancomer.mx:6443/SRVS_A02/businesses/v0/businesses/');
        iasoNameUrlMap.put('overRating', 'https://maxwebsealqa.prev.bancomer.mx/SRVS_A02/risk-business-admissions/v0/risk-assessments');

        iaso__GBL_Rest_Services_Url__c cSetting = null;
        for(String key : iasoNameUrlMap.keySet()) {
            cSetting = new iaso__GBL_Rest_Services_Url__c();
            cSetting.name = key;
            cSetting.iaso__Url__c = iasoNameUrlMap.get(key);
            iasoCnfList.add(cSetting);
        }

        return iasoCnfList;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Método que retorna un objeto User
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearUsuario
    * @param strLastName param for create user
    * @param strProfileName param for create user
    * @param strRol param for create user
    * @return User created
    * @example crearUsuario(String strLastName, String strProfileName, String strRol) {
    * ------------------------------------------------------------------------------------------------
    */
    global static User crearUsuario(String strLastName, String strProfileName, String strRol) {
        final String email                  = 'tstBBVA'+(Math.random()*10000)+'@bbva.test.com';
        final User usuario                  = new User();
        usuario.LastName              = strLastName;
        usuario.Alias                 = String.valueOf((Math.random()*10000).round());
        usuario.Email                 = email;
        usuario.UserName              = email;
        usuario.EmailEncodingKey      = 'UTF-8';
        usuario.LanguageLocaleKey     = 'en_US';
        usuario.TimeZoneSidKey        = 'America/Mexico_City';
        usuario.LocaleSidKey          = 'en_US';
        usuario.IsActive              = true;
        usuario.ProfileId             = PERFILMAPA.get(strProfileName).Id;
        if(String.isNotBlank(strRol)) {
            usuario.UserRoleId = ROLMAPA.get(strRol).Id;
        }
        usuario.CompanyName           = 'SulAmérica';
        return usuario;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto cliente
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearCuenta
    * @param strName   param for create Account
    * @param devNameRT   param for create Account
    * @param idParentAccount   param for create Account
    * @param strNumber param for create Account
    * @return Account created
    * @example crearCuenta(String strName, String devNameRT, Id idParentAccount, String strNumber) {
    * ------------------------------------------------------------------------------------------------
    */
    global static Account crearCuenta(String strName, String devNameRT, Id idParentAccount, String strNumber) {
        final Account cliente          = new Account();
        cliente.Name             = strName;
        cliente.AccountNumber    = strNumber;
        cliente.parentId = idParentAccount;
        return cliente;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Analysis__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearArceAnalysis
    * @param strName   param for create arce__Analysis__c
    * @param devNameRT   param for create arce__Analysis__c
    * @param accountGroup   param for create arce__Analysis__c
    * @return arce__Analysis__c created
    * @example crearArceAnalysis(String strName, String devNameRT, id accountGroupId) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Analysis__c crearArceAnalysis(String strName, String devNameRT, id accountGroupId) {

        final arce__Analysis__c arceVar = new arce__Analysis__c();
        arceVar.Name = strName;
        arceVar.arce__Group__c = accountGroupId;
        if(devNameRT != null) {
            arceVar.RecordTypeId = getRecordTypeId('arce__Analysis__c', devNameRT);
        }
        arceVar.arce__Stage__c = '1';
        arceVar.arce__wf_status_id__c = '01';

        return arceVar;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Sector__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearSector
    * @param strName   param for create arce__Sector__c
    * @param sectorType   param for create arce__Sector__c
    * @param devNameRT   param for create arce__Sector__c
    * @return arce__Sector__c created
    * @example crearSector(String strName, String sectorType, String devName, String devNameRT) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Sector__c crearSector(String strName, String sectorType, String devName, String devNameRT) {
        final arce__Sector__c sector = new arce__Sector__c();
        sector.Name = strName;
        sector.arce__developer_name__c = devName;
        sector.arce__analysis_template_id__c = devName;
        sector.arce__analysis_section_type__c = sectorType;
        sector.arce__sector_analisis_type__c = '2';
        sector.arce__analysis_section_list__c = 's-01-100;s-01-200;s-01-300;s-01-400;s-01-500;s-01-600';
        sector.arce__active_type__c = true;
        if(devNameRT != null) {
            sector.RecordTypeId = getRecordTypeId('arce__Sector__c', devNameRT);
        }
        return sector;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Account_has_Analysis__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      AccountHasAnalysis
    * @param sectorId   param for create arce__Account_has_Analysis__c
    * @param arceAnalysis   param for create arce__Account_has_Analysis__c
    * @param clientId   param for create arce__Account_has_Analysis__c
    * @param devNameRT   param for create arce__Account_has_Analysis__c
    * @return arce__Account_has_Analysis__c created
    * @example crearAccHasAnalysis(Id sectorId, Id arceAnalysisId, Id clientId, String sectorRtType) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Account_has_Analysis__c crearAccHasAnalysis(Id sectorId, Id arceAnalysisId, Id clientId, String sectorRtType) {

        final arce__Account_has_Analysis__c accHasAnalysis = new arce__Account_has_Analysis__c();
        accHasAnalysis.arce__gf_company_economic_actvy_id__c = String.valueOf((Math.random()*10000000).round());
        accHasAnalysis.arce__analysis_template_id__c = sectorRtType;
        accHasAnalysis.arce__Analysis__c = arceAnalysisId;
        accHasAnalysis.arce__Customer__c = clientId;
        accHasAnalysis.arce__enterprise_group_type__c = '1';
        accHasAnalysis.arce__client_refinanced_type__c = '1';
        accHasAnalysis.arce__client_refinanced_desc__c = 'Test de Prueba';
        accHasAnalysis.arce__sector_desc__c = 'Hoteleria';
        accHasAnalysis.arce__subsector_desc__c = 'sub Hoteleria';
        accHasAnalysis.arce__economic_activity_sector_desc__c ='Comercio';
        accHasAnalysis.arce__rating_econ_sector_tmpl_id__c = '4';
        accHasAnalysis.arce__currency_id__c = 'EUR';
        accHasAnalysis.arce__employees_number__c = 300;
        accHasAnalysis.arce__dependency_degree_cust_type__c = '1';
        return accHasAnalysis;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Financial_Statements__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearFinStatement
    * @param clientId   param for create arce__Financial_Statements__c
    * @param accHasAnalysisId   param for create arce__Financial_Statements__c
    * @param ratingId   param for create arce__Financial_Statements__c
    * @param devNameRT   param for create arce__Financial_Statements__c
    * @return arce__Financial_Statements__c created
    * @example crearFinStatement(Id clientId, Id accHasAnalysisId, Id ratingId, String devNameRT) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Financial_Statements__c crearFinStatement(Id clientId, Id accHasAnalysisId, Id ratingId, String devNameRT) {

        final arce__Financial_Statements__c finStatement = new arce__Financial_Statements__c();
        finStatement.arce__account_id__c = clientId;
        finStatement.arce__account_has_analysis_id__c = accHasAnalysisId;
        finStatement.arce__rating_id__c = ratingId;
        finStatement.arce__status_type__c = '2';
        if(devNameRT != null) {
            finStatement.RecordTypeId = getRecordTypeId('arce__Financial_Statements__c', devNameRT);
        }

        return finStatement;
    }


    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__rating__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearRating
    * @param devNameRT   param for create arce__rating__c
    * @return arce__rating__c created
    * @example crearRating(String devNameRT) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__rating__c crearRating(String devNameRT) {

        final arce__rating__c rating = new arce__rating__c();
        if(devNameRT != null) {
            rating.RecordTypeId = getRecordTypeId('arce__rating__c', devNameRT);
        }

        return rating;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__rating__c con detalle
    * ------------------------------------------------------------------------------------------------
    * @Author   Eduardo Efraín Hernandez Rendon  eduardoefrain.hernandez.contractor@bbva.com
    * @Date     Created: 2020-02-25
    * @Method:  createRatingObj
    * @param String ratingId - Unique Id of the calculated rating
    * @param String longFinalValue - Final Rating expressed in long scale
    * @param String shortFinalValue - Final Rating expressed in short scale
    * @param String ratingStatus - Status of the rating Calculated(2)/Validated(3)
    * @return arce__rating__c created
    * @example createRatingObj(String ratingId, String longFinalValue, String shortFinalValue, String ratingStatus)
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__rating__c createRatingObj(String ratingId, String longFinalValue, String shortFinalValue, String ratingStatus) {

        final arce__rating__c rating = new arce__rating__c();
        rating.arce__rating_id__c = ratingId;
        rating.arce__rating_long_value_type__c = longFinalValue;
        rating.arce__rating_short_value_type__c = shortFinalValue;
        rating.arce__status_type__c = ratingStatus;

        return rating;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__limits_typology__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearLimitTypology
    * @param strName   param for create arce__limits_typology__c
    * @param parentTypologyId   param for create arce__limits_typology__c
    * @param typoLevelId   param for create arce__limits_typology__c
    * @return arce__limits_typology__c created
    * @example crearLimitTypology(String strName, Id parentTypologyId, String typoLevelId) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__limits_typology__c crearLimitTypology(String strName, Id parentTypologyId, String typoLevelId) {

        final arce__limits_typology__c limitTyp = new arce__limits_typology__c();
        limitTyp.arce__risk_typology_level_id__c = typoLevelId;
        limitTyp.Name = strName;
        limitTyp.arce__risk_typology_parent_id__c = parentTypologyId;

        return limitTyp;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__limits_exposures__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearLimitExposures
    * @param parentExp   param for create arce__limits_exposures__c
    * @param devNameRT   param for create arce__limits_exposures__c
    * @param accHas   param for create arce__limits_exposures__c
    * @param limitTyp   param for create arce__limits_exposures__c
    * @return arce__limits_exposures__c created
    * @example crearLimitExposures(Id parentExp, String devNameRT, Id accHas, Id limitTyp) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__limits_exposures__c crearLimitExposures(Id parentExp, String devNameRT, Id accHas, Id limitTyp) {
        final arce__limits_exposures__c limitExp = new arce__limits_exposures__c();
        limitExp.arce__account_has_analysis_id__c = accHas;
        limitExp.arce__limits_typology_id__c = limitTyp;
        limitExp.arce__limits_exposures_parent_id__c = parentExp;
        return limitExp;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Data_Collections__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearDataCollection
    * @param strName   param for create arce__Data_Collections__c
    * @param devNameRT   param for create arce__Data_Collections__c
    * @param collectionType   param for create arce__Data_Collections__c
    * @return arce__Data_Collections__c created
    * @example crearDataCollection(String strName, String devNameRT,String collectionType) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Data_Collections__c crearDataCollection(String strName, String devNameRT,String collectionType) {
        final arce__Data_Collections__c dataCol = new arce__Data_Collections__c();
        dataCol.Name = strName;
        dataCol.arce__collection_table__c = collectionType;
        if(devNameRT != null) {
            dataCol.RecordTypeId = getRecordTypeId('arce__Data_Collections__c', devNameRT);
        }

        return dataCol;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__main_banks__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearMainBanks
    * @param accHasAnalysisId   param for create arce__main_banks__c
    * @param devNameRT   param for create arce__main_banks__c
    * @return arce__main_banks__c created
    * @example crearMainBanks(Id accHasAnalysisId, String devNameRT) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__main_banks__c crearMainBanks(Id accHasAnalysisId, String devNameRT) {

        final arce__main_banks__c mainBanks = new arce__main_banks__c();
        mainBanks.arce__account_has_analysis_id__c = accHasAnalysisId;
        if(devNameRT != null) {
            mainBanks.RecordTypeId = getRecordTypeId('arce__main_banks__c', devNameRT);
        }

        return mainBanks;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__risk_position_summary__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearRiskPositionSummary
    * @param accHasAnalysisId   param for create arce__risk_position_summary__c
    * @param devNameRT   param for create arce__risk_position_summary__c
    * @return arce__risk_position_summary__c created
    * @example crearRiskPositionSummary(Id accHasAnalysisId, String devNameRT) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__risk_position_summary__c crearRiskPositionSummary(Id accHasAnalysisId, String devNameRT) {

        final arce__risk_position_summary__c rskPositionSumm = new arce__risk_position_summary__c();
        rskPositionSumm.arce__account_has_analysis_id__c = accHasAnalysisId;
        if(devNameRT != null) {
            rskPositionSumm.RecordTypeId = getRecordTypeId('arce__risk_position_summary__c', devNameRT);
        }

        return rskPositionSumm;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Table_Content_per_Analysis__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearTableContentAnalysis
    * @param accHasAnalysisId   param for create arce__Table_Content_per_Analysis__c
    * @param dataColId   param for create arce__Table_Content_per_Analysis__c
    * @param devNameRT   param for create arce__Table_Content_per_Analysis__c
    * @param year   param for create arce__Table_Content_per_Analysis__c
    * @return arce__Table_Content_per_Analysis__c created
    * @example crearTableContentAnalysis(Id accHasAnalysisId, Id dataColId, String devNameRT,String year) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Table_Content_per_Analysis__c crearTableContentAnalysis(Id accHasAnalysisId, Id dataColId, String devNameRT,String year) {

        final arce__Table_Content_per_Analysis__c tableContAnalysis = new arce__Table_Content_per_Analysis__c();
        tableContAnalysis.arce__account_has_analysis_id__c = accHasAnalysisId;
        tableContAnalysis.arce__Data_Collection_Id__c = dataColId;
        tableContAnalysis.arce__table_content_year__c=year;
        if(devNameRT != null) {
            tableContAnalysis.RecordTypeId = getRecordTypeId('arce__Table_Content_per_Analysis__c', devNameRT);
        }
        return tableContAnalysis;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Third_Participant__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearTableContentAnalysis
    * @param devNameRT   param for create arce__Third_Participant__c
    * @return arce__Third_Participant__c created
    * @example crearThirdParticipant(String devNameRT) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Third_Participant__c crearThirdParticipant(String devNameRT) {

        final arce__Third_Participant__c thirdParticipant = new arce__Third_Participant__c();
        if(devNameRT != null) {
            thirdParticipant.RecordTypeId = getRecordTypeId('arce__Third_Participant__c', devNameRT);
        }

        return thirdParticipant;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto arce__Third_Participant_Details__c
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearThirdParticipantDetails
    * @param accHasAnalysisId   param for create arce__Third_Participant_Details__c
    * @param thirdPartId   param for create arce__Third_Participant_Details__c
    * @param devNameRT   param for create arce__Third_Participant_Details__c
    * @return arce__Third_Participant_Details__c created
    * @example crearThirdParticipantDetails(Id accHasAnalysisId, Id thirdPartId, String devNameRT) {
    * ------------------------------------------------------------------------------------------------
    */
    global static arce__Third_Participant_Details__c crearThirdParticipantDetails(Id accHasAnalysisId, Id thirdPartId, String devNameRT) {

        final arce__Third_Participant_Details__c thirdPartDetails = new arce__Third_Participant_Details__c();
        thirdPartDetails.arce__account_has_analysis_id__c = accHasAnalysisId;
        thirdPartDetails.arce__Third_Participant_id__c = thirdPartId;
        if(devNameRT != null) {
            thirdPartDetails.RecordTypeId = getRecordTypeId('arce__Third_Participant_Details__c', devNameRT);
        }
        return thirdPartDetails;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Method that creates products for test clases
    * ------------------------------------------------------------------------------------------------
    * @Author   Javier Soto Carrascosa javier.soto.carrascosa@bbva.com
    * @Date     Created: 2020-03-29
    * @Method:      setupProducts
    * @param void
    * @return void
    * @example setupProducts()
    * ------------------------------------------------------------------------------------------------
    */
    global static void setupProducts() {
        if (getSRAccounts('Arc_Gen_ProductTest').size() == 1) {
            Test.loadData(Product2.sObjectType, 'Arc_Gen_ProductTest');

            if (getSRAccounts('Arc_Gen_PricebookTestData').size() == 1 && getSRAccounts('Arc_Gen_PricebookEntryTestData').size() == 1) {
                createStandardPricebookEntries();
                Test.loadData(Pricebook2.sObjectType, 'Arc_Gen_PricebookTestData');
                Test.loadData(PricebookEntry.sObjectType, 'Arc_Gen_PricebookEntryTestData');
            }
        } else {
            Product2 prod1 = new Product2();
            prod1 = crearProduct2('testProduct', 'TP_0010', '000100030001');
            insert prod1;
            Product2 prod2 = new Product2();
            prod2 = crearProduct2('nameTest', 'familyTest', '000100030006');
            insert prod2;
            Product2 prod3 = new Product2();
            prod3 = crearProduct2('credito simple', null, '');
            insert prod3;
        }
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Method that creates a standard pricebook entry for each product.
    * ------------------------------------------------------------------------------------------------
    * @Author   José Luis García <joseluis.garcia4.contractor@bbva.com>
    * @Date     Created: 2020-06-12
    * @Method:  createStandardPricebookEntries()
    * @param void
    * @return void
    * ------------------------------------------------------------------------------------------------
    */
    global static void createStandardPricebookEntries() {
        final List<Product2> products = [SELECT Id FROM Product2];   // NOSONAR
        final List<PricebookEntry> entries = new List<PricebookEntry>();

        for (Product2 product : products) {
            entries.add(crearPriceBook(product.Id, 0, true));
        }

        insert entries;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto Product2
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearProduct2
    * @param name   param for create Product2
    * @param family   param for create Product2
    * @return Product2 created
    * @example crearProduct2(String name, String family) {
    * ------------------------------------------------------------------------------------------------
    */
    global static Product2 crearProduct2(String name, String family, String externalId) {
        Final Product2 nuevoProducto = new Product2();
        nuevoProducto.Name = name;
        nuevoProducto.Family = family;
        nuevoProducto.IsActive = true;
        nuevoProducto.ExternalId = externalId;

        return nuevoProducto;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto PriceBookEntry
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearPriceBook
    * @param objProductID   param for create PriceBookEntry
    * @param unitPrice   param for create PriceBookEntry
    * @param active   param for create PriceBookEntry
    * @return PriceBookEntry created
    * @example crearPriceBook(ID objProductID, Integer unitPrice, Boolean active ) {
    * ------------------------------------------------------------------------------------------------
    */
    global static PriceBookEntry crearPriceBook(ID objProductID, Integer unitPrice, Boolean active ) {
        final PricebookEntry objPBEntry = new PricebookEntry();
        objPBEntry.PriceBook2Id = Test.getStandardPricebookId();
        objPBEntry.Product2Id=objProductID;
        objPBEntry.UnitPrice=unitPrice;
        objPBEntry.IsActive=active;
        return objPBEntry;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description create a template for dynamic form
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearTemplate
    * @param name -  name of the template
    * @return temp - dyfr__Template__c object
    * @example crearTemplate(name)
    * ------------------------------------------------------------------------------------------------
    */
    global static dyfr__Template__c crearTemplate(string name) {
        final dyfr__Template__c temp = new dyfr__Template__c();
        temp.Name = name;
        return temp;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description create a tab for dynamic form
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearTab
    * @param name -  name of the tab
    * @param templateId - Id of the template object
    * @return tab - dyfr__Tab__c object
    * @example crearTab(name, templateId)
    * ------------------------------------------------------------------------------------------------
    */
    global static dyfr__Tab__c crearTab(string name, Id templateId) {
        final dyfr__Tab__c tab = new dyfr__Tab__c();
        tab.Name = name;
        tab.dyfr__Template__c = templateId;
        tab.dyfr__Tab_Code__c = 'BasicData';
        return tab;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description create field config data for dynamic form
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearfieldConfigData
    * @param sectionName - name of the section
    * @param tabId - Id of the tab
    * @param mapField - name of the mapfield
    * @return fieldConfig - dyfr__Field_Config__c object
    * @example crearfieldConfigData(string sectionName, string tabId, string mapField) {
    * ------------------------------------------------------------------------------------------------
    */
    global static dyfr__Field_Config__c crearfieldConfigData(string sectionName, string tabId, string mapField) {
        final dyfr__Field_Config__c fieldConfig = new dyfr__Field_Config__c();
        fieldConfig.dyfr__Section_name__c = sectionName;
        fieldConfig.dyfr__Map_field__c = mapField;
        fieldConfig.dyfr__Label__c = 'Comments';
        fieldConfig.dyfr__Tab__c = tabId;
        return fieldConfig;
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create data for the assessment tab
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example createAssessmentData()
    * ------------------------------------------------------------------------------------------------
    */
    global static void createAssessmentData() {
        final dyfr__Template__c template = Arc_UtilitiesToTest_tst.crearTemplate('s-01-400');
        insert template;
        final dyfr__Tab__c tab = Arc_UtilitiesToTest_tst.crearTab('Assessment', template.Id);
        tab.dyfr__Tab_Code__c = 'Generic_Assessment';
        insert tab;
        final dyfr__Field_Config__c fieldConfig = Arc_UtilitiesToTest_tst.crearfieldConfigData('Peer Analysis', tab.Id, 'arce__ebitda_less_70_peer_avg_type__c');
        fieldConfig.dyfr__Important__c = true;
        fieldConfig.dyfr__Type__c = 'List';
        fieldConfig.dyfr__Read_only__c = false;
        fieldConfig.dyfr__Hidden__c = false;
        insert fieldConfig;
        final dyfr__Field_Config__c fieldConfig2 = Arc_UtilitiesToTest_tst.crearfieldConfigData('Peer Analysis', tab.Id, 'arce__ebitda_less_70_peer_avg_desc__c');
        fieldConfig2.dyfr__Important__c = true;
        fieldConfig2.dyfr__Type__c = 'textArea';
        fieldConfig2.dyfr__Read_only__c = false;
        fieldConfig2.dyfr__Hidden__c = false;
        insert fieldConfig2;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create data for the basic data tab
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example createBasicDataData()
    * ------------------------------------------------------------------------------------------------
    */
    global static void createBasicDataData() {
        final dyfr__Template__c template2 = Arc_UtilitiesToTest_tst.crearTemplate('s-01-100');
        insert template2;
        final dyfr__Tab__c tab = crearTab('Basic Data', template2.Id);
        tab.dyfr__Tab_Code__c = 'Generic_BasicData';
        insert tab;
        final dyfr__Field_Config__c fieldConfig12 = crearfieldConfigData('Main Subsidiaries and affiliates', tab.Id, 'arce__mngmt_aggressiveness_type__c');
        fieldConfig12.dyfr__Important__c = true;
        fieldConfig12.dyfr__Type__c = 'List';
        fieldConfig12.dyfr__Read_only__c = false;
        fieldConfig12.dyfr__Hidden__c = false;
        insert fieldConfig12;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create data for the financial risk tab
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example createFinancialRiskData()
    * ------------------------------------------------------------------------------------------------
    */
    global static void createFinancialRiskData() {
        final dyfr__Template__c template3 = Arc_UtilitiesToTest_tst.crearTemplate('s-01-100');
        insert template3;
        final dyfr__Tab__c tab = Arc_UtilitiesToTest_tst.crearTab('Financial Risk', template3.Id);
        tab.dyfr__Tab_Code__c = 'Generic_FinancialRisk';
        insert tab;
        final dyfr__Field_Config__c fieldConfig13 = Arc_UtilitiesToTest_tst.crearfieldConfigData('Peer Analysis', tab.Id, 'arce__years_experience_mngmt_type__c');
        fieldConfig13.dyfr__Important__c = true;
        fieldConfig13.dyfr__Type__c = 'List';
        fieldConfig13.dyfr__Read_only__c = false;
        fieldConfig13.dyfr__Hidden__c = false;
        insert fieldConfig13;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create data for the business risk tab
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example createBusinessRiskData()
    * ------------------------------------------------------------------------------------------------
    */
    global static void createBusinessRiskData() {
        final dyfr__Template__c template4 = Arc_UtilitiesToTest_tst.crearTemplate('s-01-100');
        insert template4;
        final dyfr__Tab__c tab = Arc_UtilitiesToTest_tst.crearTab('Business Risk', template4.Id);
        tab.dyfr__Tab_Code__c = 'Generic_BusinessRisk';
        insert tab;
        final dyfr__Field_Config__c fieldConfig14 = Arc_UtilitiesToTest_tst.crearfieldConfigData('Peer Analysis', tab.Id, 'arce__years_experience_mngmt_type__c');
        fieldConfig14.dyfr__Important__c = true;
        fieldConfig14.dyfr__Type__c = 'List';
        fieldConfig14.dyfr__Read_only__c = false;
        fieldConfig14.dyfr__Hidden__c = false;
        insert fieldConfig14;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create data for the industry analysis tab
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example createIndustryAnalysisData()
    * ------------------------------------------------------------------------------------------------
    */
    global static void createIndustryAnalysisData() {
        final dyfr__Template__c template5 = Arc_UtilitiesToTest_tst.crearTemplate('s-01-100');
        insert template5;
        final dyfr__Tab__c tab = Arc_UtilitiesToTest_tst.crearTab('Industry Analysis', template5.Id);
        tab.dyfr__Tab_Code__c = 'Generic_IndustryAnalysis';
        insert tab;
        final dyfr__Field_Config__c fieldConfig14 = Arc_UtilitiesToTest_tst.crearfieldConfigData('Peer Analysis', tab.Id, 'arce__management_style_type__c');
        fieldConfig14.dyfr__Important__c = true;
        fieldConfig14.dyfr__Type__c = 'List';
        fieldConfig14.dyfr__Read_only__c = false;
        fieldConfig14.dyfr__Hidden__c = false;
        insert fieldConfig14;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create data for the Policies tab
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example createPolicies()
    * ------------------------------------------------------------------------------------------------
    */
    global static void createPolicies() {
        final dyfr__Template__c template5 = Arc_UtilitiesToTest_tst.crearTemplate('s-01-500');
        insert template5;
        final dyfr__Tab__c tab = Arc_UtilitiesToTest_tst.crearTab('Policies', template5.Id);
        tab.dyfr__Tab_Code__c = 'Generic_Policies';
        insert tab;
        final dyfr__Field_Config__c fieldConfig14 = Arc_UtilitiesToTest_tst.crearfieldConfigData('Peer Analysis', tab.Id, 'arce__management_style_type__c');
        fieldConfig14.dyfr__Important__c = true;
        fieldConfig14.dyfr__Type__c = 'List';
        fieldConfig14.dyfr__Read_only__c = false;
        fieldConfig14.dyfr__Hidden__c = false;
        insert fieldConfig14;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create data for accounts
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return void
    * @example setupAcccounts()
    * ------------------------------------------------------------------------------------------------
    */
    global static void setupAcccounts() {
        if (getSRAccounts('Arc_Gen_AccountTestDatachild').size() == 1 && getSRAccounts('Arc_Gen_AccountTestData').size() == 1) {
            Test.loadData(Account.sObjectType, 'Arc_Gen_AccountTestData');
            Test.loadData(Account.sObjectType, 'Arc_Gen_AccountTestDataChild');
        } else {
            Account grupo1 = new Account();
            grupo1 = crearCuenta('Group1Child', null, null, 'G000001');
            insert grupo1;
            Account grupo2 = new Account();
            grupo2 = crearCuenta('Group2Child', null, null, 'G000002');
            insert grupo2;
            Account cliente1 = new Account();
            cliente1 = crearCuenta('ChildGroup1', null, grupo1.Id, 'C000001');
            insert cliente1;
            Account cliente2 = new Account();
            cliente2 = crearCuenta('Child2Group1', null, grupo1.Id, 'C000002');
            insert cliente2;
            Account cliente3 = new Account();
            cliente3 = crearCuenta('ChildGroup2', null, grupo2.Id, 'C000004');
            insert cliente3;
            Account orphan1 = new Account();
            orphan1 = crearCuenta('OrphanChild', null, null, 'C000003');
            insert orphan1;
        }
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description validate if a static resource exists for account creation
    * ------------------------------------------------------------------------------------------------
    * @Author   Javier Soto Carrascosa javier.soto.carrascosa@bbva.com
    * @Date     Created: 2019-11-25
    * @Method:      getSRAccounts
    * @param name -  Void
    * @return List<StaticResource>
    * @example getSRAccounts()
    * ------------------------------------------------------------------------------------------------
    */
    global static List<StaticResource> getSRAccounts(string fileName) {
        return new List<StaticResource>([SELECT Id FROM StaticResource where Name=:fileName]);
    }

    /**
    * ------------------------------------------------------------------------------------------------
    * @Description: Método que retorna un objeto cliente
    * ------------------------------------------------------------------------------------------------
    * @Author   Mario Humberto Ramirez Lio  mariohumberto.ramirez.contractor@bbva.com
    * @Date     Created: 2019-05-22
    * @Method:      crearCuentaGrupo
    * @param strName   param for create Account
    * @param devNameRT   param for create Account
    * @param strNumber   param for create Account
    * @return Account created
    * @example crearCuentaGrupo(String strName, String devNameRT, String strNumber) {
    * ------------------------------------------------------------------------------------------------
    */
    global static Account crearCuentaGrupo(String strName, String devNameRT, String strNumber) {
        final Account cliente          = new Account();
        cliente.Name             = strName;
        cliente.AccountNumber    = strNumber;
        cliente.Industry         = 'Construction';
        return cliente;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create Delegation_Wrapper mockup
    * ------------------------------------------------------------------------------------------------
    * @param void
    * @return Arc_Gen_Delegation_Wrapper
    * @example Arc_Gen_Delegation_Wrapper = crearDelegationWrapper();
    * ------------------------------------------------------------------------------------------------
    */
    global static Map<String, String> crearMapaSaveScopeSanction(Id recordId, String sanction) {
        final Map<String, String> data = new Map<String, String>();
        data.put('recordId', recordId);
        data.put('idUserSelected', UserInfo.getUserId());
        data.put('userSelected', UserInfo.getName());
        data.put('sanction', sanction);
        data.put('descText', 'description');
        data.put('sancDate', String.valueOf(datetime.now()) );
        data.put('sancdateCometee', String.valueOf(datetime.now()));
        return data;
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Set data to financial statement test
    * ------------------------------------------------------------------------------------------------
    * @param arce__Financial_Statements__c ffss
    * @param String ffssId
    * @param String adjusted
    * @param String certi
    * @param Date dateType
    * @return void
    * @example setupFFSS(ffss, '1', '1', '1', '1', 'AUDITED', Date.today());
    * ------------------------------------------------------------------------------------------------
    */
    global static void setupFFSS(arce__Financial_Statements__c ffss, String params) {
        final Map<String, Object> mapParams = (Map<String, Object>) JSON.deserializeUntyped(params);
        ffss.arce__financial_statement_id__c = (String) mapParams.get('id');
        ffss.arce__ffss_submitted_type__c = (String) mapParams.get('submitType');
        ffss.arce__ffss_valid_type__c = (String) mapParams.get('validType');
        ffss.arce__ffss_adjusted_type__c = (String) mapParams.get('adjustedType');
        ffss.arce__ffss_certification_type__c = (String) mapParams.get('cerType');
        ffss.arce__financial_statement_end_date__c = Date.today().addDays(Integer.valueOf(mapParams.get('dateType')));
    }
    /**
    * ------------------------------------------------------------------------------------------------
    * @Description Create a dependent value with the data of the params
    * ------------------------------------------------------------------------------------------------
    * @param Id field config id
    * @param String labels
    * @param String values
    * @return dyfr__Dependent_value__c
    * @example dyfr__Dependent_value__c dependent = crearDependentVal(fcId, labels, values);
    * ------------------------------------------------------------------------------------------------
    */
    global static dyfr__Dependent_value__c crearDependentVal(Id fcId, String labels, String values) {
        final dyfr__Dependent_value__c depVal = new dyfr__Dependent_value__c();
        depVal.dyfr__LoV_labels__c = 'BAJO,MEDIO,ALTO';
        depVal.dyfr__LoV_values__c = '0012,0013,0014';
        depVal.dyfr__Field_Config__c = fcId;
        return depVal;
    }
}