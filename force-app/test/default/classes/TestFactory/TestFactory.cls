@isTest
public with sharing class TestFactory {
    static Integer s_num = 1;
    /*
    * @param sObjecType- SObjectType of an object which we are creating fake Id for 
    */
    private String getFakeId(Schema.SObjectType sObjecType) {
        String result = String.valueOf(s_num++);
        return sObjecType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }
    /*
    * @param bookId - Id of a book which is a parent in master-detail relationship with Bookstore_Book__c
    * @param bookstoreId - Id of a bookstore which isa a parent in master-detail relationship with Bookstore_Book__c
    * @param forInsert - Boolean value representing if we want to insert the record or not
    */
    public Bookstore_Book__c createBookstoreBook(Id bookId, Id bookstoreId, Boolean forInsert) {
        Bookstore_Book__c newBookstoreBook = new Bookstore_Book__c();
        newBookstoreBook.Book__c = bookId;
        newBookstoreBook.Bookstore__c = bookstoreId;
        if(forInsert) {
            insert newBookstoreBook;
            return newBookstoreBook;
        }
        newBookstoreBook.Id = getFakeId(Bookstore_Book__c.SObjectType);
        return newBookstoreBook;
    }
    /*
    * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
    * @param bookstoreId - Id of a Bookstore__c which is a parent in master-detail relationship
    * @param forInsert - Boolean value representing if we want to insert the record or not
    */
    public Bookstore_Publisher__c createBookstorePublisher(Id publisherId, Id bookstoreId, Boolean forInsert) {
        Bookstore_Publisher__c newBookstorePublisher = new Bookstore_Publisher__c();
        newBookstorePublisher.Publisher__c = publisherId;
        newBookstorePublisher.Bookstore__c = bookstoreId;
        if(forInsert) {
            insert newBookstorePublisher;
            return newBookstorePublisher;
        }
        newBookstorePublisher.Id = getFakeId(Bookstore_Publisher__c.SObjectType);
        return newBookstorePublisher;
    }
    /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    */
    public Bookstore__c createBookstore(Map<String, String> details, Boolean forInsert) {
        Bookstore__c newBookstore = new Bookstore__c();
        newBookstore.Name = details.get('name');
        newBookstore.Email__c = details.get('email');
        newBookstore.Store_Identification_Code__c = details.get('storeId');
        if(forInsert) {
            insert newBookstore;
            return newBookstore;
        }
        newBookstore.Id = getFakeId(Bookstore__c.SObjectType);
        return newBookstore;
    }
    /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    */
    public Publisher__c createPublisher(Map<String, String> details, Boolean forInsert) {
        Publisher__c newPublisher = new Publisher__c();
        newPublisher.Name = details.get('name');
        newPublisher.Email__c = details.get('email');
        newPublisher.Phone__c = details.get('phone');
        if(forInsert) {
            insert newPublisher;
            return newPublisher;
        }
        newPublisher.Id = getFakeId(Publisher__c.SObjectType);
        return newPublisher;
    }
     /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
    */
    public Book__c createBook(Id publisherId, Map<String, String> details,  Boolean forInsert) {
        Book__c currentBook = new Book__c();
        currentBook.Name = details.get('name');
        currentBook.Description__c = details.get('description');
        currentBook.ISBN__c = details.get('ISBN');
        currentBook.Language__c = details.get('language');
        currentBook.Categories__c = details.get('categories');
        currentBook.Publisher__c = publisherId;
        currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);
        if(forInsert) {
            insert currentBook;
            return currentBook;
        }
        currentBook.Id = getFakeId(Book__c.SObjectType);
        return currentBook;
    }
}