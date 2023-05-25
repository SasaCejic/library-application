/**
 * This class performs integration tests on controller methods
 * 
 * @see AuthorController.cls
 */
@isTest
public with sharing class ControllerIntegrationTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillReturnBookstoresWithAuthorsBooks_IfAtLeastOneIsFound() {
        // create testFactory
        TestFactory testFactory = new TestFactory();
        //create and insert Author__c object
        Author__c author = testFactory.createAuthor(false);
        insert author;
        // create and insert Publisher__c object
        Publisher__c publisher = testFactory.createPublisher(false);
        insert publisher;
        //create and insert Author_Publisher__c object
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, false);
        insert authorPublisher;
        //create and insert Book__c object
        Book__c book = testFactory.createBook(publisher.Id, author.Id, false);
        insert book;
        //create and insert Bookstore__c object
        Bookstore__c bookstore = testFactory.createBookstore(false);
        insert bookstore;
        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, false);
        insert bookstorePublisher;
        //create and insert Bookstore_Book__c junction object
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, false);
        insert bookstoreBook;

        // execute
        Test.startTest();
        List<Bookstore__c> bookstores = AuthorController.getBookstoresWithAuthorsBooks(author.Id);
        Test.stopTest();

        // assert
        Assert.areEqual(1, bookstores.size());
        Assert.areEqual(bookstore.Id, bookstores[0].Id);
    }
}