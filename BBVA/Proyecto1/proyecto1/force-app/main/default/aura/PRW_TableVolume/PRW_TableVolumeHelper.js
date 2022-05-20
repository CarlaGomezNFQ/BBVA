({
  setColumns: function(cmp) {
    let columnsArray = $A.get('$Label.c.PRW_ColumnsTableVolume');
    let columnsList = columnsArray.split('||');
    let numColumns = columnsList.length;

    var columns = [];
    columns = [
      {label: columnsList[0], fieldName: 'product', type: 'text', wrapText: true},
      {label: columnsList[numColumns - (numColumns - 1)], fieldName: 'channel', type: 'text', cellAttributes: {alignment: 'right'}},
      {label: columnsList[numColumns - (numColumns - 2)], fieldName: 'transactions', type: 'number', cellAttributes: {alignment: 'right'}},
      {label: columnsList[numColumns - (numColumns - 3)], fieldName: 'transytd', type: 'number', editable: true, cellAttributes: {alignment: 'right'}},
      {label: columnsList[numColumns - (numColumns - 4)], fieldName: 'transyoyper', type: 'percent', cellAttributes: {alignment: 'right'},typeAttributes:{step: '0.1',maximumFractionDigits:'1',minimumFractionDigits: '1'}},
      {label: columnsList[numColumns - (numColumns - 5)], fieldName: 'trans12m', type: 'number', cellAttributes: {alignment: 'right'}},
      {label: columnsList[numColumns - (numColumns - 6)], fieldName: 'trans12mper', type: 'percent', cellAttributes: {alignment: 'right'} ,typeAttributes:{step: '0.1',maximumFractionDigits:'1',minimumFractionDigits: '1'}}
    ]
    cmp.set('v.columns', columns);
  },
  getParticipants: function(cmp, helper) {
    var actionPart = cmp.get('c.gtParticipants');
    actionPart.setParams({
      idCuaderno: cmp.get('v.profSheetId')
    });
    var promise = this.promisifyVolume(actionPart);
    return promise.then(
      $A.getCallback(function(result) {
        let idsAux = [];
        for (let ind = 0; ind < result.length; ind++) {
          idsAux.push(result[ind].cuco__participant_id__r.SER_CClient__c);
        }
        let ids = idsAux.join('-');
        cmp.set('v.lAccountId', ids);
        helper.setData(cmp);
      }),
      $A.getCallback(function(error) {
        console.error( 'Error calling action "' + actionPart + '" with state: ' + error.message );
      })
    ).catch(function(e){
    });
  },
  setData: function(cmp) {
    var actionVolume = cmp.get('c.gtDataVolume');
    actionVolume.setParams({
      laccountsId: cmp.get('v.lAccountId'),
      profSheetStart: cmp.get('v.profSheetStart'),
      profSheetEnd: cmp.get('v.profSheetEnd')
    });
    var promise = this.promisifyVolume(actionVolume);
    return promise.then(
      $A.getCallback(function(result) {
        console.log('Result');
        console.log(result);
        if(result.success === true) {
          let data = [];
          let tableData = JSON.parse(result.tableData)
          for(var ind = 0; ind < tableData.length; ind++) {
            data.push(
              {
                channel : tableData[ind].channel == "null" ? " " : tableData[ind].channel,
                transytd : tableData[ind].traytd,
                transyoyper : parseFloat(tableData[ind].perytd.substring(0,5))/100,
                trans12m : tableData[ind].tral12,
                trans12mper : tableData[ind].perl12/100,
                product : tableData[ind].product,
                transactions : tableData[ind].transacc
              }
            );
          }
          cmp.set('v.loaded', true);
          cmp.set('v.data', data);
        }
      }),
      $A.getCallback(function(error) {
        console.error( 'Error calling action "' + actionVolume + '" with state: ' + error.message );
      })
    ).catch(function(e){
    });
  },
  promisifyVolume: function(actionVolume) {
    return new Promise((resolve, reject) => {
      actionVolume.setCallback(this, function(response) {
        const statusVolume = response.getState();
        if (statusVolume === 'SUCCESS') {
          const returnValue = response.getReturnValue();
          resolve(returnValue);
        } else if (statusVolume === 'ERROR') {
          var errorsVolume = response.getError();
          if (errorsVolume) {
            if (errorsVolume[0] && errorsVolume[0].message) {
              reject(Error('Error message: ' + errorsVolume[0].message));
            }
          } else {
            reject(Error('Unknown error'));
          }
        }
      });
      $A.enqueueAction(actionVolume);
    });
  },
})