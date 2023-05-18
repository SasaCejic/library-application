/**
 * Class returns a list of Bookstore_Book__c records causing the deletion of Bookstore_Publisher__c record with given Id to fail
 */
public with sharing class GetBokstoreBooksCausingPublsherDeletEror implements CustomObject {
    private List<Bookstore_Book__c> response;

    //Getter
    public List<Bookstore_Book__c> getResponse() {
        return this.response;
    }

    //Setter
    public void setResponse(List<Bookstore_Book__c> bookstoreBookList) {
        this.response = bookstoreBookList;
    }

    /**
     * @param bookstorePublisherId - Id of Bookstore_Publisher__c record that is being deleted
     */
    public void getBookstoreBooks(Bookstore_Publisher__c bookstorePublisherForDelete) {
        // Service for retrieving list of Bookstore_Book__c records causing delete to fail
        BookstorePublsherDeleteValidationService service = (BookstorePublsherDeleteValidationService) new ObjectFactory()
            .createObject(BookstorePublsherDeleteValidationService.class);
        service.validateBookstorePublisher(new List<Bookstore_Publisher__c>{ bookstorePublisherForDelete });
        List<Bookstore_Book__c> allBookstoreBooks = service.getResponse();

        // Filter bookstoreBooks to display only first 5 records
        if (allBookstoreBooks.size() > 5) {
            List<Bookstore_Book__c> filteredList = new List<Bookstore_Book__c>();
            for (Integer i = 0; i < 5; i ++) {
                filteredList.add(allBookstoreBooks[i]);
            }
            this.setResponse(filteredList);
        } else {
            this.setResponse(allBookstoreBooks);
        }
    }
}