/*
* This class tests book controller methods
*/
@isTest
public with sharing class BookControllerIntegrationTest {
    @isTest
    public static void getBooksNotInBookstore_willReturnOneBook_IfNoBookstoreBooksRecordsAreCreated() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(true, false);
        Bookstore__c bookstoreForTest = testFactory.createBookstore(true, false);
        Author__c authorForTest = testFactory.createAuthor(true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, true, false);

        Test.startTest();
        List<Book__c> booksNotInBookstore = BookController.getBooksNotInBookstore(bookstoreForTest.Id);
        Test.stopTest();
        
        Assert.areEqual(1, booksNotInBookstore.size());
    }
}