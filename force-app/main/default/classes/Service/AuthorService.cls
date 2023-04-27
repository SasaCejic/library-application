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
     * List of Bookstores that will be returned to Controller as a response
     */
    private List<Bookstore__c> response;

    /**
     * Getter method for response property
     * 
     * @return this class's response property value
     */
    public List<Bookstore__c> getResponse(){
        return this.response;
    }

    /**
     * Setter method for response property
     * 
     * @param response List of Bookstores that we want to assign to response field
     */
    public void setResponse(List<Bookstore__c> response){
        this.response = response;
    }

    /**
     * Call BookstoreBookSelector to get all Bookstore_Book__c
     * records with certain author's books, transform the 
     * AggregateResult to a list of bookstore ids and then call the
     * BookstoreSelector to get all Bookstore__c records
     * that match the passed ids
     * 
     * @param authorId certain author id
     * 
     */
    public void getBookstoresWithAuthorsBooks(Id authorId){
        if(authorId == null){
            this.response = null;
        }else{
            BookstoreBookSelector bookstoreBookSelector = (BookstoreBookSelector) new ObjectFactory().createObject(BookstoreBookSelector.class);
        
            AggregateResult[] bookstoreBooks = bookstoreBookSelector.getBookstoreBooksWithAuthorsBooks(authorId);
            Set<Id> bookstoreIds = new Set<Id>();
            for(AggregateResult ar : bookstoreBooks){
                bookstoreIds.add((Id)ar.get('Bookstore__c'));
            }

            BookstoreSelector bookstoreSelector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);

            this.response = bookstoreSelector.getBookstoresWithAuthorsBooks(bookstoreIds);
        }
    }
}