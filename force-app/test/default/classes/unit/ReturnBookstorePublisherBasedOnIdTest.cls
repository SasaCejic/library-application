/**
 * Class used for testing ReturnBookstorePublisherBasedOnIdService
 * Will only perform method execution test as there is no bussines logic involved
 */
@isTest
public with sharing class ReturnBookstorePublisherBasedOnIdTest {
    @isTest
    public static void returnBookstorePublisher_willUseSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Id bookstorePublisherId = testFactory.getFakeId(Bookstore_Publisher__c.SObjectType, true);

        // create mock
        Mocker BookstorePublisherSelectorMocker = new Mocker(BookstorePublisherSelector.class)
            .setBehavior('getRecordById', null);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) BookstorePublisherSelectorMocker.getMock()
        );

        // execute
        ReturnBookstorePublisherBasedOnIdService service = new ReturnBookstorePublisherBasedOnIdService();
        service.returnBookstorePublisher(bookstorePublisherId);

        // assert
        BookstorePublisherSelectorMocker.assertMethodExecutionCount('getRecordById', 1);
    }
}