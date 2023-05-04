/*
 * Trigger Handler is an abstract class that defines method for all possibilites in a trigger
 */
global abstract class TriggerHandler {
    public virtual Boolean isDisabled() {
        return false;
    }
    
    public virtual void beforeInsert(List<sObject> newRecords) {}

    public virtual void beforeUpdate(List<sObject> newRecords, List<sObject> oldRecords) {}

    public virtual void beforeDelete(List<sObject> newRecords, List<sObject> oldRecords) {}

    public virtual void afterInsert(List<sObject> newRecords) {}

    public virtual void afterUpdate(List<sObject> newRecords, List<sObject> oldRecords) {}

    public virtual void afterDelete(List<sObject> newRecords, List<sObject> oldRecords) {}
}