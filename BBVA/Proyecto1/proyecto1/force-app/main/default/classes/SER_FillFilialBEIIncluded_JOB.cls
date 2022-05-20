/**
* Author: BBVA
* Description:  Clase que implemente la interface Schedulable para poder programar el 
*               batch SER_FillFilialBEIIncluded_BATCH.
* History:
*   <Date>       <Author>          <Description>
* 26/11/2020   Javier Touchard   V 1.0 Initial version
*/
global without sharing class SER_FillFilialBEIIncluded_JOB implements Schedulable { //NOSONAR Avoid Global Clases: Tiene que ser Global por si en algún momento fuese necesario llamar desde APX.
  /**
  * Method execute
  */
  global void execute(SchedulableContext scctx) {
    SER_FillFilialBEIIncluded_BATCH fillBEIBatch;
    fillBEIBatch = new SER_FillFilialBEIIncluded_BATCH();
    Database.executebatch(fillBEIBatch);
  }

  /**
  * Method execute
  */
  global void execute(SchedulableContext scctx, String query) {
    SER_FillFilialBEIIncluded_BATCH fillBEIBatch;
    fillBEIBatch = new SER_FillFilialBEIIncluded_BATCH(query);
    Database.executebatch(fillBEIBatch);
  }
}