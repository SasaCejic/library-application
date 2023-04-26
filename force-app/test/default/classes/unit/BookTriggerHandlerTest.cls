/*
* This class is used to test logic in the BookTriggerHandler
*/
@isTest
public with sharing class BookTriggerHandlerTest {
 /*
    * Data used for creating objects is simple input for required fields. 
    * It won't influence the test as we use mockers, it's just there to fulfill object creation.
    */
    //reusable details for the data to be created in tests
    private static Map<String, String> publisherDetails = new Map<String, String>{
        'name'=>'publisher',
        'email'=>'publisher@gmail.com',
        'phone'=>'1241353'
    };
    private static Map<String, String> authorDetails = new Map<String, String>{
        'firstName'=>'Author',
        'lastName'=>'Author'
    };
    private static Map<String, String> bookDetails = new Map<String, String>{
        'name'=>'book',
        'description'=>'bookdesc',
        'ISBN'=>'214215425',
        'language'=>'english',
        'categories'=>'fantasy'
    };

    @isTest
    public static void beforeInsert_willNotFindError_ifErrorNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);
        Book__c bookForMock = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);
        //Mock AuthorPublisher selector so we don't depend on it
        Mocker bookValidationServiceMock = new Mocker(BookValidationService.class)
        .setBehavior('validateAuthorPublisherMatch', new List<Book__c>{bookForMock});
        ObjectFactory.mocks.put(
            bookValidationService.class.getName(),
            (BookValidationService)bookValidationServiceMock.getMock()
        );

        Test.startTest();
        BookTriggerHandler bookTriggerHandler = new BookTriggerHandler();
        bookTriggerHandler.beforeInsert(new List<Book__c>{bookForMock});
        Test.stopTest();

        System.assert(BookForMock.getErrors().size() == 0,'Errors should not have been added to book record');
        bookValidationServiceMock.assertMethodExecutionCount('validateAuthorPublisherMatch', 1);
    }

    @isTest
    public static void beforeUpdate_willNotFindError_ifErrorNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);
        Book__c oldBookForMock = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);
        Book__c newBookForMock = oldBookForMock.clone(true);
        newBookForMock.Name='new name';
        //Mock AuthorPublisher selector so we don't depend on it
        Mocker bookValidationServiceMock = new Mocker(BookValidationService.class)
        .setBehavior('validateAuthorPublisherMatch', null);
        ObjectFactory.mocks.put(
            bookValidationService.class.getName(),
            (BookValidationService)bookValidationServiceMock.getMock()
        );

        Test.startTest();
        BookTriggerHandler bookTriggerHandler = new BookTriggerHandler();
        bookTriggerHandler.beforeUpdate(new List<Book__c>{oldBookForMock},new List<Book__c>{newBookForMock});
        Test.stopTest();

        System.assert(newBookForMock.getErrors().size() == 0,'Errors should not have been added to book record');
        bookValidationServiceMock.assertMethodExecutionCount('validateAuthorPublisherMatch', 1);
    }
}