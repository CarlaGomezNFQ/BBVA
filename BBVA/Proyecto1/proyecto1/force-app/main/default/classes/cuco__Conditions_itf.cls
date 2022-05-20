/**
* ____________________________________________________________________________
* Conditions Interface
* Interface method
* ____________________________________________________________________________
* @author      Torcuato Tejada <torcuato.tejada.contractor@bbva.com>
* @modifiedBy
* @version     1.0
* @created     2021-04-21
* @modified
* @systemLayer Domain
* ____________________________________________________________________________
* @changes
*
* ____________________________________________________________________________
*/
@SuppressWarnings('PMD.AvoidGlobalModifier')
global interface Conditions_itf {

    /**
    * @description Returns, if applies, the list of condition errors
    * @param inputConditions: input condition information to validate
    * @return ConditionsValidationErrors_Wrapper
    */
    ConditionsValidationErrors_Wrapper validateInputConditionValues(ConditionsValidationInput_Wrapper inputConditions);

}