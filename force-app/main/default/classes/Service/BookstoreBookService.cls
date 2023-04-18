public with sharing class BookstoreBookService implements CustomObject{
    public AggregateResult[] getBookstoreBooksWithAuthorsBooks(Id authorId){
        BookstoreBookSelector selector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);

        return selector.getBookstoreBooksWithAuthorsBooks(authorId);
    }
}