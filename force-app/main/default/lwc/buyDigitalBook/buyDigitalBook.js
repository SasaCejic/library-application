import { LightningElement, api, wire, track} from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import userEmailFIELD from '@salesforce/schema/User.Email';
import confirmDigitalBookPurchase from '@salesforce/apex/BookController.confirmDigitalBookPurchase';
import getOrganizationDefaultCurrency from '@salesforce/apex/OrganizationController.getOrganizationDefaultCurrency';
import searchDigitalBooks from '@salesforce/apex/BookController.searchDigitalBooks';

export default class BuyDigitalBook extends NavigationMixin(LightningElement) {
    // List that holds objects with label and values for the pickist
    options = [];
    // Value of the search input
    searchValue = '';
    // Price of the book
    price = '';
    // Id of the selected book from picklist
    selectedValue;
    // Name of the selected book from picklist 
    selectedName;
    // Boolean indicating if the component is on detail view page
    isOnViewPage = true;
    // Id of the book record if on detail view page
    _recordId;
    // All books currently searched
    books;
    // Email of the user
    email;
    // default currency of the org
    defaultCurrency;
    // Boolean indicating if input is focused
    isFocussed = false;
    // Boolean indicating if picklist is open
    isOpen = false;
    // Boolean indicating if the picklist is loading
    isPicklistLoading = true;
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

    /*
     * Returns the type of input depending if it is on detail view page or not
     */
    get isSearchInput() {
        return this.isOnViewPage? '' : 'Search'; 
    }

    /*
     * Returns true if there are no options to display
     */
    get noOptions() {
    return this.options.length === 0;
    }

    /*
     * Returns classes depending if picklis is open or not
     */
    get dropdownClasses() {
        let dropdownClasses = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        // Show dropdown list on focus
        if (this.isOpen) {
            dropdownClasses += ' slds-is-open';
        }
        return dropdownClasses;
    }

    /*
     * Returns organization default currency
     */
    renderedCallback() {
        this.getCurrency();
        this.isOnViewPage = this.recordId? true : false;
    }

    /*
     * Gets information about current book record
     * If on detail view page - will result in data and will set the input to fixed value and disable it
     * @param recordId - Id of the record
     */
    @wire(getRecord, { recordId: '$_recordId', layoutTypes: ['Full'] })
    wireRecord(result) {
        if (result.data) {
            // Set default search value to that of the record fetched
            this.searchValue = result.data.fields.Name.value;
            // Format the price to include currency
            this.price = result.data.fields.Price__c.value + ' ' + this.defaultCurrency;
            // Set selected value and name to that of the fetched record
            this.selectedValue = result.data.id;
            this.selectedName = this.searchValue;
        } else if (result.error) {
            this.showToast('Error', 'Error while retrieving book information', 'error');
        }
    }

    /*
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
    
    /*
     * Performs apex call of getting default currency
     */
    getCurrency() {
        getOrganizationDefaultCurrency().then((result) => {
            this.defaultCurrency = result;
        }).catch(() => {
            this.showToast('Error', 'Error while retrieving the organization currency', 'error'); 
        })
    }

    /*
     * Apex method that triggers every time searchValue is changed
     * Returns books which names correspond to searched value
     * @param searchValue - value in the input field
     */
    searchBooks(searchValue) {
        this.isPicklistLoading = true;
        searchValue = searchValue == null? '' : searchValue;
        searchDigitalBooks({ searchTerm: searchValue}).then((result) => {
            this.books = result;
            this.options = [];
            result.forEach(book => {
                this.options.push({
                    label: book.Name,
                    value: book.Id
                })
            })
            this.isPicklistLoading = false;
        }).catch(() => {
            this.showToast('Error', 'Error while retrieving user books information', 'error');
        })
    }

    /*
     * Catches event from comboboxAutoComplete component
     * @param event - Value of the picklist from ComboboxAutocomplete
     */
    handleSelectOption(event) {
        this.searchValue = event.currentTarget.dataset.label;
        this.selectedValue = event.currentTarget.dataset.value;
        this.books.forEach(book => {
            if (book.Id === this.selectedValue) {
                this.price = book.Price__c + ' ' + this.defaultCurrency;
            }
        })
        this.isOpen = false;
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
     * Sets the search value to the value of the input field
     * @param event - event propagated from ComboboxAutoComplete component that holds value of the input
     */
    handleSearch(event) {
        window.clearTimeout(this.delay)
        this.searchValue = event.detail.value;
        this.delay = setTimeout(() => {
            this.searchBooks(this.searchValue);
        }, 300);
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
        if (this.recordId) {
            const closeEvent = new CloseActionScreenEvent();
            this.dispatchEvent(closeEvent);
        } else {
            this.redirectToBookPage();
        }
    }

    /*
     * When clicked outside of input or picklist will close the picklist and unfocs input
     */
    handleOutsideClick(event) {
        if ((!this.isFocussed) && (this.isOpen)) { 
            //Fetch the dropdown DOM node
            let domElement = this.template.querySelector('div[data-id="resultBox"]');
            //Is the clicked element within the dropdown 
            if (domElement && !domElement.contains(event.target)) {
                this.isOpen = false;
            }
        }
    }

    /*
     * When input is focused sends event to parent container to filter based on what is in input field
     */
    handleFocus() {
        this.searchBooks(this.searchValue);
        this.isFocussed = true;
        this.isOpen = true;
    }

    /*
     * Handles onblur property by unfocusing
     */
    handleBlur() {
        this.isFocussed = false;
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

    /*
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