({
  isProfile: function(ProfileName) {
    var LblSerStaUserAdm        =   $A.get('$Label.c.SER_System_Administrator');
    var LblSerStaUserGNC        =   $A.get('$Label.c.SER_Service_Standard_User_GNC');
    var LblSerManagerGNC        =   $A.get('$Label.c.SER_Service_Client_Service_Manager_GNC');
    var LblSerConsultationIT    =   $A.get('$Label.c.SER_Consultation_IT');
    return (ProfileName     === LblSerStaUserAdm
          || ProfileName    === LblSerStaUserGNC
          || ProfileName    === LblSerManagerGNC
          || ProfileName    === LblSerConsultationIT);
  }
});