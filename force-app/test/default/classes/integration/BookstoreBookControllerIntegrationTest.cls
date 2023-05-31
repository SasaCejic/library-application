/**
 * Class used for performing integration tests for BookstoreBookController
 */
@isTest
public with sharing class BookstoreBookControllerIntegrationTest {
    @isTest
    public static void returnBookstoreBooksCausingErrorOnPublisherDelete_willReturnBokstoreBooks_IfTheyHaveSamePublisher() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false);
        insert bookstorePublisherForTest;
        Bookstore_Book__c bookstoreBookForTest = testFactory
            .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false);
        insert bookstoreBookForTest;

        // execute
        Test.startTest();
        List<Bookstore_Book__c> bookstoreBooksCausingError = BookstoreBookController.returnBookstoreBooksCausingErrorOnPublisherDelete(bookstorePublisherForTest.Id, 5);
        Test.stopTest();

        // assert 
        Assert.areEqual(1, bookstoreBooksCausingError.size());
    }
}