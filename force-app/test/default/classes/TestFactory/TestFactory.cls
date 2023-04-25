@isTest
public with sharing class TestFactory {
    static Integer s_num = 1;
    /*
    * @param sObjecType- SObjectType of an object which we are creating fake Id for 
    */
    private String getFakeId(Schema.SObjectType sObjecType, Boolean simulateInsert) {
        if(simulateInsert) {
            String result = String.valueOf(s_num++);
            return sObjecType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
        }
        return null;
    }
    /*
    * @param bookId - Id of a book which is a parent in master-detail relationship with Bookstore_Book__c
    * @param bookstoreId - Id of a bookstore which isa a parent in master-detail relationship with Bookstore_Book__c
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Bookstore_Book__c createBookstoreBook(Id bookId, Id bookstoreId, Boolean forInsert, Boolean simulateInsert) {
        Bookstore_Book__c newBookstoreBook = new Bookstore_Book__c();
        newBookstoreBook.Book__c = bookId;
        newBookstoreBook.Bookstore__c = bookstoreId;
        if(forInsert) {
            insert newBookstoreBook;
            return newBookstoreBook;
        }
        newBookstoreBook.Id = getFakeId(Bookstore_Book__c.SObjectType, simulateInsert);
        return newBookstoreBook;
    }
    /*
    * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
    * @param bookstoreId - Id of a Bookstore__c which is a parent in master-detail relationship
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Bookstore_Publisher__c createBookstorePublisher(Id publisherId, Id bookstoreId, Boolean forInsert, Boolean simulateInsert) {
        Bookstore_Publisher__c newBookstorePublisher = new Bookstore_Publisher__c();
        newBookstorePublisher.Publisher__c = publisherId;
        newBookstorePublisher.Bookstore__c = bookstoreId;
        if(forInsert) {
            insert newBookstorePublisher;
            return newBookstorePublisher;
        }
        newBookstorePublisher.Id = getFakeId(Bookstore_Publisher__c.SObjectType, simulateInsert);
        return newBookstorePublisher;
    }
    /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Bookstore__c createBookstore(Map<String, String> details, Boolean forInsert, Boolean simulateInsert) {
        Bookstore__c newBookstore = new Bookstore__c();
        newBookstore.Name = details.get('name');
        newBookstore.Email__c = details.get('email');
        newBookstore.Store_Identification_Code__c = details.get('storeId');
        if(forInsert) {
            insert newBookstore;
            return newBookstore;
        }
        newBookstore.Id = getFakeId(Bookstore__c.SObjectType, simulateInsert);
        return newBookstore;
    }
    /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Publisher__c createPublisher(Map<String, String> details, Boolean forInsert, Boolean simulateInsert) {
        Publisher__c newPublisher = new Publisher__c();
        newPublisher.Name = details.get('name');
        newPublisher.Email__c = details.get('email');
        newPublisher.Phone__c = details.get('phone');
        if(forInsert) {
            insert newPublisher;
            return newPublisher;
        }
        newPublisher.Id = getFakeId(Publisher__c.SObjectType, simulateInsert);
        return newPublisher;
    }
     /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Book__c createBook(Id publisherId, Map<String, String> details,  Boolean forInsert, Boolean simulateInsert) {
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
        currentBook.Id = getFakeId(Book__c.SObjectType, simulateInsert);
        return currentBook;
    }
   /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param bookId - Id of a Book__c object which is a parent in master-detail relationship to Book__c
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Book_Review__c createBookReview(Id bookId, Map<String, String> details, Boolean forInsert, Boolean simulateInsert) {
        Book_Review__c newBookReview = new Book_Review__c();
        newBookReview.Book__c = bookId;
        newBookReview.Name = details.get('name');
        newBookReview.Rating__c = details.get('rating');
        if(forInsert) {
            insert newBookReview;
            return newBookReview;
        }
        newBookReview.Id = getFakeId(Book_Review__c.SObjectType, simulateInsert);
        return newBookReview;
    }
}