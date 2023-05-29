/*
 * This class is used for deleting Author_Publisher record
 */
public with sharing class DeleteAuthorPublisherRecordService implements CustomObject {
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
     * @param authorPublisherId - Id of the authorPublisher for delete
     */
    public void deleteAuthorPublisher(Id authorPublisherId) { 
        Database.DeleteResult deleteResult = Database.delete(authorPublisherId, false);
        this.setResponse(deleteResult);
    }
}