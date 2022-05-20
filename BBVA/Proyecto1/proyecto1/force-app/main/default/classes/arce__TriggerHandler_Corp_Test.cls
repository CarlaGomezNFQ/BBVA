/*----------------------------------------------------------------------------------------------------
*Autor:         Framework Kevin Ohara
*Proyecto:
*Descripción:   Clase del Framework Kevin Ohara
*_______________________________________________________________________________________________________
*Versión    Fecha           Autor                     Descripción
*1.0        10/AGO/2017     BBVA Administrador        Se instala el Framework Kevin Ohara
*1.1        03/ABR/2018     BBVA Administrador       Se prueba la adición de logica en el evento after
                                                      update para hacer un bypass de forma automatica
*1.2        03/ABR/2018     BBVA Administrador       Modificacion para eliminar bugs en el  uso de try catch
                                                      en la clase de prueba del framework
*1.3	    03/ABR/2018     Ruben Quinto	      Actualización por refactorización y reduccion de complejidad
-------------------------------------------------------------------------------------------------------*/
@isTest
private class TriggerHandler_Corp_Test {

  private static final String TRIGGER_CONTEXT_ERROR = 'Trigger handler called outside of Trigger execution';

  private static String lastMethodCalled;

  private static TriggerHandler_Corp_Test.TestHandler handler;

  static {
    handler = new TriggerHandler_Corp_Test.TestHandler();
    // override its internal trigger detection
    handler.isTriggerExecuting = true;
  }

  /***************************************
    * unit tests
    ***************************************/

  // contexts tests

  @isTest
  static void testBeforeInsert() {
    beforeInsertMode();
    handler.run();
    System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
  }

  @isTest
  static void testBeforeUpdate() {
    beforeUpdateMode();
    handler.run();
    System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
  }

  @isTest
  static void testBeforeDelete() {
    beforeDeleteMode();
    handler.run();
    System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
  }

  @isTest
  static void testAfterInsert() {
    afterInsertMode();
    handler.run();
    System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
  }

  @isTest
  static void testAfterUpdate() {
    afterUpdateMode();
    handler.run();
    System.assertEquals('afterUpdate', lastMethodCalled, 'last method should be afterUpdate');
  }

  @isTest
  static void testAfterDelete() {
    afterDeleteMode();
    handler.run();
    System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
  }

  @isTest
  static void testAfterUndelete() {
    afterUndeleteMode();
    handler.run();
    System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
  }

  @isTest
  static void testNonTriggerContext() {
    try{
      handler.run();
      System.assert(false, 'the handler ran but should have thrown');
    } catch(TriggerHandler_Corp.TriggerHandlerException te) {
      System.assertEquals(TRIGGER_CONTEXT_ERROR, te.getMessage(), 'the exception message should match');
    } catch(DmlException e) {
      System.assert(false, 'DML exception');
    } catch(SObjectException e) {
      System.assert(false, 'SObjectException exception');
    }
  }

  // test bypass api

  @isTest
  static void testBypassAPI() {
    afterUpdateMode();

    // test a bypass and run handler
    TriggerHandler_Corp.bypass('TestHandler');
    handler.run();
    System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    System.assertEquals(true, TriggerHandler_Corp.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();

    // clear that bypass and run handler
    TriggerHandler_Corp.clearBypass('TestHandler');
    handler.run();
    System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
    System.assertEquals(false, TriggerHandler_Corp.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();

    // test a re-bypass and run handler
    TriggerHandler_Corp.bypass('TestHandler');
    handler.run();
    System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    System.assertEquals(true, TriggerHandler_Corp.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();

    // clear all bypasses and run handler
    TriggerHandler_Corp.clearAllBypasses();
    handler.run();
    System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
    System.assertEquals(false, TriggerHandler_Corp.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();
  }

  // instance method tests

  @isTest
  static void testLoopCount() {
    beforeInsertMode();

    // set the max loops to 2
    handler.setMaxLoopCount(2);

    // run the handler twice
    handler.run();
    handler.run();

    // clear the tests
    resetTest();

    try {
      // try running it. This should exceed the limit.
      handler.run();
      System.assert(false, 'the handler should throw on the 3rd run when maxloopcount is 3');
    } catch(TriggerHandler_Corp.TriggerHandlerException te) {
      // we're expecting to get here
      System.assertEquals(null, lastMethodCalled, 'last method should be null');
    } catch(DmlException e) {
      System.assert(false, 'DML exception');
    } catch(SObjectException e) {
      System.assert(false, 'SObjectException exception');
    }
    // clear the tests
    resetTest();

    // now clear the loop count
    handler.clearMaxLoopCount();

    try {
      // re-run the handler. We shouldn't throw now.
      handler.run();
      System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    } catch(TriggerHandler_Corp.TriggerHandlerException te) {
      System.assert(false, 'running the handler after clearing the loop count should not throw');
    } catch(DmlException e) {
      System.assert(false, 'DML exception');
    } catch(SObjectException e) {
      System.assert(false, 'SObjectException exception');
    }
  }

  @isTest
  static void testLoopCountClass() {
    TriggerHandler_Corp.LoopCount lc = new TriggerHandler_Corp.LoopCount();
    System.assertEquals(5, lc.getMax(), 'max should be five on init');
    System.assertEquals(0, lc.getCount(), 'count should be zero on init');

    lc.increment();
    System.assertEquals(1, lc.getCount(), 'count should be 1');
    System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 1');
    System.assertEquals(0, lc.getCountAfter(), 'count should be <= 1');

    lc.increment();
    lc.increment();
    lc.increment();
    lc.increment();
    lc.incrementCountAfter();
    lc.incrementCountAfter();
    System.assertEquals(5, lc.getCount(), 'count should be 5');
    System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 5');
    System.assertEquals(2, lc.getCountAfter(), 'should not be exceeded count after update');

    lc.increment();
    System.assertEquals(6, lc.getCount(), 'count should be 6');
    System.assertEquals(true, lc.exceeded(), 'should not be exceeded with count of 6');
  }

  // private method tests

  @isTest
  static void testGetHandlerName() {
    System.assertEquals('TestHandler', handler.getHandlerName(), 'handler name should match class name');
  }

  // test virtual methods

  @isTest
  static void testVirtualMethods() {
    TriggerHandler_Corp h = new TriggerHandler_Corp();
    h.beforeInsert();
    h.beforeUpdate();
    h.beforeDelete();
    h.afterInsert();
    h.afterUpdate();
    h.afterDelete();
    h.afterUndelete();
    System.assertEquals(false, h.isTriggerExecuting, 'Trigger executed');
  }

  /***************************************
    * testing utilities
    ***************************************/

  private static void resetTest() {
    lastMethodCalled = null;
  }

  // modes for testing

  private static void beforeInsertMode() {
    handler.setTriggerContext(System.TriggerOperation.BEFORE_INSERT, true);
  }

  private static void beforeUpdateMode() {
    handler.setTriggerContext(System.TriggerOperation.BEFORE_UPDATE, true);
  }

  private static void beforeDeleteMode() {
    handler.setTriggerContext(System.TriggerOperation.BEFORE_DELETE, true);
  }

  private static void afterInsertMode() {
    handler.setTriggerContext(System.TriggerOperation.AFTER_INSERT, true);
  }

  private static void afterUpdateMode() {
    handler.setTriggerContext(System.TriggerOperation.AFTER_UPDATE, true);
  }

  private static void afterDeleteMode() {
    handler.setTriggerContext(System.TriggerOperation.AFTER_DELETE, true);
  }

  private static void afterUndeleteMode() {
    handler.setTriggerContext(System.TriggerOperation.AFTER_UNDELETE, true);
  }

  // test implementation of the TriggerHandler_Corp

  private class TestHandler extends TriggerHandler_Corp {

    public override void beforeInsert() {
      TriggerHandler_Corp_Test.lastMethodCalled = 'beforeInsert';
    }

    public override void  beforeUpdate() {
      TriggerHandler_Corp_Test.lastMethodCalled = 'beforeUpdate';
    }

    public override void beforeDelete() {
      TriggerHandler_Corp_Test.lastMethodCalled = 'beforeDelete';
    }

    public override void afterInsert() {
      TriggerHandler_Corp_Test.lastMethodCalled = 'afterInsert';
    }

    public override void afterUpdate() {
      TriggerHandler_Corp_Test.lastMethodCalled = 'afterUpdate';
    }

    public override void afterDelete() {
      TriggerHandler_Corp_Test.lastMethodCalled = 'afterDelete';
    }

    public override void afterUndelete() {
      TriggerHandler_Corp_Test.lastMethodCalled = 'afterUndelete';
    }

  }
}