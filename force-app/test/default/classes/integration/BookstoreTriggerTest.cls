/**
 * This class performs tests for Bookstore__c object trigger
 * 
 * @see BookstoreTrigger.trigger
 */
@isTest
public with sharing class BookstoreTriggerTest {
    @isTest
    public static void onInsert_WillAddError_IfUserIsManagerOfSomeBookstore() {
        // create data
        TestFactory testFactory = new TestFactory();
        User userForTest = testFactory.createUser(false);
        insert userForTest;
        userForTest.isBookstoreManager__c = true;
        update userForTest;
        Bookstore__c bookstore1 = testFactory.createBookstore(false);
        insert bookstore1;
        //make user manager of the bookstore
        bookstore1.Manager__c = userForTest.Id;
        update bookstore1;
        Bookstore__c bookstore2 = new Bookstore__c (Name = 'Bookstore 2', Email__c = 'bookstore2@gmail.com', Store_Identification_Code__c = '84957562');
        //make user manager of the bookstore
        bookstore2.Manager__c = userForTest.Id;

        Test.startTest();
        Database.SaveResult insertResult = Database.insert(bookstore2, false);
        Test.stopTest();

        Assert.isTrue(insertResult.getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', insertResult.getErrors()[0].getMessage());
    }

    @isTest
    public static void onUpdate_WillAddError_IfUserIsManagerOfSomeBookstore() {
        // create data
        TestFactory testFactory = new TestFactory();
        User userForTest = testFactory.createUser(false);
        insert userForTest;
        userForTest.isBookstoreManager__c = true;
        update userForTest;
        Bookstore__c bookstore1 = testFactory.createBookstore(false);
        insert bookstore1;
        //make user manager of the bookstore
        bookstore1.Manager__c = userForTest.Id;
        update bookstore1;
        Bookstore__c bookstore2 = testFactory.createBookstore(false);
        insert bookstore2;
        //make user manager of the bookstore
        bookstore2.Manager__c = userForTest.Id;

        Test.startTest();
        Database.SaveResult updateResult = Database.update(bookstore2, false);
        Test.stopTest();

        Assert.isTrue(updateResult.getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', updateResult.getErrors()[0].getMessage());
    }

    @isTest
    public static void onInsert_WillAddError_IfOneOfThreeUsersIsAlreadyABookstoreManager() {
        // create data
        TestFactory testFactory = new TestFactory();
        User user1 = testFactory.createUser(false);
        insert user1;
        user1.isBookstoreManager__c = true;
        update user1;
        User user2 = testFactory.createUser(false);
        insert user2;
        user2.isBookstoreManager__c = true;
        update user2;
        User user3 = testFactory.createUser(false);
        insert user3;
        user3.isBookstoreManager__c = true;
        update user3;
        Bookstore__c bookstore1 = testFactory.createBookstore(false);
        insert bookstore1;
        //make user manager of the bookstore
        bookstore1.Manager__c = user1.Id;
        update bookstore1;
        Bookstore__c bookstore2 = new Bookstore__c (Name = 'Bookstore 2', Email__c = 'bookstore2@gmail.com', Store_Identification_Code__c = '84957562');
        //make user manager of the bookstore
        bookstore2.Manager__c = user2.Id;
        Bookstore__c bookstore3 = new Bookstore__c (Name = 'Bookstore 3', Email__c = 'bookstore3@gmail.com', Store_Identification_Code__c = '77648930');
        //make user manager of the bookstore
        bookstore3.Manager__c = user3.Id;
        Bookstore__c bookstore4 = new Bookstore__c (Name = 'Bookstore 4', Email__c = 'bookstore4@gmail.com', Store_Identification_Code__c = '85967324');
        //make user manager of the bookstore
        bookstore4.Manager__c = user1.Id;

        List<Bookstore__c> bookstores = new List<Bookstore__c> {bookstore2, bookstore3, bookstore4};

        Test.startTest();
        List<Database.SaveResult> insertResults = Database.insert(bookstores, false);
        Test.stopTest();

        Assert.isTrue(insertResults[0].isSuccess());
        Assert.isTrue(insertResults[1].isSuccess());
        Assert.isTrue(!insertResults[2].isSuccess());
        Assert.isTrue(insertResults[2].getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', insertResults[2].getErrors()[0].getMessage());
    }

    @isTest
    public static void onUpdate_WillAddError_IfOneOfThreeUsersIsAlreadyABookstoreManager() {
        // create data
        TestFactory testFactory = new TestFactory();
        User user1 = testFactory.createUser(false);
        insert user1;
        user1.isBookstoreManager__c = true;
        update user1;
        User user2 = testFactory.createUser(false);
        insert user2;
        user2.isBookstoreManager__c = true;
        update user2;
        User user3 = testFactory.createUser(false);
        insert user3;
        user3.isBookstoreManager__c = true;
        update user3;
        Bookstore__c bookstore1 = testFactory.createBookstore(false);
        insert bookstore1;
        //make user manager of the bookstore
        bookstore1.Manager__c = user1.Id;
        update bookstore1;

        Bookstore__c bookstore2 = testFactory.createBookstore(false);
        insert bookstore2;
        Bookstore__c bookstore3 = testFactory.createBookstore(false);
        insert bookstore3;
        Bookstore__c bookstore4 = testFactory.createBookstore(false);
        insert bookstore4;

        bookstore2.Manager__c = user2.Id;
        bookstore3.Manager__c = user3.Id;
        bookstore4.Manager__c = user1.Id;

        List<Bookstore__c> bookstores = new List<Bookstore__c> {bookstore2, bookstore3, bookstore4};

        Test.startTest();
        List<Database.SaveResult> updateResults = Database.update(bookstores, false);
        Test.stopTest();

        Assert.isTrue(updateResults[0].isSuccess());
        Assert.isTrue(updateResults[1].isSuccess());
        Assert.isTrue(!updateResults[2].isSuccess());
        Assert.isTrue(updateResults[2].getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', updateResults[2].getErrors()[0].getMessage());
    }

    @isTest
    public static void onInsert_WillAddTwoErrors_IfTwoUsersAreAlreadyBookstoreManagers() {
        // create data
        TestFactory testFactory = new TestFactory();
        User user1 = testFactory.createUser(false);
        insert user1;
        user1.isBookstoreManager__c = true;
        update user1;
        User user2 = testFactory.createUser(false);
        insert user2;
        user2.isBookstoreManager__c = true;
        update user2;
        User user3 = testFactory.createUser(false);
        insert user3;
        user3.isBookstoreManager__c = true;
        update user3;
        Bookstore__c bookstore1 = testFactory.createBookstore(false);
        insert bookstore1;
        //make user manager of the bookstore
        bookstore1.Manager__c = user1.Id;
        update bookstore1;
        Bookstore__c bookstore2 = new Bookstore__c (Name = 'Bookstore 2', Email__c = 'bookstore2@gmail.com', Store_Identification_Code__c = '84957562');
        //make user manager of the bookstore
        bookstore2.Manager__c = user2.Id;
        Bookstore__c bookstore3 = new Bookstore__c (Name = 'Bookstore 3', Email__c = 'bookstore3@gmail.com', Store_Identification_Code__c = '77648930');
        //make user manager of the bookstore
        bookstore3.Manager__c = user3.Id;
        Bookstore__c bookstore4 = new Bookstore__c (Name = 'Bookstore 4', Email__c = 'bookstore4@gmail.com', Store_Identification_Code__c = '85967324');
        //make user manager of the bookstore
        bookstore4.Manager__c = user1.Id;
        Bookstore__c bookstore5 = new Bookstore__c (Name = 'Bookstore 5', Email__c = 'bookstore5@gmail.com', Store_Identification_Code__c = '84759032');
        //make user manager of the bookstore
        bookstore5.Manager__c = user1.Id;

        List<Bookstore__c> bookstores = new List<Bookstore__c> {bookstore2, bookstore3, bookstore4, bookstore5};

        Test.startTest();
        List<Database.SaveResult> insertResults = Database.insert(bookstores, false);
        Test.stopTest();

        Assert.isTrue(insertResults[0].isSuccess());
        Assert.isTrue(insertResults[1].isSuccess());
        Assert.isTrue(!insertResults[2].isSuccess());
        Assert.isTrue(insertResults[2].getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', insertResults[2].getErrors()[0].getMessage());
        Assert.isTrue(!insertResults[3].isSuccess());
        Assert.isTrue(insertResults[3].getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', insertResults[3].getErrors()[0].getMessage());
    }

    @isTest
    public static void onUpdate_WillAddTwoErrors_IfTwoUsersAreAlreadyBookstoreManagers() {
        // create data
        TestFactory testFactory = new TestFactory();
        User user1 = testFactory.createUser(false);
        insert user1;
        user1.isBookstoreManager__c = true;
        update user1;
        User user2 = testFactory.createUser(false);
        insert user2;
        user2.isBookstoreManager__c = true;
        update user2;
        User user3 = testFactory.createUser(false);
        insert user3;
        user3.isBookstoreManager__c = true;
        update user3;
        Bookstore__c bookstore1 = testFactory.createBookstore(false);
        insert bookstore1;
        //make user manager of the bookstore
        bookstore1.Manager__c = user1.Id;
        update bookstore1;

        Bookstore__c bookstore2 = testFactory.createBookstore(false);
        insert bookstore2;
        Bookstore__c bookstore3 = testFactory.createBookstore(false);
        insert bookstore3;
        Bookstore__c bookstore4 = testFactory.createBookstore(false);
        insert bookstore4;
        Bookstore__c bookstore5 = testFactory.createBookstore(false);
        insert bookstore5;

        bookstore2.Manager__c = user2.Id;
        bookstore3.Manager__c = user3.Id;
        bookstore4.Manager__c = user1.Id;
        bookstore5.Manager__c = user1.Id;

        List<Bookstore__c> bookstores = new List<Bookstore__c> {bookstore2, bookstore3, bookstore4, bookstore5};

        Test.startTest();
        List<Database.SaveResult> updateResults = Database.update(bookstores, false);
        Test.stopTest();

        Assert.isTrue(updateResults[0].isSuccess());
        Assert.isTrue(updateResults[1].isSuccess());
        Assert.isTrue(!updateResults[2].isSuccess());
        Assert.isTrue(updateResults[2].getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', updateResults[2].getErrors()[0].getMessage());
        Assert.isTrue(!updateResults[3].isSuccess());
        Assert.isTrue(updateResults[3].getErrors().size() == 1);
        Assert.areEqual('User is already a Bookstore Manager!', updateResults[3].getErrors()[0].getMessage());
    }

}