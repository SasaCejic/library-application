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
        List<Set<Id>> publisherAndBookstoreIds = new List<Set<Id, Id>>();
        //Loop through all new records and perform validation for them
        for(Bookstore_Book__c bookstoreBook : newBookstoreBooks) {
            addedBookIds.add(bookstoreBook.Book__c);
            /*
            BookSelector bookSelector = (BookSelector) new ObjectFactory().createObject(bookSelector.class);
            //Get publisher Id of the book that is being added to the bookstore
            Id publisherId = bookSelector.getBookById(bookstoreBook.Book__c)[0].Publisher__c;
            BookstorePublisherSelector bkStorePublisherSelector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
            // Get Publisher that is assigned to both Bookstore and the book
            List<Bookstore_Publisher__c> correspondingBookstorePublishers = bkStorePublisherSelector
            .getBookstorePublisherByPublisherIdAndBookstoreId(publisherId, bookstoreBook.Bookstore__c);
            // If no publisher is found, validation fails, book can't be added to the store
            if (correspondingBookstorePublishers.isEmpty()) {
                bookstoreBook.addError('Book and bookstore must work with the same publisher!');
            }*/
        }
        Map<Id, Book__c> booksWithPublishers = new BookSelector().getBooksBySetOfIds(addedBookIds);
        for(Bookstore_Book__c bookstoreBook: newBookstoreBooks) {
            publisherAndBookstoreIds.put(booksWithPublishers.get(bookstoreBook.Book__c).Publisher__c, bookstoreBook.Bookstore__c);
        }
        // Build the dynamic SOQL query
        String soqlQuery = 'SELECT Id, Publisher__c, Bookstore__c FROM Bookstore_Publisher__c WHERE ';
        for (Set<Id> setId : publisherAndBookstoreIds) {
            soqlQuery += '(Publisher__c = \'' + setId.iterator().next() + '\' AND Bookstore__c = \'' + setId.iterator().next() + '\') OR ';
        }
        soqlQuery = soqlQuery.removeEnd(' OR ');
        List<Bookstore_Publisher__c> bookstorePublishers = Database.query(soqlQuery);
        
    }
}