/**
* ------------------------------------------------------------------------------------------------
* @Name     Arc_Gen_wrpSave
* @Author   Ricardo Almanza Angeles
* @Date     Created: 15/01/2020
* @Group    ARCE
* -----------------------------------------------------------------------------------------------
* @Description Class that wraps save details dyanmic form save.
* -----------------------------------------------------------------------------------------------
* @Changes
*
* |2019-01-15 Ricardo Almanza Angeles
*             Class creation.
* |2019-01-15 amunguia.contractor@bbva.com
*             Class moved to dependencies and shared as global
* -----------------------------------------------------------------------------------------------
*/
@JsonAccess(serializable='always' deserializable='always')
global with sharing class Arc_Gen_wrpSave extends dyfr.WrapperSaveResponse {
    global Arc_Gen_wrpSave(Boolean val, String msg, List<sObject> sobs) {
        validated = val;
        message = msg;
        listObjects = sobs;
    }
}