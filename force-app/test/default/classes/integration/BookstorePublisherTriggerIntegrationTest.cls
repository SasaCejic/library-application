/**
 * Class used for testing Bookstore_Publisher__c Trigger
 */
@isTest
public with sharing class BookstorePublisherTriggerIntegrationTest {
    @isTest
    public static void onDelete_willAddError_ifBookstoreBookWithSamePublisherExists() {
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
        Database.DeleteResult deleteResult = Database.delete(bookstorePublisherForTest, false);
        Test.stopTest();

        // assert
        Assert.areEqual(false, deleteResult.isSuccess());
    }
}