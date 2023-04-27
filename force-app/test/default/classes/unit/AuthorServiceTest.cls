/**
 * This class tests the AuthorService class methods
 * 
 * @see AuthorService.cls
 */
@isTest
public with sharing class AuthorServiceTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillUseSelectors() {
        //create TestFactory
        TestFactory testFactory = new TestFactory();

        //create Bookstore__c
        Bookstore__c bookstore = testFactory.createBookstore(false, true);
        
        //create Author__c
        Author__c author = testFactory.createAuthor(false, true);

        // create mock
        Mocker bookstoreBookSelectorMock = new Mocker(BookstoreBookSelector.class)
            .setBehavior('getBookstoreBooksWithAuthorsBooks', new AggregateResult[]{});
        // set mock
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector) bookstoreBookSelectorMock.getMock()
        );

        //create mock
        Mocker bookstoreSelectorMock = new Mocker(BookstoreSelector.class)
            .setBehavior('getBookstoresWithAuthorsBooks', new List<Bookstore__c>{bookstore});
        // set mock
        ObjectFactory.mocks.put(
            BookstoreSelector.class.getName(),
            (BookstoreSelector) bookstoreSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        AuthorService service = new AuthorService();
        service.getBookstoresWithAuthorsBooks(author.Id);
        List<Bookstore__c> bookstores = service.getResponse();
        Test.stopTest();

        // assert
        bookstoreBookSelectorMock.assertMethodExecutionCount('getBookstoreBooksWithAuthorsBooks', 1);
        bookstoreSelectorMock.assertMethodExecutionCount('getBookstoresWithAuthorsBooks', 1);
        Assert.areEqual(1, bookstores.size());
        Assert.areEqual(bookstore.Id, bookstores[0].Id);
    }

}