/*
* This class is used to test logic in BookstoreBookTriggerHandler
*/
@isTest
public with sharing class BookstoreBookTriggerHandlerTest {
    @isTest
    public static void beforeInsert_willNotFindError_ifErrorNotAdded() {
        //Create data for mocks and test
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = new TestFactory().createPublisher(publisherDetails, false);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = new TestFactory().createBookstore(bookstoreDetails, false);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = new TestFactory().createBook(publisherForTest.Id, bookDetails, false);

        Bookstore_Book__c bookstoreBookForMock = new TestFactory()
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false);

        Mocker bookstoreBookValidationServiceMock = new Mocker(BookstoreBookValidationService.class)
        .setBehavior('validatePublisher', bookstoreBookForMock);
        ObjectFactory.mocks.put(
            BookstoreBookValidationService.class.getName(),
            (BookstoreBookValidationService)bookstoreBookValidationServiceMock.getMock()
        );

        Test.startTest();
        BookstoreBookTriggerHandler bookstoreBookTriggerHandler = new BookstoreBookTriggerHandler();
        bookstoreBookTriggerHandler.beforeInsert(new List<Bookstore_Book__c>{bookstoreBookForMock});
        Test.stopTest();

        System.assert(bookstoreBookForMock.getErrors().size() == 0);
    }
}