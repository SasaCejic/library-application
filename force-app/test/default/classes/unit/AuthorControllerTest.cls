/**
 * This class tests the AuthorController class methods
 * 
 * @see AuthorController.cls
 */
@isTest
public with sharing class AuthorControllerTest {
    @IsTest
    static void getBookstoresWithAuthorsBooks_WillUseService() {
        //create Bookstore__c
        TestFactory testFactory = new TestFactory();
        Map<String, String> bookstoreDetails = new Map<String, String>();
        bookstoreDetails.put('name', 'TestBookstore');
        bookstoreDetails.put('email', 'bookstore@gmail.com');
        bookstoreDetails.put('storeId', '1234567');
        Bookstore__c bookstore = testFactory.createBookstore(bookstoreDetails, false, true);

        //create Author__c
        Map<String, String> authorDetails = new Map<String, String>();
        authorDetails.put('name', 'Test Author');
        authorDetails.put('firstName', 'Test');
        authorDetails.put('lastName', 'Author');
        Author__c author = testFactory.createAuthor(authorDetails, false, true);

        // create mock
        Mocker mock = new Mocker(AuthorService.class)
            .setBehavior('getBookstoresWithAuthorsBooks', new List<Bookstore__c>{bookstore});
        
        // set mock
        ObjectFactory.mocks.put(
            AuthorService.class.getName(),
            (AuthorService) mock.getMock()
        );

        // execute
        List<Bookstore__c> bookstores = AuthorController.getBookstoresWithAuthorsBooks(author.Id);

        // assert
        mock.assertMethodExecutionCount('getBookstoresWithAuthorsBooks', 1);
        Assert.areEqual(1, bookstores.size());
        Assert.areEqual(bookstore.Id, bookstores[0].Id);
    }

}