/**
 * Class used for converting JSON from BOOK REST API request to list of books
 * JSON string will be in form of { "data": ["field": "fieldValue"] }
 */
public with sharing class ConvertJSONToBookListService implements CustomObject {
    /**
     * @param jsonString - Json strig from request body
     */
    public List<Book__c> convert(String jsonString) {
        // Cast the JSON body into a map
        Map<String, Object> deserializeBody = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        // Create a list that will store the data
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        // Deserialized body has key called data which holds the list of all the records
        for (Object instance : (List<Object>)deserializeBody.get('data')) {
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
        // return books
        return bookList;        
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