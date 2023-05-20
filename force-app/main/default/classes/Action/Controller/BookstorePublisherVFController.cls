/**
 * Class used as Bookstore_Publisher__c controller for both VF and LWC pages
 */
public class BookstorePublisherVFController {
    // Id of the Bookstore_Publisher__c record being deleted
    private Id recordId { get; set; }
    // Bookstore_Publisher__c record for delete
    private Bookstore_Publisher__c bookstorePublisherForDelete { get; set; }
    // Database.DeleteResult representing the result of Bookstore_Publisher__c record deletion
    private transient Database.DeleteResult deletionResult { get; set; }
    // Boolean indicating if Canceled button was clicked
    private Boolean isCanceled { get; set; }
    // Boolean indicating if the viewAllButton was clicked
    private Boolean isViewAllClicked { get; set; }
    // Boolean indicating if the confirm button was clicked was clicked
    public Boolean isConfirmClicked{ get; set; }
    // Boolean indicating if delete failed
    public Boolean didDeleteFail { get; set; }

    /**
     * Constructor that sets recordId and Bookstore_Publisher__c record for deletion
     * @param controller - Standard controller
     */
    public BookstorePublisherVFController(ApexPages.StandardController controller) {
        isCanceled = false;
        isViewAllClicked = false;
        recordId = controller.getId();
        isViewAllClicked = false;
        didDeleteFail = false;
        setBookstorePublihserForDelete();
    }

    /**
     * Setter that will set to true if delete result is successfull and vice versa
     */
    private void settDeletionStatus() {
        GetDeletStatusBasedOnDeleteResultService service = (GetDeletStatusBasedOnDeleteResultService) new ObjectFactory()
            .createObject(GetDeletStatusBasedOnDeleteResultService.class);
        service.getStatus(deletionResult);
        didDeleteFail = service.getResponse();
    }

    /**
     * Method that returns the Bookstore_Publisher__c record based on its id
     */
    private void setBookstorePublihserForDelete() {
        ReturnBookstorePublisherBasedOnIdService service = (ReturnBookstorePublisherBasedOnIdService) new ObjectFactory()
            .createObject(ReturnBookstorePublisherBasedOnIdService.class);
        service.returnBookstorePublisher(recordId);
        bookstorePublisherForDelete = service.getResponse();
    }

    /**
     * Getter that will return first 5 Bookstore_Book__c records causing the deletion to fail
     */
    public List<Bookstore_Book__c> getBookstoreBooksCausingError() {
        GetBookstoreBookOnPublsherDeleteService service = (GetBookstoreBookOnPublsherDeleteService) new ObjectFactory()
            .createObject(GetBookstoreBookOnPublsherDeleteService.class);
        service.getBookstoreBooks(recordId, 5);
        return service.getResponse();
    }

    /**
     * Method that will return corresponding PageReference based on the state of the controller
     */
    public PageReference getPageReference() {
        GetPageReferenceForBookstorePublisher service = (GetPageReferenceForBookstorePublisher) new ObjectFactory()
            .createObject(GetPageReferenceForBookstorePublisher.class);
        service.getPageReference(isCanceled, isViewAllClicked, didDeleteFail, bookstorePublisherForDelete);
        return service.getResponse();
    }

    /**
     * Delete override. First tries to delete the record, if it fails, displays the table of records that caused it to fail
     */
    public void deleteRecord() {
        isConfirmClicked = true;
        DeleteBookPublisherRecordService deleteService = (DeleteBookPublisherRecordService) new ObjectFactory()
            .createObject(DeleteBookPublisherRecordService.class);
        deleteService.deleteBookstorePublisher(this.recordId);
        deletionResult = deleteService.getResponse();
        settDeletionStatus();
    }

    /**
     * Cancel override functionality that redirects to the bookstore page from where delete button was clicked
     */
    public PageReference cancel() {
       isCanceled = true;
       return getPageReference();
    }

    /**
     * Method redirects user to page where they can see all bookstore books causing delete to fail
     */
    public Pagereference viewAll() {
        isViewAllClicked = true;
        return getPageReference();
    }
}