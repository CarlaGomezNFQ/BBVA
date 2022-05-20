/**
* @Name          	  : Arc_Gen_CustomServiceMessages.cls
* @Description        : Custom message errors
* @Project			  : ARCE - BBVA Bancomer
* @Author             : ARCE Team
* @Date Created		  : 2019-11-04
* @Group              : ARCE
* @Changes :
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0    2019-11-04 20:53:04   		   ARCE Team    		  	 Initial Version
* 1.2        12/06/2019      diego.miguel.contractor@bbva.com    204 messages
**/
global class Arc_Gen_CustomServiceMessages {
    /**
* @description Custom message errors
**/
    global final String ERROR_500 = System.Label.Cls_arce_Error500;
    global final String ERROR_400 = System.Label.Cls_arce_Error400;
    global final String ERROR_403 = System.Label.Cls_arce_Error403;
    global final String ERROR_404 = System.Label.Cls_arce_Error404;
    global final String ERROR_409 = System.Label.Cls_arce_Error409;

    global final String ERROR_OTHER = System.Label.Cls_arce_ErrorOther;
    /**
* @description Custom message success
**/
    global final String SUCCESSFUL_200 = System.Label.Cls_arce_Success200;
    global final String SUCCESSFUL_204 = System.Label.Cls_arce_Success204;
    /**
* @description Response Codes of a service
**/
    global final Integer CODE_200 = 200;
    global final Integer CODE_204 = 204;
    global final Integer CODE_400 = 400;
    global final Integer CODE_403 = 403;
    global final Integer CODE_404 = 404;
    global final Integer CODE_409 = 409;
    global final Integer CODE_500 = 500;
}