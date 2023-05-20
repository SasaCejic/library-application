/**
 * Class used for performing integration tests for BookstorePublisherVFController
 * Performs positive tests for public methods in the controller
 * Every test revolves around creating data, such that Bookstore_Book__c book record has the same publisher as the Bookstore_Publisher__c record
 * Which will fail in deletion
 */
@isTest
public with sharing class BokstorePublshrVFControlerIntgrationTest {
    /**
     * This method tests both if the delete failed, and the page reference that was returned.
     * If the deletion failed page reference will be null (staying on the same page of VF page)
     */
    @isTest
    public static void deleteRecord_willFail_IfTheyHaveSamePublisher() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true, false);
        Bookstore_Book__c bookstoreBookForTest = testFactory
            .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, true, false);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // execute
        Test.startTest();
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        controller.deleteRecord();
        Test.stopTest();

        // assert 
        Assert.areEqual(true, controller.didDeleteFail);
    }
    
    @isTest
    public static void getBookstoreBooksCausingError_willReturnBookstoreBook_ifTheyHaveSamePublisher() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true, false);
        Bookstore_Book__c bookstoreBookForTest = testFactory
            .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, true, false);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // execute
        Test.startTest();
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        List<Bookstore_Book__c> bookstoreBooksCausingError = controller.getBookstoreBooksCausingError();
        Test.stopTest();

        // assert 
        Assert.areEqual(1, bookstoreBooksCausingError.size());
    }

    @isTest
    public static void cancel_willReturnPageReference() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true, false);
        Bookstore_Book__c bookstoreBookForTest = testFactory
            .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, true, false);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // execute
        Test.startTest();
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        Pagereference pageReference = controller.cancel();
        Test.stopTest();

        // assert 
        Assert.isTrue(pageReference != null);
    }

    @isTest
    public static void viewAll_willReturnPageReference() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true, false);
        Bookstore_Book__c bookstoreBookForTest = testFactory
            .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, true, false);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bookstorePublisherForTest);

        // execute
        Test.startTest();
        BookstorePublisherVFController controller = new BookstorePublisherVFController(stdController);
        Pagereference pageReference = controller.viewAll();
        Test.stopTest();

        // assert 
        Assert.isTrue(pageReference != null);
    }
}