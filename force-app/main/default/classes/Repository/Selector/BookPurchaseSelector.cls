/*
 * This class is used for retrieving Book_Purchase__c records from database
 */
public with sharing class BookPurchaseSelector implements CustomObject{
    /*
     * @param bookIds - set of book Ids that were bought
     */
    public List<Book_Purchase__c> getList(Set<Id> bookIds) {
        return [
            SELECT
                Id,
                Book__c,
                CreatedById
            FROM Book_Purchase__c
        ];
    }
}