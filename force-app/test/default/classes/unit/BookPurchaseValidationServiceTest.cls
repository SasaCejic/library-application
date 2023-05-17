/*
 * This class is used for testing book purchase validation service
 * There will be 1 positive, 1 negative and 1 mockerexecutioncount tests
 */
@isTest
public with sharing class BookPurchaseValidationServiceTest {
    /*
     * Reason why we have no mocks in this method is because the code will add error before the selector is even executed
     */
    @isTest
    public static void validatePurchase_willAddError_ifTwoSamePurchasesAreInsertedAtOnce() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Book_Purchase__c purchaseForTest = testFactory.createBookPurchase(bookForTest.Id, false, true);

        // execute
        BookPurchaseValidationService service = new BookPurchaseValidationService();
        service.validatePurchase(new List<Book_Purchase__c>{purchaseForTest, purchaseForTest});

        // assert
        Assert.isTrue(purchaseForTest.getErrors().size() == 1);
    }

    @isTest
    public static void validatePurchase_wilNotAddError_ifNoSamePurchasesExist() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Book_Purchase__c purchaseForTest = testFactory.createBookPurchase(bookForTest.Id, false, true);
        
        // create mock
        Mocker BookPurchaseSelectorMock = new Mocker(BookPurchaseSelector.class)
            .setBehavior('getList', new List<Book_Purchase__c>());
        ObjectFactory.mocks.put(
            BookPurchaseSelector.class.getName(),
            (BookPurchaseSelector) BookPurchaseSelectorMock.getMock()
        );

        // execute
        BookPurchaseValidationService service = new BookPurchaseValidationService();
        service.validatePurchase(new List<Book_Purchase__c>{purchaseForTest});

        // assert
        Assert.isTrue(purchaseForTest.getErrors().size() == 0);
    }

    @isTest
    public static void validatePurchase_willUseCorrectSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false, true);
        Author__c authorForTest = testFactory.createAuthor(false, true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false, true);
        Book_Purchase__c purchaseForTest = testFactory.createBookPurchase(bookForTest.Id, false, true);
        
        // create mock
        Mocker BookPurchaseSelectorMock = new Mocker(BookPurchaseSelector.class)
            .setBehavior('getList', new List<Book_Purchase__c>());
        ObjectFactory.mocks.put(
            BookPurchaseSelector.class.getName(),
            (BookPurchaseSelector) BookPurchaseSelectorMock.getMock()
        );

        // execute
        BookPurchaseValidationService service = new BookPurchaseValidationService();
        service.validatePurchase(new List<Book_Purchase__c>{purchaseForTest});

        // assert
        BookPurchaseSelectorMock.assertMethodExecutionCount('getList', 1);
    }
}