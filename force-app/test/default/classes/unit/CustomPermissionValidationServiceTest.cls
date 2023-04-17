/*
* Test class used for testing custom permission validation service
*/
@isTest
public with sharing class CustomPermissionValidationServiceTest {
    @isTest
    public static void validateCustomPermission_willReturnTrue_runAsBookstoreManager() {
        // create a user with the necessary profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Library User'];
        User u = new User(Alias = 'testuser', Email='testuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', 
            UserName='testuser@testorg.com');
        insert u;
        // assign the Bookstore_Manager permission set to the user
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Bookstore_Manager'];
        PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps.Id);
        insert psa;

        System.runAs(u) {
            CustomPermissionValidationService validator = new CustomPermissionValidationService();
            System.assertEquals(true, validator.validateCustomPermission('Bookstore_Manager'));
        }
    }

    @isTest
    public static void validateCustomPermission_willReturnFalse_notRunAsBookstoreManager() {
        // create a user with the necessary profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Library User'];
        User u = new User(Alias = 'testuser', Email='testuser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', 
            UserName='testuser@testorg.com');
        insert u;

        System.runAs(u) {
            CustomPermissionValidationService validator = new CustomPermissionValidationService();
            System.assertEquals(false, validator.validateCustomPermission('Bookstore_Manager'));
        }
    }
}