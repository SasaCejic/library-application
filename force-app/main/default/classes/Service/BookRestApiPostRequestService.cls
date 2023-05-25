/**
 * Class used for handling bussiness logic for performing insertion on POST method of BookRESTAPI
 * @see BookRESTAPI
 */
public with sharing class BookRestApiPostRequestService implements CustomObject {
    // Http request
    RestRequest req = RestContext.request;
    // Http response
    RestResponse res = RestContext.response;

    /**
     * Method will perform validation of request data and then insert it, Will respond with appropriate HTTP response
     */
    public void insertBooks() {
        // List that holds non duplicate records
        List<Book__c> nonDuplicateRecords;
        // List that holds duplicate all duplicate records
        List<Book__c> duplicateRecords;
        // List that hold duplicate records from database
        List<Book__c> duplicatesFromDatabase;

        // Cast the JSON body into a map
        ConvertBookRestApiJsonDataService convertJsonService = (ConvertBookRestApiJsonDataService) new ObjectFactory()
            .createObject(ConvertBookRestApiJsonDataService.class);
        BookRestApiRequestDTO bookRestApiRequestDTO = convertJsonService.convert(req.requestBody.toString());
        // Set book list and insert option
        List<Book__c> bookList = bookRestApiRequestDTO.bookList;
        Integer insertOption = bookRestApiRequestDTO.insertOption;
        // Check if client provided data for insertion
        if (bookList == null || bookList.isEmpty()) {
            setHttpResponse(400, 'Please provide records for insertion.', 'Insertion failed', null, 0, 0);
            return;
        }

        // Check if client provided correct insert option
        if (insertOption != 1 && insertOption != 2) {
            setHttpResponse(400, 'Invalid insert option, Please choose from values 1 and 2.', 'Insertion failed', null, 0, bookList.size());
            return;
        }

        // If book size is larger than 12000 abort the operation and repsond with appropriate message
        if (bookList.size() > 12000) {
            setHttpResponse(413, 'You can insert a maximum of 12000 books at once.', 'Insertion failed', null, 0, bookList.size());
            return;
        }

        // Filter the duplicate and non duplicate books
        GetDuplicateBooksService duplicateBooksService = (GetDuplicateBooksService) new ObjectFactory()
            .createObject(GetDuplicateBooksService.class);
        Map<String, List<Book__c>> duplicates = duplicateBooksService.getDuplicates(bookList);

        // fetch the lists from the map
        duplicateRecords = duplicates.get('duplicateRecords');
        nonDuplicateRecords = duplicates.get('nonDuplicateRecords');
        duplicatesFromDatabase = duplicates.get('duplicatesFromDatabase');

        // Service for inserting list of books
        InsertBookRecordService insertService = (InsertBookRecordService) new ObjectFactory()
            .createObject(InsertBookRecordService.class);

        /**
         * If insertion option is 2 and there are any duplicate records, insertion should be aborted
         * If insertion option is 1 and there are any duplicate records, we should insert only non duplicate records
         */
        if (insertOption == 2 && !duplicateRecords.isEmpty()) {
            // Form response
            setHttpResponse(409, 'Operation was aborted and no records were saved because of the duplicate records', 'Insertion failed', 
                duplicateRecords, 0, bookList.size() - duplicatesFromDatabase.size());
        } else if (insertOption == 1 && !duplicateRecords.isEmpty()) {
            // Cover insertion in case it fails because of some validation rules, triggers etc...
            try {
                insertService.insertBooks(nonDuplicateRecords);
                // if non duplicate records insertion was successfull, return insertion details about duplicate records
                setHttpResponse(409, 'Insertion partially failed, non duplicate records were inserted, duplicate records were not.',
                    'Insertion failed', duplicateRecords, nonDuplicateRecords.size(), duplicateRecords.size() - duplicatesFromDatabase.size());
            } catch (Exception e) {
                // Form response
                setHttpResponse(500, e.getMessage(), 'Insertion failed', duplicateRecords, 0, bookList.size() - duplicatesFromDatabase.size());
            }
        } else {
            // Cover insertion in case it fails because of some validation rules, triggers etc...
            try {
                // Insert the book
                insertService.insertBooks(nonDuplicateRecords);
                setHttpResponse(200, 'Insertion was successfull', '', duplicateRecords, nonDuplicateRecords.size(), 0);
            } catch (Exception e) {
                // Form response
                setHttpResponse(500, e.getMessage(), 'Insertion failed', duplicateRecords, 0, bookList.size() - duplicatesFromDatabase.size());
            }
        }
    }

    /**
     * Setter for Http response for BookRestAPI
     * @param statusCode - Status code of http response
     * @param message - Message for http response
     * @param  error - Error for the http response
     * @param duplicateRecords - records that are duplicate in database and request
     * @param successfullRecords - number of successfull records
     * @param failedRecords - number of failed records
     */
    private void setHttpResponse(Integer statusCode, String message, String error, List<Book__c> duplicateRecords, Integer successfullRecords, Integer failedRecords) {
        // Create the response body as a map that will later be converted to a string
        Map<String, Object> responseBody = new Map<String, Object>();
        // set response header
        res.addHeader('Content-Type', 'application/json');
        res.statusCode = statusCode;
        responseBody.put('message', message);
        responseBody.put('error', error);
        responseBody.put('duplicateRecords', duplicateRecords);
        responseBody.put('numberOfSuccessfullRecords', successfullRecords);
        responseBody.put('numberOfFailedRecords', failedRecords);
        res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
    }
}