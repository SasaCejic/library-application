/*
 * This class retrieves all the Publisher records not in the bookstore provided by bookstoreID
 */
public with sharing class GetPublishersNotWithBookstoreService implements CustomObject{
    private List<Publisher__c> response;

    //Getter
    public List<Publisher__c> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Publisher__c> publisherList) {
        this.response = publisherList;
    }

    /*
     * @param bookstoreId - Id of the bookstore 
     */
    public void getPublishers(Id bookstoreId) {
        //Set of book ids that are already in bookstore
        Set<Id> publishersWorkingWithBookstoreIds = new Set<Id>();
        BookstorePublisherSelector bookstorePublisherSelector = (BookstorePublisherSelector) new ObjectFactory()
            .createObject(BookstorePublisherSelector.class);
            
        //Get all bookstoreBooks assigned to Bookstore by bookstore Id
        List<Bookstore_Publisher__c> bookstorePublishersInBookstore = bookstorePublisherSelector.getListByBookstoreId(bookstoreId);

        //Loop through all the bookstoreBooks in bookstore and add Book ids to the set
        for(Bookstore_Publisher__c bookstorePublisher:bookstorePublishersInBookstore) {
            publishersWorkingWithBookstoreIds.add(bookstorePublisher.Publisher__c);
        }
        
        //Get all the books that are not in the bookstore
        PublisherSelector publisherSelector = (PublisherSelector) new ObjectFactory()
            .createObject(PublisherSelector.class);
        List<Publisher__c> allPublishers = publisherSelector.getListNotInIds(publishersWorkingWithBookstoreIds);
        this.setResponse(allPublishers);
    }
}