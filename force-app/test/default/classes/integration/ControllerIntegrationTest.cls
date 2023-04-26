/**
 * This class performs integration tests on controller methods
 * 
 * @see AuthorController.cls
 */
@isTest
public with sharing class ControllerIntegrationTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillReturnNull_IfNullPassed() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        // execute
        Test.startTest();
        List<Bookstore__c> bookstores = AuthorController.getBookstoresWithAuthorsBooks(null);
        Test.stopTest();

        // assert
        Assert.areEqual(null, bookstores);
    }
    
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillReturnEmptyList_IfNoBookstoresAreFound() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        //create and insert Author__c object
        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('name', 'Test Author');
        authorDetails.put('firstName', 'Test');
        authorDetails.put('lastName', 'Author');
        Author__c author = testFactory.createAuthor(authorDetails, true, false);

        // execute
        Test.startTest();
        List<Bookstore__c> bookstores = AuthorController.getBookstoresWithAuthorsBooks(author.Id);
        Test.stopTest();

        // assert
        Assert.areEqual(0, bookstores.size());
    }

    @IsTest
    static void getBookstoresWithAuthorsBooks_WillReturnBookstoresWithAuthorsBooks_IfAtLeastOneIsFound() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        //create and insert Author__c object
        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('name', 'Test Author');
        authorDetails.put('firstName', 'Test');
        authorDetails.put('lastName', 'Author');
        Author__c author = testFactory.createAuthor(authorDetails, true, false);

        // create and insert Publisher__c object
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1234567');
        Publisher__c publisher = testFactory.createPublisher(publisherDetails, true, false);

        //create and insert Book__c object
        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'description');
        bookDetails.put('ISBN', '1234567');
        bookDetails.put('language', 'English');
        bookDetails.put('categories', 'Fantasy');
        Book__c book = testFactory.createBook(author.Id, publisher.Id, bookDetails, true, false);

        //create and insert Bookstore__c object
        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'bookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1234567');
        Bookstore__c bookstore = testFactory.createBookstore(bookstoreDetails, true, false);

        //create and insert Bookstore_Book__c junction object
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, true, false);

        // execute
        Test.startTest();
        List<Bookstore__c> bookstores = AuthorController.getBookstoresWithAuthorsBooks(author.Id);
        Test.stopTest();

        // assert
        Assert.areEqual(1, bookstores.size());
        Assert.areEqual(bookstore.Id, bookstores[0].Id);
    }

    @IsTest
    static void getBookstoresWithAuthorsBooks_WillReturnThreeBookstoresWithAuthorsBooks_IfThereAreThreeBookstoresWithAuthorsBooks() {
        // create testFactory
        TestFactory testFactory = new TestFactory();

        //create and insert Author__c object
        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('name', 'Test Author');
        authorDetails.put('firstName', 'Test');
        authorDetails.put('lastName', 'Author');
        Author__c author = testFactory.createAuthor(authorDetails, true, false);

        // create and insert Publisher__c object
        Map<String, String> publisherDetails = new Map<String, String>();
        publisherDetails.put('name', 'publisher');
        publisherDetails.put('email', 'publisher@gmail.com');
        publisherDetails.put('phone', '1234567');
        Publisher__c publisher = testFactory.createPublisher(publisherDetails, true, false);

        //create and insert Book__c object
        Map<String, String> bookDetails = new Map<String, String>();
        bookDetails.put('name', 'book');
        bookDetails.put('description', 'description');
        bookDetails.put('ISBN', '1234567');
        bookDetails.put('language', 'English');
        bookDetails.put('categories', 'Fantasy');
        Book__c book = testFactory.createBook(author.Id, publisher.Id, bookDetails, true, false);

        //create and insert Bookstore__c objects
        Map<String, String> bookstore1Details = new Map<String, String>();
        bookstore1Details.put('name', 'bookstore1');
        bookstore1Details.put('email', 'bookstore1@gmail.com');
        bookstore1Details.put('storeId', '1234567');
        Bookstore__c bookstore1 = testFactory.createBookstore(bookstore1Details, true, false);

        Map<String, String> bookstore2Details = new Map<String, String>();
        bookstore2Details.put('name', 'bookstore2');
        bookstore2Details.put('email', 'bookstore2@gmail.com');
        bookstore2Details.put('storeId', '4748463');
        Bookstore__c bookstore2 = testFactory.createBookstore(bookstore2Details, true, false);

        Map<String, String> bookstore3Details = new Map<String, String>();
        bookstore3Details.put('name', 'bookstore3');
        bookstore3Details.put('email', 'bookstore3@gmail.com');
        bookstore3Details.put('storeId', '90484762');
        Bookstore__c bookstore3 = testFactory.createBookstore(bookstore3Details, true, false);

        //create and insert Bookstore_Book__c junction objects
        Bookstore_Book__c bookstoreBook1 = testFactory.createBookstoreBook(book.Id, bookstore1.Id, true, false);
        Bookstore_Book__c bookstoreBook2 = testFactory.createBookstoreBook(book.Id, bookstore2.Id, true, false);
        Bookstore_Book__c bookstoreBook3 = testFactory.createBookstoreBook(book.Id, bookstore3.Id, true, false);

        // execute
        Test.startTest();
        List<Bookstore__c> bookstores = AuthorController.getBookstoresWithAuthorsBooks(author.Id);
        Test.stopTest();

        // assert
        Assert.areEqual(3, bookstores.size());
        Assert.areEqual(bookstore1.Id, bookstores[0].Id);
        Assert.areEqual(bookstore2.Id, bookstores[1].Id);
        Assert.areEqual(bookstore3.Id, bookstores[2].Id);
    }
}