/**
 * This class performs integration tests on controller methods
 * 
 * @see AuthorController.cls
 */
@isTest
public with sharing class ControllerIntegrationTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_willReturnBookstoresWithAuthorsBooks_ifAtLeastOneIsFound() {
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
        Book__c book = testFactory.createBook(publisher.Id, bookDetails, true, false);
        //make relationship between book and author
        book.Author__c = author.Id;
        update book;

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

}