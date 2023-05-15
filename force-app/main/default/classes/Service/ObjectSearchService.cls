/**
 * Class used for searching through all salesforce custom objects based on object type, recordType, and searchTerm
 */
public with sharing class ObjectSearchService implements CustomObject {
    private List<SObject> response;

    //Getter
    public List<SObject> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<SObject> objectList) {
        this.response = objectList;
    }

    /**
     * @param objectName - String indicating which object is being searched
     * @param recordType - Id indicating which RecordTypeId is being searched
     * @param searchTerm - String representing the name being searched
     */
    public void search(String objectName, Id recordType, String searchTerm) {
        String query = '';
        // If record type is null, meaning it wasn't specified, don't include recordTypeId in query
        if (recordType != null) {
            query += ' RecordTypeId = \'' + recordType + '\'' + ' AND';
        }
        ObjectSelector selector = (ObjectSelector) new ObjectFactory()
            .createObject(ObjectSelector.class);
        this.setResponse(selector.searchObjects(objectName, query, searchTerm));
    }
}