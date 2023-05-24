/**
 * Class used for handling bussiness logic for performing insertion on POST method of BookRESTAPI
 * @see BookRESTAPI
 */
public with sharing class BookRestApiPostRequestService implements CustomObject {
    /**
     * @param req - System.RestContext.request of the rest api
     * @param res - System.RestContext.response of the rest api
     */
    public void insertBooks(RestRequest req, RestResponse res) {
        // Create the response body as a map that will later be converted to a string
        Map<String, Object> responseBody = new Map<String, Object>();
        // Set used to hold book ISBNs so we can find duplicates by ISBN__c
        Set<String> bookISBNs = new Set<String>();
        // List that holds non duplicate records
        List<Book__c> nonDuplicateRecords = new List<Book__c>();
        // List that holds duplicate records
        List<Book__c> duplicateRecords = new List<Book__c>();

        // Cast the JSON body into a map
        ConvertBookRestApiJsonDataService convertJsonService = (ConvertBookRestApiJsonDataService) new ObjectFactory()
            .createObject(ConvertBookRestApiJsonDataService.class);
        BookRestApiRequestDTO bookRestApiRequestDTO = convertJsonService.convert(req.requestBody.toString());
        // Set book list and insert option
        List<Book__c> bookList = bookRestApiRequestDTO.bookList;
        Integer insertOption = bookRestApiRequestDTO.insertOption;

        res.addHeader('Content-Type', 'application/json');
        
        // Check if client provided data for insertion
        if (bookList.size() == 0) {
            res.statusCode = 400;
            responseBody.put('message', 'Please provide records for insertion.');
            responseBody.put('error', 'Insertion failed');
            res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
            return;
        }
        
        // Check if client provided correct insert option
        if (insertOption != 1 && insertOption != 2) {
            res.statusCode = 400;
            responseBody.put('message', 'Invalid insert option, Please choose from values 1 and 2.');
            responseBody.put('error', 'Insertion failed');
            res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
            return;
        }

        // If book size is larger than 12000 abort the operation and repsond with appropriate message
        if(bookList.size() > 12000) {
            res.statusCode = 400;
            responseBody.put('message', 'You can insert a maximum of 12000 books at once.');
            responseBody.put('error', 'Insertion failed');
            responseBody.put('numberOfSuccessfullRecords', 0);
            responseBody.put('numberOfFailedRecords', bookList.size());
            res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
            return;
        }

        // loop through books and check if there are duplicates
        for (Book__c book : bookList) {
            if (!bookISBNs.contains(book.ISBN__c)) {
                nonDuplicateRecords.add(book);
                bookISBNs.add(book.ISBN__c);
                continue;
            }
            duplicateRecords.add(book);
        }

        // Service for inserting list of books
        InsertBookRecordService insertService = (InsertBookRecordService) new ObjectFactory()
            .createObject(InsertBookRecordService.class);

        /**
         * If insertion option is 2 and there are any duplicate records, insertion should be aborted
         * If insertion option is 1 and therea are any duplicate records, we should insert only non duplicate records
         */
        if (insertOption == 2 && duplicateRecords.size() > 0) {
            res.statusCode = 409;
            responseBody.put('message', 'Operation was aborted and no records were saved because of the duplicate records');
            responseBody.put('error', 'Insertion failed');
            responseBody.put('numberOfSuccessfullRecords', 0);
            responseBody.put('numberOfFailedRecords', bookList.size());
            res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
        } else if (insertOption == 1 && duplicateRecords.size() > 0) {
            insertService.insertBooks(nonDuplicateRecords);
            List<Database.SaveResult> insertResults = insertService.getResponse();

            // Check if insert of any of the books failed (some validation rules etc...)
            for (Database.SaveResult result : insertResults) {
                if (!result.isSuccess()) {
                    res.statusCode = 400;
                    responseBody.put('message', result.getErrors()[0].getMessage());
                    responseBody.put('error', 'Insertion failed');
                    res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
                    return;
                }
            }
            
            // if non duplicate records insertion was successfull, return insertion details about duplicate records
            res.statusCode = 409;
            responseBody.put('message', 'Insertion partially failed, non duplicate records were inserted, duplicate records were not.');
            responseBody.put('Error', 'Insertion fail');
            responseBody.put('duplicateRecords', duplicateRecords);
            responseBody.put('numberOfSuccessfullRecords', nonDuplicateRecords.size());
            responseBody.put('numberOfFailedRecords', duplicateRecords.size());
            res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
        } else {
            insertService.insertBooks(nonDuplicateRecords);
            List<Database.SaveResult> insertResults = insertService.getResponse();

            // Check if insert of any of the books failed insert (some validation rules etc...)
            for (Database.SaveResult result : insertResults) {
                if (!result.isSuccess()) {
                    res.statusCode = 400;
                    responseBody.put('message', result.getErrors()[0].getMessage());
                    responseBody.put('error', 'Insertion failed');
                    res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
                    return;
                }
            }
            res.statusCode = 200;
            responseBody.put('message', 'Insertion was successfull');
            responseBody.put('numberOfSuccessfullRecords', nonDuplicateRecords.size());
            responseBody.put('numberOfFailedRecords', 0);
            res.responseBody = Blob.valueOf(JSON.serialize(responseBody));
        }
    }
}