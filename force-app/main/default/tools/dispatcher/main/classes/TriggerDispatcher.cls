/*
*Trigger dispatcher is a class that handles Logic for triggers based on their operationType and trigger handler
*/
public with sharing class TriggerDispatcher {
    /*
    * @param operationType - type of operration that started the trigge
    * @param handler - Class of type TriggerHanlder that implements blogic of what happens with the trigger
    */ 
    public void dispatch(TriggerOperation operationType, TriggerHandler handler) {
        switch on operationType {
            when BEFORE_INSERT {
                handler.beforeInsert(Trigger.new);
            } when BEFORE_UPDATE {
                //
            } when BEFORE_DELETE {
                //
            } when AFTER_INSERT {
                //
            } when AFTER_UPDATE {
                //
            } when AFTER_DELETE {
                //
            }
        }
    }
}