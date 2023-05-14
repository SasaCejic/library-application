/*
 * Validates if the Book that is being added to the bookstore(Via creating Bookstore_Book__c object) has the same publisher 
 * as the bookstore that it is being added too
 */
public with sharing class BookstoreBookValidationService implements CustomObject {
    /*
     * @param newBookstoreBooks - Books added to the bookstore
     */
    public void validatePublisher(List<Bookstore_Book__c> newBookstoreBooks) {
        //Set of book ids corresponding to added bookstoreBooks Ids
        Set<Id> addedBookIds = new Set<Id>();
        
        //Map that holds pairs of publisher and bookstore Ids corresponding to the Bookstore_Book__c object Id
        Map<Id, List<Id>> publisherAndBookstoreIds = new Map<Id, List<Id>>();

        // Set of Ids used to store Bookstore_Book__c Ids that did not pass the validation
        Set<Id> nonValidatedBookstoreBooks = new Set<Id>(); 
        
        //Loop through all new records and put all book ids into a set
        for (Bookstore_Book__c bookstoreBook : newBookstoreBooks) {
            addedBookIds.add(bookstoreBook.Book__c);
        }

        //Create book selector object and get all books that were added
        BookSelector bookSelector = (BookSelector) new ObjectFactory().createObject(BookSelector.class);
        Map<Id, Book__c> correspondingBooks = bookSelector.getMapByIds(addedBookIds);

        for (Bookstore_Book__c bookstoreBook: newBookstoreBooks) {
            List<Id> currentList = new List<Id>();
            currentList.add(correspondingBooks.get(bookstoreBook.Book__c).Publisher__c);
            currentList.add(bookstoreBook.Bookstore__c);
            publisherAndBookstoreIds.put(bookstoreBook.Id, currentList);
        }

        //Get all bookstore_publisher__c objects
        BookstorePublisherSelector bookstorePublisherSelector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
        List<Bookstore_Publisher__c> bookstorePublishers = bookstorePublisherSelector.getList();

        //Find the Bookstore_Publisher__c objects corresponding to pairs of bookstores and publishers 
        for (String key : publisherAndBookstoreIds.keySet()) {
            Boolean isFound =  false;
            List<Id> publisherAndBookstoreIdPair = publisherAndBookstoreIds.get(key);

            for (Bookstore_Publisher__c bookstorePublisher:bookstorePublishers) {
                if (publisherAndBookstoreIdPair[0] == bookstorePublisher.Publisher__c && publisherAndBookstoreIdPair[1] == bookstorePublisher.Bookstore__c) {
                        isFound = true;
                        break;
                }
            }
            
            if (!isFound) {
                nonValidatedBookstoreBooks.add(key);
            }
        }

        //Add error to all the Bookstore_Book__c objects that did not have the corresponding Bookstore_Publisher__c object
        for (Bookstore_Book__c bookstoreBook:newBookstoreBooks) {
            if (nonValidatedBookstoreBooks.contains(bookstoreBook.Id)) {
                bookstoreBook.addError('Book and bookstore must work with the same publisher!');
            }
        }
    }
}