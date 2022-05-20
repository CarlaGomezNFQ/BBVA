/**
* @File Name          : Arc_Gen_Wrapper_RatingSP2.cls
* @Description        : Class that construct JSON response of ratings service
* @Author             : juanpedro.benito.contractor@bbva.com
* @Group              : ARCE Team
* @Last Modified By   : juanpedro.benito.contractor@bbva.com
* @Last Modified On   : 29-04-2021
* @Changes
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    29-04-2021  juanpedro.benito.contractor@bbva.com     Initial Version
**/
@SuppressWarnings('PMD.ExcessivePublicCount')
public class Arc_Gen_Wrapper_RatingSP2 {
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON WrapperRatingSP2
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class WrapperRatingSP2 {
        /**
        * @Description: data of WrapperRatingSP2
        */
        public List<FF_SS> data {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON FFSS
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class FF_SS {
        /**
        * @Description: id of FFSS
        */
        public String id {get;set;}
        /**
        * @Description: originApplication of FFSS
        */
        public OriginApplication originApplication {get;set;}
        /**
        * @Description: variables of FFSS
        */
        public List<Variables> variables {get;set;}
        /**
        * @Description: subRatings of FFSS
        */
        public List<SubRatings> subRatings {get;set;}
        /**
        * @Description: evaluationDate of FFSS
        */
        public String evaluationDate {get;set;}
        /**
        * @Description: financialStatement of FFSS
        */
        public FinancialStatement financialStatement {get;set;}
        /**
        * @Description: adjustments of FFSS
        */
        public List<Adjustments> adjustments {get;set;}
        /**
        * @Description: templates of FFSS
        */
        public List<Templates> templates {get;set;}
        /**
        * @Description: bank of FFSS
        */
        public Banks bank {get;set;}
    }

    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON variables
    *--------------------------------------------------------------------------------
    * @ Author jose.hijar.contractor@bbva.com
    * @ Date   Created: 21-06-2021
    *--------------------------------------------------------------------------------
    **/
    public class OriginApplication{
      /**
      * @Description: id of OriginApplication
      */
      public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON variables
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Variables {
        /**
        * @Description: id of Variables
        */
        public String id {get;set;}
        /**
        * @Description: level of Variables
        */
        public String level {get;set;}
        /**
        * @Description: blockType of Variables
        */
        public String blockType {get;set;}
        /**
        * @Description: parentCode of Variables
        */
        public String parentCode {get;set;}
        /**
        * @Description: score of Variables
        */
        public Score score {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON score
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Score {
        /**
        * @Description: value of Score
        */
        public String value {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON subRatings
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class SubRatings {
        /**
        * @Description: longScaleValue of SubRatings
        */
        public String longScaleValue {get;set;}
        /**
        * @Description: partialPunctuations of SubRatings
        */
        public List<PartialPunctuations> partialPunctuations {get;set;}
        /**
        * @Description: shortScaleValue of SubRatings
        */
        public String shortScaleValue {get;set;}
        /**
        * @Description: ratingType of SubRatings
        */
        public RatingType ratingType {get;set;}
        /**
        * @Description: model of SubRatings
        */
        public Model model {get;set;}
        /**
        * @Description: model of SubRatings
        */
        public Tool tool {get;set;}
        /**
        * @Description: score of SubRatings
        */
        public String score {get;set;}
        /**
        * @Description: businessAgents of SubRatings
        */
        public List<BusinessAgents> businessAgents {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON partialPunctuations
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class PartialPunctuations {
        /**
        * @Description: id of PartialPunctuations
        */
        public String id {get;set;}
        /**
        * @Description: value of PartialPunctuations
        */
        public String value {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON model
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Model {
        /**
        * @Description: id of Model
        */
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON tool
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Tool {
        /**
        * @Description: id of tool
        */
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON ratingType
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class RatingType {
        /**
        * @Description: id of RatingType
        */
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON businessAgents
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class BusinessAgents {
        /**
        * @Description: id of BusinessAgents
        */
        public String id {get;set;}
        /**
        * @Description: BusinessAgentType of BusinessAgents
        */
        public BusinessAgentType businessAgentType {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON businessAgentType
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class BusinessAgentType {
        /**
        * @Description: id of BusinessAgentType
        */
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON financialStatement
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class FinancialStatement {
        /**
        * @Description: id of FinancialStatement
        */
        public String id {get;set;}
        /**
        * @Description: financialStatementType of FinancialStatement
        */
        public FinancialStatementType financialStatementType {get;set;}
        /**
        * @Description: period of FinancialStatement
        */
        public Period period {get;set;}
        /**
        * @Description: adjustedIndicator of FinancialStatement
        */
        public String adjustedIndicator {get;set;}
        /**
        * @Description: certification of FinancialStatement
        */
        public Certification certification {get;set;}
        /**
        * @Description: audit of FinancialStatement
        */
        public Audit audit {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON financialStatementType
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class FinancialStatementType {
        /**
        * @Description: id of FinancialStatementType
        */
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON period
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Period {
        /**
        * @Description: unit of Period
        */
        public String unit {get;set;}
        /**
        * @Description: number_x of Period
        */
        final public String number_x {get;set;}
        /**
        * @Description: periodType of Period
        */
        public PeriodType periodType {get;set;}
        /**
        * @Description: startDate of Period
        */
        public String startDate {get;set;}
        /**
        * @Description: endDate of Period
        */
        public String endDate {get;set;}
        /**
        * @Description: audit object
        */
        public Audit audit {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON certification
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Certification {
        /**
        * @Description: type of certification
        */
        public String certificationType {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON periodType
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class PeriodType {
        /**
        * @Description: id of PeriodType
        */
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON audit
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Audit {
        /**
        * @Description: auditor of Audit
        */
        public Auditor auditor {get;set;}
        /**
        * @Description: auditDate of Audit
        */
        public String auditDate {get;set;}
        /**
        * @Description: quality of Audit
        */
        public String quality {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON auditor
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Auditor {
        /**
        * @Description: opinion of Auditor
        */
        public String opinion {get;set;}
        /**
        * @Description: fullName of Auditor
        */
        public String fullName {get;set;}
        /**
        * @Description: origin of Auditor
        */
        public String origin {get;set;}
        /**
        * @Description: hasQualification of Auditor
        */
        public String hasQualification {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON adjustments
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Adjustments {
        /**
        * @Description: score of Adjustments
        */
        @AuraEnabled
        public String score {get;set;}
        /**
        * @Description: modifier of Adjustments
        */
        @AuraEnabled
        public Modifier modifier {get;set;}
        /**
        * @Description: adjustmentType of Adjustments
        */
        @AuraEnabled
        public AdjustmentType adjustmentType {get;set;}
        /**
        * @Description: shortScaleValue of Adjustments
        */
        @AuraEnabled
        public String shortScaleValue {get;set;}
        /**
        * @Description: longScaleValue of Adjustments
        */
        @AuraEnabled
        public String longScaleValue {get;set;}
        /**
        * @Description: reason of Adjustments
        */
        @AuraEnabled
        public String reason {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON modifier
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Modifier {
        /**
        * @Description: id of Modifier
        */
        @AuraEnabled
        public String id {get;set;}
        /**
        * @Description: description of Modifier
        */
        @AuraEnabled
        public String description {get;set;}
        /**
        * @Description: valuation of Modifier
        */
        @AuraEnabled
        public String valuation {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON adjustmentType
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class AdjustmentType {
        /**
        * @Description: id of AdjustmentType
        */
        @AuraEnabled
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON templates
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Templates {
        /**
        * @Description: id of Templates
        */
        @AuraEnabled
        public String id {get;set;}
        /**
        * @Description: description of Templates
        */
        @AuraEnabled
        public String description {get;set;}
        /**
        * @Description: ratingType of Templates
        */
        @AuraEnabled
        public String ratingType {get;set;}
        /**
        * @Description: longScaleValue of Templates
        */
        @AuraEnabled
        public String longScaleValue {get;set;}
        /**
        * @Description: weight of Templates
        */
        @AuraEnabled
        public String weight {get;set;}
        /**
        * @Description: SubIndustry of Templates
        */
        @AuraEnabled
        public SubIndustry subindustry {get;set;}
        /**
        * @Description: Country of Templates
        */
        @AuraEnabled
        public Country country {get;set;}
        /**
        * @Description: Financial Risk Score of the template
        */
        @AuraEnabled
        public String financialRiskScore {get;set;}
        /**
        * @Description: Business Risk Score of the template
        */
        @AuraEnabled
        public String businessRiskScore {get;set;}
        /**
        * @Description: Total Score of the template
        */
        @AuraEnabled
        public String totalScore {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON SubIndustry
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 14-09-2021
    *--------------------------------------------------------------------------------
    **/
    public class SubIndustry {
        /**
        * @Description: id of SubIndustry
        */
        @AuraEnabled
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON Country
    *--------------------------------------------------------------------------------
    * @ Author saimassimilianno.jordana.contractor@bbva.com
    * @ Date   Created: 14-09-2021
    *--------------------------------------------------------------------------------
    **/
    public class Country {
        /**
        * @Description: id of Country
        */
        @AuraEnabled
        public String id {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON bank
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Banks {
        /**
        * @Description: id of Bank
        */
        public String id {get;set;}
        /**
        * @Description: branch of Bank
        */
        public Branch branch {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON branch
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Branch {
        /**
        * @Description: id of branch
        */
        public String id {get;set;}
        /**
        * @Description: level of branch
        */
        public Level level {get;set;}
    }
    /**
    *-------------------------------------------------------------------------------
    * @Description Class for JSON level
    *--------------------------------------------------------------------------------
    * @ Author juanpedro.benito.contractor@bbva.com
    * @ Date   Created: 29-04-2021
    *--------------------------------------------------------------------------------
    **/
    public class Level {
        /**
        * @Description: id of level
        */
        public String id {get;set;}
    }


    @SuppressWarnings('PMD.TooManyFields')
    public class StudiesAuraWrapper {
      /**
      * @Description: id of branch
      */
      @AuraEnabled
      public String id {get;set;}
      /**
      * @Description: evalDate of branch
      */
      @AuraEnabled
      public String evalDate {get;set;}
      /**
      * @Description: shortId of branch
      */
      @AuraEnabled
      public String shortId {get;set;}
      /**
      * @Description: months of branch
      */
      @AuraEnabled
      public String months {get;set;}
      /**
      * @Description: months of branch
      */
      @AuraEnabled
      public String diverAdjustm {get;set;}
      /**
      * @Description: months of branch
      */
      @AuraEnabled
      public String finanFlexRiskScore {get;set;}
      /**
      * @Description: validity of branch
      */
      @AuraEnabled
      public String validity {get;set;}
      /**
      * @Description: endDate of branch
      */
      @AuraEnabled
      public String endDate {get;set;}
      /**
      * @Description: evaluationDate of branch
      */
      @AuraEnabled
      public String evaluationDate {get;set;}
      /**
      * @Description: certification of branch
      */
      @AuraEnabled
      public String certification {get;set;}
      /**
      * @Description: audit of branch
      */
      @AuraEnabled
      public String audit {get;set;}
      /**
      * @Description: finalizedBy of branch
      */
      @AuraEnabled
      public String finalizedBy {get;set;}
      /**
      * @Description: ffssType of branch
      */
      @AuraEnabled
      public String ffssType {get;set;}
      /**
      * @Description: adjustment of branch
      */
      @AuraEnabled
      public String adjustment {get;set;}
      /**
      * @Description: model of branch
      */
      @AuraEnabled
      public String model {get;set;}
      /**
      * @Description: finalScore of branch
      */
      @AuraEnabled
      public String finalScore {get;set;}
      /**
      * @Description: finalLong of branch
      */
      @AuraEnabled
      public String finalLong {get;set;}
      /**
      * @Description: validated of branch
      */
      @AuraEnabled
      public String validated {get;set;}
      /**
      * @Description: scale of branch
      */
      @AuraEnabled
      public String scale {get;set;}
      /**
      * @Description: anchorScore of branch
      */
      @AuraEnabled
      public String anchorScore {get;set;}
      /**
      * @Description: anchorLong of branch
      */
      @AuraEnabled
      public String anchorLong {get;set;}
      /**
      * @Description: standaloneScore of branch
      */
      @AuraEnabled
      public String standaloneScore {get;set;}
      /**
      * @Description: standaloneLong of branch
      */
      @AuraEnabled
      public String standaloneLong {get;set;}
      /**
      * @Description: overlaysScore of branch
      */
      @AuraEnabled
      public String overlaysScore {get;set;}
      /**
      * @Description: overlaysLong of branch
      */
      @AuraEnabled
      public String overlaysLong {get;set;}
      /**
      * @Description: overrideRating of branch
      */
      @AuraEnabled
      public String overrideRating {get;set;}
      /**
      * @Description: gre of branch
      */
      @AuraEnabled
      public String gre {get;set;}
      /**
      * @Description: parentAd of branch
      */
      @AuraEnabled
      public String parentAd {get;set;}
      /**
      * @Description: soveCap of branch
      */
      @AuraEnabled
      public String soveCap {get;set;}
      /**
      * @Description: wl of branch
      */
      @AuraEnabled
      public String wl {get;set;}
      /**
      * @Description: reason of branch
      */
      @AuraEnabled
      public String reason {get;set;}
      /**
      * @Description: level of templatesh
      */
      @AuraEnabled
      public List<Templates> templates {get;set;}
      /**
      * @Description: level of bradjustments
      */
      @AuraEnabled
      public List<Adjustments> adjustments {get;set;}
      /**
      * @Description: variables of FFSS
      */
      public List<Variables> variables {get;set;}

    }
}