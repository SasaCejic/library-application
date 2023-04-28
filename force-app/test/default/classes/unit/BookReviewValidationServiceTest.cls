/*
 * This class is used for testing book review validation service
 * There will be 1 positive, 1 negative and 1 mockerexecutioncount tests
 */
@isTest
public with sharing class BookReviewValidationServiceTest {
    /*
     * Reason why we have no mocks in this method is because the code will add error before the selector is even executed
     */
    @isTest
    public static void validateReview_willAddError_ifSameBookReviewsAreCreated() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, false, true);

        // execute
        BookReviewValidationService service = new BookReviewValidationService();
        service.validateReview(new List<Book_Review__c>{bookReviewForInsert, bookReviewForInsert});

        // assert
        Assert.isTrue(bookReviewForInsert.getErrors().size() == 1);
    }

    @isTest
    public static void validateReview_willNotAddError_ifSameBookReviewDoesentExist() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, false, true);

        // create mock
        Mocker BookReviewSelectorMock = new Mocker(BookReviewSelector.class)
        .setBehavior('getList', new List<Book_Review__c>());
        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) BookReviewSelectorMock.getMock()
        );

        // execute
        BookReviewValidationService service = new BookReviewValidationService();
        service.validateReview(new List<Book_Review__c>{bookReviewForInsert});

        // assert
        Assert.isTrue(bookReviewForInsert.getErrors().size() == 0);
    }

    @isTest
    public static void validateReview_willUseCorrectSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Book_Review__c bookReviewForInsert = testFactory.createBookReview(bookForTest.Id, false, true);

        // create mock
        Mocker BookReviewSelectorMock = new Mocker(BookReviewSelector.class)
        .setBehavior('getList', new List<Book_Review__c>());
        ObjectFactory.mocks.put(
            BookReviewSelector.class.getName(),
            (BookReviewSelector) BookReviewSelectorMock.getMock()
        );

        // execute
        BookReviewValidationService service = new BookReviewValidationService();
        service.validateReview(new List<Book_Review__c>{bookReviewForInsert});

        // assert
        BookReviewSelectorMock.assertMethodExecutionCount('getList', 1);
    }
}