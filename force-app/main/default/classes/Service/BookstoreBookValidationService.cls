/*
* Validates if the current user that is creating/updating the Bookstore_Book__c object has BookstoreManager permission set
* Validates if the Book that is being added to the bookstore(Via creating Bookstore_Book__c object) has the same publisher
* as the bookstore that it is being added too
*/
public with sharing class BookstoreBookValidationService implements CustomObject {
    /*
    * Validates the publisher and current users permission set
    * @param newBookstoreBooks - Books added to the bookstore
    */
    public void validatePublisher(List<Bookstore_Book__c> newBookstoreBooks) {
        CustomPermissionValidationService permissionValidator = (CustomPermissionValidationService) new ObjectFactory()
        .createObject(CustomPermissionValidationService.class);
        //Check if a user has Bookstore_Manager permission set
        if (!permissionValidator.validateCustomPermission('Bookstore_Manager')) {
            return;
        }
        //Loop through all new records and perform validation for them
        for(Bookstore_Book__c bookstoreBook : newBookstoreBooks) {
            BookSelector bookSelector = (BookSelector) new ObjectFactory().createObject(bookSelector.class);
            //Get publisher Id of the book that is being added to the bookstore
            Id publisherId = bookSelector.getBookById(bookstoreBook.Book__c)[0].Publisher__c;
            BookstorePublisherSelector bkStorePublisherSelector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
            // Get Publisher that is assigned to both Bookstore and the book
            List<Bookstore_Publisher__c> correspondingBookstorePublishers = bkStorePublisherSelector
            .getBookstorePublisherByPublisherIdAndBookstoreId(publisherId, bookstoreBook.Bookstore__c);
            // If no publisher is found, validation fails, book can't be added to the store
            if (correspondingBookstorePublishers.isEmpty()) {
                bookstoreBook.addError('Book and bookstore must work with the same publisher!');
            }
        }
    }
}