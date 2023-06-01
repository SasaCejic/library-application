/*
 * Class used for testng GetRelatedBooksOnAuthPubDelService
 */
@isTest
public with sharing class GetRelatedBooksOnAuthPubDelServiceTest {
    @isTest
    public static void getRelatedBooks_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true);

        // create mocks
        Mocker authorPublisherSelectorMocker = new Mocker(AuthorPublisherSelector.class)
            .setBehavior('getRecordById', authorPublisherForTest);
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMocker.getMock()
        );

        Mocker authorPublisherDeleteValidationServiceMocker = new Mocker(AuthorPublisherDeleteValidationService.class)
            .setBehavior('validateAuthorPublisher', null)
            .setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            AuthorPublisherDeleteValidationService.class.getName(),
            (AuthorPublisherDeleteValidationService) authorPublisherDeleteValidationServiceMocker.getMock()
        );

        // execute
        GetRelatedBooksOnAuthPubDelService service = new GetRelatedBooksOnAuthPubDelService();
        service.getRelatedBooks(authorPublisherForTest.Id, 5);

        // Assert
        authorPublisherSelectorMocker.assertMethodExecutionCount('getRecordById', 1);
        authorPublisherDeleteValidationServiceMocker.assertMethodExecutionCount('validateAuthorPublisher', 1);
        authorPublisherDeleteValidationServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }
}