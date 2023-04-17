/*
*This class is used to check if a current user has a certain permission set
*/
public with sharing class CustomPermissionValidationService implements CustomObject {
    /*
    @param customPermission - name of the custom permission
    */
    public Boolean validateCustomPermission(String customPermission) {
        return FeatureManagement.checkPermission(customPermission);
    }
}