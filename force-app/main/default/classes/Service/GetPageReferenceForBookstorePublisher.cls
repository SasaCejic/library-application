/*
 * This class is used for returning Pagereference for BookstorePublisherController
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
     * @param isViewAllClicked - Boolean representing if View all button was clicked on VF page
     * @param deleteStatus - Boolean representing if the deletion result was successfull or not
     * @param bookstorePublisherForDelete - Bookstore_Publisher__c record being deleted
     */
    public void getPageReference(Boolean isCanceled, Boolean isViewAllClicked, Boolean deleteStatus, Bookstore_Publisher__c bookstorePublisherForDelete) { 
        if (isCanceled || !deleteStatus) {
            // Set the response that redirects to the bookstore detil view page of the record being deleted
            this.setResponse(new PageReference('/' + bookstorePublisherForDelete.Bookstore__c));
        } else if (isViewAllClicked) {
            // Set the response that redirects to the page where user can see all Bookstore_Book__c records that caused error
            this.setResponse(new PageReference('/lightning/n/Books_preventing_publisher_removal?c__recordId=' + bookstorePublisherForDelete.Id));       
        } else {
            // Set the response that will stay at the same page
            this.setResponse(null);
        }
    }
}
