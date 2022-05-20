({
  doInit: function(cmp, evt, helper) {
    helper.getExternalDocumentInfo(cmp, evt, helper);
  },
  changeDocVisibility: function(cmp, evt, helper) {
    helper.changeDocVisibility(cmp, evt, helper);
  },
  handleDocClick: function(cmp, evt, helper) {
    let currentDoc = evt.getSource().get('v.name');
    let data = currentDoc.split('_');
    helper.getPicassoWSResponse(cmp, evt, helper, data);
  }
});