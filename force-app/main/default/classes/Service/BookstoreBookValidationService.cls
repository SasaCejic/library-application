/*
* Validates if the Book that is being added to the bookstore(Via creating Bookstore_Book__c object) has the same publisher
* as the bookstore that it is being added too
*/
public with sharing class BookstoreBookValidationService implements CustomObject {
    /*
    * @param newBookstoreBooks - Books added to the bookstore
    */
    public void validatePublisher(List<Bookstore_Book__c> newBookstoreBooks) {
        //Set of book ids corresponding to added bookstoreBooks
        Set<Id> addedBookIds = new Set<Id>();
        //List that holds pairs of publisher and bookstore Ids corresponding to the Bookstore_Book__c object
        List<List<Id>> publisherAndBookstoreIds = new List<List<Id>>();
        //Loop through all new records and put all book ids into a set
        for(Bookstore_Book__c bookstoreBook : newBookstoreBooks) {
            addedBookIds.add(bookstoreBook.Book__c);
        }
        //Create book selector object and get all books that were added
        BookSelector bookSelector = (BookSelector) new ObjectFactory().createObject(BookSelector.class);
        Map<Id, Book__c> correspondingBooks = bookSelector.getBooksBySetOfIds(addedBookIds);
        //Create pairs of publishers and bookstores
        for(Bookstore_Book__c bookstoreBook: newBookstoreBooks) {
            List<Id> currentList = new List<Id>();
            currentList.add(correspondingBooks.get(bookstoreBook.Book__c).Publisher__c);
            currentList.add(bookstoreBook.Bookstore__c);
            publisherAndBookstoreIds.add(currentList);
        }
        //Get all Bookstore_Publisher__c object that correspond to the list of pairs
        BookstorePublisherSelector bkstorePubSelector = (BookstorePublisherSelector) new ObjectFactory()
        .createObject(BookstorePublisherSelector.class);
        List<Bookstore_Publisher__c> bookstorePublishers = bkstorePubSelector
        .getBookstorePublishersWithPublisherAndBookstoreId(publisherAndBookstoreIds);
        //Check which Bookstore_Book__c objects are valid and for the rest add errors.
        for(Bookstore_Book__c bookstoreBook: newBookstoreBooks) {
            Boolean isValid = false;
            for(Bookstore_Publisher__c bkstorePub : bookstorePublishers) {
                Id publisherId = correspondingBooks.get(bookstoreBook.Book__c).Publisher__c;
                if(bookstoreBook.Bookstore__c == bkstorePub.Bookstore__c && bkstorePub.Publisher__c == publisherId ) {
                    isValid = true;
                    break;
                }   
            }
            if(!isValid) {
                bookstoreBook.addError('Book and bookstore must work with the same publisher!');
            }   
        }
    }
}