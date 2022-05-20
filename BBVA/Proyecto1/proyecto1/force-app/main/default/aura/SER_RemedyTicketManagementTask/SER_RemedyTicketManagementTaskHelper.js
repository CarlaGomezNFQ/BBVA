({
  fillLlamadaAccion: function(option) {
    var llamadaAccion;
    switch (option) {
      case 'New Remedy':
        llamadaAccion = 'c:SER_RTM_Task_NewTicket';
        break;
      case 'Send Comment':
        llamadaAccion = 'c:SER_RTM_Task_SendComment';
        break;
      case 'Send Attachment':
        llamadaAccion = 'c:SER_RTM_Task_SendAttachment';
        break;
      case 'Update Remedy':
        llamadaAccion = 'c:SER_RTM_Task_UpdateTicket';
        break;
      case 'Claim Remedy':
        llamadaAccion = 'c:SER_RTM_Task_ClaimTicket';
        break;
      case 'Close Remedy':
        llamadaAccion = 'c:SER_RTM_Task_CloseTicket';
        break;
      case 'Reopen Remedy':
        llamadaAccion = 'c:SER_RTM_Task_ReopenTicket';
        break;
    }
    return llamadaAccion;
  },

  showToast: function(message, toastType, helper) {
    helper.showToastError(message, toastType);
  },
});