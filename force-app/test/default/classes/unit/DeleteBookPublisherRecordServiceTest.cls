/**
 * Class used for testing DeleteBookstorePublisherRecordService
 */
@isTest
public with sharing class DeleteBookPublisherRecordServiceTest {
    @isTest
    public static void deleteBookstorePublisher_willDelete_ifNoBookstoreBooksWithSamePublisherExist() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, false);
        insert bookstorePublisherForTest;

        // execute
        Test.startTest();
        DeleteBookPublisherRecordService service = new DeleteBookPublisherRecordService();
        service.deleteBookstorePublisher(bookstorePublisherForTest.Id);
        Test.stopTest();

        // assert
        Assert.isTrue(service.getResponse().isSuccess());
    }
}