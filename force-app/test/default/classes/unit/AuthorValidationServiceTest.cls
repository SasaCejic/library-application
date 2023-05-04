/*
 *This class performs unit tests for the AuthorValidationService class
 *Tests consist of 1 mock where we mock a selector
 * There is 1 positive, 1 negative and 1 mockerexecutioncount test
 */
@isTest
public with sharing class AuthorValidationServiceTest {

    @isTest
    public static void validateNoStdAuthorChange_willAddError_ifStdAuthorsChanged(){
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
        AuthorValidationService authorValidationService = new AuthorValidationService();
        authorValidationService.validateNoStdAuthorChange(new List<Author__c>{anonAuthor,unknownAuthor});

        //assert errors have been added to standard author records
        Assert.isTrue(anonAuthor.getErrors().size() == 1,'Errors should have been added to anonymous author record');
        Assert.isTrue(unknownAuthor.getErrors().size() == 1,'Errors should have been added to unknown author record');
    }

    @isTest
    public static void validateNoStdAuthorChange_willNotAddError_ifStdAuthorsUncahanged(){
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
        AuthorValidationService authorValidationService = new AuthorValidationService();
        authorValidationService.validateNoStdAuthorChange(new List<Author__c>{});

        //assert errors have not been added to standard author records
        Assert.isTrue(anonAuthor.getErrors().size() == 0,'Errors should not have been added to anonymous author record');
        Assert.isTrue(unknownAuthor.getErrors().size() == 0,'Errors should not have been added to unknown author record');
    }

        @isTest
    public static void validateNoStdAuthorChange_willUseCorrectSelector(){
        // create mock
        Mocker customSettingSelectorMock = new Mocker(CustomSettingSelector.class)
            .setBehavior('getStdAuthorsSettingList', new List<Standard_Authors_Settting__c>{});
        // set mock
        ObjectFactory.mocks.put(
            CustomSettingSelector.class.getName(),
            (CustomSettingSelector) customSettingSelectorMock.getMock()
        );

        //execute
        AuthorValidationService authorValidationService = new AuthorValidationService();
        authorValidationService.validateNoStdAuthorChange(new List<Author__c>{});

        //assert correct selector has been used
        customSettingSelectorMock.assertMethodExecutionCount('getStdAuthorsSettingList', 1);
    }
}