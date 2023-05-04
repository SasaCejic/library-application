/**
 * Class that contains a method to validate if a User is already a Bookstore manager
 * 
 * @see BookstoreTriggerHandler.cls
 */
public with sharing class BookstoreValidationService implements CustomObject {

    /**
     * Method that checks if some Bookstore already contains certain User's Id
     * 
     * @param newBookstores list of new Bookstore records
     */
    public void validateBookstoreManagerMatch(List<Bookstore__c> newBookstores) {
        //Get all Bookstore__c sObjects
        BookstoreSelector bookstoreSelector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);
        List<Bookstore__c> bookstores = bookstoreSelector.getList();

        /**
         * Iterate through new Bookstores.
         * For each new Bookstore, iterate through existing Bookstores returned by
         * selector.
         * Check if existing Bookstore is related to User we want to relate a new 
         * Booktore to
         */
        for (Bookstore__c newBookstore:newBookstores) {
            for (Bookstore__c bookstore:bookstores) {
                if (newBookstore.Manager__c != null && bookstore.Manager__c != null && newBookstore.Manager__c == bookstore.Manager__c) {
                    newBookstore.addError('User is already a Bookstore Manager!');
                    break;
                }
            }
        }
    }
}