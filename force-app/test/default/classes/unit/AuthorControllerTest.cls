/**
 * This class tests the AuthorController class methods
 * 
 * @see AuthorController.cls
 */
@isTest
public with sharing class AuthorControllerTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillUseService() {
        //create TestFactory
        TestFactory testFactory = new TestFactory();

        //create Bookstore__c
        Bookstore__c bookstore = testFactory.createBookstore(false, true);

        //create Author__c
        Author__c author = testFactory.createAuthor(false, true);

        // create mock
        Mocker mock = new Mocker(AuthorService.class);
        mock.setBehavior('getBookstoresWithAuthorsBooks', null);
        mock.setBehavior('getResponse', new List<Bookstore__c>{bookstore});
        
        // set mock
        ObjectFactory.mocks.put(
            AuthorService.class.getName(),
            (AuthorService) mock.getMock()
        );

        // execute
        Test.startTest();
        List<Bookstore__c> bookstores = AuthorController.getBookstoresWithAuthorsBooks(author.Id);
        Test.stopTest();

        // assert
        mock.assertMethodExecutionCount('getBookstoresWithAuthorsBooks', 1);
        mock.assertMethodExecutionCount('getResponse', 1);
        Assert.areEqual(1, bookstores.size());
        Assert.areEqual(bookstore.Id, bookstores[0].Id);
    }

}