/**
 * Class used for performing unit tests for GetDuplicateBooksService
 */
@isTest
public with sharing class GetDuplicateBooksServiceTest {
    @isTest
    public static void getDuplicates_willReturnDuplicates_ifDuplicatesExistInListProvidedAndDatabase() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        List<Book__c> bookListForTest = new List<Book__c>{ bookForTest, bookForTest };

        // create mock
        Mocker bookSelectorMocker = new Mocker(BookSelector.class)
            .setBehavior('getListByISBNs', new List<Book__c>{ bookForTest });
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMocker.getMock()
        );

        // execute
        GetDuplicateBooksService service = new GetDuplicateBooksService();
        Map<String, List<Book__c>> duplicateLists = service.getDuplicates(bookListForTest);

        // assert
        Assert.areEqual(0, duplicateLists.get('nonDuplicateRecords').size());
        Assert.areEqual(3, duplicateLists.get('duplicateRecords').size());
        Assert.areEqual(1, duplicateLists.get('duplicatesFromDatabase').size());
    }

    @isTest
    public static void getDuplicates_willNotReturnDuplicates_ifDuplicatesDontExist() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        List<Book__c> bookListForTest = new List<Book__c>{ bookForTest };

        // create mock
        Mocker bookSelectorMocker = new Mocker(BookSelector.class)
            .setBehavior('getListByISBNs', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMocker.getMock()
        );

        // execute
        GetDuplicateBooksService service = new GetDuplicateBooksService();
        Map<String, List<Book__c>> duplicateLists = service.getDuplicates(bookListForTest);

        // assert
        Assert.areEqual(1, duplicateLists.get('nonDuplicateRecords').size());
        Assert.areEqual(0, duplicateLists.get('duplicateRecords').size());
        Assert.areEqual(0, duplicateLists.get('duplicatesFromDatabase').size());
    }

    @isTest
    public static void getDuplicates_willUseSelector() {
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true);
        Author__c authorForTest = testFactory.createAuthor(true);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        List<Book__c> bookListForTest = new List<Book__c>{ bookForTest };

        // create mock
        Mocker bookSelectorMocker = new Mocker(BookSelector.class)
            .setBehavior('getListByISBNs', new List<Book__c>{});
        ObjectFactory.mocks.put(
            BookSelector.class.getName(),
            (BookSelector) bookSelectorMocker.getMock()
        );

        // execute
        GetDuplicateBooksService service = new GetDuplicateBooksService();
        Map<String, List<Book__c>> duplicateLists = service.getDuplicates(bookListForTest);

        // assert
        bookSelectorMocker.assertMethodExecutionCount('getListByISBNs', 1);
    }
}