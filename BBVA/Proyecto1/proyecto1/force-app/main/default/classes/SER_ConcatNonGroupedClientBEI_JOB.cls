/**
* Author: BBVA
* Description:  Clase que implemente la interface Schedulable para poder programar el 
*               batch SER_ConcatNonGroupedClientBEI_BATCH.
* History:
*   <Date>       <Author>          <Description>
* 14/10/2020   Javier Touchard   V 1.0 Initial version
*/
global without sharing class SER_ConcatNonGroupedClientBEI_JOB implements Schedulable {
  /**
  * Method execute
  */
  global void execute(SchedulableContext scctx) {
    final SER_ConcatNonGroupedClientBEI_BATCH concatBatch = new SER_ConcatNonGroupedClientBEI_BATCH();
    Database.executebatch(concatBatch);
  }

  /**
  * Method execute
  */
  global void execute(SchedulableContext scctx, String query) {
    final SER_ConcatNonGroupedClientBEI_BATCH concatBatch = new SER_ConcatNonGroupedClientBEI_BATCH(query);
    Database.executebatch(concatBatch);
  }
}