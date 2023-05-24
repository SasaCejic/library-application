/**
 * Book search service class used to hold business logic for the
 * BookController
 * 
 * @see BookController.cls
 * @see BookSelector.cls
 * @see BookReviewSelector.cls
 * @see BookSearchDTO.cls
 */
public with sharing class BookSearchService implements CustomObject{
    /**
     * List of Books containging book information that will be returned to Controller as a response
     */
    private List<Book__c> response;

    /**
     * Getter method for response property
     * 
     * @return this class's response property value
     */
    public List<Book__c> getResponse() {
        return this.response;
    }

    /**
     * Setter method for response property
     * 
     * @param response List of Books containging book information that we want to assign to response field
     */
    public void setResponse(List<Book__c> response) {
        this.response = response;
    }

    /**
     * Returns conjunction (WHERE/AND) to append to query conditions depending on weather WHERE clause was already started or not
     * 
     * @param queryConditions - Query conditions the conjunction is getting appended to
     */
    public String getQueryConjunction(String queryConditions){
        if (!String.isBlank(queryConditions)){
            return ' AND ';
        }

        else {
            return 'WHERE ';
        }
    }

    /**
     * Generates query conditions based on recieved bookSearchDTO
     * Calls BookSelector method to get a list of book information based on these query conditions
     * Further filters book list by description term and minimum review score if they are set as search keys
     * Sets response property to searched and filtered book list
     * 
     * @param bookSearchDTO - Object containing all relevant search keys
     * @param limitSize - Maximum number of records to return
     * @param offset - Offset for querying records
     * 
     */
    public void getBooksFromSearchDTO(BookSearchDTO bookSearchDTO, Integer limitSize, Integer offset) {
        if (bookSearchDTO == null) {
            this.setResponse(null);
        }
        
        else {
            BookSelector bookSelector = (BookSelector) new ObjectFactory().createObject(BookSelector.class);
            BookReviewSelector bookReviewSelector = (BookReviewSelector) new ObjectFactory().createObject(BookReviewSelector.class);
            String bookQueryConditions='';
            
            if (!String.isBlank(bookSearchDTO.name)){
                bookQueryConditions+=String.format('WHERE Name LIKE \'%{0}%\'', new String[] { bookSearchDTO.name.trim() });
            }

            if (!String.isBlank(bookSearchDTO.ISBN)){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                bookQueryConditions+=String.format('ISBN__c LIKE \'%{0}%\'', new String[] { bookSearchDTO.ISBN.trim() });
            }

            if (!String.isBlank(bookSearchDTO.author)){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                bookQueryConditions+='Author__c=\''+bookSearchDTO.author+'\'';
            }

            if (bookSearchDTO.publishDate!=null){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                //Creates DateTime from Date object to enable custom formatting
                Datetime publishDateTime=Datetime.newInstance(
                    bookSearchDTO.publishDate.year(),
                    bookSearchDTO.publishDate.month(),
                    bookSearchDTO.publishDate.day()
                );
                bookQueryConditions+=String.format('Publish_Date__c={0}', new String[] { publishDateTime.format('yyyy-MM-dd') });
            }

            if (!String.isBlank(bookSearchDTO.bookstore)){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                bookQueryConditions+='Id IN (SELECT Book__c FROM Bookstore_Book__c WHERE Bookstore__c= \''+bookSearchDTO.bookstore+'\' )';
            }

            if (!String.isBlank(bookSearchDTO.publisher)){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                bookQueryConditions+='Publisher__c=\''+bookSearchDTO.publisher+'\'';
            }

            if (bookSearchDTO.categories!=null && bookSearchDTO.categories.size()>0){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                String concatedCategories='';

                //Concats categories from an array to a string form suitable for an SOQL query
                for(Integer i=0;i<bookSearchDTO.categories.size();i++){
                    concatedCategories+=bookSearchDTO.categories[i];

                    if (i<bookSearchDTO.categories.size()-1){
                        concatedCategories+=';';
                    }
                }
                bookQueryConditions+=String.format('Categories__c includes (\' {0} \')', new String[] { concatedCategories });
            }

            if (bookSearchDTO.languages!=null && bookSearchDTO.languages.size()>0){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                String concatedLanguages='';

                //Concats languages from an array to a string form suitable for an SOQL query
                for(Integer i=0;i<bookSearchDTO.languages.size();i++){
                    concatedLanguages+='\''+bookSearchDTO.languages[i]+'\'';

                    if (i<bookSearchDTO.languages.size()-1){
                        concatedLanguages+=',';
                    }
                }
                bookQueryConditions+=String.format('Language__c in ({0})', new String[] { concatedLanguages });
            }

            if (bookSearchDTO.price!=null && bookSearchDTO.price>0){
                bookQueryConditions+= getQueryConjunction(bookQueryConditions);
                bookQueryConditions+=String.format('Price__c<={0}', new String[] { bookSearchDTO.price.format() });
            }

            if (limitSize!=null && limitSize>0){
                bookQueryConditions+=String.format(' LIMIT {0}', new String[] { String.valueOf(limitSize) });
            }
            
            else {
                bookQueryConditions+=' LIMIT 2000';
            }

            if (offset!=null && offset>0){
                bookQueryConditions+=String.format(' OFFSET {0}', new String[] { String.valueOf(offset) });
            }

            //queries books as a list 
            List<Book__c> searchedAndFilteredBooks=bookSelector.getListFromQueryConditions(bookQueryConditions);

            /**
             * If minimum review score set as search key, makes map of queried books
             * The keyset of that map is used as a parameter for the getAverageRatingListByBookIdSet method of the bookReviewSelector
             */
            if (bookSearchDTO.reviewScore!=null && bookSearchDTO.reviewScore>0){
                Map<Id, Book__c> searchedBookMap = new Map<Id, Book__c>(searchedAndFilteredBooks);
                List<AggregateResult> averageRatigsList = bookReviewSelector.getAverageRatingListByBookIdSet(searchedBookMap.keySet());
                List<Book__c> booksWithPassingReview = new List<Book__c>();

                //For each average review score, if it matches search criteria, adds the associated book to a filtered list
                for (AggregateResult averageRating:averageRatigsList){

                    if ((Decimal)averageRating.get('Rating')>=bookSearchDTO.reviewScore){
                        booksWithPassingReview.add(searchedBookMap.get((Id)averageRating.get('Book__c')));
                    }
                }
                searchedAndFilteredBooks=booksWithPassingReview;
            }

            //If term set as search key, filters existing book list to contain only books whose decriptions contain the term
            if (!String.isBlank(bookSearchDTO.term)){
                List<Book__c> booksWithMatchingDescription = new List<Book__c>();

                for (Book__c book:searchedAndFilteredBooks){

                    if (book.Description__c.toLowerCase().contains( bookSearchDTO.term.trim().toLowerCase() )){
                        booksWithMatchingDescription.add(book);
                    }
                }
                searchedAndFilteredBooks=booksWithMatchingDescription;
            }

            this.setResponse(searchedAndFilteredBooks);
        }
    }
}