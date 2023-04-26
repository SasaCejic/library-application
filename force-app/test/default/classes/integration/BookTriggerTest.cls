/*
* This class performs tests for Book__c trigger 
*/
@isTest
public with sharing class BookTriggerTest {
    //reusable details for the data to be created in tests
    private static Map<String, String> publisherDetails = new Map<String, String>{
        'name'=>'publisher',
        'email'=>'publisher@gmail.com',
        'phone'=>'1241353'
    };
    private static Map<String, String> authorDetails = new Map<String, String>{
        'firstName'=>'Author',
        'lastName'=>'Author'
    };
    private static Map<String, String> bookDetails = new Map<String, String>{
        'name'=>'book',
        'description'=>'bookdesc',
        'ISBN'=>'214215425',
        'language'=>'english',
        'categories'=>'fantasy'
    };

    @isTest
    public static void onInsert_willAddError_whenAuthorPublisherNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, true, false);
        Author__c authorForTest = testFactory.createAuthor(authorDetails, true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, authorForTest.Id, bookDetails, false, false);

        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookForTest, false);
        Test.stopTest();

        System.assert(insertResult.isSuccess() == false,'Result for book insert should not be a success');
    }

    @isTest
    public static void onUpdate_willAddError_whenNewAuthorPublisherNotAdded() {
        //Create data for mocks and test
        TestFactory testFactory = new TestFactory();
        Publisher__c publisherForTest = testFactory.createPublisher(publisherDetails, true, false);
        Author__c oldAuthorForTest = testFactory.createAuthor(authorDetails, true, false);
        Author_Publisher__c authorPublisherForMock = testFactory
        .createAuthorPublisher(oldAuthorForTest.Id, publisherForTest.Id, true, false);
        Book__c bookForTest = testFactory.createBook(publisherForTest.Id, oldAuthorForTest.Id, bookDetails, true, false);
        //Create new data for update
        Author__c newAuthorForTest = testFactory.createAuthor(authorDetails, false, true);
        bookForTest.Author__c=newAuthorForTest.Id;

        Test.startTest();
        Database.SaveResult updateResult = Database.update(bookForTest, false);
        Test.stopTest();

        System.assert(updateResult.isSuccess() == false,'Result for book update should not be a success');
    }
}