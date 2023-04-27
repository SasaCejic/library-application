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
            .setBehavior('getListByAuthorId', new AggregateResult[]{});
        // set mock
        ObjectFactory.mocks.put(
            BookstoreBookSelector.class.getName(),
            (BookstoreBookSelector) bookstoreBookSelectorMock.getMock()
        );

        //create mock
        Mocker bookstoreSelectorMock = new Mocker(BookstoreSelector.class)
            .setBehavior('getListByIds', new List<Bookstore__c>{bookstore});
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
        bookstoreBookSelectorMock.assertMethodExecutionCount('getListByAuthorId', 1);
        bookstoreSelectorMock.assertMethodExecutionCount('getListByIds', 1);
        Assert.areEqual(1, bookstores.size());
        Assert.areEqual(bookstore.Id, bookstores[0].Id);
    }
    
    @IsTest
    static void getResponse_WillReturnNull_ifAuthorIdIsNull() {
        // execute
        Test.startTest();
        AuthorService service = new AuthorService();
        service.getBookstoresWithAuthorsBooks(null);
        List<Bookstore__c> bookstores = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(null, bookstores);
    }
    
    @IsTest
    static void getResponse_WillReturnEmptyList_IfNoBookstoresAreFound() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        //create and insert Author__c object
        Author__c author = testFactory.createAuthor(true, false);

        // execute
        Test.startTest();
        AuthorService service = new AuthorService();
        service.getBookstoresWithAuthorsBooks(author.Id);
        List<Bookstore__c> bookstores = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(0, bookstores.size());
    }

    @IsTest
    static void getResponse_WillReturnThreeBookstoresWithAuthorsBooks_IfThereAreThreeBookstoresWithAuthorsBooks() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        //create and insert Author__c object
        Author__c author = testFactory.createAuthor(true, false);

        // create and insert Publisher__c object
        Publisher__c publisher = testFactory.createPublisher(true, false);

        //create and insert Book__c object
        Book__c book = testFactory.createBook(publisher.Id, author.Id, true, false);

        //create and insert Bookstore__c objects
        Bookstore__c bookstore1 = testFactory.createBookstore(true, false);

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher1 = testFactory.createBookstorePublisher(publisher.Id, bookstore1.Id, true, false);

        //We need to change the unique store Id number, Name and Email
        // before inserting another bookstore
        testFactory.bookstoreDetails.put('name', 'bookstore2');
        testFactory.bookstoreDetails.put('email', 'bookstore2@gmail.com');
        testFactory.bookstoreDetails.put('storeId', '85758498');
        Bookstore__c bookstore2 = testFactory.createBookstore(true, false);

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher2 = testFactory.createBookstorePublisher(publisher.Id, bookstore2.Id, true, false);

        //We need to change the unique store Id number, Name and Email
        // before inserting another bookstore
        testFactory.bookstoreDetails.put('name', 'bookstore3');
        testFactory.bookstoreDetails.put('email', 'bookstore3@gmail.com');
        testFactory.bookstoreDetails.put('storeId', '04793211');
        Bookstore__c bookstore3 = testFactory.createBookstore(true, false);

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher3 = testFactory.createBookstorePublisher(publisher.Id, bookstore3.Id, true, false);

        //create and insert Bookstore_Book__c junction objects
        Bookstore_Book__c bookstoreBook1 = testFactory.createBookstoreBook(book.Id, bookstore1.Id, true, false);
        Bookstore_Book__c bookstoreBook2 = testFactory.createBookstoreBook(book.Id, bookstore2.Id, true, false);
        Bookstore_Book__c bookstoreBook3 = testFactory.createBookstoreBook(book.Id, bookstore3.Id, true, false);

        // execute
        Test.startTest();
        AuthorService service = new AuthorService();
        service.getBookstoresWithAuthorsBooks(author.Id);
        List<Bookstore__c> bookstores = service.getResponse();
        Test.stopTest();

        // assert
        Assert.areEqual(3, bookstores.size());
        Assert.areEqual(bookstore1.Id, bookstores[0].Id);
        Assert.areEqual(bookstore2.Id, bookstores[1].Id);
        Assert.areEqual(bookstore3.Id, bookstores[2].Id);
    }

}