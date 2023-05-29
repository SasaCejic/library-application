/**
 * Class separates the books into duplicate and non duplicates
 * Will check for duplicates both in the list and database
 * @return Map holding duplicate and non duplicate books
 */
public with sharing class GetDuplicateBooksService implements CustomObject {
    /**
     * @param bookList - List of books to be separated into duplicates and non duplicates
     */
    public Map<String, List<Book__c>> getDuplicates(List<Book__c> bookList) {
        // Set used to hold book ISBNs without duplicates so we can query the database and see if there are any already inserted
        Set<String> bookISBNs = new Set<String>();
        // List that holds non duplicate records
        List<Book__c> nonDuplicateRecords = new List<Book__c>();
        // List that holds duplicate total all the duplicate records
        List<Book__c> duplicateRecords = new List<Book__c>();
        // List that holds duplicates only from the database
        List<Book__c> duplicatesFromDatabase = new List<Book__c>();
        // Map the holds the response value
        Map<String, List<Book__c>> duplicatesResponse = new Map<String, List<Book__c>>();

        // Store book ISBNs so we can search for the same books from the database
        for (Book__c book : bookList) {
            bookISBNs.add(book.ISBN__c);
        }

        // Search for duplicates in database 
        BookSelector bookSelector = (BookSelector) new ObjectFactory()
            .createObject(BookSelector.class);
        // Append all the duplicate records from database to the list of books from HTTP request
        duplicatesFromDatabase = bookSelector.getListByISBNs(bookISBNs);
        bookList.addAll(duplicatesFromDatabase);

        // Map used to track how many duplicates are there in duplicateRecordsList
        Map<String, Integer> bookCount = new Map<String, Integer>();
        // Loop through duplicate records and set the duplicateCount map value (count the number of each book in the bookList)
        for (Book__c book : bookList) {
            if (!bookCount.containsKey(book.ISBN__c)) {
                bookCount.put(book.ISBN__c, 1);
            } else {
                bookCount.put(book.ISBN__c, bookCount.get(book.ISBN__c) + 1);
            }
        }

        // If the count is larger than 1, meaning there are duplicates, store them in the duplicate list, else in the non duplicate list
        for (Book__c book : bookList) {
            if (bookCount.get(book.ISBN__c) > 1) {
                duplicateRecords.add(book);
            } else {
                nonDuplicateRecords.add(book);
            }
        }

        // Set the response
        duplicatesResponse.put('nonDuplicateRecords', nonDuplicateRecords);
        duplicatesResponse.put('duplicateRecords', duplicateRecords);
        duplicatesResponse.put('duplicatesFromDatabase', duplicatesFromDatabase);
        return duplicatesResponse;
    }
}