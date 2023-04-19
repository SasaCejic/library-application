@isTest
public with sharing class TestFactory {
    /*
    * @param numOfBookstoreBooks - Number of objects we want to create
    * @param bookId - Id of a book which is a parent in master-detail relationship with Bookstore_Book__c
    * @param bookstoreId - Id of a bookstore which isa a parent in master-detail relationship with Bookstore_Book__c
    */
    public List<Bookstore_Book__c> createBookstoreBooks(Integer numOfBookstoreBooks, Id bookId, Id bookstoreId) {
        List<Bookstore_Book__c> bookStoreBooksForTest = new List<Bookstore_Book__c>();
        for(Integer i = 0; i<numOfBookstoreBooks; i++) {
            Bookstore_Book__c newBookstoreBook = new Bookstore_Book__c();
            newBookstoreBook.Book__c = bookId;
            newBookstoreBook.Bookstore__c = bookstoreId;
            bookStoreBooksForTest.add(newBookstoreBook);
        }
        return bookStoreBooksForTest;
    }
    /*
    * @param numOfbkStorePublishers - number of objects to be created
    * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
    * @param bookstoreId - Id of a Bookstore__c which is a parent in master-detail relationship
    */
    public List<Bookstore_Publisher__c> createBookstorePublishers(Integer numOfbkStorePublishers,
    Id publisherId, Id bookstoreId) {
        List<Bookstore_Publisher__c> BookstorePublishersForTest = new List<Bookstore_Publisher__c>();
        for(Integer i = 0; i<numOfbkStorePublishers; i++) {
            Bookstore_Publisher__c currentBkstorePublisher = new Bookstore_Publisher__c();
            currentBkstorePublisher.Publisher__c = publisherId;
            currentBkstorePublisher.Bookstore__c = bookstoreId;
            BookstorePublishersForTest.add(currentBkstorePublisher);
        }
        return BookstorePublishersForTest;
    }
    /*
    * @param numOfBookstores - number of Bookstore__c objects to be inserted
    */
    public List<Bookstore__c> createBookstores(Integer numOfBookstores) {
        List<Bookstore__c> bookstoresForTest = new List<Bookstore__c>();
        for(Integer i = 0;i<numOfBookstores; i++) {
            Bookstore__c currentBookstore = new Bookstore__c();
            currentBookstore.Name = 'Bookstore' + i;
            currentBookstore.Email__c = 'bookstore' + i + '@gmail.com';
            currentBookstore.Store_Identification_Code__c = '12i245' + i;
            bookstoresForTest.add(currentBookstore);
        }
        return bookstoresForTest;
    }
    /*
    * @param numOfPublishers - number of Publisher__c objects to be created
    */
    public List<Publisher__c> createPublishers(Integer numOfPublishers) {
        List<Publisher__c> publishersForTest = new List<Publisher__c>();
        for(Integer i = 0; i<numOfPublishers; i++) {
            Publisher__c currentPublisher = new Publisher__c();
            currentPublisher.Name = 'Publisher' + i;
            currentPublisher.Email__c = 'publisher'+ i + '@gmail.com';
            currentPublisher.Phone__c = '015524' + i;
            publishersForTest.add(currentPublisher);
        }
        return publishersForTest;
    }
     /*
    * @param numOfBooks - number of books to be created
    * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
    */
    public List<Book__c> createBooks(Integer numOfBooks, Id publisherId) {
        List<Book__c> booksForTest = new List<Book__c>();
        for(Integer i = 0; i<numOfBooks; i++) {
            Book__c currentBook = new Book__c();
            currentBook.Name = 'Book' + i;
            currentBook.Description__c = 'Book Description' + i;
            currentBook.ISBN__c = '555333' + i;
            currentBook.Language__c = 'English';
            currentBook.Categories__c = 'Fantasy';
            currentBook.Publisher__c = publisherId;
            currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);
            booksForTest.add(currentBook);
        }
        return booksForTest;
    }
}