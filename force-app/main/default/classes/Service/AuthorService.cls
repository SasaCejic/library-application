/**
 * Author service class used to hold business logic for the
 * AuthorController
 * 
 * @see AuthorController.cls
 * @see BookstoreBookSelector.cls
 * @see BookstoreSelector.cls
 */
public with sharing class AuthorService implements CustomObject{

    /**
     * Call BookstoreBookSelector to get all Bookstore_Book__c
     * records with certain author's books, transform the 
     * AggregateResult to a list of bookstore ids and then call the
     * BookstoreSelector to get all Bookstore__c records
     * that match the passed ids
     * 
     * @param authorId certain author id
     * 
     * @return list of Bookstore__c object records
     */
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