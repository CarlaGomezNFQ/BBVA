({
  doInit: function(c, e, h) {
    var action = c.get('c.getDP');
    action.setParams({ flatRates: c.get('v.wrapper') });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var respuesta = response.getReturnValue();
        if (Object.entries(respuesta).length !== 0) {
          if (respuesta.nonCrossDPTable !== undefined && respuesta.nonCrossDPTable.classificationsList !== undefined) {
            for (var i = 0; i < respuesta.nonCrossDPTable.classificationsList.length; i++) {
              respuesta.nonCrossDPTable.classificationsList[i].expanded = true;
            }
          }
          c.set('v.flatWrap', respuesta);
          var crossDp = respuesta.crossDPAttList;
          var nonCross = respuesta.nonCrossDPTable;
          c.set('v.showSection', (crossDp !== null && crossDp.length > 0) || (nonCross !== null && nonCross.classificationsList.length > 0 && nonCross.headersList.length > 0));
        }
      }
    });
    $A.enqueueAction(action);


  }
});