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
        Author__c author = testFactory.createAuthor(true, false);

        // create and insert Publisher__c object
        Publisher__c publisher = testFactory.createPublisher(true, false);

        //create and insert Author_Publisher__c object
        Author_Publisher__c authorPublisher = testFactory.createAuthorPublisher(author.Id, publisher.Id, true, false);

        //create and insert Book__c object
        Book__c book = testFactory.createBook(publisher.Id, author.Id, true, false);

        //create and insert Bookstore__c object
        Bookstore__c bookstore = testFactory.createBookstore(true, false);

        //create Bookstore_Publisher__c junction object
        Bookstore_Publisher__c bookstorePublisher = testFactory.createBookstorePublisher(publisher.Id, bookstore.Id, true, false);

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