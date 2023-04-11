public with sharing class BookstoreBookService {
    public List<Bookstore_Book__c> getBookstoreBooksWithAuthorsBooks(Id authorId){
        BookstoreBookSelector selector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);

        return selector.getBookstoreBooksWithAuthorsBooks(authorId);
    }
}