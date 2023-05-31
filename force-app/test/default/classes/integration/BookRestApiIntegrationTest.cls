/**
 * Class used for performing integration test for BookRestApi
 */
@isTest
public with sharing class BookRestApiIntegrationTest {
    @isTest
    public static void doPost_willInsertBookRecords_ifThereAreNotDuplicatesAndOptionEqualsToOne() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Author_Publisher__c authorPublisherForTest = testFactory.createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        insert authorPublisherForTest;
        Book__c book1 = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        Book__c book2 = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        book2.ISBN__c = '21542675223';

        // Set up the REST Request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/api/Book__c/';
        request.httpMethod = 'POST';
        Map<String, Object> reqBody = new Map<String, Object>();
        reqBody.put('data', new List<Book__c>{ book1, book2 });
        reqBody.put('option', 1);
        request.requestBody = Blob.valueOf(JSON.serialize(reqBody));

        // Set up the REST response
        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        // execute
        Test.startTest();
        BookRestApi.doPost();
        Test.stopTest();

        // Assert
        Assert.areEqual(200, response.statusCode);
    }
}