/**
 * Class used for testing DeleteBookstorePublisherRecordService
 */
@isTest
public with sharing class DeleteBookPublisherRecordServiceTest {
    @isTest
    public static void deleteBookstorePublisher_willDelete_ifNoBookstoreBooksWithSamePublisherExist() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true, false);
        
        // execute
        Test.startTest();
        DeleteBookPublisherRecordService service = new DeleteBookPublisherRecordService();
        service.deleteBookstorePublisher(bookstorePublisherForTest.Id);
        Test.stopTest();

        // assert
        Assert.isTrue(service.getResponse().isSuccess());
    }
}