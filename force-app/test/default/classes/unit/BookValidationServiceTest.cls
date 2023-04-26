/*
*This class performs unit tests for the BookValidationService class
*Tests include a mock for the AuthorPublisherSelector
*Both single and multiple validations are tested
*Method Execution count will always be the same regardless of the amount of records inserted
*/
@isTest
public with sharing class BookValidationServiceTest {
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
    public static void validateAuthorPublisherMatch_willNotAddError_ifAuthorPublisherIsAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);
        Author_Publisher__c authorPublisherForMock = testFactory
        .createAuthorPublisher(authorForTest.Id, publisherForTest.Id, false, true);

        //Mock AuthorPublisher selector so we don't depend on it
        Mocker authorPublisherSelectorMock = new Mocker(AuthorPublisherSelector.class)
        .setBehavior('getList', new List<Author_Publisher__c>{authorPublisherForMock});
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookValidationService bookValidation = new BookValidationService();
        bookValidation.validateAuthorPublisherMatch(new List<Book__c>{bookForTest});
        Test.stopTest();

        System.assert(BookForTest.getErrors().size() == 0,'Errors should not have been added to book record');
    }

    @isTest
    public static void validateAuthorPublisherMatch_willAddError_ifAuthorPublisherNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, false, true);
        Author__c authorForTest = testFactory.createAuthor(authorDetails, false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, true);

        //Mock AuthorPublisher selector so we don't depend on it
        Mocker authorPublisherSelectorMock = new Mocker(AuthorPublisherSelector.class)
        .setBehavior('getList', new List<Author_Publisher__c>{});
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookValidationService bookValidation = new BookValidationService();
        bookValidation.validateAuthorPublisherMatch(new List<Book__c>{bookForTest});
        Test.stopTest();

        System.assert(BookForTest.getErrors().size() == 1,'An error should have been added to the book record');
    }

    @isTest
    public static void validateAuthorPublisherMatch_singleSelectorUse_ifMultipleBooksAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        List<Publisher__c> publishersForTest=new List<Publisher__c>();
        List<Author__c> authorsForTest =new List<Author__c>();
        List<Book__c> booksForTest = new List<Book__c>();
        List<Author_Publisher__c> authorPublishersForMock = new List<Author_Publisher__c>();
        for(Integer i=0;i<3;i++){
            publishersForTest.add(testFactory.createPublisher(publisherDetails, false, true));
            authorsForTest.add(testFactory.createAuthor(authorDetails, false, true));
            booksForTest.add(testFactory.createBook((publishersForTest[i]).Id, (authorsForTest[i]).Id, bookDetails, false, true));
            authorPublishersForMock.add(testFactory.createAuthorPublisher((authorsForTest[i]).Id, (publishersForTest[i]).Id, false, true));
        }
        //Mock AuthorPublisher selector so we don't depend on it
        Mocker authorPublisherSelectorMock = new Mocker(AuthorPublisherSelector.class)
        .setBehavior('getList', authorPublishersForMock);
        ObjectFactory.mocks.put(
            AuthorPublisherSelector.class.getName(),
            (AuthorPublisherSelector) authorPublisherSelectorMock.getMock()
        );

        Test.startTest();
        BookValidationService bookValidation = new BookValidationService();
        bookValidation.validateAuthorPublisherMatch(booksForTest);
        Test.stopTest();

        authorPublisherSelectorMock.assertMethodExecutionCount('getList', 1);
    }
}