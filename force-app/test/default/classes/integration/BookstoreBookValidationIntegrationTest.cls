/*
* This class performs integration tests for BookstoreBookValidationService class
*/
@isTest
public with sharing class BookstoreBookValidationIntegrationTest {
    /*
    * Method inserts the needed data so validation succeeds.
    * Book and bookstore have the same publisher, therefore validation is successfull
    */
    @isTest
    public static void validatePublisher_validationSuccessfull() {
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Publisher__c> bkStorePublisherForTest = new TestFactory()
        .createBookstorePublishers(1, publisherForTest[0].Id, bookstoreForTest[0].Id);
        insert bkStorePublisherForTest;
        List<Bookstore_Book__c> bkstoreBookForTest = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);

        Test.startTest();
        BookstoreBookValidationService bkStoreBookValidation = new BookstoreBookValidationService();
        bkStoreBookValidation.validatePublisher(bkstoreBookForTest);
        Test.stopTest();
        System.assert(bkstoreBookForTest[0].getErrors().size() == 0);
    }
    /*
    * Method inserts the data so validation fails.
    * Book and bookstore do not have the same publishers, that was achieved by not 
    inserting Bookstore_Publisher__c object
    */
    @isTest
    public static void validatePublisher_validationFailure() {
        List<Publisher__c> publisherForTest = new TestFactory().createPublishers(1);
        insert publisherForTest;
        List<Bookstore__c> bookstoreForTest = new TestFactory().createBookstores(1);
        insert bookstoreForTest;
        List<Book__c> bookForTest = new TestFactory().createBooks(1, publisherForTest[0].Id);
        insert bookForTest;
        List<Bookstore_Book__c> bkstoreBookForTest = new TestFactory()
        .createBookstoreBooks(1, bookForTest[0].Id, bookstoreForTest[0].Id);

        Test.startTest();
        BookstoreBookValidationService bkstoreBookValidation = new BookstoreBookValidationService();
        bkstoreBookValidation.validatePublisher(bkstoreBookForTest);
        Test.stopTest();

        System.assert(bkstoreBookForTest[0].getErrors().size() > 0);
        System.assertEquals(bkstoreBookForTest[0].getErrors()[0].getMessage(),'Book and bookstore must work with the same publisher!');
    }
}