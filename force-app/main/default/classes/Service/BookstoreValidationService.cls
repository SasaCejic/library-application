/**
 * Class that contains a method to validate if a User is already a Bookstore manager
 * 
 * @see BookstoreTriggerHandler.cls
 */
public with sharing class BookstoreValidationService implements CustomObject {

    /**
     * Method that checks if some Bookstore already contains certain User's Id
     * when we create new Bookstores
     * 
     * @param newBookstores list of new Bookstore records
     */
    public void validateBookstoreManagerMatch(List<Bookstore__c> newBookstores) {
        //Get all Bookstore__c sObjects for certain Manager
        BookstoreSelector bookstoreSelector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);
        Map<Id, List<Bookstore__c>> newBookstoresByManagers= new Map<Id, List<Bookstore__c>>();
        for (Bookstore__c bookstore : newBookstores) {
            if (bookstore.Manager__c != null) {
                if (newBookstoresByManagers.containsKey((Id) bookstore.Manager__c)) {
                    newBookstoresByManagers.get((Id) bookstore.Manager__c).add(bookstore);
                } else {
                    newBookstoresByManagers.put((Id) bookstore.Manager__c, new List<Bookstore__c> { bookstore });
                }
            }
        }

        if (!newBookstoresByManagers.isEmpty()) {
            List<Bookstore__c> bookstores = bookstoreSelector.getListByManagers(newBookstoresByManagers.keySet());
            /**
            * Iterate through returned Bookstores.
            * Add an error to each new bookstore that has the same Manager
            */
            if (!bookstores.isEmpty()) {
                for (Bookstore__c bookstore:bookstores) {
                    for (Bookstore__c newBookstore : newBookstoresByManagers.get((Id) bookstore.Manager__c)) {
                        newBookstore.addError('User is already a Bookstore Manager!');
                    }
                }
            }
        }
    }

    /**
     * Method that checks if some Bookstore already contains certain User's Id
     * when we update existing bookstores
     * 
     * @param oldBookstores list of old Bookstore records
     * @param newBookstores list of new Bookstore records
     */
    public void validateBookstoreManagerMatch(List<Bookstore__c> oldBookstores, List<Bookstore__c> newBookstores) {
        //Get all Bookstore__c sObjects for certain Manager
        BookstoreSelector bookstoreSelector = (BookstoreSelector) new ObjectFactory().createObject(BookstoreSelector.class);
        List<Bookstore__c> newBookstoresWithNewManager = new List<Bookstore__c>();
        for (Bookstore__c newBookstore : newBookstores) {
            for (Bookstore__c oldBookstore : oldBookstores) {
                if (oldBookstore.Id == newBookstore.Id && oldBookstore.Manager__c != newBookstore.Manager__c) {
                    newBookstoresWithNewManager.add(newBookstore);
                }
            }
        }

        if (!newBookstoresWithNewManager.isEmpty()) {
            Map<Id, List<Bookstore__c>> newBookstoresByManagers= new Map<Id, List<Bookstore__c>>();
            for (Bookstore__c bookstore : newBookstoresWithNewManager) {
                if (bookstore.Manager__c != null) {
                    if (newBookstoresByManagers.containsKey((Id) bookstore.Manager__c)) {
                        newBookstoresByManagers.get((Id) bookstore.Manager__c).add(bookstore);
                    } else {
                        newBookstoresByManagers.put((Id) bookstore.Manager__c, new List<Bookstore__c> { bookstore });
                    }
                }
            }

            if (!newBookstoresByManagers.isEmpty()) {
                List<Bookstore__c> bookstores = bookstoreSelector.getListByManagers(newBookstoresByManagers.keySet());
                /**
                * Iterate through returned Bookstores.
                * Add an error to each new bookstore that has the same Manager
                */
                if (!bookstores.isEmpty()) {
                    for (Bookstore__c bookstore:bookstores) {
                        for (Bookstore__c newBookstore : newBookstoresByManagers.get((Id) bookstore.Manager__c)) {
                            newBookstore.addError('User is already a Bookstore Manager!');
                        }
                    }
                }
            }
        }
    }
}