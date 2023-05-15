import { LightningElement, api, wire, track} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import Id from '@salesforce/user/Id';
import userEmailFIELD from '@salesforce/schema/User.Email';
import BOOK_API_NAME from '@salesforce/schema/Book__c';
import confirmDigitalBookPurchase from '@salesforce/apex/BookController.confirmDigitalBookPurchase';

export default class BuyDigitalBook extends NavigationMixin(LightningElement) {
    bookRecordTypeId;
    bookApiName = BOOK_API_NAME.objectApiName;
    // List that holds objects with label and values for the pickist
    options = [];
    // Price of the book
    price = '';
    // Id of the selected book from picklist
    selectedValue;
    // Name of the selected book from picklist 
    selectedName;
    // Boolean indicating if the component is on record detail page
    isOnViewPage = false;
    // Id of the book record if on detail view page
    _recordId;
    // All books currently searched
    books;
    // Email of the user
    email;
    // Boolean indicating if the email input is loading
    isEmailInputLoading = true;

    // setter
    @api set recordId(value) {
        this._recordId = value;
    }
    
    // getter
    get recordId() {
        return this._recordId;
    }

    @wire(getObjectInfo, { objectApiName: BOOK_API_NAME })
    handleObjectInfo({ error, data }) {
        if (data) {
            const recordTypes = data.recordTypeInfos;
            this.bookRecordTypeId = Object.keys(recordTypes).find(
                (key) => recordTypes[key].name === 'Digital Book'
            );
        } else if (error) {
            this.showToast('Error', 'Error while retrieving book object info')
        }
}

    @wire(CurrentPageReference)
    currentPageReference(currentPageReference) {
        if (currentPageReference) {
            if (currentPageReference.type === 'standard__quickAction') {
                this.isOnViewPage = true;
            }
        }
    }

    /*
     * Gets information about current book record
     * If on detail view page - will result in data and will set the input to fixed value and disable it
     * @param recordId - Id of the record
     */
    @wire(getRecord, { recordId: '$_recordId', layoutTypes: ['Full'] })
    wireRecord(result) {
        if (result.data) {
            console.log(result.data);
            // Format the price to include currency
            this.price = result.data.fields.Price__c.displayValue;
            // Set selected value and name to that of the fetched record
            this.selectedValue = result.data.id;
            this.selectedName = result.data.fields.Name.value;;
        } else if (result.error) {
            this.showToast('Error', 'Error while retrieving book information', 'error');
        }
    }

    /**
     * Gets the details of user currently logged in
     * @param recordId - Id of the user
     * @param fields - list of fields to be retrieved
     */
    @wire(getRecord, { recordId: Id, fields: [userEmailFIELD] })
    wireUserRecord(result) {
        if (result.data) {
            this.email = result.data.fields.Email.value;
            
        } else if (result.error) {
            this.showToast('Error', 'Error while retrieving user information', 'error');
        }
        this.isEmailInputLoading = false;
    }

    /**
     * @param event - div event representing picklist
     */
    handleSelectOption(event) {
        this.recordId = event.detail.value;
    }

    /*
     * If all the information is filled, will call confirmDigitalBookPurchase apex method
     * If successfull will insert purchase record and send email to the user
     * If not succesfull will respond with apropriate message
     */
    handleConfirmBtn() {
        // Do not let user confirm purhcase if they haven't chosen a book or given their mail
        if (!this.selectedValue || !this.email) {
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
            if (err.body.message) {
                this.showToast('Error', err.body.message, 'error');
            } else if (err.body.pageErrors) {
                this.showToast('Error', err.body.pageErrors[0].message, 'error');
            } else {
                this.showToast('Email Limit', 'Email Limit has been reached', 'error');
            }
        }).finally(() => {
            if (error) {
                return;
            }

            // if on detail view page close quick qaciton, if not redirect to book list
            if (this.isOnViewPage) {
                const closeEvent = new CloseActionScreenEvent();
                this.dispatchEvent(closeEvent);
            } else {
                this.redirectToBookPage();
            }
        })
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
        if (this.isOnViewPage) {
            const closeEvent = new CloseActionScreenEvent();
            this.dispatchEvent(closeEvent);
        } else {
            this.redirectToBookPage();
        }
    }

    /**
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

    /**
     * Method used to redriect to book page once the purchase is bought/canceled from list view page
     */
    redirectToBookPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Book__c',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            }
        });
    }
}