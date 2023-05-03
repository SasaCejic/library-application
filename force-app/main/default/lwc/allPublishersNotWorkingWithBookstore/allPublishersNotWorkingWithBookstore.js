import { LightningElement, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getPublishersNotWorkingWithBookstore from '@salesforce/apex/PublisherController.getPublishersNotWorkingWithBookstore';
import PHONE_FIELD from '@salesforce/schema/Publisher__c.Phone__c';
import NAME_FIELD from '@salesforce/schema/Publisher__c.Name';

const COLUMNS = [
    {
        label:'Book Name',
        fieldName:'linkToDetailView',
        type:'url',
        typeAttributes:{ label:{ fieldName:NAME_FIELD.fieldApiName } }
    },
    {
        label:'Phone',
        fieldName:PHONE_FIELD.fieldApiName,
        type:'text'
    }
]

export default class DisplayRecordsInAList extends NavigationMixin(LightningElement) {
    recordId;
    pageRef;
    publishersForShow;
    publisherEmptyList;
    columns = COLUMNS;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if(currentPageReference) {
            this.recordId = currentPageReference.state?.c__recordId;
        }
    }

    @wire(getPublishersNotWorkingWithBookstore, { bookstoreId:'$recordId' })
    wiredBooks(result) {
        if(result.data) {
            if(result.data.length === 0) {
                this.publisherEmptyList = true;
                this.publishersForShow = undefined;
                return;
            }
            //Create new field that will hold the value of bookId, so on click we can be redirected to that book view page
            let proccessedRecords = [];
            result.data.forEach(rec => {
                let currRec = Object.assign({}, rec);
                currRec.linkToDetailView = '/' + currRec.Id;
                proccessedRecords.push(currRec);
            })
            this.publishersForShow = proccessedRecords;
        } else if(result.error) {
            this.publishersForShow = undefined;
            const event = new ShowToastEvent({
                title: 'Error while retrieving publisher information',
                message: result.error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        } 
    }
}
