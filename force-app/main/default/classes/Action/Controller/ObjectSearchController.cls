/**
 * Class used for performing search functionality on all custom objects and record types
 */
public with sharing class ObjectSearchController {
    /**
     * @param objectName - Name of object being searched
     * @param recordTypeId - Record type id of the object
     * @param searchTerm - value in the search input
     */
    @AuraEnabled()
    public static List<SObject> searchObject(String objectName, Id recordTypeId, String searchTerm) {
        ObjectSearchService service = (ObjectSearchService) new ObjectFactory()
            .createObject(ObjectSearchService.class);
        service.search(objectName, recordTypeId, searchTerm);
        return service.getResponse();
    }
}