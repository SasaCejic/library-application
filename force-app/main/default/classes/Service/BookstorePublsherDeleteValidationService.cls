/*
 * Class responsible for stopping delete of Bookstore_Publisher__c record if Bookstore__Book__c record exist assigned to the same Bookstore__c record
 */
public with sharing class BookstorePublsherDeleteValidationService {
    /*
     * @param deletedRecords - Bookstore_Publisher__c records being deleted
     */
    public void validateBookstorePublisher(List<Bookstore_Publisher__c> deletedRecords) {
        // Set that holds Ids of deleted Bookstore_Publisher__c records
        Set<Id> bookstorePublisherIds = new Set<Id>();
        // Loop through deleted records and add their Ids to the set
        for (Bookstore_Publisher__c bookstorePublisher : deletedRecords) {
            bookstorePublisherIds.add(bookstorePublisher.Id);
        }
        
    }
}