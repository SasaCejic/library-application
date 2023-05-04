/*
 * This class tests StandardAuthorCreator methods
 */
@isTest
public with sharing class StandardAuthorCreatorTest {

    @isTest
    public static void create_ifDontAlreadyExist_willCreateAuthorsAndCustomSettings(){
        //execute
        Test.startTest();
        StandardAuthorCreator.create();
        Test.stopTest();
        
        //assert custom setting creation
        List<Standard_Authors_Settting__c> stdAuthorSettings = Standard_Authors_Settting__c.getall().values();
        Assert.isTrue(stdAuthorSettings.size()==1, 'Custom settings were not created');

        //get corresponding authors and assert they have correct name field values
        Map<Id,Author__c> stdAuthors = new  Map<Id,Author__c>([
            SELECT
                Id,
                Name
            FROM
                Author__c
        ]);
        Assert.areEqual('Anonymous Author', stdAuthors.get(stdAuthorSettings[0].AnonymousId__c).Name, 'Anonymous Author not found or name invalid');
        Assert.areEqual('Unknown Author', stdAuthors.get(stdAuthorSettings[0].UnknownId__c).Name,'Unknown Author not found or name invalid');
    }

    @isTest
    public static void create_ifAlreadyCreated_willNotCreateNew(){
        //create pre-existing data
        StandardAuthorCreator.create();
        Assert.isTrue(Limits.getDMLStatements()==2, 'Two dml operations should have been ran');

        //execute and assert no insertions have ben made within test context
        Test.startTest();
        StandardAuthorCreator.create();
        Assert.isTrue(Limits.getDMLStatements()==0, 'No dml operations should have been ran');
        Test.stopTest();
    }
}