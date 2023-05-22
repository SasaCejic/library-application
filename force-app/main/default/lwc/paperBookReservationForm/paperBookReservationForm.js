import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import LightningConfirm from 'lightning/confirm';
import getBookById from '@salesforce/apex/BookController.getBookById';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import BOOK_RESERVATION_OBJECT from '@salesforce/schema/Book_Reservation__c';

export default class PaperBookReservationForm extends NavigationMixin(LightningElement) {
    @api recordId;
    bookId = '';
    selectedBook;
    @track objectFields;

    @wire(getObjectInfo, { objectApiName: BOOK_RESERVATION_OBJECT })
    wiredObjectInfo({error, data}){
        if (data) {
            this.objectFields = [];
            const fieldMetadata = data.fields;
            for (let fieldApiName in fieldMetadata) {
                if (fieldMetadata.hasOwnProperty(fieldApiName)) {
                    const field = fieldMetadata[fieldApiName];
                    if (field.createable && field.required) {
                        if (field.apiName == 'Book__c') {
                            this.objectFields.push({apiName : field.apiName, canBeDisabled : true});
                        } else {
                            this.objectFields.push({apiName : field.apiName, canBeDisabled: false});
                        }
                    }
                }
            }
        } else if (error) {
            this.objectFields = undefined;
        }
    }

    @wire(getBookById, {bookId: '$bookId'})
    wiredBook({data, error}){
        if(data){
            this.selectedBook = data;
        }
    }

    

    async onSubmitHandler (event) {
        event.preventDefault();
        const fields = event.detail.fields;
        this.bookId = fields.Book__c;

        const result = await LightningConfirm.open({
            message:`Book: ${this.selectedBook.Name},    Total Price: ${this.selectedBook.Price__c * fields.Quantity__c},    Quantity: ${fields.Quantity__c}`,
            variant: 'headerless',
            label: 'Book Reservation',
        });

        if (result) {
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }
    }

    closeForm (event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showSuccessMessage (event) {
        this.toast('Success', 'Book reservation has been made successfully!', 'success', 'dismissable');
        this.closeForm(event);
        this.navigate('standard__recordPage', event.detail.id, 'Book_Reservation__c', 'view');
    }

    navigate(type, recordId, objectApiName, actionName){
        this[NavigationMixin.Navigate]({
            type: type,
            attributes:{
                recordId: recordId,
                objectApiName: objectApiName,
                actionName: actionName
            }
        });
    }

    toast (title, message, variant, mode) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant,
                mode: mode
            })
        );
    }
}