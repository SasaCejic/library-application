/*
* This class is used to test logic in BookstoreBookTriggerHandler
*/
@isTest
public with sharing class BookstoreBookTriggerHandlerTest {
    /*
    * Data used for creating objects is simple input for rquired fields, meaning it won't influence the test as we use mockers, it's just there to fulfill object creation
    */
    @isTest
    public static void beforeInsert_willUseCorrectService() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1241353');
        Bookstore__c bookstoreForTest = testFactory.createBookstore(bookstoreDetails, false, true);

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, true, false);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

        Bookstore_Book__c bookstoreBookForMock = testFactory
        .createBookstoreBook(bookForTest.Id, bookstoreForTest.Id, false, true);

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
        bookstoreBookValidationServiceMock.assertMethodExecutionCount('validatePublisher', 1);
    }
}