@isTest
public with sharing class TestFactory {
    static Integer s_num = 1;

    /**
     * @param sObjecType- SObjectType of an object which we are creating fake Id for 
     */
    public String getFakeId(Schema.SObjectType sObjecType, Boolean simulateInsert) {
        if (simulateInsert) {
            String result = String.valueOf(s_num++);
            return sObjecType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
        }
        return null;
    }

    /**
     * @param bookId - Id of a book which is a parent in master-detail relationship with Bookstore_Book__c
     * @param bookstoreId - Id of a bookstore which isa a parent in master-detail relationship with Bookstore_Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Bookstore_Book__c createBookstoreBook(Id bookId, Id bookstoreId, Boolean simulateInsert) {
        Bookstore_Book__c newBookstoreBook = new Bookstore_Book__c();
        newBookstoreBook.Book__c = bookId;
        newBookstoreBook.Bookstore__c = bookstoreId;
        newBookstoreBook.Quantity__c = 10;
        newBookstoreBook.Number_Of_Active_Reservations__c = 0;

        // Generate Id based on simulateInsert
        newBookstoreBook.Id = this.getFakeId(Bookstore_Book__c.SObjectType, simulateInsert);
        return newBookstoreBook;
    }

    /**
     * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
     * @param bookstoreId - Id of a Bookstore__c which is a parent in master-detail relationship
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Bookstore_Publisher__c createBookstorePublisher(Id publisherId, Id bookstoreId, Boolean simulateInsert) {
        Bookstore_Publisher__c newBookstorePublisher = new Bookstore_Publisher__c();
        newBookstorePublisher.Publisher__c = publisherId;
        newBookstorePublisher.Bookstore__c = bookstoreId;

        // Generate Id based on simulateInsert
        newBookstorePublisher.Id = this.getFakeId(Bookstore_Publisher__c.SObjectType, simulateInsert);
        return newBookstorePublisher;
    }

    /**
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Bookstore__c createBookstore(Boolean simulateInsert) {
        Bookstore__c newBookstore = new Bookstore__c();
        newBookstore.Name = 'Bookstore';
        Integer randomEmailNumber = (Integer)Math.floor(Math.random() * 9000) + 1000;
        newBookstore.Email__c = 'bookstore' + String.valueOf(randomEmailNumber) + '@gmail.com';
        Integer randomIdentificationCode = (Integer)Math.floor(Math.random() * 90000000) + 10000000;
        newBookstore.Store_Identification_Code__c = String.valueOf(randomIdentificationCode);

        // Generate Id based on simulateInsert
        newBookstore.Id = this.getFakeId(Bookstore__c.SObjectType, simulateInsert);
        return newBookstore;
    }

    /**
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Publisher__c createPublisher(Boolean simulateInsert) {
        Publisher__c newPublisher = new Publisher__c();
        newPublisher.Name = 'publisher';
        newPublisher.Email__c = 'publisher@gmail.com';
        newPublisher.Phone__c = '123214256';

        // Generate Id based on simulateInsert
        newPublisher.Id = this.getFakeId(Publisher__c.SObjectType, simulateInsert);
        return newPublisher;
    }

    /**
     * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
     * @param authorId - Id of an Author__c which is connected through lookup relationship with Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Book__c createBook(Id publisherId, Id authorId, Boolean simulateInsert) {
        Book__c currentBook = new Book__c();
        currentBook.Name = 'book';
        currentBook.Description__c = 'bookdesdc';
        currentBook.ISBN__c = '2141342646';
        currentBook.Language__c = 'english';
        currentBook.Categories__c = 'fantasy';
        currentBook.Price__c = 200;
        currentBook.Publisher__c = publisherId;
        currentBook.Author__c = authorId;
        currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);

        // Generate fake Id
        currentBook.Id = this.getFakeId(Book__c.SObjectType, simulateInsert);
        return currentBook;
    }

    /**
     * Create Book__c record with Paper record type
     * 
     * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
     * @param authorId - Id of an Author__c which is connected through lookup relationship with Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not(This boolean makes sense only if forInsert is false, if you set for Insert to be true, simulateInsert won't take action)
     */
    public Book__c createPaperBook(Id publisherId, Id authorId, Boolean simulateInsert) {
        Book__c currentBook = new Book__c();
        currentBook.recordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Book__c' AND Name = 'Paper Book'][0].Id;
        currentBook.Name = 'book';
        currentBook.Description__c = 'bookdesdc';
        currentBook.ISBN__c = '2141342646';
        currentBook.Language__c = 'english';
        currentBook.Categories__c = 'fantasy';
        currentBook.Price__c = 200;
        currentBook.Print_Length__c = 200;
        currentBook.Publisher__c = publisherId;
        currentBook.Author__c = authorId;
        currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);

        // Generate Id based on simulate insert
        currentBook.Id = this.getFakeId(Book__c.SObjectType, simulateInsert);
        return currentBook;
    }
    
    /**
     * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
     * @param authorId - Id of an Author__c which is connected through lookup relationship with Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Book__c createDigitalBook(Id publisherId, Id authorId, Boolean simulateInsert) {
        Book__c currentBook = new Book__c();
        currentBook.Name = 'Digital book';
        currentBook.Description__c = 'bookdesc';
        currentBook.ISBN__c = '212412535';
        currentBook.Language__c = 'english';
        currentBook.Categories__c = 'fantasy';
        currentBook.Hours_Of_Listening__c = 20;
        currentBook.Price__c = 200;
        currentBook.Publisher__c = publisherId;
        currentBook.Author__c = authorId;
        currentBook.Publish_Date__c = Date.newInstance(2022, 1, 1);
        currentBook.RecordTypeId = Schema.SObjectType.Book__c.getRecordTypeInfosByName()
            .get('Digital Book').getRecordTypeId();

        // Generate Id based on  simulate insert
        currentBook.Id = this.getFakeId(Book__c.SObjectType, simulateInsert);
        return currentBook;
    }   

   /**
     * @param bookId - Id of a Book__c object which is a parent in master-detail relationship to Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Book_Review__c createBookReview(Id bookId, Boolean simulateInsert) {
        Book_Review__c newBookReview = new Book_Review__c();
        newBookReview.Book__c = bookId;
        newBookReview.Name = 'Good book';
        newBookReview.Rating__c = '4';
        
        // Generate Id based on simulate insert
        newBookReview.Id = getFakeId(Book_Review__c.SObjectType, simulateInsert);
        return newBookReview;
    }

    /**
     * @param publisherId - Id of a Publisher__c object which is a parent in master-detail relationship to Book__c
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Author__c createAuthor(Boolean simulateInsert) {
        Author__c newAuthor = new Author__c();
        newAuthor.First_Name__c = 'Author';
        newAuthor.Last_Name__c = 'Test';

        // Generate Id based on simulate insert
        newAuthor.Id = this.getFakeId(Author__c.SObjectType, simulateInsert);
        return newAuthor;
    }

    /**
     * @param authorId - Id of a Author__c which is a parent in master-detail relationship
     * @param publisherId - Id of a Publisher__c which is a parent in master-detail relationship
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Author_Publisher__c createAuthorPublisher(Id authorId, Id publisherId, Boolean simulateInsert) {
        Author_Publisher__c newAuthorPublisher = new Author_Publisher__c();
        newAuthorPublisher.Author__c=authorId;
        newAuthorPublisher.Publisher__c=publisherId;

        // Generate Id based on simulate insert
        newAuthorPublisher.Id = getFakeId(Author_Publisher__c.SObjectType, simulateInsert);
        return newAuthorPublisher;
    }

    /**
     * @param anonymousId - Id of a Author__c object to be set as the standard Anonymous Author record
     * @param unknownId - Id of a Author__c object to be set as the standard Unknown Author record
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Standard_Authors_Settting__c createStandardAuthorsSettting(Id anonymousId, Id unknownId, Boolean simulateInsert) {
        Standard_Authors_Settting__c stdAuthorSetting = new Standard_Authors_Settting__c();
        stdAuthorSetting.Name = 'out of the box author settings';
        stdAuthorSetting.AnonymousId__c=anonymousId;
        stdAuthorSetting.UnknownId__c=unknownId;

        // Generate Id based on simulate insert
        stdAuthorSetting.Id = this.getFakeId(Standard_Authors_Settting__c.SObjectType, simulateInsert);
        return stdAuthorSetting;
    }

    /**
     * @param bookId - Id of the book that was purchased
     * @param simulateInsert - Boolean valure representing if we want fakeId or not
     */
    public Book_Purchase__c createBookPurchase(Id bookId, Boolean simulateInsert) {
        Book_Purchase__c newBookPurchase = new Book_Purchase__c();
        newBookPurchase.Book__c = bookId;

        // Generate Id based on simulate insert
        newBookPurchase.Id = getFakeId(Book_Purchase__c.SObjectType, simulateInsert);
        return newBookPurchase;
    }

    /**
     * Method creates a library user for testing
     */
    public User createLibraryUser(Boolean simulateInsert) {
        Profile p = [SELECT Id FROM Profile WHERE Name='Library User'];
        User user = new User(Alias = 'testuser', Email='testuser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing',
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                          TimeZoneSidKey='America/Los_Angeles', UserName='user12562d53@testorg.com',
                          ProfileId = p.Id);
        return user;
    }
    
    /**
     * Method for creating a new User
     * 
     * @param simulateInsert Boolean valure representing if we want fakeId or not
     */
    public User createUser(Boolean simulateInsert) {
        User newUser = new User();
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        uniqueName = (uniqueName.length() > 51) ? uniqueName.substring(0,51) : uniqueName;
        newUser.Username = uniqueName + '@test' + orgId + '.org';
        newUser.LastName = 'User';
        newUser.Email = 'testuser123@gmail.com';
        newUser.EmailEncodingKey  = 'ISO-8859-1';
        newUser.Alias = 'testuser';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey = 'en_US';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.ProfileId = [SELECT Id FROM Profile WHERE Name=:'Standard User' LIMIT 1].Id;

        // Generate id based on simulate insert
        newUser.Id = this.getFakeId(User.SObjectType, simulateInsert);
        return newUser;
    }

    /**
     * Method for creating a new BookSearchDTO
     * 
     * @param author - Id of the author to search by
     * @param publisher - Id of the publisher to search by
     * @param bookstore - Id of the bookstore to search by
     */
    public BookSearchDTO createBookSearchDTO(Id author, Id publisher, Id bookstore) {
        BookSearchDTO newBookDTO = new BookSearchDTO();
        newBookDTO.name=bookSearchDTODetails.get('name');
        newBookDTO.ISBN=bookSearchDTODetails.get('ISBN');
        newBookDTO.categories=new List<String>{bookSearchDTODetails.get('categories')};
        newBookDTO.languages=new List<String>{bookSearchDTODetails.get('languages')};
        newBookDTO.price=Decimal.valueOf(bookSearchDTODetails.get('price'));
        newBookDTO.reviewScore=Decimal.valueOf(bookSearchDTODetails.get('reviewScore'));
        newBookDTO.term=bookSearchDTODetails.get('term');
        newBookDTO.author=author;
        newBookDTO.publisher=publisher;
        newBookDTO.bookstore=bookstore;
        newBookDTO.publishDate=Date.newInstance(2022, 1, 1);
        
        return newBookDTO;
    }

    /**
     * Creates new Book_Reservation__c for testing
     */
    public Book_Reservation__c createBookReservation(Id bookstoreId, Id bookId, Boolean simulateInsert) {
        Book_Reservation__c newBookReservation = new Book_Reservation__c();
        newBookReservation.Bookstore__c = bookstoreId;
        newBookReservation.Book__c = bookId;
        newBookReservation.Quantity__c = 1;
        newBookReservation.Price__c = 19.99;

        newBookReservation.Id = getFakeId(Book_Reservation__c.SObjectType, simulateInsert);
        return newBookReservation;
    }

}