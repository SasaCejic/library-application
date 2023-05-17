@isTest
public with sharing class TestFactory {
    @TestVisible
    public Map<String, String> publisherDetails = new Map<String, String>{
        'name' => 'publisher',
        'email' => 'publisher@gmail.com',
        'phone' => '124215426'
    };

    @TestVisible
    public Map<String, String> bookstoreDetails = new Map<String, String>{
        'name' => 'bookstore'
    };

    @TestVisible
    public Map<String, String> authorDetails = new Map<String, String>{
        'firstName' => 'Author',
        'lastName' => 'Author'
    };

    @TestVisible
    public Map<String, String> bookDetails = new Map<String, String>{
        'name' => 'book',
        'description' => 'bookdesc',
        'ISBN' => '214215425',
        'language' => 'english',
        'categories' => 'fantasy',
        'price' => '20',
        'hoursOfListening' => '20'
    };

    @TestVisible
    public Map<String, String> bookReviewDetails = new Map<String, String>{
        'name' => 'Good book',
        'rating' => '4'
    };

    @TestVisible
    public Map<String, String> standardAuthorsSettingDetails = new Map<String, String>{
        'name' => 'out-of-the-box authors setting'
    };
    
    @TestVisible
    public Map<String, String> mailDetails = new Map<String, String> {
        'subject' => 'Test subject',
        'body' => 'Test body',
        'address' => 'testaddress@gmail.com'
    };

    @TestVisible
    public Map<String, String> userDetails = new Map<String, String>{
        'lastName' => 'User',
        'alias' => 'testuser',
        'email' => 'testuser123@gmail.com',
        'emailEncodingKey' => 'ISO-8859-1',
        'communityNickName' => 'testuser1234',
        'localeSidKey' => 'en_US',
        'timeZoneSidKey' => 'GMT',
        'languageLocaleKey' => 'en_US',
        'profileId' => [SELECT Id FROM Profile WHERE Name=:'Standard User' LIMIT 1].Id
    };

    static Integer s_num = 1;

    /*
     * @param sObjecType- SObjectType of an object which we are creating fake Id for 
     */
    public String getFakeId(Schema.SObjectType sObjecType, Boolean simulateInsert) {
        if (simulateInsert) {
            String result = String.valueOf(s_num++);
            return sObjecType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
        }
        return null;
    }

    /*
     * @param bookId - Id of a book which is a parent in master-detail relationship with Bookstore_Book__c
     * @param bookstoreId - Id of a bookstore which isa a parent in master-detail relationship with Bookstore_Book__c
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Bookstore_Book__c createBookstoreBook(Id bookId, Id bookstoreId, Boolean forInsert, Boolean simulateInsert) {
        Bookstore_Book__c newBookstoreBook = new Bookstore_Book__c();
        newBookstoreBook.Book__c = bookId;
        newBookstoreBook.Bookstore__c = bookstoreId;
        
        if (forInsert) {
            insert newBookstoreBook;
            return newBookstoreBook;
        }
        newBookstoreBook.Id = this.getFakeId(Bookstore_Book__c.SObjectType, simulateInsert);
        return newBookstoreBook;
    }

    /*
     * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
     * @param bookstoreId - Id of a Bookstore__c which is a parent in master-detail relationship
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Bookstore_Publisher__c createBookstorePublisher(Id publisherId, Id bookstoreId, Boolean forInsert, Boolean simulateInsert) {
        Bookstore_Publisher__c newBookstorePublisher = new Bookstore_Publisher__c();
        newBookstorePublisher.Publisher__c = publisherId;
        newBookstorePublisher.Bookstore__c = bookstoreId;

        if (forInsert) {
            insert newBookstorePublisher;
            return newBookstorePublisher;
        }
        newBookstorePublisher.Id = this.getFakeId(Bookstore_Publisher__c.SObjectType, simulateInsert);
        return newBookstorePublisher;
    }

    /*
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Bookstore__c createBookstore(Boolean forInsert, Boolean simulateInsert) {
        Bookstore__c newBookstore = new Bookstore__c();
        newBookstore.Name = bookstoreDetails.get('name');
        Integer randomEmailNumber = (Integer)Math.floor(Math.random() * 9000) + 1000;
        newBookstore.Email__c = 'bookstore' + String.valueOf(randomEmailNumber) + '@gmail.com';
        Integer randomIdentificationCode = (Integer)Math.floor(Math.random() * 90000000) + 10000000;
        newBookstore.Store_Identification_Code__c = String.valueOf(randomIdentificationCode);

        if (forInsert) {
            insert newBookstore;
            return newBookstore;
        }
        newBookstore.Id = this.getFakeId(Bookstore__c.SObjectType, simulateInsert);
        return newBookstore;
    }

    /*
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Publisher__c createPublisher(Boolean forInsert, Boolean simulateInsert) {
        Publisher__c newPublisher = new Publisher__c();
        newPublisher.Name = publisherDetails.get('name');
        newPublisher.Email__c = publisherDetails.get('email');
        newPublisher.Phone__c = publisherDetails.get('phone');

        if (forInsert) {
            insert newPublisher;
            return newPublisher;
        }
        newPublisher.Id = this.getFakeId(Publisher__c.SObjectType, simulateInsert);
        return newPublisher;
    }

    /*
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
     * @param authorId - Id of an Author__c which is connected through lookup relationship with Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Book__c createBook(Id publisherId, Id authorId, Boolean forInsert, Boolean simulateInsert) {
        Book__c currentBook = new Book__c();
        currentBook.Name = bookDetails.get('name');
        currentBook.Description__c = bookDetails.get('description');
        currentBook.ISBN__c = bookDetails.get('ISBN');
        currentBook.Language__c = bookDetails.get('language');
        currentBook.Categories__c = bookDetails.get('categories');
        currentBook.Price__c = Decimal.valueOf(bookDetails.get('price'));
        currentBook.Publisher__c = publisherId;
        currentBook.Author__c = authorId;
        currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);

        if (forInsert) {
            insert currentBook;
            return currentBook;
        }
        currentBook.Id = this.getFakeId(Book__c.SObjectType, simulateInsert);
        return currentBook;
    }
    
    /*
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
     * @param authorId - Id of an Author__c which is connected through lookup relationship with Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Book__c createDigitalBook(Id publisherId, Id authorId, Boolean forInsert, Boolean simulateInsert) {
        Book__c currentBook = new Book__c();
        currentBook.Name = bookDetails.get('name');
        currentBook.Description__c = bookDetails.get('description');
        currentBook.ISBN__c = bookDetails.get('ISBN');
        currentBook.Language__c = bookDetails.get('language');
        currentBook.Categories__c = bookDetails.get('categories');
        currentBook.Hours_Of_Listening__c = Integer.valueOf(bookDetails.get('hoursOfListening'));
        currentBook.Price__c = Decimal.valueOf(bookDetails.get('price'));
        currentBook.Publisher__c = publisherId;
        currentBook.Author__c = authorId;
        currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);
        currentBook.RecordTypeId = Schema.SObjectType.Book__c.getRecordTypeInfosByName()
            .get('Digital Book').getRecordTypeId();

        if (forInsert) {
            insert currentBook;
            return currentBook;
        }
        currentBook.Id = this.getFakeId(Book__c.SObjectType, simulateInsert);
        return currentBook;
    }   

   /*
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param bookId - Id of a Book__c object which is a parent in master-detail relationship to Book__c
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Book_Review__c createBookReview(Id bookId, Boolean forInsert, Boolean simulateInsert) {
        Book_Review__c newBookReview = new Book_Review__c();
        newBookReview.Book__c = bookId;
        newBookReview.Name = bookReviewDetails.get('name');
        newBookReview.Rating__c = bookReviewDetails.get('rating');
        if (forInsert) {
            insert newBookReview;
            return newBookReview;
        }
        newBookReview.Id = getFakeId(Book_Review__c.SObjectType, simulateInsert);
        return newBookReview;
    }

    /*
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Author__c createAuthor(Boolean forInsert, Boolean simulateInsert) {
        Author__c newAuthor = new Author__c();
        newAuthor.First_Name__c = authorDetails.get('firstName');
        newAuthor.Last_Name__c = authorDetails.get('lastName');

        if (forInsert) {
            insert newAuthor;
            return newAuthor;
        }
        newAuthor.Id = this.getFakeId(Author__c.SObjectType, simulateInsert);
        return newAuthor;
    }

    /*
    * @param authorId - Id of a Author__c which is a parent in master-detail relationship
    * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
    * @param forInsert - Boolean value representing if we want to insert the record or not
    * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
    */
    public Author_Publisher__c createAuthorPublisher(Id authorId, Id publisherId, Boolean forInsert, Boolean simulateInsert) {
        Author_Publisher__c newAuthorPublisher = new Author_Publisher__c();
        newAuthorPublisher.Author__c=authorId;
        newAuthorPublisher.Publisher__c=publisherId;

        if (forInsert) {
            insert newAuthorPublisher;
            return newAuthorPublisher;
        }
        newAuthorPublisher.Id = getFakeId(Author_Publisher__c.SObjectType, simulateInsert);
        return newAuthorPublisher;
    }

    /*
     * @param anonymousId - Id of a Author__c object to be set as the standard Anonymous Author record
     * @param unknownId - Id of a Author__c object to be set as the standard Unknown Author record
     * @param forInsert - Boolean value representing if we want to insert the record or not
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Standard_Authors_Settting__c createStandardAuthorsSettting(Id anonymousId, Id unknownId, Boolean forInsert, Boolean simulateInsert) {
        Standard_Authors_Settting__c stdAuthorSetting = new Standard_Authors_Settting__c();
        stdAuthorSetting.Name=standardAuthorsSettingDetails.get('name');
        stdAuthorSetting.AnonymousId__c=anonymousId;
        stdAuthorSetting.UnknownId__c=unknownId;

        if(forInsert) {
            insert stdAuthorSetting;
            return stdAuthorSetting;
        }
        stdAuthorSetting.Id = this.getFakeId(Standard_Authors_Settting__c.SObjectType, simulateInsert);
        return stdAuthorSetting;
    }

    /*
     * @param bookId - Id of the book that was purchased
     */
    public Book_Purchase__c createBookPurchase(Id bookId, Boolean forInsert, Boolean simulateInsert) {
        Book_Purchase__c newBookPurchase = new Book_Purchase__c();
        newBookPurchase.Book__c = bookId;

        if (forInsert) {
            insert newBookPurchase;
            return newBookPurchase;
        }
        newBookPurchase.Id = getFakeId(Book_Purchase__c.SObjectType, simulateInsert);
        return newBookPurchase;
    }

    /*
     * Method creates a library user for testing
     */
    public User createLibraryUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Library User'];
        User user = new User(Alias = 'testuser', Email='testuser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing',
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                          TimeZoneSidKey='America/Los_Angeles', UserName='user12562d53@testorg.com',
                          ProfileId = p.Id);
        return user;
    }

    /*
     * Create mail for testing
     */
    public Messaging.SingleEmailMessage createMail() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(mailDetails.get('subject'));
        mail.setPlainTextBody(mailDetails.get('body'));
        mail.setToAddresses(new String[] {mailDetails.get('address')});
        return mail;
    }

    /*
     * Method creates a fake Database.SaveResult for testing
     */
    public Database.SaveResult createSuccessDatabaseSaveResult() {
        Database.SaveResult sr = (Database.SaveResult) JSON.deserialize('{"success":true,"id":"0013000000abcde"}', Database.SaveResult.class);
        return sr;
    }
    
    /**
     * Method for creating a new User
     * 
     * @param forInsert Boolean value representing if we want to insert the record or not
     * @param simulateInsert Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public User createUser(Boolean forInsert, Boolean simulateInsert) {
        User newUser = new User();
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        uniqueName = (uniqueName.length() > 51) ? uniqueName.substring(0,51) : uniqueName;
        newUser.Username = uniqueName + '@test' + orgId + '.org';
        newUser.LastName = userDetails.get('lastName');
        newUser.Email = userDetails.get('email');
        newUser.EmailEncodingKey  = userDetails.get('emailEncodingKey');
        newUser.Alias = userDetails.get('alias');
        newUser.TimeZoneSidKey = userDetails.get('timeZoneSidKey');
        newUser.LocaleSidKey = userDetails.get('localeSidKey');
        newUser.LanguageLocaleKey = userDetails.get('languageLocaleKey');
        newUser.ProfileId = userDetails.get('profileId');

        if(forInsert) {
            insert newUser;
            return newUser;
        }
        newUser.Id = this.getFakeId(User.SObjectType, simulateInsert);
        return newUser;
    }

}