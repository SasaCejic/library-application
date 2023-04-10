public with sharing class BookstoreService implements CustomObject{
    public List<Bookstore__c> getStoresWithAuthorsBooks(){
        BookstoreSelector selector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);

        return selector.getStoresWithAuthorsBooks();
    }
}