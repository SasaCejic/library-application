/*
 * This class is used for deleting Book_Publisher record
 */
public with sharing class DeleteBookPublisherRecordService implements CustomObject{
    private Database.DeleteResult response;

    //Getter
    public Database.DeleteResult getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(Database.DeleteResult deletionResult) {
        this.response = deletionResult;
    }
    
    /**
     * * @param bookstorePublisherId - Id of the bookstorePublisher for delete
     */
    public void deleteBookstorePublisher(Id bookstorePublisherId) { 
        Database.DeleteResult deleteResult = Database.delete(bookstorePublisherId, false);
        this.setResponse(deleteResult);
    }
}
