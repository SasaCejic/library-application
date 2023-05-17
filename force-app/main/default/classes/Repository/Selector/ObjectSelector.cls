/**
 * Class used for performing selectors for all objects
 */
public with sharing class ObjectSelector implements CustomObject{
    /**
     * @param objectName - name of object being searched
     * @param middleQuery - String coming from Search Service
     * @param searchTerm - value being searched
     */
    public List<SObject> searchObjects(String objectName, String middleQuery, String searchTerm) {
        String query = 'SELECT Id, Name FROM ' + objectName + ' WHERE' +
            middleQuery + ' Name LIKE \'%' + searchTerm + '%\'' + ' LIMIT 2000';
        return Database.query(query);
    }
}