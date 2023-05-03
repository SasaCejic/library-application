import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
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
    emptyBookList;
    columns = COLUMNS;
    booksForShow;

    //If the Id of the bookstore manager matches, currently logged in user
    @wire(getRecord, { recordId:'$recordId', fields:[MANAGER_FIELD] })
    wiredBookstore(result) {
        if(result.data) {
            if(USER_ID == result.data.fields.Manager__c.value) {
                this.isManagerToBookstore = true;
            }
        } else if(result.error) {
            this.isManagerToBookstore = false;
            const event = new ShowToastEvent({
                title: 'Error while retrieving bookstore information',
                message: result.error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        }
    }

    @wire(getBooksNotInBookstore, { bookstoreId:'$recordId' })
    wiredBooks(result) {
        if(result.data) {
            if(result.data.length === 0) {
                this.emptyBookList = true;
                this.allBooks = undefined;
                return;
            }
            //Create new field that will hold the value of bookId, so on click we can be redirected to that book view page
            let proccessedRecords = [];
            result.data.forEach(rec => {
                let currRec = Object.assign({}, rec);
                currRec.linkToDetailView = '/' + currRec.Id;
                proccessedRecords.push(currRec);
            })
            this.booksForShow = proccessedRecords.slice(0,3);
        } else if(result.error) {
            this.books = undefined;
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
                c__recordId:this.recordId
            }
        });
    }
}