/*
 * This class tests book controller methods
 */
@isTest
public with sharing class BookControllerIntegrationTest {
    @isTest
    public static void getBooksNotInBookstore_willReturnOneBook_IfNoBookstoreBooksRecordsAreCreated() {
        //disable triger unrelated to test
        BookTriggerHandler.triggerDisabled=true;

        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Bookstore__c bookstoreForTest = testFactory.createBookstore(false);
        insert bookstoreForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;
        
        // execute
        Test.startTest();
        List<Book__c> booksNotInBookstore = BookController.getBooksNotInBookstore(bookstoreForTest.Id, 5);
        Test.stopTest();
        
        // assert
        Assert.areEqual(1, booksNotInBookstore.size());
    }

    @isTest
    public static void confirmDigitalBookPurchase_willSendMail_ifPurchaseIsInserted() {
        //disable triger unrelated to test
        BookPurchaseTriggerHandler.triggerDisabled = true;
        BookTriggerHandler.triggerDisabled = true;
        
        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(false);
        insert publisherForTest;
        Author__c authorForTest = testFactory.createAuthor(false);
        insert authorForTest;
        Book__c bookForTest = testFactory.createDigitalBook(publisherForTest.Id, authorForTest.Id, false);
        insert bookForTest;

        //Execute
        Test.startTest();
        BookController.confirmDigitalBookPurchase('testaddress@gmail.com', 'testBook', 'testPrice', bookForTest.Id);
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
 
        // assert
        Assert.areEqual(1, invocations);
    }

    @isTest
    public static void getBooksFromSearchDTO_willReturnOneBook_IfOneMatchFound() {
        //disable triggers unrelated to test
        BookTriggerHandler.triggerDisabled=true;
        BookstoreBookTriggerHandler.triggerDisabled=true;

        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisher = testFactory.createPublisher(true, false);
        Bookstore__c bookstore = testFactory.createBookstore(true, false);
        Author__c author = testFactory.createAuthor(true, false);
        Book__c book = testFactory.createBook(publisher.Id, author.Id, true, false);
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, true, false);
        Book_Review__c bookReview;
        //Unlock book record
        Approval.UnlockResult ur = Approval.unlock(book, false);
        User user = testFactory.createLibraryUser();

        system.runAs(user) {
            bookReview = testFactory.createBookReview(book.Id, true, false);
        }
        BookSearchDTO searchDTO = testFactory.createBookSearchDTO(author.Id, publisher.Id, bookstore.Id);
        searchDTO.ISBN=book.ISBN__c;
        
        // execute
        Test.startTest();
        List<Book__c> searchedBooks = BookController.getBooksFromSearchDTO(searchDTO, 5, 0).books;
        Test.stopTest();
        
        // assert
        Assert.areEqual(1, searchedBooks.size());
    }

    @isTest
    public static void getBooksFromSearchDTO_willReturnEmptyList_IfNoMatchesFound() {
        //disable triggers unrelated to test
        BookTriggerHandler.triggerDisabled=true;
        BookstoreBookTriggerHandler.triggerDisabled=true;

        // create data
        TestFactory testFactory = new TestFactory();
        Publisher__c publisher = testFactory.createPublisher(true, false);
        Bookstore__c bookstore = testFactory.createBookstore(true, false);
        Author__c author = testFactory.createAuthor(true, false);
        Book__c book = testFactory.createBook(publisher.Id, author.Id, true, false);
        Bookstore_Book__c bookstoreBook = testFactory.createBookstoreBook(book.Id, bookstore.Id, true, false);
        BookSearchDTO searchDTO = testFactory.createBookSearchDTO(author.Id, publisher.Id, bookstore.Id);
        searchDTO.name='changed';
        
        // execute
        Test.startTest();
        List<Book__c> searchedBooks = BookController.getBooksFromSearchDTO(searchDTO, 5, 0).books;
        Test.stopTest();
        
        // assert
        Assert.areEqual(0, searchedBooks.size());
    }
}