/**
 * Class used for converting JSON from BOOK REST API request to BookRestApiRequestDTO
 * @see BookRestApiRequestDTO
 * JSON string will be in form of { "data": ["field": "fieldValue"], "option": 1 } where data is books data and option is Insert option, can be 1 or 2
 */
public with sharing class ConvertBookRestApiJsonDataService implements CustomObject {
    /**
     * @param jsonString - Json strig from request body
     */
    public BookRestApiRequestDTO convert(String jsonString) {
        // Cast the JSON body into a map
        Map<String, Object> deserializeBody = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        // Value of the option about book insert from request body
        Integer insertOption = (Integer) deserializeBody.get('option');
        // Create a list that will store the data
        List<Map<String, Object>> data = new List<Map<String, Object>>();

        // IMPORTANT - For some reson apex doesen't allow us to deserialize List<Map<String,Object>> from JSON
        // So the only option was to cast it first into List<Object> and than loop that List to cast that Each <Object> into to Map<String,Object> and add it to our data list
        for (Object instance : (List<Object>) deserializeBody.get('data')) {
            data.add((Map<String, Object>)instance);
        } 

        // Loop through record data and create book objects from it
        List<Book__c> bookList = new List<Book__c>();
        for (Map<String, Object> bookFields : data) {
            // Dynamically create Book__c object from Map
            Book__c book = new Book__c();
            for (String fieldName : bookFields.keySet()) {
                // Check if the field is a Publish date because it will need conversion to date from string
                if (fieldName == 'Publish_Date__c') {
                    book.put(fieldName, convertStringToDate((String) bookFields.get(fieldName)));
                    continue;
                }

                // Check if the field is recordTypeName and generate corresponding recordTypeId for it
                if (fieldName == 'RecordTypeName') {
                    book.put('RecordTypeId', generateRecordTypeIdFromRecordTypeName((String) bookFields.get(fieldName)));
                    continue;
                }

                book.put(fieldName, bookFields.get(fieldName));
            }
            bookList.add(book);
        }

        // Set DTO class
        BookRestApiRequestDTO bookRestApiRequestDTO = new BookRestApiRequestDTO();
        bookRestApiRequestDTO.bookList = bookList;
        bookRestApiRequestDTO.insertOption = insertOption;

        // return books
        return bookRestApiRequestDTO;        
    }

    /**
     * @param dateString - Date in form of a string
     */
    private Date convertStringToDate(String dateString) {
        return Date.valueOf(dateString);
    }

    /**
     * @param recordTypeName - Name of the record Type
     */
    private Id generateRecordTypeIdFromRecordTypeName(String recordTypeName) {
        return Schema.SObjectType.Book__c.getRecordTypeInfosByName()
            .get(recordTypeName).getRecordTypeId();
    }
}