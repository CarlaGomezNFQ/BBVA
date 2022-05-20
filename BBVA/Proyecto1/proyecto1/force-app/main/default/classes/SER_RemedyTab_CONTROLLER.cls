/**
* VASS Latam
* @author            Victor Velandia victor.velandia@vass.es
* Project:           BBVA Service
* Description:       Clase Controller SER_RemedyTab - SER_RemedyTab para mostrar campos dependiendo del perfil
*
*            No.     Date            Author                  Description
*            -----   ----------      --------------------    ---------------
* @version   1.0     2018-07-11      Victor Velandia (VV)    Clase Controller SER_RemedyTab
**************************************************************************************************************************************/
public with sharing class SER_RemedyTab_CONTROLLER {
  /* constructori privado de la clase porque todos los métodos son estáticos */
  private SER_RemedyTab_CONTROLLER () {
  }
  /*--------------------------------------------------------------------------------
    @author       Vass
    @date         2018-07-11
    @description  Método que deviuelve el perfil del usuario actual
  ------------------------------------------------------------------------------------*/
  @AuraEnabled
  public static String currentUser() {
    String salida;
    try {
      User sqlUser = new User();
      sqlUser = [Select Id, Name, ProfileId, Profile.Name
                  from user
                  where id = :System.UserInfo.getUserId()
                            limit 1];
      salida = sqlUser.Profile.Name;
    } catch (Exception ex) {
      throw new AuraHandledException(Label.SER_Error_Server + ' ' + ex);
    }
    return salida;
  }
}