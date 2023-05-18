/*
 * This class is used for returning Pagereference for BookstorePublisherControllerExtension
 */
public with sharing class GetPageReferenceForBookstorePublisher implements CustomObject{
    private Pagereference response;

    //Getter
    public Pagereference getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(Pagereference pageReference) {
        this.response = pageReference;
    }
    
    /**
     * @param isCanceled - Boolean representing if the cancel button was clicke
     * @param deleteStatus - Boolean representing if the deletion result was successfull or not
     * @param bookstorePublisherId - Id of Bookstore_Publisher__c record being deleted
     */
    public void getPageReference(Boolean isCanceled, Boolean deleteStatus, Id bookstorePublisherId) { 
        if (isCanceled || deleteStatus) {
            // Get the Bookstore_Publisher__c record being deleted
            BookstorePublisherSelector selector = (BookstorePublisherSelector) new ObjectFactory()
                .createObject(BookstorePublisherSelector.class);
            Bookstore_Publisher__c bookstorePublisherForDelete = selector.getRecordById(bookstorePublisherId);
            
            // Set the response that redirects to the bookstore detil view page of the record being deleted
            this.setResponse(new PageReference('/' + bookstorePublisherForDelete.Bookstore__c));
            return;
        }
        this.setResponse(null);
    }
}
