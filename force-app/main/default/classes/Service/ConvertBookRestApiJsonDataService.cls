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

        // IMPORTANT - For some reson apex doesen't allow us to cast List<Map<String,Object>> from JSON
        // So the only option was to cast it first into List<Object> and than loop that List to cast that Each <Object> into to Map<String,Object>
        List<Book__c> bookList = new List<Book__c>();
        if (deserializeBody.get('data') != null) {
            // Lopp through book data and cast it from Object to Map<String,Object>
            for (Object bookFields : (List<Object>) deserializeBody.get('data')) {
                Book__c book = createBookFromFields((Map<String, Object>) bookFields);
                bookList.add(book);
            }
        } else {
            bookList = null;
        }

        // Set DTO class
        BookRestApiRequestDTO bookRestApiRequestDTO = new BookRestApiRequestDTO();
        bookRestApiRequestDTO.bookList = bookList;
        bookRestApiRequestDTO.insertOption = insertOption;

        // return books
        return bookRestApiRequestDTO;        
    }

    /**
     * Create a Book__c object from the given field map
     * @param bookFields - Map of field names and values
     * @return Book__c object
     */
    private Book__c createBookFromFields(Map<String, Object> bookFields) {
        Book__c book = new Book__c();
        // Loop through the fields, and cover the cases where data has to be converted (Dates, record type names etc...)
        for (String fieldName : bookFields.keySet()) {
            if (fieldName.equals('Publish_Date__c')) {
                book.put(fieldName, convertStringToDate((String) bookFields.get(fieldName)));
            } else if (fieldName.equals('attributes')) {
                continue;
            } else if (fieldName.equals('RecordTypeName')) {
                book.put('RecordTypeId', generateRecordTypeIdFromRecordTypeName((String) bookFields.get(fieldName)));
            } else {
                book.put(fieldName, bookFields.get(fieldName));
            }
        }
        // return the book
        return book;
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