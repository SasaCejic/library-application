import { LightningElement, wire, api } from 'lwc';
import BOOKSTORE_NAME_FIELD from '@salesforce/schema/Bookstore__c.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/Bookstore__c.Description__c';
import getStoresWithAuthorsBooks from '@salesforce/apex/BookstoreController.getStoresWithAuthorsBooks';

const COLUMNS = [
    { label: 'Bookstore Name', fieldName: BOOKSTORE_NAME_FIELD.fieldApiName, type: 'text'},
    { label: 'Description', fieldName: DESCRIPTION_FIELD.fieldApiName, type: 'text'}
];

export default class StoresWithAuthorsBooks extends LightningElement {
    @api recordId;
    bookstores = [];
    columns = COLUMNS;

    @wire(getStoresWithAuthorsBooks)
    wiredBookstores({data}){
        if(data){
            this.bookstores = data;
        }
    }
}