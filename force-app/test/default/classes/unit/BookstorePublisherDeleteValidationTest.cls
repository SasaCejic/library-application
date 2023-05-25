/**
 * Class performs unit tests for BookstorePublisherDeleteValidatonService
 */
@isTest
public with sharing class BookstorePublisherDeleteValidationTest {
    @isTest
    public static void validatePublisher_willNotAddError_ifBookstoreBookWithSamePublisherDoesentExist() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true);

        // create mock
        Mocker BookstoreBookSelectorMocker = new Mocker(BookstoreBookSelector.class)
            .setBehavior('getListByBookstoreIds', new List<Bookstore_Book__c>{});
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector) BookstoreBookSelectorMocker.getMock()
        );

        // execute
        BookstorePublsherDeleteValidationService service = new BookstorePublsherDeleteValidationService();
        service.validateBookstorePublisher(new List<Bookstore_Publisher__c>{ bookstorePublisherForTest }, 2000);

        // Assert
        Assert.isTrue(bookstorePublisherForTest.getErrors().size() == 0);
    }
    
    @isTest
    public static void validatePublisher_willUseSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true);
        Bookstore_Publisher__c bookstorePublisherForTest = testFactory
            .createBookstorePublisher(publisherForTest.Id, bookstoreForTest.Id, true);

        // create mock
        Mocker BookstoreBookSelectorMocker = new Mocker(BookstoreBookSelector.class)
            .setBehavior('getListByBookstoreIds', new List<Bookstore_Book__c>{});
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector) BookstoreBookSelectorMocker.getMock()
        );

        // execute
        BookstorePublsherDeleteValidationService service = new BookstorePublsherDeleteValidationService();
        service.validateBookstorePublisher(new List<Bookstore_Publisher__c>{ bookstorePublisherForTest }, 2000);

        // Assert
        BookstoreBookSelectorMocker.assertMethodExecutionCount('getListByBookstoreIds', 1);
    }
}