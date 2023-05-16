/**
 * Book search service class used to hold business logic for the
 * BookController
 * 
 * @see BookController.cls
 * @see BookSelector.cls
 * @see BookSearchDTO.cls
 */
public with sharing class BookSearchService implements CustomObject{
/**
     * List of Aggregate Results containging book information that will be returned to Controller as a response
     */
    private List<AggregateResult> response;

    /**
     * Getter method for response property
     * 
     * @return this class's response property value
     */
    public List<AggregateResult> getResponse() {
        return this.response;
    }

    /**
     * Setter method for response property
     * 
     * @param response List of Aggregate Results containging book information that we want to assign to response field
     */
    public void setResponse(List<AggregateResult> response) {
        this.response = response;
    }

    /**
     * Call BookSelector method to get Aggregate Results containging book information based on query conditions
     * generated from the BookSearchDTO
     * 
     * @param bookSearchDTO object containing all relevant search keys
     * 
     */
    public void getBooksFromSearchDTO(BookSearchDTO bookSearchDTO, Integer limitSize, Integer offset) {
        if (bookSearchDTO == null) {
            this.setResponse(null);
        }
        
        else {
            BookSelector bookSelector = (BookSelector) new ObjectFactory().createObject(BookSelector.class);
            String bookQueryConditions='';
            String bookstoreQueryConditions='';
            
            if (!String.isBlank(bookSearchDTO.name)){
                bookQueryConditions+=String.format('WHERE Name LIKE \'%{0}%\'', new String[] { bookSearchDTO.name.trim() });
            }

            if (!String.isBlank(bookSearchDTO.ISBN)){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }

                else {
                    bookQueryConditions+='WHERE ';
                }
                bookQueryConditions+=String.format('ISBN LIKE \'%{0}%\'', new String[] { bookSearchDTO.ISBN.trim() });
            }

            if (!String.isBlank(bookSearchDTO.author)){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }
                
                else {
                    bookQueryConditions+='WHERE ';
                }
                bookQueryConditions+=String.format('Author__c=\'{0}\'', new String[] { bookSearchDTO.author });
            }

            if (bookSearchDTO.publishDate!=null){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }

                else {
                    bookQueryConditions+='WHERE ';
                }
                String publishDateString=String.format('{0}-{1}-{2}', new String[] {
                    String.valueOf(bookSearchDTO.publishDate.year()), 
                    String.valueOf(bookSearchDTO.publishDate.month()), 
                    String.valueOf(bookSearchDTO.publishDate.day())});
                bookQueryConditions+=String.format('Publish_Date__c={0}', new String[] { publishDateString });
            }

            if (!String.isBlank(bookSearchDTO.bookstore)){
                bookstoreQueryConditions+=String.format(' WHERE Name=\'{0}\'', new String[] { bookSearchDTO.bookstore });
            }

            if (!String.isBlank(bookSearchDTO.publisher)){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }

                else {
                    bookQueryConditions+='WHERE ';
                }
                bookQueryConditions+=String.format('Publisher__c=\'{0}\'', new String[] { bookSearchDTO.publisher });
            }

            if (bookSearchDTO.categories!=null && bookSearchDTO.categories.size()>0){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }

                else {
                    bookQueryConditions+='WHERE ';
                }
                String concatedCategories='';

                for(Integer i=0;i<bookSearchDTO.categories.size();i++){
                    concatedCategories+=bookSearchDTO.categories[i];

                    if (i<bookSearchDTO.categories.size()-1){
                        concatedCategories+=';';
                    }
                }
                bookQueryConditions+=String.format('Categories__c includes (\'{0}\')', new String[] { concatedCategories });
            }

            if (bookSearchDTO.languages!=null && bookSearchDTO.languages.size()>0){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }

                else {
                    bookQueryConditions+='WHERE ';
                }
                String concatedLanguages='';

                for(Integer i=0;i<bookSearchDTO.languages.size();i++){
                    concatedLanguages+='\''+bookSearchDTO.languages[i]+'\'';

                    if (i<bookSearchDTO.languages.size()-1){
                        concatedLanguages+=',';
                    }
                }
                bookQueryConditions+=String.format('Language__c in ({0})', new String[] { concatedLanguages });
            }

/*             if (bookSearchDTO.price!=null){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }

                else {
                    bookQueryConditions+='WHERE ';
                }
                bookQueryConditions+=String.format('Price__c<={0}', new String[] { bookSearchDTO.price });
            } */

            if (!String.isBlank(bookSearchDTO.term)){
                if (!String.isBlank(bookQueryConditions)){
                    bookQueryConditions+=' AND ';
                }

                else {
                    bookQueryConditions+='WHERE ';
                }
                bookQueryConditions+=String.format('Description__c LIKE \'%{0}%\'', new String[] { bookSearchDTO.term.trim() });
            }

            if (bookSearchDTO.reviewScore!=null){
                bookQueryConditions+=' HAVING ';             
                bookQueryConditions+=String.format('AVG(Book_Review__r.Rating__c)reviewScore>{0}', new String[] { String.valueOf(bookSearchDTO.reviewScore.format()) });
            }

            String paginationQueryConditions='';

            if (limitSize!=null && limitSize>0){
                paginationQueryConditions+=String.format(' LIMIT {0}', new String[] { String.valueOf(limitSize) });
            }
            else {
                paginationQueryConditions+='LIMIT 2000';
            }

            if (offset!=null && offset>0){
                paginationQueryConditions+=String.format(' OFFSET {0}', new String[] { String.valueOf(offset) });
            }
            
            this.setResponse(BookSelector.getAggregateResultFromQueryConditions(bookQueryConditions, bookstoreQueryConditions,paginationQueryConditions));
        }
    }
}