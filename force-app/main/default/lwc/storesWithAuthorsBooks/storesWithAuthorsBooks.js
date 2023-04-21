import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import BOOKSTORE_NAME_FIELD from '@salesforce/schema/Bookstore__c.Name';
import BOOKSTORE_EMAIL_FIELD from '@salesforce/schema/Bookstore__c.Email__c';
import getBookstoresWithAuthorsBooks from '@salesforce/apex/AuthorController.getBookstoresWithAuthorsBooks';

const COLUMNS = [
    { label: 'Bookstore Name', fieldName: BOOKSTORE_NAME_FIELD.fieldApiName, type: 'button',
      typeAttributes: {label: { fieldName: BOOKSTORE_NAME_FIELD.fieldApiName }, name : 'urlredirect', variant: 'base' } },
    { label: 'Bookstore Email', fieldName: BOOKSTORE_EMAIL_FIELD.fieldApiName, type: 'email' }
];

export default class StoresWithAuthorsBooks extends NavigationMixin (LightningElement) {
    @api recordId;
    bookstores;
    columns = COLUMNS;

    @wire(getBookstoresWithAuthorsBooks, {authorId: '$recordId'})
    wiredBookstores({data}){
        if(data){
            if(data.length > 0){
                this.bookstores = data;
            }
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'urlredirect':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    showRowDetails(row){
        this.navigate('standard__recordPage', row.Id, 'Bookstore__c', 'view');
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
}