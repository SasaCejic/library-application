import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getBooksNotInBookstore from '@salesforce/apex/BookController.getBooksNotInBookstore';
import ISBN_FIELD from '@salesforce/schema/Book__c.ISBN__c';
import NAME_FIELD from '@salesforce/schema/Book__c.Name';

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

export default class DisplayRecordsInAList extends NavigationMixin(LightningElement) {
    recordId;
    pageRef;
    booksForShow;
    emptyBookList;
    columns = COLUMNS;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if(currentPageReference) {
            this.recordId = currentPageReference.state?.c__recordId;
            console.log(this.recordId);
        }
    }

    @wire(getBooksNotInBookstore, { bookstoreId:'$recordId' })
    wiredBooks(result) {
        if(result.data) {
            if(result.data.length === 0) {
                this.emptyBookList = true;
                this.booksForShow = undefined;
                return;
            }
            //Create new field that will hold the value of bookId, so on click we can be redirected to that book view page
            let proccessedRecords = [];
            result.data.forEach(rec => {
                let currRec = Object.assign({}, rec);
                currRec.linkToDetailView = '/' + currRec.Id;
                proccessedRecords.push(currRec);
            })
            this.booksForShow = proccessedRecords;
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
}
