/**
 * Class used to extend the standard BookstorePublisher VF page controller
 */
public class BookstorePublisherControllerExtension {
    // standard apex page controller to be extended
    private ApexPages.StandardController standardController;
    // Id of the Bookstore_Publisher__c record being deleted
    public Id recordId { get; set; }
    // Database.DeleteResult representing the result of Bookstore_Publisher__c record deletion
    public Database.DeleteResult deletionResult { get; set; }
    // Boolean indicating if Canceled button was clicked
    public Boolean isCanceled { get; set; }

    /**
     * Constructor that sets recordId and bookstoreId
     * @param controller - Standard controller to be extended
     */
    public BookstorePublisherControllerExtension(ApexPages.StandardController controller) {
        isCanceled = false;
        standardController = controller;
        recordId = controller.getId();
    }

    /**
     * Getter that will return true if delete result is successfull and vice versa
     */
    public Boolean getDeletionStatus() {
        GetDeletStatusBasedOnDeleteResultService service = (GetDeletStatusBasedOnDeleteResultService) new ObjectFactory()
            .createObject(GetDeletStatusBasedOnDeleteResultService.class);
        service.getStatus(deletionResult);
        return false;
    }

    /**
     * Getter that will return all the Bookstore_Book__c records causing the deletion to fail
     */
    public List<Bookstore_Book__c> getBookstoreBooksCausingError() {
        GetBookstoreBooksCausingErrorBasedOnId service = (GetBookstoreBooksCausingErrorBasedOnId) new ObjectFactory()
            .createObject(GetBookstoreBooksCausingErrorBasedOnId.class);
        service.getBookstoreBooks(recordId);
        return service.getResponse();
    }

    /**
     * Delete override. First tries to delete the record, if it fails, displays the table of records that caused it to fail
     */
    public PageReference deleteRecord() {
        DeleteBookPublisherRecordService deleteService = (DeleteBookPublisherRecordService) new ObjectFactory()
            .createObject(DeleteBookPublisherRecordService.class);
        deleteService.deleteBookstorePublisher(this.recordId);
        deletionResult = deleteService.getResponse();
        return getPageReference();
    }

    /**
     * Cancel override functionality that redirects to the bookstore page from where delete button was clicked
     */
    public PageReference cancel() {
       isCanceled = true;
       return getPageReference();
    }

    /**
     * Method that will return corresponding PageReference based on the state of the controller
     */
    private PageReference getPageReference() {
        GetPageReferenceForBookstorePublisher service = (GetPageReferenceForBookstorePublisher) new ObjectFactory()
            .createObject(GetPageReferenceForBookstorePublisher.class);
        service.getPageReference(isCanceled, getDeletionStatus(), recordId);
        return service.getResponse();
    }
}
