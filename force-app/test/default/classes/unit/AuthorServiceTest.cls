/**
 * This class tests the AuthorService class methods
 * 
 * @see AuthorService.cls
 */
@isTest
public with sharing class AuthorServiceTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillUseSelectors() {
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
            .setBehavior('getListByIds', new List<Bookstore__c>{});
        // set mock
        ObjectFactory.mocks.put(
            BookstoreSelector.class.getName(),
            (BookstoreSelector) bookstoreSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        AuthorService service = new AuthorService();
        service.getBookstoresWithAuthorsBooks(new TestFactory().getFakeId(Author__c.SObjectType, true));
        List<Bookstore__c> bookstores = service.getResponse();
        Test.stopTest();

        // assert
        bookstoreBookSelectorMock.assertMethodExecutionCount('getListByAuthorId', 1);
        bookstoreSelectorMock.assertMethodExecutionCount('getListByIds', 1);
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
            .setBehavior('getListByIds', new List<Bookstore__c>{});
        // set mock
        ObjectFactory.mocks.put(
            BookstoreSelector.class.getName(),
            (BookstoreSelector) bookstoreSelectorMock.getMock()
        );

        // execute
        Test.startTest();
        AuthorService service = new AuthorService();
        service.getBookstoresWithAuthorsBooks(new TestFactory().getFakeId(Author__c.SObjectType, true));
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
        Author__c author = testFactory.createAuthor(true);
        // create and insert Publisher__c object
        Publisher__c publisher = testFactory.createPublisher(true);
        //create and insert Book__c object
        Book__c book = testFactory.createBook(publisher.Id, author.Id, true);
        //create and insert Bookstore__c objects
        Bookstore__c bookstore1 = testFactory.createBookstore(true);
        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher1 = testFactory.createBookstorePublisher(publisher.Id, bookstore1.Id, true);

        //We need to change the unique store Id number, Name and Email
        // before inserting another bookstore
        Bookstore__c bookstore2 = testFactory.createBookstore(true);
        bookstore2.Name = 'bookstore2';
        bookstore2.Email__c = 'bookstore2@gmail.com';
        bookstore2.Store_Identification_Code__c = '85758498';

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher2 = testFactory.createBookstorePublisher(publisher.Id, bookstore2.Id, true);

        //We need to change the unique store Id number, Name and Email
        // before inserting another bookstore
        Bookstore__c bookstore3 = testFactory.createBookstore(true);
        bookstore3.Name = 'bookstore3';
        bookstore3.Email__c = 'bookstore3@gmail.com';
        bookstore3.Store_Identification_Code__c = '04793211';

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher3 = testFactory.createBookstorePublisher(publisher.Id, bookstore3.Id, true);

        //create and insert Bookstore_Book__c junction objects
        Bookstore_Book__c bookstoreBook1 = testFactory.createBookstoreBook(book.Id, bookstore1.Id, true);
        Bookstore_Book__c bookstoreBook2 = testFactory.createBookstoreBook(book.Id, bookstore2.Id, true);
        Bookstore_Book__c bookstoreBook3 = testFactory.createBookstoreBook(book.Id, bookstore3.Id, true);

        //create mock
        Mocker bookstoreSelectorMock = new Mocker(BookstoreSelector.class)
            .setBehavior('getListByIds', new List<Bookstore__c>{bookstore1, bookstore2, bookstore3});
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
        Assert.areEqual(3, bookstores.size());
        Assert.areEqual(bookstore1.Id, bookstores[0].Id);
        Assert.areEqual(bookstore2.Id, bookstores[1].Id);
        Assert.areEqual(bookstore3.Id, bookstores[2].Id);
    }

}