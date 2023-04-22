import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import BOOKSTORE_NAME_FIELD from '@salesforce/schema/Bookstore__c.Name';
import BOOKSTORE_EMAIL_FIELD from '@salesforce/schema/Bookstore__c.Email__c';
import getBookstoresWithAuthorsBooks from '@salesforce/apex/AuthorController.getBookstoresWithAuthorsBooks';

/**
 * array of columns that are going to be displayed in the lightning datatable
 */
const COLUMNS = [
    { label: 'Bookstore Name', fieldName: BOOKSTORE_NAME_FIELD.fieldApiName, type: 'button',
      typeAttributes: {label: { fieldName: BOOKSTORE_NAME_FIELD.fieldApiName }, name : 'urlredirect', variant: 'base' } },
    { label: 'Bookstore Email', fieldName: BOOKSTORE_EMAIL_FIELD.fieldApiName, type: 'email' }
];

/**
 * Lightning Web Component class used to show all Bookstores that contain certain author's
 * books
 * 
 * @see AccountController.cls
 * @see storesWithAuthorsBooks.html
 * @see Author_Record_Page.flexipage-meta.xml
 */
export default class StoresWithAuthorsBooks extends NavigationMixin (LightningElement) {

    /**
     * Current Author record id
     */
    @api recordId;
    
    /**
     * Variable that will hold the bookstores returned from the Apex method
     */
    bookstores;

    /**
     * Variable that will hold the initialized COLUMNS array
     */
    columns = COLUMNS;


    /**
     * Call the Apex method to get all bookstores with current authors's books
     * and assign the result to bookstores variable
     */
    @wire(getBookstoresWithAuthorsBooks, {authorId: '$recordId'})
    wiredBookstores({data}){
        if(data){
            if(data.length > 0){
                this.bookstores = data;
            }
        }
    }

    /**
     * Handle the action when user clicks on the Bookstore name in the datatable
     * 
     * @param event event that fired the action
     */
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

    /**
     * Call the navigate method for the selected row
     * 
     * @param row currently selected row
     */
    showRowDetails(row){
        this.navigate('standard__recordPage', row.Id, 'Bookstore__c', 'view');
    }

    /**
     * Navigate to certain Lightning Record Page
     * 
     * @param type type of the page to be opened
     * @param recordId id of the record whose page will be opened
     * @param objectApiName object type of the record whose page will be opened
     * @param actionName action which will be taken over the selected record
     */
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