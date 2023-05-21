/*
 * Class used to validate if the same review already exists
 * Class will perform 2 validations, First one checks if in the list of new reviews there are 2 same reviews, and will result in an error
 * Other validation will check if in the database there are any reviews that are the same and will result in an error
 */
public with sharing class BookReviewValidationService implements CustomObject {
    /*
     * @param newRecords - records being inserted into the database
     */
    public void validateReview(List<Book_Review__c> newBookReviews) {
        //Set to store all bookIds present in new books
        Set<Id> booksIds = new Set<Id>();
        // Check if in the new added reviews there are 2 same ones(CreatedById is not checked since it is not writeable and can only have the Id of current user)
        // Meaning that there can never be multiple new book reviews at once from different users
        for (Book_Review__c newbookReview : newBookReviews) {
            if (booksIds.contains(newbookReview.Book__c)) {
                newBookReview.addError('You can only leave one review per book!');
                return;
            }
            booksIds.add(newBookReview.Book__c);
        }

        // Now check if there are any same reviews in the database
        BookReviewSelector bookReviewSelector = (BookReviewSelector) new ObjectFactory()
            .createObject(BookReviewSelector.class);
        List<Book_Review__c> allBookReviews = bookReviewSelector.getList();
        for (Book_Review__c newBookReview : newBookReviews) {
            for (Book_Review__c bookReview : allBookReviews) {
                if (newBookReview.Book__c == bookReview.Book__c && UserInfo.getUserId() == bookReview.CreatedById) {
                    newBookReview.addError('You can only leave one review per book!');
                }
            }
        }
    }
}