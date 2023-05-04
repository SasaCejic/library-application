import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
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
    isPublisherListEmpty;
    columns = COLUMNS;
    publishers = [];
    allPublishers = [];
    currentNumberOfLoadedPublishers = 9;
    limit = 5;
    isButtonVisible = true;
    isOnRecordPage = true;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if(currentPageReference) {
            if(currentPageReference.state.c__bookstoreId && this.recordId === undefined) {
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

    @wire(getPublishersNotWorkingWithBookstore, { bookstoreId:'$recordId', recordLimit:'$limit' })
    wiredPublishers(result) {
        if(result.data) {
            if(result.data.length === 0) {
                this.isPublisherListEmpty = true;
                return;
            }
            //Create new field that will hold the value of publisherId, so on click we can be redirected to that publisher view page
            let proccessedRecords = [];
            result.data.forEach(rec => {
                let currRec = Object.assign({}, rec);
                currRec.linkToDetailView = '/' + currRec.Id;
                proccessedRecords.push(currRec);
            })
            this.allPublishers = proccessedRecords;
            this.publishers = this.allPublishers.slice(0, this.currentNumberOfLoadedPublishers - 1)
        } else if(result.error) {
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
                c__bookstoreId:this.recordId
            }
        });
    }

    loadMoreData(event) {
        const { target } = event;
        // Check if we should load more records(depending if we are on a record page or not)
        if(this.isOnRecordPage) {
            target.enableInfiniteLoading = false;
            return;
        }
        target.isLoading = true;
        this.currentNumberOfLoadedPublishers += 10;
        this.publishers = this.allPublishers.slice(0, this.currentNumberOfLoadedPublishers - 1); 
        setTimeout(() => {
            target.isLoading = false;
        }, 1000);
        if(this.publishers.length === this.allPublishers.length) {
            target.enableInfiniteLoading = false;
        }
        //Check if we loaded all records
        if(this.publishers.length === this.limit) {
            const event = new ShowToastEvent({
                title: 'Error while retrieving book information',
                message: 'We can not show more records at this time.',
                variant: 'error'
            });
            this.dispatchEvent(event);
        }
    }
}