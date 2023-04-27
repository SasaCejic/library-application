/*
*Trigger dispatcher is a class that handles Logic for triggers based on their operationType and trigger handler
*/
public with sharing class TriggerDispatcher {

    TriggerOperation operationType;
    TriggerHandler handler;

    public TriggerDispatcher(TriggerOperation operation, TriggerHandler triggerHandler) {
        operationType = operation;
        handler = triggerHandler;
    }

    /*
    * @param operationType - type of operration that started the trigge
    * @param handler - Class of type TriggerHanlder that implements blogic of what happens with the trigger
    */

    public void dispatch() {
        if(handler.isDisabled()) {
            return;
        }
        
        switch on operationType {
            when BEFORE_INSERT {
                handler.beforeInsert(Trigger.new);
            } when BEFORE_UPDATE {
                handler.beforeUpdate(Trigger.old, Trigger.new);
            } when BEFORE_DELETE {
                handler.beforeDelete(Trigger.old, Trigger.new);
            } when AFTER_INSERT {
                handler.afterInsert(Trigger.new);
            } when AFTER_UPDATE {
                handler.afterUpdate(Trigger.old, Trigger.new);
            } when AFTER_DELETE {
                handler.afterDelete(Trigger.old, Trigger.new);
            }
        }
    }
}