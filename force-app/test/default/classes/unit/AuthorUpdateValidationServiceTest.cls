/*
 * This class performs unit tests for the AuthorUpdateValidationService class
 * Tests consist of 1 mock where we mock a selector
 * There is 1 positive, 1 negative and 1 mockerexecutioncount test, along with
 * an added test for validateAuthorUpdate in the scenario where only a field that should allow edit on standard authors is updated
 */
@isTest
public with sharing class AuthorUpdateValidationServiceTest {

    @isTest
    public static void validateAuthorUpdate_willAddError_ifStdAuthorUpdated(){
        //create test data
        TestFactory testFactory = new TestFactory();
        Author__c anonAuthor= testFactory.createAuthor(true);
        Author__c unknownAuthor= testFactory.createAuthor(true);
        Author__c editedUnknownAuthor= unknownAuthor.clone(true);
        editedUnknownAuthor.First_Name__c='Changed';
        Standard_Authors_Settting__c stdAuthorSetting = testFactory
            .createStandardAuthorsSettting(anonAuthor.Id, unknownAuthor.Id, true);
        
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{stdAuthorSetting});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorUpdateValidationService authorValidationService = new AuthorUpdateValidationService();
        authorValidationService.validateAuthorUpdate(new List<Author__c>{unknownAuthor}, new List<Author__c>{editedUnknownAuthor});

        //assert errors have been added to edited standard author record
        Assert.isTrue(editedUnknownAuthor.getErrors().size() == 1,'Errors should have been added to edited standard author record');
    }

    @isTest
    public static void validateAuthorUpdate_willNotAddError_ifAllowedForEditOnStdAuthorFieldUpdated(){
        //create test data
        TestFactory testFactory = new TestFactory();
        Author__c anonAuthor= testFactory.createAuthor(true);
        Author__c unknownAuthor= testFactory.createAuthor(true);
        Author__c editedUnknownAuthor= unknownAuthor.clone(true, true,true);
        editedUnknownAuthor.Number_Of_Published_Books__c=5;
        Standard_Authors_Settting__c stdAuthorSetting = testFactory
            .createStandardAuthorsSettting(anonAuthor.Id, unknownAuthor.Id, true);
        
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{stdAuthorSetting});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorUpdateValidationService authorValidationService = new AuthorUpdateValidationService();
        authorValidationService.validateAuthorUpdate(new List<Author__c>{unknownAuthor}, new List<Author__c>{editedUnknownAuthor});

        //assert errors have been added to edited standard author record
        Assert.isTrue(editedUnknownAuthor.getErrors().size() == 0,'Error should not have been added to edited standard author record on allowed field edit');
    }

        @isTest
    public static void validateAuthorUpdate_willNotAddError_ifStdAuthorsNotUpdated(){
        //create test data
        TestFactory testFactory = new TestFactory();
        Author__c anonAuthor= testFactory.createAuthor(true);
        Author__c unknownAuthor= testFactory.createAuthor(true);
        Author__c nonStdAuthor= testFactory.createAuthor(true);
        Author__c editedNonStdAuthor= nonStdAuthor.clone(true);
        editedNonStdAuthor.First_Name__c='Changed';
        Standard_Authors_Settting__c stdAuthorSetting = testFactory
            .createStandardAuthorsSettting(anonAuthor.Id, unknownAuthor.Id, true);
        
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{stdAuthorSetting});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorUpdateValidationService authorValidationService = new AuthorUpdateValidationService();
        authorValidationService.validateAuthorUpdate(new List<Author__c>{nonStdAuthor}, new List<Author__c>{editedNonStdAuthor});

        //assert errors have been added to edited standard author record
        Assert.isTrue(editedNonStdAuthor.getErrors().size() == 0,'Error should not have been added to edited non standard author record');
    }

    @isTest
    public static void validateAuthorUpdate_willUseCorrectSelector(){
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorUpdateValidationService authorValidationService = new AuthorUpdateValidationService();
        authorValidationService.validateAuthorUpdate(new List<Author__c>{},new List<Author__c>{});

        //assert correct selector has been used
        customSettingSelectorMock.assertMethodExecutionCount('getStdAuthorsSettingList', 1);
    }
}