/**
 * Class used for testing ConvertBookRestApiJsonDataService
 */
@isTest
public with sharing class ConverBookRestApiJsonDataServiceTest {
    @isTest
    public static void convert_willReturnBookRestApiRequestDTOWithData_ifDataWasProvidedInJsonRequest() {
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

        Map<String, Object> jsonMap = new Map<String, Object>();
        jsonMap.put('data', new List<Book__c>{ book1, book2 });
        jsonMap.put('option', 1);
        
        // execute
        ConvertBookRestApiJsonDataService service = new ConvertBookRestApiJsonDataService();
        BookRestApiRequestDTO bookRestApiRequestDto = service.convert(JSON.serialize(jsonMap));

        // Assert
        Assert.areEqual(2, bookRestApiRequestDto.bookList.size());
        Assert.areEqual(1, bookRestApiRequestDto.insertOption);
    }

    @isTest
    public static void convert_willReturnBookRestApiRequestDTOWithoutData_ifDataWasntProvidedInJsonRequest() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        Author__c authorForTest = testFactory.createAuthor(false);
        Author_Publisher__c authorPublisherForTest = testFactory.createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false);
        Book__c book1 = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        Book__c book2 = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        Map<String, Object> jsonMap = new Map<String, Object>();
        
        // execute
        ConvertBookRestApiJsonDataService service = new ConvertBookRestApiJsonDataService();
        BookRestApiRequestDTO bookRestApiRequestDto = service.convert(JSON.serialize(jsonMap));

        // Assert
        Assert.areEqual(null, bookRestApiRequestDto.bookList);
        Assert.areEqual(null, bookRestApiRequestDto.insertOption);
    }
}