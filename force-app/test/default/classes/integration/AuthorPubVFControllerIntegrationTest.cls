/**
 * Class used for performing integration tests for AuthorPublisherVFController
 * Performs positive tests for public methods in the controller
 * Every test revolves around creating data, such that a Book__c book record has the same publisher and author 
 * as the Author_Publisher__c record
 * Which will fail in deletion
 */
@isTest
public with sharing class AuthorPubVFControllerIntegrationTest {
    /**
     * This method tests both if the delete failed, and the page reference that was returned.
     * If the deletion failed page reference will be null (staying on the same page of VF page)
     */
    @isTest
    public static void deleteRecord_willFail_IfTRelatedBookExists() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        ApexPages.StandardController stdController = new ApexPages.StandardController(AuthorPublisherForTest);

        // execute
        Test.startTest();
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        controller.deleteRecord();
        Test.stopTest();

        // assert 
        Assert.areEqual(true, controller.didDeleteFail);
    }

    @isTest
    public static void getBooksCausingError_willReturnRelatedBook_ifTSameAuthorAndPublisher() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        ApexPages.StandardController stdController = new ApexPages.StandardController(AuthorPublisherForTest);
        
        // execute
        Test.startTest();
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        List<Book__c> booksCausingError = controller.getBooksCausingError();
        Test.stopTest();

        // assert 
        Assert.areEqual(1, booksCausingError.size());
    }

    @isTest
    public static void cancel_willReturnPageReference() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        ApexPages.StandardController stdController = new ApexPages.StandardController(AuthorPublisherForTest);

        // execute
        Test.startTest();
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        Pagereference pageReference = controller.cancel();
        Test.stopTest();

        // assert 
        Assert.isTrue(pageReference != null);
    }

    @isTest
    public static void viewAll_willReturnPageReference() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Author_Publisher__c authorPublisherForTest = testFactory
            .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        ApexPages.StandardController stdController = new ApexPages.StandardController(AuthorPublisherForTest);

        // execute
        Test.startTest();
        AuthorPublisherVFController controller = new AuthorPublisherVFController(stdController);
        Pagereference pageReference = controller.viewAll();
        Test.stopTest();

        // assert 
        Assert.isTrue(pageReference != null);
    }
}