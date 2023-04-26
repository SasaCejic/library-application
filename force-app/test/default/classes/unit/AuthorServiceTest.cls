/**
 * This class tests the AuthorService class methods
 * 
 * @see AuthorService.cls
 */
@isTest
public with sharing class AuthorServiceTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillUseSelectors() {
        //create Bookstore__c
        TestFactory testFactory = new TestFactory();
        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'TestBookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1234567');
        Bookstore__c bookstore = testFactory.createBookstore(bookstoreDetails, false, true);
        
        //create Author__c
        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('name', 'Test Author');
        authorDetails.put('firstName', 'Test');
        authorDetails.put('lastName', 'Author');
        Author__c author = testFactory.createAuthor(authorDetails, false, true);

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
        List<Bookstore__c> bookstores = service.getBookstoresWithAuthorsBooks(author.Id);
        Test.stopTest();

        // assert
        bookstoreBookSelectorMock.assertMethodExecutionCount('getBookstoreBooksWithAuthorsBooks', 1);
        bookstoreSelectorMock.assertMethodExecutionCount('getBookstoresWithAuthorsBooks', 1);
        Assert.areEqual(1, bookstores.size());
        Assert.areEqual(bookstore.Id, bookstores[0].Id);
    }

}