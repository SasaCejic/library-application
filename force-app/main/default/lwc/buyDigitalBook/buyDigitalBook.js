import { LightningElement, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import userEmailFIELD from '@salesforce/schema/User.Email';
import getDigitalBooks from '@salesforce/apex/BookController.getDigitalBooks';
import sendPurchaseMailConfirmation from '@salesforce/apex/BookController.sendPurchaseMailConfirmation';

export default class BuyDigitalBook extends LightningElement {
    options = [];
    searchValue;
    selectedValue;
    price;
    _recordId;
    books;
    email;

    @api set recordId(value) {
        this._recordId = value;
    }

    get recordId() {
        return this._recordId;
    }

    @wire(getRecord, { recordId:'$_recordId', layoutTypes: ['Full'] })
    wireRecord(result) {
        if(result) {
            this.searchValue = result.data? result.data.fields['Name'].value : '';
            this.price = result.data? result.data.fields['Price__c'].value : '';
        }
    }

    @wire(getDigitalBooks, {searchTerm: '$searchValue'})
    wireDigitalBooks(result) {
        if(result.data) {
            this.books = result.data;
            this.options = [];
            result.data.forEach(book => {
                this.options.push({
                    label: book['Name'],
                    value: book['Id']
                })
            })
        }
    }

    @wire(getRecord, {recordId: Id, fields: [userEmailFIELD]})
    wireUserRecord(result) {
        if(result.data) {
            this.email = result.data.fields.Email.value;
        }
    }

    handleSelectOption(event) {
        const value = event.detail.value;
        this.selectedValue = value;
        this.books.forEach(book => {
            if(book['Id'] === value) {
                this.price = book['Price__c']
            }
        })
    }

    handleConfirmBtn() {
        if(!this.selectedValue) {
            return;
        }
    }

    handleSearch(event) {
        this.searchValue = event.detail.searchTerm;
    }

    handleCancelBtn() {
        const closeEvent = new CloseActionScreenEvent();
        this.dispatchEvent(closeEvent);
    }
}