/*
 * This class is used to test logic in AuthorPubDeleteValidationService class
 */
@isTest
public with sharing class AuthorPubDeleteValidationServiceTest {
    @isTest
    public static void validateAuthorPublisher_willNotAddError_ifRelatedBookDoesentExist() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true);

        // create mock
        Mocker bookSelectorMocker = new Mocker(BookSelector.class)
            .setBehavior('getListByAuthorIds', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMocker.getMock()
        );

        // execute
        AuthorPublisherDeleteValidationService service = new AuthorPublisherDeleteValidationService();
        service.validateAuthorPublisher(new List<Author_Publisher__c>{ authorPublisherForTest }, 2000);

        // Assert
        Assert.isTrue(authorPublisherForTest.getErrors().size() == 0);
    }
    
    @isTest
    public static void validateAuthorPublisher_willUseSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true);

        // create mock
        Mocker bookSelectorMocker = new Mocker(BookSelector.class)
            .setBehavior('getListByAuthorIds', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMocker.getMock()
        );

        // execute
        AuthorPublisherDeleteValidationService service = new AuthorPublisherDeleteValidationService();
        service.validateAuthorPublisher(new List<Author_Publisher__c>{ authorPublisherForTest }, 2000);

        // Assert
        bookSelectorMocker.assertMethodExecutionCount('getListByAuthorIds', 1);
    }
}