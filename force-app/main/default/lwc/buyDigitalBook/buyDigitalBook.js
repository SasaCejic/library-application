import { LightningElement, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import userEmailFIELD from '@salesforce/schema/User.Email';
import getDigitalBooks from '@salesforce/apex/BookController.getDigitalBooks';
import confirmDigitalBookPurchase from '@salesforce/apex/BookController.confirmDigitalBookPurchase';

export default class BuyDigitalBook extends LightningElement {
    // List that holds objects with label and values for the pickist
    options = [];
    // Calue of the search input
    searchValue = '';
    // Price of the book
    price = '';
    // Id of the selected book from picklist
    selectedValue;
    // Name of the selected book from picklist 
    selectedName;
    // Boolean indicating if the component is on detail view page
    isOnViewPage = false;
    // Id of the book record if on detail view page
    _recordId;
    // All books currently searched
    books;
    // Email of the user
    email;
    
    //setter
    @api set recordId(value) {
        this._recordId = value;
    }
    
    //getter
    get recordId() {
        return this._recordId;
    }

    /*
     * Gets information about current book record
     * If on detail view page - will result in data and will set the input to fixed value and disable it
     * @param recordId - Id of the record
     */
    @wire(getRecord, { recordId: '$_recordId', layoutTypes: ['Full'] })
    wireRecord(result) {
        if(result.data) {
            this.isOnViewPage = true;
            this.searchValue = result.data.fields.Name.value;
            this.price = result.data.fields.Price__c.value;
            this.selectedValue = result.data.id;
            this.selectedName = this.searchValue;
        }
        if(result.error) {
            this.showToast('Error', 'Error while retrieving book information', 'error');
        }
    }

    /*
     * Apex method that triggers every time searchValue is changed
     * Returns books which names correspond to searched value
     * @param searchValue - value in the input field
     */
    @wire(getDigitalBooks, { searchTerm: '$searchValue' })
    wireDigitalBooks(result) {
        if(result.data) {
            this.books = result.data;
            this.options = [];
            result.data.forEach(book => {
                this.options.push({
                    label: book.Name,
                    value: book.Id
                })
            })
        } else if (result.error) {
            this.showToast('Error', 'Error while retrieving user books information', 'error');
        }
    }

    /*
     * Gets the details of user currently logged in
     * @param recordId - Id of the user
     * @param fields - list of fields to be retrieved
     */
    @wire(getRecord, { recordId: Id, fields: [userEmailFIELD] })
    wireUserRecord(result) {
        if(result.data) {
            this.email = result.data.fields.Email.value;
        } else if(result.error) {
            this.showToast('Error', 'Error while retrieving user information', 'error');
        }
    }
    
    /*
     * Catches event from comboboxAutoComplete component
     * @param event - Value of the picklist from ComboboxAutocomplete
     */
    handleSelectOption(event) {
        this.selectedValue = event.detail.value;
        this.selectedName = event.detail.label;
        this.books.forEach(book => {
            if(book.Id === this.selectedValue) {
                this.price = book.Price__c;
            }
        })
    }

    /*
     * If all the information is filled, will call confirmDigitalBookPurchase apex method
     * If successfull will insert purchase record and send email to the user
     * If not succesfull will respond with apropriate message
     */
    handleConfirmBtn() {
        // Do not let user confirm purhcase if they haven't chosen a book or given their mail
        if(!this.selectedValue || !this.email) {
            this.showToast('Error', 'Please fill all the information needed.', 'error');
            return;
        }
        let error = false;
        // Apex call
        confirmDigitalBookPurchase({ emailAddress: this.email, bookName: this.selectedName, bookPrice: this.price, bookId: this.selectedValue }).then(() => {
            this.showToast('Email Confirmation', 'Email has been sent to your address with information about purchase', 'success');
        }).catch((err) => {
            // Handle different type of errors
            error = true;
            if(err.body.message) {
                this.showToast('Error', err.body.message, 'error');
            } else if(err.body.pageErrors) {
                this.showToast('Error', err.body.pageErrors[0].message, 'error');
            } else {
                this.showToast('Email Limit', 'Email Limit has been reached', 'error');
            }
        }).finally(() => {
            if(error) {
                return;
            }
            const closeEvent = new CloseActionScreenEvent();
            this.dispatchEvent(closeEvent);
        })
    }

    /*
     * Sets the search value to the value of the input field
     * @param event - event propagated from ComboboxAutoComplete component that holds value of the input
     */
    handleSearch(event) {
        this.searchValue = event.detail.searchTerm;
    }

    /*
     * Sets the value of the email to the value of the email input field
     */
    handleEmailInput(event) {
        this.email = event.target.value;
    }
    
    /*
     * Closes the screen
     */
    handleCancelBtn() {
        const closeEvent = new CloseActionScreenEvent();
        this.dispatchEvent(closeEvent);
    }

    /*
     * @param title - title of toast message
     * @param message - message of toast message
     * @param varian - varian of toast message
    */
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}