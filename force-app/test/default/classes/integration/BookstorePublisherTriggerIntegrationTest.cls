/**
 * Class used for testing Bookstore_Publisher__c Trigger
 */
@isTest
public with sharing class BookstorePublisherTriggerIntegrationTest {
    @isTest
    public static void onDelete_willAddError_ifBookstoreBookWithSamePublisherExists() {
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
        Database.DeleteResult deleteResult = Database.delete(bookstorePublisherForTest, false);
        Test.stopTest();

        // assert
        Assert.areEqual(false, deleteResult.isSuccess());
    }
}