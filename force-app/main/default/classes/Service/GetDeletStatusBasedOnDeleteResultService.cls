/**
 * Class used for BookstorePublisherController
 * Response will return true if delete is successfull and vice ers
 */
public with sharing class GetDeletStatusBasedOnDeleteResultService implements CustomObject {
    private Boolean response;

    //Getter
    public Boolean getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(Boolean deleteStatus) {
        this.response = deleteStatus;
    }

    /**
     * @param deleteResult - result of deletion operation
     */
    public void getStatus(Database.DeleteResult deleteResult) {
        if (deleteResult == null) {
            this.setResponse(false);
            return;
        }
        this.setResponse(!deleteResult.isSuccess());
    }
}