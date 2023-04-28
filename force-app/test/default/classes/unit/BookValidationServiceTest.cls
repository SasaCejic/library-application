/*
*This class performs unit tests for the BookValidationService class
*Tests include a mock for the AuthorPublisherSelector
*Both single and multiple validations are tested
*Method Execution count will always be the same regardless of the amount of records inserted
*/
@isTest
public with sharing class BookValidationServiceTest {

    @isTest
    public static void validateAuthorPublisherMatch_willNotAddError_ifAuthorPublisherIsAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Author_Publisher__c authorPublisherForMock = testFactory
        .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false, true);

        //Mock AuthorPublisher selector so we don't depend on it
        Mocker authorPublisherSelectorMock = new Mocker(AuthorPublisherSelector.class)
        .setBehavior('getList', new List<Author_Publisher__c>{authorPublisherForMock});
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMock.getMock()
        );

        BookValidationService bookValidation = new BookValidationService();
        bookValidation.validateAuthorPublisherMatch(new List<Book__c>{bookForTest});

        Assert.isTrue(BookForTest.getErrors().size() == 0,'Errors should not have been added to book record');
    }

    @isTest
    public static void validateAuthorPublisherMatch_willAddError_ifAuthorPublisherNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);

        //Mock AuthorPublisher selector so we don't depend on it
        Mocker authorPublisherSelectorMock = new Mocker(AuthorPublisherSelector.class)
        .setBehavior('getList', new List<Author_Publisher__c>{});
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMock.getMock()
        );

        BookValidationService bookValidation = new BookValidationService();
        bookValidation.validateAuthorPublisherMatch(new List<Book__c>{bookForTest});

        Assert.isTrue(BookForTest.getErrors().size() == 1,'An error should have been added to the book record');
    }

    @isTest
    public static void validateAuthorPublisherMatch_willUseCorrectSelector() {
        //Mock AuthorPublisher selector so we don't depend on it
        Mocker authorPublisherSelectorMock = new Mocker(AuthorPublisherSelector.class)
        .setBehavior('getList', new List<Author_Publisher__c>{});
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMock.getMock()
        );

        BookValidationService bookValidation = new BookValidationService();
        bookValidation.validateAuthorPublisherMatch(new List<Book__c>{});

        authorPublisherSelectorMock.assertMethodExecutionCount('getList', 1);
    }
}