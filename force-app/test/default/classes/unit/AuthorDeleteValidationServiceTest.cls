/*
 * This class performs unit tests for the AuthorDeleteValidationService class
 * Tests consist of 1 mock where we mock a selector
 * There is 1 positive, 1 negative and 1 mockerexecutioncount
 */
@isTest
public with sharing class AuthorDeleteValidationServiceTest {

    @isTest
    public static void validateAuthorDelete_willAddErrors_ifStdAuthorsDeleted(){
        //create test data
        TestFactory testFactory = new TestFactory();
        Author__c anonAuthor= testFactory.createAuthor(false, true);
        Author__c unknownAuthor= testFactory.createAuthor(false, true);
        Standard_Authors_Settting__c stdAuthorSetting = testFactory
            .createStandardAuthorsSettting(anonAuthor.Id, unknownAuthor.Id, false, true);
        
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{stdAuthorSetting});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorDeleteValidationService authorValidationService = new AuthorDeleteValidationService();
        authorValidationService.validateAuthorDelete(new List<Author__c>{unknownAuthor, anonAuthor});

        //assert errors have been added to edited standard author record
        Assert.isTrue(unknownAuthor.getErrors().size() == 1,'Errors should have been added to deleted unknown author record');
        Assert.isTrue(anonAuthor.getErrors().size() == 1,'Errors should have been added to deleted anonymous author record');
    }

    @isTest
    public static void validateAuthorDelete_willNotAddError_ifStdAuthorNotDeleted(){
        //create test data
        TestFactory testFactory = new TestFactory();
        Author__c anonAuthor= testFactory.createAuthor(false, true);
        Author__c unknownAuthor= testFactory.createAuthor(false, true);
        Standard_Authors_Settting__c stdAuthorSetting = testFactory
            .createStandardAuthorsSettting(anonAuthor.Id, unknownAuthor.Id, false, true);
        
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{stdAuthorSetting});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorDeleteValidationService authorValidationService = new AuthorDeleteValidationService();
        authorValidationService.validateAuthorDelete(new List<Author__c>{});

        //assert errors have been added to edited standard author record
        Assert.isTrue(unknownAuthor.getErrors().size() == 0,'Errors should have been added to deleted unknown author record');
        Assert.isTrue(anonAuthor.getErrors().size() == 0,'Errors should have been added to deleted anonnymous author record');
    }

    @isTest
    public static void validateAuthorDelete_willUseCorrectSelector(){
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorDeleteValidationService authorValidationService = new AuthorDeleteValidationService();
        authorValidationService.validateAuthorDelete(new List<Author__c>{});

        //assert correct selector has been used
        customSettingSelectorMock.assertMethodExecutionCount('getStdAuthorsSettingList', 1);
    }
}