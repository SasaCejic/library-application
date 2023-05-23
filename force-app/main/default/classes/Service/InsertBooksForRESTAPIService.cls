/**
 * Class used for handling bussiness logic for performing insertion on POST method of BookRESTAPI
 */
public with sharing class InsertBooksForRESTAPIService implements CustomObject {
    /**
     * @param req - System.RestContext.request of the rest api
     * @param res - System.RestContext.response of the rest api
     */
    public void insertBooks(RestRequest req, RestResponse res) {
        // Create the response body as a JSON string
        Map<String, Object> responseBody = new Map<String, Object>();

        // Cast the JSON body into a map
        ConvertJSONToBookListService convertJsonService = (ConvertJSONToBookListService) new ObjectFactory()
            .createObject(ConvertJSONToBookListService.class);
        List<Book__c> bookList = convertJsonService.convert(req.requestBody.toString());
        
        // If there are more than 12000 books cancel the insertion
        if(bookList.size() > 12000) {
            res.statusCode = 400;
            responseBody.put('message', 'You can insert a maximum of 12000 books at once.');
            responseBody.put('Error', 'Insertion failed');
            String responseBodyString = JSON.serialize(responseBody);
            res.responseBody = Blob.valueOf(responseBodyString);
            return;
        }

        List<Database.SaveResult> sr = Database.insert(bookList, false);
        System.debug(sr);
    }
}