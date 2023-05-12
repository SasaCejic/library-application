/**
 * This class tests the BookstoreValidationService class
 * 
 * @see BookstoreValidationService.cls
 */
@isTest
public with sharing class BookstoreValidationServiceTest {
    @isTest
    public static void validateBookstoreManagerMatch_WillUseCorrectSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        User userForTest = testFactory.createUser(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        //make user manager of the bookstore
        bookstoreForTest.Manager__c = userForTest.Id;

        // create mocks
        Mocker bookstoreSelectorMock = new Mocker(BookstoreSelector.class)
        .setBehavior('getListByManagers', new List<Bookstore__c>{
            bookstoreForTest
        });
        ObjectFactory.mocks.put(
            BookstoreSelector.class.getName(),
            (BookstoreSelector)bookstoreSelectorMock.getMock()
        );

        // execute
        BookstoreValidationService bookstoreValidationService = new BookstoreValidationService();
        bookstoreValidationService.validateBookstoreManagerMatch(new List<Bookstore__c>{bookstoreForTest});

        // assert
        bookstoreSelectorMock.assertMethodExecutionCount('getListByManagers', 1);
    }

    @isTest
    public static void validateBookstoreManagerMatch_WillNotAddError_IfUserIsNotManager() {
        // create data
        TestFactory testFactory = new TestFactory();
        User userForTest = testFactory.createUser(false, true);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false, true);
        //make user manager of the bookstore
        bookstoreForTest.Manager__c = userForTest.Id;

        // create mocks
        Mocker bookstoreSelectorMock = new Mocker(BookstoreSelector.class)
        .setBehavior('getListByManagers', new List<Bookstore__c>{});
        ObjectFactory.mocks.put(
            BookstoreSelector.class.getName(),
            (BookstoreSelector)bookstoreSelectorMock.getMock()
        );

        // execute
        BookstoreValidationService bookstoreValidationService = new BookstoreValidationService();
        bookstoreValidationService.validateBookstoreManagerMatch(new List<Bookstore__c>{bookstoreForTest});

        // assert
        Assert.isTrue(bookstoreForTest.getErrors().size() == 0);
    }
    
    @isTest
    public static void validateBookstoreManagerMatch_WillAddError_IfUserIsManagerOfSomeBookstore() {
       // create data
       TestFactory testFactory = new TestFactory();
       User userForTest = testFactory.createUser(false, true);
       Bookstore__c bookstore1 = testFactory.createBookstore(false, true);
       //make user manager of the bookstore
       bookstore1.Manager__c = userForTest.Id;
       Bookstore__c bookstore2 = testFactory.createBookstore(false, true);
       //make user manager of the bookstore
       bookstore2.Manager__c = userForTest.Id;

       // create mocks
       Mocker bookstoreSelectorMock = new Mocker(BookstoreSelector.class)
       .setBehavior('getListByManagers', new List<Bookstore__c>{
           bookstore1
       });
       ObjectFactory.mocks.put(
           BookstoreSelector.class.getName(),
           (BookstoreSelector)bookstoreSelectorMock.getMock()
       );

       // execute
       BookstoreValidationService bookstoreValidationService = new BookstoreValidationService();
       bookstoreValidationService.validateBookstoreManagerMatch(new List<Bookstore__c>{bookstore2});

       // assert
       Assert.isTrue(bookstore2.getErrors().size() == 1);
       Assert.areEqual('User is already a Bookstore Manager!', bookstore2.getErrors()[0].getMessage());
    }
}