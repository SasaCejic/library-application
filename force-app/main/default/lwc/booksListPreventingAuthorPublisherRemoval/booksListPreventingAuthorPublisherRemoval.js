import { api, LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import returnBooksCausingErrorOnAuthPubDel from "@salesforce/apex/BookController.returnBooksCausingErrorOnAuthPubDel";

const COLUMNS = [
    { 
        label: "Book Name",
        fieldName: "linkToBookDetailView",
        type: "url",
        typeAttributes: { label: { fieldName: "bookName" } }
    },
    {
        label: "Publisher Name",
        fieldName: "linkToPublisherDetailView",
        type: "url",
        typeAttributes: { label: { fieldName: "publisherName" } }
    },
    {
        label: "Author Name",
        fieldName: "linkToAuthorDetailView",
        type: "url",
        typeAttributes: { label: { fieldName: "authorName" } }
    }
    ];

export default class BooksListPreventingAuthorPublisherRemoval extends LightningElement {
    // Id of the Author_Publisher__c record that Book__c records for the table are associated with
    @api
    recordId;
    // List of Books__c records that will be displayed in the table
    books = [];
    // Table columns
    columns = COLUMNS;
    // Number of records currently loaded
    currentNumberOfLoadedRecords = 10;
    // Array that holds all the Books__c records retrieved from database
    allBooks = [];
    // Number of Book__c records to be retrieved from the database
    recordLimit = 2000;

    /**
     * @return - True if list is empty and vice versa
     */
    get isListEmpty() {
    return this.books.length < 0;
    }

    /**
     * Method gets Author_Publisher__c record Id from url
     */
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.c__recordId;
        }
  }

    /**
     * @param recordId - Id of the Author_Publisher__c record
     * @param recordLimit - Number of records to be retrieved from database
     * @return - Books__c that would cause the error if the Author_Publisher__c record was to be deleted
     */
    @wire(returnBooksCausingErrorOnAuthPubDel, {
        authorPublisherForDeleteId: "$recordId",
        recordLimit: "$recordLimit"
    })
    wireRecords(result) {
        if (result.data) {
            //Create new field that will hold the value of publisherId, so on click we can be redirected to that publisher view page
            let proccessedRecords = [];
            result.data.forEach((rec) => {
                let currRec = Object.assign({}, rec);

                // Set url link and name for Book__c record
                currRec.bookName = currRec.Name;
                currRec.linkToBookDetailView = "/" + currRec.Id;

                // Set url link and name for Publisher__c record
                currRec.publisherName = currRec.Publisher__r.Name;
                currRec.linkToPublisherDetailView = "/" + currRec.Publisher__c;

                // Set url link and name for Author__c record
                currRec.authorName = currRec.Author__r.Name;
                currRec.linkToAuthorDetailView = "/" + currRec.Author__c;

                proccessedRecords.push(currRec);
            });
            this.allBooks = proccessedRecords;
            this.books = this.allBooks.slice(
                0,
                this.currentNumberOfLoadedRecords - 1
            );
        } else if (result.error) {
        this.showToast("Error", "Error while retrieving Book records", "error");
        }
  }

    /**
     * @param event - Event from onLoad property of Lightning datatable
     */
    loadMoreData(event) {
        const { target } = event;
        target.isLoading = true;
        this.currentNumberOfLoadedRecords += 10;
        this.books = this.allBooks.slice(0, this.currentNumberOfLoadedRecords - 1);

        // Add delay so loading is performed
        setTimeout(() => {
            target.isLoading = false;
        }, 1000);

        // Check if all the records have been loaded
        if (this.books.length === this.allBooks.length) {
            target.enableInfiniteLoading = false;
        }

        //Check if maximum number of loaded records from database has been reached
        if (this.books.length === this.recordLimit) {
            this.showToast(
                "Error",
                "Currently we can not show more records.",
                "error"
            );
        }
    }

    /**
     * @param title - title of toast message
     * @param message - message of toast message
     * @param varian - varian of toast message
     */
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
