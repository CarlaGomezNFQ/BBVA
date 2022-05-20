({
  DATA: [
  ],
  setColumns: function(cmp) {
      let columnsArray = $A.get('$Label.c.PRW_ColumnsTableMargin');
      let columnsList = columnsArray.split('||');
      let numColumns = columnsList.length;
  
      var columns = [];
      columns = [
        {label: columnsList[0], fieldName: 'product', type: 'text', wrapText: true},
        {label: columnsList[numColumns - (numColumns - 1)], fieldName: 'revenues', type: 'number', cellAttributes: {alignment: 'right'}},
        {label: columnsList[numColumns - (numColumns - 2)], fieldName: 'revenuesYTD', type: 'number', cellAttributes: {alignment: 'right'}},
        {label: columnsList[numColumns - (numColumns - 3)], fieldName: 'percentYoY_YTD', type: 'percent',  cellAttributes: {alignment: 'right'} ,typeAttributes:{step: '0.1',maximumFractionDigits:'1',minimumFractionDigits: '1'}},
        {label: columnsList[numColumns - (numColumns - 4)], fieldName: 'revenuesL12M', type: 'number', editable: true, cellAttributes: {alignment: 'right'}},
        {label: columnsList[numColumns - (numColumns - 5)], fieldName: 'percentYoYL12M', type: 'percent',  cellAttributes: {alignment: 'right'} ,typeAttributes:{step: '0.1',maximumFractionDigits:'1',minimumFractionDigits: '1'}}
      ]
      cmp.set('v.columns', columns);
    },
    getParticipants: function(cmp, helper) {
      var actionPart = cmp.get('c.gtParticipants');
      actionPart.setParams({
        idCuaderno: cmp.get('v.profSheetId')
      });
      var promise = this.promisifyMargin(actionPart);
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
      var actionMargin = cmp.get('c.gtDataMargin');
      
      actionMargin.setParams({
        laccountsId: cmp.get('v.lAccountId'),
        profSheetStart: cmp.get('v.profSheetStart'),
        profSheetEnd: cmp.get('v.profSheetEnd')
      });
      var promise = this.promisifyMargin(actionMargin);
      return promise.then(
        $A.getCallback(function(result) {
          console.log('Result');
          console.log(result);
          if(result.success === true) {
            let dataTF = [];
            let dataWC = [];
            let dataCM = [];
            let totalCM = 0;
            let totalWC = 0;
            let totalTF = 0;
            let totalpastYearTF = 0;
            let totalpastYearWC = 0;
            let totalpastYearCM = 0;
            let totalPerYoYCM = 0;
            let totalPerYoYWC = 0;
            let totalPerYoYTF = 0;
            
            let tableData = JSON.parse(result.tableData)
            for(var ind = 0; ind < tableData.length; ind++) {
              if(tableData[ind].subFamily == 'WC'){
                dataWC.push(
                  {
                    channel : tableData[ind].channel,
                    revenues : tableData[ind].revenues,
                    revenuesYTD : tableData[ind].revenuesYTD,
                    percentYoY_YTD : tableData[ind].percentYoY_YTD/100,
                    revenuesL12M : tableData[ind].revenuesL12M,
                    product : tableData[ind].product,
                    percentYoYL12M : tableData[ind].percentYoYL12M/100
                  }
                );
               // totalWC = totalWC + parseFloat(tableData[ind].revenues);
               // totalpastYearWC = totalpastYearWC + (parseFloat(tableData[ind].revenues) * ((100 - parseFloat(tableData[ind].percentYoY_YTD))/100));
              }else if(tableData[ind].subFamily == 'TF'){
                dataTF.push(
                  {
                    channel : tableData[ind].channel,
                    revenues : tableData[ind].revenues,
                    revenuesYTD : tableData[ind].revenuesYTD,
                    percentYoY_YTD : tableData[ind].percentYoY_YTD/100,
                    revenuesL12M : tableData[ind].revenuesL12M,
                    product : tableData[ind].product,
                    percentYoYL12M : tableData[ind].percentYoYL12M/100
                  }
                );
                //totalTF = totalTF + parseFloat(tableData[ind].revenues);
                //totalpastYearTF = totalpastYearTF + (parseFloat(tableData[ind].revenues) * ((100 - parseFloat(tableData[ind].percentYoY_YTD))/100));
              }else if(tableData[ind].subFamily == 'CM'){
                dataCM.push(
                  {
                    channel : tableData[ind].channel,
                    revenues : tableData[ind].revenues,
                    revenuesYTD : tableData[ind].revenuesYTD,
                    percentYoY_YTD : tableData[ind].percentYoY_YTD/100,
                    revenuesL12M : tableData[ind].revenuesL12M,
                    product : tableData[ind].product,
                    percentYoYL12M : tableData[ind].percentYoYL12M/100
                  }
                );
                //totalCM = totalCM + parseFloat(tableData[ind].revenues);
                //totalpastYearCM = totalpastYearCM + (parseFloat(tableData[ind].revenues) * ((100 - parseFloat(tableData[ind].percentYoY_YTD))/100));
              }

            }
            // totalPerYoYWC = ((totalWC - totalpastYearWC)/totalpastYearWC ) * 100;
            // totalPerYoYCM = ((totalCM - totalpastYearCM)/totalpastYearCM ) * 100;
            // totalPerYoYTF = ((totalTF - totalpastYearTF)/totalpastYearTF ) * 100;
            cmp.set('v.loaded', true);
            cmp.set('v.dataWC', dataWC);
            cmp.set('v.dataTF', dataTF);
            cmp.set('v.dataCM', dataCM);
            cmp.set('v.totalTF',totalTF);
            cmp.set('v.totalCM',totalCM);
            cmp.set('v.totalWC',totalWC);
            // cmp.set('v.totalCMYoY',totalPerYoYCM);
            // cmp.set('v.totalWCYoY',totalPerYoYWC);
            // cmp.set('v.totalTFYoY',totalPerYoYTF);
            


          }
        }),
        $A.getCallback(function(error) {
          console.error( 'Error calling action "' + actionMargin + '" with state: ' + error.message );
        })
      ).catch(function(e){
      });
    },
    promisifyMargin: function(actionMargin) {
      return new Promise((resolve, reject) => {
        actionMargin.setCallback(this, function(response) {
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
        $A.enqueueAction(actionMargin);
      });
    },
})