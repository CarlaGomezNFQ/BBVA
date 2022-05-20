/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_Wrapper_Multitemplate
* @Author   BBVA Developers
* @Date     Created: 2020-07-06
* @Group    ARCE
* ------------------------------------------------------------------------------------------------
* @Description Wrapper Class for service
* ------------------------------------------------------------------------------------------------
* @Changes
*
* |2020-07-06 BBVA Developers.
*              Class creation.
* 2020-10-21    amunguia@bbva.com   add SP2 header to locate the template type
* 2020-12-01    saimassimilianno.jordana.contractor@bbva.com   get Subsection name from qualitative question.
* 2020-12-15    ivan.cons@bbva.com   Includes root parameter, used instead data on the multitemplate engine call
* 2021-01-27    ivan.cons@bbva.com   create new constructor to send riskassessmentId & participantId in multitemplateEngine
* 2021-07-26    saimassimilianno.jordana.contractor@bbva.com   Almost all the methods modified and others created to adapt to the 2012 model.
* 2021-09-13    amunguia.contractor@bbva.com    methods have been refactored to use sObject
* 2021-09-13    amunguia.contractor@bbva.com    a new method is created to send specific activities
* 2021-09-22    amunguia.contractor@bbva.com    the ratingModel structure is added to the wrapper.
* 2021-10-08    otiliaramona.veres.contractor@bbva.com    Added userscore for templates 118, 119 and 121
* ------------------------------------------------------------------------------------------------
*/
@SuppressWarnings('PMD.ExcessivePublicCount,PMD.ExcessiveParameterList')
public with sharing class Arc_Gen_Wrapper_Multitemplate {
    public List<WrapperMultitemplate> data{ get; set; }
    public List<WrapperMultitemplate> root{ get; set; }

    /**
    * @Description: string with the service name
    */
    Static Final String MODEL_2012 = '2012';

    /**
    * @Description: string with the service name
    */
    Static Final String MODEL_2019 = '2019';

    /**
    * @Description: string with the Section name to persist in 2012.
    */
    Static Final String SECTION_MANAG = 'MANAGEMENT';

    /**
    *-------------------------------------------------------------------------------
    * @Description Constructor
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public Arc_Gen_Wrapper_Multitemplate (String ahaId, String eventType, String model) {
        Set<String> parentIdSet = new Set<String>();
        parentIdSet.add(ahaId);

        this.root = model == MODEL_2019 ? processResp2019(parentIdSet, eventType) : processResp2012(parentIdSet, eventType);
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Constructor
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-27
    *--------------------------------------------------------------------------------
    **/
    public Arc_Gen_Wrapper_Multitemplate (String ahaId, String model) {
        Set<String> parentIdSet = new Set<String>();
        parentIdSet.add(ahaId);
        final Map<String,List<arce__Qualitative_question__mdt>> mapQQ = getQuestionsMap(); //NOSONAR
        Map<String, List<dyfr__Field_Config__c>> mapFieldConfigsByTemplate = getMapFieldConfigsByTemplate();
        this.root = model == MODEL_2019 ? perstInput2019(parentIdSet,mapFieldConfigsByTemplate,mapQQ) : perstInput2012(parentIdSet,mapFieldConfigsByTemplate,mapQQ);
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Constructor
    *--------------------------------------------------------------------------------
    * @ Author amunguia.contractor@bbva.com
    * @ Date   Created: 2021-09-13
    *--------------------------------------------------------------------------------
    **/
    public Arc_Gen_Wrapper_Multitemplate (SObject actty) {
        final Map<String,List<arce__Qualitative_question__mdt>> mapQQ = getQuestionsMap(); //NOSONAR
        Map<String, List<dyfr__Field_Config__c>> mapFieldConfigsByTemplate = getMapFieldConfigsBySection('Industry Risk');
        this.root = perstSpecificInput(actty,mapFieldConfigsByTemplate,mapQQ);
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Constructor
    *--------------------------------------------------------------------------------
    * @ Author ivan.cons@bbva.com
    * @ Date   Created: 2021-01-27
    *--------------------------------------------------------------------------------
    **/
    public Arc_Gen_Wrapper_Multitemplate (String ahaId, String eventType, String riskAssessmentId, String participantId, String model) {
        Set<String> parentIdSet = new Set<String>();
        parentIdSet.add(ahaId);
        this.root = model == MODEL_2019 ? jsonInput2019(parentIdSet,eventType,riskAssessmentId,participantId) : jsonInput2012(parentIdSet,eventType,riskAssessmentId,participantId);
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Sector
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class WrapperMultitemplate {

        /**
        * @Description: id of WrapperMultitemplate
        */
        public String id { get; set; }
        /**
        * @Description: Sector of Activity Split
        */
        public Sector sector { get; set; }
        /**
        * @Description: Sub Sector of Activity Split
        */
        public Subsector subsector { get; set; }
        /**
        * @Description: economicActivity of Activity Split
        */
        public EconomicActivity economicActivity{ get; set; }
        /**
        * @Description: industry of Activity Split
        */
        public Industry industry { get; set; }
        /**
        * @Description: countries of Activity Split
        */
        public List<Country> countries { get; set; }
        /**
        * @Description: riskScore of Activity Split
        */
        public RiskScore riskScore { get; set; }
        /**
        * @Description: competitivePositionGroupProfile of Activity Split
        */
        public CompetitivePositionGroupProfile competitivePositionGroupProfile { get; set; }
        /**
        * @Description: eventType of Activity Split
        */
        public String eventType { get; set; }
        /**
        * @Description: competitivePositionSections of Activity Split
        */
        public List<CompetitivePositionSection> competitivePositionSections { get; set; }
        /**
        * @Description: ratingModel of Activity Split
        */
        public RatingModel ratingModel { get; set; }
        /**
        *-------------------------------------------------------------------------------
        * @Description Contructor with Activity and eventType
        *--------------------------------------------------------------------------------
        **/
        public WrapperMultitemplate(SObject actty,String eventType) {
            String currentsObject = actty.Id.getSObjectType().getDescribe().getName();
            id = actty.Id;
            this.eventType = eventType;
            sector = new Sector((String) actty.get('arce__sector_id__c'));
            subsector = new Subsector((String) actty.get('arce__Subsector_id__c'));
            economicActivity = new EconomicActivity((String) actty.get('arce__gf_company_economic_actvy_id__c'));
            industry = new Industry(actty);
            countries = new List<Country>();
            ratingModel = new ratingModel(currentsObject == 'arce__Activity_Split__c' ? MODEL_2019 : MODEL_2012);
            if(currentsObject == 'arce__Activity_Split__c') {
                arce__Activity_Split__c current = (arce__Activity_Split__c) actty;
                for(arce__Geographic_Split__c geo : current.arce__Geographic_Splits__r){
                    countries.add(new Country(geo));
                  }
            } else {
                countries.add(new Country((arce__Activity_Split_2012__c) actty));
            }
            riskScore = new riskScore(actty);
        }
        /**
        *-------------------------------------------------------------------------------
        * @Description Contructor with Activity, lstFieldConfig and mapQuestions
        *--------------------------------------------------------------------------------
        **/
        public WrapperMultitemplate(SObject activity, List<dyfr__Field_Config__c> lstFieldConfig, Map<String, List<arce__Qualitative_question__mdt>> mapQQ) {
            String currentObject = activity.Id.getSObjectType().getDescribe().getName();
            id = activity.Id;
            sector = new Sector((String) activity.get('arce__sector_id__c'));
            subsector = new Subsector((String) activity.get('arce__Subsector_id__c'));
            economicActivity = new EconomicActivity((String) activity.get('arce__gf_company_economic_actvy_id__c'));
            industry = new Industry(activity);
            countries = new List<Country>();
            ratingModel = new ratingModel(currentObject == 'arce__Activity_Split__c' ? MODEL_2019 : MODEL_2012);
            riskScore = new riskScore(activity);
            if(currentObject == 'arce__Activity_Split__c') {
                arce__Activity_Split__c current = (arce__Activity_Split__c) activity;
                for(arce__Geographic_Split__c geo : current.arce__Geographic_Splits__r){
                    countries.add(new Country(geo));
                  }
            } else {
                countries.add(new Country((arce__Activity_Split_2012__c) activity));
            }
            final Map<String, List<dyfr__Field_Config__c>> mapaFCbySectn = getFieldConfigMap( mapQQ, lstFieldConfig, activity);
            competitivePositionSections = new List<CompetitivePositionSection>();
            for(String seccion : new List<String>(mapaFCbySectn.keySet())) {
                competitivePositionSections.add(new CompetitivePositionSection(seccion, mapaFCbySectn.get(seccion), mapQQ, activity));
            }
            //competitivePositionGroupProfile = new CompetitivePositionGroupProfile();
        }

        /**
        *-------------------------------------------------------------------------------
        * @Description Contructor with Activity, lstFieldConfig and mapQuestions
        *--------------------------------------------------------------------------------
        **/
        public WrapperMultitemplate(arce__Activity_Split_2012__c activity, List<dyfr__Field_Config__c> lstFieldConfig, Map<String, List<arce__Qualitative_question__mdt>> mapQQ) {
            id = activity.Id;
            sector = new Sector(activity.arce__sector_id__c);
            subsector = new Subsector(activity.arce__Subsector_id__c);
            economicActivity = new EconomicActivity(activity.arce__gf_company_economic_actvy_id__c);
            industry = new Industry(activity);
            riskScore = new riskScore(activity);
            countries = new List<Country>();
            ratingModel = new ratingModel(MODEL_2012);
            countries.add(new Country(activity));
            final Map<String, List<dyfr__Field_Config__c>> mapaFCbySectn = getFieldConfigMap( mapQQ, lstFieldConfig, activity);
            competitivePositionSections = new List<CompetitivePositionSection>();
            for(String seccion : new List<String>(mapaFCbySectn.keySet())) {
                competitivePositionSections.add(new CompetitivePositionSection(seccion, mapaFCbySectn.get(seccion), mapQQ, activity));
            }
            final String ahasId = activity.arce__Account_has_Analysis__c;
            CompetitivePositionSections.add(new CompetitivePositionSection(SECTION_MANAG, ahasId, arce.Arc_Gen_PersistModifiers_Data.getModifierVariablesDefinition('persistenceData2012')));
            //competitivePositionGroupProfile = new CompetitivePositionGroupProfile();
        }

        /**
        *-------------------------------------------------------------------------------
        * @Description Get field configs map by template
        *--------------------------------------------------------------------------------
        * @ Author amunguia.contractor@bbva.com
        * @ Date Created: 2021-09-13
        * @ return Map<String,List<dyfr__Field_Config__c>> map of fieldConfigs by template
        *--------------------------------------------------------------------------------
        **/

        public Map<String,List<dyfr__Field_Config__c>> getFieldConfigMap(Map<String, List<arce__Qualitative_question__mdt>> mapQQ, List<dyfr__Field_Config__c> lstFieldConfig, SObject activity) {
            final Map<String,List<dyfr__Field_Config__c>> mapaFCbySectn = new Map<String,List<dyfr__Field_Config__c>>();
            String block;
            for(dyfr__Field_Config__c fc : lstFieldConfig) {
                if (mapQQ.containsKey(fc.dyfr__Map_field__c)) {
                    for(arce__Qualitative_question__mdt q : mapQQ.get(fc.dyfr__Map_field__c)) {
                        if(q.arce__Template__c.split(';').contains((String) activity.get('arce__Template_type__c'))) {
                            block = q.arce__Subsection_Name__c;
                            break;
                        }
                    }
                    if(!mapaFCbySectn.containsKey(block)) {
                        mapaFCbySectn.put(block,new List<dyfr__Field_Config__c>());
                    }
                    mapaFCbySectn.get(block).add(fc);
                }
            }
            return mapaFCbySectn;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Sector
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class Sector {

        /**
        * @Description: value of the Sector
        */
        public String id{ get; set; }

        /**
        * @Description: Constructor of Sector.
        */
        public Sector(String currentId) {
            this.id = currentId;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Subsector
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class Subsector {

        /**
        * @Description: value of SubSector.
        */
        public String id{ get; set; }

        /**
        * @Description: Constructor of SubSector.
        */
        public Subsector(String currentId) {
            this.id = currentId;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Subsector
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date   Created: 2021-07-20
    *--------------------------------------------------------------------------------
    **/
    public class RatingModel {

        /**
        * @Description: value of RatingModel.
        */
        public String id{ get; set; }

        /**
        * @Description: Constructor of RatingModel.
        */
        public RatingModel(String currentId) {
            this.id = currentId;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON EconomicActivity
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class EconomicActivity {

        /**
        * @Description: value of EconomicActivity.
        */
        public String id{ get; set; }

        /**
        * @Description: Constructor of EconomicActivity.
        */
        public EconomicActivity(String id) {
            this.id = id;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Subindustry
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class Subindustry {

        /**
        * @Description: value of Subindustry.
        */
        public String id { get; set; }

        /**
        * @Description: Constructor of Subindustry.
        */
        public Subindustry(String currentId) {
            this.id = currentId;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Industry
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class Industry {

        /**
        * @Description: Value of Industry.
        */
        public String id { get; set; }
        /**
        * @Description: contributionType of Industry.
        */
        public String contributionType { get; set; }
        /**
        * @Description: contributionPercentage of Industry.
        */
        public Decimal contributionPercentage { get; set; }
        /**
        * @Description: subindustry of Industry.
        */
        public Subindustry subindustry { get; set; }

        /**
        * @Description: Constructor of Industry with Activity split
        */
        public Industry(SObject actty) {
            Id acttyId = (Id) actty.get('Id');
            String sObjectName = acttyId.getSObjectType().getDescribe().getName();
            id = (String) actty.get('arce__Template_type__c');
            final Map<String,String> subacttiesPickMap = Arc_Gen_Corporate_Utils.getPicklistLabels(sObjectName, 'arce__gf_activity_split_per_type__c');
            contributionType =  subacttiesPickMap.get((String) actty.get('arce__gf_activity_split_per_type__c')).toUpperCase();
            contributionPercentage = (Decimal) actty.get('arce__gf_subindustry_weight_per__c');
            subindustry = new Subindustry((String) actty.get('arce__gf_subactivity_id__c'));
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Country
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class Country {

        /**
        * @Description: Value of Country.
        */
        public String id { get; set; }
        /**
        * @Description: contributionType of Country.
        */
        public String contributionType { get; set; }
        /**
        * @Description: contributionPercentage of Country.
        */
        public Decimal contributionPercentage { get; set; }

        /**
        * @Description: Constructor of Country with Activity split and Geo.
        */
        public Country(arce__Geographic_Split__c geo) {
          id = geo.arce__Country__c;
          final Map<String,String> subacttiesPickMap = Arc_Gen_Corporate_Utils.getPicklistLabels('arce__Geographic_Split__c', 'arce__gf_geography_split_per_type__c');
          contributionType = subacttiesPickMap.get(geo.arce__gf_geography_split_per_type__c).toUpperCase();
          contributionPercentage = geo.arce__gf_geography_weight_per__c;
        }

        /**
        * @Description: Constructor of Country with Activity split 2012
        */
        public Country(arce__Activity_Split_2012__c actty) {
            id = actty.arce__Country__c;
            final Map<String,String> subacttiesPickMap = Arc_Gen_Corporate_Utils.getPicklistLabels('arce__Activity_Split_2012__c', 'arce__gf_activity_split_per_type__c');
            contributionType = subacttiesPickMap.get(actty.arce__gf_activity_split_per_type__c).toUpperCase();
            contributionPercentage = actty.arce__gf_subindustry_weight_per__c;
        }
    }
        /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON RiskScore
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class RiskScore {

        /**
        * @Description: Value of RiskScore.
        */
        public Decimal standard { get; set; }
        /**
        * @Description: userScore of RiskScore.
        */
        public Decimal userScore { get; set; }
        /**
        * @Description: engineScores of RiskScore.
        */
        public List<String> engineScores { get; set; }
        /**
        * @Description: comments of RiskScore.
        */
        public String comments { get; set; }

        /**
        * @Description: Constructor of RiskScore with Activity split 2012
        */
        public RiskScore(SObject activity) {
            this.standard = (Decimal) activity.get('arce__Industry_Risk__c') == null ? 0 : (Decimal) activity.get('arce__Industry_Risk__c');
            if(!String.isBlank((String) activity.get('arce__Final_Industry_Risk__c'))) {
                this.userScore = decimal.valueOf((String) activity.get('arce__Final_Industry_Risk__c'));
            } else {

                // Userscore is informed with the same value as standard for the 118,119,121 templates
                this.userScore = this.standard;
            }
            this.comments = (String) activity.get('arce__Industry_Risk_Comments__c');
        }
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON CompetitivePositionGroupProfile
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class CompetitivePositionGroupProfile {

        /**
        * @Description: Value of CompetitivePositionGroupProfile.
        */
        public String id { get; set; }

        /**
        * @Description: Constructor of CompetitivePositionGroupProfile
        */
        public CompetitivePositionGroupProfile() {
            this.id = '';
      }
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON CompetitivePositionGroupProfile
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class CompetitivePositionSection {

        /**
        * @Description: Value of CompetitivePositionSection.
        */
        public String id { get; set; }
        /**
        * @Description: questions of CompetitivePositionSection.
        */
        public List<Question> questions { get; set; }

        /**
        * @Description: Constructor of CompetitivePositionSection with activity split
        */
        public CompetitivePositionSection(String currentId,List<dyfr__Field_Config__c> questions, Map<String, List<arce__Qualitative_question__mdt>> mapQQ, SObject activity) {
            final List<Question> quest = new List<Question>();
            this.id = currentId;
            for(dyfr__Field_Config__c q : questions) {
                quest.add(new Question(q.dyfr__Map_field__c, mapQQ, activity));
            }
            this.questions = quest;
        }

        /**
        * @Description: Constructor of CompetitivePositionSection with activity split 2012
        */
        public CompetitivePositionSection(String currentId, String ahasId, Map<String, arce.Arc_Gen_PersistModifiers_Data.ModifierVariableDefinition> questionMap) {
            final Set<String> parentIdSet = new Set<String>();
            parentIdSet.add(ahasId);
            final arce__Modifier__c modifier = arce.Arc_Gen_Modifiers_Utils.getModifierInfo(parentIdSet)[0];

            final List<Question> quest = new List<Question>();
            /*for(dyfr__Field_Config__c q : questions) {
                quest.add(new Question(currentid, currentValue));
            }*/
            for (String key : questionMap.keySet()) {
                arce.Arc_Gen_PersistModifiers_Data.ModifierVariableDefinition variabl = new arce.Arc_Gen_PersistModifiers_Data.ModifierVariableDefinition();
                variabl = questionMap.get(key);
                if (!String.isBlank((String)modifier.get(key.split('Obj.')[1])) && variabl.type == currentId) {
                    quest.add(new Question(variabl.id, (String)modifier.get(key.split('Obj.')[1])));
                }
            }
            if(!quest.isEmpty()) {
                this.id = currentId;
                this.questions = quest;
            }
        }
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Questions on CompetitivePositionGroupProfile
    *--------------------------------------------------------------------------------
    * @ Author jorge.diaz-blanco.contractor@bbva.com
    * @ Date   Created: 2020-07-06
    *--------------------------------------------------------------------------------
    **/
    public class Question {

        /**
        * @Description: Value of Question.
        */
        public String id { get; set; }
        //public String comments{ get; set; }
        /**
        * @Description: userAnswer of Question.
        */
        public String userAnswer { get; set; }
        /**
        * @Description: avalaibleAnswers of Question.
        */
        public List<String> avalaibleAnswers { get; set; }

        /**
        * @Description: Constructor of Question with sObject
        */
        public Question(String key, Map<String, List<arce__Qualitative_question__mdt>> mapQQ, SObject activity) {
            arce__Qualitative_question__mdt qualitativeQ;
            for(arce__Qualitative_question__mdt q : mapQQ.get(key)) {
                if(q.arce__Template__c.split(';').contains((String) activity.get('arce__Template_type__c'))) {
                    qualitativeQ = q;
                    break;
                }
            }
            if(!String.isBlank((String)activity.get(key))) {
                this.id = qualitativeQ?.Label;
                //this.comments = ''; //(String)activity.get(qq.arce__Comments__c);
                this.userAnswer = (String)activity.get(key);
            }
        }

        /**
        * @Description: Constructor of Question
        */
        public Question(String currentId, String currentValue){
            this.id = currentId;
            this.userAnswer = currentValue;
        }
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Questions on CompetitivePositionGroupProfile
    *--------------------------------------------------------------------------------
    * @ Author ivan.cons.contractor@bbva.com
    * @ Date Created: 2020-07-06
    * @ return String Serialized object
    *--------------------------------------------------------------------------------
    **/
    public String getJSON() {
        String dataJSON = JSON.serialize(this,true);
        return dataJSON;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Get qualitative questions map by question
    *--------------------------------------------------------------------------------
    * @ Author ivan.cons.contractor@bbva.com
    * @ Date Created: 2021-01-06
    * @ return Map<String,List<arce__Qualitative_question__mdt>> map of qualitative questions
    *--------------------------------------------------------------------------------
    **/

    private Map<String,List<arce__Qualitative_question__mdt>> getQuestionsMap() {
        final Map<String,List<arce__Qualitative_question__mdt>> mapQQ = new Map<String, List<arce__Qualitative_question__mdt>>();
        for(arce__Qualitative_question__mdt q : Arc_Gen_Corporate_Utils.getAllQualitativeQuestions().values()) {
            if(!mapQQ.containsKey(q.arce__Question__c)) {
                mapQQ.put(q.arce__Question__c,new List<arce__Qualitative_question__mdt>());
            }
            mapQQ.get(q.arce__Question__c).add(q);
        }
        return mapQQ;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Get arce__Activity_Split__c records to change.
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date Created: 2021-07-15
    * @ return List<WrapperMultitemplate> List of WrapperMultitemplate for 2019 model.
    *--------------------------------------------------------------------------------
    **/
    private List<WrapperMultitemplate> jsonInput2019(Set<String> parentIdSet, String eventType, String riskAssessmentId, String participantId) {
        final List<WrapperMultitemplate> lstWrapper = new List<WrapperMultitemplate>();
        final List<arce__Activity_Split__c> lstActSplit = Arc_Gen_Activities_Util.getAllActivitiesAndChildsByParent(parentIdSet);
        for(arce__Activity_Split__c aSplit : lstActSplit) {
            WrapperMultitemplate wrapper = new WrapperMultitemplate(aSplit,eventType);
            wrapper.id += '/' + riskAssessmentId + '/' + participantId;
            lstWrapper.add(wrapper);
        }
        return lstWrapper;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Get arce__Activity_Split_2012__c records to change.
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date Created: 2021-07-15
    * @ return List<WrapperMultitemplate> List of WrapperMultitemplate for 2012 model.
    *--------------------------------------------------------------------------------
    **/
    private List<WrapperMultitemplate> jsonInput2012(Set<String> parentIdSet, String eventType, String riskAssessmentId, String participantId) {
        final List<WrapperMultitemplate> lstWrapper = new List<WrapperMultitemplate>();
        final List<arce__Activity_Split_2012__c> lstActSplit = Arc_Gen_Activities_Util.getAllActByParent2012(parentIdSet);
        for(arce__Activity_Split_2012__c aSplit : lstActSplit) {
            WrapperMultitemplate wrapper = new WrapperMultitemplate(aSplit,eventType);
            wrapper.id += '/' + riskAssessmentId + '/' + participantId;
            lstWrapper.add(wrapper);
        }
        return lstWrapper;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Get arce__Activity_Split_2012__c records to change.
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date Created: 2021-07-20
    * @ return List<WrapperMultitemplate> List of WrapperMultitemplate for 2019 model.
    *--------------------------------------------------------------------------------
    **/
    private List<WrapperMultitemplate> perstInput2019 (Set<String> parentIdSet, Map<String, List<dyfr__Field_Config__c>> mapFCbyTempltd, Map<String,List<arce__Qualitative_question__mdt>> mapQQ) {
        final List<arce__Activity_Split__c> lstActSplit = Arc_Gen_Activities_Util.getAllActivitiesAndChildsByParent(parentIdSet);
        final List<WrapperMultitemplate> lstWrapper = new List<WrapperMultitemplate>();

        for(arce__Activity_Split__c aSplit : lstActSplit) {
            final WrapperMultitemplate wrapper = new WrapperMultitemplate(aSplit,mapFCbyTempltd.get('SP2-IRP-'+aSplit.arce__Template_type__c), mapQQ);
            lstWrapper.add(wrapper);
        }
        return lstWrapper;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Get arce__Activity_Split_2012__c records to change.
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date Created: 2021-07-20
    * @ return List<WrapperMultitemplate> List of WrapperMultitemplate for 2012 model.
    *--------------------------------------------------------------------------------
    **/
    private List<WrapperMultitemplate> perstInput2012 (Set<String> parentIdSet, Map<String, List<dyfr__Field_Config__c>> mapFCbyTempltd, Map<String,List<arce__Qualitative_question__mdt>> mapQQ) {
        final List<arce__Activity_Split_2012__c> lstActSplit = Arc_Gen_Activities_Util.getAllActByParent2012(parentIdSet);
        final List<WrapperMultitemplate> lstWrapper = new List<WrapperMultitemplate>();
        for(arce__Activity_Split_2012__c aSplit : lstActSplit) {
            final WrapperMultitemplate wrapper = new WrapperMultitemplate(aSplit,mapFCbyTempltd.get('SP2-IRP-'+aSplit.arce__Template_type__c), mapQQ);
            lstWrapper.add(wrapper);
        }
        return lstWrapper;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Get arce__Activity_Split__c records to process.
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date Created: 2021-07-22
    * @ return List<WrapperMultitemplate> List of WrapperMultitemplate for 2019 model.
    *--------------------------------------------------------------------------------
    **/
    private List<WrapperMultitemplate> processResp2019 (Set<String> parentIdSet, String eventType) {
        final List<arce__Activity_Split__c> lstActSplit = Arc_Gen_Activities_Util.getAllActivitiesAndChildsByParent(parentIdSet);
        final List<WrapperMultitemplate> lstWrapper = new List<WrapperMultitemplate>();
        for(arce__Activity_Split__c aSplit : lstActSplit) {
            final WrapperMultitemplate wrapper = new WrapperMultitemplate(aSplit,eventType);
            lstWrapper.add(wrapper);
        }
        return lstWrapper;
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Get arce__Activity_Split_2012__c records to process.
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date Created: 2021-07-22
    * @ return List<WrapperMultitemplate> List of WrapperMultitemplate for 2012 model.
    *--------------------------------------------------------------------------------
    **/
    private List<WrapperMultitemplate> processResp2012 (Set<String> parentIdSet, String eventType) {
        final List<arce__Activity_Split_2012__c> lstActSplit = Arc_Gen_Activities_Util.getAllActByParent2012(parentIdSet);
        final List<WrapperMultitemplate> lstWrapper = new List<WrapperMultitemplate>();
        for(arce__Activity_Split_2012__c aSplit : lstActSplit) {
            final WrapperMultitemplate wrapper = new WrapperMultitemplate(aSplit,eventType);
            lstWrapper.add(wrapper);
        }
        return lstWrapper;
    }

    /**
    * @description getMapFieldConfigsByTemplate
    * @author amunguia.contractor@bbva.com | 09-14-2021
    * @return Map<String, List<dyfr__Field_Config__c>>
    **/
    private Map<String, List<dyfr__Field_Config__c>> getMapFieldConfigsByTemplate() {
        Map<String, List<dyfr__Field_Config__c>> mapFieldConfigsByTemplate = new Map<String, List<dyfr__Field_Config__c>>();
        for(dyfr__Field_Config__c fc : [Select dyfr__Map_field__c, dyfr__Dependent_value_control_field__c, dyfr__Section_name__c, dyfr__Subsection_name__c, dyfr__Subsection_order__c, dyfr__Tab__r.dyfr__Template__r.Name, dyfr__Type__c from dyfr__Field_Config__c Where dyfr__Type__c = 'LIST' and dyfr__Dependent_value_control_field__c != null and dyfr__Section_name__c != 'Industry Risk']){ //NOSONAR
            if(!mapFieldConfigsByTemplate.containsKey(fc.dyfr__Tab__r.dyfr__Template__r.Name)) {
                mapFieldConfigsByTemplate.put(fc.dyfr__Tab__r.dyfr__Template__r.Name, new List<dyfr__Field_Config__c>());
            }
            mapFieldConfigsByTemplate.get(fc.dyfr__Tab__r.dyfr__Template__r.Name).add(fc);
        }
        return mapFieldConfigsByTemplate;
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Get List<wrapperMultitemplate by specific activity.
    *--------------------------------------------------------------------------------
    * @ Author amunguia.contractor@bbva.com
    * @ Date Created: 2021-09-13
    * @ return List<WrapperMultitemplate> List of WrapperMultitemplate for 2012 model.
    *--------------------------------------------------------------------------------
    **/
    private List<WrapperMultitemplate> perstSpecificInput (SObject aSplit, Map<String, List<dyfr__Field_Config__c>> mapFCbyTempltd, Map<String,List<arce__Qualitative_question__mdt>> mapQQ) {
        final WrapperMultitemplate wrapper = new WrapperMultitemplate(aSplit,mapFCbyTempltd.get('SP2-IRP-'+(String)aSplit.get('arce__Template_type__c')), mapQQ);
        return new List<WrapperMultitemplate>{wrapper};
    }
    /**
    * @description get map config by section
    * @author amunguia.contractor@bbva.com | 09-13-2021
    * @param String section
    * @return Map<String, List<dyfr__Field_Config__c>>
    **/
    private Map<String, List<dyfr__Field_Config__c>> getMapFieldConfigsBySection(String section) {
        Map<String, List<dyfr__Field_Config__c>> mapFieldConfigsByTemplate = new Map<String, List<dyfr__Field_Config__c>>();
        for(dyfr__Field_Config__c fc : [SELECT dyfr__Map_field__c, dyfr__Dependent_value_control_field__c, dyfr__Section_name__c, dyfr__Subsection_name__c, dyfr__Subsection_order__c, dyfr__Tab__r.dyfr__Template__r.Name, dyfr__Type__c FROM dyfr__Field_Config__c WHERE dyfr__Type__c = 'LIST' AND dyfr__Section_name__c = :section]){ //NOSONAR
            if(!mapFieldConfigsByTemplate.containsKey(fc.dyfr__Tab__r.dyfr__Template__r.Name)) {
                mapFieldConfigsByTemplate.put(fc.dyfr__Tab__r.dyfr__Template__r.Name, new List<dyfr__Field_Config__c>());
            }
            mapFieldConfigsByTemplate.get(fc.dyfr__Tab__r.dyfr__Template__r.Name).add(fc);
        }
        return mapFieldConfigsByTemplate;
    }
}