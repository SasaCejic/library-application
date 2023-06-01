/**
 * Class tests selector execution account in AuthorPublisherVFController services
 * Every test requires data to be made so the controller can even be instantiated
 * Every test will require mocking the AuthorPublisherSelector class, because it runs in the constructor
 * Controller must be instantaiated because it is an extension of standard controller
 */
@isTest
public with sharing class AuthorPublisherVFControllerTest {
    @isTest
    public static void getBooksCausingError_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(publisherForTest.Id, authorForTest.Id, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(authorPublisherForTest);

        // create mocks
        Mocker authorPublisherSelectorMocker = new Mocker(AuthorPublisherSelector.class)
            .setBehavior('getRecordById', authorPublisherForTest);
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMocker.getMock()
        );

        Mocker getRelatedBooksOnAuthPubDelServiceMocker = new Mocker(GetRelatedBooksOnAuthPubDelService.class);
        getRelatedBooksOnAuthPubDelServiceMocker.setBehavior('getRelatedBooks', null);
        getRelatedBooksOnAuthPubDelServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            GetRelatedBooksOnAuthPubDelService.class.getName(),
            (GetRelatedBooksOnAuthPubDelService) getRelatedBooksOnAuthPubDelServiceMocker.getMock()
        );

        // execute
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        controller.getBooksCausingError();

        // assert 
        getRelatedBooksOnAuthPubDelServiceMocker.assertMethodExecutionCount('getRelatedBooks', 1);
        getRelatedBooksOnAuthPubDelServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void getPageReference_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(authorPublisherForTest);

        // create mocks
        Mocker authorPublisherSelectorMocker = new Mocker(AuthorPublisherSelector.class)
            .setBehavior('getRecordById', authorPublisherForTest);
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMocker.getMock()
        );

        Mocker pageReferenceServiceMocker = new Mocker(PageReferenceService.class);
        pageReferenceServiceMocker.setBehavior('getPageReferenceForAuthorPublisher', null);
        pageReferenceServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            PageReferenceService.class.getName(),
            (PageReferenceService) pageReferenceServiceMocker.getMock()
        );

        // execute
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        controller.getPageReference();

        // assert 
        pageReferenceServiceMocker.assertMethodExecutionCount('getPageReferenceForAuthorPublisher', 1);
        pageReferenceServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void cancel_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(publisherForTest.Id, authorForTest.Id, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(authorPublisherForTest);

        // create mocks
        Mocker AuthorPublisherSelectorMocker = new Mocker(AuthorPublisherSelector.class)
            .setBehavior('getRecordById', authorPublisherForTest);
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) AuthorPublisherSelectorMocker.getMock()
        );

        Mocker PageReferenceServiceMocker = new Mocker(PageReferenceService.class);
        PageReferenceServiceMocker.setBehavior('getPageReferenceForAuthorPublisher', null);
        PageReferenceServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            PageReferenceService.class.getName(),
            (PageReferenceService) PageReferenceServiceMocker.getMock()
        );

        // execute
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        controller.cancel();
        PageReferenceServiceMocker.assertMethodExecutionCount('getPageReferenceForAuthorPublisher', 1);
        PageReferenceServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

    @isTest
    public static void viewAll_willUseService() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(publisherForTest.Id, authorForTest.Id, true);
        ApexPages.StandardController stdController = new ApexPages.StandardController(authorPublisherForTest);

        // create mocks
        Mocker AuthorPublisherSelectorMocker = new Mocker(AuthorPublisherSelector.class)
            .setBehavior('getRecordById', authorPublisherForTest);
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) AuthorPublisherSelectorMocker.getMock()
        );

        Mocker PageReferenceServiceMocker = new Mocker(PageReferenceService.class);
        PageReferenceServiceMocker.setBehavior('getPageReferenceForAuthorPublisher', null);
        PageReferenceServiceMocker.setBehavior('getResponse', null);
        ObjectFactory.mocks.put(
            PageReferenceService.class.getName(),
            (PageReferenceService) PageReferenceServiceMocker.getMock()
        );

        // execute
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        controller.viewAll();
        PageReferenceServiceMocker.assertMethodExecutionCount('getPageReferenceForAuthorPublisher', 1);
        PageReferenceServiceMocker.assertMethodExecutionCount('getResponse', 1);
    }

}