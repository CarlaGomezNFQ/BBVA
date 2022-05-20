({
  doInit: function(component, event, helper) {
    console.log('entro en doInit');

    // create a one-time use instance of the serverEcho action
    // in the server-side controller
    var action                  =   component.get('c.currentUser');
    var LblSerManagerSTE        =   $A.get('$Label.c.SER_Service_Client_Service_Manager_STE');
    var LblSerManagementSTE     =   $A.get('$Label.c.SER_Service_Management_STE');
    var LblSerConsultationIT    =   $A.get('$Label.c.SER_Consultation_IT');
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var ProfileName = response.getReturnValue();
        if (helper.isProfile(ProfileName)) {
          console.log('entro profile');
          component.set('v.userProfile', response.getReturnValue());
          component.set('v.UserGNC', response.getReturnValue());
          console.log(component.get('v.userProfile'));
          console.log(component.get('v.UserGNC'));
        } else if (ProfileName === LblSerManagerSTE || ProfileName === LblSerManagementSTE || ProfileName === LblSerConsultationIT) {
          console.log('entro else');
          component.set('v.userProfile', response.getReturnValue());
          component.set('v.UserSTE', response.getReturnValue());
          console.log(component.get('v.userProfile'));
          console.log(component.get('v.UserSTE'));
        }
      } else if (state === 'ERROR') {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log('Error message: ' + errors[0].message);
          }
        } else {
          console.log('Unknown error');
        }
      }
    });
    $A.enqueueAction(action);
  },

  handleClick: function(component, event, helper) {
    console.log('entro en handleclick');
    console.log(component.get('v.bl_DisplayModal'));
    component.set('v.bl_DisplayModal', true);
  },

  fn_CloseModal: function(component, event, helper) {
    component.set('v.bl_DisplayModal', false);
  }
});