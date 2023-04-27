/*
* This class is used for testing book review validation service
* There will be 1 positive, 1 negative and 1 mockerexecutioncount tests
*/
@isTest
public with sharing class BookReviewValidationServiceTest {
    @isTest
    public static void validateReview_willAddError_ifSameBookReviewsAreCreated() {
        //Create data for test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

        Map<String, String> bookReviewDetails = new Map<String, String>();
        bookReviewDetails.put('name', 'Good Book');
        bookReviewDetails.put('rating', '4');
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, bookReviewDetails, false, true);

        Test.startTest();
        BookReviewValidationService service = new BookReviewValidationService();
        service.validateReview(new List<Book_Review__c>{bookReviewForInsert, bookReviewForInsert});
        Test.stopTest();

        System.assert(bookReviewForInsert.getErrors().size() == 1);
    }

    @isTest
    public static void validateReview_willNotAddError_ifSameBookReviewDoesentExist() {
        //Create data for test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

        Map<String, String> bookReviewDetails = new Map<String, String>();
        bookReviewDetails.put('name', 'Good Book');
        bookReviewDetails.put('rating', '4');
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, bookReviewDetails, false, true);

        Mocker BookReviewSelectorMock = new Mocker(BookReviewSelector.class)
        .setBehavior('getList', new List<Book_Review__c>());

        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) BookReviewSelectorMock.getMock()
        );

        Test.startTest();
        BookReviewValidationService service = new BookReviewValidationService();
        service.validateReview(new List<Book_Review__c>{bookReviewForInsert});
        Test.stopTest();

        System.assert(bookReviewForInsert.getErrors().size() == 0);
    }

    @isTest
    public static void validateReview_willUseCorrectSelector() {
        //Create data for test
        TestFactory testFactory = new TestFactory();
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1241353');
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);

        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('firstName', 'Author');
        authorDetails.put('lastName', 'Author');
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);

        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'bookdesc');
        bookDetails.put('ISBN', '214215425');
        bookDetails.put('language', 'english');
        bookDetails.put('categories', 'fantasy');
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

        Map<String, String> bookReviewDetails = new Map<String, String>();
        bookReviewDetails.put('name', 'Good Book');
        bookReviewDetails.put('rating', '4');
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, bookReviewDetails, false, true);

        Mocker BookReviewSelectorMock = new Mocker(BookReviewSelector.class)
        .setBehavior('getList', new List<Book_Review__c>());

        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) BookReviewSelectorMock.getMock()
        );

        Test.startTest();
        BookReviewValidationService service = new BookReviewValidationService();
        service.validateReview(new List<Book_Review__c>{bookReviewForInsert});
        Test.stopTest();

        BookReviewSelectorMock.assertMethodExecutionCount('getList', 1);
    }
}