public with sharing class BookstoreService implements CustomObject{
    public List<Bookstore__c> getBookstoresWithAuthorsBooks(Id authorId){
        BookstoreSelector selector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);
        
        AggregateResult[] bookstoreBooks = BookstoreBookController.getBookstoreBooksWithAuthorsBooks(authorId);
        List<Id> bookstoreIds = new List<Id>();
        for(AggregateResult ar : bookstoreBooks){
            bookstoreIds.add((Id)ar.get('Bookstore__c'));
        }

        return selector.getBookstoresWithAuthorsBooks(bookstoreIds);
    }
}