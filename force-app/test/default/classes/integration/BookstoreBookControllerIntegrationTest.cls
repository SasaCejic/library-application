/**
 * Class used for performing integration tests for BookstoreBookController
 */
@isTest
public with sharing class BookstoreBookControllerIntegrationTest {
    @isTest
    public static void returnBookstoreBooksCausingErrorOnPublisherDelete_willReturnBokstoreBooks_IfTheyHaveSamePublisher() {
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

        // execute
        Test.startTest();
        List<Bookstore_Book__c> bookstoreBooksCausingError = BookstoreBookController.returnBookstoreBooksCausingErrorOnPublisherDelete(bookstorePublisherForTest.Id, 5);
        Test.stopTest();

        // assert 
        Assert.areEqual(1, bookstoreBooksCausingError.size());
    }
}