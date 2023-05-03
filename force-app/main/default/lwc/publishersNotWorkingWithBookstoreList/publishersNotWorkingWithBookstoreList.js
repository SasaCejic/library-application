import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getPublishersNotWorkingWithBookstore from '@salesforce/apex/PublisherController.getPublishersNotWorkingWithBookstore';
import NAME_FIELD from '@salesforce/schema/Publisher__c.Name';
import MANAGER_FIELD from '@salesforce/schema/Bookstore__c.Manager__c';
import PHONE_FIELD from '@salesforce/schema/Publisher__c.Phone__c';
import USER_ID from '@salesforce/user/Id';

const COLUMNS = [
    {
        label:'Publisher Name',
        fieldName:'linkToDetailView',
        type:'url',
        typeAttributes:{ label:{ fieldName:NAME_FIELD.fieldApiName } }
    },
    {
        label:'Phone',
        fieldName:PHONE_FIELD.fieldApiName,
        type:'text',
    }
]

export default class BooksNotInBookstoreList extends NavigationMixin(LightningElement) {
    @api recordId;
    isManagerToBookstore;
    emptyPublishers;
    columns = COLUMNS;
    publishers;
    
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

    @wire(getPublishersNotWorkingWithBookstore, { bookstoreId:'$recordId' })
    wiredPublishers(result) {
        if(result.data) {
            if(result.data.length === 0) {
                this.emptyPublishers = true;
                this.publishers = undefined;
                return;
            }
            //Create new field that will hold the value of publisherId, so on click we can be redirected to that publisher view page
            let proccessedRecords = [];
            result.data.forEach(rec => {
                let currRec = Object.assign({}, rec);
                currRec.linkToDetailView = '/' + currRec.Id;
                proccessedRecords.push(currRec);
            })
            this.publishers = proccessedRecords.slice(0,3);
        } else if(result.error) {
            this.books = undefined;
            const event = new ShowToastEvent({
                title: 'Error while retrieving publisher information',
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
                apiName: 'Publishers_not_working_with_bookstore'
            },
            state: {
                c__recordId:this.recordId
            }
        });
    }
}