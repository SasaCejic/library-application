import { api, LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import returnBookstoreBooksCausingErrorOnPublisherDelete from '@salesforce/apex/BookstoreBookController.returnBookstoreBooksCausingErrorOnPublisherDelete';

const COLUMNS = [
    {
        label: 'Book Name',
        fieldName: 'linkToBookDetailView',
        type: 'url',
        typeAttributes: { label: { fieldName: 'bookName' } }
    },
    {
        label: 'Publisher Name',
        fieldName: 'linkToPublisherDetailView',
        type: 'url',
        typeAttributes: { label: { fieldName: 'publisherName' } }
    },
    {
        label: 'Bookstore Name',
        fieldName: 'linkToBookstoreDetailView',
        type: 'url',
        typeAttributes: { label: { fieldName: 'bookstoreName' } }
    }
]

export default class BookstoreBooksListPreventingPublisherRemoval extends LightningElement {
    // Id of the Bookstore_Publisher__c record that Bookstore_Book__c records for the table are associated with
    @api
    recordId;
    // List of Bookstore_Books__c records that will be displayed in the table
    bookstoreBooks = [];
    // Table columns
    columns = COLUMNS;
    // Number of records currently loaded
    currentNumberOfLoadedRecords = 9;
    // Array that holds all the Bookstore_Books__c records retrieved from database
    allBookstoreBooks = [];
    // Number of Bookstore__Book__c records to be retrieved from the database
    recordLimit = 2000;

    /**
     * @return - True if list is empty and vice versa
     */
    get isListEmpty() {
        return this.bookstoreBooks.length < 0;
    }

    /**
     * Method gets Bookstore_Publisher__c record Id from url
     */
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.c__recordId;
        }
    }

    /**
     * @param recordId - Id of the Bookstore_Publisher__c record
     * @param recordLimit - Number of records to be retrieved from database
     * @return - Bookstore_Books__c that would cause the error if the Bookstore_Publisher__c record was to be deleted
     */
    @wire(returnBookstoreBooksCausingErrorOnPublisherDelete, { bookstorePublisherForDeleteId: '$recordId', recordLimit: '$recordLimit' })
    wireRecords(result) {
        if (result.data) {
            //Create new field that will hold the value of publisherId, so on click we can be redirected to that publisher view page
            let proccessedRecords = [];
            result.data.forEach(rec => {
                let currRec = Object.assign({}, rec);

                // Set url link and name for Book__c record
                currRec.bookName = currRec.Book__r.Name;
                currRec.linkToBookDetailView = '/' + currRec.Book__c;
                
                // Set url link and name for Publisher__c record
                currRec.publisherName = currRec.Book__r.Publisher__r.Name;
                currRec.linkToPublisherDetailView = '/' + currRec.Book__r.Publisher__c;

                // Set url link and name for Bookstore__c record
                currRec.bookstoreName = currRec.Bookstore__r.Name;
                currRec.linkToBookstoreDetailView = '/' + currRec.Bookstore__c;

                proccessedRecords.push(currRec);
            })
            this.allBookstoreBooks = proccessedRecords;
            this.bookstoreBooks = this.allBookstoreBooks.slice(0, this.currentNumberOfLoadedRecords - 1);
        } else if (result.error) {
            this.showToast('Error', 'Error while retrieving Bookstore Book records', 'error');
        }
    }

    /**
     * @param event - Event from onLoad property of Lightning datatable
     */
    loadMoreData(event) {
        const { target } = event;
        target.isLoading = true;
        this.currentNumberOfLoadedRecords += 10;
        this.bookstoreBooks = this.allBookstoreBooks.slice(0, this.currentNumberOfLoadedRecords - 1);

        // Add delay so loading is performed
        setTimeout(() => {
            target.isLoading = false;
        }, 1000);

        // Check if all the records have been loaded
        if (this.bookstoreBooks.length === this.allBookstoreBooks.length) {
            target.enableInfiniteLoading = false;
        }

        //Check if maximum number of loaded records from database has been reached
        if (this.bookstoreBooks.length === this.recordLimit) {
            this.showToast('Error', 'Currently we can not show more records.', 'error')
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