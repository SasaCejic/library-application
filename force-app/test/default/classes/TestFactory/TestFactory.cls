@isTest
public with sharing class TestFactory {
    @TestVisible
    public Map<String, String> publisherDetails = new Map<String, String>{
        'name' => 'publisher',
        'email' => 'publisher@gmail.com',
        'phone' => '124215426'
    };

    @TestVisible
    public Map<String, String> bookstoreDetails = new Map<String, String>{
        'name' => 'bookstore',
        'email' => 'bookstore@gmail.com',
        'storeId' => '21413523'
    };

    @TestVisible
    public Map<String, String> authorDetails = new Map<String, String>{
        'firstName' => 'Author',
        'lastName' => 'Author'
    };

    @TestVisible
    public Map<String, String> bookDetails = new Map<String, String>{
        'name' => 'book',
        'description' => 'bookdesc',
        'ISBN' => '214215425',
        'language' => 'english',
        'categories' => 'fantasy'
    };

    static Integer s_num = 1;

    /*
    * @param sObjecType- SObjectType of an object which we are creating fake Id for 
    */

    public String getFakeId(Schema.SObjectType sObjecType, Boolean simulateInsert) {
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
        newBookstoreBook.Id = this.getFakeId(Bookstore_Book__c.SObjectType, simulateInsert);
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
        newBookstorePublisher.Id = this.getFakeId(Bookstore_Publisher__c.SObjectType, simulateInsert);
        return newBookstorePublisher;
    }

    /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */

    public Bookstore__c createBookstore(Boolean forInsert, Boolean simulateInsert) {
        Bookstore__c newBookstore = new Bookstore__c();
        newBookstore.Name = bookstoreDetails.get('name');
        newBookstore.Email__c = bookstoreDetails.get('email');
        newBookstore.Store_Identification_Code__c = bookstoreDetails.get('storeId');
        if(forInsert) {
            insert newBookstore;
            return newBookstore;
        }
        newBookstore.Id = this.getFakeId(Bookstore__c.SObjectType, simulateInsert);
        return newBookstore;
    }

    /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */

    public Publisher__c createPublisher(Boolean forInsert, Boolean simulateInsert) {
        Publisher__c newPublisher = new Publisher__c();
        newPublisher.Name = publisherDetails.get('name');
        newPublisher.Email__c = publisherDetails.get('email');
        newPublisher.Phone__c = publisherDetails.get('phone');
        if(forInsert) {
            insert newPublisher;
            return newPublisher;
        }
        newPublisher.Id = this.getFakeId(Publisher__c.SObjectType, simulateInsert);
        return newPublisher;
    }

    /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param publisherId - Id of a Publisher_c object which is a parent in master-detail relationship to Book_c
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */

    public Book__c createBook(Id publisherId, Id authorId, Boolean forInsert, Boolean simulateInsert) {
        Book__c currentBook = new Book__c();
        currentBook.Name = bookDetails.get('name');
        currentBook.Description__c = bookDetails.get('description');
        currentBook.ISBN__c = bookDetails.get('ISBN');
        currentBook.Language__c = bookDetails.get('language');
        currentBook.Categories__c = bookDetails.get('categories');
        currentBook.Publisher__c = publisherId;
        currentBook.Author__c = authorId;
        currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);
        if(forInsert) {
            insert currentBook;
            return currentBook;
        }
        currentBook.Id = this.getFakeId(Book__c.SObjectType, simulateInsert);
        return currentBook;
    }

    /*
    *
    */

    public Author__c createAuthor(Boolean forInsert, Boolean simulateInsert) {
        Author__c newAuthor = new Author__c();
        newAuthor.First_Name__c = authorDetails.get('firstName');
        newAuthor.Last_Name__c = authorDetails.get('lastName');
        if(forInsert) {
            insert newAuthor;
            return newAuthor;
        }
        newAuthor.Id = this.getFakeId(Author__c.SObjectType, simulateInsert);
        return newAuthor;
    }
}