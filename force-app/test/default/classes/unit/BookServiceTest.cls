/**
 * This is unit test class for BookService
 * 
 * @see BookService.cls
 */
@isTest
public with sharing class BookServiceTest {
    @IsTest
    static void getBookById_WillUseSelector() {
        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getBookById', new Book__c());
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        BookService service = new BookService();
        service.getBookById(new TestFactory().getFakeId(Book__c.SObjectType, true));
        Book__c book = service.getResponse();
        Test.stopTest();

        // assert
        bookSelectorMock.assertMethodExecutionCount('getBookById', 1);
    }
    
    @IsTest
    static void getResponse_WillReturnNull_ifBookIdIsNull() {
        // execute
        Test.startTest();
        BookService service = new BookService();
        service.getBookById(null);
        Book__c book = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(null, book);
    }
    
    @IsTest
    static void getResponse_WillReturnNull_IfNoBookIsFound() {
        // create mock
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
            .setBehavior('getBookById', null);
        // set mock
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        BookService service = new BookService();
        service.getBookById(new TestFactory().getFakeId(Book__c.SObjectType, true));
        Book__c book = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(null, book);
    }

    }