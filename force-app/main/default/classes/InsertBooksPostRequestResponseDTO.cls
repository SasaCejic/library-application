/**
 * Class used as DTO for BookRestApiHttpResponse
 */
public with sharing class InsertBooksPostRequestResponseDTO {
    public Integer statusCode;
    public String message;
    public String error;
    public List<Book__c> duplicateRecords;
    public Integer numberOfSuccessfullRecords;
    public Integer numberOfFailedRecords;
}