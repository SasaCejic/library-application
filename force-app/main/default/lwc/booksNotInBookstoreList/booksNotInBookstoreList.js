import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import getBooksNotInBookstore from '@salesforce/apex/BookController.getBooksNotInBookstore';
import NAME_FIELD from '@salesforce/schema/Book__c.Name';
import MANAGER_FIELD from '@salesforce/schema/Bookstore__c.Manager__c';
import ISBN_FIELD from '@salesforce/schema/Book__c.ISBN__c';
import USER_ID from '@salesforce/user/Id';

const COLUMNS = [
    {
        label:'Book Name',
        fieldName:'linkToDetailView',
        type:'url',
        typeAttributes:{ label:{ fieldName:NAME_FIELD.fieldApiName } }
    },
    {
        label:'ISBN',
        fieldName:ISBN_FIELD.fieldApiName,
        type:'text'
    }
]

export default class BooksNotInBookstoreList extends NavigationMixin(LightningElement) {
    @api recordId;
    isManagerToBookstore;
    isBookListEmpty;
    columns = COLUMNS;
    books = [];
    allBooks = [];
    limit = 5;
    isButtonVisible = true;
    currrentNumberOfLoadedBooks = 10;
    isOnRecordPage = true;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            if (currentPageReference.state.c__bookstoreId && this.recordId === undefined) {
                this.recordId = currentPageReference.state.c__bookstoreId
                this.limit = 2000;
                this.isButtonVisible = false;
                this.isOnRecordPage = false;
            }
        }
    }

    //If the Id of the bookstore manager matches, currently logged in user
    @wire(getRecord, { recordId:'$recordId', fields:[MANAGER_FIELD] })
    wiredBookstore(result) {
        if (result.data) {
            if (USER_ID == result.data.fields.Manager__c.value) {
                this.isManagerToBookstore = true;
            }
        } else if (result.error) {
            this.isManagerToBookstore = false;
            const event = new ShowToastEvent({
                title: 'Error while retrieving bookstore information',
                message: result.error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        }
    }

    @wire(getBooksNotInBookstore, { bookstoreId:'$recordId', recordLimit:'$limit' })
    wiredBooks(result) {
        if (result.data) {
            if (result.data.length === 0) {
                this.isBookListEmpty = true;
                return;
            }
            //Create new field that will hold the value of bookId, so on click we can be redirected to that book view page
            let proccessedRecords = [];
            result.data.forEach(rec => {
                let currRec = Object.assign({}, rec);
                currRec.linkToDetailView = '/' + currRec.Id;
                proccessedRecords.push(currRec);
            })
            this.allBooks = proccessedRecords;
            this.books = proccessedRecords.slice(0, this.currrentNumberOfLoadedBooks - 1);
        } else if (result.error) {
            const event = new ShowToastEvent({
                title: 'Error while retrieving book information',
                message: result.error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        } 
    }

    viewAllButtonClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Books_not_in_bookstore'
            },
            state: {
                c__bookstoreId:this.recordId
            }
        });
    }

    loadMoreData(event) {
        const { target } = event;
        // Check if we should load more records(depending if we are on a record page or not)
        if (this.isOnRecordPage) {
            target.enableInfiniteLoading = false;
            return;
        }
        target.isLoading = true;
        this.currrentNumberOfLoadedBooks += 10;
        this.books = this.allBooks.slice(0, this.currrentNumberOfLoadedBooks - 1); 
        setTimeout(() => {
            target.isLoading = false;
        }, 1000);
        //Check if we loaded all records
        if (this.books.length === this.allBooks.length) {
            target.enableInfiniteLoading = false;
        }
        // check if we reached the limit of records to be retrieved from database
        if (this.books.length === this.limit) {
            const event = new ShowToastEvent({
                title: 'Error while retrieving book information',
                message: 'We can not show more records at this time.',
                variant: 'error'
            });
            this.dispatchEvent(event);
        }
    }
}