/*
 * Class performs selectors for different custom setting types
*/
public with sharing class CustomSettingSelector implements CustomObject {
    /*
    * Returns a list of all custom settings of Standard_Authors_Settting__c type
    */
    public List<Standard_Authors_Settting__c> getStdAuthorsSettingList() {
        return Standard_Authors_Settting__c.getall().values();
    }
}