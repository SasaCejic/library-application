public with sharing class AuthorService implements CustomObject{
    public List<Bookstore__c> getBookstoresWithAuthorsBooks(Id authorId){
        BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
        
        AggregateResult[] bookstoreBooks = bookstoreBookSelector.getBookstoreBooksWithAuthorsBooks(authorId);
        List<Id> bookstoreIds = new List<Id>();
        for(AggregateResult ar : bookstoreBooks){
            bookstoreIds.add((Id)ar.get('Bookstore__c'));
        }

        BookstoreSelector bookstoreSelector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);

        return bookstoreSelector.getBookstoresWithAuthorsBooks(bookstoreIds);
    }
}