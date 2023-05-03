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
            Boolean isFound=false;

            for (Bookstore__c bookstore:bookstores) {
                if (String.isNotBlank(newBookstore.Related_User_Id__c) && String.isNotBlank(bookstore.Related_User_Id__c) && newBookstore.Related_User_Id__c.equals(bookstore.Related_User_Id__c)) {
                    newBookstore.addError('User is already a Bookstore Manager!');
                    isFound = true;
                    break;
                }
            }
        }
    }
}