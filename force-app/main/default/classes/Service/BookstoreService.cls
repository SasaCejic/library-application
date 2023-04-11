public with sharing class BookstoreService implements CustomObject{
    public List<Bookstore__c> getBookstoresWithAuthorsBooks(Id authorId){
        BookstoreSelector selector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);
        
        List<Bookstore_Book__c> bookstoreBook = BookstoreBookController.getBookstoreBooksWithAuthorsBooks(authorId);
        List<Id> bookstoreIds;
        for(Bookstore_Book__c bsb : bookstoreBook){
            bookstoreIds.add(bsb.Bookstore__c);
        }

        return selector.getBookstoresWithAuthorsBooks(bookstoreIds);
    }
}