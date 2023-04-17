/*
*This class performs unit tests for BookstoreBookValidationService class
*Tests consist of 3 mocks where we mock selectors and custom permission validation
*Since these are unit tests, all the Ids used are dummy Ids, they just had to be 18 char long
in order for objects to be created in the first place.
*/
@isTest
public with sharing class BookstoreBookValidationServiceTest {
    @isTest
    public static void validatePublisher_validationSuccessfull_willRunAsBookstoreManager() {
        //Create data for mocks and test
        List<Bookstore_Book__c> bookstoreBooksForTest = new BookstoreBookTestFactory().
        createBookstoreBooks(1, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        List<Book__c> bookForMock = new BookTestFactory().createBooks(1, 'a043N00000BRi9rQAD');
        List<Bookstore_Publisher__c> bkstorePublisherForMock = new BookstorePublisherTestFactory()
        .createBookstorePublishers(1, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBookById', bookForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getBookstorePublisherByPublisherIdAndBookstoreId', bkstorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );
        //Mock custom permission validation to make it seem like user has Bookstore_Manager custom permission
        Mocker customPermissionValidationMocker = new Mocker(CustomPermissionValidationService.class)
        .setBehavior('validateCustomPermission', true);
        ObjectFactory.mocks.put(
            CustomPermissionValidationService.class.getName(),
            (CustomPermissionValidationService) customPermissionValidationMocker.getMock()
        );

        Test.startTest();
        BookstoreBookValidationService bkStoreBookValidation = new BookstoreBookValidationService();
        bkStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();

        System.assert(bookstoreBooksForTest[0].getErrors().size() == 0);
        bookSelectorMock.assertMethodExecutionCount('getBookById', 1);
        bookStorePublisherSelectorMock.assertMethodExecutionCount('getBookstorePublisherByPublisherIdAndBookstoreId', 1);
        customPermissionValidationMocker.assertMethodExecutionCount('validateCustomPermission', 1);
    }

    @isTest
    public static void validatePublisher_validationFailure_willRunAsBookstoreManager() {
        //Create data for mocks and test
        List<Bookstore_Book__c> bookstoreBooksForTest = new BookstoreBookTestFactory().
        createBookstoreBooks(1, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        List<Book__c> bookForMock = new BookTestFactory().createBooks(1, 'a043N00000BRi9rQAD');
        List<Bookstore_Publisher__c> bkstorePublisherForMock = new List<Bookstore_Publisher__c>();
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBookById', bookForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getBookstorePublisherByPublisherIdAndBookstoreId', bkstorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );
        //Mock custom permission validation to make it seem like user has Bookstore_Manager custom permission
        Mocker customPermissionValidationMocker = new Mocker(CustomPermissionValidationService.class)
        .setBehavior('validateCustomPermission', true);
        ObjectFactory.mocks.put(
            CustomPermissionValidationService.class.getName(),
            (CustomPermissionValidationService) customPermissionValidationMocker.getMock()
        );
       
        Test.startTest();
        BookstoreBookValidationService bkStoreBookValidation = new BookstoreBookValidationService();
        bkStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();
        System.assert(bookstoreBooksForTest[0].getErrors().size() > 0);
        bookSelectorMock.assertMethodExecutionCount('getBookById', 1);
        bookStorePublisherSelectorMock.assertMethodExecutionCount('getBookstorePublisherByPublisherIdAndBookstoreId', 1);
        customPermissionValidationMocker.assertMethodExecutionCount('validateCustomPermission', 1);
    }

    @isTest
    public static void validatePublisher_validationNotPerformed_willNotRunAsBookstoreManager() {
        //Create data for mocks and test
        List<Bookstore_Book__c> bookstoreBooksForTest = new BookstoreBookTestFactory().
        createBookstoreBooks(1, 'a043N00000BRi9rQAD', 'a043N00000BRi9rQAD');
        List<Book__c> bookForMock = new BookTestFactory().createBooks(1, 'a043N00000BRi9rQAD');
        List<Bookstore_Publisher__c> bkstorePublisherForMock = new List<Bookstore_Publisher__c>();
        //Mock book selector so we don't depend on it
        Mocker bookSelectorMock = new Mocker(BookSelector.class)
        .setBehavior('getBookById', bookForMock);
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector)bookSelectorMock.getMock()
        );
        //Mock BookstoreBook selector so we don't depend on it
        Mocker bookStorePublisherSelectorMock = new Mocker(BookstorePublisherSelector.class)
        .setBehavior('getBookstorePublisherByPublisherIdAndBookstoreId', bkstorePublisherForMock);
        ObjectFactory.mocks.put(
            BookstorePublisherSelector.class.getName(),
            (BookstorePublisherSelector) bookStorePublisherSelectorMock.getMock()
        );
        //Mock custom permission validation to make it seem like user has Bookstore_Manager custom permission
        Mocker customPermissionValidationMocker = new Mocker(CustomPermissionValidationService.class)
        .setBehavior('validateCustomPermission', false);
        ObjectFactory.mocks.put(
            CustomPermissionValidationService.class.getName(),
            (CustomPermissionValidationService) customPermissionValidationMocker.getMock()
        );
        Test.startTest();
        BookstoreBookValidationService bkStoreBookValidation = new BookstoreBookValidationService();
        bkStoreBookValidation.validatePublisher(bookstoreBooksForTest);
        Test.stopTest();

        System.assert(bookstoreBooksForTest[0].getErrors().size() == 0);
        bookSelectorMock.assertMethodExecutionCount('getBookById', 0);
        bookStorePublisherSelectorMock.assertMethodExecutionCount('getBookstorePublisherByPublisherIdAndBookstoreId', 0);
        customPermissionValidationMocker.assertMethodExecutionCount('validateCustomPermission', 1);
    }
}