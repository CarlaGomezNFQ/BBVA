/*----------------------------------------------------------------------------------------------------
*Autor:         Framework Kevin Ohara
*Proyecto:
*Descripción:   Clase del Framework Kevin Ohara
*_______________________________________________________________________________________________________
*Versión    Fecha           Autor                               Descripción
*1.0        10/AGO/2017     BBVA Administrador                  Se instala el Framework Kevin Ohara
*1.1        10/ABR/2019     Luis Ruben Quinto 	                Refactorización para quitar complejidad
                                                                para hacer un bypass de forma automatica
-------------------------------------------------------------------------------------------------------*/
public virtual class TriggerHandler_Corp {

    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;

    // the current context of the trigger, overridable in tests
    @TestVisible
    private System.TriggerOperation context;

    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;

    // static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }

    // constructor
    public TriggerHandler_Corp() {
        this.setTriggerContext();
    }

    /***************************************
    * public instance methods
    ***************************************/
    // main method that will be called during execution
    public void run() {

        if(!validateRun()) return;
        addToLoopCount();

        // dispatch to the correct handler method
        switch on this.context {
            when BEFORE_INSERT {
                this.beforeInsert();
            }
            when BEFORE_UPDATE {
                this.beforeUpdate();
            }
            when BEFORE_DELETE {
                this.beforeDelete();
            }
            when AFTER_INSERT {
                this.afterInsert();
            }
            when AFTER_UPDATE {
                this.afterUpdate();
            }
            when AFTER_DELETE {
                this.afterDelete();
            }
            when AFTER_UNDELETE {
                this.afterUndelete();
            }
        }

    }

    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if(!TriggerHandler_Corp.loopCountMap.containsKey(handlerName)) {
            TriggerHandler_Corp.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandler_Corp.loopCountMap.get(handlerName).setMax(max);
        }
    }

    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }

    /***************************************
    * public static methods
    ***************************************/

    public static void bypass(String handlerName) {
        TriggerHandler_Corp.bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        TriggerHandler_Corp.bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler_Corp.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        TriggerHandler_Corp.bypassedHandlers.clear();
    }

    /***************************************
    * private instancemethods
    ***************************************/

    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(System.TriggerOperation ctx, Boolean testMode) {
        String handlerName = getHandlerName();
        if(!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } else {
            this.isTriggerExecuting = true;
        }

        this.context = Trigger.operationType == null ? ctx : Trigger.operationType;
        if(this.context == System.TriggerOperation.AFTER_UPDATE) {
            if(TriggerHandler_Corp.loopCountMap.containsKey(handlerName)) {
                TriggerHandler_Corp.loopCountMap.get(handlerName).incrementCountAfter();
            }
    }
  }

    // increment the loop count
    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();
        if(TriggerHandler_Corp.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler_Corp.loopCountMap.get(handlerName).increment();
            if(exceeded) {
                Integer max = TriggerHandler_Corp.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }

    // make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {
        String handlerName = getHandlerName();
        if(!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        if(TriggerHandler_Corp.bypassedHandlers.contains(getHandlerName())) {
            return false;
        }
        if(TriggerHandler_Corp.loopCountMap.containsKey(handlerName)) {
            //Sergio Ortiz: bypass automatico si ya se ha ingresado al after update del trigger
            if(TriggerHandler_Corp.loopCountMap.get(handlerName).countAfter > 1) {
                TriggerHandler_Corp.bypassedHandlers.add(handlerName);
                return false;
            }
        }
        return true;
    }

    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }

    /***************************************
    * context methods
    ***************************************/

    // context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert() {}
    @TestVisible
    protected virtual void beforeUpdate() {}
    @TestVisible
    protected virtual void beforeDelete() {}
    @TestVisible
    protected virtual void afterInsert() {}
    @TestVisible
    protected virtual void afterUpdate() {}
    @TestVisible
    protected virtual void afterDelete() {}
    @TestVisible
    protected virtual void afterUndelete() {}

    /***************************************
    * inner classes
    ***************************************/

    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
        private Integer max;
        private Integer count;
        private Integer countAfter;

        public LoopCount() {
            this.max = 5;
            this.count = 0;
            this.countAfter = 0;
        }

        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
            this.countAfter = 0;
        }

        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }

        public Boolean exceeded() {
            if(this.max < 0) return false;
            if(this.count > this.max) {
                return true;
            }
            return false;
        }

        public Integer getMax() {
            return this.max;
        }

        public Integer getCount() {
            return this.count;
        }

        public void setMax(Integer max) {
            this.max = max;
        }

        public void incrementCountAfter() {
            this.countAfter++;
        }

        public Integer  getCountAfter() {
            return this.countAfter;
        }
    }

  // exception class
  public class TriggerHandlerException extends Exception {}

}